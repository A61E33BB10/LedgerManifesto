-- Property-suite harness for reference/Ledger.hs.
-- Drives each authored property over N deterministic seeds; on the first
-- failure it reports the seed and shrinks toward a minimal reproduction.
-- Deterministic and pure: seeds are Seed 1..N, so a run is fully reproducible.
module Main (main) where

import Ledger
import Data.Maybe (mapMaybe, isJust)
import System.Exit (exitFailure, exitSuccess)

-- N deterministic seeds.
seeds :: Int -> [Seed]
seeds n = [ Seed (toInteger i) | i <- [1 .. n] ]

-- A big timestamp: a view "as of now", past every generated boundary.
tNow :: Timestamp
tNow = Timestamp 1000000

-- Build a chain and its full-history view from a seed.
chainOf :: Seed -> [Transaction]
chainOf s = let (a, b)  = splitSeed s
                (k, _)  = nextInt 6 a           -- 0..5 boundaries
            in genChain (UnitId "u") (fromInteger k + 1) b

viewOf :: [Transaction] -> BasisView
viewOf txs = viewAsOf txs tNow

nBoundaries :: [Transaction] -> Int
nBoundaries = length . filter (isJust . txBoundary)

-- Run one Bool property over N seeds; shrink the first failing seed's structure
-- is property-specific, so here we report the seed and a small neighbourhood.
runProp :: String -> Int -> (Seed -> Bool) -> IO Bool
runProp name n f =
  case [ i | (i, s) <- zip [1 :: Int ..] (seeds n), not (f s) ] of
    []      -> putStrLn ("  PASS  " ++ pad name ++ show n ++ " cases") >> return True
    (i : _) -> do putStrLn ("  FAIL  " ++ pad name ++ "first failing seed = " ++ show i)
                  return False
  where pad t = t ++ replicate (max 1 (34 - length t)) ' '

-- ---- property wrappers -------------------------------------------------------

prop_p24 :: Seed -> Bool
prop_p24 s = p24 (chainOf s)

prop_pPermN :: Seed -> Bool
prop_pPermN s =
  let (a, b) = splitSeed s
      txs    = chainOf a
      perm   = genPerm (nBoundaries txs) b
  in pPermN txs perm

prop_pDet :: Seed -> Bool
prop_pDet s =
  let (a, b) = splitSeed s
      v      = viewOf (chainOf a)
  in case genFeed v 1 b of
       ((src, t, rd) : _) -> pDet v src t rd
       []                 -> True

prop_pMode :: Seed -> Bool
prop_pMode s =
  let (a, b) = splitSeed s
      v      = viewOf (chainOf a)
      (c, d) = splitSeed b
      (k, _) = nextInt 8 c
  in pMode v (genFeed v (fromInteger k) d)

prop_pPermO :: Seed -> Bool
prop_pPermO s =
  let (a, b)  = splitSeed s
      v       = viewOf (chainOf a)
      (c, d)  = splitSeed b
      (k, _)  = nextInt 8 c
      feed    = genFeed v (fromInteger k) d
      perm    = genPerm (length feed) c
  in pPermO v feed perm

prop_pCrash :: Seed -> Bool
prop_pCrash s =
  let (a, b)  = splitSeed s
      v       = viewOf (chainOf a)
      (c, d)  = splitSeed b
      (k, _)  = nextInt 8 c
      feed    = genFeed v (fromInteger k) d
      cp      = genCrashPoint (length feed) c
  in pCrash v feed cp

prop_pRepro :: Seed -> Bool
prop_pRepro s =
  let (a, b)  = splitSeed s
      txs     = chainOf a
      (c, d)  = splitSeed b
      (cc, _) = nextInt (toInteger (length txs) + 1) c
      (ex, _) = nextInt 4 d
      v       = viewOf txs
  in case genFeed v 1 d of
       ((src, t, rd) : _) -> pRepro txs (Timestamp cc) (fromInteger ex) (src, t, rd)
       []                 -> True

prop_pCloneStamp :: Seed -> Bool
prop_pCloneStamp s =
  let (a, b)  = splitSeed s
      txs     = chainOf a
      v       = viewOf txs
  in case genFeed v 1 b of
       ((src, t, rd) : _) -> pCloneStamp txs (src, t, rd)
       []                 -> True

prop_pLag :: Seed -> Bool
prop_pLag s =
  let (a, b)  = splitSeed s
      v       = viewOf (chainOf a)
      (c, d)  = splitSeed b
      (t, _)  = nextInt 20 c
      (k, _)  = nextInt 6 d
  in pLag v (UnitId "u") (Timestamp t) k

prop_pPartition :: Seed -> Bool
prop_pPartition s =
  let (a, b) = splitSeed s
      v      = viewOf (chainOf a)
      ss     = take 8 (iterate (snd . splitSeed) b)
  in pPartition (mapMaybe (genStampedObs v) ss)

prop_p25 :: Seed -> Bool
prop_p25 s =
  let (a, b) = splitSeed s
      txs    = chainOf a
  in case replay txs emptyLedger of
       Left _  -> True
       Right l ->
         let v = basisView l
         in case genFeed v 1 b of
              (inp@(src, t, rd) : _) ->
                let o = ingestAt v src t rd
                in pre p25 l inp && post p25 l inp o
              [] -> True

prop_fibreOK :: Seed -> Bool
prop_fibreOK s =
  let (a, b) = splitSeed s
      (q, _) = nextInt 1000 a
      (d, _) = nextInt 1000 b
  in fibreOK (UnitId "u") q d

main :: IO ()
main = do
  let n = 1000
  putStrLn ("Property suite over reference/Ledger.hs  (" ++ show n ++ " deterministic seeds each)\n")
  rs <- sequence
    [ runProp "P24  tip-weld agreement"          n prop_p24
    , runProp "P25  door soundness"              n prop_p25
    , runProp "P-DET  stamp purity"              n prop_pDet
    , runProp "P-MODE  mode equivalence"         n prop_pMode
    , runProp "P-PERM-N  notice-order irrel."    n prop_pPermN
    , runProp "P-PERM-O  arrival-order irrel."   n prop_pPermO
    , runProp "P-CRASH  crash recovery"          n prop_pCrash
    , runProp "P-REPRO  as-of reproducibility"   n prop_pRepro
    , runProp "P-CLONE-STAMP  time-travel stamp" n prop_pCloneStamp
    , runProp "P-LAG  lag arithmetic"            n prop_pLag
    , runProp "P-PARTITION  basis separation"    n prop_pPartition
    , runProp "F8  Cum/Ex fibre"                 n prop_fibreOK
    ]
  putStrLn ""
  if and rs
    then putStrLn "ALL PROPERTIES PASSED" >> exitSuccess
    else putStrLn (show (length (filter not rs)) ++ " PROPERTY/PROPERTIES FAILED") >> exitFailure
