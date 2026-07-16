{-# LANGUAGE GADTs              #-}
{-# LANGUAGE DataKinds          #-}
{-# LANGUAGE KindSignatures     #-}
{-# LANGUAGE StandaloneDeriving #-}

-- =============================================================================
-- StatesHome.hs  --  reference for Addendum A1 (StatesHome) of The Ledger v10.3.
--
-- Replaces the Python listing of the addendum's "Minimal Reference
-- Implementation". Goal: make the addendum's illegal states UNREPRESENTABLE and
-- keep every exported function TOTAL and DETERMINISTIC.
--
-- The export list below is part of the specification, not decoration:
--   * `Ledger` is exported ABSTRACT (no field setters) -- the only way to change
--     PositionState is `applyDelta`, which inserts/updates rows and NEVER deletes
--     one. There is deliberately no PS deleter anywhere. That absence IS the
--     monotone-carrier discipline (C1, storage half).
--   * `ValidDelta` is exported ABSTRACT -- the only way to build one is `validate`,
--     which discharges conservation (C2). An unconserved delta cannot reach
--     `applyDelta`. The illegal state "applied an unconserved delta" is unreachable.
--   * `ProductTerms` is exported ABSTRACT -- the only ways to grow it are
--     `register` (singleton) and `appendVersion` (append). There is no in-place
--     setter. That absence IS the append-only discipline (C6).
--
-- A note on numbers: quantities are exact `Integer` minor units, never `Float`
-- (the Python listing used `float`). Determinism and conservation are arithmetic
-- facts; floating point would forfeit both. This is the single deviation from the
-- Python and it is a correctness improvement, not a translation choice.
-- =============================================================================

module StatesHome
  ( -- * Scalars (exact, an additive abelian group)
    Qty (..), qneg, qmax
    -- * Keys
  , WalletId (..), UnitId (..)
    -- * Map 1: ProductTerms  (immutable, versioned, append-only -- C6/C7)
  , TermsVersion (..)
  , ProductTerms            -- abstract: no in-place setter is exported (C6)
  , currentTerms, allVersions, appendVersion
    -- * Map 2: UnitStatus    (mutable, shared across holders -- C5)
  , Lifecycle (..), UnitStatus (..), defaultStatus
    -- * Map 3: PositionState (per (w,u); Option accessor + monotone carrier -- C1)
  , PositionState (..), zeroP
    -- * C11: per-field canonical-writer tagging (a write names its handler in its type)
  , Handler (..), FieldWrite (..), SomeWrite (..), applyWrite, conserved
  , settleHandler, erase     -- the live authorship -> erasure pipeline (C11/S3)
    -- * Conservation (C2) as a group homomorphism into PosDelta
  , PosDelta (..)
    -- * Atomic, conservation-checked event delta (C2/C3)
  , StateDelta (..), ValidDelta, validate, ConservationError (..)
    -- * The ledger and its total operations
  , Ledger                  -- abstract: no row-deleter is exported (C1, monotone)
  , emptyLedger, register, applyDelta, replay
  , productTerms, unitStatus, position
  , LedgerError (..)
    -- * C8: two-track amendment
  , Fungibility (..), FungibilityPredicate, AmendResult (..), amend
    -- * Runnable example
  , main
  ) where

import           Control.Monad      (foldM)
import           Data.List          (foldl')
import           Data.List.NonEmpty (NonEmpty (..))
import qualified Data.List.NonEmpty as NE
import           Data.Map.Strict    (Map)
import qualified Data.Map.Strict    as Map

-- =============================================================================
-- Scalars.  Qty is the additive abelian group of exact minor units.
-- Conservation (C2) is a statement in THIS monoid: a conserving delta sums to
-- `mempty`. Using a monoid here is not ornament -- it is what lets the
-- zero-holder (vacuous) base case fall out for free: a sum over no wallets is
-- `mempty`, i.e. conserved, with no special case (C9).
-- =============================================================================

newtype Qty = Qty Integer deriving (Eq, Ord)
instance Show Qty where show (Qty n) = show n

instance Semigroup Qty where Qty a <> Qty b = Qty (a + b)
instance Monoid    Qty where mempty = Qty 0

qneg :: Qty -> Qty
qneg (Qty n) = Qty (negate n)

qmax :: Qty -> Qty -> Qty
qmax (Qty a) (Qty b) = Qty (max a b)

-- Keys.
newtype WalletId = WalletId String deriving (Eq, Ord, Show)
newtype UnitId   = UnitId   String deriving (Eq, Ord, Show)

-- =============================================================================
-- Map 1 -- ProductTerms : Map UnitId (NonEmpty TermsVersion)
--   immutable, versioned, APPEND-ONLY (C6), registration-total (C7).
--
-- `NonEmpty` makes "registered but versionless" unrepresentable: there is no
-- ProductTerms with zero versions, so `currentTerms` is total without a Maybe.
-- The type is abstract; the only growth operations are `register` (which builds
-- the singleton) and `appendVersion`. No setter exists -> C6 holds by absence.
-- =============================================================================

data TermsVersion = TermsVersion
  { tvLabel  :: String
  , tvFields :: Map String String   -- opaque terms payload (multiplier, ISIN, ...)
  } deriving (Eq, Show)

newtype ProductTerms = ProductTerms (NonEmpty TermsVersion) deriving (Show)

-- | The version in force = the most recently appended one. Total (NonEmpty).
currentTerms :: ProductTerms -> TermsVersion
currentTerms (ProductTerms vs) = NE.last vs

allVersions :: ProductTerms -> NonEmpty TermsVersion
allVersions (ProductTerms vs) = vs

-- | C6: the ONLY in-module mutation of terms. Append; never rewrite.
appendVersion :: TermsVersion -> ProductTerms -> ProductTerms
appendVersion tv (ProductTerms vs) = ProductTerms (vs <> (tv :| []))

-- =============================================================================
-- Map 2 -- UnitStatus : Map UnitId UnitStatus
--   mutable, SHARED across every holder of the unit (C5).
--
-- This is the "shared observable" sector: `last_settlement_price`, lifecycle,
-- `superseded_by`. Read identically by all holders -> it is environment, not
-- per-holder state (Reader / representable functor at the consuming layer; here
-- a plain shared cell, which is all this data reference needs).
-- =============================================================================

data Lifecycle = Listed | Active | Expired | Closed deriving (Eq, Show)

data UnitStatus = UnitStatus
  { usLifecycle    :: Lifecycle
  , usLastSettle   :: Maybe Qty       -- None at registration default (C5)
  , usSupersededBy :: Maybe UnitId    -- set by a Breaking amendment (C8)
  } deriving (Eq, Show)

-- | C5: product-declared default, applied at registration. `LISTED`, no settle
--   price, not superseded. Because `register` always writes this, `unitStatus`
--   is total on every registered unit.
defaultStatus :: UnitStatus
defaultStatus = UnitStatus Listed Nothing Nothing

-- =============================================================================
-- Map 3 -- PositionState : Map (WalletId, UnitId) PositionState
--   per (holder, unit). C1 has TWO orthogonal halves, both required:
--     (a) Option accessor  : `position` returns `Maybe PositionState`.
--           Nothing      = this wallet has NEVER held this unit.
--           Just zeroP   = held once, currently flat.
--         These cannot be collapsed (VM-settle, wash-sale lookback, record-date
--         entitlements all read the difference).
--     (b) Monotone carrier : a row, once created, is never deleted. Close-out
--         leaves a flat row. Enforced structurally: `applyDelta` only
--         inserts/updates, and no deleter is exported.
--
-- Field disciplines, demonstrating C11 (one canonical writer per field):
--   psAc       conserved, additive            <- Settle / Trade
--   psBalance  conserved, additive            <- Transfer
--   psHwm      NOT conserved, monotone (max)  <- FeeCrystallise
--   psEntryNav NOT conserved, write-once      <- Subscribe
-- Note: "held-and-flat" means psAc = psBalance = 0; psHwm / psEntryNav are
-- retained (final HWM kept for tax reporting -- addendum wind-down case).
-- =============================================================================

data PositionState = PositionState
  { psAc       :: !Qty
  , psBalance  :: !Qty
  , psHwm      :: !Qty
  , psEntryNav :: !(Maybe Qty)
  } deriving (Eq, Show)

-- | The flat row created on first touch (also the "held-and-flat" baseline).
zeroP :: PositionState
zeroP = PositionState mempty mempty mempty Nothing

-- =============================================================================
-- C11 -- per-field canonical-writer-set tagging, as a TYPE-LEVEL relation.
--
-- A `FieldWrite h` is a write performed BY handler `h`. The GADT constructors
-- ARE the C11 field->writer table; no other pairing is representable:
--     ac       writable by Settle and Trade   (two constructors)
--     balance  writable by Transfer
--     hwm      writable by FeeCrystallise
--     entryNav writable by Subscribe
-- Each event handler is typed by the Handler it speaks for. `settleHandler`
-- (defined below, and the source of `main`'s trade/close deltas) has output type
--     settleHandler :: ... -> Map WalletId [FieldWrite 'Settle]
-- so the phantom index constrains at a LIVE call site, not only in an alias. A
-- settle handler that tried to bump hwm would have to produce `WHwm`, whose type
-- is `FieldWrite 'FeeCrystallise`, and would fail to typecheck against the
-- declared `'Settle` output. C11's "mutation by any other handler is a type
-- error" is therefore literally a type error -- exercised by `settleHandler`,
-- with the static witnesses `_c11_ok_*` and the commented `_c11_bad` below.
-- =============================================================================

data Handler = Settle | Trade | Transfer | FeeCrystallise | Subscribe
  deriving (Eq, Show)

data FieldWrite (h :: Handler) where
  WAc       :: Qty -> FieldWrite 'Settle           -- ac, by settle
  WAcTrade  :: Qty -> FieldWrite 'Trade            -- ac, by trade
  WBalance  :: Qty -> FieldWrite 'Transfer         -- balance, by transfer
  WHwm      :: Qty -> FieldWrite 'FeeCrystallise   -- hwm, by fee crystallisation
  WEntryNav :: Qty -> FieldWrite 'Subscribe        -- entry_nav, by subscribe

deriving instance Show (FieldWrite h)

-- | Handler index erased for storage in a heterogeneous delta row. The index
--   was already checked at the point each handler authored its write (see the
--   EXPRESSIBILITY SIGNAL on C11 below).
data SomeWrite where
  SomeWrite :: FieldWrite h -> SomeWrite

instance Show SomeWrite where show (SomeWrite w) = show w

-- | Apply one field write to a row. Total over all constructors.
applyWrite :: FieldWrite h -> PositionState -> PositionState
applyWrite (WAc q)       p = p { psAc      = psAc p <> q }
applyWrite (WAcTrade q)  p = p { psAc      = psAc p <> q }
applyWrite (WBalance q)  p = p { psBalance = psBalance p <> q }
applyWrite (WHwm q)      p = p { psHwm     = qmax (psHwm p) q }                 -- monotone
applyWrite (WEntryNav q) p = p { psEntryNav = maybe (Just q) Just (psEntryNav p) } -- write-once

-- | A settle handler authors ONLY `'Settle` writes. Its result type
--   `Map WalletId [FieldWrite 'Settle]` IS the C11 checkpoint: this is the live
--   call site at which the phantom index constrains. A body that tried to bump
--   hwm would have to emit `WHwm :: FieldWrite 'FeeCrystallise` and could not
--   typecheck against this signature. `main` builds its trade/close deltas from
--   this handler, so C11 is exercised on the running path, not only in an alias.
settleHandler :: [(WalletId, Qty)] -> Map WalletId [FieldWrite 'Settle]
settleHandler legs = Map.fromList [ (w, [WAc q]) | (w, q) <- legs ]

-- | The S3 boundary, in code. Erase the per-handler index so heterogeneous
--   authored writes can share one delta row; authorship was already typechecked
--   at the handler's output type. After `erase` the row is `[SomeWrite]` and the
--   index is gone. This is the authorship -> erasure pipeline the addendum names.
erase :: Map WalletId [FieldWrite h] -> Map WalletId [SomeWrite]
erase = fmap (map SomeWrite)

-- =============================================================================
-- Conservation (C2) as a group homomorphism.
--
-- `conserved` maps each field write to its contribution in the abelian group
-- `PosDelta` of conserved-field deltas (ac, balance). Non-conserved fields
-- (hwm, entryNav) contribute the identity.
--
-- Totalling a delta over wallets is then a monoid homomorphism
--     Map WalletId [SomeWrite]  -->  PosDelta
-- and "conserving" means the image is `mempty`. State the law in words:
--     for every event class, the conserved fields sum to zero across wallets.
-- The categorical name is the LAST thing said, not the first: it is a group
-- homomorphism landing at the identity.
--
-- Per-event-class cases, all the same identity in `PosDelta`:
--   2-leg trade : WAc(+q) <> WAc(-q)            = mempty
--   K-leg       : <> of K balanced legs          = mempty
--   VM fan-out  : each wallet reset, cash offsets = mempty
--   vacuous     : <> over the EMPTY map          = mempty   (C9; no holders, no
--                 division by holder count -- the dividend/len(holders) bug
--                 class cannot arise because we sum deltas, never divide).
-- =============================================================================

data PosDelta = PosDelta { dAc :: !Qty, dBalance :: !Qty } deriving (Eq, Show)

instance Semigroup PosDelta where
  PosDelta a b <> PosDelta a' b' = PosDelta (a <> a') (b <> b')
instance Monoid PosDelta where
  mempty = PosDelta mempty mempty

conserved :: FieldWrite h -> PosDelta
conserved (WAc q)       = PosDelta q mempty
conserved (WAcTrade q)  = PosDelta q mempty
conserved (WBalance q)  = PosDelta mempty q
conserved (WHwm _)      = mempty
conserved (WEntryNav _) = mempty

-- =============================================================================
-- Atomic, conservation-checked StateDelta (C2 + C3).
--
-- A StateDelta is the proposed change for ONE event, across all three maps:
--   sdRows   : PositionState changes, keyed by wallet (the unit is sdUnit).
--   sdStatus : a replacement UnitStatus for the unit, if the event touches it.
--   sdAppend : a TermsVersion to append, if the event touches terms.
-- C3 (atomic, all-or-nothing) is structural: `applyDelta` returns the whole new
-- `Ledger` or a `Left`. There is no observable partially-applied state -- a
-- rejected delta (unconserved, caught by `validate`; or on an unregistered unit,
-- caught by `applyDelta`) leaves the prior ledger untouched.
-- =============================================================================

data StateDelta = StateDelta
  { sdUnit   :: UnitId
  , sdRows   :: Map WalletId [SomeWrite]
  , sdStatus :: Maybe UnitStatus
  , sdAppend :: Maybe TermsVersion
  } deriving (Show)

-- | C2 witness. Abstract: the ONLY constructor is `validate` (Show is for the
--   example's benefit; the data constructor is not exported).
newtype ValidDelta = ValidDelta StateDelta deriving (Show)

data ConservationError = NotConserved UnitId PosDelta deriving (Show)

-- | Discharge conservation. The conserved fold over the rows must be the
--   identity. `foldMap` over the `Map` folds its values; over `[SomeWrite]`
--   folds the list; the empty case is `mempty` (C9), so zero-holder events
--   validate with no special case.
validate :: StateDelta -> Either ConservationError ValidDelta
validate sd
  | net == mempty = Right (ValidDelta sd)
  | otherwise     = Left  (NotConserved (sdUnit sd) net)
  where
    net :: PosDelta
    net = foldMap (foldMap (\(SomeWrite w) -> conserved w)) (sdRows sd)

-- =============================================================================
-- The ledger.  Abstract: no field setter is exported, so no caller can delete a
-- PositionState row (monotone carrier, C1) or fabricate terms (C6) / a valid
-- delta (C2) from outside.
-- =============================================================================

data Ledger = Ledger
  { ledgerPT :: Map UnitId ProductTerms
  , ledgerUS :: Map UnitId UnitStatus
  , ledgerPS :: Map (WalletId, UnitId) PositionState
  }

data LedgerError
  = ReRegistration   UnitId   -- C10
  | UnitAlreadyExists UnitId   -- fresh-id collision in a Breaking amendment
  | UnknownUnit      UnitId
  deriving (Eq, Show)

emptyLedger :: Ledger
emptyLedger = Ledger Map.empty Map.empty Map.empty

-- | C5 + C7 jointly, by construction: `register` is the ONLY introducer of a
--   unit, and it writes BOTH ProductTerms and UnitStatus, establishing the
--   invariant "u registered in PT  <=>  u registered in US". Every other mutation
--   path PRESERVES it: `applyDelta` touches US/PT only for an already-registered
--   `sdUnit` (it rejects an unregistered one with `UnknownUnit`), and `amend`'s
--   Breaking track writes PT and US for the fresh unit together. The invariant is
--   thus preserved by construction across the whole module, not merely asserted.
--   C10: re-registration is a hard `Left`, never a silent reset.
register :: UnitId -> TermsVersion -> UnitStatus -> Ledger -> Either LedgerError Ledger
register u tv us l
  | u `Map.member` ledgerPT l = Left (ReRegistration u)        -- C10
  | otherwise = Right l
      { ledgerPT = Map.insert u (ProductTerms (tv :| [])) (ledgerPT l)  -- C7
      , ledgerUS = Map.insert u us                          (ledgerUS l)  -- C5
      }

-- | Apply a validated event to a ledger. Two failure modes, both typed:
--   conservation (already discharged by `validate`, so it cannot recur here) and
--   REGISTRATION -- a delta whose `sdUnit` is not registered is a hard
--   `Left (UnknownUnit u)`. The registration guard is what makes the PT<->US
--   invariant hold BY CONSTRUCTION rather than by assertion: because the guard
--   establishes `u` is in `ledgerPT` (the canonical registration test -- see
--   `register`), the UnitStatus write can only REPLACE an existing entry (it
--   cannot fabricate a half-registered unit), and the terms `Map.adjust` is
--   guaranteed to hit (the append can no longer vanish silently). Conservation
--   and registration are deliberately separated: `validate` is ledger-
--   independent (a pure conservation witness, valid in any ledger), so the
--   contextual registration check belongs here, at apply time, not baked into a
--   would-be-stale `ValidDelta`.
--   Atomic: returns the whole new ledger or a `Left`, never a partial state.
--   Monotone: rows are inserted/updated, never removed.
applyDelta :: ValidDelta -> Ledger -> Either LedgerError Ledger
applyDelta (ValidDelta sd) l
  | not (u `Map.member` ledgerPT l) = Left (UnknownUnit u)
  | otherwise = Right l
      { ledgerPS = Map.foldrWithKey applyRow (ledgerPS l) (sdRows sd)
      , ledgerUS = maybe (ledgerUS l)
                         (\us -> Map.insert u us (ledgerUS l))            -- replaces (u registered)
                         (sdStatus sd)
      , ledgerPT = maybe (ledgerPT l)
                         (\tv -> Map.adjust (appendVersion tv) u (ledgerPT l))  -- C6 append; hits (u registered)
                         (sdAppend sd)
      }
  where
    u = sdUnit sd
    applyRow w writes ps =
      let key = (w, u)
          cur = Map.findWithDefault zeroP key ps                  -- first touch -> flat row
          new = foldl' (\acc (SomeWrite fw) -> applyWrite fw acc) cur writes
      in  Map.insert key new ps                                   -- insert/update only

-- | Replay = a Kleisli fold of the event stream over the ledger. Determinism of
--   replay (P3) is the Kleisli homomorphism law: for event streams xs, ys,
--       replay (xs <> ys)  =  replay xs >=> replay ys
--   (composition in the `Either LedgerError` Kleisli category). Hence `replay
--   events` is independent of where a checkpoint is cut -- checkpoint-
--   independence is a CONSEQUENCE of the law, not a test. The monotone carrier
--   (C1) keeps the key set stable across cuts; on a well-formed stream (every
--   delta on a registered unit) no `Left` arises, so replay is total there.
replay :: [ValidDelta] -> Ledger -> Either LedgerError Ledger
replay ds l0 = foldM (\l d -> applyDelta d l) l0 ds

-- Accessors. Total. `Maybe` on PT/US distinguishes unregistered; on PS it is
-- the load-bearing C1 Option accessor (never-held vs held-and-flat).
productTerms :: Ledger -> UnitId -> Maybe ProductTerms
productTerms l u = Map.lookup u (ledgerPT l)

unitStatus :: Ledger -> UnitId -> Maybe UnitStatus
unitStatus l u = Map.lookup u (ledgerUS l)

position :: Ledger -> WalletId -> UnitId -> Maybe PositionState   -- C1 Option accessor
position l w u = Map.lookup (w, u) (ledgerPS l)

-- =============================================================================
-- C8 -- two-track amendment.
--
-- A product-declared, total predicate decides the track:
--     is_fungibility_preserving : ProductTerms -> TermsVersion -> Fungibility
--   Preserving -> append a TermsVersion to the SAME unit (C6); existing
--                 PositionState rows survive untouched.
--   Breaking   -> allocate a FRESH unit; stamp `superseded_by` on the old
--                 unit's status; the old unit's terms are NEVER rewritten
--                 (C7/P7). Re-subscription that moves holders old -> new is a
--                 separate paired-issuance event -- see the EXPRESSIBILITY
--                 SIGNAL on cross-unit conservation below.
-- =============================================================================

data Fungibility = Preserving | Breaking deriving (Eq, Show)

type FungibilityPredicate = ProductTerms -> TermsVersion -> Fungibility

data AmendResult
  = Appended   UnitId          -- Preserving: same unit, new version
  | Superseded UnitId UnitId   -- Breaking: old unit -> fresh unit
  deriving (Eq, Show)

amend :: FungibilityPredicate
      -> UnitId        -- ^ unit being amended
      -> TermsVersion  -- ^ the amendment
      -> UnitId        -- ^ caller-supplied fresh id (used only on the Breaking track)
      -> Ledger
      -> Either LedgerError (AmendResult, Ledger)
amend isFungible u tvNew uFresh l =
  case Map.lookup u (ledgerPT l) of
    Nothing -> Left (UnknownUnit u)
    Just pt -> case isFungible pt tvNew of
      Preserving ->
        Right ( Appended u
              , l { ledgerPT = Map.insert u (appendVersion tvNew pt) (ledgerPT l) } )
      Breaking
        | uFresh `Map.member` ledgerPT l -> Left (UnitAlreadyExists uFresh)
        | otherwise ->
            Right ( Superseded u uFresh
                  , l { ledgerPT = Map.insert uFresh (ProductTerms (tvNew :| [])) (ledgerPT l)
                      , ledgerUS = Map.insert uFresh defaultStatus
                                 $ Map.adjust (\s -> s { usSupersededBy = Just uFresh }) u
                                              (ledgerUS l)
                      } )

-- | C11, made concrete. These typecheck:
_c11_ok_settle :: Qty -> FieldWrite 'Settle
_c11_ok_settle = WAc
_c11_ok_fee    :: Qty -> FieldWrite 'FeeCrystallise
_c11_ok_fee    = WHwm
-- ...and this would NOT (uncomment to see the C11 type error):
--   _c11_bad :: Qty -> FieldWrite 'Settle
--   _c11_bad = WHwm        -- WHwm :: FieldWrite 'FeeCrystallise, not 'Settle

-- =============================================================================
-- EXPRESSIBILITY SIGNALS  (recorded, not contorted around)
-- -----------------------------------------------------------------------------
-- [S1] Cross-unit conservation for the Breaking-amendment re-subscription.
--      POINTS AT: the DESIGN / NOTATION (not this encoding).
--      Conservation is stated per unit: for each u, Sum_w df(w,u) = 0. A
--      re-subscription "moves" (w, u_old) -> (w, u_new); per unit that is NOT
--      zero-sum (one wallet gains on u_new with no offsetting wallet on u_new).
--      A single-unit StateDelta cannot express it. The faithful encoding is
--      PAIRED ISSUANCE: a burn on u_old (client -q, issuer +q ; sums to 0 on
--      u_old) and a mint on u_new (issuer -q, client +q ; sums to 0 on u_new),
--      applied atomically as two ValidDeltas. This is not a contortion -- it
--      surfaces exactly the addendum's own point that u_MA has a REAL issuer
--      (not the Dirac u_empty hack). The signal: state conservation as a
--      homomorphism INDEXED BY UNIT, and model re-subscription as paired
--      issuance, so `applyAll [burn, mint]` is the atomic re-subscription.
--
-- [S2] C4 (capability-scoped reads; cross-(w,u_MA) overlay reads forbidden) is
--      NOT expressed here. POINTS AT: the DESIGN -- read scoping is an
--      authority/effect concern at the boundary (a Reader of capabilities over
--      the accessors), not a shape of the stored data. Forcing it into this
--      pure data reference would buy nothing and add noise. It belongs in the
--      capability layer that wraps `position` / `unitStatus`.
--
-- [S3] C11's type-level guarantee holds at AUTHORSHIP, then is erased.
--      POINTS AT: a DESIGN TRADEOFF (restraint rule). The handler index on
--      `FieldWrite h` is checked where each handler declares its output type:
--      `settleHandler :: ... -> Map WalletId [FieldWrite 'Settle]`. `erase`
--      (= `fmap (map SomeWrite)`) is the boundary -- once heterogeneous writes
--      share a delta row they are wrapped in `SomeWrite` and the index is gone.
--      `main` builds `tradeSD`/`closeSD` as `erase . settleHandler`, so the
--      authorship -> erasure pipeline runs on the live path, not only in the
--      static `_c11_ok_*` witnesses. Re-proving canon at the row level would need
--      an indexed/heterogeneous list and buys nothing the authorship-site check
--      did not already buy. We stop at the cheaper guarantee on purpose.
--
-- [S4] Conservation cannot be a pure TYPE fact (the addendum's own C2 point:
--      refinement types on decimal sums are not free). We use a value-level
--      smart constructor (`validate` -> `ValidDelta`) returning `Either`. This
--      is the correct boundary, acknowledged, not awkward: types make the
--      *unchecked* delta unable to reach `applyDelta`; the *check itself* is a
--      one-line monoid identity.
-- =============================================================================

-- =============================================================================
-- Runnable example.  `runghc StatesHome.hs`  (or load in GHCi and run `main`).
-- The `expect*` helpers are demo glue and are the only partial code in the file;
-- the library above is total. They fail loudly only on an outcome the example
-- asserts cannot happen.
-- =============================================================================

expect :: Show e => Either e a -> IO a
expect = either (\e -> error ("unexpected Left: " <> show e)) pure

main :: IO ()
main = do
  let uES    = UnitId "CME-ES"      -- a future (CME-ES and ICE-ES are DISTINCT units)
      uMA    = UnitId "MANDATE-7"   -- a managed-account mandate, itself a unit
      wBuyer = WalletId "BUYER"
      wSeller= WalletId "SELLER"

  -- Registration (C5 + C7): PT and US written together.
  l0 <- expect $ register uES (TermsVersion "ES-v1"
                    (Map.fromList [("multiplier","50"),("ccy","USD")])) defaultStatus emptyLedger
  l1 <- expect $ register uMA (TermsVersion "MA-v1"
                    (Map.fromList [("fee","0.02")])) defaultStatus l0

  putStrLn "== untraded instrument (C1 None; US total) =="
  print (position l1 wBuyer uES)            -- Nothing : never held
  print (unitStatus l1 uES)                 -- Just (UnitStatus Listed Nothing Nothing)

  putStrLn "== conserving Trade (C2/C3): buyer +1000, seller -1000 =="
  let tradeSD = StateDelta uES
        -- C11 authored at type `Map WalletId [FieldWrite 'Settle]`, then S3-erased:
        (erase (settleHandler [ (wBuyer , Qty   1000 )
                              , (wSeller, Qty (-1000)) ]))
        Nothing Nothing
  vTrade <- expect (validate tradeSD)
  l2 <- expect (applyDelta vTrade l1)
  print (position l2 wBuyer  uES)           -- Just (ac=1000)
  print (position l2 wSeller uES)           -- Just (ac=-1000)

  putStrLn "== non-conserving delta is REJECTED (cannot reach applyDelta) =="
  let badSD = StateDelta uES
        (Map.fromList [(wBuyer, [SomeWrite (WAc (Qty 1000))])]) Nothing Nothing
  print (validate badSD)                    -- Left (NotConserved CME-ES (PosDelta 1000 0))

  putStrLn "== zero-holder lifecycle event validates vacuously (C9) =="
  let lifeSD = StateDelta uMA Map.empty (Just defaultStatus { usLifecycle = Active }) Nothing
  vLife <- expect (validate lifeSD)         -- empty fold = mempty : conserved
  l3 <- expect (applyDelta vLife l2)
  print (usLifecycle <$> unitStatus l3 uMA) -- Just Active ; no PS rows created
  print (position l3 (WalletId "ANY") uMA)  -- Nothing

  putStrLn "== close-out keeps a flat row (monotone carrier; held-and-flat /= never-held) =="
  let closeSD = StateDelta uES
        -- same C11 settle authorship, S3-erased into the delta row:
        (erase (settleHandler [ (wBuyer , Qty (-1000))
                              , (wSeller, Qty   1000 ) ]))
        Nothing Nothing
  vClose <- expect (validate closeSD)
  l4 <- expect (applyDelta vClose l3)
  print (position l4 wBuyer uES)            -- Just (ac=0) : retained, NOT Nothing

  putStrLn "== amendment, Preserving track (C8/C6): append a version =="
  (r1, l5) <- expect $ amend feePreserving uES
                 (TermsVersion "ES-v2" (Map.fromList [("multiplier","50"),("ccy","USD")]))
                 (UnitId "unused") l4
  print r1                                  -- Appended CME-ES
  print (tvLabel . currentTerms <$> productTerms l5 uES)  -- Just "ES-v2"
  print (length . NE.toList . allVersions <$> productTerms l5 uES)  -- Just 2

  putStrLn "== amendment, Breaking track (C8): fresh unit + SupersededBy =="
  (r2, l6) <- expect $ amend isinBreaking uMA
                 (TermsVersion "MA-v2-newISIN" Map.empty) (UnitId "MANDATE-7b") l5
  print r2                                  -- Superseded MANDATE-7 MANDATE-7b
  print (usSupersededBy <$> unitStatus l6 uMA)  -- Just (Just (UnitId "MANDATE-7b"))
  print (tvLabel . currentTerms <$> productTerms l6 (UnitId "MANDATE-7b"))  -- Just "MA-v2-newISIN"

  putStrLn "== delta on an UNREGISTERED unit is REJECTED (PT<->US invariant preserved) =="
  let ghostSD = StateDelta (UnitId "GHOST") Map.empty (Just defaultStatus) Nothing
  vGhost <- expect (validate ghostSD)       -- validates vacuously (empty fold = mempty)
  print (applyDelta vGhost l6)              -- Left (UnknownUnit (UnitId "GHOST")) : no half-registered unit
  print (unitStatus l6 (UnitId "GHOST"))    -- Nothing : US never fabricated for an unregistered unit

  putStrLn "== re-registration is a hard error (C10) =="
  print (register uES (TermsVersion "dup" Map.empty) defaultStatus l6)
                                            -- Left (ReRegistration (UnitId "CME-ES"))

-- Example fungibility predicates (product-declared, total).
feePreserving :: FungibilityPredicate
feePreserving _ _ = Preserving   -- fee tweak within declared band: fungibility preserved
isinBreaking :: FungibilityPredicate
isinBreaking _ _ = Breaking      -- new ISIN: fungibility broken -> fresh unit
