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
--     is restated as the §11 `Balances` monoid (Part B), the same projection
--     written once as `foldMap`. The §2 Move algebra (conservation) and
--     §11 balance projection are both kept.
--
--   * Genuinely distinct subsystems keep distinct names so the whole compiles
--     with no shadowing: §10's fee record (Part D) is `FeeEvent`, to avoid
--     colliding with the Handler constructor `FeeCrystallise` / the promoted
--     index 'FeeCrystallise; the settlement boundary (Part H) names its move
--     `SettleMove` and its transaction `SettlementTx`; the CDM layer (Part I) uses
--     `CdmTransaction`; the futures engine (Part K) is `Fut*`-prefixed; the
--     obligation handler (Part J) is `ob*`-prefixed; the property oracles
--     (Part L) use `OracleTx`; App. D's pricer (Part F) is `statePrice`,
--     because `priceOf` is the PriceVec selector of Part E. Each rename is
--     noted against its section.
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
--   * `StampedObs` / `BasisView` (Part M) are exported WITHOUT constructors: a
--     stamped observation exists only as the Right image of the ingest door, and
--     a basis view is a read-only value -- the market-data boundary's two arrows
--     are enforced by the export list, not by convention.
-- =============================================================================

module Ledger
  ( -- * Part A -- shared scalars (an additive abelian group; exact minor units)
    Qty (..), qneg, negQty, qmax
  , Cash (..), cashNeg, cashSub
  , Price (..), Quote (..)
  , BasisId (..), BoundaryId   -- BoundaryId ABSTRACT: a content address is never minted here
  , WalletId (..), UnitId (..), Timestamp (..), SourceId (..)
    -- * Part B -- the economic Move, conservation (§2) and balances (§11)
  , Move (..), move
  , Balances (..), contribution, balances, netBal
    -- * Part C -- dimensions, the adjustment schedule and the closed CA taxonomy
    --   (D3 / Ruling 2b): every terms field carries its dimension by
    --   construction; the schedule is total over the closed CAClass enum (C14)
  , Dim (..), NonQtyDim, nonQtyDim, unNonQtyDim
  , TermsValue (..), dimOf
  , CAClass (..)
  , Expr (..), Rule (..), Schedule (..), emptySchedule
  , PriceTermsDefault (..), priceTermsDefault, classDefault
  , scheduleRule, ruleWellFormed, scheduleTotalOK
  , evalExpr, evalRule, transportField, transportVersion
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
  , BoundaryEvent (..), Declaration (..)
  , registerTx, appendTx, supersedeTx, withCause, canonicalTx
    -- * Part C -- the ledger and its total operations
  , Ledger, emptyLedger, register, applyTx, replay
  , productTerms, unitStatus, position, LedgerError (..)
    -- * Part C -- two-track amendment (C8)
  , Fungibility (..), FungibilityPredicate, AmendResult (..), amend
    -- * Part D -- fee crystallisation and issuance moves (§10)
  , usd, moveDelta, issueMandate, crystallise
  , FeeEvent (..), crystalliseFees
    -- * Part E -- valuation and PnL (§5)
  , PriceVec (..), Portfolio, mkPortfolio, Snapshot (..), markValue, value, pnl
    -- * Part F -- state-aware pricing (App. D)
  , Distribution (..), Market (..), statePrice
    -- * Part G -- generalised positions and SBL (§16)
  , Position (..), zeroPos, avail, possess, encumb, Coord (..), applyMove
    -- * Part G (continued) -- locates (§16.14): the kernel, the P26 oracle,
    --   its companion witnesses, and their generator and shrinker
  , LenderId (..), LocateId (..), LocateKind (..), LocOrigin (..)
  , LocState (..), Locate (..), locActive
  , LocLedger, locEmpty, locPosOf, locHoldOf, locReserved, locAtl
  , LocCmd (..), LocDecision (..), locStep, locRun
  , p26, locSplitOK, locConvertNeutralOK, locDrawMonotoneOK
  , genLocCmds, shrinkLocCmds
    -- * Part H -- the settlement-layer interface (§13)
  , Day (..), TxId (..), ISIN (..), Currency (..), LEI (..), MIC (..)
  , Asset (..), SettleMove (..), TxClass (..), settles
  , CdmPayload (..), SettlementTx (..)
  , SecuritiesLeg (..), CashLeg (..)
  , SettlementLegs (..), SettlementType (..), settlementType
  , SettlementInstruction (..), settleProjection, signedFor, reconciles
    -- * Part I -- the ISDA-CDM forgetful map (§14)
  , Intent (..), LifecycleState (..), TradeState (..)
  , PrimitiveInstruction (..), BusinessEvent (..)
  , CdmTransaction (..), instructionMoves, forget
    -- * Part J -- obligation liveness (§15)
  , ObId (..), Source (..), Time (..), ObType (..), OblView (..)
  , Obligation (..), Live (..), Terminal (..), ObState (..), Trigger (..), obStep
    -- * Part K -- the futures lifecycle engine (§9)
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
  , effTip, p24, fibreOK
    -- * Part L (continued) -- the D1-D4 witnesses: P27 producer agreement and
    --   its terms leg, P28 cause committed, P29 schedule totality (C14),
    --   P30 dimension invariance with its G2 rider, and the G2 stand witness
    --   (P32-P34 are conformance-tier: documented, not suite code -- their
    --   executable form lives where `transport` lives)
  , recomputeOK, propTermsRecompute, pCauseCommitted
  , propScheduleTotalGate, propDimInvariance
  , propOrdDivTermsStand, propClassDefaultTable
    -- * Part L (continued) -- WILSON blind-spot closers: the invariance weld on
    --   REAL booked holders (BS-1), the schedule-override lookup evaluated and
    --   observed (BS-2), and P27 as an end-to-end producer trial (BS-5)
  , weldHolderOK, scheduleOverrideOK, producerE2EOK
    -- * Part M -- the market-data boundary (§8): the basis projection (read-only,
    --   a view of the log), the stamp envelope, the ingest door factoring, and
    --   the ingestion property catalogue with its generators and shrinkers
  , BasisView, basisView, viewAsOf, betaAt, chainAt, onChain, viewVersion
  , ViewVersion, ConvVersion (..), Convention (..), RawDatum (..)
    -- * Part M (continued) -- the datum-kind registry (D4/E3): kinds are
    --   registered vocabulary with mandatory invariance witnesses; the registry
    --   projection rides the pinned view (soView), and the door refuses an
    --   unregistered kind (P31)
  , KindId (..), KindWitness (..), DatumKind (..)
  , kindRegistry, withKinds, kindAt, baseKinds
  , pKindTotal, dkDivSplitOK
  , StampedObs, obsValue, obsTime, obsSource, obsStamp, obsView, obsConv
  , IngestError (..), retained
  , ingest, ingestAt, ingestRun, ingestResume, partitionByStamp
  , p25, pDet, pMode, pPermN, pPermO, pCrash, pRepro, pCloneStamp, pLag
  , pPartition
  , Seed (..), splitSeed, nextInt, permuteBy, permuteBoundariesBy, rebook
  , genRawDatum, genVendorBehaviour, genStampedObs
  , genFeed, genPerm, genCrashPoint
  , shrinkInteger, shrinkRawDatum, shrinkVendorBehaviour
  , shrinkStampedObs, shrinkFeed, shrinkPerm, shrinkCrashPoint
  , mintBoundary, genBoundaryEvent, shrinkBoundaryEvent
  , genChain, shrinkChain, genBoundaryStraddle
  , genTermsValue, shrinkTermsValue, genTermsVersion, shrinkTermsVersion
  , genCauseLog
  ) where

import           Control.Monad      (foldM)
import           Data.Either        (partitionEithers)
import           Data.List          (sortOn)
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

negQty :: Qty -> Qty               -- the §2/§13 spelling of qneg
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

-- The corporate-action basis (state basis) coordinate (§state-basis). A BasisId of a
-- unit is its origin or a corporate-action Boundary crossed -- a content address,
-- never an ordinal, so a retro-effective boundary renumbers no stored value.
-- BoundaryId is exported ABSTRACT: the address of a boundary event is assigned by
-- content at the attested notice gateway, never minted by a caller.
newtype BoundaryId = BoundaryId String deriving (Eq, Ord, Show)

data BasisId = Origin UnitId | Boundary BoundaryId
  deriving (Eq, Ord, Show)

-- =============================================================================
-- PART B -- the economic Move (§2), conservation, and the balance projection (§11).
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

-- | The balance projection (§11). The monoid is POINTWISE addition -- NOT the
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

-- -----------------------------------------------------------------------------
-- Dimensions and the adjustment schedule (D3 / sec:state-basis).
--
-- Every terms field carries one of FOUR dimensions, and the dimension IS the
-- constructor: an unclassified terms field is unconstructible, not merely
-- unchecked. The re-expression map of a declared boundary (f, c) is ONE
-- total function, `transportField` -- quantities scale by f, price-in-basis
-- values move by (p - c)/f, cash and dimensionless values are fixed -- so the
-- N x M "one rule per (event, field) pair" failure collapses to N + M: each
-- field declares its dimension once, each event declares (f, c) once. The
-- schedule's LAYER-1 DEFAULT is the closed (CAClass x dimension) table
-- `classDefault` (G2): every dimension follows `transportField` except that a
-- price-in-basis field under an ordinary dividend STANDS -- anticipated
-- distributions are priced at inception and never re-struck. Quotes are
-- unaffected: they cross at the ingest seam, not through the schedule.
-- -----------------------------------------------------------------------------

data Dim
  = DimQuantity   -- quantity-of-u: scales by the declared factor f
  | DimPrice      -- price-in-basis: p -> (p - c) / f
  | DimCash       -- absolute cash: fixed under a basis change
  | DimNone       -- dimensionless (labels, identifiers, ratios): fixed
  deriving (Eq, Ord, Show, Enum, Bounded)

-- | The non-quantity gate (D4's micro-fork ruling): the datum-kind registry
--   declares component dimensions through THIS door, so a quantity-dimensioned
--   datum component is unrepresentable -- observations are never entitlements.
--   Abstract: `nonQtyDim` is the sole constructor.
newtype NonQtyDim = NonQtyDim Dim deriving (Eq, Ord, Show)

nonQtyDim :: Dim -> Maybe NonQtyDim
nonQtyDim DimQuantity = Nothing
nonQtyDim d           = Just (NonQtyDim d)

unNonQtyDim :: NonQtyDim -> Dim
unNonQtyDim (NonQtyDim d) = d

-- The dimensioned terms value: dimension = constructor. TVFree is the opaque
-- dimensionless carrier (ISIN, venue, label); the three numeric constructors
-- carry exact Rationals so the per-dimension action is exact arithmetic.
data TermsValue
  = TVQty   Rational   -- quantity-of-u
  | TVPrice Rational   -- price-in-basis (strike, cap, barrier)
  | TVCash  Rational   -- absolute cash (a fixed fee)
  | TVFree  String     -- dimensionless, opaque
  deriving (Eq, Show)

dimOf :: TermsValue -> Dim   -- total: the classification is the constructor
dimOf (TVQty   _) = DimQuantity
dimOf (TVPrice _) = DimPrice
dimOf (TVCash  _) = DimCash
dimOf (TVFree  _) = DimNone

-- | The per-dimension action of a declared boundary (f, c) -- the gloss repair
--   in executable form. Total via Maybe: the degenerate factor f == 0 is
--   refused here exactly as `requireInvariance` refuses it at admission.
--   law (P30): transportField 1 0 v == Just v   for every v (neutral boundary).
transportField :: Rational -> Rational -> TermsValue -> Maybe TermsValue
transportField f _ _ | f == 0 = Nothing
transportField f _ (TVQty   q) = Just (TVQty   (q * f))
transportField f c (TVPrice p) = Just (TVPrice ((p - c) / f))
transportField _ _ (TVCash  x) = Just (TVCash  x)
transportField _ _ (TVFree  s) = Just (TVFree  s)

-- The closed corporate-action taxonomy (Ruling 2b). Eight members, closed:
-- extending CAClass is a change to the SPECIFICATION, never a change to data;
-- a notice outside the eight classes is refused at the door, fail-closed.
-- The class is DECLARED data of the attested notice (the exchange's own
-- adjustment decision), never inferred from an event's name. Excluded by
-- construction: delisting-with-continuation (a venue fact, no boundary event)
-- and non-corporate-action TermsChange (no declaration).
data CAClass
  = CASplit             -- stock split, reverse split, stock dividend: any pure ratio event
  | CADividendOrdinary  -- ordinary cash distribution / coupon detachment
  | CADividendSpecial   -- special/extraordinary cash distribution, return of capital
  | CASpinOff
  | CAMergerStock       -- stock-for-stock succession
  | CAMergerElective    -- elective / mixed consideration, tender with proration
  | CATermination       -- merger for cash, liquidation, delisting with termination
  | CARebalance         -- index composition / divisor change
  deriving (Eq, Ord, Show, Enum, Bounded)

-- -----------------------------------------------------------------------------
-- The layer-1 class default (G2): a CLOSED (CAClass x dimension) table.
--
-- Only the price-in-basis dimension varies by class, so the table collapses
-- to one two-valued function on the closed enum: does the class RE-EXPRESS a
-- price field through `transportField` ((p - c)/f), or does the price STAND?
-- Declared once here; extending it is a change to the SPECIFICATION. The
-- quantity, cash, and dimensionless actions are class-independent -- they
-- follow `transportField` under every class, so conservation of the
-- per-dimension action needs no per-class argument.
--
-- Class/parameter COHERENCE (recorded, not gated): the class and the declared
-- (f, c) are BOTH attested data of the same notice (W4), and their coherence
-- -- an ordinary dividend declares f = 1, a rebalance declares (1, 0) -- is
-- the attesting authority's obligation, not this module's: `requireInvariance`
-- checks the arithmetic weld against (f, c) and never class coherence. An
-- incoherent declaration (CADividendOrdinary with f /= 1) therefore evaluates
-- by the table -- quantities scale, prices stand -- exactly as declared; the
-- trust boundary is the attestation, stated here so the absence of a
-- coherence gate is a decision on record, not an oversight (FORMALIS G2
-- review, MEDIUM-3).
-- -----------------------------------------------------------------------------

data PriceTermsDefault = ReExpress | Stand
  deriving (Eq, Show)

priceTermsDefault :: CAClass -> PriceTermsDefault
priceTermsDefault CASplit            = ReExpress
priceTermsDefault CADividendOrdinary = Stand      -- anticipated: priced at inception, never re-struck
priceTermsDefault CADividendSpecial  = ReExpress  -- make-whole (listed: ByParty exchange)
priceTermsDefault CASpinOff          = ReExpress
priceTermsDefault CAMergerStock      = ReExpress
priceTermsDefault CAMergerElective   = ReExpress
priceTermsDefault CATermination      = ReExpress  -- vacuous under Terminal
priceTermsDefault CARebalance        = ReExpress  -- a rebalance declares (1,0): identity

-- | The layer-1 default action, total via Maybe. The degenerate factor is
--   refused FIRST -- before the Stand dispatch -- so `classDefault` refuses
--   exactly where `transportField` refuses, on every dimension and class;
--   a price field then dispatches on the class table, and every other
--   dimension follows `transportField` verbatim.
--   law (P30 rider): classDefault cls 1 0 v == Just v  for EVERY cls -- the
--   neutral boundary is the identity under every class (Stand and ReExpress
--   coincide at (1, 0)).
classDefault :: CAClass -> Rational -> Rational -> TermsValue -> Maybe TermsValue
classDefault _ f _ _ | f == 0 = Nothing
classDefault cls f c v@(TVPrice _) = case priceTermsDefault cls of
  ReExpress -> transportField f c v
  Stand     -> Just v
classDefault _ f c v = transportField f c v

-- -----------------------------------------------------------------------------
-- The adjustment schedule: three layers, total over CAClass x field (C14).
--
--   1. Class default -- absent an override, a field follows the closed
--      (CAClass x dimension) table (`classDefault`: `transportField` on every
--      cell except ordinary-dividend prices, which stand); this alone makes
--      the schedule total.
--   2. Declared override -- a CLOSED first-order rule AST, total by
--      construction: expressions over (f, c, field) with +/-/x only (no
--      division, no recursion, no names), so evaluation cannot diverge and
--      cannot divide by zero. The worked example -- "a special dividend adjusts
--      the strike only above EUR 0.50, by the excess" -- is
--        RWhen ECash (ELit (1/2))
--              (RSet (ESub EField (ESub ECash (ELit (1/2)))))
--              (RSet EField)
--      declared at (CADividendSpecial, "strike").
--   3. Designated discretion -- RByParty names the deciding authority
--      (exchange, clearing house); the adjustment then lands as W4-attested
--      RESOLVED TERMS, and until they land, evaluation is Nothing: fail-closed,
--      never a guessed arrow.
-- -----------------------------------------------------------------------------

-- Closed expression alphabet over the declared parameters and the field value.
data Expr
  = EField            -- the field's current numeric value
  | EFactor           -- the declared quantity factor f
  | ECash             -- the declared per-unit cash c
  | ELit Rational
  | EAdd Expr Expr
  | ESub Expr Expr
  | EMul Expr Expr
  deriving (Eq, Show)

-- | Total: structural recursion over a finite AST; EField on the opaque
--   dimensionless carrier is Nothing (there is no number to read), and every
--   composite propagates the refusal -- fail-closed, never a default.
evalExpr :: Rational -> Rational -> Maybe Rational -> Expr -> Maybe Rational
evalExpr _ _ mv EField      = mv
evalExpr f _ _  EFactor     = Just f
evalExpr _ c _  ECash       = Just c
evalExpr _ _ _  (ELit r)    = Just r
evalExpr f c mv (EAdd a b)  = (+) <$> evalExpr f c mv a <*> evalExpr f c mv b
evalExpr f c mv (ESub a b)  = (-) <$> evalExpr f c mv a <*> evalExpr f c mv b
evalExpr f c mv (EMul a b)  = (*) <$> evalExpr f c mv a <*> evalExpr f c mv b

data Rule
  = RDefault              -- layer 1: the class default (classDefault)
  | RSet  Expr            -- layer 2: write the expression's value, same dimension
  | RWhen Expr Expr Rule Rule  -- layer 2: if e1 > e2 then rule else rule
  | RByParty String       -- layer 3: designated discretion; resolves only to
                          --   attested resolved terms -- Nothing until they land
  deriving (Eq, Show)

-- | Does an expression read the field's value? A condition that reads EField
--   on the opaque dimensionless carrier can never evaluate (fieldNum is
--   Nothing there), so C14 must refuse such an entry at the door rather than
--   admit one that quarantines forever -- the only sanctioned indefinite
--   refusal is layer 3, RByParty.
exprReadsField :: Expr -> Bool
exprReadsField EField     = True
exprReadsField EFactor    = False
exprReadsField ECash      = False
exprReadsField (ELit _)   = False
exprReadsField (EAdd a b) = exprReadsField a || exprReadsField b
exprReadsField (ESub a b) = exprReadsField a || exprReadsField b
exprReadsField (EMul a b) = exprReadsField a || exprReadsField b

-- | Rule well-formedness against the field's dimension: an RSet writes a
--   number, so it is well-formed on the three numeric dimensions only; a
--   conditional is well-formed iff both branches are AND its condition
--   expressions do not read the field on the opaque carrier (well-formed
--   implies transport-evaluable up to RByParty, by construction); a
--   designation must name its party. Read by the C14 gate and by P29.
ruleWellFormed :: Dim -> Rule -> Bool
ruleWellFormed _ RDefault          = True
ruleWellFormed d (RSet _)          = d /= DimNone
ruleWellFormed d (RWhen e1 e2 a b) =
     (d /= DimNone || not (exprReadsField e1 || exprReadsField e2))
  && ruleWellFormed d a && ruleWellFormed d b
ruleWellFormed _ (RByParty p)      = not (null p)

-- | Evaluate one rule at the declared (f, c), under the notice's declared
--   class -- the class reaches ONLY the `RDefault` occurrences, WHEREVER they
--   sit (G2): a declared `RSet`/`RByParty` says what it does explicitly, so
--   the table has nothing to add there, while an `RDefault` nested in an
--   `RWhen` branch denotes the class default at that occurrence too --
--   `RDefault` has ONE meaning everywhere, never two (FORMALIS G2 review,
--   MEDIUM-1). Total via Maybe; Nothing is the fail-closed refusal
--   (degenerate factor, a numeric write on the opaque carrier, a designation
--   whose resolved terms have not landed).
evalRule :: CAClass -> Rule -> Rational -> Rational -> TermsValue -> Maybe TermsValue
evalRule cls RDefault         f c v = classDefault cls f c v
evalRule _   (RSet e)         f c v = evalExpr f c (fieldNum v) e >>= setNum v
evalRule cls (RWhen a b t e)  f c v = do
  x <- evalExpr f c (fieldNum v) a
  y <- evalExpr f c (fieldNum v) b
  evalRule cls (if x > y then t else e) f c v
evalRule _   (RByParty _)     _ _ _ = Nothing

fieldNum :: TermsValue -> Maybe Rational
fieldNum (TVQty   q) = Just q
fieldNum (TVPrice p) = Just p
fieldNum (TVCash  x) = Just x
fieldNum (TVFree  _) = Nothing

setNum :: TermsValue -> Rational -> Maybe TermsValue   -- same-dimension write
setNum (TVQty   _) x = Just (TVQty   x)
setNum (TVPrice _) x = Just (TVPrice x)
setNum (TVCash  _) x = Just (TVCash  x)
setNum (TVFree  _) _ = Nothing

-- The schedule: declared overrides and designations, keyed by (class, field).
-- A Map, so AT MOST one declared entry per cell holds by construction; the
-- class default fills every undeclared cell -- "exactly one entry per
-- (CAClass x field)" (C14) then has exactly one refusal channel left: a
-- declared entry that is ill-formed, or one that dangles off the field set.
newtype Schedule = Schedule (Map (CAClass, String) Rule) deriving (Eq, Show)

emptySchedule :: Schedule
emptySchedule = Schedule Map.empty

-- | The one entry a cell yields: the declared override when present, the
--   class default otherwise. Total.
scheduleRule :: Schedule -> CAClass -> String -> Rule
scheduleRule (Schedule m) cls fn = Map.findWithDefault RDefault (cls, fn) m

-- | C14's predicate: over EVERY class of the closed enum and every field of
--   the version being written, the schedule yields exactly one well-formed
--   entry, and no declared entry names an absent field. Enforced at the door
--   (`applyTx` refuses ScheduleIncomplete on registration and on every append
--   -- an append that introduces fields carries its own schedule in the SAME
--   transaction, so the extension rule holds by construction); witnessed by
--   P29. A declared entry that is ill-formed refuses -- it does NOT fall
--   through to the default: fail-closed, never a silent repair.
scheduleTotalOK :: TermsVersion -> Bool
scheduleTotalOK tv =
     and [ ruleWellFormed (dimOf v) (scheduleRule sch cls fn)
         | cls <- [minBound .. maxBound] :: [CAClass]
         , (fn, v) <- Map.toList (tvFields tv) ]
  && all (\(_, fn) -> fn `Map.member` tvFields tv) (Map.keys declared)
  where sch@(Schedule declared) = tvSchedule tv

-- | The terms leg of the P27 differential (D3 N7): the transported version --
--   every field through its scheduled rule at the declared (f, c) -- computed
--   by the reference itself. Nothing when any field's rule refuses (fail-closed
--   as one version: all-or-nothing, the C3 discipline at the terms plane).
transportVersion :: CAClass -> Rational -> Rational -> TermsVersion -> Maybe TermsVersion
transportVersion cls f c tv =
  (\fs -> tv { tvFields = fs })
    <$> Map.traverseWithKey
          (\fn v -> evalRule cls (scheduleRule (tvSchedule tv) cls fn) f c v)
          (tvFields tv)

data TermsVersion = TermsVersion
  { tvLabel    :: String
  , tvFields   :: Map String TermsValue   -- dimensioned terms payload (D3): the
                                          --   field name stays an open string; the
                                          --   dimension closes semantics, not names
  , tvSchedule :: Schedule                -- the adjustment schedule IS terms: same
                                          --   confirmation, same authority, so it
                                          --   inherits C6/C7 instead of duplicating
                                          --   them behind a weld
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
  , usBasis        :: BasisId                 -- corporate-action basis; tip-welded (sec:state-basis)
  , usLastSettle   :: Maybe (Price, BasisId)  -- a settle mark names its basis; None at default (C5)
  , usSupersededBy :: Maybe UnitId            -- set only by a Breaking amendment (C8)
  } deriving (Eq, Show)

defaultStatus :: UnitId -> UnitStatus -- C5: the per-unit default written at registration;
defaultStatus u = UnitStatus Registered (Origin u) Nothing Nothing
                                      --   the basis origin is forced by the unit itself

-- C11 (UnitStatus half): each StatusWrite constructor is the ONE canonical writer
-- of its field, and `applyStatus` is the only function that writes a status field.
data StatusWrite                      -- the closed status-writer set; each names ONE field
  = SetLifecycle    Lifecycle         -- a lifecycle event
  | SetBasis        BasisId           -- a corporate-action boundary crossed (sec:state-basis)
  | SetLastSettle   (Price, BasisId)  -- a settle event (a logged observation)
  | SetSupersededBy UnitId            -- a Breaking amendment (C8)
  deriving (Eq, Show)

applyStatus :: StatusWrite -> UnitStatus -> UnitStatus   -- the ONLY writer of a status field;
applyStatus (SetLifecycle l)    s = s { usLifecycle    = l }      -- total; every equation an
applyStatus (SetBasis b)        s = s { usBasis        = b }      -- ABSOLUTE replacement write,
applyStatus (SetLastSettle m)   s = s { usLastSettle   = Just m } -- never an increment:
applyStatus (SetSupersededBy u) s = s { usSupersededBy = Just u } -- last-write-wins, idempotent (P6)

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

-- Structural equality across the erased handler index -- the P27 diff compares
-- authored writes: equal iff same constructor, same payload. (The index was
-- checked at authorship; equality of the stored write does not resurrect it.)
-- Routed through a TOTAL closed-case discriminator, no catch-all: a fifth
-- FieldWrite constructor is then an incomplete-pattern error here under
-- -Wall -Werror, not a silent reflexivity break.
instance Eq SomeWrite where
  a == b = tagOf a == tagOf b
    where
      tagOf :: SomeWrite -> (Int, Qty)
      tagOf (SomeWrite w) = case w of
        WAc q       -> (0, q)
        WAcTrade q  -> (1, q)
        WHwm q      -> (2, q)
        WEntryNav q -> (3, q)

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

-- A boundary event (§state-basis): the logged declaration of a basis change on
-- txUnit. bevId is the content address; effective order is the lexicographic
-- order on (bevTEff, bevPrec, bevId), so the tie-break is data in the notice and
-- booking order never enters the composite.
data BoundaryEvent = BoundaryEvent
  { bevId   :: BoundaryId    -- content address of the attested notice
  , bevTEff :: Timestamp     -- economic effectiveness, not booking time
  , bevPrec :: Integer       -- declared intra-day precedence (W4)
  , bevDecl :: Declaration
  } deriving (Eq, Show)

-- The declaration, restricted to the invariance parameters the admission weld
-- consumes: the declared quantity factor f and per-unit cash c of the invariance
-- identity (price action p -> (p - c)/f; quantity legs q -> q*f; cash legs q*c,
-- booked in declCashUnit). The full kind-indexed operator map of §state-basis is
-- consumed by valuation transport, outside this module. DeclPending (parameter
-- unpublished) and DeclTerminal (series ends) admit no invariance check; their
-- consequence is quarantine at valuation, not admission.
data Declaration
  = DeclParams { declF :: Rational, declC :: Rational, declCashUnit :: Maybe UnitId }
  | DeclPending
  | DeclTerminal
  deriving (Eq, Show)

data Transaction = Transaction
  { txUnit      :: UnitId                          -- the unit this event concerns
  , txMoves     :: [Move]                          -- conserved flow as edges (by construction)
  , txRows      :: Map WalletId [SomeWrite]        -- non-balance per-wallet bookkeeping (ac/hwm/entryNav)
  , txStatus    :: [StatusWrite]                   -- shared UnitStatus writes
  , txIntroduce :: Maybe (TermsVersion, UnitStatus)-- Just => introduce txUnit (registration)
  , txAppend    :: Maybe TermsVersion              -- Just => append a version (C6, Preserving amendment)
  , txBoundary  :: Maybe BoundaryEvent             -- Just => declares a corporate-action boundary on txUnit
  , txCause     :: Maybe BoundaryId                -- PROVENANCE ONLY (D2/E7): the parent notice's
                                                   --   boundary id for a follow-on or cascade;
                                                   --   Nothing on a unit's OWN boundary transaction
                                                   --   (its identity lives in txBoundary -- one
                                                   --   fact, one home). Read by the recomputation
                                                   --   witnesses (P27/P28) for agreement and by
                                                   --   reverse-direction audit; NO code path
                                                   --   branches on its value to decide behaviour.
  } deriving (Eq, Show)

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
  , txStatus = [], txIntroduce = Just (tv, us), txAppend = Nothing
  , txBoundary = Nothing, txCause = Nothing }

appendTx :: UnitId -> TermsVersion -> Transaction               -- C6 Preserving amendment
appendTx u tv = Transaction
  { txUnit = u, txMoves = [], txRows = Map.empty
  , txStatus = [], txIntroduce = Nothing, txAppend = Just tv
  , txBoundary = Nothing, txCause = Nothing }

supersedeTx :: UnitId -> UnitId -> Transaction                  -- C8 Breaking: stamp old unit
supersedeTx u uFresh = Transaction
  { txUnit = u, txMoves = [], txRows = Map.empty
  , txStatus = [SetSupersededBy uFresh], txIntroduce = Nothing, txAppend = Nothing
  , txBoundary = Nothing, txCause = Nothing }

-- | Stamp a follow-on or cascade transaction with its cause: the PARENT
--   notice's boundary id (Ruling 2e, one lineage model). A unit's own boundary
--   transaction is never stamped -- its identity is bevId in txBoundary, and
--   the admission gate's strictly-before read makes self-reference
--   unrepresentable rather than checked.
withCause :: BoundaryId -> Transaction -> Transaction
withCause bid tx = tx { txCause = Just bid }

-- | C-P2's canonical move order: a deterministic sort keyed on
--   (unit, from, to, qty, time, source) -- ALL six Move fields, so the key
--   determines the record and the sort is a true canonical form of the move
--   multiset: two submissions of one economic content are bit-identical after
--   it. `Eq Transaction` on canonicalised values is then the P27 diff -- the
--   stronger witness (observational equality would admit economically-equal-
--   but-differently-shaped submissions and weaken the two-implementation
--   clause). txRows and txStatus are deliberately NOT canonicalised: entry_nav
--   is write-once and applyStatus is last-write-wins, so list order there is
--   semantically load-bearing and reordering would be unsound.
canonicalTx :: Transaction -> Transaction
canonicalTx tx = tx { txMoves = sortOn key (txMoves tx) }
  where key m = (mUnit m, mFrom m, mTo m, unPosQty (mQty m), mTime m, mSource m)

-- -----------------------------------------------------------------------------
-- The ledger. ABSTRACT: no field setter is exported, so no caller can delete a
-- PositionState row (C1) or fabricate terms (C6) / a valid delta (C2) from
-- outside.
-- -----------------------------------------------------------------------------

data Ledger = Ledger
  { ledgerPT :: Map UnitId ProductTerms
  , ledgerUS :: Map UnitId UnitStatus
  , ledgerPS :: Map (WalletId, UnitId) PositionState
  , ledgerBounds :: Map UnitId (Set (Timestamp, Integer, BoundaryId))
      -- committed-boundary projection: each unit's (t_eff, prec, bid) triples, whose
      -- derived Ord IS the effective order. A DERIVABLE CACHE of the log, exactly
      -- like ledgerUS -- rebuilt by replay, never a source of truth.
  } deriving (Show)

data LedgerError
  = ReRegistration      UnitId   -- C10
  | UnitAlreadyExists   UnitId   -- fresh-id collision in a Breaking amendment
  | UnknownUnit         UnitId
  | DanglingSupersede   UnitId   -- SetSupersededBy target is not a registered unit
  | BasisNotTip         UnitId   -- tip weld: SetBasis must write the post-insertion effective tip
  | InvarianceViolation UnitId   -- invariance weld: moves, declaration and SetBasis do not cohere
  | ForeignOrigin       UnitId   -- origin weld: an introduced status must carry the origin of its own unit
  | ScheduleIncomplete  UnitId   -- C14: the written version's schedule fails totality over CAClass x field
  | CauseNotCommitted   UnitId   -- D2 cause gate: txCause names no strictly-earlier committed boundary id
  deriving (Eq, Show)

emptyLedger :: Ledger
emptyLedger = Ledger Map.empty Map.empty Map.empty Map.empty

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
    ()  <- requireSchedule
    ()  <- requireSupersedeTargets l1
    ()  <- requireBasisTip l1
    ()  <- requireInvariance l1
    ()  <- requireCause l1
    Right (commit l1)
  where
    u = txUnit tx

    -- C14, the totality gate: registration and every terms append are admitted
    -- only if the written version's schedule yields exactly one well-formed
    -- entry per (CAClass x field of that version). The appended version carries
    -- its own schedule in the SAME transaction, so the same-transaction
    -- extension rule on appends holds by construction rather than by check.
    requireSchedule =
      case [ tv | Just (tv, _) <- [txIntroduce tx] ] ++ [ tv | Just tv <- [txAppend tx] ] of
        tvs | all scheduleTotalOK tvs -> Right ()
            | otherwise               -> Left (ScheduleIncomplete u)

    -- The cause gate (D2/E7). txCause is PROVENANCE: lineage read by the
    -- recomputation witnesses (P27/P28), never a control input -- no code path
    -- branches on its VALUE to decide behaviour. Admission checks only
    -- WELL-FORMEDNESS of the referent: the named boundary id must already be
    -- COMMITTED, i.e. present in the pre-state projection. This transaction's
    -- own boundary commits only WITH the transaction, so it is absent from that
    -- read -- self-reference is structurally excluded by the strictly-before
    -- clause, not policed by a second one.
    requireCause l = case txCause tx of
      Nothing  -> Right ()
      Just bid
        | any (\s -> any (\(_, _, b) -> b == bid) (Set.toList s))
              (Map.elems (ledgerBounds l)) -> Right ()
        | otherwise                        -> Left (CauseNotCommitted u)

    introduce l = case txIntroduce tx of
      Nothing -> Right l
      Just (tv, us)
        | u `Map.member` ledgerPT l -> Left (ReRegistration u)              -- C10
        | usBasis us /= Origin u    -> Left (ForeignOrigin u)               -- origin weld: C5 stays
        | otherwise -> Right l                                              --   a construction
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

    -- The tip weld: a SetBasis b on u is admitted only if b is the last element,
    -- in effective order, of u's chain after insertion of the boundary this
    -- transaction itself carries -- checkable from the committed projection and
    -- the transaction alone. A retro-effective boundary therefore re-asserts the
    -- standing tip (idempotent under P6) and the coordinate never regresses:
    -- "basis regressed by a late notice" is an unrepresentable ledger state.
    requireBasisTip l =
      case [ b | SetBasis b <- txStatus tx, b /= tipAfter l ] of
        (_ : _) -> Left (BasisNotTip u)
        []      -> Right ()

    tipAfter l =
      let committed = Map.findWithDefault Set.empty u (ledgerBounds l)
          inserted  = maybe committed
                        (\be -> Set.insert (bevTEff be, bevPrec be, bevId be) committed)
                        (txBoundary tx)
      in case Set.lookupMax inserted of
           Nothing          -> Origin u
           Just (_, _, bid) -> Boundary bid

    -- The invariance weld: a basis-changing corporate action is ONE transaction
    -- carrying its entitlement moves, its SetBasis and its declaration, admitted
    -- only if they jointly satisfy the invariance identity -- quantity legs
    -- q -> q*f up to nothing (the reference requires q*f exact in minor units;
    -- explicit cash-in-lieu legs for the fractional case are a recorded
    -- refinement), and cash legs q*c in the declared cash unit. The check reads
    -- no market data: committed balances and the transaction alone.
    --
    -- The check below is the UNIFORM-boundary case (every CAClass except
    -- CAMergerElective), per holder, at full strength -- verbatim. The
    -- ELECTIVE-aggregate case (Ruling 2d / E1) is a recorded refinement: where
    -- the confirmed notice records an election structure and a proration
    -- result, admission checks the aggregate identity -- sum of quantity legs
    -- = f * sum(q) and sum of cash legs = c * sum(q) at the confirmed blend --
    -- and per-holder allocation against the logged elections is Layer-2
    -- economic correctness, recomputed by P27 (witnessed conformance-tier by
    -- P33). The discriminator is DECLARED notice data, never inferred; absent
    -- a confirmed elective declaration the strict per-holder weld here applies
    -- unchanged -- fail-closed into this case, never into the aggregate one.
    requireInvariance l = case txBoundary tx of
      Nothing -> Right ()
      Just be
        | null [ () | SetBasis _ <- txStatus tx ] -> Left (InvarianceViolation u)
        | otherwise -> case bevDecl be of
            DeclPending  -> Right ()   -- parameter unpublished: nothing checkable; quarantine downstream
            DeclTerminal -> Right ()   -- series ends: no arrow, no identity to check
            DeclParams f c mCash
              | f == 0                          -> Left (InvarianceViolation u)
              | c /= 0 && mCash == Nothing      -> Left (InvarianceViolation u)
              | all holdsFor (holders l)        -> Right ()
              | otherwise                       -> Left (InvarianceViolation u)
              where
                holdsFor (w, q) =
                     toRational (q + qVal (delta u w)) == toRational q * f   -- quantity leg
                  && maybe True                                              -- cash leg
                       (\cu -> toRational (qVal (delta cu w)) == toRational q * c)
                       mCash

    -- The wallets holding txUnit before this event; the invariance weld constrains
    -- exactly these. Zero-balance wallets (the corporate-action contra side) are
    -- unconstrained: q -> q*f fixes 0 to 0, and conservation carries their legs.
    holders l = [ (w, q) | ((w, u'), ps) <- Map.toList (ledgerPS l)
                         , u' == u
                         , let Qty q = psBalance ps, q /= 0 ]

    qVal (Qty n) = n

    delta uu w = foldMap
      (\m -> if mUnit m /= uu then mempty
             else (if mTo m == w then unPosQty (mQty m) else mempty)
               <> (if mFrom m == w then qneg (unPosQty (mQty m)) else mempty))
      (txMoves tx)

    commit l = l
      { ledgerBounds = maybe (ledgerBounds l)
                             (\be -> Map.insertWith Set.union u
                                       (Set.singleton (bevTEff be, bevPrec be, bevId be))
                                       (ledgerBounds l))
                             (txBoundary tx)
      , ledgerPT = maybe (ledgerPT l)
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
            l1 <- applyTx (registerTx uFresh tvNew (defaultStatus uFresh)) l
            l2 <- applyTx (supersedeTx u uFresh)                           l1
            Right (Superseded u uFresh, l2)

-- | C11 made concrete: these typecheck; `_c11_bad = WHwm :: Qty -> FieldWrite
--   'Settle` would NOT (WHwm is a FieldWrite 'FeeCrystallise).
_c11_ok_settle :: Qty -> FieldWrite 'Settle
_c11_ok_settle = WAc
_c11_ok_fee    :: Qty -> FieldWrite 'FeeCrystallise
_c11_ok_fee    = WHwm

-- =============================================================================
-- PART D -- managed accounts: issuance, settlement signature, fee crystallisation (§10).
-- Reuses the core Move, Qty group and the C11 WHwm writer.
-- (Names: §10's fee record `FeeCrystallise` is `FeeEvent` here, to avoid colliding
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
--
-- Rename: App. D calls this function `priceOf`; here it is `statePrice`, since
-- `priceOf` is PriceVec's selector (Part E).
--
-- Fibre reading (sec:state-basis): this pricer IS the one-step, f=1 fibre of the
-- basis discipline. Cum/Ex are the two basis points of a chain of length <= 2;
-- `mQuoteEx` is the one-bit degenerate per-(unit, source) basis stamp; the
-- Ex/False equation is the generator arrow Shift (-d) applied exactly once. Nothing
-- here competes with C13 -- it is its |chain| <= 2 restriction. The fibre holds
-- on the lag-only subdomain: the fourth inhabitant, Cum with a quote already ex
-- (quote LEADS), is outside this model -- the Bool has no refusal channel; the
-- general discipline quarantines it (W3). Witness: `fibreOK`, Part L.
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

-- -----------------------------------------------------------------------------
-- Locates (§16.14) and the locate-capacity oracle P26.
--
-- A locate is a pre-trade confirmation that requested securities are identified
-- and deliverable. It is NOT a move: nothing moves at confirmation, no
-- coordinate changes, conservation is not engaged -- a claim about the WORLD
-- (SSR Art. 12(1)(c); Reg SHO Rule 203(b)(1), ETB reliance under 203(b)(1)(ii)),
-- so this kernel is the GATE'S READ DOMAIN, not a conserved ledger: it keeps
-- the lender-side position rows the capacity predicate reads (a sale writes
-- Own from OUTSIDE any locate family), the recorded regulatory holds, and the
-- locate units themselves. The conserved plane -- the §16.8 loan-initiation
-- pair, the borrower leg of a conversion -- lives in the core (Part C) and is
-- out of frame here, exactly as the futures kernel (Part K) projects onto it.
--
-- Activity is a TIMESTAMP PREDICATE and the sole authority: a locate is active
-- at t iff it is live, its remaining quantity is positive, and t precedes its
-- expiry, with t the admitting command's log position (the k-th command
-- commits at Timestamp k -- the viewAsOf precedent). There is deliberately no
-- stored "expired" state to read: the due-event scheduler's terminal sweep is
-- hygiene, not authority, and a status a read could consult would be a second
-- authority. `reserved` is likewise a READ-TIME FOLD over the active
-- put-on-hold locates -- a store-projection over the locate set, never stored,
-- so no counter exists to drift and the deduction lives in ONE place: the gate
-- is atl >= q, where atl already nets exactly the existing outstanding and the
-- locate under confirmation is not yet in the fold. Nothing is counted twice.
-- -----------------------------------------------------------------------------

newtype LenderId = LenderId String  deriving (Eq, Ord, Show)
newtype LocateId = LocateId Integer deriving (Eq, Ord, Show)  -- minted at admission, in-module

-- The four confirmation types of Implementing Regulation (EU) No 827/2012
-- Art. 6. Only PUT-ON-HOLD binds the provider to hold the quantity -- there
-- the bound is law -- and it alone enters the reserved fold. For the other
-- three the capacity gate is firm policy and the kind may lawfully over-locate.
data LocateKind = LocStandard | LocSameDay | LocEasyToBorrow | LocPutOnHold
  deriving (Eq, Show)

-- In-ledger lenders are gated; an external or agent lender's locate is an
-- attested boundary observation, admitted ungated -- capacity is the issuer's
-- obligation, and under SSR 12(1)(c) the third-party confirmer is P14's MAIN
-- case, not an edge.
data LocOrigin = LocInLedger LenderId | LocExternal String
  deriving (Eq, Show)

-- LocLive | LocConverted only: "expired" is not a state, it is the activity
-- predicate reading the log clock. Terminal is absorbing: no arm of locStep
-- writes a LocConverted locate.
data LocState = LocLive | LocConverted deriving (Eq, Show)

data Locate = Locate
  { locOrigin    :: !LocOrigin
  , locSecurity  :: !UnitId
  , locKind      :: !LocateKind
  , locRemaining :: !Qty        -- monotone non-increasing (drawdown, conversion)
  , locExpiry    :: !Timestamp  -- fixed at confirmation
  , locState     :: !LocState
  } deriving (Eq, Show)

-- | The sole authority for activity. No status read competes with it.
locActive :: Timestamp -> Locate -> Bool
locActive t loc = locState loc == LocLive
               && locRemaining loc > mempty
               && t < locExpiry loc

-- The kernel state. Abstract: `locEmpty` and `locStep`/`locRun` are the only
-- doors, so a locate outside the admission gate's image is not constructible
-- by a caller.
data LocLedger = LocLedger
  { llPos  :: Map (LenderId, UnitId) Position  -- the six-coordinate rows the gate reads
  , llHold :: Map (LenderId, UnitId) Qty       -- regulatory holds: recorded, as-of-pinned inputs
  , llLocs :: Map LocateId Locate
  , llMint :: Integer                          -- LocateId mint counter (in-module minting)
  } deriving (Eq, Show)

locEmpty :: LocLedger
locEmpty = LocLedger Map.empty Map.empty Map.empty 0

locPosOf :: LocLedger -> LenderId -> UnitId -> Position
locPosOf ll e u = Map.findWithDefault zeroPos (e, u) (llPos ll)

locHoldOf :: LocLedger -> LenderId -> UnitId -> Qty
locHoldOf ll e u = Map.findWithDefault mempty (e, u) (llHold ll)

-- | reserved: the remaining quantities of the lender's ACTIVE PUT-ON-HOLD
--   locates, summed at read time. A store-projection (a fold over the locate
--   set), not a function of the six coordinates; never stored.
locReserved :: LocLedger -> LenderId -> UnitId -> Timestamp -> Qty
locReserved ll e u t = foldMap locRemaining
  [ loc | loc <- Map.elems (llLocs ll)
        , locOrigin loc == LocInLedger e, locSecurity loc == u
        , locKind loc == LocPutOnHold, locActive t loc ]

-- | AvailableToLend -- ONE definition, ONE subtraction of reserved:
--   max(0, (own - onloan + borr) - reserved - regulatory_hold).
locAtl :: LocLedger -> LenderId -> UnitId -> Timestamp -> Qty
locAtl ll e u t =
  qmax mempty (avail (locPosOf ll e u)
                 <> qneg (locReserved ll e u t)
                 <> qneg (locHoldOf ll e u))

-- The command alphabet IS the generator's input space (the Property precedent:
-- generator and checker share one type). LWrite is the out-of-family capacity
-- writer -- a sale writes Own -- included so generated runs exercise exactly
-- the interleaving that kills per-(lender, security) workflow owners.
data LocCmd
  = LConfirm LenderId UnitId Qty LocateKind Timestamp -- gated: the locate-capacity weld
  | LAttest  String   UnitId Qty LocateKind Timestamp -- external lender: admitted on attestation, ungated
  | LDraw    LocateId Qty                             -- short-sale drawdown (P14), one admission
  | LConvert LocateId Qty                             -- loan write + drawdown + terminalisation, ONE command;
                                                      --   partial conversion leaves a residual live locate
  | LWrite   LenderId UnitId Coord Qty                -- inventory writer outside any locate family
  | LHold    LenderId UnitId Qty                      -- (re)record the regulatory hold
  deriving (Eq, Show)

-- One decision per command; the CONFIRMED/DECLINED stream is replayable DATA.
-- LocDeclined is the gate WORKING (not an error); LocRefused is the typed
-- refusal of an ill-formed request (dead locate, overdraw, non-positive
-- quantity, expiry not after admission) -- inert, never silent.
data LocDecision = LocConfirmed LocateId | LocDeclined | LocApplied | LocRefused
  deriving (Eq, Show)

-- | One command at its log position. Total: every input yields a decision and
--   a ledger; no arm raises, no arm is silent.
locStep :: Timestamp -> LocCmd -> LocLedger -> (LocDecision, LocLedger)
locStep t (LConfirm e u q kind expy) ll
  | q <= mempty || expy <= t = (LocRefused, ll)
  | locAtl ll e u t >= q     = admitLoc (LocInLedger e) u q kind expy ll
  | otherwise                = (LocDeclined, ll)
locStep t (LAttest src u q kind expy) ll
  | q <= mempty || expy <= t = (LocRefused, ll)
  | otherwise                = admitLoc (LocExternal src) u q kind expy ll
locStep t (LDraw lid q) ll =
  withActive t lid ll $ \loc ->
    if q <= mempty || q > locRemaining loc
      then (LocRefused, ll)
      else (LocApplied,
            putLoc lid loc { locRemaining = locRemaining loc <> qneg q } ll)
locStep t (LConvert lid q) ll =
  withActive t lid ll $ \loc ->
    if q <= mempty || q > locRemaining loc
      then (LocRefused, ll)
      else
        let left = locRemaining loc <> qneg q
            loc' = loc { locRemaining = left
                       , locState = if left == mempty then LocConverted
                                                      else LocLive }
            ll'  = putLoc lid loc' ll
        in (LocApplied, case locOrigin loc of
             LocInLedger e -> writePos e (locSecurity loc) OnLoan q ll'
             LocExternal _ -> ll')  -- lender book out of frame; borrower leg in the core
locStep _ (LWrite e u coord q) ll = (LocApplied, writePos e u coord q ll)
locStep _ (LHold e u q) ll
  | q < mempty = (LocRefused, ll)
  | otherwise  = (LocApplied, ll { llHold = Map.insert (e, u) q (llHold ll) })

admitLoc :: LocOrigin -> UnitId -> Qty -> LocateKind -> Timestamp -> LocLedger
         -> (LocDecision, LocLedger)
admitLoc o u q kind expy ll =
  let lid = LocateId (llMint ll + 1)
  in ( LocConfirmed lid
     , ll { llLocs = Map.insert lid (Locate o u kind q expy LocLive) (llLocs ll)
          , llMint = llMint ll + 1 } )

withActive :: Timestamp -> LocateId -> LocLedger
           -> (Locate -> (LocDecision, LocLedger)) -> (LocDecision, LocLedger)
withActive t lid ll kont = case Map.lookup lid (llLocs ll) of
  Just loc | locActive t loc -> kont loc
  _                          -> (LocRefused, ll)

putLoc :: LocateId -> Locate -> LocLedger -> LocLedger
putLoc lid loc ll = ll { llLocs = Map.insert lid loc (llLocs ll) }

writePos :: LenderId -> UnitId -> Coord -> Qty -> LocLedger -> LocLedger
writePos e u coord q ll =
  ll { llPos = Map.insert (e, u) (applyMove coord q (locPosOf ll e u)) (llPos ll) }

-- | A whole run. The k-th command commits at Timestamp k (counting from 1):
--   booking time IS the log position, so the capacity predicate is evaluated
--   at the command's position in the total order -- the locate-capacity weld
--   -- and race-freedom is inherited from the order, not argued case by case:
--   two confirms are totally ordered and the later one's fold sees the
--   earlier's locate; confirm-vs-convert cannot tear because conversion's loan
--   write and drawdown are one command; confirm-vs-expire is a non-race
--   because expiry is a timestamp predicate, not an event. Byte-equality of
--   the CONFIRMED/DECLINED stream under replay is the pureL register: locRun
--   is a total pure function of the command list, so it is discharged by the
--   type, not restated as a vacuous run-it-twice oracle.
locRun :: [LocCmd] -> (LocLedger, [LocDecision])
locRun = go (1 :: Integer) locEmpty
  where
    go _ ll []       = (ll, [])
    go k ll (c : cs) = let (d, ll')  = locStep (Timestamp k) c ll
                           (llF, ds) = go (k + 1) ll' cs
                       in (llF, d : ds)

-- P26 Locate-capacity admission. Step-indexed to ADMITTED in-ledger
-- confirmation positions and to NOTHING else: over-location freedom has
-- precondition shape, not invariant shape -- a lawful later sale of located
-- stock lowers the bound without touching a locate -- so a standing
-- reachable-state restatement (an INV-OL, an "O <= B" solvency identity)
-- would prove a theorem the law falsifies, and NO artifact, this oracle
-- included, may make one. Both sides are evaluated at the commit position p,
-- post-admission (the admitted locate, if put-on-hold, is in the fold).
-- Attested external locates are OUTSIDE the quantification: ungated by
-- design, never in the fold. There is no cached aggregate to recompute
-- against (the effTip concern is empty: reserved is fold-only), so the oracle
-- replays the commands and re-evaluates the fold at each admitted
-- confirmation. Wrongful DECLINE is the vacuous side, as in P1/P2's split;
-- completeness is locSplitOK's half. Log-shaped like P4/P8/P24, not
-- Property-shaped: the claim quantifies over positions of a run.
p26 :: [LocCmd] -> Bool
p26 = go (1 :: Integer) locEmpty
  where
    go _ _  []       = True
    go k ll (c : cs) =
      let t        = Timestamp k
          (d, ll') = locStep t c ll
          ok = case (c, d) of
                 (LConfirm e u _ _ _, LocConfirmed _) ->
                   locReserved ll' e u t
                     <= qmax mempty (avail (locPosOf ll' e u)
                                       <> qneg (locHoldOf ll' e u))
                 _ -> True
      in ok && go (k + 1) ll' cs

-- | The split metamorphic -- the ONE test that kills a double-counted
--   deduction. With the subtraction written once (atl >= q; the locate under
--   confirmation not yet in the fold), one put-on-hold confirmation of q <> q
--   is admitted iff two successive put-on-hold confirmations of q each are:
--   the second sees the first in the fold, so both pass iff
--   avail - reserved - hold >= 2q -- exactly the single confirmation's gate.
--   A gate that re-subtracted outstanding (avail - 2*reserved - hold >= q)
--   breaks the equivalence wherever 2q <= avail - 2*reserved - hold < 3q.
--   PUT-ON-HOLD only: for the other three kinds the fold does not tighten and
--   the kind may lawfully over-locate, so the equivalence is not a theorem
--   there. Vacuous when q is non-positive or the expiry does not outlive both
--   trials.
locSplitOK :: [LocCmd] -> LenderId -> UnitId -> Qty -> Timestamp -> Bool
locSplitOK pfx e u q expy =
  q <= mempty || expy <= Timestamp (toInteger (length pfx) + 2)
    || (admitsAll [LConfirm e u (q <> q) LocPutOnHold expy]
          == admitsAll [ LConfirm e u q LocPutOnHold expy
                       , LConfirm e u q LocPutOnHold expy ])
  where
    admitsAll appended =
      all isConfirmed (drop (length pfx) (snd (locRun (pfx ++ appended))))
    isConfirmed (LocConfirmed _) = True
    isConfirmed _                = False

-- | Conversion is ATL-neutral for a put-on-hold locate: the loan write raises
--   onloan by q (avail falls by q) and the drawdown removes q from the fold
--   (reserved falls by q) IN THE SAME COMMAND -- one atomic admission, so no
--   interleaved confirmation can see a torn middle. Vacuous outside the
--   guarded domain (dead locate, overdraw, non-hold kind, external origin).
locConvertNeutralOK :: [LocCmd] -> LocateId -> Qty -> Bool
locConvertNeutralOK pfx lid q =
  let (ll, _) = locRun pfx
      t       = Timestamp (toInteger (length pfx) + 1)
  in case Map.lookup lid (llLocs ll) of
       Just loc | LocInLedger e <- locOrigin loc
                , locKind loc == LocPutOnHold
                , locActive t loc
                , q > mempty, q <= locRemaining loc ->
         let (_, ll') = locStep t (LConvert lid q) ll
             u        = locSecurity loc
         in locAtl ll' e u t == locAtl ll e u t
       _ -> True

-- | P14's structural half, re-checked in the chainOK register: along any run,
--   every locate's remaining quantity is non-increasing and a converted
--   locate stays converted (terminal absorbing), so a locate is spent at most
--   once. True by construction -- no locStep arm increases remaining or
--   revives LocConverted -- so a failure needs API-tamper; the capacity bound
--   at the confirmation door is P26's half, and no standing invariant is
--   stated between the doors.
locDrawMonotoneOK :: [LocCmd] -> Bool
locDrawMonotoneOK cmds = and (zipWith stepOK states (drop 1 states))
  where
    states = scanl (\ll (k, c) -> snd (locStep (Timestamp k) c ll))
                   locEmpty (zip [1 ..] cmds)
    stepOK a b = all ok (Map.toList (llLocs b))
      where
        ok (lid, loc) = case Map.lookup lid (llLocs a) of
          Nothing   -> True   -- newly admitted at this position
          Just prev -> locRemaining loc <= locRemaining prev
                    && (locState prev /= LocConverted
                          || locState loc == LocConverted)

-- | genLocCmds: a command stream over a small lender/security pool --
--   inventory writes (sales included: Own falls from outside any locate
--   family), recorded holds, confirmations of all four kinds with near
--   expiries (so activity flips mid-run), attested external locates, and
--   draws and conversions against the deterministic mint sequence
--   (LocateId 1, 2, ...) so live, spent, and never-minted ids all occur.
--   Every stream is a legal input: locStep is total, so the generator has no
--   reject loop. (Seed machinery: Part M.)
genLocCmds :: Int -> Seed -> [LocCmd]
genLocCmds n sd0
  | n <= 0    = []
  | otherwise = let (s1, s2) = splitSeed sd0
                in genLocCmd n s1 : genLocCmds (n - 1) s2

genLocCmd :: Int -> Seed -> LocCmd
genLocCmd n sd0 =
  let (arm, sd1) = nextInt 6 sd0
      (ei,  sd2) = nextInt 2 sd1
      (ui,  sd3) = nextInt 2 sd2
      (q,   sd4) = nextInt 120 sd3
      e = LenderId ("lender-" ++ show ei)
      u = UnitId   ("sec-"    ++ show ui)
  in case arm of
       0 -> let (kk, sd5) = nextInt 4 sd4
                (ex, _  ) = nextInt (toInteger n + 8) sd5
            in LConfirm e u (Qty q) (locKindOf kk) (Timestamp ex)
       1 -> let (kk, sd5) = nextInt 4 sd4
                (ex, _  ) = nextInt (toInteger n + 8) sd5
            in LAttest "agent" u (Qty q) (locKindOf kk) (Timestamp ex)
       2 -> let (lid, _) = nextInt (toInteger n + 1) sd4
            in LDraw (LocateId (lid + 1)) (Qty (q `mod` 40))
       3 -> let (lid, _) = nextInt (toInteger n + 1) sd4
            in LConvert (LocateId (lid + 1)) (Qty (q `mod` 40))
       4 -> let (sgn, _) = nextInt 3 sd4
            in LWrite e u Own (Qty (if sgn == 0 then negate q else q))
       _ -> LHold e u (Qty (q `mod` 30))

locKindOf :: Integer -> LocateKind
locKindOf 0 = LocStandard
locKindOf 1 = LocSameDay
locKindOf 2 = LocEasyToBorrow
locKindOf _ = LocPutOnHold

-- | shrinkLocCmds: prefixes first (the structurally smaller run), then
--   pointwise quantity shrinking -- ids, kinds, and expiries name the trial;
--   the quantities carry the arithmetic.
shrinkLocCmds :: [LocCmd] -> [[LocCmd]]
shrinkLocCmds cmds =
     [ take k cmds | k <- [0 .. length cmds - 1] ]
  ++ [ pre ++ c' : post
     | (pre, c : post) <- [ splitAt i cmds | i <- [0 .. length cmds - 1] ]
     , c' <- shrinkLocCmd c ]

shrinkLocCmd :: LocCmd -> [LocCmd]
shrinkLocCmd cmd = case cmd of
  LConfirm e u (Qty q) kind ex -> [ LConfirm e u (Qty q') kind ex | q' <- shrinkInteger q ]
  LAttest  s u (Qty q) kind ex -> [ LAttest  s u (Qty q') kind ex | q' <- shrinkInteger q ]
  LDraw    lid (Qty q)         -> [ LDraw    lid (Qty q')         | q' <- shrinkInteger q ]
  LConvert lid (Qty q)         -> [ LConvert lid (Qty q')         | q' <- shrinkInteger q ]
  LWrite   e u coord (Qty q)   -> [ LWrite   e u coord (Qty q')   | q' <- shrinkInteger q ]
  LHold    e u (Qty q)         -> [ LHold    e u (Qty q')         | q' <- shrinkInteger q ]

-- =============================================================================
-- PART H -- the settlement-layer interface (§13).
--
-- The boundary is ONE pure total function settleProjection :: SettlementTx ->
-- Maybe SettlementInstruction. It reads one committed transaction and nothing
-- else, so it is deterministic and safe to re-run. Each leg-bearing instruction
-- carries exactly the legs its type names, so "an instruction with no legs" is
-- unrepresentable. (Names: §13's Move is `SettleMove` here -- it ranges over the
-- settlement identity `Asset`, not the ledger UnitId; §13's Transaction is
-- `SettlementTx`; §13's TxType is `TxClass`; §13's Asset case `Cash` is `CashCcy`
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
-- PART I -- the ISDA-CDM forgetful map  forget :: BusinessEvent -> CdmTransaction (§14).
--
-- F reads the economic operators a CDM BusinessEvent carries, emits the
-- corresponding ledger Moves, and stores the WHOLE originating event verbatim --
-- the legal/workflow detail is dropped from ledger state but recoverable.
-- Move extraction is `concatMap instructionMoves`, a monoid homomorphism from the
-- free monoid of instruction lists to the free monoid of move lists:
--     moves (xs <> ys) = moves xs <> moves ys.
-- (Names: §14's primitive `Transfer` is `PiTransfer` here, to avoid colliding with
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
-- PART J -- orchestration and obligation liveness (§15).
--
-- A first-class Obligation with a total discharge predicate D and compensation
-- kappa. The lifecycle is split so the TYPE forbids leaving a terminal state:
-- `obStep` consumes only `Live`, so a `Terminal` can never be transitioned --
-- "leaving a terminal state" is unrepresentable, not merely unreached. On
-- DeadlineFired every arm returns a Terminal (lemma L5 / P21), visible in the
-- types. (Names: §15's placeholder LedgerState is `OblView` here; its
-- compensating moves are the core `Move`; the handler `step` is `obStep`; and
-- §15's ObState constructors Active/Settled are ObActive/ObSettled here, to
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
-- PART K -- the futures lifecycle engine (§9).
--
-- One cash-settled listed future: registration, trading, daily variation-margin
-- settlement, expiry, terminal flatten. This is a SECOND, self-contained ledger
-- with its own event alphabet and three-way conserved delta (position, accumulated
-- cost, cash); it carries stored per-position accumulated_cost (C11) so that the
-- intraday VM result is correct (VM = net*S*m + ac, not the gross mark). Every
-- name is `Fut`-prefixed (or otherwise disambiguated) so it coexists with the
-- canonical core. futMark is §9's three-argument markValue (with the multiplier);
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
-- separate only so §9's three-way (position, accumulated cost, cash) bookkeeping
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
-- The core invariants P1--P10, the basis invariant P24 (tip agreement), and the
-- unnumbered witnesses (`total`, `fibreOK`) as TYPED PREDICATES over the cleared
-- core: a precondition that constrains the generated input and a postcondition
-- the operation must satisfy, both total. `execute :: Ledger -> OracleTx ->
-- Outcome` returns a typed Outcome -- never an exception; `Accepted` is the ONLY
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

-- | The effective-order tip a log prefix mandates for u, recomputed from the
--   transactions' own BoundaryEvents -- INDEPENDENT of the ledger's ledgerBounds
--   cache, so a drifted cache cannot vouch for itself. The spec function of the
--   basis-chain definition (sec:state-basis), written once, here: the maximum,
--   in the lexicographic order (t_eff, prec, bid), of the boundary events the
--   prefix carries on u, or Origin u if it carries none.
effTip :: UnitId -> [Transaction] -> BasisId
effTip u txs =
  case Set.lookupMax (Set.fromList
         [ (bevTEff be, bevPrec be, bevId be)
         | tx <- txs, txUnit tx == u, Just be <- [txBoundary tx] ]) of
    Nothing          -> Origin u
    Just (_, _, bid) -> Boundary bid

-- P24 Basis tip agreement: at EVERY accepted prefix of the log, the booking-order
-- status fold (replay) and the effective-order chain projection (effTip) agree on
-- usBasis for every registered unit. Quantifying over prefixes makes each check a
-- clone_at(k), so the retro-effective time-travel claim (sec:basis-time-travel)
-- rides on this oracle plus the existing P8 (sameLedger already observes usBasis
-- through unitStatus, whose structural Eq covers all four fields). No-regression
-- is a corollary, not a test: the max of a growing committed set never recedes.
-- Wrongful ADMISSION of a non-tip SetBasis fails this oracle at that prefix;
-- wrongful REJECTION is the vacuous side, as in P1/P2's split -- consistent with
-- catalogue precedent. Log-prefix-shaped like P4/P8, not Property-shaped: the
-- claim quantifies over prefixes of a log, not over single transactions.
-- (Generators: BoundaryId is abstract by design, so boundary transactions for
-- this oracle are compiled IN-MODULE, minting deterministic content addresses --
-- no production caller gains a minting door.)
p24 :: [Transaction] -> Bool
p24 txs = all prefixOK [ take k txs | k <- [0 .. length txs] ]
  where
    prefixOK pfx = case replay pfx emptyLedger of
      Left _  -> True   -- a rejected prefix asserts nothing (rejection is P2's half)
      Right l -> all (agrees l pfx) (Set.toList (Set.fromList (map txUnit pfx)))
    agrees l pfx u = fmap usBasis (unitStatus l u) == Just (effTip u pfx)

-- Fibre witness (app:pricing-coordination vs sec:state-basis): the Cum/Ex pricer
-- IS the one-step, f=1 fibre of basis transport, on the lag-only subdomain. Cum
-- with a lagging source reads at the old point; Ex with a caught-up source
-- (stamp True) is the identity arrow at the new point; Ex with a lagging source
-- (stamp False) applies the generator Shift (-d) exactly once. mQuoteEx is the
-- one-bit degenerate per-(unit, source) basis stamp; nothing competes with C13.
-- Unnumbered like `total`: a finite algebraic identity of one function, not a
-- ledger invariant -- a P-number would be decoration. The fourth inhabitant
-- (Cum with an ex quote -- quote LEADS) is outside App. D's model and outside
-- this witness; see the Part F banner.
fibreOK :: UnitId -> Integer -> Integer -> Bool
fibreOK u q d =
     statePrice u Cum           (Market (Quote q) False) == Price q
  && statePrice u (Ex (Cash d)) (Market (Quote q) True ) == Price q
  && statePrice u (Ex (Cash d)) (Market (Quote q) False) == Price (q - d)

-- -----------------------------------------------------------------------------
-- The processor-contract witnesses (D1/D2/D3, prin:admission-recomputation).
--
-- Layer 1 (structural correctness) is the admission door itself; Layer 2
-- (economic correctness) is DIFFERENTIAL RECOMPUTATION: the reference is the
-- recomputer, and agreement is a diff of values, not a re-audit of code. A
-- processor here is a PURE function of the committed log prefix -- purity IS
-- injectability (the P9 register), so no separate injection oracle exists.
-- -----------------------------------------------------------------------------

-- P27 Producer agreement. Recompute the submitted transaction from the log
-- prefix with the reference's own deterministic construction and diff under
-- the canonical move order (C-P2: sort on (unit, from, to, qty); Eq is then
-- bit identity). Zero diff, or the producer is defective. A prefix that does
-- not replay asserts nothing (P2's half). txBoundary and txCause are read for
-- AGREEMENT only -- the CA-restricted instance (W-D2.1) joins on them (E7:
-- provenance, never a control input).
recomputeOK :: ([Transaction] -> Ledger -> Transaction)   -- the processor under test
            -> [Transaction]                              -- committed log prefix
            -> Transaction                                -- the submitted transaction
            -> Bool
recomputeOK processor pfx submitted =
  case replay pfx emptyLedger of
    Left _  -> True
    Right l -> canonicalTx (processor pfx l) == canonicalTx submitted

-- | P27's terms leg (D3 N7), the same differential shape: the transported
--   version recomputed by the reference (`transportVersion`: every field
--   through its scheduled rule at the declared (f, c)) must equal the
--   submitted one. An undefined transport asserts nothing here -- the C14 gate
--   already refuses it at the door, which is stronger than a property.
propTermsRecompute :: CAClass -> Rational -> Rational -> TermsVersion -> TermsVersion -> Bool
propTermsRecompute cls f c tv submitted =
  maybe True (== submitted) (transportVersion cls f c tv)

-- P28 Cause committed. Along the accepted prefix of any log, every committed
-- transaction's txCause names a boundary id committed STRICTLY EARLIER. The
-- oracle accumulates the committed ids itself, independently of ledgerBounds,
-- so a drifted cache cannot vouch for itself (the effTip discipline); a
-- refused transaction ends the accepted prefix and asserts nothing.
pCauseCommitted :: [Transaction] -> Bool
pCauseCommitted = go Set.empty emptyLedger
  where
    go _    _ []         = True
    go seen l (tx : txs) = case applyTx tx l of
      Left _   -> True
      Right l' ->
        let ok    = maybe True (`Set.member` seen) (txCause tx)
            seen' = maybe seen (\be -> Set.insert (bevId be) seen) (txBoundary tx)
        in ok && go seen' l' txs

-- P29 Schedule totality at registration (C14's witness), the enumeration
-- idiom: the door's verdict on registering a version equals the cell-by-cell
-- recount -- over EVERY class of [minBound .. maxBound] :: [CAClass] and every
-- field of the version being written, the schedule yields EXACTLY ONE
-- well-formed entry (the class default when none is declared; the declared
-- entry, well-formed, when one is), and no declared entry dangles off the
-- field set. Refusal is ScheduleIncomplete and ONLY that (the trial is a lone
-- registration: no other gate can fire). The recount shares scheduleRule /
-- ruleWellFormed with the gate, so this oracle witnesses the gate's WIRING --
-- verdict routing, error selection, absence of a competing gate -- while
-- "exactly one" itself is discharged by the type argument (Map key uniqueness
-- plus the total default), not by a reimplementation.
propScheduleTotalGate :: TermsVersion -> Bool
propScheduleTotalGate tv =
  case applyTx (registerTx u tv (defaultStatus u)) emptyLedger of
    Right _                     -> expectOK
    Left (ScheduleIncomplete _) -> not expectOK
    Left _                      -> False
  where
    u = UnitId "u-c14"
    Schedule declared = tvSchedule tv
    cellCount cls fn v =
      length [ () | let r = scheduleRule (tvSchedule tv) cls fn
                  , ruleWellFormed (dimOf v) r ]
    expectOK =
         and [ cellCount cls fn v == 1
             | cls <- [minBound .. maxBound] :: [CAClass]
             , (fn, v) <- Map.toList (tvFields tv) ]
      && all (\(_, fn) -> fn `Map.member` tvFields tv) (Map.keys declared)

-- P30 Dimension invariance under a neutral boundary: the per-dimension action
-- at (f, c) = (1, 0) is the identity on every dimension -- quantities x 1,
-- prices (p - 0)/1, cash and dimensionless fixed -- and, the G2 rider, the
-- class default and the default rule evaluate to the same identity under
-- EVERY class of the closed enum: Stand and ReExpress coincide at (1, 0), so
-- the neutral boundary is the identity no matter which class declares it.
-- Shared with D4: the composite-kind oracle `dkDivSplitOK` (Part M) rides
-- this property's suite run.
propDimInvariance :: TermsValue -> Bool
propDimInvariance v =
     transportField 1 0 v == Just v
  && and [ classDefault cls 1 0 v == Just v
        && evalRule cls RDefault 1 0 v == Just v
         | cls <- [minBound .. maxBound] :: [CAClass] ]

-- | The G2 witness: under an ordinary-dividend boundary (f = 1, c /= 0) the
--   layer-1 class default lets every price-in-basis field STAND. The oracle
--   strips the schedule to the empty one, so LAYER 1 ALONE answers -- a
--   declared override is layer-2 behaviour with its own witnesses -- and it
--   checks both halves per price field:
--     (i)  Stand: the transported version carries the field unchanged;
--     (ii) non-vacuity: `transportField 1 c` on the same field MOVES it
--          ((p - c) /= p at c /= 0), so the pre-G2 behaviour -- prices
--          re-expressed under every class -- is observably caught, not
--          silently equal.
--   At c == 0 the two actions coincide (P30's ground), so the per-field
--   assertion is guarded to c /= 0; a version with no price field asserts
--   nothing (the suite wrapper injects one, so the run is never vacuous).
--   `Nothing -> False`: the class default at f == 1 is total by construction.
propOrdDivTermsStand :: Rational -> TermsVersion -> Bool
propOrdDivTermsStand c tv =
  case transportVersion CADividendOrdinary 1 c tv1 of
    Nothing   -> False
    Just tv'  -> and
      [ Map.lookup fn (tvFields tv') == Just (TVPrice p)      -- (i)  stands
        && transportField 1 c (TVPrice p) /= Just (TVPrice p) -- (ii) would move
      | (fn, TVPrice p) <- Map.toList (tvFields tv1), c /= 0 ]
  where tv1 = tv { tvSchedule = emptySchedule }

-- | The class-default table's remaining obligations (FORMALIS G2 review,
--   HIGH-1 and MEDIUM-2), riding the G2 suite line:
--     (i)   degenerate-factor refusal FIRST: at f == 0 the default refuses
--           under EVERY class and EVERY dimension, through both doors
--           (`classDefault` and the `RDefault` arm) -- including the Stand
--           class on a price field, the ONE cell where a Stand dispatch
--           wrongly hoisted above the guard would answer identity instead of
--           refusing: the guard-order law, witnessed rather than asserted;
--     (ii)  every class OTHER THAN CADividendOrdinary re-expresses a price
--           field -- agrees with `transportField` at the drawn (f, c) -- so
--           the seven non-Stand rows are pinned OFF the neutral boundary,
--           where a row misdeclared Stand cannot hide behind the (1, 0)
--           coincidence. The quantifier ranges over class NAMES, never over
--           `priceTermsDefault` itself: a filter reading the table under
--           test would excuse exactly the rows a mutation flips (the
--           shared-predicate trap -- P27's terms leg cannot see this either,
--           since its two legs share `transportVersion`). The Stand set
--           {CADividendOrdinary} is thus recomputed here independently, as
--           specification data;
--     (iii) non-vacuity: whenever the re-expression actually moves the price
--           ((p - c)/f /= p), the class default moves it too.
--   Total over all inputs: (ii) holds at f == 0 as shared refusal, and (iii)
--   is guarded to the moving case, so no draw makes the oracle wrong -- only,
--   at a fixed point of the re-expression, silent (the wrapper draws past
--   those).
propClassDefaultTable :: Rational -> Rational -> Rational -> Bool
propClassDefaultTable f c p =
     and [ classDefault cls 0 c v == Nothing
           && evalRule cls RDefault 0 c v == Nothing
         | cls <- allCls
         , v <- [TVQty p, TVPrice p, TVCash p, TVFree "opaque"] ]
  && and [ classDefault cls f c pv == transportField f c pv
           && (f == 0 || (p - c) / f == p || classDefault cls f c pv /= Just pv)
         | cls <- allCls, cls /= CADividendOrdinary ]
  -- FORMALIS residual-LOW witness: the Stand cell holds at every non-zero f, not
  -- only the neutral f == 1, so an ordinary-dividend price field stands under a
  -- combined quantity-changing boundary too. Kills the Stand -> transportField f 0 mutant.
  && (f == 0 || classDefault CADividendOrdinary f c pv == Just pv)
  where
    allCls = [minBound .. maxBound] :: [CAClass]
    pv     = TVPrice p

-- =============================================================================
-- BS-1 (WILSON blind spot, author condition E1(iv)): the invariance weld run
-- against ACTUAL booked holder moves and cash legs -- NOT the holder-free chain
-- (`chainOf`), whose zero-holder `all holdsFor []` is vacuously true. A mutant
-- that flips the per-holder agreement check survives that chain; it must not
-- survive here.
--
-- `weldHolderOK` builds a pre-state in which wallet A genuinely holds q units of
-- u, submits a boundary transaction carrying real per-holder entitlement moves,
-- and asserts the weld ADMITS exactly when the moves realise the declared
-- operator (f, c) and REFUSES (InvarianceViolation, specifically) on any
-- per-holder disagreement. It covers both E1 cases:
--   * case 1, UNIFORM boundary, at full strength -- a split (f >= 2, no cash: the
--     quantity leg q |-> q*f) and an ordinary dividend (f = 1, cash leg q*c);
--   * case 2, per-holder cash delivered across MULTIPLE legs -- a gross credit
--     and a withholding debit whose SIGNED SUM is q*c -- the `delta` aggregation
--     the weld performs per holder (a single-move check would miss it).
-- The refusal arms are pinned to InvarianceViolation, so it is the weld -- not
-- some other gate -- that refuses; that is exactly what a flipped cash-leg
-- agreement check (accept when q*c is off by a holder's leg) fails.
-- =============================================================================
weldHolderOK :: Integer -> Integer -> Integer -> Bool
weldHolderOK qRaw fRaw cRaw =
  and [ admits  splitAgree,  refuses splitDisagree    -- case 1, uniform, split (no cash)
      , admits  divAgree,    refuses divDisagree      -- case 1, uniform, ordinary dividend
      , admits  multiAgree,  refuses multiDisagree ]  -- case 2, multi-leg cash summing to q*c
  where
    u   = UnitId "u"
    cu  = UnitId "eur"
    wA  = WalletId "A"          -- the real holder (nonzero balance: constrained)
    wC  = WalletId "contra"     -- zero-balance contra side (unconstrained)
    wT  = WalletId "tax"        -- withholding sink
    q   = 1 + (qRaw `mod` 500)  -- 1..500 units actually held
    f   = 2 + (fRaw `mod` 3)    -- 2..4 split factor
    c   = 1 + (cRaw `mod` 50)   -- 1..50 per-unit cash
    wth = q + 1                 -- a positive withholding amount

    -- A pre-state with u and its cash unit registered and wallet A holding q of u.
    regTv = TermsVersion "reg" Map.empty emptySchedule
    l0 = Ledger
      { ledgerPT     = Map.fromList [ (x, ProductTerms (regTv :| [])) | x <- [u, cu] ]
      , ledgerUS     = Map.fromList [ (u, defaultStatus u), (cu, defaultStatus cu) ]
      , ledgerPS     = Map.singleton (wA, u) zeroP { psBalance = Qty q }
      , ledgerBounds = Map.empty }

    mv from to unit n src =
      case move from to unit (Qty n) (Timestamp 500) (SourceId src) of
        Just m  -> [m]
        Nothing -> []           -- a non-positive magnitude drops the leg (still a disagreement)

    boundary decl ms = Transaction
      { txUnit = u, txMoves = ms, txRows = Map.empty
      , txStatus = [SetBasis (Boundary bid)]
      , txIntroduce = Nothing, txAppend = Nothing
      , txBoundary = Just (BoundaryEvent bid (Timestamp 500) 0 decl)
      , txCause = Nothing }
      where bid = BoundaryId "b-weld"

    -- case 1, split: f >= 2, no cash. Quantity leg delta_u(A) = q*(f - 1).
    declS         = DeclParams (toRational f) 0 Nothing
    splitAgree    = boundary declS (mv wC wA u (q * (f - 1))     "split")
    splitDisagree = boundary declS (mv wC wA u (q * (f - 1) + 1) "split-bad")

    -- case 1, ordinary dividend: f = 1, single cash leg delta_eur(A) = q*c.
    declD         = DeclParams 1 (toRational c) (Just cu)
    divAgree      = boundary declD (mv wC wA cu (q * c)     "div")
    divDisagree   = boundary declD (mv wC wA cu (q * c + 1) "div-bad")

    -- case 2, multi-leg cash: gross credit (q*c + wth) and withholding debit wth;
    -- the signed sum into A is q*c. Dropping the withholding leg disagrees.
    multiAgree    = boundary declD ( mv wC wA cu (q * c + wth) "gross"
                                  ++ mv wA wT cu wth           "withhold" )
    multiDisagree = boundary declD ( mv wC wA cu (q * c + wth) "gross" )

    admits  tx = case applyTx tx l0 of Right _                      -> True; _ -> False
    refuses tx = case applyTx tx l0 of Left (InvarianceViolation _) -> True; _ -> False

-- =============================================================================
-- BS-2 (WILSON blind spot): the schedule OVERRIDE layer is actually EVALUATED,
-- and the declared override is OBSERVED distinct from the class default -- a
-- `scheduleRule` lookup mutant (return the default, ignore the declared entry)
-- must not survive. The showcase is the prose special dividend: strike EUR 100
-- with the declared override "adjust the strike above EUR 0.50, by the excess
-- over 0.50" resolves to 98.50, whereas the class default (special dividends
-- RE-EXPRESS: (p - c)/f) yields 98. The RByParty arm (designated discretion,
-- unresolved) is observed to REFUSE (transportVersion Nothing) -- fail-closed,
-- never a guessed arrow, killing an RByParty -> Just mutant.
-- =============================================================================
scheduleOverrideOK :: Integer -> Bool
scheduleOverrideOK strikeRaw =
  and
    [ -- (a) the DECLARED override is looked up (not RDefault) and evaluated
      scheduleRule schO CADividendSpecial "strike" == override
    , transportVersion CADividendSpecial 1 c tvO == Just (tvSet declaredVal)
      -- (b) DISTINCT from the class default, which re-expresses to (p - c)
    , classDefault CADividendSpecial 1 c (TVPrice p) == Just (TVPrice classDefVal)
    , declaredVal /= classDefVal
      -- (c) the prose showcase pinned literally: 100 -> 98.50, default 98
    , transportVersion CADividendSpecial 1 2 tv100
        == Just (tv100 { tvFields = Map.singleton "strike" (TVPrice (197 / 2)) })
    , classDefault CADividendSpecial 1 2 (TVPrice 100) == Just (TVPrice 98)
      -- (c') the ELSE branch of the override is live: BELOW the EUR 0.50
      -- threshold (c = 1/4 < 1/2) the condition is false, RSet EField fires,
      -- and the strike STANDS -- proving the strict-threshold semantics, not
      -- just the then-branch (FORMALIS: kills the always-then RWhen mutant).
    , transportVersion CADividendSpecial 1 (1 / 4) tvO == Just tvO
      -- (d) designated discretion, unresolved -> fail-closed refusal
    , transportVersion CADividendSpecial 1 c tvP == Nothing
    , evalRule CADividendSpecial (RByParty "exchange") 1 c (TVPrice p) == Nothing
    ]
  where
    c           = 2                                       -- a special dividend of EUR 2
    p           = toRational (100 + (strikeRaw `mod` 400))  -- drawn strike, >= 100
    override    = RWhen ECash (ELit (1 / 2))
                        (RSet (ESub EField (ESub ECash (ELit (1 / 2)))))
                        (RSet EField)
    schO        = Schedule (Map.singleton (CADividendSpecial, "strike") override)
    tvO         = TermsVersion "special-div" (Map.singleton "strike" (TVPrice p)) schO
    tvSet v     = tvO { tvFields = Map.singleton "strike" (TVPrice v) }
    declaredVal = p - (c - 1 / 2)                          -- override result: p - 1.5
    classDefVal = (p - c) / 1                              -- class default: p - 2
    schP        = Schedule (Map.singleton (CADividendSpecial, "strike") (RByParty "exchange"))
    tvP         = TermsVersion "byparty" (Map.singleton "strike" (TVPrice p)) schP
    tv100       = TermsVersion "special-div" (Map.singleton "strike" (TVPrice 100)) schO

-- =============================================================================
-- BS-5 (WILSON blind spot): P27 as an END-TO-END producer trial, not oracle
-- mechanics. From a SEALED prefix carrying a declared split boundary on unit u,
-- the producer reads the boundary's (f, c) off the log, RESOLVES the unit's
-- terms version through the schedule (`transportVersion`), and appends the
-- resolved version caused by the boundary. The reference recomputes the
-- identical value (diff zero); perturbing one transported field yields a nonzero
-- diff caught by `recomputeOK`. The factor is drawn in {2, 3}, so the resolution
-- actually MOVES the fields (strike (p - 0)/f, mult q*f) on every seed -- never a
-- vacuous identity.
-- =============================================================================
producerE2EOK :: Integer -> Bool
producerE2EOK fRaw =
  case replay pfx emptyLedger of
    Left _  -> False                       -- the prefix MUST replay
    Right l ->
      let honest    = procE pfx l
          perturbed = honest { txAppend = fmap bump (txAppend honest) }
          bump v    = v { tvFields = Map.insert "strike" (TVPrice 777) (tvFields v) }
          -- the resolution, recomputed INDEPENDENTLY as specification data
          -- (strike (p - 0)/f, mult q*f), so BS-5 also pins the arithmetic and
          -- does not rest solely on procE's self-consistency (FORMALIS hardening).
          resolved  = Map.fromList [ ("strike", TVPrice (100 / toRational f))
                                   , ("mult",   TVQty  (5 * toRational f)) ]
      in recomputeOK procE pfx honest
         && not (recomputeOK procE pfx perturbed)
         && fmap tvFields (txAppend honest) == Just resolved
  where
    u    = UnitId "u-e2e"
    f    = 2 + (fRaw `mod` 2)               -- {2, 3}: resolution is never the identity
    bid  = BoundaryId "e2e-b"
    be   = BoundaryEvent bid (Timestamp 500) 0 (DeclParams (toRational f) 0 Nothing)
    tv0  = TermsVersion "reg"
             (Map.fromList [("strike", TVPrice 100), ("mult", TVQty 5)])
             emptySchedule
    btx  = Transaction
             { txUnit = u, txMoves = [], txRows = Map.empty
             , txStatus = [SetBasis (Boundary bid)]
             , txIntroduce = Nothing, txAppend = Nothing
             , txBoundary = Just be, txCause = Nothing }
    pfx  = [registerTx u tv0 (defaultStatus u), btx]

    procE :: [Transaction] -> Ledger -> Transaction
    procE txs l =
      case [ b | t <- reverse txs, Just b <- [txBoundary t] ] of
        (b : _) | DeclParams ff cc _ <- bevDecl b ->
            let tv  = maybe tv0 currentTerms (Map.lookup u (ledgerPT l))
                tv' = maybe tv id (transportVersion CASplit ff cc tv)
            in withCause (bevId b) (appendTx u tv')
        _ -> appendTx u tv0

-- -----------------------------------------------------------------------------
-- Conformance-tier witnesses P32-P34 (documented, NOT suite code). Their
-- executable form lives where `transport` lives -- outside this module, with
-- W-D2.2/W-D2.4 -- because the reference carries no operator arithmetic (AD-2:
-- the OpSpec menu stays out; the module carries only the invariance parameters
-- declF/declC that `requireInvariance` consumes). House precedent: P25's and
-- P26's executable forms already live outside the core block.
--
--   P32 Confirmation gate: a Pending boundary blocks consumption, and an empty
--       declaration yields REFUSAL, never identity (oracles
--       pendingBlocksConsumption / noOperatorNoAdjustment).
--   P33 Elective aggregate invariance: against the restated two-case weld
--       (Ruling 2d / E1). It cannot run against this reference, whose
--       per-holder check models uniform boundaries only; the uniform case
--       keeps its existing weld witness -- both run, neither substitutes.
--   P34 Basket joint consumption (Ruling 2f / E2): the spin-off basket datum
--       is derivable only as a JOINTLY-stamped pair; projection onto a single
--       component is refused (C13) until a fresh per-component stamped
--       observation arrives, at which point the basket bridge RETIRES; the
--       transported basket mark carries lineage (txCause) to the spin-off
--       boundary.
--
-- W-D2.2/W-D2.4 remain conformance obligations attached to
-- prop:composition-law (no P numbers); their declF/declC leg rides P30's
-- suite run.
-- -----------------------------------------------------------------------------

-- =============================================================================
-- PART M -- the market-data boundary (§8, the market-data contract).
--
-- Exactly two arrows cross this boundary. OUT: the basis projection --
-- `BasisView`, a READ-ONLY view of the log, same rank as UnitStatus (derivable,
-- discardable, never authoritative) -- consumable by any ingestion layer. IN:
-- raw observations through `ingest`, the sole door, where the LEDGER attaches
-- the stamp. The market-data layer never writes ledger state; the ledger never
-- accepts a basis it did not stamp or verify against its own committed chain.
--
-- Stamping authority: the committed boundary chain is the single source of
-- basis truth; the ingestion layer stamps by consulting this projection, never
-- by re-implementing corporate-action logic. The projection is ARITHMETIC-FREE:
-- it exposes positions ON the chain and nothing else -- no operator kinds, no
-- parameters, no arrows -- so "no corporate-action logic outside the Ledger"
-- holds by information hiding: an external component does not possess the
-- information needed to adjust. Adjustment arrows are declared once, in the
-- log, and applied by the one evaluator; the ingestion layer's whole competence
-- is transcription -- of values, times, and conventions -- never adjustment.
--
-- Abstractness is again load-bearing. BasisView and StampedObs export no
-- constructor: a view cannot be mutated or forged, so a stamp is a pure total
-- function of a pinned value; a StampedObs exists outside this module ONLY as
-- the Right image of the door, so "no unstamped observation is consumable" has
-- a type-fact half (no side door -- the `total`/`fibreOK` register, unnumbered)
-- beside its property half (P25, below) and its consumption half (C13 at
-- withSnapshot, in the specification).
-- =============================================================================

-- The projection version. Every stamp records the version it consulted, so the
-- stamp replays as a pure function of recorded data. In production the pin is
-- the as-of log position held by the log store; the sealed `Ledger` VALUE
-- carries no position, so this reference identifies a view by the CONTENT
-- ADDRESS of the projection itself -- the BoundaryId precedent (Part A): equal
-- projections get equal versions, and the version is never an ordinal that a
-- retro-effective boundary would renumber. Every property below consumes only
-- its Eq; clone reconstruction (pCloneStamp) recovers the pin from the log.
newtype ViewVersion = ViewVersion Integer deriving (Eq, Ord, Show)

-- The version of the source basis convention consulted (O4): the per-(unit,
-- source) convention is kept on file as logged observation events, versioned
-- and as-of-queryable, owned by market-data operations under TA-BASIS. The
-- gateway transcribes the consulted entry onto the raw record (`rdConv`); the
-- stamp envelope records the version, so the stamp's provenance is data.
newtype ConvVersion = ConvVersion Integer deriving (Eq, Ord, Show)

-- -----------------------------------------------------------------------------
-- The basis projection. `bvChain` is the committed effective-order chain per
-- unit -- the same (t_eff, prec, bid) triples as `ledgerBounds`, whose derived
-- Ord IS the effective order; `bvBeta` is replayed `usBasis` over registered
-- units, so `betaAt`'s Maybe distinguishes UNREGISTERED (Nothing: the door's
-- refusal is a pattern match that cannot be forgotten) from registered-and-at-
-- origin (Just (Origin u)) -- an Origin default for an unregistered unit would
-- be a guessed basis wearing a type. Immutable once constructed; monotone under
-- append (P24 corollary: the tip never regresses, and an on-chain id stays
-- on-chain under every later view); cache-vs-replay agreement is inherited from
-- P24 -- zero new proof obligations.
-- -----------------------------------------------------------------------------

-- -----------------------------------------------------------------------------
-- The datum-kind registry (D4). A datum kind declares, component by component,
-- how a datum of that kind behaves under basis transport -- and the dimensions
-- are declared through the NON-QUANTITY gate (nonQtyDim): an observation is
-- never an entitlement, so a quantity-dimensioned component is unrepresentable.
-- Two values that transform differently under the same operator are DIFFERENT
-- kinds (Ruling 2c: absolute-strike vol and moneyness vol are two kind ids;
-- the quotation-convention text stays on the entry as attested provenance,
-- checkable, never branched on). Registration is immutable: a correction is a
-- NEW kind plus a logged retirement closing the old to new ingestion -- and
-- retirement is spec-only (E10): no witness consumes it, so this reference
-- carries no retirement machinery.
--
-- E3 (TA-KIND, bounded): every registry entry carries its invariance witness
-- BY CONSTRUCTION -- dkWitness is a mandatory field, so a witness-less kind is
-- unrepresentable, not merely refused. The trust assumption is only ever as
-- wide as the witnesses pinning each entry.
-- -----------------------------------------------------------------------------

newtype KindId = KindId String deriving (Eq, Ord, Show)

-- The mandatory per-entry invariance witness (E3). A scalar kind cites the
-- proved theorem instance (thm:basis-value-invariance) -- citing a theorem
-- discharges the obligation without one oracle per trivial entry; a composite
-- kind names its catalogue oracle (the dividend-list kind names dkDivSplitOK).
data KindWitness
  = WitnessByTheorem       -- cites thm:basis-value-invariance
  | WitnessOracle String   -- names the catalogue oracle that pins the entry
  deriving (Eq, Ord, Show)

data DatumKind = DatumKind
  { dkId         :: KindId
  , dkComponents :: [(String, NonQtyDim)]  -- component dimension declaration,
                                           --   through the non-quantity gate
  , dkWitness    :: KindWitness            -- mandatory: E3's bound on TA-KIND
  } deriving (Eq, Ord, Show)

-- | The registry projection: the fold of the attested registration log.
--   Registration is IMMUTABLE -- the first entry for an id wins and a
--   re-registration is inert (the P6 idiom), so a later conflicting
--   registration cannot silently redefine transport behaviour.
kindRegistry :: [DatumKind] -> Map KindId DatumKind
kindRegistry = foldl' (\m dk -> Map.insertWith (\_ old -> old) (dkId dk) dk m) Map.empty

data BasisView = BasisView
  { bvChain   :: Map UnitId (Set (Timestamp, Integer, BoundaryId))
  , bvBeta    :: Map UnitId BasisId
  , bvKinds   :: Map KindId DatumKind   -- the registry projection (D4): a
                                        --   log-derived cache like bvBeta, pinned
                                        --   by the SAME version (soView) -- one
                                        --   pin, no second envelope field; never
                                        --   authoritative
  , bvVersion :: ViewVersion
  } deriving (Eq, Show)

-- Deterministic content address of a projection: a fold over the canonical
-- (ascending) rendering of its content. Equal content, equal address. The
-- registry is content, so a stamp's soView pins the vocabulary it was
-- admitted under.
mintViewVersion :: Map UnitId (Set (Timestamp, Integer, BoundaryId))
                -> Map UnitId BasisId -> Map KindId DatumKind -> ViewVersion
mintViewVersion ch be ks =
  ViewVersion (foldl' (\h c -> h * 131 + toInteger (fromEnum c)) 7
                 (show ( Map.toAscList (fmap Set.toAscList ch)
                       , Map.toAscList be
                       , Map.toAscList ks )))

-- | The projection of a ledger's committed state. A view of the log like every
--   other projection: `ledgerBounds` and `ledgerUS` are themselves derivable
--   caches of the log (rebuilt by replay), so `basisView` composes projections
--   and adds no authority. A Ledger VALUE carries no datum vocabulary: the
--   registry arrives from its own attested registration log via `withKinds`,
--   and a view without one refuses every datum at the kind guard (fail-closed).
basisView :: Ledger -> BasisView
basisView l = BasisView ch be Map.empty (mintViewVersion ch be Map.empty)
  where ch = ledgerBounds l
        be = fmap usBasis (ledgerUS l)

-- | Attach the registry projection to a pinned view, re-minting the content
--   address so ONE version covers both projections. The argument is the
--   attested registration log -- each element one kind-registration event,
--   identity its own content; no txCause (governance events are not CA-caused
--   transactions, Ruling 2e).
withKinds :: [DatumKind] -> BasisView -> BasisView
withKinds ds v =
  v { bvKinds = reg, bvVersion = mintViewVersion (bvChain v) (bvBeta v) reg }
  where reg = kindRegistry ds

-- | Nothing = the kind is not registered (the door refuses, P31); Just dk =
--   the registered declaration. The `betaAt` of the registry.
kindAt :: BasisView -> KindId -> Maybe DatumKind
kindAt v k = Map.lookup k (bvKinds v)

-- | The standing suite vocabulary: the registration log the property harness
--   attaches to every view it pins (and that pRepro/pCloneStamp re-attach when
--   they reconstruct a pin from the transaction log -- the vocabulary is a
--   CONSTANT of the trial, so reconstruction stays a pure function of recorded
--   data). Per Ruling 2c the two vol conventions are two KINDS: the
--   absolute-strike entry declares its strike component price-in-basis (it
--   transforms) and its vol value dimensionless (invariant, E5); the moneyness
--   entry is dimensionless throughout. Scalar kinds cite the theorem; the
--   composite dividend-list kind names its oracle (dkDivSplitOK) -- every
--   entry carries its witness (E3).
baseKinds :: [DatumKind]
baseKinds =
  [ DatumKind (KindId "spot")
      (comps [("value", DimPrice)]) WitnessByTheorem
  , DatumKind (KindId "vol-absolute-strike")
      (comps [("strike", DimPrice), ("vol", DimNone)]) WitnessByTheorem
  , DatumKind (KindId "vol-moneyness")
      (comps [("moneyness", DimNone), ("vol", DimNone)]) WitnessByTheorem
  , DatumKind (KindId "dividend-list")
      (comps [("cash-per-share", DimPrice), ("proportional", DimNone)])
      (WitnessOracle "dkDivSplitOK")
  ]
  where comps ps = [ (n, d') | (n, d) <- ps, Just d' <- [nonQtyDim d] ]

-- | The composite-kind invariance oracle (D4/E3), riding P30's suite run. The
--   dividend-list kind declares its cash-per-share component price-in-basis
--   (per-share money divides by f) and its proportional component
--   dimensionless (untouched). Under a declared ratio event with factor f the
--   per-holder payout q * d is then invariant -- (q*f) * (d/f) == q*d -- and
--   the MISDECLARATION PROBE (the same component declared DimCash, fixed) pays
--   wrong on every real entry (f /= 1, q /= 0, d /= 0): the witness that pins
--   the registry entry. Scalar kinds cite thm:basis-value-invariance instead;
--   the catalogue does not grow one oracle per trivial entry.
dkDivSplitOK :: Rational -> Rational -> Rational -> Bool
dkDivSplitOK f q d =
  case ( transportField f 0 (TVQty q)
       , transportField f 0 (TVPrice d)      -- declared per-share: transforms
       , transportField f 0 (TVCash d) ) of  -- misdeclared as cash: fixed
    (Just (TVQty q'), Just (TVPrice d'), Just (TVCash dBad)) ->
         q' * d' == q * d
      && (f == 1 || q == 0 || d == 0 || q' * dBad /= q * d)
    _ -> f == 0    -- transport is refused exactly at the degenerate factor

-- P31 Kind totality at the ingest door (the P25 shape). Over a pinned view
-- carrying the registry: a datum whose kind IS registered is never refused
-- for kind reasons -- the door is total over registered kinds, and whatever
-- basis-plane refusal remains names a basis error, never the kind -- and a
-- datum whose kind is NOT registered is refused UnregisteredKind with the
-- payload retained verbatim (fail-closed; TA-KIND is only as wide as the
-- witnesses pinning each entry, E3). The Property record's Ledger parameter
-- is unused: the registry rides the pinned view.
pKindTotal :: Property (BasisView, SourceId, Timestamp, RawDatum)
                       (Either IngestError StampedObs)
pKindTotal = Property (\_ _ -> True) $ \_ (v, _, _, rd) o ->
  if rdKind rd `Map.member` bvKinds v
    then case o of
           Left (UnregisteredKind _ _) -> False
           _                           -> True
    else o == Left (UnregisteredKind (rdKind rd) rd)

-- | The as-of view (the P8 clone machinery): the projection of the log as it
--   was KNOWN at booking time t. Booking time in this reference is the log
--   position itself -- the k-th transaction (counting from 1) books at
--   Timestamp k -- so the as-of cut is a prefix cut, exactly clone_at, and no
--   booking timestamp is added to the Transaction payload. The fold is
--   error-stopping like `replay`: a rejected event never enters the committed
--   log, so the committed log IS the accepted prefix.
viewAsOf :: [Transaction] -> Timestamp -> BasisView
viewAsOf txs (Timestamp t) =
    basisView (go emptyLedger (take (fromInteger (max 0 t)) txs))
  where
    go l []          = l
    go l (tx : rest) = case applyTx tx l of
                         Left _   -> l          -- the committed log ends here
                         Right l' -> go l' rest

viewVersion :: BasisView -> ViewVersion
viewVersion = bvVersion

-- | Nothing = the unit is not registered (the door refuses, O5); Just b = the
--   prevailing basis (replayed usBasis; by P24, the committed chain's tip).
betaAt :: BasisView -> UnitId -> Maybe BasisId
betaAt v u = Map.lookup u (bvBeta v)

-- | The unit's committed chain, ascending in the effective order (t_eff, prec,
--   bid) -- the read a re-stamp repair or a backward transport pins against.
chainAt :: BasisView -> UnitId -> [(Timestamp, Integer, BoundaryId)]
chainAt v u = Set.toAscList (Map.findWithDefault Set.empty u (bvChain v))

-- | The admission predicate: is b a committed point of u's chain? The origin
--   of a REGISTERED unit is the chain's base point; a boundary id is on-chain
--   iff the chain carries it. A claim naming anything else is refused
--   (OffChainClaim) -- in particular a pro-forma claim on a not-yet-committed
--   boundary, which is re-presented after the boundary commits at effectiveness.
onChain :: BasisView -> UnitId -> BasisId -> Bool
onChain v u (Origin u')    = u' == u && Map.member u (bvBeta v)
onChain v u (Boundary bid) = any (\(_, _, b) -> b == bid) (chainAt v u)

-- -----------------------------------------------------------------------------
-- The raw observation and the source basis convention.
--
-- A raw observation carries exactly what a provider owes (O1): an exact value,
-- a resolvable unit reference, and -- attached by the gateway from the
-- convention on file, under signature (O4/O7) -- the source basis convention
-- entry consulted, with its version. Providers are NOT required to be
-- corporate-action-aware (O3): a pre-adjusting source and a lagging source are
-- both representable, because the convention says WHICH chain position the
-- source's dissemination is in -- App. D's `mQuoteEx` generalised from one bit
-- to the coordinate. The alphabet is a chain-position CLAIM, never a
-- computation: no parameter, no arrow, no adjustment is expressible here.
-- -----------------------------------------------------------------------------

data Convention
  = TracksChain          -- caught up: the value is in the chain position at t_obs
  | LagsBy Integer       -- still publishing k boundaries behind that position
  | PreAdjusts           -- adjusts at commit: the value is at the pinned view's tip
  | DeclaredAt BasisId   -- file declared adjusted-through a named basis (O6);
                         --   the door checks the claim against the chain
  | NoClaim              -- nothing on file: refused, quarantined (O5)
  deriving (Eq, Show)

data RawDatum = RawDatum
  { rdUnitRef :: String                     -- provider's unit reference (O1)
  , rdValue   :: Integer                    -- exact disseminated value (O1)
  , rdConv    :: (ConvVersion, Convention)  -- convention consulted (O2/O4)
  , rdKind    :: KindId                     -- the claimed datum kind (D4): a NAME
                                            --   resolved against the registry at the
                                            --   door -- never a declaration; the
                                            --   declaration lives on the registered
                                            --   entry, one per vocabulary
  } deriving (Eq, Show)

-- The stamped observation. ABSTRACT: the constructor is not exported, so the
-- Right image of `ingest` is the WHOLE consumable plane -- no side door. The
-- envelope records the projection version and convention version consulted
-- (O2), so every stamp replays as a pure function of recorded data.
data StampedObs = StampedObs
  { soValue  :: Integer
  , soTObs   :: Timestamp
  , soSource :: SourceId
  , soStamp  :: Map UnitId BasisId   -- singleton for a plain observation
  , soView   :: ViewVersion          -- projection version consulted
  , soConv   :: ConvVersion          -- convention version consulted
  } deriving (Eq, Ord, Show)

obsValue  :: StampedObs -> Integer
obsValue  = soValue
obsTime   :: StampedObs -> Timestamp
obsTime   = soTObs
obsSource :: StampedObs -> SourceId
obsSource = soSource
obsStamp  :: StampedObs -> Map UnitId BasisId
obsStamp  = soStamp
obsView   :: StampedObs -> ViewVersion
obsView   = soView
obsConv   :: StampedObs -> ConvVersion
obsConv   = soConv

-- The Left branch IS the quarantine: refused with payload retained, never
-- given a guessed basis, never defaulted from the ledger's prevailing state
-- (O5). The quarantine store is the fold of Lefts, inspected by the W3
-- workflow; `retained` is its accessor.
data IngestError
  = UnregisteredUnit  UnitId RawDatum          -- unresolvable reference: refused outright
  | UndeterminedBasis UnitId RawDatum          -- no convention on file: quarantined
  | OffChainClaim     UnitId BasisId RawDatum  -- claim names no committed chain point
  | UnregisteredKind  KindId RawDatum          -- the claimed kind is not in the pinned
                                               --   registry: refused, quarantined (D4;
                                               --   the error names the missing
                                               --   REGISTRATION, not the door's ignorance)
  deriving (Eq, Show)

retained :: IngestError -> RawDatum
retained (UnregisteredUnit  _ rd)   = rd
retained (UndeterminedBasis _ rd)   = rd
retained (OffChainClaim     _ _ rd) = rd
retained (UnregisteredKind  _ rd)   = rd

-- -----------------------------------------------------------------------------
-- The door. `ingest` keeps its published signature and is the factoring
-- `ingest l = ingestAt (basisView l)`: the market-data layer links against
-- `ingestAt` only, so the Ledger value never crosses the boundary -- the
-- projection does. Every input of the stamp is a value argument (the pinned
-- view, the convention on the datum, t_obs, the source, the raw value); no
-- clock and no ambient state is read, so the stamp is a pure total function
-- and one ingestion run pins one projection version by construction.
-- -----------------------------------------------------------------------------

-- | The chain position at time t in EFFECTIVE order: the maximal committed
--   boundary with t_eff <= t, or the origin. A declared-convention computation
--   (TracksChain / LagsBy consume it) -- never a stamp default: a datum with no
--   convention is refused, never positioned (O5). t is the datum's t_obs, an
--   input the convention uses; it is never itself the coordinate.
chainPosAt :: BasisView -> UnitId -> Timestamp -> BasisId
chainPosAt v u t =
  case [ bid | (te, _, bid) <- chainAt v u, te <= t ] of
    [] -> Origin u
    bs -> Boundary (last bs)

-- | The position k boundaries behind the chain position at t (a lagging
--   source's convention), floored at the origin. Total.
lagPosAt :: BasisView -> UnitId -> Timestamp -> Integer -> BasisId
lagPosAt v u t k =
  case drop (fromInteger (max 0 k))
            (reverse [ bid | (te, _, bid) <- chainAt v u, te <= t ]) of
    []      -> Origin u
    (b : _) -> Boundary b

-- | Stamp one raw observation against one pinned view. Total; deterministic in
--   its visible arguments (pDet). The door refuses (Left, payload retained)
--   rather than guess: an unregistered reference, a missing convention, and a
--   claim naming no committed chain point -- the pro-forma case included: a
--   datum claiming a boundary that has not yet committed at effectiveness is
--   an OffChainClaim, re-presented after the boundary commits.
ingestAt :: BasisView -> SourceId -> Timestamp -> RawDatum
         -> Either IngestError StampedObs
ingestAt v _ _ rd
  -- The kind guard (D4/P31): an unregistered kind never enters the consumable
  -- plane -- fail-closed BEFORE any basis reasoning, so a refusal is
  -- deterministic in the pinned registry alone. Registered kinds pass through
  -- untouched: the door is TOTAL over them, and no arm below reads the kind
  -- again (transport, outside this module, reads the registered declaration).
  | not (rdKind rd `Map.member` bvKinds v) = Left (UnregisteredKind (rdKind rd) rd)
ingestAt v src tObs rd =
  case betaAt v u of
    Nothing  -> Left (UnregisteredUnit u rd)
    Just tip -> case conv of
      NoClaim      -> Left (UndeterminedBasis u rd)
      TracksChain  -> stampAs (chainPosAt v u tObs)
      LagsBy k     -> stampAs (lagPosAt v u tObs k)
      PreAdjusts   -> stampAs tip
      DeclaredAt b
        | onChain v u b -> stampAs b
        | otherwise     -> Left (OffChainClaim u b rd)
  where
    u          = UnitId (rdUnitRef rd)
    (cv, conv) = rdConv rd
    stampAs b  = Right StampedObs
      { soValue = rdValue rd, soTObs = tObs, soSource = src
      , soStamp = Map.singleton u b
      , soView  = bvVersion v, soConv = cv }

-- | The published door (§8): the sole path from a raw vendor number to a
--   consumable observation -- the parse-boundary idiom of `move`.
ingest :: Ledger -> SourceId -> Timestamp -> RawDatum
       -> Either IngestError StampedObs
ingest l = ingestAt (basisView l)

-- -----------------------------------------------------------------------------
-- One ingestion run at one pinned view: the fold of the door over a feed.
-- Committed observations dedup by content address -- the StampedObs value IS
-- its content, so Set membership is the P6 idiom at the observation plane: a
-- duplicate submission re-mints the identical value and the insert is inert.
-- Refusals are retained in arrival order -- the quarantine.
-- -----------------------------------------------------------------------------

ingestRun :: BasisView -> [(SourceId, Timestamp, RawDatum)]
          -> (Set StampedObs, [IngestError])
ingestRun v = ingestResume v Set.empty

ingestResume :: BasisView -> Set StampedObs -> [(SourceId, Timestamp, RawDatum)]
             -> (Set StampedObs, [IngestError])
ingestResume v acc0 = foldl' step (acc0, [])
  where
    step (acc, qs) (s, t, rd) = case ingestAt v s t rd of
      Left e   -> (acc, qs ++ [e])
      Right so -> (Set.insert so acc, qs)

-- | Partition a set of stamped observations by stamp -- the W3 partition.
--   Vendor disagreement on VALUE inside one cell is data quality, out of
--   scope; disagreement on BASIS is two cells, in scope, resolved by the
--   stamp. Sound by construction: the key IS the stamp.
partitionByStamp :: [StampedObs] -> Map (Map UnitId BasisId) [StampedObs]
partitionByStamp sos =
  Map.fromListWith (flip (++)) [ (obsStamp so, [so]) | so <- sos ]

-- -----------------------------------------------------------------------------
-- The ingestion property catalogue (App. B shape). Property-shaped where the
-- claim is per-invocation (P25, the P1/P2 precedent); boolean oracles where it
-- quantifies over a log or a feed (the P8/P24 precedent). All properties are
-- authored with generators and shrinkers and verified by inspection; execution
-- is pending the toolchain and is not reported as passed.
-- -----------------------------------------------------------------------------

-- P25 Ingest-door soundness. Run o = ingest l s t rd. On Right: every stamped
-- unit is registered and every stamped id is a committed point of that unit's
-- chain (origin included) -- nothing enters the consumable plane claiming a
-- basis the ledger has not committed. On Left: nothing is admitted and the
-- payload is retained verbatim -- the Left IS the quarantine. Wrongful-
-- rejection is the vacuous half, as in P1/P2. The no-side-door half is the
-- type fact stated at StampedObs; the consumption half is C13 at withSnapshot.
p25 :: Property (SourceId, Timestamp, RawDatum) (Either IngestError StampedObs)
p25 = Property (\_ _ -> True) $ \l (_, _, rd) o -> case o of
  Left e   -> retained e == rd
  Right so -> all (\(u, b) -> registered l u && onChain (basisView l) u b)
                  (Map.toList (obsStamp so))

-- P-DET Stamp determinism, restated as the purity witness (the pureL
-- precedent): the stamp is a total pure function of (projection version,
-- convention version, source, t_obs, raw) and of NOTHING else -- every input
-- is a value argument; no clock, no ambient log read.
pDet :: BasisView -> SourceId -> Timestamp -> RawDatum -> Bool
pDet v s t rd = ingestAt v s t rd == ingestAt v s t rd

-- P-MODE Mode equivalence -- the executable shadow of a one-sentence theorem:
-- the stamp is a pure function of the pinned view and the datum, so arrival
-- MODE (tick-by-tick, end-of-day file, resumed run) cannot enter the result.
-- One datum through the door equals the same datum inside any batch at the
-- same pin; a boundary committing mid-run cannot tear the run, because the
-- run never re-reads the ledger.
pMode :: BasisView -> [(SourceId, Timestamp, RawDatum)] -> Bool
pMode v feed =
  fst (ingestRun v feed)
    == Set.fromList [ so | (s, t, rd) <- feed, Right so <- [ingestAt v s t rd] ]

-- P-PERM-N Notice-order irrelevance, strong form: the effective order is data
-- in the notices ((t_eff, prec, bid)), so booking order cannot enter the chain
-- projection or the tip. A naive permutation of a committed log is mostly
-- REFUSED by the tip weld -- each SetBasis re-assertion is derived for its own
-- booking position -- and a refused replay asserts nothing (P2's half), so the
-- naive trial is vacuous almost always. The oracle therefore re-derives what
-- is derived and permutes only what is data: the boundary NOTICES are permuted
-- among their own positions (registrations stay put, permuteBoundariesBy) and
-- each SetBasis is re-asserted to the post-insertion tip of the NEW order
-- (rebook), exactly as genChain mints it. Every permutation of a generated
-- chain then replays Right, and the trial is non-vacuous by construction; the
-- vacuous branch remains only for adversarial inputs, where refusal is P2's
-- half, as before.
pPermN :: [Transaction] -> [Int] -> Bool
pPermN txs perm =
  case ( replay txs emptyLedger
       , replay (rebook (permuteBoundariesBy perm txs)) emptyLedger ) of
    (Right a, Right b) ->
      all (\u -> chainAt (basisView a) u == chainAt (basisView b) u
              && betaAt  (basisView a) u == betaAt  (basisView b) u)
          (map txUnit txs)
    _ -> True

-- | Permute the boundary-carrying transactions among their own positions,
--   leaving every other transaction (registration included) where it stands:
--   the permutation permutes notices, never the log's shape.
permuteBoundariesBy :: [Int] -> [Transaction] -> [Transaction]
permuteBoundariesBy ks txs = go txs (permuteBy ks [ tx | tx <- txs, isB tx ])
  where
    isB tx = case txBoundary tx of Just _ -> True; Nothing -> False
    go []       _  = []
    go (t : ts) ps
      | isB t     = case ps of (p : ps') -> p : go ts ps'
                               []        -> t : go ts []
      | otherwise = t : go ts ps

-- | Re-assert each boundary transaction's SetBasis to the post-insertion
--   effective tip of ITS OWN booking order, per unit -- the derived write
--   recomputed, the notice untouched, other status writes passed through.
--   Agrees with the tip weld's tipAfter for logs replayed from emptyLedger,
--   which is exactly how pPermN consumes it.
rebook :: [Transaction] -> [Transaction]
rebook = go Map.empty
  where
    go _   []        = []
    go acc (tx : ts) = case txBoundary tx of
      Nothing -> tx : go acc ts
      Just be ->
        let u   = txUnit tx
            s'  = Set.insert (bevTEff be, bevPrec be, bevId be)
                             (Map.findWithDefault Set.empty u acc)
            tip = case Set.lookupMax s' of
                    Nothing        -> Origin u
                    Just (_, _, b) -> Boundary b
            re w = case w of SetBasis _ -> SetBasis tip; _ -> w
        in tx { txStatus = map re (txStatus tx) } : go (Map.insert u s' acc) ts

-- P-PERM-O Observation-order irrelevance: at a fixed pin, the committed set of
-- a run is invariant under any permutation of arrivals -- each datum's stamp
-- is a function of the pin and the datum, never of its neighbours. (The
-- quarantine LIST keeps arrival order and is not claimed; the committed SET is.)
pPermO :: BasisView -> [(SourceId, Timestamp, RawDatum)] -> [Int] -> Bool
pPermO v feed perm =
  fst (ingestRun v feed) == fst (ingestRun v (permuteBy perm feed))

-- P-CRASH Crash recovery: a run interrupted after k data leaves exactly its
-- committed prefix -- a StampedObs exists only as an appended event, so
-- crash-before-append is nothing-happened -- and resubmitting the WHOLE feed
-- against the SAME pin dedups by content address and lands on the
-- uninterrupted run's committed set. Every crash point recovers to a committed
-- prefix, and then to the run itself.
pCrash :: BasisView -> [(SourceId, Timestamp, RawDatum)] -> Int -> Bool
pCrash v feed k =
  fst (ingestResume v (fst (ingestRun v (take k feed))) feed)
    == fst (ingestRun v feed)

-- P-REPRO Reproducibility (as-of stability): the view as-of booking position c
-- is unchanged by anything booked after c -- viewAsOf is prefix-stable -- so a
-- stamp replayed today against the recorded pin is bit-identical to the stamp
-- minted then. Same log, same observations, same pinned version: the same
-- StampedObs, and (with P8 and C13) the same valuations.
pRepro :: [Transaction] -> Timestamp -> Int -> (SourceId, Timestamp, RawDatum) -> Bool
pRepro txs (Timestamp c) ext (s, t, rd) =
  let m = fromInteger (max 0 c) + max 0 ext          -- any later extension
      pin ts = withKinds baseKinds (viewAsOf ts (Timestamp c))
      -- the standing vocabulary rides the pin (D4): reconstruction re-attaches
      -- the same registration log, itself recorded data, so the rebuilt view
      -- is still a pure function of recorded inputs
  in ingestAt (pin (take m txs)) s t rd == ingestAt (pin txs) s t rd

-- P-CLONE-STAMP clone_at stamp reconstruction: for a stamp minted at ANY
-- booking cut, the log alone reconstructs the pin -- some cut's rebuilt view
-- carries the recorded projection version (a content address, so a
-- retro-effective boundary booked later renumbers nothing) -- and EVERY cut
-- carrying that version re-mints the stamp bit-identically. The as-known-at-t
-- replay thus reproduces the honest mistake rather than repairing it; the
-- corrected reading is the same door at the tip pin (deterministic by pDet);
-- re-coordination beyond that is exclusively the ledger's re-stamp event with
-- lineage (O8), outside this oracle.
pCloneStamp :: [Transaction] -> (SourceId, Timestamp, RawDatum) -> Bool
pCloneStamp txs (s, t, rd) = all cutOK cuts
  where
    cuts = [0 .. toInteger (length txs)]
    viewAt k = withKinds baseKinds (viewAsOf txs (Timestamp k))
    -- the standing vocabulary rides every reconstructed pin (D4): soView
    -- covers the registry, so a cut re-mints the stamp only when it carries
    -- the same chain, beta AND vocabulary -- recorded data throughout
    cutOK k = case ingestAt (viewAt k) s t rd of
      Left _   -> True                     -- a refusal asserts nothing (P2's half)
      Right so ->
        let hits = [ j | j <- cuts, bvVersion (viewAt j) == obsView so ]
        in  not (null hits)
            && all (\j -> ingestAt (viewAt j) s t rd == Right so) hits

-- P-LAG Lag-convention arithmetic: a LagsBy k stamp sits exactly k
-- effective-order steps behind the caught-up position at the same t_obs,
-- floored at the origin -- and LagsBy 0 IS TracksChain. P25 cannot see an
-- off-by-one here, because any on-chain id is sound; the arithmetic therefore
-- carries its own oracle, computed independently by positional indexing where
-- lagPosAt drops from the reversed chain. Drivers: views from genChain via
-- viewAsOf, t and k drawn by nextInt, k shrunk by shrinkInteger.
pLag :: BasisView -> UnitId -> Timestamp -> Integer -> Bool
pLag v u t k =
  let path = [ bid | (te, _, bid) <- chainAt v u, te <= t ]   -- ascending
      k'   = fromInteger (max 0 k)
      want | length path <= k' = Origin u
           | otherwise         = Boundary (path !! (length path - 1 - k'))
  in lagPosAt v u t k == want  &&  lagPosAt v u t 0 == chainPosAt v u t

-- F10 Basis-partition separation: observations aggregate only within one stamp
-- cell. The oracle witnesses the partition's soundness; that no AGGREGATE can
-- consume two cells is the consumption seam's type fact (C13), not re-proved
-- here.
pPartition :: [StampedObs] -> Bool
pPartition sos =
  all (\(st, cell) -> all ((== st) . obsStamp) cell)
      (Map.toList (partitionByStamp sos))

-- -----------------------------------------------------------------------------
-- Generators and shrinkers. Deterministic and pure -- no external dependency:
-- a Seed drives a splittable linear congruence, every generator is a total
-- function of its Seed, every shrinker is a pure enumeration toward the
-- structurally smaller candidate. The suite is driven by test/RunProps.hs
-- (each property over deterministic seeds, shrinking to a minimal reproduction).
-- -----------------------------------------------------------------------------

newtype Seed = Seed Integer deriving (Eq, Show)

stepSeed :: Seed -> Seed
stepSeed (Seed s) =
  Seed ((6364136223846793005 * s + 1442695040888963407) `mod` 9223372036854775783)

-- | A draw uniform-ish in [0, n) together with the advanced seed. Total: the
--   modulus is floored at 1.
nextInt :: Integer -> Seed -> (Integer, Seed)
nextInt n sd = let sd'@(Seed v) = stepSeed sd in (v `mod` max 1 n, sd')

splitSeed :: Seed -> (Seed, Seed)
splitSeed (Seed s) = (stepSeed (Seed (2 * s + 1)), stepSeed (Seed (3 * s + 2)))

shrinkInteger :: Integer -> [Integer]
shrinkInteger n
  | n == 0    = []
  | otherwise = 0 : [ n `div` 2 | n `div` 2 /= 0 ]

-- | Apply a reordering drawn from a key list; total for ANY key list (zip
--   truncates; a permutation of [0..n-1] yields a permutation of the input).
permuteBy :: [Int] -> [a] -> [a]
permuteBy ks xs = map snd (sortOn fst (zip ks xs))

genPerm :: Int -> Seed -> [Int]
genPerm n sd0 = map snd (sortOn fst (zip (keys n sd0) [0 .. n - 1]))
  where
    keys 0 _ = []
    keys k s = let (x, s') = nextInt 997 s in x : keys (k - 1) s'

genCrashPoint :: Int -> Seed -> Int
genCrashPoint n sd = fromInteger (fst (nextInt (toInteger (max 0 n) + 1) sd))

-- | shrinkPerm: one step, to the identity -- the smallest permutation is the
--   unpermuted schedule.
shrinkPerm :: [Int] -> [[Int]]
shrinkPerm ks = [ sortOn id ks | ks /= sortOn id ks ]

-- | shrinkCrashPoint: toward 0 (crash before anything commits), then halfway.
shrinkCrashPoint :: Int -> [Int]
shrinkCrashPoint k =
  [ 0 | k /= 0 ] ++ [ k `div` 2 | k `div` 2 /= 0, k `div` 2 /= k ]

-- | genVendorBehaviour: the source basis convention alphabet -- caught-up,
--   lagging, pre-adjusting, declared-through (on-chain ids AND an off-chain id,
--   so the OffChainClaim refusal is exercised), and nothing-on-file. Shrinks
--   toward TracksChain, the best-behaved vendor. The forged off-chain id is
--   harmless by construction: the door refuses it, and the tip weld refuses it
--   as a SetBasis -- it can never name a committed state.
genVendorBehaviour :: BasisView -> UnitId -> Seed -> Convention
genVendorBehaviour v u sd0 =
  let (k, sd1) = nextInt 5 sd0
  in case k of
       0 -> TracksChain
       1 -> let (j, _) = nextInt 4 sd1 in LagsBy j
       2 -> PreAdjusts
       3 -> case chainAt v u of
              [] -> DeclaredAt (Origin u)
              cs -> let (j, _) = nextInt (toInteger (length cs + 1)) sd1
                    in if j == 0
                         then DeclaredAt (Origin u)
                         else let (_, _, b) = cs !! fromInteger (j - 1)
                              in DeclaredAt (Boundary b)
       _ -> let (j, _) = nextInt 2 sd1
            in if j == 0 then NoClaim
                         else DeclaredAt (Boundary (BoundaryId "off-chain"))

shrinkVendorBehaviour :: Convention -> [Convention]
shrinkVendorBehaviour TracksChain = []
shrinkVendorBehaviour (LagsBy k)  = TracksChain : [ LagsBy k' | k' <- shrinkInteger k ]
shrinkVendorBehaviour _           = [TracksChain]

-- | genRawDatum: draws the unit reference from the view's register, PLUS one
--   unregistered reference so the UnregisteredUnit refusal is exercised; an
--   exact value; and a generated vendor behaviour with its convention version.
genRawDatum :: BasisView -> Seed -> RawDatum
genRawDatum v sd0 =
  let us         = Map.keys (bvBeta v)
      (i,   sd1) = nextInt (toInteger (length us + 1)) sd0
      ref        = case drop (fromInteger i) us of
                     (UnitId nm : _) -> nm
                     []              -> "unregistered"
      (val, sd2) = nextInt 1000 sd1
      (cv,  sd3) = nextInt 3 sd2
      ks         = Map.keys (bvKinds v)
      (ki,  sd4) = nextInt (toInteger (length ks + 1)) sd3
      kid        = case drop (fromInteger ki) ks of      -- one unregistered kind in
                     (k : _) -> k                        --   the draw, so the P31
                     []      -> KindId "kind-unregistered" -- refusal is exercised
  in RawDatum ref val (ConvVersion cv, genVendorBehaviour v (UnitId ref) sd4) kid

shrinkRawDatum :: RawDatum -> [RawDatum]
shrinkRawDatum (RawDatum ref val (cv, conv) kid) =
     [ RawDatum ref v' (cv, conv) kid | v' <- shrinkInteger val ]
  ++ [ RawDatum ref val (cv, c')  kid | c' <- shrinkVendorBehaviour conv ]

-- | genStampedObs: ONLY by calling the door. A generator that built a
--   StampedObs by record syntax would mint values outside ingest's image --
--   precisely the states the abstract type excludes -- so generation is
--   ingestAt over generated inputs, Nothing when the door refuses, and
--   shrinking shrinks the RAW DATUM and re-ingests (shrinkStampedObs): a
--   stamp is never shrunk in place.
genStampedObs :: BasisView -> Seed -> Maybe StampedObs
genStampedObs v sd0 =
  let (s1, s2) = splitSeed sd0
      (tv, _ ) = nextInt 16 s1
  in either (const Nothing) Just
       (ingestAt v (SourceId "gen") (Timestamp tv) (genRawDatum v s2))

shrinkStampedObs :: BasisView -> SourceId -> Timestamp -> RawDatum -> [StampedObs]
shrinkStampedObs v s t rd =
  [ so | rd' <- shrinkRawDatum rd, Right so <- [ingestAt v s t rd'] ]

-- | genFeed: a multi-vendor feed against one view -- several sources, mixed
--   vendor behaviours, observation times straddling the chain's boundaries.
--   genPerm and genCrashPoint drive the pPermO / pCrash schedules over the
--   same feed; partitionByStamp splits its committed set for pPartition.
genFeed :: BasisView -> Int -> Seed -> [(SourceId, Timestamp, RawDatum)]
genFeed v n sd0
  | n <= 0    = []
  | otherwise =
      let (s1,  s2) = splitSeed sd0
          (sid, sa) = nextInt 3 s1
          (tv,  sb) = nextInt 16 sa
      in (SourceId ("vendor-" ++ show sid), Timestamp tv, genRawDatum v sb)
           : genFeed v (n - 1) s2

-- | shrinkFeed: prefixes first (the structurally smaller feed), then pointwise
--   datum shrinking through shrinkRawDatum -- source and t_obs are left alone:
--   they name the trial; the datum carries the structure.
shrinkFeed :: [(SourceId, Timestamp, RawDatum)]
           -> [[(SourceId, Timestamp, RawDatum)]]
shrinkFeed feed =
     [ take k feed | k <- [0 .. length feed - 1] ]
  ++ [ pre ++ (s, t, rd') : post
     | (pre, (s, t, rd) : post) <- [ splitAt i feed | i <- [0 .. length feed - 1] ]
     , rd' <- shrinkRawDatum rd ]

-- -----------------------------------------------------------------------------
-- In-module chain minting (the P24 precedent). BoundaryId is a content address
-- assigned at the attested notice gateway; the oracle harness mints
-- deterministic addresses HERE, in-module, and these minters are deliberately
-- NOT exported -- no production caller gains a minting door. (They become live
-- call sites when the toolchain runs the catalogue.)
-- -----------------------------------------------------------------------------

mintBoundary :: UnitId -> Timestamp -> Integer -> Declaration -> BoundaryEvent
mintBoundary (UnitId nm) te pr decl =
  BoundaryEvent
    (BoundaryId (nm ++ "@" ++ show te ++ "#" ++ show pr ++ ":" ++ show decl))
    te pr decl

-- | genBoundaryEvent: covers retro-effective t_eff (the small window makes a
--   later booking with an earlier t_eff frequent), same-t_eff precedence
--   collisions (tie broken by the content address, data in the notice), and
--   every Declaration constructor -- parameterised (with and without a cash
--   leg), Pending, Terminal. The kind-indexed operator map of the OpSpec lives
--   in valuation transport, outside this module; the admission weld consumes
--   only this Declaration alphabet, which the generator exhausts.
genBoundaryEvent :: UnitId -> Seed -> BoundaryEvent
genBoundaryEvent u sd0 =
  let (te, sd1) = nextInt 8 sd0
      (pr, sd2) = nextInt 3 sd1
      (dk, sd3) = nextInt 4 sd2
      (fq, sd4) = nextInt 3 sd3
      (cq, _  ) = nextInt 3 sd4
      decl = case dk of
               0 -> DeclParams (toRational (2 + fq)) 0 Nothing
               1 -> DeclParams (toRational (2 + fq)) (toRational cq) (Just usd)
               2 -> DeclPending
               _ -> DeclTerminal
  in mintBoundary u (Timestamp te) pr decl

shrinkBoundaryEvent :: UnitId -> BoundaryEvent -> [BoundaryEvent]
shrinkBoundaryEvent u (BoundaryEvent _ (Timestamp te) pr decl) =
     [ mintBoundary u (Timestamp te') pr decl | te' <- shrinkInteger te ]
  ++ [ mintBoundary u (Timestamp te) pr' decl | pr' <- shrinkInteger pr ]
  ++ [ mintBoundary u (Timestamp te) pr DeclPending | decl /= DeclPending ]

-- | genChain: a committed log for one unit -- registration, then n boundary
--   transactions, each SetBasis re-asserting the post-insertion effective tip
--   so the tip weld admits it (retro-effective notices included). Holder-free
--   by construction, so the invariance weld is the vacuous zero-holder case
--   and the generator exercises the CHAIN, not entitlement arithmetic; every
--   generated log replays Right. Shrinking is prefix-closed (shrinkChain):
--   every prefix of a committed log is a committed log.
genChain :: UnitId -> Int -> Seed -> [Transaction]
genChain u n sd0 =
    registerTx u (TermsVersion "v1" Map.empty emptySchedule) (defaultStatus u) : go sd0 Set.empty n
  where
    go _  _   0 = []
    go s0 acc k =
      let (s1, s2) = splitSeed s0
          be   = genBoundaryEvent u s1
          acc' = Set.insert (bevTEff be, bevPrec be, bevId be) acc
          tip  = case Set.lookupMax acc' of
                   Nothing           -> Origin u
                   Just (_, _, bid)  -> Boundary bid
          tx   = Transaction { txUnit = u, txMoves = [], txRows = Map.empty
                             , txStatus = [SetBasis tip], txIntroduce = Nothing
                             , txAppend = Nothing, txBoundary = Just be
                             , txCause = Nothing }   -- own boundary: identity in txBoundary (2e)
      in tx : go s2 acc' (k - 1)

shrinkChain :: [Transaction] -> [[Transaction]]
shrinkChain txs = [ take k txs | k <- [1 .. length txs - 1] ]

-- | genTermsValue: one draw across the four dimension constructors, so P30's
--   neutral-boundary identity is exercised on every dimension.
genTermsValue :: Seed -> TermsValue
genTermsValue sd0 =
  let (k, sd1) = nextInt 4 sd0
      (n, _  ) = nextInt 500 sd1
  in case k of
       0 -> TVQty   (toRational n)
       1 -> TVPrice (toRational n)
       2 -> TVCash  (toRational n)
       _ -> TVFree  ("lbl-" ++ show n)

shrinkTermsValue :: TermsValue -> [TermsValue]
shrinkTermsValue (TVQty   q) = [ TVQty   (toRational n) | n <- shrinkInteger (truncate q :: Integer) ]
shrinkTermsValue (TVPrice x) = [ TVPrice (toRational n) | n <- shrinkInteger (truncate x :: Integer) ]
shrinkTermsValue (TVCash  x) = [ TVCash  (toRational n) | n <- shrinkInteger (truncate x :: Integer) ]
shrinkTermsValue (TVFree  _) = []

-- | genTermsVersion: a small dimensioned field map and a schedule -- mostly
--   admissible (dimension defaults; well-formed RSet / RWhen overrides,
--   including the worked special-dividend example; a ByParty designation),
--   with ILL-FORMED overrides (an RSet on the opaque dimensionless carrier)
--   and DANGLING overrides (naming an absent field) drawn in, so P29
--   exercises the ScheduleIncomplete refusal channel on both sides.
genTermsVersion :: Seed -> TermsVersion
genTermsVersion sd0 =
  let (nf, s1) = nextInt 4 sd0
      fields   = goF (fromInteger nf :: Int) s1
      (no, s2) = nextInt 3 (snd (splitSeed s1))
      ovrs     = goO (fromInteger no :: Int) (map fst fields) s2
  in TermsVersion "gen" (Map.fromList fields) (Schedule (Map.fromList ovrs))
  where
    goF 0 _ = []
    goF k sd = let (a, b) = splitSeed sd
               in ("f" ++ show k, genTermsValue a) : goF (k - 1) b
    goO 0 _ _ = []
    goO k fns sd =
      let (a, b)    = splitSeed sd
          (ci, sa)  = nextInt 8 a
          (fi, sb)  = nextInt (toInteger (length fns + 1)) sa
          (ri, _ )  = nextInt 4 sb
          cls       = toEnum (fromInteger ci) :: CAClass
          fn        = case drop (fromInteger fi) fns of
                        (x : _) -> x
                        []      -> "ghost"          -- a dangling override
          rule      = case ri of
                        0 -> RSet (EMul EField EFactor)
                        1 -> RWhen ECash (ELit (1 / 2))
                                   (RSet (ESub EField (ESub ECash (ELit (1 / 2)))))
                                   (RSet EField)    -- the worked example
                        2 -> RByParty "exchange"
                        _ -> RSet EField            -- ill-formed iff the field is opaque
      in ((cls, fn), rule) : goO (k - 1) fns b

shrinkTermsVersion :: TermsVersion -> [TermsVersion]
shrinkTermsVersion tv =
     [ tv { tvSchedule = Schedule (Map.deleteAt i m) }
     | let Schedule m = tvSchedule tv, i <- [0 .. Map.size m - 1] ]
  ++ [ tv { tvFields = Map.deleteAt i (tvFields tv) }
     | i <- [0 .. Map.size (tvFields tv) - 1] ]

-- | genCauseLog: a two-unit log exercising the cause gate (P28) -- the
--   dependent unit registered, the parent's committed chain, then one
--   follow-on append on the dependent unit per parent boundary, each stamped
--   `withCause` that boundary's id (strictly before by construction). An
--   occasional DANGLING cause (a never-committed id) closes the log: the
--   correct gate refuses it -- the accepted prefix simply ends there -- while
--   a wrongly-permissive gate admits it and pCauseCommitted's independent
--   recount catches the defect.
genCauseLog :: Seed -> [Transaction]
genCauseLog sd0 =
  let uP = UnitId "u-parent"
      uD = UnitId "u-dep"
      (s1, s2)    = splitSeed sd0
      (k,  s3)    = nextInt 4 s1
      chain       = genChain uP (fromInteger k + 1) s3
      (dangle, _) = nextInt 6 s2
      dep lbl     = appendTx uD (TermsVersion lbl Map.empty emptySchedule)
      followOns   = [ withCause (bevId be) (dep "dep-follow-on")
                    | tx <- chain, Just be <- [txBoundary tx] ]
      bad         = [ withCause (BoundaryId "never-committed") (dep "dep-dangling")
                    | dangle == 0 ]
  in registerTx uD (TermsVersion "v1" Map.empty emptySchedule) (defaultStatus uD)
       : chain ++ followOns ++ bad

-- | genBoundaryStraddle: the boundary-straddle scenario -- one unit, one
--   committed boundary, and the two booking cuts on either side of it. A
--   consumer pinned at the earlier cut reads the stored series at the old
--   point; a consumer pinned at the later cut reads it transported along the
--   declared arrow; both are correct, related by value invariance, and the
--   cross-reading is refused at the seam (C13). The two cuts feed viewAsOf;
--   the same scenario drives pRepro and pCloneStamp across the boundary.
genBoundaryStraddle :: Seed -> ([Transaction], Timestamp, Timestamp)
genBoundaryStraddle sd =
  let u   = UnitId "u-straddle"
      lg  = genChain u 1 sd
  in (lg, Timestamp 1, Timestamp (toInteger (length lg)))
