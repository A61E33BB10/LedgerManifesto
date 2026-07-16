{-# LANGUAGE ScopedTypeVariables #-}

-- =============================================================================
-- LedgerTestKit.hs  --  shared harness for the three UnitStatus gating tests.
--
-- These tests gate the SETTLED finding (FORMALIS synthesis, 9/9 DERIVED
-- PROJECTION): UnitStatus is a MATERIALISED PROJECTION of the immutable event
-- log -- a read cache whose every change is caused by a logged event and which
-- replay rebuilds exactly. They are the executable form of that finding.
--
-- They run against the reference model `reference/StatesHome.hs`. GHC was NOT
-- available in the authoring environment, so they could not be executed here;
-- they are written to be RUN once GHC exists, with NO dependency beyond `base`
-- (no QuickCheck install needed). To run, from this `tests/` directory:
--
--     runghc -i../reference Test1_GenesisRefold.hs
--     runghc -i../reference Test2_BackdatedRestatement.hs
--     runghc -i../reference Test3_ExternalObservables.hs
--
-- or compile:  ghc -i../reference -o t1 Test1_GenesisRefold.hs && ./t1
-- Each prints PASS/FAIL and exits non-zero on failure (CI-ready, Commandment 7).
--
-- Method (Lamport + Hughes): instead of sampling random inputs, each property is
-- checked by BOUNDED-EXHAUSTIVE enumeration of all event streams up to a small
-- depth -- a model check of the projection law over the reachable state space.
-- Streams are enumerated in INCREASING LENGTH, so the first failure found is a
-- minimal counterexample (shrinking for free). Enumeration is deterministic
-- (Commandment 5): the same alphabet and depth give the same verdict every run.
-- =============================================================================

module LedgerTestKit where

import           Control.Monad   (replicateM, foldM)
import qualified Data.Map.Strict as Map
import           StatesHome

-- ---------------------------------------------------------------------------
-- Fixed finite test domain (a bounded model; exhaustive enumeration = check).
-- ---------------------------------------------------------------------------

uA, uB, uNew :: UnitId
uA   = UnitId "A"
uB   = UnitId "B"
uNew = UnitId "A2"      -- the fresh successor allocated by a Breaking amendment

wX, wY :: WalletId
wX = WalletId "X"
wY = WalletId "Y"

tv :: TermsVersion
tv = TermsVersion "v1" Map.empty

-- | The units a property inspects.
checkedUnits :: [UnitId]
checkedUnits = [uA, uB, uNew]

-- ---------------------------------------------------------------------------
-- Test-level events.  EACH is a logged event -- the ONLY ways the ledger
-- changes.  There is no constructor that mutates a stored value out of band:
-- that is the point under test, made structural by the model (no exported
-- setStatus; `Ledger` sealed; the sole status writer is `applyStatus`).
-- ---------------------------------------------------------------------------

data Ev
  = Reg        UnitId           -- registration: writes ProductTerms + default UnitStatus
  | SettleE    UnitId Integer   -- a logged settlement observation (externally-sourced price)
  | TradeE     UnitId Integer   -- a conserving position move; touches NO status field
  | AmendBreak UnitId UnitId    -- Breaking amendment: stamps superseded_by, mints successor
  deriving (Eq, Show)

-- | The StatusWrites a settlement event carries: it becomes Active and records
--   the marked price.  This SAME list is what the model logs and folds, so the
--   externally-sourced price enters only through the logged event.
settleWrites :: Integer -> [StatusWrite]
settleWrites p = [SetLifecycle Active, SetLastSettle (Qty p)]

-- | Apply one event to a ledger (the model's own writers; no back door).
applyEv :: Ev -> Ledger -> Either LedgerError Ledger
applyEv (Reg u)       l = register u tv defaultStatus l
applyEv (SettleE u p) l = applyValidated (StateDelta u Map.empty (settleWrites p) Nothing) l
applyEv (TradeE u q)  l =
  applyValidated
    (StateDelta u (erase (settleHandler [(wX, Qty q), (wY, Qty (negate q))])) [] Nothing)
    l
applyEv (AmendBreak uOld uFresh) l =
  case amend (\_ _ -> Breaking) uOld (TermsVersion "v2" Map.empty) uFresh l of
    Left e        -> Left e
    Right (_, l') -> Right l'

-- | Validate-then-apply, surfacing a (never-triggered, for this alphabet)
--   conservation rejection as a Left so the harness has a uniform result type.
applyValidated :: StateDelta -> Ledger -> Either LedgerError Ledger
applyValidated sd l =
  either (\_ -> Left (UnknownUnit (sdUnit sd))) (\vd -> applyDelta vd l) (validate sd)

-- | Fold an event stream from genesis (emptyLedger).  This IS the incrementally
--   maintained store: stepping events one at a time.
foldEvents :: [Ev] -> Either LedgerError Ledger
foldEvents = foldM (flip applyEv) emptyLedger

-- | Well-formed streams are exactly the ones that fold without error.
isWellFormed :: [Ev] -> Bool
isWellFormed evs = either (const False) (const True) (foldEvents evs)

-- ---------------------------------------------------------------------------
-- The INDEPENDENT re-fold oracle: the projection of the log, recomputed from
-- scratch by hand (NOT by calling the model's `applyStatus`).  It reimplements
-- the rule for folding each kind of event -- registration sets the default,
-- a settlement overwrites the lifecycle and the marked price field-wise, a
-- trade changes nothing, a Breaking amendment stamps the predecessor and mints
-- the successor.  The store must equal this for every unit at every cut.
--
-- A future snapshot/cache (the addendum's E1/E2/F3 work) that disagrees with
-- this oracle FAILS test 1 -- which is the whole purpose of the gate.
-- ---------------------------------------------------------------------------

refoldStatus :: [Ev] -> UnitId -> Maybe UnitStatus
refoldStatus evs target = foldl step Nothing evs
  where
    step acc (Reg u)
      | u == target = Just (UnitStatus Listed Nothing Nothing)   -- defaultStatus, spelled out
      | otherwise   = acc
    step acc (SettleE u p)
      | u == target = fmap (\s -> s { usLifecycle = Active, usLastSettle = Just (Qty p) }) acc
      | otherwise   = acc
    step acc (TradeE _ _) = acc                                   -- a trade NEVER changes status
    step acc (AmendBreak uOld uFresh)
      | target == uFresh = Just (UnitStatus Listed Nothing Nothing)  -- minted successor: default
      | target == uOld   = fmap (\s -> s { usSupersededBy = Just uFresh }) acc
      | otherwise        = acc

-- ---------------------------------------------------------------------------
-- Bounded-exhaustive enumeration, length-ordered (minimal counterexample).
-- ---------------------------------------------------------------------------

sequencesUpTo :: Int -> [a] -> [[a]]
sequencesUpTo n alpha = concat [ replicateM k alpha | k <- [0 .. n] ]

-- | The standard event alphabet used by all three tests.
alphabet :: [Ev]
alphabet =
  [ Reg uA, Reg uB
  , SettleE uA 100, SettleE uA 101, SettleE uB 100
  , TradeE uA 5
  , AmendBreak uA uNew
  ]

-- | All well-formed streams up to a depth, in increasing length.
wellFormedStreams :: Int -> [[Ev]]
wellFormedStreams depth = filter isWellFormed (sequencesUpTo depth alphabet)

-- ---------------------------------------------------------------------------
-- Tiny test runner.  `checkProp` returns the first (hence minimal) failing
-- input, if any.  `report` prints PASS/FAIL and sets the exit code.
-- ---------------------------------------------------------------------------

firstFailure :: (a -> Bool) -> [a] -> Maybe a
firstFailure p xs = case filter (not . p) xs of
  (y:_) -> Just y
  []    -> Nothing
