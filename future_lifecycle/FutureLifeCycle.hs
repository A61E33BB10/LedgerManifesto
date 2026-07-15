-- =============================================================================
-- FutureLifeCycle.hs  --  the listed-future lifecycle for The Ledger.
--
-- An incremental, types-first reference for one cash-settled listed future:
-- registration, trading, daily variation-margin settlement, expiry, and the
-- terminal flatten (Close). It is a sibling of
-- `addendum_rewrite/reference/StatesHome.hs` and reuses its disciplines (Qty as
-- an exact additive group; conservation as a monoid identity discharged by a
-- smart constructor; a monotone, abstract Ledger). It is grounded in
-- addendum_stateshome_v2.tex Sec.4.1, future_lifecycle/SETTLEMENT_SEED.md, and
-- future_lifecycle/WORKED_EXAMPLE_FUTURE.md; every figure in `main` reproduces
-- the verified worked example, NOW THROUGH THE TERMINAL CLOSE to
-- net=(0,0,0)/ac=(0,0,0).
--
-- The CENTREPIECE is the settlement handler (Sec.8). Daily variation margin is
-- ONE atomic event that (a) writes the shared settlement price ONCE on UnitStatus
-- and (b) fans out over the current holders, resetting each `accumulated_cost` to
-- -net_qty*S*multiplier and emitting a variation-margin cash leg. The per-wallet
-- cash is the CORRECT  VM(w) = net_qty(w)*S*multiplier + ac(w),  NOT the naive
-- net_qty*(S - S_prev)*mult, so an intraday trader settles correctly (the day-2
-- A = -100, not -300, in the worked example).
--
-- Derive then state: each abstraction is introduced at the step that forces it
-- and named only once it has earned its place. Read top to bottom.
--
-- No GHC is assumed in this environment; the file is verified by construction
-- against the worked example, not compiled.
-- =============================================================================

module FutureLifeCycle
  ( -- * Scalars: three distinct dimensions, two of them groups
    Qty (..), qneg
  , PosQty, mkPosQty, unPosQty   -- positive trade quantity (parse boundary, G5)
  , Cash (..), cashNeg
  , Price (..)
  , Day (..)
  , markValue
    -- * Keys
  , WalletId (..), UnitId (..)
    -- * ProductTerms (immutable) -- multiplier and the other contract terms
  , ProductTerms (..)
    -- * UnitStatus (shared) -- lifecycle stage with the settlement mark fused in
  , Stage (..), Settlement (..), UnitStatus (..)
  , stageOf, settlement, settlementPrice, settlementDate, stageRank, isExpired
    -- * PositionState (per (wallet,unit)) -- net_qty and accumulated_cost
  , PositionState (..), zeroP
    -- * Events
  , Event (..), eventUnit
    -- * Conservation (a monoid identity) and the atomic delta
  , Conserved (..), RowDelta (..), StateDelta (..)
  , ValidDelta                 -- abstract: only `validate` builds one
  , netDelta, validate
    -- * Handlers
  , handle
    -- * The ledger and its total operations
  , Ledger                     -- abstract: no row/status/cash deleter is exported
  , emptyLedger, register, applyDelta, step, replay
  , productTerms, unitStatus, position, cashOf
  , holdersOf
  , LedgerError (..)
    -- * Runnable worked example
  , main
  ) where

import           Control.Monad   (foldM, forM_)
import           Data.Map.Strict (Map)
import qualified Data.Map.Strict as Map

-- =============================================================================
-- 1. Scalars.  Three dimensions, kept apart on purpose.
--
--   Qty   -- a count of CONTRACTS.        Additive abelian group.
--   Cash  -- MONEY in minor units.        Additive abelian group. Shares ONE fixed
--                                          minor-unit scale with Price (see markValue).
--   Price -- a settlement/trade PRICE.    NOT a group: you never sum two prices,
--            nor move a price between wallets.
--
-- Why three types and not one `Integer`: the only multiplication in the whole
-- lifecycle, `net_qty * price * multiplier`, CONVERTS contracts into money. Giving
-- contracts, money, and price distinct types makes that conversion the only place
-- the dimensions cross, and makes the load-bearing line  VM = net_qty*S*mult + ac
-- typecheck only because both summands are `Cash`. A single `Integer` would let a
-- contract count be added to a cash amount silently -- the bug this separation
-- removes. (Price's lack of a Monoid instance is the same purchase the
-- states_simple thread already banked: a price can never be summed into a balance.)
-- =============================================================================

newtype Qty = Qty Integer deriving (Eq, Ord, Show)

instance Semigroup Qty where Qty a <> Qty b = Qty (a + b)
instance Monoid    Qty where mempty = Qty 0

qneg :: Qty -> Qty
qneg (Qty n) = Qty (negate n)

newtype Cash = Cash Integer deriving (Eq, Ord, Show)

instance Semigroup Cash where Cash a <> Cash b = Cash (a + b)
instance Monoid    Cash where mempty = Cash 0

cashNeg :: Cash -> Cash
cashNeg (Cash n) = Cash (negate n)

newtype Price = Price Integer deriving (Eq, Ord, Show)   -- deliberately NO Monoid

newtype Day = Day Int deriving (Eq, Ord, Show)

-- | The single dimension bridge: contracts at a price, scaled by the contract
--   multiplier, become money.  net_qty * S * multiplier.
--
-- SCALE INVARIANT. Price and Cash share ONE fixed minor-unit scale, chosen so that
-- q * s * multiplier lands in Cash's minor unit. The worked example carries Price in
-- whole index points and Cash in whole USD for readability -- markValue (Qty 10)
-- (Price 102) 50 = Cash 51000 reads as $51,000, NOT 51000 cents. A production scale
-- carries Price in scaled minor units (a quarter-point for ES, where a tick = $12.50;
-- a cent for a bond quoted in 32nds) so sub-point ticks are EXACT. The arithmetic is
-- integer and never divides, so the scale is free to fix and no rounding can break
-- conservation; only the comment's "minor units" and the example's scale must agree,
-- which this note pins.
markValue :: Qty -> Price -> Integer -> Cash
markValue (Qty q) (Price s) mult = Cash (q * s * mult)

-- Keys.
newtype WalletId = WalletId String deriving (Eq, Ord, Show)
newtype UnitId   = UnitId   String deriving (Eq, Ord, Show)

-- ---- GHCi -------------------------------------------------------------------
-- ghci> markValue (Qty 10) (Price 100) 50
-- Cash 50000
-- ghci> markValue (Qty (-10)) (Price 102) 50 <> Cash 51000   -- a Cash sum
-- Cash 0
-- ghci> Price 100 <> Price 102                                -- type error: Price has no <>
-- -----------------------------------------------------------------------------

-- =============================================================================
-- 2. ProductTerms -- IMMUTABLE contract terms, one per unit.
--
-- The CME-ES and ICE-ES contracts are DISTINCT units; the clearinghouse and
-- exchange are terms of the unit, not per-wallet fields. The lifecycle below
-- reads `ptMultiplier`; the rest are carried because the contract has them.
--
-- This file does NOT version terms (no NonEmpty / appendVersion as in
-- StatesHome): a listed future is not amended over its short life, so the
-- append-only versioning machinery would buy nothing here. A plain immutable
-- record with no setter is the minimum that suffices (Minimalism). If amendment
-- enters scope, lift `ProductTerms` to the StatesHome `NonEmpty TermsVersion`.
-- =============================================================================

data ProductTerms = ProductTerms
  { ptMultiplier    :: !Integer
  , ptCurrency      :: !String
  , ptExpiry        :: !Day
  , ptClearinghouse :: !String
  , ptExchange      :: !String
  , ptProductId     :: !String
  } deriving (Eq, Show)

-- =============================================================================
-- 3. UnitStatus -- the SHARED observable, one per unit.
--
-- It holds the lifecycle stage and the settlement mark (last_settlement_price,
-- last_settlement_date), read identically by every holder.
--
-- DERIVE then STATE. The addendum lists three fields:
--     lifecycle_stage  : REGISTERED | ACTIVE | EXPIRED
--     last_settlement_price : Maybe Price
--     last_settlement_date  : Maybe Day
-- A naive product  (Stage, Maybe Price, Maybe Day)  is representable but admits
-- two states that never occur:
--     (REGISTERED, Just p, _) -- a never-traded unit with a settlement price;
--     (EXPIRED,    Nothing, _) -- an expired unit with no final mark.
-- The first cannot arise (the mark is written only by settle/expire, which act on
-- a traded unit); the second cannot arise (expiry always carries a final mark).
--
-- FUSE the mark onto the stage so neither is spellable. The PURCHASE: two illegal
-- states removed, at the cost of one sum type. This is the states_simple R4 fuse
-- (`Active Price`) generalised to three stages with a (price,date) mark.
--
-- NOTE (terminology, settled in R1): the COARSE rank REGISTERED < ACTIVE < EXPIRED
-- is unchanged at a daily settle, while the EMBEDDED settlement mark
-- (`Active (Just (Settlement S d))`) is rewritten every settle. `last_settlement_*`
-- are projections of the `Settlement` carried by the stage (see `settlementPrice`).
-- =============================================================================

data Settlement = Settlement
  { settlePrice :: !Price
  , settleDate  :: !Day
  } deriving (Eq, Show)

data Stage
  = Registered                  -- recorded, never traded: no holders, no mark
  | Active (Maybe Settlement)   -- trading; Nothing = traded-not-yet-settled,
                                --          Just s  = marked at s
  | Expired Settlement          -- final mark ALWAYS present; absorbing (Sec.10)
  deriving (Eq, Show)

newtype UnitStatus = UnitStatus { usStage :: Stage } deriving (Eq, Show)

stageOf :: UnitStatus -> Stage
stageOf = usStage

-- | The mark carried by a stage, if any.  Total over all three stages.
settlement :: Stage -> Maybe Settlement
settlement Registered   = Nothing
settlement (Active m)   = m
settlement (Expired s)  = Just s

-- | Total accessors recovering the addendum's two mark fields. The `Maybe` is now
--   exactly the two reachable cases (un-marked vs marked), not a hole.
settlementPrice :: UnitStatus -> Maybe Price
settlementPrice = fmap settlePrice . settlement . usStage

settlementDate :: UnitStatus -> Maybe Day
settlementDate = fmap settleDate . settlement . usStage

-- | The lifecycle is MONOTONE: REGISTERED < ACTIVE < EXPIRED. The rank is the one
--   fact `applyDelta` needs to reject a stage that regresses (Sec.10); it never
--   regresses. EXPIRED is additionally ABSORBING -- see `isExpired`.
stageRank :: Stage -> Int
stageRank Registered  = 0
stageRank (Active _)  = 1
stageRank (Expired _) = 2

-- | EXPIRED is the absorbing terminal stage. Once a unit is EXPIRED no economic
--   event (Trade, SettleVM, Expire) may act on it: the daily mark is fixed and no
--   further variation-margin cash may move. `stageRank` alone is too weak for this
--   (rank does not separate Expired(105) from Expired(110), so a strict
--   `new < cur` guard would re-admit a second Expire); `isExpired` is the test
--   `applyDelta` and `handle` use to make EXPIRED truly absorbing (G2).
isExpired :: Stage -> Bool
isExpired (Expired _) = True
isExpired _           = False

-- | The default at registration: known to the ledger, never traded, no mark.
registeredStatus :: UnitStatus
registeredStatus = UnitStatus Registered

-- ---- GHCi -------------------------------------------------------------------
-- ghci> settlementPrice (UnitStatus Registered)
-- Nothing
-- ghci> settlementPrice (UnitStatus (Active (Just (Settlement (Price 102) (Day 1)))))
-- Just (Price 102)
-- ghci> settlementPrice (UnitStatus (Expired (Settlement (Price 105) (Day 3))))
-- Just (Price 105)
-- The states (Registered, Just p) and (Expired, Nothing) cannot be written.
-- -----------------------------------------------------------------------------

-- =============================================================================
-- 4. PositionState -- per (wallet, unit).
--
-- Two fields, the minimum the future needs:
--   psNetQty    -- signed contracts held; conserved (sum over holders = 0).
--   psAccumCost -- accumulated cost `ac`; conserved (sum over holders = 0).
-- `ac` is what makes each holder's variation margin correct when it trades
-- INTRADAY -- the load-bearing point of Sec.4.1 and the SEED. It is per (w,u):
-- two wallets holding the same contract carry different `ac`.
--
-- C1, the Option accessor (Sec.9, `position`): `Nothing` = never held; `Just
-- zeroP` = held and now flat. The two are never collapsed (settlement entitlement
-- and wash-sale lookback read the difference). C1, the monotone carrier: a row,
-- once created, is never deleted -- closed positions stay at zero (no PS deleter
-- is exported; `Ledger` is abstract). The terminal Close (Sec.8) drives every row
-- to zero by ADDITIVE delta, leaving the rows in place.
-- =============================================================================

data PositionState = PositionState
  { psNetQty    :: !Qty
  , psAccumCost :: !Cash
  } deriving (Eq, Show)

-- | The flat row created on first touch; also the held-and-flat baseline.
zeroP :: PositionState
zeroP = PositionState mempty mempty

-- =============================================================================
-- 5. Events -- the four lifecycle event classes for a listed future.
--
--   Trade    -- buyer/seller exchange `q` contracts at `p` (no upfront cash;
--               only `net_qty` and `ac` move). `q` is carried RAW in the alphabet
--               and PARSED positive at the handler (G5); q<=0 is rejected, never
--               recorded -- see Sec.7.
--   SettleVM -- daily variation-margin settlement at price `S` on day `d`.
--   Expire   -- final settlement at `S` on day `d`, then stage -> EXPIRED.
--   Close    -- terminal flatten: extinguish every holder's position against the
--               clearinghouse (net_qty -> 0, ac -> 0) with NO further cash. For a
--               cash-settled future the final VM at Expire already moved the
--               value; Close only returns the contracts and zeroes the books.
--
-- Close is the ONE event permitted on an EXPIRED unit (Sec.10): it carries no
-- stage write, so it does not violate the absorbing rule, while Trade/SettleVM/
-- Expire on an EXPIRED unit are rejected.
--
-- Each event names the unit it acts on (`eventUnit`).
-- =============================================================================

data Event
  = Trade    UnitId WalletId WalletId Qty Price   -- ^ buyer, seller, qty, price
  | SettleVM UnitId Price Day                      -- ^ settlement price, date
  | Expire   UnitId Price Day                      -- ^ final price, date
  | Close    UnitId                                -- ^ terminal flatten to zero
  deriving (Eq, Show)

eventUnit :: Event -> UnitId
eventUnit (Trade u _ _ _ _) = u
eventUnit (SettleVM u _ _)  = u
eventUnit (Expire u _ _)    = u
eventUnit (Close u)         = u

-- =============================================================================
-- 6. Conservation as a monoid identity, and the atomic StateDelta.
--
-- A StateDelta is the proposed change for ONE event across the maps it touches:
--   sdStage -- a replacement shared Stage, at most one write;
--   sdRows  -- per-holder ADDITIVE position deltas (net_qty and ac);
--   sdCash  -- per-holder variation-margin cash legs (a move on the cash unit).
--
-- Conservation (addendum C2): for every event class, each conserved quantity
-- sums to zero across wallets. Totalling a delta is a monoid homomorphism into
-- `Conserved`; "conserving" means the image is `mempty`. Stated in words first:
--   sum_w Δnet_qty = 0,  sum_w Δac = 0,  sum_w VM_cash = 0.
-- The categorical name comes last: a monoid homomorphism landing at the identity.
--
-- The zero-holder (vacuous) case (addendum C9) needs no special handling: a fold
-- over an empty map is `mempty`, i.e. conserved. No division by holder count ever
-- occurs -- we SUM deltas, never apportion -- so the dividend/len(holders) bug
-- class cannot arise.
-- =============================================================================

data Conserved = Conserved !Qty !Cash !Cash   -- (sum net_qty, sum ac, sum cash)
  deriving (Eq, Show)

instance Semigroup Conserved where
  Conserved a b c <> Conserved a' b' c' = Conserved (a <> a') (b <> b') (c <> c')
instance Monoid Conserved where
  mempty = Conserved mempty mempty mempty

data RowDelta = RowDelta { rdNetQty :: !Qty, rdAc :: !Cash } deriving (Eq, Show)

data StateDelta = StateDelta
  { sdUnit  :: UnitId
  , sdStage :: Maybe Stage
  , sdRows  :: Map WalletId RowDelta
  , sdCash  :: Map WalletId Cash
  } deriving (Show)

-- | The conserved image of a delta. `foldMap` over the row map sums the position
--   deltas; over the cash map sums the cash legs; the empty case is `mempty` (C9).
netDelta :: StateDelta -> Conserved
netDelta sd =
       foldMap (\(RowDelta nq ac) -> Conserved nq ac mempty) (sdRows sd)
    <> foldMap (\c               -> Conserved mempty mempty c) (sdCash sd)

-- | The C2 witness. ABSTRACT: the only constructor is `validate`, so an
--   unconserved delta cannot reach `applyDelta`.
newtype ValidDelta = ValidDelta StateDelta

-- | Discharge conservation: the conserved image must be the identity.
validate :: StateDelta -> Either LedgerError ValidDelta
validate sd
  | net == mempty = Right (ValidDelta sd)
  | otherwise     = Left (NotConserved (sdUnit sd) net)
  where net = netDelta sd

-- =============================================================================
-- 7. The Trade handler.
--
-- A trade of `q` contracts at price `p` (multiplier `m`):
--   net_qty : buyer +q, seller -q                                  (sums to 0)
--   ac      : each leg  ac += -Δsigned_qty * p * m                 (sums to 0)
--             buyer  Δsigned = +q  =>  ac += -(q*p*m)
--             seller Δsigned = -q  =>  ac += +(q*p*m)
--   stage   : REGISTERED -> ACTIVE on first trade; an existing settlement mark is
--             preserved (a trade must never wipe the shared price).
-- No cash leg: entering a futures position pays no notional.
--
-- `activateTrade` keeps any mark already on the stage. A trade on an EXPIRED unit
-- never reaches here -- `handle` rejects it (G2) before a delta is built.
--
-- POSITIVITY (G5). A trade leg carries a POSITIVE quantity; q<=0 is not a trade:
--   q = 0  would promote REGISTERED->ACTIVE and create `Just zeroP` rows for the
--          buyer and seller -- two NEVER-HELD wallets reading as held-and-flat,
--          collapsing the very never-held/held-flat distinction `position` certifies
--          (Sec.4, C1), and silently activating a unit that never traded (against
--          G4's own ground).
--   q < 0  conserves but SWAPS the buyer/seller roles, violating the move
--          primitive's positivity invariant.
-- Positivity is refined at the BOUNDARY, the same shape as conservation (E3): the
-- Event alphabet carries a raw `Qty` (the unparsed input of the free monoid),
-- `handle` PARSES it ONCE into `PosQty`, and `tradeDelta` plus everything downstream
-- accept only the parsed evidence -- so q<=0 is unrepresentable in the core.
-- `PosQty` is abstract (`mkPosQty` is its sole constructor), so the positive cone
-- cannot be re-entered with a bad value. Parse, don't validate.
-- =============================================================================

newtype PosQty = PosQty Qty deriving (Eq, Ord, Show)   -- abstract: mkPosQty only

-- | The sole constructor of the positive cone. Positivity of an arbitrary integer
--   is a VALUE-level fact (like conservation), so this is a parse boundary, not a
--   free type fact: `Nothing` exactly when q <= 0.
mkPosQty :: Qty -> Maybe PosQty
mkPosQty q@(Qty n)
  | n > 0     = Just (PosQty q)
  | otherwise = Nothing

unPosQty :: PosQty -> Qty
unPosQty (PosQty q) = q

activateTrade :: Stage -> Stage
activateTrade cur = Active (settlement cur)

tradeDelta :: UnitId -> Stage -> Integer -> WalletId -> WalletId -> PosQty -> Price -> StateDelta
tradeDelta u cur m buyer seller pq p = StateDelta
  { sdUnit  = u
  , sdStage = Just (activateTrade cur)
  , sdRows  = Map.fromList
      [ (buyer , RowDelta q        (cashNeg (markValue q p m)))   -- ac += -(q*p*m)
      , (seller, RowDelta (qneg q) (markValue q p m))             -- ac += +(q*p*m)
      ]
  , sdCash  = Map.empty
  }
  where q = unPosQty pq

-- =============================================================================
-- 8. The settlement fan-out (shared by SettleVM and Expire) and the Close flatten.
--
-- SETTLEMENT. For each current holder at settlement price `S`, multiplier `m`:
--   target = -net_qty * S * m            -- the reset value of ac
--   Δac    = target - ac                 -- additive delta written to the row
--   VM     = -Δac  =  net_qty*S*m + ac    -- the CORRECT per-wallet cash leg
--
-- The third line is the centrepiece identity. VM is the CORRECT
--   VM(w) = net_qty(w)*S*m + ac(w),
-- NOT the naive net_qty*(S - S_prev)*m, because `ac` has already absorbed any
-- intraday trades since the last settle. And VM = -Δac exactly, so the cash leg
-- is the mirror of the change in accumulated cost. Therefore
--   sum_w VM = -sum_w Δac = 0  whenever sum_w Δac = 0:
-- variation-margin cash conservation is the SAME fact as ac conservation, not a
-- separate runtime reconciliation. (`validate` still checks both sums; for trades
-- they are independent -- a trade has Δac /= 0 with no cash -- so the cash check
-- is not redundant in general.)
--
-- A holder that is flat (net_qty = 0, ac = 0) yields Δac = 0 and VM = 0: settling
-- touches its retained row to no effect. A unit with no holders settles vacuously
-- -- the shared price still updates, no cash moves (empty fan-out, C9).
--
-- CLOSE. The terminal flatten extinguishes every holder's position against the
-- clearinghouse: Δnet_qty = -net_qty, Δac = -ac, NO cash. For cash settlement the
-- value already moved at the final settle (Expire), so Close returns the contracts
-- and zeroes the books with zero further money. It conserves trivially because the
-- holders' net_qty and ac each already sum to zero, so their negations do too:
--   sum_w Δnet_qty = -sum_w net_qty = 0,   sum_w Δac = -sum_w ac = 0,   sum VM = 0.
-- The clearinghouse leg is the residual of the holder legs -- zero here -- so no CH
-- row materialises (signal E1). Rows are retained at zero (monotone carrier).
-- =============================================================================

settlementFanout :: Price -> Integer -> [(WalletId, PositionState)]
                 -> (Map WalletId RowDelta, Map WalletId Cash)
settlementFanout s m holders =
    ( Map.fromList [ (w, RowDelta mempty (deltaAc ps)) | (w, ps) <- holders ]
    , Map.fromList [ (w, cashNeg (deltaAc ps))         | (w, ps) <- holders ]
    )
  where
    -- Δac = target - ac  where target = -(net_qty * S * m)
    deltaAc ps = cashNeg (markValue (psNetQty ps) s m) <> cashNeg (psAccumCost ps)

-- | The terminal flatten delta. NO stage write (the unit stays EXPIRED, so Close
--   does not breach the absorbing rule); NO cash; every row driven to zero by an
--   additive negation of its current value.
closeDelta :: UnitId -> [(WalletId, PositionState)] -> StateDelta
closeDelta u holders = StateDelta
  { sdUnit  = u
  , sdStage = Nothing
  , sdRows  = Map.fromList
      [ (w, RowDelta (qneg (psNetQty ps)) (cashNeg (psAccumCost ps))) | (w, ps) <- holders ]
  , sdCash  = Map.empty
  }

-- =============================================================================
-- 9. The event dispatcher: Event -> current Ledger -> StateDelta.
--
-- Settlement, expiry, and close depend on the CURRENT holders and their `ac`; the
-- trade's stage write depends on the current stage. So a handler is a pure
-- function of the ledger and the event (deterministic), not a constant delta.
--
-- The stage-legality guards live here, stated once per event, as RUNTIME checks
-- (signal E2 -- legality depends on runtime stage, not a type fact):
--   * Trade    -- self-trade rejected (G3); rejected on an EXPIRED unit (G2);
--                 quantity PARSED positive (G5: q<=0 -> NonPositiveQty, so q=0
--                 cannot fabricate held-flat rows and q<0 cannot swap roles).
--   * SettleVM -- rejected before the first trade, i.e. on REGISTERED (G4: a
--                 settle must not silently promote a never-traded unit to ACTIVE,
--                 and REGISTERED has no mark slot to update); rejected on EXPIRED.
--   * Expire   -- rejected on an already-EXPIRED unit (G2, idempotency); ALSO
--                 rejected on REGISTERED (G4, SYMMETRIC with SettleVM, settled R3):
--                 a never-traded unit has no position and no mark slot, so expiring
--                 it would fabricate a final mark with no economic content. EXPIRED
--                 is therefore reachable ONLY from ACTIVE -- the lifecycle is the
--                 linear chain REGISTERED -> ACTIVE -> EXPIRED with no skips.
--   * Close    -- permitted ONLY on an EXPIRED unit (you cannot flatten before
--                 expiry); it is the single transition allowed within EXPIRED.
-- An event naming an unregistered unit is `Left (UnknownUnit u)`; because terms
-- and status are co-registered in one map, that lookup is exhaustive.
-- =============================================================================

handle :: Event -> Ledger -> Either LedgerError StateDelta
handle ev l =
  case Map.lookup u (ledgerUnits l) of
    Nothing            -> Left (UnknownUnit u)
    Just (terms, us)   ->
      let m   = ptMultiplier terms
          cur = usStage us
      in case ev of
           Trade _ buyer seller q p
             | buyer == seller -> Left (SelfTrade u buyer)              -- G3
             | isExpired cur   -> Left (UnitExpired u)                  -- G2
             | otherwise       -> case mkPosQty q of                    -- G5: parse
                 Nothing -> Left (NonPositiveQty u q)
                 Just pq -> Right (tradeDelta u cur m buyer seller pq p)

           SettleVM _ s d -> case cur of
             Expired _  -> Left (UnitExpired u)                          -- G2
             Registered -> Left (NotActive u)                            -- G4
             Active _   ->
               let (rows, cash) = settlementFanout s m (holdersOf u l)
               in Right (StateDelta u (Just (Active (Just (Settlement s d)))) rows cash)

           Expire _ s d -> case cur of
             Expired _  -> Left (UnitExpired u)                          -- G2
             Registered -> Left (NotActive u)                            -- G4 (symmetric)
             Active _   ->
               let (rows, cash) = settlementFanout s m (holdersOf u l)
               in Right (StateDelta u (Just (Expired (Settlement s d))) rows cash)

           Close _ -> case cur of
             Expired _ -> Right (closeDelta u (holdersOf u l))           -- G1
             _         -> Left (NotExpired u)
  where u = eventUnit ev

-- =============================================================================
-- 10. The ledger and its total operations.
--
-- ABSTRACT: no field setter, row/status/cash deleter is exported. The only way to
-- change PositionState or cash is `applyDelta`, which inserts/updates and NEVER
-- deletes. That absence IS the monotone-carrier discipline (C1, storage half).
--
-- Terms and status are FUSED into one `Map UnitId (ProductTerms, UnitStatus)` so
-- that "u in terms <=> u in status" is a type fact, not a `register`-boundary
-- convention: the desynchronised state (one map has `u`, the other does not) is
-- now unrepresentable, and the `handle`/`applyDelta` lookups are exhaustive on
-- `Maybe (ProductTerms, UnitStatus)` rather than collapsing asymmetric cases.
--
-- EXPIRED is absorbing: `applyDelta` rejects ANY stage-writing delta when the
-- current stage is EXPIRED (G2). Close carries no stage write, so it is the one
-- delta that may still be applied to an EXPIRED unit.
-- =============================================================================

data Ledger = Ledger
  { ledgerUnits :: Map UnitId (ProductTerms, UnitStatus)
  , ledgerPos   :: Map (WalletId, UnitId) PositionState
  , ledgerCash  :: Map WalletId Cash          -- VM cash accumulated (see E1)
  }

data LedgerError
  = ReRegistration  UnitId
  | UnknownUnit     UnitId
  | StageRegression UnitId Stage Stage          -- unit, current, proposed
  | NotConserved    UnitId Conserved
  | UnitExpired     UnitId                       -- economic event on an EXPIRED unit (G2)
  | NotActive       UnitId                       -- settle before the first trade (G4)
  | NotExpired      UnitId                       -- close before expiry (G1)
  | SelfTrade       UnitId WalletId              -- buyer == seller (G3)
  | NonPositiveQty  UnitId Qty                   -- trade quantity q <= 0 (G5)
  deriving (Eq, Show)

emptyLedger :: Ledger
emptyLedger = Ledger Map.empty Map.empty Map.empty

-- | Registration writes terms AND status as one tuple, establishing
--   "u in terms <=> u in status" by construction. Re-registration is a hard
--   error, never a silent reset.
register :: UnitId -> ProductTerms -> Ledger -> Either LedgerError Ledger
register u terms l
  | u `Map.member` ledgerUnits l = Left (ReRegistration u)
  | otherwise = Right l
      { ledgerUnits = Map.insert u (terms, registeredStatus) (ledgerUnits l) }

-- | Apply a conservation-validated event. Total, atomic, monotone. Failure modes:
--   an unregistered unit (UnknownUnit); a stage regression -- a proposed stage of
--   strictly lower rank than the current one (StageRegression); and a stage write
--   on an EXPIRED unit (UnitExpired) -- EXPIRED is absorbing, so re-expiry and
--   post-expiry re-settles are rejected even though they would conserve. A bare
--   `<=` would be wrong: it would also reject the intended ACTIVE->ACTIVE daily
--   re-settle (same rank). The `isExpired` test is the precise absorbing rule.
--   Close carries `sdStage = Nothing`, so it bypasses the stage guards and is the
--   one delta still applicable to an EXPIRED unit. Rows and cash are
--   inserted/updated, never removed.
applyDelta :: ValidDelta -> Ledger -> Either LedgerError Ledger
applyDelta (ValidDelta sd) l
  | not (u `Map.member` ledgerUnits l) = Left (UnknownUnit u)
  | otherwise = case sdStage sd of
      Nothing  -> Right written
      Just new
        | isExpired cur                 -> Left (UnitExpired u)          -- G2: absorbing
        | stageRank new < stageRank cur -> Left (StageRegression u cur new)
        | otherwise -> Right written
            { ledgerUnits = Map.adjust (\(t, _) -> (t, UnitStatus new)) u (ledgerUnits l) }
  where
    u   = sdUnit sd
    cur = maybe Registered (usStage . snd) (Map.lookup u (ledgerUnits l))
    written = l
      { ledgerPos  = Map.foldrWithKey applyRow (ledgerPos l) (sdRows sd)
      , ledgerCash = Map.foldrWithKey (\w c -> Map.insertWith (<>) w c)
                                      (ledgerCash l) (sdCash sd)
      }
    applyRow w (RowDelta dnq dac) m =
      let key = (w, u)
          p0  = Map.findWithDefault zeroP key m        -- first touch -> flat row
          p1  = p0 { psNetQty    = psNetQty    p0 <> dnq
                   , psAccumCost = psAccumCost p0 <> dac }
      in Map.insert key p1 m                            -- insert/update only

-- | One event end to end: handle (read state) -> validate (conservation) -> apply.
step :: Event -> Ledger -> Either LedgerError Ledger
step ev l = do
  sd <- handle ev l
  vd <- validate sd
  applyDelta vd l

-- | Replay = a Kleisli fold of the event stream over the ledger in
--   `Either LedgerError`. Determinism (P3) is the Kleisli homomorphism law:
--       replay (xs <> ys) = replay xs >=> replay ys
--   so the result is independent of where a checkpoint is cut -- checkpoint
--   independence is a CONSEQUENCE of the law, not a test. The monotone carrier
--   keeps the key set stable across cuts.
--
--   BOUNDARY ASSUMPTION (dedup). The stream is assumed UNIQUE -- de-duplicated at
--   ingestion by an event key -- because the two event kinds differ in idempotency:
--   a duplicated SettleVM at a fixed mark is inert (Δac = 0, VM = 0, Sec.8), but a
--   duplicated Trade accumulates a SECOND position delta via applyDelta's
--   Map.insertWith (<>). Duplicate suppression is a boundary obligation, not a
--   ledger function.
replay :: [Event] -> Ledger -> Either LedgerError Ledger
replay evs l0 = foldM (flip step) l0 evs

-- Accessors. Total. `position` is the C1 Option accessor (never-held vs flat).
productTerms :: Ledger -> UnitId -> Maybe ProductTerms
productTerms l u = fst <$> Map.lookup u (ledgerUnits l)

unitStatus :: Ledger -> UnitId -> Maybe UnitStatus
unitStatus l u = snd <$> Map.lookup u (ledgerUnits l)

position :: Ledger -> WalletId -> UnitId -> Maybe PositionState
position l w u = Map.lookup (w, u) (ledgerPos l)

cashOf :: Ledger -> WalletId -> Cash
cashOf l w = Map.findWithDefault mempty w (ledgerCash l)

-- | Current holders of a unit: every wallet with a row, including flat ones.
holdersOf :: UnitId -> Ledger -> [(WalletId, PositionState)]
holdersOf u l = [ (w, ps) | ((w, u'), ps) <- Map.toList (ledgerPos l), u' == u ]

-- =============================================================================
-- EXPRESSIBILITY SIGNALS  (recorded, not contorted around)
-- -----------------------------------------------------------------------------
-- [E1] Settlement is intrinsically a TWO-UNIT event. The future side (net_qty,
--      ac, shared stage) is modelled fully; the cash leg is a move on a SEPARATE
--      unit -- the settlement currency. This file summarises that side as
--      `sdCash :: Map WalletId Cash` and a `ledgerCash :: Map WalletId Cash`,
--      rather than as PositionState rows on a cash unit with a clearinghouse
--      counterpart leg. The faithful multi-unit encoding makes cash a first-class
--      unit, keyed (wallet, cashUnit), with a CH leg that absorbs the residual
--      (here zero, since the holder legs already sum to zero); the single-future
--      StateDelta is then the future-unit slice of a multi-unit atomic event.
--      This is the same cross-unit point as StatesHome signal S1: state
--      conservation is per unit; an event spanning two units is two per-unit
--      zero-sum slices applied atomically. POINTS AT: the DESIGN (multi-unit
--      atomic events), not this encoding.
--
-- [E2] Stage-transition legality (no trade/settle/expire after expiry; no settle
--      before the first trade; close only after expiry) is a RUNTIME guard -- the
--      `isExpired`/stage cases in `handle` and the absorbing check in `applyDelta`
--      -- not a type fact. It depends on the current stage, which is runtime data;
--      a type that forbade it would have to index the Ledger by each unit's stage,
--      which buys nothing here. The type DOES make unrepresentable the two STATE
--      illegalities the fuse removes (REGISTERED-with-price, EXPIRED-without-mark,
--      Sec.3) and the terms/status desync (Sec.10 fused map); it does not make
--      unrepresentable an illegal TRANSITION. POINTS AT: a DESIGN TRADEOFF
--      (restraint rule) -- stop at the cheaper value-level guard.
--
-- [E3] Conservation cannot be a pure TYPE fact (sums of exact integers are a
--      value-level property; a refinement type on a sum is not free in any
--      production language). The smart constructor `validate -> ValidDelta`
--      (returning `Either`) is the correct boundary: the type makes the UNCHECKED
--      delta unable to reach `applyDelta`; the check itself is a one-line monoid
--      identity. This is StatesHome signal S4. The bonus here: VM = -Δac, so
--      cash conservation for settle/expire is the SAME fact as ac conservation,
--      surfaced rather than reconciled; and the Close flatten conserves because it
--      negates two columns that already sum to zero. Trade-quantity positivity (G5)
--      has the SAME boundary shape: the Event alphabet carries a raw `Qty`, `handle`
--      parses it once into the abstract `PosQty`, and the core (`tradeDelta`) accepts
--      only the evidence -- so q<=0 is unrepresentable downstream of the boundary,
--      exactly as an unconserved delta is unable to reach `applyDelta`.
--
-- [E4] The settlement and close handlers read the CURRENT holders and their `ac`
--      to compute each reset, so they are functions of the ledger, not constant
--      deltas. They are genuinely state-dependent; determinism is preserved
--      because each handler is a pure function of (event, ledger). POINTS AT:
--      nothing to fix -- recorded so the state-dependence is not mistaken for
--      impurity.
-- =============================================================================

-- =============================================================================
-- Runnable worked example.  `runghc FutureLifeCycle.hs` (no GHC in this env; the
-- figures are hand-verified against WORKED_EXAMPLE_FUTURE.md). One cash-settled
-- listed future, multiplier 50, wallets A B C. Conservation is asserted after
-- EVERY step: sum_w net_qty = 0, sum_w ac = 0, and sum_w cumulative VM cash = 0.
-- The life runs through the terminal Close to net=(0,0,0)/ac=(0,0,0).
-- =============================================================================

expect :: Show e => Either e a -> IO a
expect = either (\e -> error ("unexpected Left: " <> show e)) pure

assertZero :: String -> Cash -> IO ()
assertZero label c
  | c == mempty = putStrLn ("   conserved: " <> label <> " = 0")
  | otherwise   = error ("CONSERVATION VIOLATED: " <> label <> " = " <> show c)

assertZeroQty :: String -> Qty -> IO ()
assertZeroQty label q
  | q == mempty = putStrLn ("   conserved: " <> label <> " = 0")
  | otherwise   = error ("CONSERVATION VIOLATED: " <> label <> " = " <> show q)

sumNet :: UnitId -> Ledger -> Qty
sumNet u l = mconcat [ psNetQty ps | (_, ps) <- holdersOf u l ]

sumAc :: UnitId -> Ledger -> Cash
sumAc u l = mconcat [ psAccumCost ps | (_, ps) <- holdersOf u l ]

sumCash :: Ledger -> Cash
sumCash l = mconcat (Map.elems (ledgerCash l))

-- The naive (WRONG) formula, shown only for contrast. NOT exported, NOT used to
-- move money: net_qty*(S - S_prev)*mult. For an intraday trader it disagrees with
-- the correct VM = net_qty*S*mult + ac.
naiveVM :: Qty -> Price -> Price -> Integer -> Cash
naiveVM (Qty q) (Price sPrev) (Price s) mult = Cash (q * (s - sPrev) * mult)

main :: IO ()
main = do
  let uF = UnitId "ES-FUT"
      a  = WalletId "A"; b = WalletId "B"; c = WalletId "C"
      terms = ProductTerms
        { ptMultiplier = 50, ptCurrency = "USD", ptExpiry = Day 3
        , ptClearinghouse = "CME-CH", ptExchange = "CME", ptProductId = "ES" }

  putStrLn "== Listing: register the future (stage REGISTERED, no mark) =="
  l0 <- expect $ register uF terms emptyLedger
  print (unitStatus l0 uF)          -- Just (UnitStatus {usStage = Registered})
  print (position l0 a uF)          -- Nothing : never held

  let report tag l = do
        putStrLn ("-- after " <> tag)
        print (usStage <$> unitStatus l uF)
        forM_ [a, b, c] $ \w -> putStrLn ("   " <> show w <> " " <>
          show (position l w uF) <> "  cumVM=" <> show (cashOf l w))
        assertZeroQty ("sum net_qty") (sumNet uF l)
        assertZero    ("sum ac")      (sumAc uF l)
        assertZero    ("sum cumVM")   (sumCash l)

  putStrLn "== T1: A buys 10 from B @100 =="
  l1 <- expect $ step (Trade uF a b (Qty 10) (Price 100)) l0
  report "T1" l1
  -- A net_qty=10 ac=-50000 ; B net_qty=-10 ac=+50000 ; stage Active Nothing

  putStrLn "== Settle d1: S=102 (the centrepiece, vacuous over non-holder C) =="
  l2 <- expect $ step (SettleVM uF (Price 102) (Day 1)) l1
  report "Settle d1" l2
  -- ac -> (-51000,+51000) ; VM -> (+1000,-1000) ; stage Active (Just 102@d1)

  putStrLn "== T2: C buys 4 from A @103 (A trades INTRADAY) =="
  l3 <- expect $ step (Trade uF c a (Qty 4) (Price 103)) l2
  report "T2" l3
  -- net (6,-10,4) ; ac (-30400,+51000,-20600)

  putStrLn "== Settle d2: S=101 -- A's VM is -100, NOT the naive -300 =="
  -- Show the per-wallet legs the settlement handler computes, before applying:
  sd2 <- expect $ handle (SettleVM uF (Price 101) (Day 2)) l3
  putStrLn ("   VM legs (correct): " <> show (sdCash sd2))
  putStrLn ("   A correct VM = net_qty*S*m + ac = 6*101*50 + (-30400) = "
            <> show (Map.lookup a (sdCash sd2)))             -- Just (Cash (-100))
  putStrLn ("   A naive   VM = net_qty*(S-S_prev)*m = 6*(101-102)*50 = "
            <> show (naiveVM (Qty 6) (Price 102) (Price 101) 50))  -- Cash (-300)  WRONG
  l4 <- expect $ step (SettleVM uF (Price 101) (Day 2)) l3
  report "Settle d2" l4
  -- ac (-30300,+50500,-20200) ; VM (-100,+500,-400)

  putStrLn "== T3: B buys 4 from C @101 (C -> flat, row RETAINED) =="
  l5 <- expect $ step (Trade uF b c (Qty 4) (Price 101)) l4
  report "T3" l5
  -- net (6,-6,0) ; ac (-30300,+30300,0) ; C is Just (flat), not Nothing

  putStrLn "== Expiry: final S=105, fan-out, stage -> EXPIRED =="
  l6 <- expect $ step (Expire uF (Price 105) (Day 3)) l5
  report "Expiry" l6
  -- ac (-31500,+31500,0) ; VM step (+1200,-1200,0) ; stage Expired (105@d3)

  putStrLn "== Close: flatten against CH, zero cash, net & ac -> 0 (rows retained) =="
  -- Show the per-wallet flatten legs before applying: Δnet (-6,+6,0), Δac (+31500,-31500,0).
  sdC <- expect $ handle (Close uF) l6
  putStrLn ("   Close rows (Δnet_qty, Δac): " <> show (sdRows sdC))
  putStrLn ("   Close cash legs (none): "     <> show (sdCash sdC))
  l7 <- expect $ step (Close uF) l6
  report "Close" l7
  -- net (0,0,0) ; ac (0,0,0) ; cumVM unchanged (Close moves no cash) ; stage Expired

  putStrLn "== Closing identity: cumulative VM = economic PnL (sum = 0) =="
  -- A=+2100, B=-1700, C=-400, and they sum to zero.
  print (cashOf l7 a, cashOf l7 b, cashOf l7 c)   -- (Cash 2100, Cash (-1700), Cash (-400))
  assertZero "sum cumVM (final)" (sumCash l7)

  putStrLn "== Stage guards (shown, not asserted) =="
  putStrLn "   post-expiry trade is REJECTED (EXPIRED is absorbing, G2):"
  case step (Trade uF a b (Qty 1) (Price 106)) l7 of
    Left e  -> print e   -- UnitExpired (UnitId "ES-FUT")
    Right _ -> error "post-expiry trade should have been rejected"
  putStrLn "   re-expiry is REJECTED (EXPIRED is absorbing, G2):"
  case step (Expire uF (Price 110) (Day 4)) l7 of
    Left e  -> print e   -- UnitExpired (UnitId "ES-FUT")
    Right _ -> error "re-expiry should have been rejected"
  putStrLn "   settle before first trade is REJECTED (REGISTERED, G4):"
  case step (SettleVM uF (Price 100) (Day 0)) l0 of
    Left e  -> print e   -- NotActive (UnitId "ES-FUT")
    Right _ -> error "settling a never-traded unit should have been rejected"
  putStrLn "   expire before first trade is REJECTED (REGISTERED, G4 symmetric):"
  case step (Expire uF (Price 100) (Day 0)) l0 of
    Left e  -> print e   -- NotActive (UnitId "ES-FUT")
    Right _ -> error "expiring a never-traded unit should have been rejected"
  putStrLn "   zero-quantity trade is REJECTED (G5, parse boundary):"
  case step (Trade uF a b (Qty 0) (Price 100)) l0 of
    Left e  -> print e   -- NonPositiveQty (UnitId "ES-FUT") (Qty 0)
    Right _ -> error "a non-positive-quantity trade should have been rejected"
  putStrLn "   negative-quantity trade is REJECTED (G5, no role swap):"
  case step (Trade uF a b (Qty (-5)) (Price 100)) l0 of
    Left e  -> print e   -- NonPositiveQty (UnitId "ES-FUT") (Qty (-5))
    Right _ -> error "a negative-quantity trade should have been rejected"
  putStrLn "   self-trade is REJECTED with a clear diagnostic (G3):"
  case step (Trade uF a a (Qty 5) (Price 100)) l0 of
    Left e  -> print e   -- SelfTrade (UnitId "ES-FUT") (WalletId "A")
    Right _ -> error "self-trade should have been rejected"
  putStrLn "   close before expiry is REJECTED (G1):"
  case step (Close uF) l1 of
    Left e  -> print e   -- NotExpired (UnitId "ES-FUT")
    Right _ -> error "close before expiry should have been rejected"

  putStrLn "== Replay reproduces the same final ledger (checkpoint independence) =="
  l7' <- expect $ replay
           [ Trade uF a b (Qty 10) (Price 100)
           , SettleVM uF (Price 102) (Day 1)
           , Trade uF c a (Qty 4) (Price 103)
           , SettleVM uF (Price 101) (Day 2)
           , Trade uF b c (Qty 4) (Price 101)
           , Expire uF (Price 105) (Day 3)
           , Close uF
           ] l0
  print ( sumNet uF l7' == mempty
       && sumAc  uF l7' == mempty
       && sumCash l7'   == mempty )                          -- True
