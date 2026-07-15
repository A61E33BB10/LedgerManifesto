# FORMALIS Fidelity Check — UnitStatus "Mutable" Amendment

**Verifier:** FORMALIS Committee (Leroy, Chair; Coquand, Huet, Paulin-Mohring, de Moura, Avigad, et al.)
**Subject:** Does the amendment implement the SETTLED synthesis
(`unitstatus_review/formalis_synthesis.md`, DERIVED PROJECTION, 9/9) faithfully and without over-reach?
**Verdict:** PASS — every MUST-change is done, every PROTECTED item is untouched, no over-reach, and the
reference single-writer closure genuinely shuts the gap.

Scope reminder (not re-litigated): UnitStatus is a *materialised projection* of the immutable event log —
a read cache whose every change is caused by a logged event and is rebuilt exactly by replay. The corpus
defect was one word, "mutable". The fix is wording (relabel) plus the reference/tests closure commissioned
for this pass. The numbered MAT C-invariant and the C-list C11/UnitStatus extension are explicitly OUT of
scope of this pass and were correctly NOT added to the prose documents.

---

## 1. Canonical wording — used verbatim, no drift

Word-sequence containment was checked mechanically across all five files.

| File | FULL canonical (prose) | COMPRESSED canonical (terse cell) | Correct? |
|------|:----------------------:|:---------------------------------:|:--------:|
| States.tex                  | present | — | yes (prose) |
| FutureLifeCycle.tex         | — | present (l.58 cell) | yes (terse) |
| managed_account_workflow.tex| present | — | yes (prose) |
| addendum_stateshome_v2.tex  | present | present (code-comment row) | yes (both, as directed) |
| reference/StatesHome.hs     | present | — | yes (header comment) |

The distribution is exactly what the task prescribes: the single terse state-table cell (FutureLifeCycle
l.58) and the code-comment table row (addendum) carry the COMPRESSED form; every prose statement of the
discipline carries the FULL form. No third paraphrase of the discipline exists. No drift.

---

## 2. MUST-change checklist

| # | Required change | Status | Evidence |
|---|-----------------|:------:|----------|
| 1 | **FutureLifeCycle l.58 Discipline cell** — the single most important edit; bare "mutable, shared across holders; registration-total" → COMPRESSED canonical | DONE | `FutureLifeCycle.tex:58` now: "projection of the log, overwritten in place as a read cache; shared, read identically by every holder; registration-total --- every change caused by a logged event, rebuilt exactly by replay" |
| 2 | **States.tex** — clarify the "overwritten" passage so it is unmistakably *cache* overwrite, cause logged | DONE | `States.tex:201–207` carries the FULL canonical verbatim; the prior bare "overwritten" reading is gone |
| 3 | **States.tex** — optional rebuild-guarantee sentence (clarification only) | DONE | `States.tex:398–403`: stored UnitStatus "is a cache the log can always rebuild ... total on well-formed prefixes, deterministic, and reconstructible ... a logged event is the only thing that can change it" |
| 4 | **managed l.510–513** — rewrite the concern that voiced the REJECTED reading ("only as reproducible as a mutable cell") to the RESOLVED position | DONE | `managed_account_workflow.tex:513–541` (E2): the fee-striking price "lives in the immutable settlement event in the log, not only in the overwritten cache cell, so replaying the events rebuilds it exactly ... never ``only as reproducible as a mutable cell.''" |
| 5 | **managed** — state separately and honestly: reproducing the NUMBER is assured; ATTESTATION is a DISTINCT requirement (Nazarov), NOT fixed here | DONE | `managed:519–533`: "Reproducing the number is therefore assured." then "What remains open is distinct from reproducibility: attestation ... determinism is not attestation ... recorded separately as the Nazarov finding and is not resolved here" |
| 6 | **managed** — harmonise every UnitStatus mention to one voice; keep the A1 deferral but pointed at corrected definition | DONE | `managed:96–105` states the FULL canonical inline within the three-map model; A1 references now resolve to corrected wording |
| 7 | **addendum** — relabel code-comment row, home-table row, and prose ("shared mutable UnitStatus", "settlement prices and immutable terms share one mutable cell") to canonical / resolved voice | DONE | `addendum:164–166` (COMP row), `addendum:214` (home row, "a projection of the log (read cache, rebuilt exactly by replay)"), `addendum:60–63` & `175–187` (prose FULL), `addendum:671` ("share one overwrite-in-place cell") |
| 8 | **addendum** — make explicit that the CACHE CELL is overwritten while the settling EVENT is appended immutably | DONE | `addendum:602–607` (Why Three, point iii): "the status cache cell is overwritten on every settle, while the settling event that determines it is appended immutably to the log" |
| 9 | **MAT-soundness principle in PLAIN words** where each doc introduces UnitStatus ("stored value always equals what replaying the unit's events produces, and no part of the system writes it except through a logged event") | DONE | `addendum:181–183` verbatim; the FULL canonical (carrying the same operational content) appears at the UnitStatus introduction in States/managed/hs |
| 10 | **External-observable qualifier** — settlement price and benchmark level CAPTURED AS A LOGGED OBSERVATION EVENT | DONE | settlement price: `States.tex:207–208`, `FutureLifeCycle.tex:219–222`; benchmark level: `managed:151`, `addendum:373`, plus boundary note `addendum:185–187` and `StatesHome.hs:151–156` |
| 11 | **Plain language over category theory** — catamorphism/fold/Kleisli translated; "materialised projection" glossed on first use | DONE | "replaying the events ... rebuilds the exact value"; C1(b) law rendered as "replaying two batches of events in sequence gives the same result as replaying them together" (`FutureLifeCycle:417–419`, `addendum:713–719`); first-use gloss "a cached view the log can always rebuild" (`managed:97`, `addendum:61`) |
| 12 | **Reference single-writer closure** for ALL UnitStatus fields (the one real gap) | DONE | `StatesHome.hs`: closed `StatusWrite` sum + total `applyStatus` is the SOLE UnitStatus writer; folded inside `applyDelta`; `amend` routes supersession through it; `register` sets genesis default; no exported `setStatus`, no record-update on UnitStatus elsewhere, `Ledger` sealed. Signal S5 records the design choice. |
| 13 | **Gating tests** present | DONE | `tests/Test1_GenesisRefold.hs` (store == independent re-fold at every cut), `tests/Test2_BackdatedRestatement.hs` (M1 past immutable / M2 correction-as-appended-event), `tests/Test3_ExternalObservables.hs` (purity, status-less inertness, cache==payload), shared `tests/LedgerTestKit.hs` with an independent re-fold oracle |

All thirteen hold.

---

## 3. Protected-list checklist (verify UNTOUCHED)

| Protected item | Status | Evidence |
|----------------|:------:|----------|
| Overwrite-in-place, NON-VERSIONED storage of UnitStatus (NOT made append-only/versioned) | INTACT | UnitStatus remains a single overwrite-in-place cell everywhere; no version list introduced; wording says "overwritten in place as a read cache" |
| "shared, read identically by every holder" / u-keying phrasing | INTACT, verbatim | `States.tex:130–131`, `FutureLifeCycle:77,431`, `managed:101–102`, `addendum:60,176,257`, `StatesHome.hs:147–149` |
| Sealed Ledger (unexported constructor + field selectors) | INTACT | `StatesHome.hs:381–389` abstract; export list (l.56) exports `Ledger` abstract; `States.tex:279` comment preserved |
| Closed writer set; NO exported setStatus | INTACT (strengthened for UnitStatus by StatusWrite/applyStatus, as commissioned) | no `setStatus` in any export list; every status change a case of `applyStatus` |
| Registration-totality (C5/C7; default at registration) | INTACT | `addendum` C5/C7; `defaultStatus` at `register`; "A value exists from registration onward" |
| Idempotent write-by-replacement (P5) | INTACT | `addendum:720–728`; `StatesHome.hs:196–200` last-write-wins idempotent |
| Monotone PositionState carrier / Option accessor | INTACT | C1(a)/(b); `StatesHome.hs:203–232,478–479`; no row deleter |
| accumulated_cost home in PositionState | INTACT | `FutureLifeCycle:79–85`, `addendum:219–224,260`; conserved per-position |
| ProductTerms "immutable, versioned, append-only" wording | INTACT, verbatim | `FutureLifeCycle:57`, `addendum:163`, `StatesHome.hs:36,99`; unrelated, untouched |

All nine intact.

---

## 4. Over-reach check (nothing changed beyond what the synthesis directs)

- **States.tex model unchanged.** "Every view is a projection of the stream" (`l.398`) and
  `replay = foldM apply` (`l.386–387`) are preserved; the only additions are clarifying prose. OK.
- **No numbered MAT C-invariant added** to the prose documents; the addendum's condition set is still
  C1–C12 (`addendum:556–584`). The MAT principle appears in PLAIN prose only, as directed. OK.
- **C11 not extended to UnitStatus in the addendum prose** (C11 remains a PositionState discipline,
  `addendum:328–340`). The single-writer closure for UnitStatus lives only in the reference (this pass)
  and is recorded as design-tradeoff signal S5. OK.
- **Retained "mutable" usages are out-of-scope and correct, not stragglers:**
  - `managed:500` "mutable PositionState scalars" — escalation **E1** (store-vs-derive of HWM/entry-NAV/
    accrued-fee), an explicitly *open, additive* divergence in synthesis §5.1; concerns PositionState, not
    UnitStatus; leaving it is correct (changing it would be over-reach into a separate finding).
  - `managed:522` "only as reproducible as a mutable cell" — the *quoted rejected phrase being rebutted*.
  - `managed:549` "a mutable LEI" — escalation **E3** (counterparty identity / WalletRegistry), unrelated.
  - All remaining "immutable" hits are ProductTerms / event-log descriptors (protected, correct).
- No structural code change beyond the commissioned UnitStatus single-writer closure and its tests.

No over-reach found.

---

## 5. Does the .hs closure genuinely close the gap?

Yes. The synthesis named "extend the single-writer closure to *all* UnitStatus fields so no writer exists
outside the fold" as the one real gap. In `StatesHome.hs`:

1. `StatusWrite` is a **closed sum**; each constructor names exactly one UnitStatus field
   (`SetLifecycle`, `SetLastSettle`, `SetSupersededBy`).
2. `applyStatus` is **total** over that sum and is the **only** function that writes a UnitStatus field —
   verified by inspection: no other record-update on a `UnitStatus` value exists in the module.
3. `applyDelta` folds the event-carried `sdStatus` writes through `applyStatus`; `amend` (Breaking) and
   `register` (genesis default) are the only other status touch-points, and both route through the same
   total step. There is **no exported `setStatus`**, and `Ledger` is sealed.
4. Therefore the stored cell cannot change except as the image of a logged event under a pure total fold —
   the materialisation-soundness property holds **by construction**, and the gating tests assert it will
   keep holding once the addendum leaves the by-construction regime (E1/E2/F3):
   - Test 1: store == independent re-fold oracle, at every prefix/cut.
   - Test 2: past immutable (M1) and correction-as-appended-event (M2); no in-place patch reachable.
   - Test 3: purity/determinism, status-less events inert, cache == logged payload, number tracks the
     observation. The Nazarov attestation gap is recorded as out of scope, consistently with §5.2.

The rejected "authoritative-mutable" reading is now *unrepresentable* in the reference and *unwritable* in
the prose.

---

## 6. Verdict

**PASS = true.** The amendment implements the FORMALIS synthesis exactly: the load-bearing relabels are
done (FutureLifeCycle l.58 above all), the managed-account passage now speaks the resolved voice while
honestly separating reproducibility from attestation, the canonical wording is used verbatim with no drift,
the materialisation-soundness principle is stated in plain words where UnitStatus is introduced, the
external-observable qualifier is present at both boundaries, every protected invariant is untouched, there
is no over-reach, and the reference single-writer closure plus its three gating tests genuinely close the
one real gap. A competent implementer reading any of the four documents must now conclude, without doubt,
that the only way UnitStatus changes is through a logged event and that the stored cell is a cache the log
can always rebuild.

*"We do not verify that code runs. We verify that code is correct." — and that the prose can no longer be
read to license an off-log writer.*
