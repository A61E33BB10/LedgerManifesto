# Proposal TEMPORAL-5 — Round 3

## MERGE INTO proposal-1

I concede the merged artifact to the nominated bases: **mapping = TEMPORAL-1** (three record
kinds + lineage discipline), **catalogue = TEMPORAL-4** (D1/D7/D13/D14/D15, D15 corrected to
FLAG). The spine, Forks A/B/C/D, the namespace seam, and the determinism gap are settled; I do
not reopen them. From my line, carry across, folded into those bases:

- **Compute/emit split (primary determinism mechanism)** — model-eval is one non-local activity
  whose output Temporal memoizes; door-propose is a separate downstream activity that
  re-presents the *recorded* bytes. The door-arrival race is *structurally removed*: exactly one
  payload ever reaches the door. **Never fuse model-eval with door-propose.**
- **Numerical-environment pin (Tier-2 dispute bound)** — §3(c), governance-optional; see the
  one-voice scope statement below.
- **Three-returned-value-loci table** — broken chain (VM-7, a *projection* reads the record) /
  gate fail-or-undecidable (MD-16, the *construction/gate activity* decides) / door refusal
  (R-22, the *door* decides). Three loci, never conflated.
- **A′ = FLAG** — my §4 wording, which TuringAward marks as the certified answer; restated below.
- **Stream-vs-namespace** — MD-16's "derived states never enter the base stream" is a *stream*
  boundary, not a *namespace* one; two orthogonal separations. Discriminator: *does a real
  production unit's valuation chain read it back?*

Two corrections to my r2 wording, applied on the way in:

**Fix 1 — drop §3(b)'s admission-time-contract phrasing.** My r2 §3(b) called bit-reproducibility
"the producer's admission-time contract, enforced by recompute-and-compare." Both referees are
right: that narrows the out-of-scope-numerics boundary (C-Scope.11), collides with T-3/T-4, and
is internally equivocal (prevention words, audit enforcement). The l.3921 citation is a
*simulation*-reproducibility rule and does not generalise to every re-entered observation.
**Retracted.** One voice, stated once:

> Canonical-by-first-admission is the spec default. **Bit-reproducibility is never a
> door/admission precondition** (out-of-scope numerics, C-Scope.11). The numerical-environment
> pin is a **governance-optional Tier-2** dispute-readiness term, whose adequacy is caught at
> audit by recomputation, never gated at the door. Dispute-readiness must not quietly become an
> admission gate.

**Fix 2 — two → three record kinds.** My r2 concession line said "two record kinds"; TEMPORAL-1's
base is **three**: projection / re-entered observation / **recorded-decision-pinned-as-known**
(the gate verdict — not a new primitive, it is the door's own admit/refuse shape, spec l.1051).
Corrected.

---

## New contribution — closing the value-level bound (FORMALIS's sharpest open item)

Read-back proves **byte**-reproducibility (the recorded value reproduces against the record). It
does **not** prove the recorded value is what an honest independent re-derivation would produce
within VM-6 tolerance. For a non-bit-reproducible model the recorded value is one arbitrary
member of `{P₁, P₂, …}`, and nobody bounds `|Pᵢ − Pⱼ|`. If that spread exceeds the instrument's
VM-6 residual tolerance, a mark that "reproduces bit-for-bit against the record" is one no honest
re-derivation matches — MD-14/VM-8 then guarantee the record's *self-consistency*, not the mark's
correctness. This is the whole set's remaining rigor debt. Closed here **without** reaching into
out-of-scope numerics and **without** giving the door model knowledge:

**The producer attests a reproducibility class in the re-entered observation's lineage** — a
declared, recorded, versioned term, exactly like the VM-6 bound, the attribution convention, or
TA-KIND. Its *truth* is governance/model, out of scope (C-Scope.11), verified — if at all — by
recomputation at audit. Three classes suffice:

1. **BIT-EXACT** — reproducible given (inputs, seed, pinned numerical-environment version). Spread
   is zero; the compute/emit split makes admission race-free *and* any re-derivation with the
   pinned environment reproduces the bytes. Full value-level dispute-readiness.
2. **TOLERANCE-BOUNDED(τ)** — not bit-exact, but the producer attests a bound `τ`: any two honest
   runs on the same recorded inputs agree within `τ`. `τ` is a recorded scalar.
3. **UNBOUNDED** — no attested bound. Not admissible as a re-entered observation feeding a
   dispute-ready valuation (it may still live in a simulation namespace, which claims no
   dispute-readiness).

**Two enforcement points, both model-free, mirroring the existing architecture:**

- **Door (structural, model-free):** a re-entered observation used in valuation must *carry* a
  reproducibility-class attestation in its lineage — a **presence** check, the same class as the
  door's existing provenance-completeness check (a re-entered observation missing it is
  incomplete → refused/quarantined, W4). The door never checks whether the model *is*
  reproducible; it checks a required lineage field *exists*.
- **Consumption (a projection over recorded terms):** a valuation that consumes a class-2 mark
  whose attested `τ` exceeds that instrument's VM-6 tolerance is a **broken chain (VM-7)** — a
  comparison of two recorded scalars (`τ` and the VM-6 bound), model-free, decided by the
  valuation projection, exactly as MD-16 enforces consumption-by-reference. The mark is not
  silently carried; it is a visible open item.

So canonical-by-first-admission **cannot** admit a dispute-ready mark outside its dispute
tolerance: either the spread is zero (class 1), or it is `≤ τ ≤` VM-6 tolerance (class 2, checked
at consumption), or the mark is unconsumable in a dispute-ready valuation (class 3). The
value-level gap is closed at the value level, not merely the byte level — and no numeric
admission precondition is introduced (Fix 1 honoured): the door checks *presence*, the projection
compares *recorded terms*, the attestation's *truth* stays governance.

**Actor boundary (reconciles T-2 and T-4's D14).** The **substrate** never retries-for-value and
never compares payloads — it runs the model once and re-presents the one recorded output. The
**door** (trusted single writer) may record a content-hash of the payload as a **diagnostic**
that catches the residual case of a fused/buggy worker presenting two payloads under one txid;
recording the hash changes nothing about which value is canonical (still first-admitted). Under
the compute/emit split the divergent-payload case cannot arise on a conformant producer, so the
hash is a defence-in-depth diagnostic, not a live mechanism — and it never compares *for value
correctness*, which stays the consumption-time τ-vs-tolerance projection above.

---

## A′ = FLAG (committee resolution, restate for the merged artifact)

A correction to a consumed input admitted at ≤ the pinned cut C, in the window between pinCut and
door-admit, **flags `m*` stale-forward** (MD-8/MD-10) — the single writer decides this on the
refold; `m*` remains the as-known-at-C value it was gated as (certified MD-16). The door refuses
**only** on a gate fail/undecidable verdict (the gate decides) or an unresolvable structural
reference (the door decides). **C-11.3 is a structural coordinate guard, not a freshness check**,
so "refuse the stale cut (C-11.3)" misreads it; by the three-kind taxonomy `m*` is kind-2 (stales
on consumed-input-move) and its decision is kind-3 (pinned as-known, not stale). REFUSE conflates
the two and, on a 90s model with corrections every 45s, **livelocks**; FLAG guarantees progress.
T-3 (§2b) and T-4 (D15) flip to FLAG; the exact C-11.3-vs-MD-8 clause reading is
CONCORDIA/FORMALIS's to certify — the answer is already on record. Optional, never load-bearing:
a producer-side freshness pre-check (re-read the tip before proposing; skip and re-pin if C is
already superseded) — a pure optimisation, because the flag path catches any born-stale state that
races through.

---

## Assembly endorsement

Build on TEMPORAL-1 (three kinds) + TEMPORAL-4 (catalogue, D15→FLAG); fold T-2's idempotence key +
seam list, T-3's two-tier determinism + versioning axes + Fork-B split, and my compute/emit split
+ env-version pin + loci table + A′ + the value-level reproducibility-class closure above. After
that, plus the scope-boundary one-voice statement, the artifact is ready for FORMALIS/CONCORDIA.
No Constitution park.
