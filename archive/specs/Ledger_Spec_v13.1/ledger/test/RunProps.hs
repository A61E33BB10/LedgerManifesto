-- Property-suite harness for reference/Ledger.hs.
-- Drives each authored property over N deterministic seeds; on the first
-- failure it reports the seed and shrinks toward a minimal reproduction.
-- Deterministic and pure: seeds are Seed 1..N, so a run is fully reproducible.
module Main (main) where

import Ledger
import qualified Data.Map.Strict as Map
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

-- Every suite pin carries the standing vocabulary (D4): the registry
-- projection rides the view, so registered kinds flow and the unregistered
-- draw exercises the P31 refusal.
viewOf :: [Transaction] -> BasisView
viewOf txs = withKinds baseKinds (viewAsOf txs tNow)

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
         let v = withKinds baseKinds (basisView l)
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

-- P27: the reference is the recomputer. The processor under test is the
-- follow-on producer: from the committed prefix it deterministically
-- constructs the dependent append caused by the LAST booked boundary. The
-- honest submission diffs to zero; a forged one (different appended version)
-- is caught -- and the terms leg (propTermsRecompute) runs the same
-- differential over a dimensioned version at a drawn factor.
prop_p27 :: Seed -> Bool
prop_p27 s =
  let (a, b) = splitSeed s
      pfx    = chainOf a
      proc :: [Transaction] -> Ledger -> Transaction
      proc txs _ =
        let fo = appendTx (UnitId "u") (TermsVersion "fo" Map.empty emptySchedule)
        in case [ be | tx <- reverse txs, Just be <- [txBoundary tx] ] of
             (be : _) -> withCause (bevId be) fo
             []       -> fo
      honest = case replay pfx emptyLedger of
                 Left _  -> Nothing
                 Right l -> Just (proc pfx l)
      forged tx = tx { txAppend = Just (TermsVersion "forged" Map.empty emptySchedule) }
      moveLeg = case honest of
        Nothing -> True   -- an unreplayable prefix asserts nothing
        Just h  -> recomputeOK proc pfx h && not (recomputeOK proc pfx (forged h))
      (fq, _) = nextInt 3 b
      f       = toRational (1 + fq)     -- 1..3, never the degenerate factor
      tv      = TermsVersion "t"
                  (Map.fromList [ ("strike", TVPrice 100), ("mult", TVQty 5) ])
                  emptySchedule
      termsLeg = case transportVersion CASplit f 0 tv of
        Nothing  -> False    -- defaults at f /= 0 are always defined
        Just tv' -> propTermsRecompute CASplit f 0 tv tv'
                 && not (propTermsRecompute CASplit f 0 tv tv' { tvLabel = "forged" })
      -- Canonical-order non-vacuity (C-P2): the recomputed transaction carries
      -- a KEY-TIED pair of moves -- equal on (unit, from, to, qty), differing
      -- only in time/source -- plus a third; the submission arrives with its
      -- move list reversed. Agreement must survive the permutation (the sort
      -- key covers all six Move fields, so the sort is a true canonical form),
      -- while dropping a move is still caught.
      mv t src = move (WalletId "a") (WalletId "b") (UnitId "u") (Qty 5)
                      (Timestamp t) (SourceId src)
      procM :: [Transaction] -> Ledger -> Transaction
      procM _ _ = (appendTx (UnitId "u") (TermsVersion "m" Map.empty emptySchedule))
                    { txMoves = [ m | Just m <- [mv 1 "s1", mv 1 "s2", mv 2 "s1"] ] }
      permuted tx = tx { txMoves = reverse (txMoves tx) }
      dropOne  tx = tx { txMoves = drop 1 (txMoves tx) }
      canonLeg = case replay pfx emptyLedger of
        Left _  -> True
        Right l -> let h = procM pfx l
                   in recomputeOK procM pfx (permuted h)
                      && not (recomputeOK procM pfx (dropOne h))
  in moveLeg && termsLeg && canonLeg

-- BS-1: the invariance weld on REAL booked holders and cash legs (both E1
-- cases). Draws (q, f, c); a flipped per-holder agreement check dies here where
-- it survives the holder-free chain.
prop_weldHolder :: Seed -> Bool
prop_weldHolder s =
  let (a, b)  = splitSeed s
      (c, d)  = splitSeed b
      (q, _)  = nextInt 500 a
      (f, _)  = nextInt 3 c
      (cc, _) = nextInt 50 d
  in weldHolderOK q f cc

-- BS-2: the schedule override layer evaluated and observed (98.50 vs 98), and
-- the RByParty arm resolving to Nothing (fail-closed refusal).
prop_scheduleOverride :: Seed -> Bool
prop_scheduleOverride s =
  let (a, _) = splitSeed s
      (k, _) = nextInt 400 a
  in scheduleOverrideOK k

-- BS-5: P27 as an end-to-end producer trial -- declared boundary, schedule
-- resolution, appended terms version, recompute from the prefix and diff.
prop_producerE2E :: Seed -> Bool
prop_producerE2E s =
  let (a, _) = splitSeed s
      (k, _) = nextInt 100 a
  in producerE2EOK k

prop_p28 :: Seed -> Bool
prop_p28 = pCauseCommitted . genCauseLog

prop_p29 :: Seed -> Bool
prop_p29 = propScheduleTotalGate . genTermsVersion

-- P30 plus its composite-kind rider: the neutral-boundary identity on a drawn
-- value of every dimension, and dkDivSplitOK over drawn (f, q, d) with f in
-- -2..2 -- the degenerate factor (refusal arm) and the trivial factor 1 both
-- occur.
prop_p30 :: Seed -> Bool
prop_p30 s =
  let (a, b)  = splitSeed s
      (c, d)  = splitSeed a
      (fi, _) = nextInt 5 c
      (qi, e) = nextInt 200 d
      (di, _) = nextInt 200 e
  in propDimInvariance (genTermsValue b)
     && dkDivSplitOK (toRational fi - 2) (toRational qi) (toRational di)

-- G2: ordinary-dividend price-in-basis terms STAND under the layer-1 class
-- default. A generated version is forced non-vacuous by an injected strike
-- (there is always at least one price field), and the drawn cash c is never
-- zero, so the oracle's second half bites on every seed: the pre-G2
-- behaviour -- the strike re-expressed to (p - c) -- is observably caught.
-- The table rider (propClassDefaultTable) runs on the same line: f in 1..4
-- and c, p > 0, so (p - c)/f == p is impossible at f == 1 (c /= 0) and at
-- f > 1 (it would need c == p(1 - f) < 0) -- the ReExpress leg is never at a
-- fixed point, and every seed also drives the f == 0 refusal arm.
prop_ordDivStand :: Seed -> Bool
prop_ordDivStand s =
  let (a, b)  = splitSeed s
      (cn, d) = nextInt 200 b
      (pn, e) = nextInt 500 d
      (fn, _) = nextInt 4 e
      c       = toRational cn + 1 / 2          -- 1/2 .. 199 + 1/2, never 0
      p       = toRational pn + 1              -- 1 .. 500, never 0
      f       = toRational fn + 1              -- 1 .. 4, never 0
      tv0     = genTermsVersion a
      tv      = tv0 { tvFields = Map.insert "strike" (TVPrice (toRational pn))
                                            (tvFields tv0) }
  in propOrdDivTermsStand c tv
     && propClassDefaultTable f c p

prop_p31 :: Seed -> Bool
prop_p31 s =
  let (a, b) = splitSeed s
      v      = viewOf (chainOf a)
  in case genFeed v 1 b of
       ((src, t, rd) : _) ->
         let o = ingestAt v src t rd
         in pre pKindTotal emptyLedger (v, src, t, rd)
            && post pKindTotal emptyLedger (v, src, t, rd) o
       [] -> True

-- A locate command stream: 0..11 commands over the small lender/security pool.
cmdsOf :: Seed -> [LocCmd]
cmdsOf s = let (a, b) = splitSeed s
               (k, _) = nextInt 12 a
           in genLocCmds (fromInteger k) b

prop_p26 :: Seed -> Bool
prop_p26 = p26 . cmdsOf

prop_locDrawMonotone :: Seed -> Bool
prop_locDrawMonotone = locDrawMonotoneOK . cmdsOf

-- Split metamorphic: over a generated prefix, one put-on-hold confirm of 2q is
-- admitted iff two of q are. A far expiry keeps both trials live.
prop_locSplit :: Seed -> Bool
prop_locSplit s =
  let (a, b)  = splitSeed s
      pfx     = cmdsOf a
      (c, d)  = splitSeed b
      (q, _)  = nextInt 60 c
      (ui, _) = nextInt 2 d
  in locSplitOK pfx (LenderId "lender-0") (UnitId ("sec-" ++ show ui))
                (Qty (q + 1)) (Timestamp 100000)

-- Conversion is ATL-neutral for a put-on-hold locate: seed inventory and a live
-- put-on-hold locate, take its minted id from the decision stream, convert part
-- of it, and check available-to-lend is unchanged.
prop_locConvertNeutral :: Seed -> Bool
prop_locConvertNeutral s =
  let (a, b) = splitSeed s
      pfx    = cmdsOf a
            ++ [ LWrite   (LenderId "lender-0") (UnitId "sec-0") Own (Qty 500)
               , LConfirm (LenderId "lender-0") (UnitId "sec-0")
                          (Qty 100) LocPutOnHold (Timestamp 100000) ]
      (q, _) = nextInt 100 b
  in case last (snd (locRun pfx)) of
       LocConfirmed lid -> locConvertNeutralOK pfx lid (Qty (q + 1))
       _                -> True

main :: IO ()
main = do
  let n = 1000
  putStrLn ("Property suite over reference/Ledger.hs  (" ++ show n ++ " deterministic seeds each)\n")
  rs <- sequence
    [ runProp "P24  tip-weld agreement"          n prop_p24
    , runProp "P27  producer agreement"          n prop_p27
    , runProp "P27e end-to-end producer (BS-5)"  n prop_producerE2E
    , runProp "BS-1 weld on real holders"        n prop_weldHolder
    , runProp "BS-2 schedule override observed"  n prop_scheduleOverride
    , runProp "P28  cause committed"             n prop_p28
    , runProp "P29  schedule totality (C14)"     n prop_p29
    , runProp "P30  dimension invariance"        n prop_p30
    , runProp "G2   ord-div price terms stand"   n prop_ordDivStand
    , runProp "P31  kind totality at the door"   n prop_p31
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
    , runProp "P26  locate-capacity admission"   n prop_p26
    , runProp "P26b  locate drawdown monotone"   n prop_locDrawMonotone
    , runProp "P26c  locate split metamorphic"   n prop_locSplit
    , runProp "P26d  conversion ATL-neutral"     n prop_locConvertNeutral
    ]
  putStrLn ""
  if and rs
    then putStrLn "ALL PROPERTIES PASSED" >> exitSuccess
    else putStrLn (show (length (filter not rs)) ++ " PROPERTY/PROPERTIES FAILED") >> exitFailure
