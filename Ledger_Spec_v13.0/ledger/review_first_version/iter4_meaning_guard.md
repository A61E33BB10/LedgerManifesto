# GUARD LIST — `/home/renaud/Ledger/Ledger_Spec_v13.0/ledger/ledger_v13_0.tex` (7,833 lines)

The invariant of this pass: **the set of provable claims, their hypotheses, their qualifications, and their cross-reference labels must be conserved.** Every item in Part A below is a Noether current of the document — an editor may re-order or compress prose around it, but its meaning, its side-conditions, and its `\label` must survive. Part B distinguishes true duplication (mergeable) from deliberate hub-and-spoke restatement (must stay).

---

## A. STATEMENTS TO PRESERVE IN MEANING (by location)

### A1. Core theorems and propositions (13 — the load-bearing results)

| Loc | Label | Statement — and the part editors lose first |
|---|---|---|
| 571–581 | `inv:P1` Thm **System Closure** | ∑w wt(u)=0 ∀u,t; induction proof from all-zero start. Label doubles as the P1 anchor. |
| 1947–1962 | `inv:P10` Thm **Path-independent PnL** | Telescoping proof; **plus** qualification 1967 (unrecorded fee falls outside) and scope 1970 (economic, not accounting PnL). |
| 2162–2164 | Prop **Lot-split conservation** | Underlying and cash net to zero; value transferred = (K−ST)·N independent of split. |
| 2627–2644 | `prop:composition-law` | Composite arrow = interp(gₙ)∘…∘interp(g₁) **iff k in every declaration**; inverse iff every generator invertible; identity and associativity laws. Non-commuting 50-vs-49 example (2653–2660) is the existence proof that order-sensitivity is dissolved by data, not configuration — keep. |
| 2662–2679 | `thm:basis-value-invariance` | (q·f)·(p−c)/f = q·p − q·c; **hypotheses are admission conditions** (the weld), cash-in-lieu makes it exact to the minor unit. Explicitly the proof of Property 5 (restricted form, 313) — the link at 2681–2684 must survive. |
| 3717–3722 | Thm **Closing identity** (futures) | Cumulative VM per wallet = economic PnL; the numbers (+2100, −1700, −400, 0) are the computed witness. |
| 4011–4017 | `inv:singleton` **Mandate singleton** | support = {(w_M,−1),(w_C,+1)}; **plus** 4019–4024: conservation alone does NOT establish it — four primitives pin it (P1 + Option accessor + lifecycle guard + C8). |
| 4181–4187 | `thm:fee-zerosum` | Fee crystallisation is zero-sum per event. |
| 4204–4221 | `thm:seg` **Segregation** | Isolation **iff CONS ∧ LOC ∧ C4** — the point is that conservation alone is NOT segregation; CASS 6/MiFID II Art. 16(8) mapping; legal segregation out of scope; C4-in-prose is ME4. |
| 4255–4269 | `thm:trs-equiv` | TRS ≡ funded managed account as ledger op; the CDM report derives from the retained two-leg BusinessEvent, **never from the netted move**. |
| 5203–5222 | `thm:obligation-liveness` | Five-lemma proof L1–L5; **L4's prerequisite** (cluster availability is operational, not framework) and the four assumptions at 5303–5306 are the honesty conditions. |
| 5440–5447 | `prop:gpm-conservation` | Six-coordinate conservation; the **onloan cancellation** leaving the five-term identity encodes "lent shares counted once, as borr". In-flight reconciliation identity (5451). |
| 2540–2547 / 2562–2570 | `prin:tip-weld`, `prin:invariance-weld` | Admission-time welds; consequence list 2572–2576 ("positions doubled but basis not advanced" etc. unrepresentable). The tip weld's rationale (2529–2538: booking-order fold vs effective-order projection do not commute on retro-insertions) is the *inner ground* — do not compress it to the conclusion. |

### A2. The invariant series P1–P23 (canonical numbering fixed at §17)

- **Hub, canonical prose:** P1–P10 at 5903–5916 (P4's nuance — hash-chaining gives **tamper-evidence, not prevention** — is a scoped claim, keep exactly); P11–P20 index 5921–5937; P21–P23 index 5940–5949. Line 5885: numbering P1–P23 is canonical **here**.
- **Full statements at home sections:** P11–P20 in `inv:P11`/`inv:P20` block 5828–5843 (P18's buy-in exclusion and "by construction" mechanism; P20 as definition-not-check); P21–P23 at 5181–5198 (`inv:P21/P22/P23`). Line 5826: "every transaction satisfying P11–P20 also satisfies P1–P10" — the narrows-without-relaxing claim.
- **Two unnumbered global oracles** (5918): totality, valid-transitions-only.
- **Executable oracle table** App. B, 6461–6493 — normative test forms for P1–P10, stated to be the only place the test forms live (6457).

### A3. The condition series C1–C13

- **C1–C12 defined once**: table 1616–1664 (`cond:C1`…`cond:C12` hypertargets live here), except **C7 (825–829)** and **C10 (831–834)** defined in §3, plus the coupling invariant "registered in ProductTerms ⟺ registered in UnitStatus" (836–838).
- **C13 (basis edge)**: 2787–2792, "the data-plane sibling of P3".
- Hub index 5952–5978 cross-links; both discharge maps (see B7).
- Each condition's precise two-part content matters: C1 is **both** Option accessor **and** monotone carrier; C2 includes the **vacuous base case**; C9's "sums edge legs, never divides by a holder count" excludes a named bug class.

### A4. Definitions (illegal-state-exclusion is the content, not decoration)

§2: Wallet (436), Move (460–465, positive magnitude + direction-by-endpoints), **Transaction** (`def:transaction` 526–529 — total order by sequence number within a timestamp; conservation order-independent, intermediate state order-dependent), Real/Virtual wallets (635), initialisation with **no `set_balance` primitive** (693).
§3: Unit Identity principle (`prin:unit-identity` 738) + identity-key table 745–762 (**OTC identity includes the Collateral/CSA field** — two identical payoffs under different CSAs are different units); `unit_id` deterministic **and injective** (800); registration channels + never-deleted units (813–821); two-stage validation (873–888); four guarantees making P3 hold by construction (890–901).
§4: placement rule and 2×2 (981–1007, incl. WalletRegistry carries no quantity); **UnitStatus discipline** canonical statement 1134–1157; minimality (1666–1677: three constraints force three maps); **uniqueness argument** 1679–1702 (rejections A, C, D, E, F — each fails on a named forcing point); unrepresentability scope caveat 1711–1717 (read-scoping is capability-layer, **not** type-level — an honesty boundary).
§5: `def:portfolio-value` 1877–1884 (whole-ledger valuation is identically zero; scope is always chosen; P_t external) + qualification 1886; the **five illegal states excluded by the valuation types** (1930); `prin:state-sufficiency` 1936.
§6–7: smart contract def (2029); transition function signature f : (unit, state, market_data) → (moves, state′) (2215–2221); `prin:idempotence` (2250); `prin:executor` **single door** (2300–2307 — conservation is *not checked* at the door because unconserved proposals are unrepresentable; product guards live in `handle`); replay fold-homomorphism law and checkpoint-independence-as-consequence (2329–2341); `prin:purity` (2345) + the **market-data oracle requirement** and known-at-t vs restated-data distinction (2352, also 317); the four time-travel hard cases (2360–2365).
§8: `def:boundary-event` (2474), `def:basis-point` (2485–2507 — **ids stored, ordinals never**; W4 precedence; fail-closed collision), `def:usbasis` (2509), `def:opspec` (2584–2612 — **AId declared, never default**; exact rational plane; `toPrice` the single rounding site, round-half-even fixed in ProductTerms), `def:basis-category` (2614), `prin:rederivation` (2696 — never assume derivation commutes with adjustment), **TA-BASIS named trust assumption** (2742–2749), `inv:basis` Single-basis consumption (2754–2766) + stamp-closure well-definedness (2769–2774).
§9: ac is a **conserved field**, ∑ac=0 enforced at handler level (3222–3224); FutStateDelta/futValidate as a *boundary* kernel projecting onto core `applyTx` (3226–3240); the single dimension bridge — **Price has no Monoid** (3242–3256); the intraday-margin principle (3627–3634 — the −100 vs −300 computation is the forcing argument for C11); the three settlement answers (3636–3650); Some-flat vs None (3666–3675); physical settlement struck at **final settlement price, not trade price** (3705–3715); the three threaded invariants 3758–3788 (per-event conservation; Kleisli replay with **duplicate suppression as a boundary obligation** because FTrade is not idempotent; monotone **absorbing** stage — the rank guard alone is too weak, 2<2 is false; FClose the sole event admissible on EXPIRED).
§10: `prin:nonvalued` (4026–4031 — P(u_MA) **undefined, not zero**); HWM before subscription is None, **never 0** (4062–4068); guard determinism is price-relative, missing price fails closed, passive breach outside move-time guards (4082–4091); Perf net-of-flows formula (4109–4119); the three fee equations incl. HWM ratchet by max (4125–4134); `crystallise` at-most-one-move semantics with Nothing at zero (4141–4158); baseline B_k post-settlement + **rounding residual retained, never dropped** (4189–4199); CSA netting set = the single real u_TRS, never virtual constituents (4232–4237); TR_k partiality precondition V>0 (4252); single logged price for both realms (4271–4276).
§11: reconstruction formula (4397–4405); the Balances monoid is **pointwise union, not the left-biased Map default** (4424–4434 — "the whole correctness content of this type"); substantiation scope split — quantities/provenance by construction, valuations/disclosures/legal status **not** (4470–4476); dual-valuation def (4484–4491); CRR Art. 105 FVA (4502–4506); snapshot validity requires quiescence or MVCC (4513).
§13: `def:settle-projection` pure/total/deterministic/idempotent, Just only for SETTLEMENT|COLLATERAL (4632–4639); SettlementTx as boundary type, never the core Transaction (4641); **legs and type are one value** — no-legs instruction unrepresentable, type is a projection of legs (4690–4697, `def:settlement-instruction` 4739–4742); `prin:settlement-boundary` what-vs-how (4749); settlability assigned by contract, never inferred; LIFECYCLE "sometimes" = decomposition at source (4756–4775).
§14: forgetful map F — `ctPayload` retains the event verbatim, `ctPayload (forget e) == e` (4891–4953); **composition is restricted** to referentially independent events, with the causal-order precondition (4963); preserves conservation/sequencing/idempotency, forgets intent/lineage/structure/classification (4961–4969); the closed-enum generator universe (4977–4979, 6093–6117 — a new enum value with no rule is *flagged*, missing rejection is a bug).
§15: `def:obligation` six-tuple with **D and κ total** (5044–5057); live/terminal type split — leaving a terminal state unrepresentable (5071–5092); transition table (5096–5111); taxonomy table (`tab:obligation-types` 5116–5149); obligation store is a projection (5154–5159); `princ:obligation-completeness` (5166–5169).
§16: coordinate vs projection — the **physical-action test** (5334); `princ:single-coord` (5336–5341); six-coordinate `def:position-vector-gpm` (5345–5367) with per-coordinate physical actions; `def:avail-projection` (5369–5376 — never stored, cannot drift); avail as group homomorphism with the δ_c table (5423); **non-negativity is a value-level gate, not a type** (5425–5427); the four reasons own is a coordinate (5438); reclassification vs transfer (5477); `def:projections` (5484+).
§19: theorems-as-modelling-choices honesty paragraph (6208–6210); the nine "does not" items (6184–6206), esp. #9 reproducibility requires **dependency version-pinning**.

### A5. Property statements in §1 (the contract of the whole document)

Lines 302–318: the six by-construction properties. **Property 5** (`prop:lifecycle-value-invariance`, 313–315) must keep both its restricted-form statement **and** its qualification (optionality extinguishes time value; this is not a conservation violation). **Property 6** must keep the known-at-t vs restated-data distinction (317). Lines 322–332: three unreachable breaks **with the migration scoping caveat** (332). Ledger boundary lists 398–426 (see B4).

### A6. Numeric worked examples = proofs by computation

Every figure is a witness, not an illustration: PnL 157 = 100 + 57 (1986–2010); IRS 12,500 (2190); futures day-2 VM (−100, +500, −400) and every ∑=0 line (3617–3701); fee example 5,750 / 28,850 / HWM 1,115,400 (4174–4179); CSA 1.8M and SBL substitution conservation checks (5245–5291); named-wallet 1000+0+0+400−400−1000=0 (5471–5475); the eight-scenario avail verification (App. F, 7055+) and both SBL appendices (cited at 5826 as the correctness witnesses for P11–P20). **No number may change; no ∑=0 line may be dropped.**

### A7. Registers and commitments

Open-items register 6354–6420: F1–F8, mutation-score commitments (85–90%, 70–80%, ≥80%, TLC bounds), ME1–ME5, FE1–FE2. These are referenced from §4 (1826–1829), §9, §10 — the escalation pointers (ME1/ME2/ME4/ME5, FE1/FE2) embedded in body text are part of claims' honesty conditions and must survive with their claims.

### A8. Label integrity (mechanical guard)

The `\ref`/`\hyperref` graph depends on labels living where they do — in particular `inv:P1` and `inv:P10` are **theorem** labels, `cond:C1..C12` live in the §4 table (except C7/C10 in §3), `inv:P20` is in the SBL block while `inv:P20-hub` is in the hub, and `cond:conservation` is a Principle. Any merge that deletes a label site breaks compilation or silently retargets references. Also: quantities are exact `Integer` minor units, **never floating point** — this sentence recurs (473, 1814, 6008) because it is a hypothesis of P1 and P8; at least the §2 and hub instances must stay.

---

## B. DUPLICATION MAP — mergeable vs deliberate

### Safely mergeable (one fact, two registers, no meaning loss)

**B1. The UnitStatus-projection paragraph, verbatim ×3.** Lines **805–808** (remark, §3), **1137–1145** (§4.3, titled *"stated once"*), **3194–3200** (Principle, §9) are word-for-word the same paragraph. Canonical home is 1134–1157 (it alone carries the applyStatus/no-setStatus mechanism). The §3 remark and §9 principle can each become one sentence + `\S\ref{sec:states-unitstatus}`. Caution: §3 precedes §4, so keep a one-line gloss there, not a bare forward reference. The other echoes (4050, 4476, 4958, 6004, 6234, 6452, 6497) are already pointer-length — leave them.

**B2. Consecutive homomorphism remarks in §11.** Remarks at **4456–4460** and **4462–4468** both state `balances (xs <> ys) = balances xs <> balances ys`. The second is a strict superset (the law read three ways: determinism, O(k) snapshots, P1). Merge into one remark keeping the plain reading of the first and all three readings of the second. Zero loss.

**B3. Three Unreachable Breaks ×3.** §1.3 (322–332), Self-Consistency bullets (707–715), Key-Invariants box (946–949). The §2.8 version carries the mechanism per break; §1.3 alone carries the **migration scoping caveat** (332). §1.3 may shrink to announcement + pointer **only if the caveat migrates with it**; the box entry is already pointer-style.

**B4. Ledger boundary ×2.** §1.6 (398–426) says "The boundary is stated here, **once**"; §19.1–19.2 (6156–6182) restates both lists nearly verbatim. The restatement contradicts the "once". §19.1/19.2 can become a pointer to §1.6 — but the Regulator reading path (167) sends readers to §19, so retain the section with pointer plus its **unique** content: the nine "does not" items (6184) and the modelling-choices paragraph (6208). Alternatively collapse the §1.6 list and let §19 be canonical — either direction, but exactly one full statement.

**B5. Quantity-vs-value FX example.** The "FX trade conserves EUR and USD separately…" sentence appears near-verbatim at 1873 and 5895 (and in compressed form at 307). The **rule** must stay at all three roles (property statement, valuation motivation, oracle framing); the worked FX **sentence** can be kept once and pointed to.

### Deliberate restatements — must stay (hub-and-spoke by design)

**B6. Full statement vs hub index for P11–P20, P21–P23, C1–C12.** The hub (§17) explicitly indexes and defers: "stated in full … in Section~\ref{sec:sbl-invariants}; the index follows" (5924), likewise 5943, 5955. This is the document's declared architecture (5885: prose fixed at the hub for P1–P10, at home sections for the rest). Do not collapse either side. If trimming, only the *index* entries may shorten to bare pointers.

**B7. The two discharge maps** (§4.8, 1704–1754 vs §17.6, 5981–6002). Same map, and the text *says so and resolves the authority*: 1710 ("The P-numbers are the canonical hub numbering") and 5984 ("Section states presents the same map under its own local labels, for which the P1–P23 names here are canonical"). This is a deliberate local/canonical pair with different mechanism granularity. Do not merge.

**B8. The `unitDelta`/`netDelta` listing** in §2 (560–567) vs hub anchor (6012–6032): the hub declares them "verbatim excerpts of the reference". The repetition *is* the claim (types-as-theorems anchors). Keep.

**B9. Per-section Haskell preludes** (Qty/group instances redefined at 475, 1891, 3260, 4409, 5380). Each listing is a self-contained excerpt of a per-section reference and each annotates *why* locally (e.g. "Price carries NO Monoid" is load-bearing in §5 and §9 independently). Merging would break the excerpt-of-reference claims (1812, 6008). Keep.

**B10. Part-end "Key Invariants and Consequences" boxes** (923–950, 1831–1862, 5847–5877). Pure recap with canonical pointers — a declared convention ("Each is catalogued, with its executable oracle, in §17"). Keep the convention; these boxes are the *lowest-risk* compression sites if the owner ever wants length back, since every line names its canonical home — but they are not duplication errors.

**B11. Property 5 (§1) vs Theorem basis-value-invariance (§8).** Statement/proof pair with an explicit closing link (2681–2684). Keep both.

**B12. Preface / Abstract / Key Concepts / Glossary layering.** Four registers by design; line 196–197 fixes precedence (formal definition governs). Keep.

**B13. Obligation-store projection paragraph** (5159) resembles the UnitStatus discipline but governs a *different object* (the obligation store). Not a duplicate; keep.

---

**One-sentence charge to the editor:** compress connective prose freely; touch nothing in A without preserving statement + hypotheses + qualifications + label; of the repetitions, only B1–B5 are true merged-draft duplication — B6–B13 are the document's declared hub-and-spoke structure, and collapsing them would break the canonicality sentences (1710, 5885, 5984) that make the numbering system sound.