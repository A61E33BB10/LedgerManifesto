-- =============================================================================
-- Test 3 -- EXTERNAL OBSERVABLES captured as logged observation events
--           (the fold is pure at the boundary; status changes ONLY via a log event).
--
-- ASSERTS four facts that together say: an externally-sourced value (a settlement
-- price / benchmark level) changes UnitStatus ONLY through a logged observation
-- event, and replaying is pure at that boundary.
--
--   (P1) DETERMINISM / PURITY: re-folding the same event stream twice yields the
--        identical UnitStatus for every unit.  No ambient clock, feed, or config
--        leaks in -- same events => same status (Commandment 5).
--
--   (P2) NO OUT-OF-BAND CHANGE: a status-less event (a Trade: sdStatus = []) never
--        changes any unit's UnitStatus.  Status moves only when an event carries a
--        StatusWrite.  (A status change with NO corresponding logged status event
--        is not merely untested -- it is unrepresentable: the Ledger is sealed and
--        the sole writer is `applyStatus`, reached only from `applyDelta`/`amend`.)
--
--   (P3) THE CACHE EQUALS THE LOGGED EVENT'S IMAGE: after a settlement at price p,
--        the stored last_settlement_price is EXACTLY p -- the externally-sourced
--        number entered through, and only through, the logged event's payload, and
--        replay reproduces it byte-for-byte.  No value appears that no event placed.
--
--   (P4) THE NUMBER TRACKS THE OBSERVATION: settling at p1 vs p2 (p1 /= p2) gives
--        different stored prices, each equal to its own logged payload -- the value
--        is caused by the observation event, nothing else.
--
-- BOUNDARY CAVEAT (recorded, not tested here): reproducing the NUMBER is what this
-- gates.  ATTESTATION that the number is the genuine external settlement level is a
-- DISTINCT requirement (the Nazarov finding), out of scope of the mutability verdict.
--
-- HOW TO RUN:  runghc -i../reference Test3_ExternalObservables.hs
-- =============================================================================

module Main (main) where

import           System.Exit     (exitFailure)
import           StatesHome   hiding (main)
import           LedgerTestKit

depth :: Int
depth = 4

statusOf :: Ledger -> UnitId -> Maybe UnitStatus
statusOf l u = unitStatus l u

-- (P1) Purity / reproducibility at the boundary: replaying the logged events
-- reproduces the stored status exactly, via an INDEPENDENT computation
-- (`refoldStatus`).  Because the externally-sourced number is carried IN the
-- event, a fresh replay reconstructs it with no ambient input -- not a trivial
-- self-comparison: the store and the oracle are two separate implementations.
propReproducible :: [Ev] -> Bool
propReproducible evs = case foldEvents evs of
  Left _  -> True
  Right l -> all (\u -> unitStatus l u == refoldStatus evs u) checkedUnits

-- (P2) A status-less event changes no unit's status.  For each well-formed ledger
-- and each registered checked unit, applying a Trade (sdStatus = []) on that unit
-- leaves every unit's UnitStatus identical.
propStatusLessInert :: [Ev] -> Bool
propStatusLessInert evs = case foldEvents evs of
  Left _  -> True
  Right l -> all inertOn [ u | u <- checkedUnits, isRegistered l u ]
    where
      isRegistered lg u = maybe False (const True) (unitStatus lg u)
      inertOn u = case applyEv (TradeE u 7) l of
        Left _   -> True   -- a Trade may be rejected, but it can never *change* status
        Right l' -> all (\v -> unitStatus l' v == unitStatus l v) checkedUnits

-- (P3) The stored mark equals exactly the logged event's payload.
propCacheEqualsPayload :: Bool
propCacheEqualsPayload =
  case foldEvents [Reg uA, SettleE uA 12345] of
    Right l -> (usLastSettle =<< statusOf l uA) == Just (Qty 12345)
               && (usLifecycle <$> statusOf l uA) == Just Active
    Left _  -> False

-- (P4) Different observations give different stored numbers, each its own payload.
propTracksObservation :: Bool
propTracksObservation =
  let p1 = usLastSettle =<< (either (const Nothing) (\l -> unitStatus l uA)
                                    (foldEvents [Reg uA, SettleE uA 100]))
      p2 = usLastSettle =<< (either (const Nothing) (\l -> unitStatus l uA)
                                    (foldEvents [Reg uA, SettleE uA 200]))
  in p1 == Just (Qty 100) && p2 == Just (Qty 200) && p1 /= p2

main :: IO ()
main = do
  let streams = wellFormedStreams depth
  putStrLn ("Test 3: EXTERNAL OBSERVABLES captured as logged events  (depth "
            ++ show depth ++ ", " ++ show (length streams) ++ " streams)")
  let r1 = firstFailure propReproducible    streams
      r2 = firstFailure propStatusLessInert streams
  ok1 <- pass "P1 purity / reproducibility (logged events reproduce the status)" r1
  ok2 <- pass "P2 status-less event (Trade) never changes status" r2
  ok3 <- passBool "P3 cache equals the logged event's payload exactly" propCacheEqualsPayload
  ok4 <- passBool "P4 stored number tracks the logged observation" propTracksObservation
  if and [ok1, ok2, ok3, ok4]
    then putStrLn "PASS -- status changes only via a logged event; replay is pure at the boundary."
    else exitFailure
  where
    pass name Nothing    = do putStrLn ("  [ok] " ++ name); pure True
    pass name (Just bad) = do putStrLn ("  [FAIL] " ++ name ++ " -- minimal counterexample:")
                              print bad; pure False
    passBool name ok     = do putStrLn ("  [" ++ (if ok then "ok" else "FAIL") ++ "] " ++ name)
                              pure ok
