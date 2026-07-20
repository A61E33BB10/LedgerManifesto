# FORMALIS — Rigor Review of the Backtesting Cross-Manifesto Amendment

Targets: `MarketData/MarketDataManifesto_1.2.tex` (MD-4/MD-11/MD-13 extensions, §4,
amendment record) and `Valuation/ValuationManifesto_1.0.tex` (new VM-11, VM-10 touch,
abstract touches). Inputs: `drafting_note_bt.md`, `memo_jacobi_functionals.md`.
Method: functionals re-derived from JACOBI's conservation identity; every VM-11 and
MDM-extension citation checked at source against Constitution v1.4 / MDM; byte-stability
of PARK-1 and Part B verified by `git diff`.

---

## (1) THE COMPARISON DOCTRINE — SOUND

**A(C) well-defined by the certificate's conservation — SOUND, and convention-
independence is TRUE as stated.** JACOBI's per-link conservation (VM-4, C-8.4) is
`Σ_j a_k^{(j)} + R_k = ΔNAV_k := (V_k−V_{k−1}) + F_k =: ΔV_k`. Re-derived: `A(C) =
Σ_k ΔV_k` telescopes to `(V_N−V_0) + Σ_k F_k` — exactly the printed form. `A` reads only
the marks `V_k` and the recorded flow lines `F_k`, never the split `a_k`, so it is
independent of the **attribution convention** (VM-5's "split"): this is VM-4's plug-
identity invariant — the total is path-/convention-independent, only the decomposition
is not. The convention-independence holds at the mark level too: two conventions
"reproduce today's marks exactly" (VM-5), so over an actual history both give the same
`V_k` and differ only in `a_k` — `A` is the same. `A` is also partition-independent
(endpoints + total flows), correctly kept distinct from `Σ`. **Matches VM-4 mechanics
exactly.**

**Σ(C;π,D,ν) deterministic given chain + declared terms — SOUND.** `Σ = ν·D(ΔV_1,…,ΔV_N)`
is a deterministic value once `(π,D,ν)` are pinned (D a fixed functional, ν a scalar,
`ΔV_k` recorded) — "a value read off the record, not a statistical estimate," correct at
principle level. `π,D,ν` are declared, recorded terms. **Auditable-change parity — SOUND:**
VM-11 ties them to "the same auditable-change discipline as the attribution convention
(VM-5) and the certification bound (VM-6)"; this matches VM-5 (a declared, recorded term
reproduced bit-for-bit) and VM-6 (whose in-force text makes the bound "a recorded,
reviewable event … a loosened bound is an auditable change, never a silent one"). Parity
language faithful.

**Comparison validity — SOUND and DECIDABLE as printed.** "Comparable only at identical
coordinates … differing in nothing but the strategy unit under test" and "That identity
is a decidable check on the record: each chain carries complete lineage (VM-3, MD-6), and
the two lineage sets are compared." Complete lineage (MD-6) is a finite recorded object;
equality-modulo-the-strategy-unit of two finite sets is decidable. **The check is
decidable as printed.** "Invalid by definition … the exact analogue of VM-2, a comparison
without shared coordinates being no comparison at all" — correctly seated on VM-2 ("a
valuation carried without its coordinates … is not one"): the comparison is a derived
object whose coordinates are constitutive, so mismatch yields not a bad comparison but no
comparison. The analogue is faithful, not an over-reach.

*Minor (non-blocking, no VM edit needed at cap):* "a named validity failure **the record
refuses**" reads faintly admission-active for what is a *definitional* void over a
projection (comparisons are projected, not door-admitted). The surrounding "invalid by
definition / no comparison at all / analogue of VM-2" disambiguates it to the definitional
reading, so it is not a defect; if a cap-neutral slot opens, "the record yields no valid
comparison" would be exact.

## (2) ILLUSTRATION vs ENGINE DESIGN — RULING: ILLUSTRATION; boundary adequate as drafted

Neither functional designs an engine (CLAUDE.md §5). `A(C)` is a **definitional identity**
— what the terminal total *is* — its computation trivial (read endpoints and flows); it
fixes no estimator. `Σ` explicitly **leaves the estimator open**: `D` is "a declared
dispersion rule," and the article states `Σ` is "deterministic given the chain and
`(π,D,ν)` — a value read off the record, not a statistical estimate." A schema whose
estimator is a declared term the manifesto does not choose cannot be engine design. Both
formulas "make concrete something the prose has already said" (the total; the normalised
dispersion) — the prose governs. **This complies with §5.** The boundary is already marked
by "declared dispersion rule `D`" + "not a statistical estimate" + "read off the record";
**no sentence is required**, which also respects the VM's zero-margin cap. *Optional
cap-neutral sharpening only:* append "— the manifesto fixing none" to "a declared
dispersion rule `D`", if a slot exists; not needed for soundness.

## (3) VM-10 GENERALISATION — SOUND; no contradiction with the seed doctrine or C-2.8

"Let the recorded shift be the identity — what actually happened — over a base taken from
a past cut (C-12.1)" is a **direct application of C-2.8** ("production is simply the one
path whose events happened to be real"), not a contradiction of VM-10's existing
seed/shift discipline. The historical trajectory's coordinates are the historical cut
(record, C-12.1) and the identity shift (recorded) — both recorded ⇒ it replays, exactly
on MD-11's terms. **Stated honestly:** the draft does *not* claim "the seed is the record
itself"; it says the shift is the identity and both coordinates are recorded — the honest
framing. MDM's MD-11 extension mirrors it symmetrically ("'what happened' is the identity
shift; 'what could have happened' is any other … the two symmetric") and preserves
MD-11's seed clause verbatim in spirit ("Recording only the shift, like a path recording
only its seed, could not replay"). No contradiction.

## (4) STRATEGY-AS-UNIT CITATIONS — SOUND (verbatim-correct against Constitution v1.4)

- **C-10.2** (l.769-772): "A deterministic strategy is a smart contract whose rulebook is
  the terms of a (non-valued) strategy unit. The hypothetical portfolio it manages is a
  wallet in a virtual ledger. Each rebalancing is a recorded transaction triggered by
  stamped market observations." VM-11 renders this near-verbatim. ✓
- **C-7.2** (l.659): "ProductTerms — the immutable, append-only versions of an
  instrument's contractual terms." VM-11 cites it for the strategy's declared terms
  (hedge instruments, rebalancing rules, triggers). Correct — the strategy is a unit
  (C-10.2), its rulebook lives in ProductTerms. ✓
- **C-2.6** (l.161-162): "behaviour carried as declared data rather than hidden in code."
  VM-11: "behaviour is carried as declared terms, not hidden in code." ✓
- **C-6.4** (l.636-639): "Every smart contract is a pure, deterministic function of its
  inputs: the declared terms … the recorded observations, and the visible unit and
  position state." VM-11: "a pure function of those terms, the recorded observations, and
  the visible state." ✓ (verbatim)
- **C-6.1** (l.581): instruments are active smart contracts that fire on events — fair
  basis for "the strategy's contract fires on the trajectory's events exactly as a listed
  option's fires on a settlement print." ✓

All five verbatim-correct.

## (5) MDM 1.2 EXTENSION CLAUSES — SOUND

- **MD-4 served history / look-ahead-impossible — DERIVED, not asserted.** Mechanism
  given: "default read pins as-at to the historical as-of, so each coordinate sees only
  the observations then in force (MD-5) and look-ahead cannot arise — structurally
  impossible." The derivation is cited: MD-5 supplies "the observations it then held"
  (MD-5's own as-known clause), the two-cut/as-known root is MD-4's own as-at/as-of plus
  C-12.1 ("what was known as of a past date," in the trace), gap-free by read-back
  (C-14.15), exactness by the read-back/re-derive split (MD-6). Not an assertion.
- **MD-11 stressed history — SOUND, faithful to the seed doctrine.** The shift plays the
  seed's role (single non-record input); replayability requires the branched path's model
  outputs be captured as re-entered observations — the extension states exactly the
  seed-clause analogue ("Recording only the shift, like a path recording only its seed,
  could not replay"). Coordinates = historical cut + recorded shift, both recorded.
- **MD-13 horizon-agnostic — SOUND, no narrowing.** Nothing relaxed through the horizon:
  frame boundary, delivery-frame discipline, terms-resolved condition all held; one
  pointer to the VM's sandwich ("stated once there"). Consistent with the earlier MD-13
  narrowing-watch — the guards are kept, not dropped.
- **§4 + amendment record — SOUND.** The backtest object is placed in the VM (data side
  the MDM's, chain + comparison the VM's); no new MD-n; 1.1 untouched.

## CROSS-MANIFESTO DISCIPLINE (D1-D3) & BYTE-STABILITY

- **Separation respected.** Chain-separation lives in VM-10/VM-11, referenced (not
  re-described) from the MDM; the served/stressed history's replayability is the MDM's,
  referenced (not re-described) by VM-11; the ex-date sandwich is "stated once" in the VM,
  with MD-13 pointing. Consistent with the drafting note's D1-D3 claims (spot-verified).
- **PARK-1 and all of Part B (PE-1..PE-6) BYTE-STABLE — confirmed by `git diff`.** The only
  VM hunks are the abstract (l.102 "+2", l.108 one line) and the VM-10-touch/VM-11
  insertion (`@@ -490,2 +492,78 @@`); no hunk touches the Part B / PARK-1 region. The
  abstract touch is benign and correct ("the eleven articles"; "a backtest is that same
  valuation read across a trajectory of historical or stressed world states, two
  strategies comparable only at identical coordinates").

---

## VERDICT: SIGN

All five duties discharge SOUND. The two functionals are illustration (`A` a definitional
total, `Σ` a schema with the estimator declared, not fixed) — CLAUDE.md §5 satisfied;
convention-independence of `A` is true and matches VM-4's plug-identity; `Σ` deterministic
with auditable-change parity to VM-5/VM-6; the comparison-validity check is decidable and
correctly seated on VM-2; the VM-10 generalisation is a faithful application of C-2.8 with
the historical "seed" (identity shift) stated honestly; the strategy-as-unit citations are
verbatim-correct; the MDM extensions derive (not assert) look-ahead-impossibility and
preserve the seed and operator-algebra doctrines without narrowing. PARK-1 and Part B are
byte-stable. Two minor wording notes ("the record refuses"; an optional estimator-fixing
clause) are non-blocking and require no VM edit — I add none, respecting the 17 pp cap.

**FORMALIS SIGNS** the backtesting amendment (MDM 1.2 MD-4/MD-11/MD-13/§4; VM-11, the
VM-10 generalisation, and the abstract touches). — 2026-07-20.
