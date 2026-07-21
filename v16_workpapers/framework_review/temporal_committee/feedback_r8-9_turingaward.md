# TuringAward — Temporal Committee Referee, Rounds 8+9 (FINAL, consensus round 10)

Role: standing referee — architecture, convergence, §4 anti-bias. Advisory, no veto; the signature below is a
concur/dissent, not a certification. Fresh instance; consulted feedback_r6-7. Lenses: L2 (log-as-truth,
idempotence key, exactly-once), L1 (deploy/CAN/failover/skew), L8 (adversary, hash-chain), L3 (firing
properties), L5 (by-type boundaries), L6 (minimalism). All three r6-7 merge-hygiene closes verified landed.

---

## 1. S2 + S5 — survive at architecture level? Hand-waving?

**Both SURVIVE; no hand-waving.** S2 (DEPLOY-IS-ORCHESTRATION-ONLY): Build-ID ∉ H (T-1 l.156), value is a
version-pinned activity reading the recipe/model version *from the log, not the binary* (I4); three
independent reviewers verdict HOLDS naming the **same** honest break — "Break iff a deploy embeds a recipe
version as a CODE CONSTANT" (T-3 l.5; T-2 l.29; T-1 l.156). In-flight runs stay Build-ID-pinned, drain at CAN
(R-17). S5 (THREE-TIMES-ARE-RECORDED-VALUES): fold orders on recorded `(exec, door, hash)`; monitor time
"orders NOTHING, gates NOTHING" (T-5 (iii)); skew enters **only timer FIRING → identical txid, S4-absorbed →
overdue-watch liveness** (T-1 l.160-162; T-2 l.42-46). Break named: a wall clock stamping a recorded time/order
(T-3 l.10). Both reduce to prior invariants — no new mechanism.

## 2. PARETO-OPTIMALITY — the crux. Can any member improve an axis without degrading another?

**Correctness / minimalism / simplicity: no improvement available** — containments are by-construction, the
round was subtractive (the content-hash diagnostic is *deleted*, T-1 l.99), nothing cuts without losing a
guarantee. **Testability: YES, one improvement remains.** The §5 harvest witnesses the *double-admit* half of
I2 (`prop_exactlyOnceAdmission`, which holds txid fixed) but **not the injectivity/under-admit half** the
design itself names — "a coarse label false-dedups two distinct causes → silent under-admit (the injectivity
dual of the key)" (T-1 l.36-37). Adding `prop_noSilentUnderAdmit` (two fine-grained-distinct causes → two
distinct admitted txids) raises executable coverage of a **stated** guarantee at zero cost to the other axes
(an owed §3 test is not ornament). **Named axis: testability.** So not yet Pareto-optimal.

## 3. MINIMALISM + §4 anti-bias

**§4 CLEAN** — no functor, adjunction, commutative diagram, or "categorically" in any of the five files; every
term is ordinary (fenced lease, quorum, unique-key insert, read-back, hash chain, refold, sandwich,
continue-as-new). No proof leans on a box; delete-the-box leaves every argument intact. **Minimalism POSITIVE**
— S2/S5 add nothing (S2 → I4; S5 → D11/D12 + R-08); the diagnostic deletion (l.99) is a subtraction. No ornament.

## 4. Coherent single artifact ready to publish?

**Substantially yes.** T-1 r9 carries mapping table + decomposition per framework area (ledger/MD/valuation/
prod-sim seam) + all seven containments (S1-S7 in §4) + the D-divergence references + harvest + exercised-empty
parking; β is the sole reproducibility symbol, single-voice. The consensus artifact is **T-1 (assembly) + T-4
(catalogue)**, now reconciled (both 3-tuple). **One structural gap for T-1 to close:** the missing harvest row
(item 2/5); secondarily, cite T-4 explicitly as the companion catalogue so the pair reads as one publication.

## 5. Firing-witness harvest — right move? complete?

**Right move: YES.** The reference implementation lives outside the specification (CLAUDE.md §5/§10); the
design's obligation is to make each guarantee's firing *obligatory* and to prove each precondition *generable*
by naming a concrete generator — which §5 does (property + generator + obligation). Leaving them to the impl
risks a vacuous pass (a precondition never generated). **Complete? NO — one owed witness.** S1-S7 + COVERAGE-β
+ I1/I3/I4 each map to a generator; only I2 is *half*-witnessed. The harvest's own convention is to carry an
implementation-conformance generator per guarantee (storm, skew, deploy-injection); by that same convention the
exact-grained-cut / no-under-admit direction of I2 is owed and absent. That asymmetry inside one invariant, in
a harvest whose sole purpose is §3 completeness, is the gap.

---

**TuringAward CONSENSUS SIGNATURE: NO.** Single blocking issue — the §3 firing harvest is one witness short:
no generator asserts that two fine-grained-distinct causes yield two distinct admitted txids (the
injectivity / no-silent-under-admit dual of **I2**, the exact-grained `input-cut`). The double-admit half fires
(`prop_exactlyOnceAdmission`, txid held fixed); the under-admit half — the failure the design explicitly guards
against (T-1 l.36-37) — is ungenerated, so by the Constitution's words it "is defended only in prose" and "is
not an invariant." This is a **one-row close** (`prop_noSilentUnderAdmit`) that reopens **no** design decision;
on its addition to §5 I convert to YES. Everything else passes: the design (three record kinds + one lineage
discipline + containments + I1-I4 + COVERAGE-β) is architecturally sound, minimal, §4-clean, coherent, one
design; S2 and S5 both survive; it is Pareto-optimal on correctness / minimalism / simplicity and fails Pareto
solely on testability by this single omission.

## Declaration
Lenses applied: L2, L1, L8, L3, L5, L6. Dismissed: **L4** (no new algorithm/data structure — all reduce to
unique-key insert, hash-chain revalidation, fold); **L9** (no new numeric — β is a prior bound); **L10** (no
learned component near a safety property); **L7** (no new transport/timeout — skew is contained to liveness).
Confidence: **HIGH** — each finding cites a clause; the blocking gap is a named missing generator, not a
judgment call. Biggest residual unknown (non-blocking, correctly parked): the load model K sizing Forks C/D.
