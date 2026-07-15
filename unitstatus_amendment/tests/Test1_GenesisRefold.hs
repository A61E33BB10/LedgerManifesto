-- =============================================================================
-- Test 1 -- GENESIS RE-FOLD == stored / snapshotted value.
--
-- ASSERTS (the materialisation-soundness law, executable):
--   For every well-formed event stream and every unit, the UnitStatus held in
--   the maintained store (the ledger built by stepping events from genesis) is
--   EQUAL to the value produced by an INDEPENDENT re-fold of the same events
--   from genesis (`refoldStatus`, a hand-written oracle that does not call the
--   model's own writer).  Equality is structural `==` on `UnitStatus` (a sum of
--   `Eq` fields) -- i.e. byte-for-byte, value-for-value.
--
--   Because enumeration covers ALL streams up to the depth, it also covers every
--   PREFIX of every stream, so the law is checked at every cut point, not just at
--   the end: replaying a unit's events from genesis up to any point reproduces
--   the exact value the store holds there.
--
-- WHY IT GATES: this is the regression gate on any future snapshot/cache work
-- (addendum E1/E2/F3).  Today store and re-fold coincide because the store IS the
-- fold; the moment a cache or snapshot is introduced as a separate value, this
-- test demands it still equal the re-fold, or it FAILS.  A cache that disagrees
-- with the log is exactly the rejected "authoritative-mutable" reading; this test
-- makes that disagreement a red build.
--
-- HOW TO RUN (GHC was unavailable when authored):
--   runghc -i../reference Test1_GenesisRefold.hs
-- =============================================================================

module Main (main) where

import           System.Exit (exitFailure)
import           StatesHome   hiding (main)
import           LedgerTestKit

depth :: Int
depth = 4

-- | Store value == independent re-fold, for every checked unit.
prop :: [Ev] -> Bool
prop evs = case foldEvents evs of
  Left _  -> True   -- ill-formed (already filtered); nothing to compare
  Right l -> all (\u -> unitStatus l u == refoldStatus evs u) checkedUnits

main :: IO ()
main = do
  let streams = wellFormedStreams depth
      n       = length streams
  putStrLn ("Test 1: GENESIS RE-FOLD == stored value  (depth " ++ show depth
            ++ ", " ++ show n ++ " well-formed streams)")
  case firstFailure prop streams of
    Nothing -> putStrLn "PASS -- the store equals the re-fold of the log for every unit at every cut."
    Just bad -> do
      putStrLn "FAIL -- minimal counterexample (store disagrees with re-fold):"
      print bad
      mapM_ (\u -> putStrLn ("  unit " ++ show u
                             ++ "  store="   ++ show (either (const Nothing) (\l -> unitStatus l u) (foldEvents bad))
                             ++ "  refold="  ++ show (refoldStatus bad u)))
            checkedUnits
      exitFailure
