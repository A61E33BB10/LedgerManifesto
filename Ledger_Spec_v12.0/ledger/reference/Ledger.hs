{-# LANGUAGE GADTs              #-}
{-# LANGUAGE DataKinds          #-}
{-# LANGUAGE KindSignatures     #-}
{-# LANGUAGE StandaloneDeriving #-}

-- =============================================================================
-- Ledger.hs  --  The Ledger, consolidated reference implementation.
--
-- This is the RUNNABLE WHOLE. The per-section .tex listings are excerpts of it;
-- here every concept used by the specification is defined exactly once, in one
-- module, total and deterministic, with illegal states made unrepresentable.
--
-- Consolidation decisions (Minimalism: resolve duplicates; one primitive per
-- concept). The per-section snippets each redefined the shared vocabulary so they
-- could load standalone; the duplicates are collapsed here:
--
--   * Scalars (Qty, Cash, Price, Quote, keys) are defined ONCE (Part A). Qty is
--     the additive abelian group of exact Integer minor units -- never Float:
--     conservation and deterministic replay are arithmetic facts a float forfeits.
--
--   * The CANONICAL CORE (Part C) is the three-home model of section 4:
--     ProductTerms / UnitStatus /
--     PositionState, the one atomic `Transaction` (its conserved flow carried as
--     `Move` edges, so conservation holds by construction), replay as a fold
--     homomorphism. Sections 3, 9 and 15 are subsets of it and add nothing new to
--     the runnable whole; section 7's "general lifecycle core" is the same shape
--     with a poorer alphabet and is realised concretely by the futures engine
--     (Part K), so it is not re-derived here.
--
--   * The §2 closed-ledger `applyMove`/`balance`/(Map-of-Maps `Ledger`) projection
--     is restated as the §10 `Balances` monoid (Part B), the same projection
--     written once as `foldMap`. The §2 Move algebra (conservation) and
--     §10 balance projection are both kept.
--
--   * Genuinely distinct subsystems keep distinct names so the whole compiles
--     with no shadowing: §9's fee record (Part D) is `FeeEvent`, to avoid
--     colliding with the Handler constructor `FeeCrystallise` / the promoted
--     index 'FeeCrystallise; the settlement boundary (Part H) names its move
--     `SettleMove` and its transaction `SettlementTx`; the CDM layer (Part I) uses
--     `CdmTransaction`; the futures engine (Part K) is `Fut*`-prefixed; the
--     obligation handler (Part J) is `ob*`-prefixed; the property oracles
--     (Part L) use `OracleTx`. Each rename is noted against its section.
--
-- Abstractness is load-bearing and enforced by the export list:
--   * `Ledger` / `FutLedger` are exported WITHOUT constructors or field setters,
--     so no caller can delete a PositionState row -> monotone carrier (C1).
--   * The core `Transaction` carries its conserved flow as `Move` edges (each
--     debits one wallet and credits another by the same magnitude), so its
--     balance conservation holds BY CONSTRUCTION: the signed per-unit sum is
--     mempty, the empty/registration case included. There is no unconserved event
--     to gate -- no `validate` door is needed, and none is representable (C2).
--     `FutValidDelta` keeps its abstract `futValidate` door for the futures
--     conserved triple (net, ac, cash), which is not edge-shaped.
--   * `ProductTerms` is exported WITHOUT its constructor, growth only via
--     `register` (singleton) / `appendVersion` (append) -> append-only (C6).
--   * `PosQty` is exported WITHOUT its constructor, built only by `mkPosQty`.
-- =============================================================================

module Ledger
  ( -- * Part A -- shared scalars (an additive abelian group; exact minor units)
    Qty (..), qneg, negQty, qmax
  , Cash (..), cashNeg, cashSub
  , Price (..), Quote (..)
  , WalletId (..), UnitId (..), Timestamp (..), SourceId (..)
    -- * Part B -- the economic Move, conservation (§2) and balances (§10)
  , Move (..), move
  , Balances (..), contribution, balances, netBal
    -- * Part C -- ProductTerms (§4): immutable, versioned, append-only (C6/C7)
  , TermsVersion (..), ProductTerms, currentTerms, allVersions, appendVersion
    -- * Part C -- UnitStatus (§4): the shared observable, a projection of the log
  , Lifecycle (..), UnitStatus (..), defaultStatus
  , StatusWrite (..), applyStatus
    -- * Part C -- per-field canonical-writer table (C11), a type-level relation
  , Handler (..), FieldWrite (..), SomeWrite (..)
  , applyWrite, settleHandler, erase
    -- * Part C -- PositionState (§4): Option accessor + monotone carrier (C1)
  , PositionState (..), zeroP
    -- * Part C -- the ONE atomic event: moves (edges) + state delta (C2/C3)
  , Transaction (..), unitDelta, netDelta
  , registerTx, appendTx, supersedeTx
    -- * Part C -- the ledger and its total operations
  , Ledger, emptyLedger, register, applyTx, replay
  , productTerms, unitStatus, position, LedgerError (..)
    -- * Part C -- two-track amendment (C8)
  , Fungibility (..), FungibilityPredicate, AmendResult (..), amend
    -- * Part D -- fee crystallisation and issuance moves (§9)
  , usd, moveDelta, issueMandate, crystallise
  , FeeEvent (..), crystalliseFees
    -- * Part E -- valuation and PnL (§5)
  , PriceVec (..), Portfolio, mkPortfolio, Snapshot (..), markValue, value, pnl
    -- * Part F -- state-aware pricing (App. D)
  , Distribution (..), Market (..), statePrice
    -- * Part G -- generalised positions and SBL (§16)
  , Position (..), zeroPos, avail, possess, encumb, Coord (..), applyMove
    -- * Part H -- the settlement-layer interface (§12)
  , Day (..), TxId (..), ISIN (..), Currency (..), LEI (..), MIC (..)
  , Asset (..), SettleMove (..), TxClass (..), settles
  , CdmPayload (..), SettlementTx (..)
  , SecuritiesLeg (..), CashLeg (..)
  , SettlementLegs (..), SettlementType (..), settlementType
  , SettlementInstruction (..), settleProjection, signedFor, reconciles
    -- * Part I -- the ISDA-CDM forgetful map (§13)
  , Intent (..), LifecycleState (..), TradeState (..)
  , PrimitiveInstruction (..), BusinessEvent (..)
  , CdmTransaction (..), instructionMoves, forget
    -- * Part J -- obligation liveness (§14)
  , ObId (..), Source (..), Time (..), ObType (..), OblView (..)
  , Obligation (..), Live (..), Terminal (..), ObState (..), Trigger (..), obStep
    -- * Part K -- the futures lifecycle engine (§8)
  , PosQty, mkPosQty, unPosQty, futMark
  , FutTerms (..), Settlement (..)
  , FutStage (..), FutStatus (..), stageOf, settlement
  , settlementPrice, settlementDate, stageRank, isExpired, futRegisteredStatus
  , FutPos (..), futZeroP
  , FutEvent (..), futEventUnit
  , Conserved (..), FutRowDelta (..), FutStateDelta (..), futNetDelta
  , FutValidDelta, futValidate
  , activateTrade, tradeDelta, settlementFanout, closeDelta, futHandle
  , FutLedger, FutLedgerError (..), futEmptyLedger, futRegister
  , futApplyDelta, futStep, futReplay
  , futProductTerms, futUnitStatus, futPosition, futCashOf, futHoldersOf
    -- * Part L -- the property-test oracle catalogue (App. B)
  , Outcome (..), TxError (..), Property (..), TxInput (..), Scope (..)
  , OracleTx (..), registered, inScope, isRejected, invalidMove
  , unitTotal, sameLedger, p1, p2, p3, p7, idempotentTx
  , Hash (..), Hashed (..), chainOK, p8
  , LifecycleFn, idempotentL, pureL, validTransitionsOnly, p10, total
  ) where

import           Control.Monad      (foldM)
import           Data.Either        (partitionEithers)
import           Data.List          (foldl')
import           Data.List.NonEmpty (NonEmpty (..))
import qualified Data.List.NonEmpty as NE
import           Data.Map.Strict    (Map)
import qualified Data.Map.Strict    as Map
import           Data.Set           (Set)
import qualified Data.Set           as Set

-- =============================================================================
-- PART A -- shared scalars.
--
-- Qty is the additive abelian group of exact minor units. Conservation is a
-- statement in THIS monoid: a conserving delta sums to `mempty`. The zero-holder
-- (vacuous) base case then falls out for free -- a sum over no wallets is mempty,
-- hence conserved -- with no special case and no "divide by holder count".
-- Cash is a second such group. Price and Quote carry NO Monoid on purpose: adding
-- two prices is meaningless, so the type forbids the one wrong way to combine them.
-- =============================================================================

newtype Qty = Qty Integer deriving (Eq, Ord)
instance Show Qty where show (Qty n) = show n

instance Semigroup Qty where Qty a <> Qty b = Qty (a + b)
instance Monoid    Qty where mempty = Qty 0

qneg :: Qty -> Qty
qneg (Qty n) = Qty (negate n)
-- group inverse axiom:  qneg q <> q == mempty   for every q

negQty :: Qty -> Qty               -- the §2/§12 spelling of qneg
negQty = qneg

qmax :: Qty -> Qty -> Qty
qmax (Qty a) (Qty b) = Qty (max a b)

newtype Cash = Cash Integer deriving (Eq, Ord, Show)
instance Semigroup Cash where Cash a <> Cash b = Cash (a + b)
instance Monoid    Cash where mempty = Cash 0

cashNeg :: Cash -> Cash
cashNeg (Cash n) = Cash (negate n)

cashSub :: Cash -> Cash -> Cash
cashSub a b = a <> cashNeg b

newtype Price = Price Integer deriving (Eq, Ord, Show)   -- minor units per unit; NO Monoid
newtype Quote = Quote Integer deriving (Eq, Ord, Show)   -- raw disseminated spot;  NO Monoid

newtype WalletId  = WalletId  String  deriving (Eq, Ord, Show)
newtype UnitId    = UnitId    String  deriving (Eq, Ord, Show)
newtype Timestamp = Timestamp Integer deriving (Eq, Ord, Show)
newtype SourceId  = SourceId  String  deriving (Eq, Ord, Show)

-- =============================================================================
-- PART B -- the economic Move (§2), conservation, and the balance projection (§10).
--
-- A Move is one indivisible transfer of a positive quantity of one unit from a
-- source wallet to a destination. Direction is carried by (from,to); the
-- magnitude mQty is a PosQty -- a NON-negative-excluding newtype whose only door
-- is mkPosQty (its constructor is not exported), so "a move of a non-positive
-- magnitude" is unrepresentable, not merely rejected. Because a Move names BOTH
-- parties, it conserves by
-- construction: its contribution to the system-wide total of its unit is
-- qneg q <> q = mempty. (The §6 "smart-contract move generator" emits exactly
-- these moves; its extra free-text metadata field is not load-bearing and is
-- elided.)
-- =============================================================================

data Move = Move
  { mFrom   :: !WalletId
  , mTo     :: !WalletId
  , mUnit   :: !UnitId
  , mQty    :: !PosQty       -- positive magnitude (PosQty; sole door mkPosQty); from -= q, to += q
  , mTime   :: !Timestamp
  , mSource :: !SourceId
  } deriving (Eq, Show)

-- | The sole ingest path from a raw Qty: positivity is now a TYPE guarantee
--   (mQty :: PosQty), so `move` builds the magnitude through mkPosQty and returns
--   Nothing on a non-positive input -- the only place the check lives. Total.
move :: WalletId -> WalletId -> UnitId -> Qty -> Timestamp -> SourceId -> Maybe Move
move ws wd u q t s = fmap (\pq -> Move ws wd u pq t s) (mkPosQty q)

-- | A Move is the conserved flow in EDGE form (from -> to, positive magnitude).
--   Its per-unit signed contribution is qneg q <> q = mempty, so ANY finite list
--   of moves conserves by construction -- the empty list (registration) included.
--   The one unifying event that carries such a list, the `Transaction`, and the
--   conservation witnesses `unitDelta` / `netDelta` are defined with the canonical
--   core in Part C, where they ride alongside the non-balance state delta.

-- | The balance projection (§10). The monoid is POINTWISE addition -- NOT the
--   library-default left-biased union, which would silently drop a cell's second
--   contribution. `balances = foldMap contribution` is a monoid homomorphism:
--       balances (xs <> ys) = balances xs <> balances ys,
--   which gives, in one law: deterministic replay, O(k) snapshot-incremental
--   queries, and conservation (the column sum cancelling to mempty).
newtype Balances = Balances (Map (WalletId, UnitId) Qty) deriving (Eq, Show)

instance Semigroup Balances where
  Balances a <> Balances b = Balances (Map.unionWith (<>) a b)
instance Monoid Balances where
  mempty = Balances Map.empty

contribution :: Move -> Balances
contribution m = let n = unPosQty (mQty m) in Balances (Map.fromListWith (<>)
  [ ((mTo   m, mUnit m),      n)
  , ((mFrom m, mUnit m), qneg n) ])

balances :: [Move] -> Balances
balances = foldMap contribution

netBal :: WalletId -> UnitId -> [Move] -> Qty
netBal w u ms = let Balances b = balances ms
               in Map.findWithDefault mempty (w, u) b

-- =============================================================================
-- PART C -- the canonical core: the three-home model (§4).
-- -----------------------------------------------------------------------------
-- Map 1 -- ProductTerms : immutable, versioned, APPEND-ONLY (C6), registration-
-- total (C7). `NonEmpty` makes "registered but versionless" unrepresentable, so
-- `currentTerms` is total without a Maybe. The type is abstract; the only growth
-- operations are the singleton built by `register` and `appendVersion`.
-- =============================================================================

data TermsVersion = TermsVersion
  { tvLabel  :: String
  , tvFields :: Map String String   -- opaque terms payload (multiplier, ISIN, ...)
  } deriving (Eq, Show)

newtype ProductTerms = ProductTerms (NonEmpty TermsVersion) deriving (Show)

currentTerms :: ProductTerms -> TermsVersion
currentTerms (ProductTerms vs) = NE.last vs

allVersions :: ProductTerms -> NonEmpty TermsVersion
allVersions (ProductTerms vs) = vs

appendVersion :: TermsVersion -> ProductTerms -> ProductTerms   -- C6: append; never rewrite
appendVersion tv (ProductTerms vs) = ProductTerms (vs <> (tv :| []))

-- -----------------------------------------------------------------------------
-- Map 2 -- UnitStatus : a materialised projection of the log -- a cached view the
-- log can always rebuild (C5).
--
-- UnitStatus holds one value per unit, shared -- read identically by every
-- holder. Its value changes over time, but UnitStatus is not a separate source
-- of truth: the immutable event log is. Every change is caused by a logged
-- event; the stored value is overwritten in place only as a read cache.
-- Replaying the events up to any point rebuilds the exact value that held then,
-- so nothing is lost by overwriting and there is no other way to change the
-- value. A value exists from registration onward.
--
-- The single writer is `applyStatus`: every UnitStatus field changes ONLY as a
-- case of that pure total step, folded over the unit's status events inside
-- `applyTx`. No `setStatus` is exported, no record-update on a UnitStatus
-- appears anywhere else, and `Ledger` is sealed -- so no out-of-band writer can
-- reach a field and the cache cannot drift from the log.
-- -----------------------------------------------------------------------------

data Lifecycle = Registered | Active | Expired | Closed deriving (Eq, Show)

data UnitStatus = UnitStatus
  { usLifecycle    :: Lifecycle
  , usLastSettle   :: Maybe Qty       -- None at registration default (C5)
  , usSupersededBy :: Maybe UnitId    -- set by a Breaking amendment (C8)
  } deriving (Eq, Show)

defaultStatus :: UnitStatus            -- C5: product-declared default at registration
defaultStatus = UnitStatus Registered Nothing Nothing

-- C11 (UnitStatus half): the closed set of field writers. Each constructor is the
-- ONE canonical writer of its field; `applyStatus` is the only function that
-- writes a UnitStatus field. Last-write-wins, idempotent (P6).
data StatusWrite
  = SetLifecycle    Lifecycle
  | SetLastSettle   Qty
  | SetSupersededBy UnitId
  deriving (Eq, Show)

applyStatus :: StatusWrite -> UnitStatus -> UnitStatus
applyStatus (SetLifecycle l)    s = s { usLifecycle    = l }
applyStatus (SetLastSettle q)   s = s { usLastSettle   = Just q }
applyStatus (SetSupersededBy u) s = s { usSupersededBy = Just u }

-- -----------------------------------------------------------------------------
-- C11 -- per-field canonical-writer table as a TYPE-LEVEL relation.
-- A `FieldWrite h` is a write authored BY handler `h`; the GADT constructors ARE
-- the field->writer table, and no other pairing is representable. A settle
-- handler that tried to bump the high-water mark would have to emit
-- `WHwm :: FieldWrite 'FeeCrystallise` and fail to typecheck against its declared
-- `'Settle` output -- "mutation by any other handler is a type error", literally.
-- -----------------------------------------------------------------------------

data Handler = Settle | Trade | Transfer | FeeCrystallise | Subscribe
  deriving (Eq, Show)

-- The balance field is NOT in this table: its sole canonical writer is the `Move`
-- edge (handler 'Transfer), applied in `applyTx`. So `psBalance` can change only
-- through a conserving move, and "balance written off-ledger" is unrepresentable.
-- The remaining fields are the non-balance per-position bookkeeping.
data FieldWrite (h :: Handler) where
  WAc       :: Qty -> FieldWrite 'Settle           -- ac, by settle
  WAcTrade  :: Qty -> FieldWrite 'Trade            -- ac, by trade
  WHwm      :: Qty -> FieldWrite 'FeeCrystallise   -- hwm, by fee crystallisation
  WEntryNav :: Qty -> FieldWrite 'Subscribe        -- entry_nav, by subscribe

deriving instance Show (FieldWrite h)

-- | Handler index erased for storage in a heterogeneous delta row (the index was
--   already checked at the point each handler authored its write).
data SomeWrite where
  SomeWrite :: FieldWrite h -> SomeWrite

instance Show SomeWrite where show (SomeWrite w) = show w

applyWrite :: FieldWrite h -> PositionState -> PositionState
applyWrite (WAc q)       p = p { psAc       = psAc p <> q }
applyWrite (WAcTrade q)  p = p { psAc       = psAc p <> q }
applyWrite (WHwm q)      p = p { psHwm      = qmax (psHwm p) q }                    -- monotone
applyWrite (WEntryNav q) p = p { psEntryNav = maybe (Just q) Just (psEntryNav p) } -- write-once

-- | A settle handler authors ONLY 'Settle writes; its result type is the C11
--   checkpoint -- the live call site at which the phantom index constrains.
settleHandler :: [(WalletId, Qty)] -> Map WalletId [FieldWrite 'Settle]
settleHandler legs = Map.fromList [ (w, [WAc q]) | (w, q) <- legs ]

-- | The authorship -> erasure boundary: drop the per-handler index so
--   heterogeneous authored writes can share one delta row.
erase :: Map WalletId [FieldWrite h] -> Map WalletId [SomeWrite]
erase = fmap (map SomeWrite)

-- -----------------------------------------------------------------------------
-- Map 3 -- PositionState, per (holder, unit). C1 has two orthogonal halves:
--   (a) Option accessor : `position` returns `Maybe PositionState`;
--         Nothing = never held; Just zeroP = held once, currently flat. These
--         cannot be collapsed (VM-settle, wash-sale lookback, record-date
--         entitlements all read the difference).
--   (b) Monotone carrier : a row, once created, is never deleted. Enforced
--         structurally -- `applyTx` only inserts/updates, and no deleter is
--         exported.
-- -----------------------------------------------------------------------------

data PositionState = PositionState
  { psAc       :: !Qty
  , psBalance  :: !Qty
  , psHwm      :: !Qty
  , psEntryNav :: !(Maybe Qty)
  } deriving (Eq, Show)

zeroP :: PositionState
zeroP = PositionState mempty mempty mempty Nothing

-- -----------------------------------------------------------------------------
-- The ONE atomic event: the Transaction (C2 + C3).
--
-- A Transaction is the whole proposed change for ONE event across all three maps,
-- carried in TWO complementary parts:
--
--   * txMoves -- the conserved economic flow, in EDGE form. Each Move debits one
--     wallet and credits another by the same magnitude, so the signed per-unit
--     sum of any move list is mempty BY CONSTRUCTION -- the empty list (a move-
--     less registration / amendment) included, which is the vacuous C9 case.
--     There is no unconserved Transaction to reject, hence no `validate` gate:
--     conservation is a property of the type, not a checked side-condition.
--
--   * the state delta -- the non-balance writes that ride alongside the moves:
--     per-wallet bookkeeping (txRows: ac / hwm / entry_nav, via the C11 FieldWrite
--     table), the shared UnitStatus writes (txStatus), and the ProductTerms
--     introduction (txIntroduce) or append (txAppend).
--
-- One value, two notations: txMoves is the per-edge (Heisenberg) view of the same
-- flow that `balances`/`contribution` reads per-wallet (Schroedinger) -- so this
-- single type carries BOTH the conserved move edges and the non-balance state delta
-- (txRows, txStatus, txIntroduce/txAppend) that ride with them, in one value.
--
-- txIntroduce is the ONE structural asymmetry between registration and every other
-- event: Just => this event INTRODUCES its unit (writes ProductTerms + UnitStatus
-- together); Nothing => it operates on an EXISTING unit. `applyTx` reads this field
-- to make "introduce an already-registered unit => Left" and "PT and US created as
-- one" hold by construction, so registration is the move-less instance of this one
-- type rather than a separate operation.
--
-- C3 (all-or-nothing) is structural: `applyTx` returns the whole new Ledger or a
-- Left; no partially-applied ledger is representable.
-- -----------------------------------------------------------------------------

data Transaction = Transaction
  { txUnit      :: UnitId                          -- the unit this event concerns
  , txMoves     :: [Move]                          -- conserved flow as edges (by construction)
  , txRows      :: Map WalletId [SomeWrite]        -- non-balance per-wallet bookkeeping (ac/hwm/entryNav)
  , txStatus    :: [StatusWrite]                   -- shared UnitStatus writes
  , txIntroduce :: Maybe (TermsVersion, UnitStatus)-- Just => introduce txUnit (registration)
  , txAppend    :: Maybe TermsVersion              -- Just => append a version (C6, Preserving amendment)
  } deriving (Show)

-- | Conservation witnesses. Each move contributes qneg q <> q = mempty, so the
--   foldMap lands at mempty by the monoid laws -- not by a sum computed and
--   compared at run time.
unitDelta :: UnitId -> Transaction -> Qty
unitDelta u tx =
  foldMap (\m -> if mUnit m == u then let n = unPosQty (mQty m) in qneg n <> n else mempty) (txMoves tx)
-- law:  unitDelta u tau == mempty   for every unit u and transaction tau

netDelta :: Transaction -> Qty
netDelta tx = foldMap (\m -> let n = unPosQty (mQty m) in qneg n <> n) (txMoves tx)
-- law:  netDelta tau == mempty   for every tau (the empty/registration case too)

-- | The canonical move-less instances. Trade/settlement/transfer are built with
--   the record constructor directly (txIntroduce = Nothing, moves + rows present).
registerTx :: UnitId -> TermsVersion -> UnitStatus -> Transaction
registerTx u tv us = Transaction
  { txUnit = u, txMoves = [], txRows = Map.empty
  , txStatus = [], txIntroduce = Just (tv, us), txAppend = Nothing }

appendTx :: UnitId -> TermsVersion -> Transaction               -- C6 Preserving amendment
appendTx u tv = Transaction
  { txUnit = u, txMoves = [], txRows = Map.empty
  , txStatus = [], txIntroduce = Nothing, txAppend = Just tv }

supersedeTx :: UnitId -> UnitId -> Transaction                  -- C8 Breaking: stamp old unit
supersedeTx u uFresh = Transaction
  { txUnit = u, txMoves = [], txRows = Map.empty
  , txStatus = [SetSupersededBy uFresh], txIntroduce = Nothing, txAppend = Nothing }

-- -----------------------------------------------------------------------------
-- The ledger. ABSTRACT: no field setter is exported, so no caller can delete a
-- PositionState row (C1) or fabricate terms (C6) / a valid delta (C2) from
-- outside.
-- -----------------------------------------------------------------------------

data Ledger = Ledger
  { ledgerPT :: Map UnitId ProductTerms
  , ledgerUS :: Map UnitId UnitStatus
  , ledgerPS :: Map (WalletId, UnitId) PositionState
  } deriving (Show)

data LedgerError
  = ReRegistration     UnitId   -- C10
  | UnitAlreadyExists  UnitId   -- fresh-id collision in a Breaking amendment
  | UnknownUnit        UnitId
  | DanglingSupersede  UnitId   -- SetSupersededBy target is not a registered unit
  deriving (Eq, Show)

emptyLedger :: Ledger
emptyLedger = Ledger Map.empty Map.empty Map.empty

-- | `register` is the convenience that applies the move-less introduction event
--   (`registerTx`). It is not a primitive standing outside the fold: it is
--   exactly `applyTx . registerTx`, so registration, trade, settlement and
--   amendment all flow through the ONE apply. C5 + C7 + C10 are discharged inside
--   `applyTx` (introduce-an-existing-unit => Left; PT and US written together).
register :: UnitId -> TermsVersion -> UnitStatus -> Ledger -> Either LedgerError Ledger
register u tv us = applyTx (registerTx u tv us)

-- | Apply ONE Transaction. The single door for every change to the three maps.
--
--   1. Introduction (txIntroduce): Just => txUnit must be ABSENT, then PT (the
--      singleton first version, C7) and US are inserted TOGETHER (C5); an already-
--      registered unit is a hard Left (C10). Nothing => no introduction.
--   2. Reference check: txUnit, and every unit a move names, must now be
--      registered -- else UnknownUnit. (PT/US are never auto-vivified; only the
--      PositionState row auto-vivifies to zeroP on first touch, C1.)
--   3. Commit: append (C6), status writes, then the per-wallet bookkeeping rows
--      and the balance edges -- onto disjoint PositionState fields (psBalance only
--      via moves; psAc/psHwm/psEntryNav only via rows).
--
--   Conservation is already a property of `txMoves` (edges), so there is nothing
--   to validate. Atomic and monotone (insert/update only): the whole new Ledger or
--   a Left, never a partial write.
applyTx :: Transaction -> Ledger -> Either LedgerError Ledger
applyTx tx l0 = do
    l1 <- introduce l0
    ()  <- requireKnown l1
    ()  <- requireSupersedeTargets l1
    Right (commit l1)
  where
    u = txUnit tx

    introduce l = case txIntroduce tx of
      Nothing -> Right l
      Just (tv, us)
        | u `Map.member` ledgerPT l -> Left (ReRegistration u)              -- C10
        | otherwise -> Right l
            { ledgerPT = Map.insert u (ProductTerms (tv :| [])) (ledgerPT l) -- C7
            , ledgerUS = Map.insert u us                        (ledgerUS l) -- C5
            }

    requireKnown l =
      case filter (\x -> not (x `Map.member` ledgerPT l)) (u : map mUnit (txMoves tx)) of
        (bad : _) -> Left (UnknownUnit bad)
        []        -> Right ()

    -- Referential integrity for the supersede pointer: a SetSupersededBy target
    -- must name a registered unit, else the stamp would dangle. Total (a pure scan
    -- of txStatus); conservation untouched (this gates a UnitStatus write, not a
    -- move). In a Breaking amendment the successor is introduced first, so its id
    -- is registered by the time supersedeTx is applied.
    requireSupersedeTargets l =
      case filter (\x -> not (x `Map.member` ledgerPT l))
                  [ t | SetSupersededBy t <- txStatus tx ] of
        (bad : _) -> Left (DanglingSupersede bad)
        []        -> Right ()

    commit l = l
      { ledgerPT = maybe (ledgerPT l)
                         (\tv -> Map.adjust (appendVersion tv) u (ledgerPT l))   -- C6 append
                         (txAppend tx)
      , ledgerUS = if null (txStatus tx)
                     then ledgerUS l
                     else Map.adjust (\s -> foldl' (flip applyStatus) s (txStatus tx)) u (ledgerUS l)
      , ledgerPS = foldl' (flip applyMoveRow)
                          (Map.foldrWithKey applyRow (ledgerPS l) (txRows tx))
                          (txMoves tx)
      }

    applyRow w writes ps =                                       -- non-balance bookkeeping
      let key = (w, u)
          cur = Map.findWithDefault zeroP key ps                 -- first touch -> flat row
          new = foldl' (\acc (SomeWrite fw) -> applyWrite fw acc) cur writes
      in  Map.insert key new ps                                  -- insert/update only

-- | A Move writes ONLY psBalance, via the conserving pair from `moveDelta`
--   (from -= q, to += q), keyed by the move's own unit. This is the sole writer of
--   the balance field, so balance change without a conserving move is unrepresentable.
applyMoveRow :: Move -> Map (WalletId, UnitId) PositionState
             -> Map (WalletId, UnitId) PositionState
applyMoveRow m ps0 =
  foldl' step ps0 (moveDelta m)
  where
    step ps (w, dq) =
      let key = (w, mUnit m)
          cur = Map.findWithDefault zeroP key ps
      in  Map.insert key cur { psBalance = psBalance cur <> dq } ps

-- | Replay = an error-stopping fold of the event stream over the ledger.
--   Determinism (P8) is the fold-homomorphism law:
--       replay (xs <> ys)  =  replay xs >=> replay ys,
--   so the result is independent of where a checkpoint is cut. Checkpoint-
--   independence is a CONSEQUENCE of the law, not a test.
replay :: [Transaction] -> Ledger -> Either LedgerError Ledger
replay ds l0 = foldM (\l d -> applyTx d l) l0 ds

-- Accessors. Total. `Maybe` on PT/US distinguishes unregistered; on PS it is the
-- load-bearing C1 Option accessor (never-held vs held-and-flat).
productTerms :: Ledger -> UnitId -> Maybe ProductTerms
productTerms l u = Map.lookup u (ledgerPT l)

unitStatus :: Ledger -> UnitId -> Maybe UnitStatus
unitStatus l u = Map.lookup u (ledgerUS l)

position :: Ledger -> WalletId -> UnitId -> Maybe PositionState
position l w u = Map.lookup (w, u) (ledgerPS l)

-- -----------------------------------------------------------------------------
-- C8 -- two-track amendment, expressed in the ONE type. A product-declared total
-- predicate decides the track.
--   Preserving -> ONE move-less Transaction on the SAME unit: `appendTx` (C6);
--     existing rows survive.
--   Breaking   -> a unit is INTRODUCED and the old unit is stamped: that spans two
--     units, so it is the composition of two Transactions -- `registerTx uFresh`
--     (the successor) then `supersedeTx u uFresh` (the back-stamp). `amend` runs
--     them through `applyTx` and exposes only the final ledger or a Left, so the
--     pair is atomic to callers; the old unit's terms are never rewritten (C7/P7).
-- Either track, the effect reaches the maps ONLY through `applyTx` -- there is no
-- second write path.
-- -----------------------------------------------------------------------------

data Fungibility = Preserving | Breaking deriving (Eq, Show)

type FungibilityPredicate = ProductTerms -> TermsVersion -> Fungibility

data AmendResult
  = Appended   UnitId          -- Preserving: same unit, new version
  | Superseded UnitId UnitId   -- Breaking: old unit -> fresh unit
  deriving (Eq, Show)

amend :: FungibilityPredicate -> UnitId -> TermsVersion -> UnitId -> Ledger
      -> Either LedgerError (AmendResult, Ledger)
amend isFungible u tvNew uFresh l =
  case Map.lookup u (ledgerPT l) of
    Nothing -> Left (UnknownUnit u)
    Just pt -> case isFungible pt tvNew of
      Preserving ->
        (\l' -> (Appended u, l')) <$> applyTx (appendTx u tvNew) l
      Breaking
        | uFresh `Map.member` ledgerPT l -> Left (UnitAlreadyExists uFresh)
        | otherwise -> do
            l1 <- applyTx (registerTx uFresh tvNew defaultStatus) l
            l2 <- applyTx (supersedeTx u uFresh)                  l1
            Right (Superseded u uFresh, l2)

-- | C11 made concrete: these typecheck; `_c11_bad = WHwm :: Qty -> FieldWrite
--   'Settle` would NOT (WHwm is a FieldWrite 'FeeCrystallise).
_c11_ok_settle :: Qty -> FieldWrite 'Settle
_c11_ok_settle = WAc
_c11_ok_fee    :: Qty -> FieldWrite 'FeeCrystallise
_c11_ok_fee    = WHwm

-- =============================================================================
-- PART D -- managed accounts: issuance, settlement signature, fee crystallisation (§9).
-- Reuses the core Move, Qty group and the C11 WHwm writer.
-- (Names: §9's fee record `FeeCrystallise` is `FeeEvent` here, to avoid colliding
--  with the Handler constructor `FeeCrystallise` / the promoted index 'FeeCrystallise.)
-- =============================================================================

usd :: UnitId
usd = UnitId "USD"

-- | The per-wallet deltas a move induces on its unit; their sum is the
--   conservation witness  qneg q <> q = mempty.
moveDelta :: Move -> [(WalletId, Qty)]
moveDelta (Move s d _ q _ _) = let n = unPosQty q in [(s, qneg n), (d, n)]

-- | Mandate issuance: a real two-named-wallet transfer of u_MA, manager -> client.
issueMandate :: WalletId -> WalletId -> UnitId -> Move
issueMandate manager client uMA = Move manager client uMA (PosQty (Qty 1)) (Timestamp 0) (SourceId "issuance")

-- | Crystallise(magnitude, from, to): a signed amount becomes AT MOST ONE
--   conserved cash move -- magnitude |x|, direction by sign(x), NO move at x = 0.
--   Total via Maybe.
crystallise :: Qty -> WalletId -> WalletId -> Maybe Move
crystallise (Qty x) from to
  | x > 0     = Just (Move from to usd (PosQty (Qty x))          (Timestamp 0) (SourceId "fee"))
  | x < 0     = Just (Move to   from usd (PosQty (Qty (negate x))) (Timestamp 0) (SourceId "fee"))
  | otherwise = Nothing

data FeeEvent = FeeEvent
  { fcMgmt   :: Qty          -- management fee (accrues on AUM, any sign of perf)
  , fcPerf   :: Qty          -- performance fee (floored at zero; no clawback)
  , fcNavNet :: Qty          -- NAV net of the management fee, for the ratchet
  } deriving (Eq, Show)

-- | Fee crystallisation = double-entry (two cash moves w_C -> w_M, atomic) plus
--   the HWM ratchet as the C11 FieldWrite 'FeeCrystallise:
--       HWM_k = max(HWM_{k-1}, NAV^net_k - f^p_k)   (qmax, by construction).
--   On a loss period f_p = 0, so `crystallise` returns Nothing and the
--   performance leg is simply absent (no zero-quantity move).
crystalliseFees :: WalletId -> WalletId -> FeeEvent -> ([Move], FieldWrite 'FeeCrystallise)
crystalliseFees wC wM fc =
  ( [ m | Just m <- [ crystallise (fcMgmt fc) wC wM
                    , crystallise (fcPerf fc) wC wM ] ]
  , WHwm (fcNavNet fc <> qneg (fcPerf fc)) )

-- =============================================================================
-- PART E -- portfolio valuation and PnL (§5).
--
-- A price vector assigns a Price to EVERY unit (a total function, not a partial
-- lookup), so "a held unit with no price" is not representable. Valuation is one
-- total fold of the balance projection against the prices; its signature has no
-- time and no history -- value depends ONLY on current balances and prices
-- (state-sufficiency), so PnL over an interval is the difference of two
-- valuations: path-independent (P10) by telescoping.
-- =============================================================================

newtype PriceVec = PriceVec { priceOf :: UnitId -> Price }

markValue :: Qty -> Price -> Cash
markValue (Qty q) (Price p) = Cash (q * p)

-- A PORTFOLIO is a NON-EMPTY set of a book's real wallets. `mkPortfolio` is the
-- sole door; the empty scope -- which values to Cash 0 by the empty sum, the very
-- degeneracy by which a whole-ledger fold is identically zero -- is not
-- representable. A Set, not a list, so value is scope-idempotent: a wallet named
-- twice is one wallet.
newtype Portfolio = Portfolio (Set WalletId)

mkPortfolio :: [WalletId] -> Maybe Portfolio
mkPortfolio [] = Nothing
mkPortfolio ws = Just (Portfolio (Set.fromList ws))

-- A valuation SNAPSHOT pairs one price vector with one ledger. Bundling the two
-- into a single endpoint makes the pnl transposition (valuing one ledger at the
-- OTHER endpoint's prices) unrepresentable -- the endpoints cannot be cross-paired.
data Snapshot = Snapshot PriceVec Ledger

-- value of a PORTFOLIO (scope first: `value port` is a book's valuation function).
-- Summing over ALL wallets is zero by closure (conservation), so a meaningful
-- valuation is always of a chosen NON-EMPTY scope. Depends ONLY on current
-- balances in scope and prices -- no time, no history (state-sufficiency).
value :: Portfolio -> PriceVec -> Ledger -> Cash
value (Portfolio ws) (PriceVec p) l =
  foldMap (\((w, u), ps) -> if w `Set.member` ws
                              then markValue (psBalance ps) (p u) else mempty)
          (Map.toList (ledgerPS l))

-- PnL of one portfolio across two snapshots. Each value is fixed by its own
-- snapshot alone, so PnL telescopes: path-independent (P10).
pnl :: Portfolio -> Snapshot -> Snapshot -> Cash
pnl port (Snapshot pv0 l0) (Snapshot pv1 l1) =
  value port pv1 l1 `cashSub` value port pv0 l0

-- =============================================================================
-- PART F -- state-aware pricing (App. D).
--
-- P_t(u) = P(u, state, market): a total pure function of the unit's contract
-- state AND the external quote, never the quote alone. A quote-only pricer would
-- double-count a coupon/dividend (once as the cash leg, once embedded in the
-- mark); at this type that pricer is not expressible. Carrying the paid amount on
-- `Ex` makes the adjustment total and "ex with unknown amount" unrepresentable.
-- =============================================================================

data Distribution = Cum | Ex Cash deriving (Eq, Show)

data Market = Market { mQuote :: Quote, mQuoteEx :: Bool } deriving (Eq, Show)

statePrice :: UnitId -> Distribution -> Market -> Price
statePrice _ Cum           (Market (Quote q) _    ) = Price q          -- cum: quote as is
statePrice _ (Ex _)        (Market (Quote q) True ) = Price q          -- quote already ex
statePrice _ (Ex (Cash d)) (Market (Quote q) False) = Price (q - d)    -- quote lags: remove once

-- =============================================================================
-- PART G -- generalised positions and SBL (§16).
--
-- The six-coordinate position vector; `avail` a TOTAL projection computed on read
-- (never stored, so it cannot drift -- P20); single-coordinate moves (a move
-- names exactly ONE coordinate, so a multi-coordinate move is unrepresentable).
-- =============================================================================

data Position = Position
  { own       :: !Qty   -- economic ownership; may be negative (short). Drives PnL.
  , onloan    :: !Qty   -- lent out; lender retains ownership.
  , borr      :: !Qty   -- borrowed; the return-obligation count.
  , collPost  :: !Qty   -- collateral delivered to lender / triparty.
  , collRecv  :: !Qty   -- collateral held from the borrower.
  , collRehyp :: !Qty   -- non-cash collateral re-used by the taker (SFTR Art.15).
  } deriving (Eq, Show)

zeroPos :: Position
zeroPos = Position mempty mempty mempty mempty mempty mempty

avail :: Position -> Qty                 -- own - onloan + borr; a group homomorphism
avail p = own p <> qneg (onloan p) <> borr p

possess :: Position -> Qty               -- physical custody
possess p = avail p <> collRecv p

encumb :: Position -> Qty                -- owned, not tradeable
encumb p = onloan p <> collPost p

data Coord = Own | OnLoan | Borr | CollPost | CollRecv | CollRehyp deriving (Eq, Show)

applyMove :: Coord -> Qty -> Position -> Position
applyMove Own       q p = p { own       = own p       <> q }
applyMove OnLoan    q p = p { onloan    = onloan p    <> q }
applyMove Borr      q p = p { borr      = borr p      <> q }
applyMove CollPost  q p = p { collPost  = collPost p  <> q }
applyMove CollRecv  q p = p { collRecv  = collRecv p  <> q }
applyMove CollRehyp q p = p { collRehyp = collRehyp p <> q }

-- =============================================================================
-- PART H -- the settlement-layer interface (§12).
--
-- The boundary is ONE pure total function settleProjection :: SettlementTx ->
-- Maybe SettlementInstruction. It reads one committed transaction and nothing
-- else, so it is deterministic and safe to re-run. Each leg-bearing instruction
-- carries exactly the legs its type names, so "an instruction with no legs" is
-- unrepresentable. (Names: §12's Move is `SettleMove` here -- it ranges over the
-- settlement identity `Asset`, not the ledger UnitId; §12's Transaction is
-- `SettlementTx`; §12's TxType is `TxClass`; §12's Asset case `Cash` is `CashCcy`
-- to avoid colliding with the scalar `Cash`.)
-- =============================================================================

newtype Day      = Day      Int    deriving (Eq, Ord, Show)
newtype TxId     = TxId     String deriving (Eq, Ord, Show)   -- the EndToEndId
newtype ISIN     = ISIN     String deriving (Eq, Ord, Show)
newtype Currency = Currency String deriving (Eq, Ord, Show)
newtype LEI      = LEI      String deriving (Eq, Ord, Show)
newtype MIC      = MIC      String deriving (Eq, Ord, Show)

data Asset = Security ISIN | CashCcy Currency deriving (Eq, Show)

data SettleMove = SettleMove
  { smFrom  :: WalletId
  , smTo    :: WalletId
  , smAsset :: Asset
  , smQty   :: Qty
  } deriving (Eq, Show)

-- Settlability is a first-class field set by the generating contract, not
-- inferred. `settles` is total over all five classes; only SETTLEMENT and
-- COLLATERAL settle.
data TxClass = SETTLEMENT | COLLATERAL | LIFECYCLE | ACCOUNTING | CORRECTION
  deriving (Eq, Show)

settles :: TxClass -> Bool
settles SETTLEMENT = True
settles COLLATERAL = True
settles LIFECYCLE  = False
settles ACCOUNTING = False
settles CORRECTION = False

data CdmPayload = CdmPayload
  { cdmTradeDate    :: Day
  , cdmSettleDate   :: Day
  , cdmCounterparty :: LEI
  , cdmVenue        :: MIC
  } deriving (Eq, Show)

data SettlementTx = SettlementTx
  { stId    :: TxId
  , stClass :: TxClass
  , stMoves :: [SettleMove]
  , stCdm   :: CdmPayload
  } deriving (Eq, Show)

data SecuritiesLeg = SecuritiesLeg
  { slIsin    :: ISIN
  , slQty     :: Qty
  , slDeliver :: WalletId
  , slReceive :: WalletId
  } deriving (Eq, Show)

data CashLeg = CashLeg
  { clCcy      :: Currency
  , clAmount   :: Qty
  , clPayer    :: WalletId
  , clReceiver :: WalletId
  } deriving (Eq, Show)

data SettlementLegs
  = DvP SecuritiesLeg CashLeg   -- delivery versus payment
  | FoP SecuritiesLeg           -- securities only: free of payment
  | CashOnly CashLeg            -- cash only
  deriving (Eq, Show)

data SettlementType = DVP | FOP | CASH deriving (Eq, Show)

settlementType :: SettlementLegs -> SettlementType   -- a projection, not a stored field
settlementType (DvP _ _)    = DVP
settlementType (FoP _)      = FOP
settlementType (CashOnly _) = CASH

data SettlementInstruction = SettlementInstruction
  { siRef          :: TxId
  , siTradeDate    :: Day
  , siSettleDate   :: Day
  , siLegs         :: SettlementLegs
  , siCounterparty :: LEI
  , siVenue        :: MIC
  } deriving (Eq, Show)

classify :: SettleMove -> Either SecuritiesLeg CashLeg
classify (SettleMove from to (Security i) q) = Left  (SecuritiesLeg i q from to)
classify (SettleMove from to (CashCcy c)  q) = Right (CashLeg       c q from to)

legsOf :: [SettleMove] -> Maybe SettlementLegs
legsOf ms = case partitionEithers (map classify ms) of
  ([s], [c]) -> Just (DvP s c)
  ([s], [])  -> Just (FoP s)
  ([], [c])  -> Just (CashOnly c)
  _          -> Nothing

settleProjection :: SettlementTx -> Maybe SettlementInstruction
settleProjection tx
  | settles (stClass tx) = mk <$> legsOf (stMoves tx)
  | otherwise            = Nothing
  where
    mk legs = SettlementInstruction
      { siRef          = stId tx
      , siTradeDate    = cdmTradeDate (stCdm tx)
      , siSettleDate   = cdmSettleDate (stCdm tx)
      , siLegs         = legs
      , siCounterparty = cdmCounterparty (stCdm tx)
      , siVenue        = cdmVenue (stCdm tx)
      }

-- Gross-to-net reconciliation as a group homomorphism: for each group the net
-- leg's signed quantity equals the SUM of the gross legs' signed quantities.
signedFor :: WalletId -> SecuritiesLeg -> Qty
signedFor me l
  | slDeliver l == me = slQty l
  | slReceive l == me = negQty (slQty l)
  | otherwise         = mempty

reconciles :: WalletId -> [SecuritiesLeg] -> SecuritiesLeg -> Bool
reconciles me gross net = foldMap (signedFor me) gross == signedFor me net

-- =============================================================================
-- PART I -- the ISDA-CDM forgetful map  forget :: BusinessEvent -> CdmTransaction (§13).
--
-- F reads the economic operators a CDM BusinessEvent carries, emits the
-- corresponding ledger Moves, and stores the WHOLE originating event verbatim --
-- the legal/workflow detail is dropped from ledger state but recoverable.
-- Move extraction is `concatMap instructionMoves`, a monoid homomorphism from the
-- free monoid of instruction lists to the free monoid of move lists:
--     moves (xs <> ys) = moves xs <> moves ys.
-- (Names: §13's primitive `Transfer` is `PiTransfer` here, to avoid colliding with
-- the Handler constructor `Transfer`.)
-- =============================================================================

data Intent = Execution | Exercise | Termination | QtyChange | ResetIntent
  deriving (Eq, Show)

data LifecycleState = ActiveS | Exercised | Terminated | SettledS deriving (Eq, Show)
newtype TradeState = TradeState LifecycleState deriving (Eq, Show)

data PrimitiveInstruction
  = PiTransfer  WalletId WalletId UnitId Qty   -- value leg (cash or asset)
  | PiQtyChange WalletId WalletId UnitId Qty   -- position leg (contracts)
  | PiTerms                                     -- amendment: no move
  | PiReset                                     -- observation/reset: no move
  deriving (Eq, Show)

data BusinessEvent = BusinessEvent
  { beInstructions :: [PrimitiveInstruction]   -- read by F (economic content)
  , beBefore       :: TradeState
  , beAfter        :: TradeState
  , beIntent       :: Intent                   -- FORGOTTEN
  , beLineage      :: [String]                 -- FORGOTTEN
  , beStructure    :: String                   -- FORGOTTEN
  } deriving (Eq, Show)

data CdmTransaction = CdmTransaction
  { ctMoves   :: [Move]         -- economic content the ledger acts on
  , ctPayload :: BusinessEvent  -- originating CDM event, kept verbatim
  } deriving (Eq, Show)

instructionMoves :: PrimitiveInstruction -> [Move]
-- The CDM boundary is untrusted: q arrives from an external instruction, so both
-- legs are built through the checked `move` (mkPosQty), never the raw Move
-- constructor. A non-positive magnitude yields no move rather than an illegal one.
-- (A principled boundary would surface the rejection as `Either CdmError` on
-- `forget`; here the ill-formed leg is dropped -- a recorded refinement.)
instructionMoves (PiTransfer  a b u q) = [ m | Just m <- [move a b u q (Timestamp 0) (SourceId "cdm")] ]
instructionMoves (PiQtyChange a b u q) = [ m | Just m <- [move a b u q (Timestamp 0) (SourceId "cdm")] ]
instructionMoves PiTerms               = []
instructionMoves PiReset               = []

forget :: BusinessEvent -> CdmTransaction
forget be = CdmTransaction (concatMap instructionMoves (beInstructions be)) be

-- =============================================================================
-- PART J -- orchestration and obligation liveness (§14).
--
-- A first-class Obligation with a total discharge predicate D and compensation
-- kappa. The lifecycle is split so the TYPE forbids leaving a terminal state:
-- `obStep` consumes only `Live`, so a `Terminal` can never be transitioned --
-- "leaving a terminal state" is unrepresentable, not merely unreached. On
-- DeadlineFired every arm returns a Terminal (lemma L5 / P21), visible in the
-- types. (Names: §14's placeholder LedgerState is `OblView` here; its
-- compensating moves are the core `Move`; the handler `step` is `obStep`; and
-- §14's ObState constructors Active/Settled are ObActive/ObSettled here, to
-- avoid colliding with the core Lifecycle constructor Active.)
-- =============================================================================

data OblView = OblView { collateralPosted :: Integer } deriving (Eq, Show)

newtype ObId   = ObId   String  deriving (Eq, Ord, Show)
newtype Source = Source String  deriving (Eq, Show)
newtype Time   = Time   Integer deriving (Eq, Ord, Show)
data    ObType = CsaVariationMargin | SblCollateralSubstitution | BondCoupon
  deriving (Eq, Show)

data Obligation = Obligation
  { obId         :: ObId
  , obType       :: ObType
  , obSource     :: Source
  , obDeadline   :: Time
  , obDischarge  :: OblView -> Bool           -- D : the discharge predicate (total)
  , obCompensate :: OblView -> Maybe [Move]   -- kappa : Just on success, Nothing on failure
  }

data Live     = Pending | Attempted                    -- non-terminal
  deriving (Eq, Show)
data Terminal = Discharged | Compensated | Defaulted   -- terminal: no exit edge
  deriving (Eq, Show)
data ObState  = ObActive Live | ObSettled Terminal     -- stored projection per obligation
  deriving (Eq, Show)

data Trigger = DischargeSignal | DeadlineFired deriving (Eq, Show)

obStep :: Obligation -> OblView -> Live -> Trigger -> Either Live Terminal
obStep o s _ DischargeSignal
  | obDischarge o s = Right Discharged
  | otherwise       = Left  Attempted
obStep o s _ DeadlineFired                       -- L5 / P21: this arm has no Left
  | obDischarge o s = Right Discharged
  | otherwise       = case obCompensate o s of
      Just _  -> Right Compensated
      Nothing -> Right Defaulted

-- =============================================================================
-- PART K -- the futures lifecycle engine (§8).
--
-- One cash-settled listed future: registration, trading, daily variation-margin
-- settlement, expiry, terminal flatten. This is a SECOND, self-contained ledger
-- with its own event alphabet and three-way conserved delta (position, accumulated
-- cost, cash); it carries stored per-position accumulated_cost (C11) so that the
-- intraday VM result is correct (VM = net*S*m + ac, not the gross mark). Every
-- name is `Fut`-prefixed (or otherwise disambiguated) so it coexists with the
-- canonical core. futMark is §8's three-argument markValue (with the multiplier);
-- the stage constructors are FutRegistered/FutActive/FutExpired so they do not
-- collide with the core Lifecycle.
--
-- BOUNDARY MODEL. This engine is a self-contained kernel that PROJECTS onto the
-- core Transaction/applyTx, exactly as the CDM BusinessEvent and the settlement
-- instruction do. Its FutStateDelta is the per-wallet (Schroedinger) presentation
-- of one futures event; futValidate is the conservation gate that the core gets
-- for free from the signed edge-sum of txMoves. Read FutStateDelta -> Transaction:
-- fsdRows/fsdCash are the conserved flow (txMoves + the C11 ac/cash rows) and
-- fsdStage is a txStatus write. It is NOT the core Transaction and is not renamed
-- to it; it is the futures-shaped notation of the same conserved event, kept
-- separate only so §8's three-way (position, accumulated cost, cash) bookkeeping
-- reads directly.
-- =============================================================================

newtype PosQty = PosQty Qty deriving (Eq, Ord, Show)   -- abstract: mkPosQty is the sole door (G5)

mkPosQty :: Qty -> Maybe PosQty
mkPosQty q@(Qty n) | n > 0     = Just (PosQty q)
                   | otherwise = Nothing

unPosQty :: PosQty -> Qty
unPosQty (PosQty q) = q

-- The single dimension bridge: contracts at a price * multiplier -> money.
futMark :: Qty -> Price -> Integer -> Cash
futMark (Qty q) (Price s) mult = Cash (q * s * mult)

data FutTerms = FutTerms
  { ptMultiplier    :: !Integer
  , ptCurrency      :: !String
  , ptExpiry        :: !Day
  , ptClearinghouse :: !String
  , ptExchange      :: !String
  , ptProductId     :: !String
  } deriving (Eq, Show)

data Settlement = Settlement { settlePrice :: !Price, settleDate :: !Day } deriving (Eq, Show)

data FutStage
  = FutRegistered                  -- recorded, never traded: no holders, no mark
  | FutActive (Maybe Settlement)   -- trading; Nothing = not yet settled, Just s = marked
  | FutExpired Settlement          -- final mark ALWAYS present; absorbing
  deriving (Eq, Show)

newtype FutStatus = FutStatus { fusStage :: FutStage } deriving (Eq, Show)

stageOf :: FutStatus -> FutStage
stageOf = fusStage

settlement :: FutStage -> Maybe Settlement
settlement FutRegistered  = Nothing
settlement (FutActive m)  = m
settlement (FutExpired s) = Just s

settlementPrice :: FutStatus -> Maybe Price
settlementPrice = fmap settlePrice . settlement . fusStage
settlementDate :: FutStatus -> Maybe Day
settlementDate = fmap settleDate . settlement . fusStage

stageRank :: FutStage -> Int
stageRank FutRegistered  = 0
stageRank (FutActive _)  = 1
stageRank (FutExpired _) = 2

isExpired :: FutStage -> Bool
isExpired (FutExpired _) = True
isExpired FutRegistered  = False    -- enumerate: a new
isExpired (FutActive _)  = False    -- stage forces a case

futRegisteredStatus :: FutStatus
futRegisteredStatus = FutStatus FutRegistered

data FutPos = FutPos { fpNetQty :: !Qty, fpAccumCost :: !Cash } deriving (Eq, Show)

futZeroP :: FutPos
futZeroP = FutPos mempty mempty

data FutEvent
  = FTrade    UnitId WalletId WalletId Qty Price   -- buyer, seller, qty, price
  | FSettleVM UnitId Price Day                      -- settlement price, date
  | FExpire   UnitId Price Day                      -- final price, date
  | FClose    UnitId                                -- terminal flatten to zero
  deriving (Eq, Show)

futEventUnit :: FutEvent -> UnitId
futEventUnit (FTrade u _ _ _ _) = u
futEventUnit (FSettleVM u _ _)  = u
futEventUnit (FExpire u _ _)    = u
futEventUnit (FClose u)         = u

data Conserved = Conserved !Qty !Cash !Cash deriving (Eq, Show)   -- (Σnet, Σac, Σcash)
instance Semigroup Conserved where
  Conserved a b c <> Conserved a' b' c' = Conserved (a <> a') (b <> b') (c <> c')
instance Monoid Conserved where mempty = Conserved mempty mempty mempty

data FutRowDelta = FutRowDelta { rdNetQty :: !Qty, rdAc :: !Cash } deriving (Eq, Show)

data FutStateDelta = FutStateDelta
  { fsdUnit  :: UnitId
  , fsdStage :: Maybe FutStage
  , fsdRows  :: Map WalletId FutRowDelta
  , fsdCash  :: Map WalletId Cash
  } deriving (Show)

futNetDelta :: FutStateDelta -> Conserved
futNetDelta sd =
       foldMap (\(FutRowDelta nq ac) -> Conserved nq ac mempty) (fsdRows sd)
    <> foldMap (\c                   -> Conserved mempty mempty c) (fsdCash sd)

newtype FutValidDelta = FutValidDelta FutStateDelta   -- abstract: futValidate is sole constructor

futValidate :: FutStateDelta -> Either FutLedgerError FutValidDelta
futValidate sd
  | net == mempty = Right (FutValidDelta sd)
  | otherwise     = Left  (FutNotConserved (fsdUnit sd) net)
  where net = futNetDelta sd

activateTrade :: FutStage -> FutStage
activateTrade cur = FutActive (settlement cur)

tradeDelta :: UnitId -> FutStage -> Integer
           -> WalletId -> WalletId -> PosQty -> Price -> FutStateDelta
tradeDelta u cur m buyer seller pq p = FutStateDelta
  { fsdUnit  = u
  , fsdStage = Just (activateTrade cur)
  , fsdRows  = Map.fromList
      [ (buyer , FutRowDelta q        (cashNeg (futMark q p m)))
      , (seller, FutRowDelta (qneg q) (futMark q p m)) ]
  , fsdCash  = Map.empty }
  where q = unPosQty pq

-- Δac = (-(net*S*m)) - ac ;  VM = -Δac = net*S*m + ac.
settlementFanout :: Price -> Integer -> [(WalletId, FutPos)]
                 -> (Map WalletId FutRowDelta, Map WalletId Cash)
settlementFanout s m holders =
    ( Map.fromList [ (w, FutRowDelta mempty (deltaAc ps)) | (w, ps) <- holders ]
    , Map.fromList [ (w, cashNeg (deltaAc ps))            | (w, ps) <- holders ] )
  where deltaAc ps = cashNeg (futMark (fpNetQty ps) s m) <> cashNeg (fpAccumCost ps)

closeDelta :: UnitId -> [(WalletId, FutPos)] -> FutStateDelta
closeDelta u holders = FutStateDelta
  { fsdUnit  = u, fsdStage = Nothing
  , fsdRows  = Map.fromList
      [ (w, FutRowDelta (qneg (fpNetQty ps)) (cashNeg (fpAccumCost ps))) | (w, ps) <- holders ]
  , fsdCash  = Map.empty }

futHandle :: FutEvent -> FutLedger -> Either FutLedgerError FutStateDelta
futHandle ev l = case Map.lookup u (flUnits l) of
  Nothing          -> Left (FutUnknownUnit u)
  Just (terms, us) ->
    let m = ptMultiplier terms; cur = fusStage us in case ev of
      FTrade _ buyer seller q p
        | buyer == seller -> Left (SelfTrade u buyer)            -- G3
        | isExpired cur   -> Left (UnitExpired u)                -- G2
        | otherwise       -> case mkPosQty q of                  -- G5: parse once
            Nothing -> Left (NonPositiveQty u q)
            Just pq -> Right (tradeDelta u cur m buyer seller pq p)
      FSettleVM _ s d -> case cur of
        FutExpired _    -> Left (UnitExpired u)                   -- G2
        FutRegistered   -> Left (NotActive u)                     -- G4
        FutActive _     -> let (rows, cash) = settlementFanout s m (futHoldersOf u l)
                           in Right (FutStateDelta u (Just (FutActive (Just (Settlement s d)))) rows cash)
      FExpire _ s d -> case cur of
        FutExpired _    -> Left (UnitExpired u)                   -- G2
        FutRegistered   -> Left (NotActive u)                     -- G4 (symmetric)
        FutActive _     -> let (rows, cash) = settlementFanout s m (futHoldersOf u l)
                           in Right (FutStateDelta u (Just (FutExpired (Settlement s d))) rows cash)
      FClose _ -> case cur of
        FutExpired _  -> Right (closeDelta u (futHoldersOf u l))  -- G1
        FutRegistered -> Left (NotExpired u)                      -- enumerate: a new
        FutActive _   -> Left (NotExpired u)                      -- stage forces a case
  where u = futEventUnit ev

data FutLedger = FutLedger
  { flUnits :: Map UnitId (FutTerms, FutStatus)
  , flPos   :: Map (WalletId, UnitId) FutPos
  , flCash  :: Map WalletId Cash
  }

data FutLedgerError
  = FutReRegistration UnitId | FutUnknownUnit UnitId
  | StageRegression UnitId FutStage FutStage | FutNotConserved UnitId Conserved
  | UnitExpired UnitId | NotActive UnitId | NotExpired UnitId
  | SelfTrade UnitId WalletId | NonPositiveQty UnitId Qty
  deriving (Eq, Show)

futEmptyLedger :: FutLedger
futEmptyLedger = FutLedger Map.empty Map.empty Map.empty

-- Two disjoint doors mutate the kernel, mirroring the core's own door split.
-- `futRegister` is the sole (monotone, error-on-re-registration) INTRODUCER of
-- units: it only inserts into `flUnits`, never an existing key. It projects onto
-- the core's move-less `registerTx` Transaction (txIntroduce = Just), vacuously
-- conserved. `futApplyDelta` is the sole MUTATOR of existing-unit position,
-- status, and cash: it errors `FutUnknownUnit` on an absent unit and never
-- creates one. The two ranges are disjoint, so neither claim contradicts the
-- other -- introduction and mutation are separate doors by construction, just as
-- the core keeps registration (txIntroduce) distinct from balance-moving txMoves.
futRegister :: UnitId -> FutTerms -> FutLedger -> Either FutLedgerError FutLedger
futRegister u terms l
  | u `Map.member` flUnits l = Left (FutReRegistration u)
  | otherwise = Right l { flUnits = Map.insert u (terms, futRegisteredStatus) (flUnits l) }

futApplyDelta :: FutValidDelta -> FutLedger -> Either FutLedgerError FutLedger
futApplyDelta (FutValidDelta sd) l
  | not (u `Map.member` flUnits l) = Left (FutUnknownUnit u)
  | otherwise = case fsdStage sd of
      Nothing  -> Right written
      Just new
        | isExpired cur                 -> Left (UnitExpired u)
        | stageRank new < stageRank cur -> Left (StageRegression u cur new)
        | otherwise -> Right written
            { flUnits = Map.adjust (\(t, _) -> (t, FutStatus new)) u (flUnits l) }
  where
    u   = fsdUnit sd
    cur = maybe FutRegistered (fusStage . snd) (Map.lookup u (flUnits l))
    written = l
      { flPos  = Map.foldrWithKey applyRow (flPos l) (fsdRows sd)
      , flCash = Map.foldrWithKey (\w c -> Map.insertWith (<>) w c) (flCash l) (fsdCash sd) }
    applyRow w (FutRowDelta dnq dac) mp =
      let key = (w, u); p0 = Map.findWithDefault futZeroP key mp
      in Map.insert key p0 { fpNetQty    = fpNetQty    p0 <> dnq
                           , fpAccumCost = fpAccumCost p0 <> dac } mp

futStep :: FutEvent -> FutLedger -> Either FutLedgerError FutLedger
futStep ev l = futHandle ev l >>= futValidate >>= \vd -> futApplyDelta vd l

-- futReplay (xs <> ys) = futReplay xs >=> futReplay ys  (Kleisli homomorphism).
futReplay :: [FutEvent] -> FutLedger -> Either FutLedgerError FutLedger
futReplay evs l0 = foldM (flip futStep) l0 evs

futProductTerms :: FutLedger -> UnitId -> Maybe FutTerms
futProductTerms l u = fst <$> Map.lookup u (flUnits l)
futUnitStatus :: FutLedger -> UnitId -> Maybe FutStatus
futUnitStatus l u = snd <$> Map.lookup u (flUnits l)
futPosition :: FutLedger -> WalletId -> UnitId -> Maybe FutPos
futPosition l w u = Map.lookup (w, u) (flPos l)
futCashOf :: FutLedger -> WalletId -> Cash
futCashOf l w = Map.findWithDefault mempty w (flCash l)
futHoldersOf :: UnitId -> FutLedger -> [(WalletId, FutPos)]
futHoldersOf u l = [ (w, ps) | ((w, u'), ps) <- Map.toList (flPos l), u' == u ]

-- =============================================================================
-- PART L -- the property-test oracle catalogue (App. B).
--
-- The ten core invariants P1--P10 as TYPED PREDICATES over the cleared core: a
-- precondition that constrains the generated input and a postcondition the
-- operation must satisfy, both total. `execute :: Ledger -> OracleTx -> Outcome`
-- returns a typed Outcome -- never an exception; `Accepted` is the ONLY
-- constructor carrying a ledger, so a partially-applied ("half-committed") ledger
-- is not representable. (Names: §B's local Move/Transaction reuse the core Move
-- and an `OracleTx` with a tx-id; §B's Cash reuses the scalar Cash; §B's
-- `Lifecycle` handler synonym is `LifecycleFn` to avoid colliding with the core
-- Lifecycle type.)
-- =============================================================================

data Outcome = Accepted Ledger | Rejected TxError

data TxError = Unconserved | BadRef | Duplicate | NotRegistered deriving (Eq)

data OracleTx = OracleTx { otId :: TxId, otMoves :: [Move] }

data Property i o = Property
  { pre  :: Ledger -> i -> Bool
  , post :: Ledger -> i -> o -> Bool
  }

data TxInput = TxInput { tiTx :: OracleTx, tiScope :: Scope }
data Scope   = Scope   { scWallets :: [WalletId], scUnits :: [UnitId] }

registered :: Ledger -> UnitId -> Bool
registered l u = maybe False (const True) (productTerms l u)

inScope :: Scope -> WalletId -> Bool
inScope sc w = w `elem` scWallets sc

isRejected :: Outcome -> Bool
isRejected (Rejected _) = True
isRejected _            = False

invalidMove :: Ledger -> Move -> Bool
invalidMove l m = not (registered l (mUnit m))

-- | Sum a wallet's holding of u across a wallet SET -- a monoid homomorphism into
--   the Qty group: the empty set sums to mempty, so a zero-holder unit conserves
--   vacuously (we sum, never divide; the dividend/len(holders) bug cannot arise).
--   The input is deduplicated so the reading is a set-sum: a wallet named twice is
--   summed once (matching `value`'s Set scope), never double-counted.
unitTotal :: Ledger -> [WalletId] -> UnitId -> Qty
unitTotal l ws u = foldMap (\w -> maybe mempty psBalance (position l w u))
                           (Set.toList (Set.fromList ws))

-- | Equality of ledgers BY OBSERVATION over the generated scope -- the only
--   equality the oracles need; the abstract Ledger exports no structural Eq.
sameLedger :: Scope -> Ledger -> Ledger -> Bool
sameLedger sc a b =
     and [ position a w u == position b w u | w <- scWallets sc, u <- scUnits sc ]
  && and [ unitStatus a u == unitStatus b u | u <- scUnits sc ]

-- P1 Conservation: on any accepted transaction, every unit's holdings sum to zero.
p1 :: Property TxInput Outcome
p1 = Property (\_ _ -> True) $ \_ (TxInput _ sc) o -> case o of
  Rejected _ -> True
  Accepted l -> all (\u -> unitTotal l (scWallets sc) u == mempty) (scUnits sc)

-- P2 Atomic commitment: if any move fails validation, the whole tx is rejected.
p2 :: Property TxInput Outcome
p2 = Property (\l (TxInput tx _) -> any (invalidMove l) (otMoves tx))
              (\_ _ o -> isRejected o)

-- P3 Referential integrity: every accepted move names a registered unit and in-scope wallets.
p3 :: Property TxInput Outcome
p3 = Property (\_ _ -> True) $ \_ (TxInput tx sc) o -> case o of
  Rejected _ -> True
  Accepted l -> all (\m -> registered l (mUnit m)
                        && inScope sc (mFrom m)
                        && inScope sc (mTo m)) (otMoves tx)

-- P7 Ledger isolation: with the virtual ledger's wallets as scope, no move crosses out.
p7 :: Property TxInput Outcome
p7 = Property (\_ (TxInput tx _) -> not (null (otMoves tx)))
     $ \_ (TxInput tx sc) _ ->
         all (\m -> inScope sc (mFrom m) && inScope sc (mTo m)) (otMoves tx)

-- P5 Transaction idempotency (dedup by tx_id): re-running an accepted tx is a no-op.
idempotentTx :: (Ledger -> OracleTx -> Outcome) -> Scope -> Ledger -> OracleTx -> Bool
idempotentTx exec sc l tx = case exec l tx of
  Rejected _  -> True
  Accepted l' -> case exec l' tx of
                   Accepted l'' -> sameLedger sc l' l''
                   Rejected _   -> False

-- P4 Log monotonicity: append-only, hash-chained by construction; the oracle re-checks the link.
newtype Hash = Hash Integer deriving (Eq)

data Hashed = Hashed { hPrev :: Hash, hPayload :: Transaction, hSelf :: Hash }

chainOK :: [Hashed] -> Bool
chainOK es = and (zipWith (\a b -> hPrev b == hSelf a) es (drop 1 es))

-- P8 Snapshot consistency: cloneAt t (replay up to t) must equal s_t by observation.
p8 :: Scope -> Ledger -> Ledger -> Bool
p8 = sameLedger

-- A lifecycle handler is a PURE TOTAL function; purity IS P9 (no effect to leak).
type LifecycleFn st ev = UnitId -> st -> ev -> ([Move], st)

-- P6 Lifecycle idempotency: feeding the handler its own output state emits no further moves.
idempotentL :: (Eq st) => LifecycleFn st ev -> UnitId -> st -> ev -> Bool
idempotentL f u st ev = let (_, st') = f u st ev in f u st' ev == ([], st')

-- P9 Lifecycle purity restated as the determinism witness -- true by the type.
pureL :: (Eq st) => LifecycleFn st ev -> UnitId -> st -> ev -> Bool
pureL f u st ev = f u st ev == f u st ev

-- Valid-transitions-only: outside the table the guarded handler returns Left.
validTransitionsOnly
  :: (p -> st -> ev -> Bool)
  -> (p -> st -> ev -> Either TxError ([Move], st))
  -> p -> st -> ev -> Bool
validTransitionsOnly inTable h p st ev
  | inTable p st ev = True
  | otherwise       = case h p st ev of Left _ -> True; Right _ -> False

-- P10 PnL path-independence: the price/flow decomposition must close to V_t1 - V_t0.
p10 :: Cash -> Cash -> Cash -> Cash -> Bool      -- pnlPrice pnlFlow V_t0 V_t1
p10 pnlPrice pnlFlow v0 v1 = pnlPrice <> pnlFlow == v1 <> cashNeg v0

-- Totality: `execute` is total into Outcome, whose two constructors are exhaustive.
total :: Outcome -> Bool
total (Accepted _) = True
total (Rejected _) = True
