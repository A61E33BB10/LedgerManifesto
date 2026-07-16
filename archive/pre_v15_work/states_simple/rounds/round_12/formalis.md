# FORMALIS — States.tex, Round 12

**Verdict: NOT-YET**

My lens: conservation and deterministic replay must be *visible* consequences of the
structure; no load-bearing fact of `SOLUTION_ESSENCE.md` may be dropped, weakened, hidden,
or contradicted; the bar is that a competent first-time reader follows every pointer to its
justification and reaches for nothing more. VETO on any regression. I read the current
`States.tex` end to end, cross-checked every listing against `States.hs`, verified the
KEEP/DROP contract, and resolved every `\S\ref` against `States.aux`. Both `States.tex`
(12:42) and `States.hs` (12:33) were edited after Round 11 closed (12:28).

## The mathematics is sound — almost everything is OBVIOUS

Everything Round 11 certified still holds, unweakened:

- **Listings faithful to source.** `Qty`/`negQty` (tex 173–179 ↔ hs 93–118); keys
  (188–189 ↔ 134–135); `Price`/`Lifecycle`/`UnitStatus`/`defaultStatus` (204–208 ↔ 249–272);
  `ProductTerms`/`currentTerms`/`appendVersion` (220–226 ↔ 333–353); `PositionState`/`zeroP`
  (242–247 ↔ 379–391); `Ledger`/`emptyLedger` (264–268 ↔ 436–451); `register`/`settle`
  (284–294 ↔ 465–489); `applyMove`/`netDeltas`/`writeNet` (305–318 ↔ 519–554); `position`
  (339–340 ↔ 504–505); `netBal` (361–362 ↔ 597–598); `Event`/`apply`/`replay` (369–375 ↔
  696–713). `TermsVersion`/`Move` are shown positionally where the source uses record
  syntax — a licensed structural simplification, not a misstatement.
- **Conservation visibly forced.** Base (`emptyLedger` sum zero, 261), step (`applyMove`
  sole `psBal` writer, two legs `negQty q <> q = mempty`; `register`/`settle` touch only
  `ledgerUnit`, 348–357), closure (sealed constructor, no other door). Edge cases
  (`q = mempty`, `from = to`) net `mempty` and write no row (321–326).
- **Determinism visibly forced.** `apply` pure/total; `replay = foldM`; checkpoint
  soundness by the genuine monadic left-fold split law (378–381). Row retention correctly
  attributed to audit, not determinism (384–385).
- **All six KEEP items present.** Three homes + structural-empty fourth (2×2, 80–99); no
  wallet-keyed economic sector with mandate reification (65–67, 153–158); never-held vs
  held-and-flat (328–336); three forcing reasons by concrete example (113–141);
  conservation + replay (348–385); mandate-as-unit (153–158).
- **Round-10 false statement stays fixed.** `psHwm` "carries no zero-sum invariant … and no
  aggregate over holders is claimed for it" (236–238, 358). No DROP-list leakage.

## The blocker: two cross-references resolve to the wrong section

`States.aux` resolves the labels as: `sec:answer`=§2, `sec:why`=§3, `sec:right`=§5 ("Why It
Is Right"). §4 "The Construction" (tex line 161) carries **no `\label`**. Two forward
references aim at content that lives in §4 but, lacking a §4 label, point at `sec:right` and
land on §5 — which does not contain the cited justification (I read §5 in full, lines
344–386: it is Conservation and Deterministic replay, nothing else).

1. **Line 103** — "Terms and status … ride together as a pair — a third home, a third kind
   of state, not a third map (§5)." The pair-not-a-third-map / two-maps justification is the
   §4 paragraph "The three homes, two maps" (249–269). §5 says nothing of maps. The reader
   sent to §5 for *why two maps suffice* finds conservation instead.

2. **Line 217** — "register, the one writer that lays down version one, refuses a unit
   already present (§5)." The refusal is demonstrated in the §4 "Registration and settlement"
   listing and prose (271–295). §5 neither shows nor mentions register's refusal or the
   shortening-of-history argument.

Root cause: a single mislabel. `sec:right` sits on §5, but **both** of its consumers want §4
content; no reference in the file targets §5's actual subject by label. Nothing load-bearing
is *dropped* — the justifications exist, in §4 — but each pointer is a false locative claim:
"(§5)" asserts the argument is in §5 when it is in §4. For a document whose standard is that
the reader "reaches for no further justification," a pointer that sends them to a section
not containing the cited justification defeats exactly that standard, and on the live read
(not just print) both refs misdirect.

**Remediation (actionable, minimal):** add `\label{sec:construction}` to §4 "The
Construction" (line 161, after the section command), and repoint lines 103 and 217 from
`\S\ref{sec:right}` to `\S\ref{sec:construction}`. Then re-run LaTeX so `.aux` updates.
(Equivalently, line 217's target is the very section it sits in, so a bare "(below)" or
removal also serves; line 103 genuinely needs the §4 pointer.) After the fix, re-verify both
references resolve to §4.

## Residue

The two `\S\ref{sec:right}` references at `States.tex:103` and `States.tex:217` resolve to §5
"Why It Is Right," which does not contain the cited justifications; those live in the
unlabeled §4 "The Construction." Located, single-root, actionable.

**NOT-YET.**

— FORMALIS Committee
