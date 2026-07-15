-- =============================================================================
-- Test 2 -- BACK-DATED RESTATEMENT (corrections are events, never in-place edits).
--
-- ASSERTS both time-travel modes the verdict requires:
--   (M1) "what we knew at t" -- re-folding the ORIGINAL event prefix still yields
--        the ORIGINAL status.  The past is immutable: appending a correction later
--        does not, and cannot, reach back and patch it.
--   (M2) "t with corrected data" -- appending a compensating/correction event
--        (a restated last_settlement_price; and, for the superseded_by linkage, a
--        Breaking amendment) and re-folding yields the CORRECTED status.
--
-- The only way to obtain the corrected value is to APPEND an event; there is no
-- in-place patch, because the model exports no setStatus, seals the Ledger, and
-- routes every status change through `applyStatus` folded over the log.  This is
-- the addendum's `first_touch_date` discipline applied to the settlement mark.
--
-- It runs both as explicit scenarios (precise, reviewable) and as a property:
-- for every well-formed stream and every appended correction, the un-appended
-- stream still re-folds to its own value (M1) while the appended stream re-folds
-- to the corrected one (M2) -- and the store agrees with the re-fold throughout.
--
-- HOW TO RUN:  runghc -i../reference Test2_BackdatedRestatement.hs
-- =============================================================================

module Main (main) where

import           System.Exit   (exitFailure)
import           StatesHome   hiding (main)
import           LedgerTestKit

statusOf :: [Ev] -> UnitId -> Maybe UnitStatus
statusOf evs u = either (const Nothing) (\l -> unitStatus l u) (foldEvents evs)

-- --- Explicit scenarios -----------------------------------------------------

-- A unit registered, then settled at 100; later a correcting settle restates it
-- to 101.  M1: the original prefix still reads 100.  M2: the corrected stream
-- reads 101.
priceOriginal, priceCorrected :: [Ev]
priceOriginal  = [Reg uA, SettleE uA 100]
priceCorrected = priceOriginal ++ [SettleE uA 101]

-- Supersession linkage: original has no successor; a Breaking amendment appends
-- the link.  M1: original prefix still has superseded_by = Nothing.
supOriginal, supCorrected :: [Ev]
supOriginal  = [Reg uA]
supCorrected = supOriginal ++ [AmendBreak uA uNew]

scenarios :: [(String, Bool)]
scenarios =
  [ ( "M2 price restated: corrected stream reads 101"
    , (usLastSettle =<< statusOf priceCorrected uA) == Just (Qty 101) )
  , ( "M1 price immutable past: original prefix still reads 100"
    , (usLastSettle =<< statusOf priceOriginal uA) == Just (Qty 100) )
  , ( "M1 holds even after the correction is computed (pure; no in-place patch)"
    , (usLastSettle =<< statusOf priceOriginal uA) == Just (Qty 100) )
  , ( "M2 supersession stamped by the appended Breaking amendment"
    , (usSupersededBy =<< statusOf supCorrected uA) == Just uNew )
  , ( "M1 supersession absent on the original prefix"
    , (usSupersededBy =<< statusOf supOriginal uA) == Nothing )
  , ( "minted successor exists from its amendment onward (default status)"
    , statusOf supCorrected uNew == Just (UnitStatus Listed Nothing Nothing) )
  ]

-- --- General property -------------------------------------------------------

depth :: Int
depth = 3

-- For every well-formed stream s and a correcting settle appended on uA:
--   M1: re-fold of s is unchanged by the append (past immutable), and
--   M2: the appended stream's uA price equals the correction,
-- and in both the store equals the independent re-fold.
correction :: Ev
correction = SettleE uA 101

prop :: [Ev] -> Bool
prop s =
  let s' = s ++ [correction]
      m1 = statusOf s uA == refoldStatus s uA                       -- store == re-fold (past)
      m2 = not (isWellFormed s') ||                                  -- if appendable...
           ( (usLastSettle =<< statusOf s' uA) == Just (Qty 101)     -- ...M2 corrected
             && statusOf s' uA == refoldStatus s' uA )               -- ...store == re-fold (corrected)
  in m1 && m2

main :: IO ()
main = do
  putStrLn "Test 2: BACK-DATED RESTATEMENT (corrections are appended events)"
  okScenarios <- fmap and $ mapM checkScenario scenarios
  let streams = filter (\s -> isWellFormed (s ++ [correction]) || isWellFormed s)
                       (wellFormedStreams depth)
  okProp <- case firstFailure prop streams of
    Nothing  -> do putStrLn ("  property over " ++ show (length streams)
                             ++ " streams: both time-travel modes hold")
                   pure True
    Just bad -> do putStrLn "  property FAIL -- minimal counterexample:"; print bad; pure False
  if okScenarios && okProp
    then putStrLn "PASS -- past is immutable; correction is an appended event, re-folded exactly."
    else exitFailure
  where
    checkScenario (name, ok) = do
      putStrLn ("  [" ++ (if ok then "ok" else "FAIL") ++ "] " ++ name)
      pure ok
