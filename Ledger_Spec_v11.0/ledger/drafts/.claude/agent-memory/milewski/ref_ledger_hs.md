---
name: ref-ledger-hs
description: Structure of the consolidated reference module Ledger.hs — parts, drops, renames, build/verify commands.
metadata:
  type: project
---

The runnable whole is `ledger/reference/Ledger.hs` (single module `Ledger`, GHC 9.10.3, builds `-Wall` clean, exit 0). The per-section `ledger/drafts/hs/*.hs` snippets are self-contained excerpts that each re-declare the shared vocabulary; Ledger.hs defines each concept once.

**Build/verify:** `export PATH="$HOME/.ghcup/bin:$PATH"; ghc -fno-code -Wall ledger/reference/Ledger.hs` (zero warnings = totality via exhaustiveness, no shadowing). Behavioral law checks run via `runghc -i.` against a small importing Main.

**Parts (in file order):** A scalars (once) · B Move algebra §2 + Balances monoid §10 · C canonical three-home core §4 (the spine) · D fees/issuance §9 · E valuation/PnL §5 · F state-aware pricing appD · G generalised positions/SBL §16 · H settlement interface §12 · I CDM forgetful map §13 · J obligation liveness §14 · K futures engine §8 · L property oracles appB. (Earlier notes said futures=L, oracles=M — stale; the file uses K/L.)

**GHC 9.10 gotcha:** `foldl'` is in Prelude since base-4.20; do NOT `import Data.List (foldl')` — it triggers `-Wunused-imports`. Removed in Phase-3 polish (the one remaining warning).

**Dropped as duplicates (Minimalism), noted in the header:** §7 "general lifecycle core" (same shape as §4 core, realised concretely by §8 futures engine); §2 map-of-maps `Ledger` + its `applyMove`/`balance` (superseded by §10 `Balances` monoid). Nothing conceptual lost — the .tex per-section listings still carry them.

**Collision-free renames (distinct concepts get distinct names; documented per section in-file):** settlement §12 `Move`→`SettleMove`, `Transaction`→`SettlementTx`, `TxType`→`TxClass`, Asset case `Cash`→`CashCcy`. CDM §13 `Transaction`→`CdmTransaction`, primitive `Transfer`→`PiTransfer` (Handler already owns `Transfer`). Futures §8 everything `Fut`-prefixed; stage ctors `FutRegistered/FutActive/FutExpired` (core `Lifecycle` owns `Active/Expired`); `markValue`(w/ multiplier)→`futMark`. Obligations §14 `step`→`obStep`, `LedgerState`→`OblView`, `ObState` ctors `ObActive/ObSettled`. appB `Cash`→reuse scalar, `Move`→reuse core, local tx→`OracleTx`, handler synonym `Lifecycle`→`LifecycleFn`. §9 fee data type `FeeCrystallise`→`FeeEvent` (Handler owns ctor `FeeCrystallise`). appD function `priceOf`→`statePrice` (PriceVec field is `priceOf`).

**Verified laws:** conservation (balanced validates, unbalanced rejected); replay homomorphism replay(xs<>ys)==replay xs >=> replay ys; C1 never-held(Nothing) vs held-and-flat(Just zeroP); futures intraday VM = Cash(-100) not -300 (stored accumulated_cost, C11). See [[representation-decisions]].
