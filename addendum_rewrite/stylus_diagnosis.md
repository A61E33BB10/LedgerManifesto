# STYLUS Diagnosis — `_original_addendum.tex` (Addendum A1 to v10.3, "StatesHome")

Scope: every cryptic instance in the addendum, classified by the five requested
categories. Each entry gives location (section + `.tex` line), the offending text,
and the plain-language intent the rewrite must carry. Where the intent cannot be
stated without subject-matter knowledge STYLUS does not own, the entry is marked
`CONSULT:<specialist>` and STYLUS stops there.

The single structural fault behind most entries: the addendum is written as a
**record of an agent deliberation** (who proposed what, in which round, under which
codename), not as a **derivation**. The reader is handed verdicts, codenames, and
scores in place of the argument. The rewrite must convert provenance into
derivation: state each result, then the reason that forces it, in deductive order,
with every term defined before use.

---

## Category 1 — Agent-private shorthand used as if shared

These are codenames, reviewer attributions, and internal work-file citations that
carry meaning only inside the deliberation that produced the document. Each must be
replaced by the *argument it stands for*; the name itself is struck. A design never
stands on who proposed it.

| # | Location | Offending text | Intent the rewrite must convey |
|---|----------|----------------|-------------------------------|
| 1.1 | §1, L78 | "Adversarial reviewers — `formalis`, `jane-street-cto`, `testcommittee`, `correctness-architect`, `institutional-brake` — stress-tested every proposal" | Cut. Reviewer roster is provenance, not content. If retained at all, relegate to a single closing provenance note; no claim in the body may rest on it. |
| 1.2 | §2.2, L118 | "(Lattner, Jane Street)" | Keep the discipline and its reason (Option accessor; `None` vs `Some(zero)` both load-bearing); strike the attribution. |
| 1.3 | §2.2, L119 | "(Feynman, testcommittee)" | Keep the monotone-carrier discipline and its reason (replay as fold; stable key set); strike the attribution. |
| 1.4 | §4.1, L188 | "the Karpathy substitution test" | State the discriminator plainly: two wallets holding the same contract can hold different `accumulated_cost`, so any `u`-only keying collapses distinct positions. Drop the name. |
| 1.5 | §4.1, L189 | "(R5\_futures A3)" | Internal work-file cite. Inline the substance (back-dated corrections make a cached `first_touch_date` fold-inconsistent) or drop the cite. Not an enforceable reference. |
| 1.6 | §4.2, L215 | "Why this is not the Dirac $u_\emptyset$ hack." | Name the rejected design plainly (a sentinel unit with no issuer/holder/conservation partner) and contrast it with `u_MA` (a real contract). Drop the codename. |
| 1.7 | §4.3, L243 | "(R5\_managed\_account) … (R5\_qis) … `correctness-architect` and `formalis` broke the tie" | Keep the forcing reason (a client holding two strategies carries two HWMs, so any `w`-only keying collapses them). Strike both cites and the authority appeal. |
| 1.8 | §5 table, L279–282 | Row labels "Dirac $\sigma$ … with $u_\emptyset$ sentinel", "Minsky 4-map", "Grothendieck sheaf on $H_t$", "F — 2-map … with universe wallet $w_\star$" | Each rejected design needs a plain structural descriptor in place of the codename (e.g. "partial map with sentinel unit", "four-map with explicit WalletState", "sheaf over the held set", "two-map with a universe wallet"). |
| 1.9 | §5, L289–291 | "B dominates E (Grothendieck) … the Minsky denormalisation trap … C (Dirac $u_\emptyset$)" | Restate each domination in terms of the structural fault, not the codename. "Minsky denormalisation trap" must become its definition: folding `UnitStatus` into `PositionState[w_⋆,u]` re-introduces the per-unit/per-(w,u) split as a runtime predicate and forces a conservation carve-out. |
| 1.10 | §5.1, L301 | "Karpathy substitution" | Same as 1.4; state the discriminator, drop the name. |
| 1.11 | §5.1, L306 | "(R6\_formalis §2 enumerates every candidate and shows each collapses to $(w,u_\mathrm{MA})$)" | Keep the claim (every per-wallet economic-state candidate collapses to a `(w, u_MA)` key, so the fourth sector is economically empty); drop the cite or replace with the enumeration itself. |
| 1.12 | §6, L325 | "(R7\_correctness)" | Internal cite for "no other candidate exceeds 3 unreachable invariants." Inline or drop. |
| 1.13 | §7, L332 | "The `testcommittee` (R4, R7) committed to concrete numbers" | Strike the process framing; state the numbers as commitments of the spec, not of a committee. See 5.3 for the numbers themselves. |
| 1.14 | §7, L337 | "meets the Feathers change-safety threshold" | Hand-waving external appeal. Either pin the 80% figure to a citable source or state it as a project-chosen threshold. `CONSULT:testcommittee` for the enforceable source, if one is claimed. |
| 1.15 | §9, L348 | "The `institutional-brake` reviewer raised eight concerns." | Strike the reviewer framing; present the eight items as the risk register of the design. |
| 1.16 | §10, L379–403 | Entire Iteration Log: "grothendieck, noether, minsky, dirac, finops-architect, rosetta-cdm-engineer, geohot, karpathy, feynman, chris-lattner, gatheral …", round-by-round narration, and "All agent reports are preserved in `/home/renaud/A61E33BB10/output/...`" | This is process history, not derivation. Cut from the body. If provenance must be recorded at all, one sentence: the design is the fixed point of adversarial review; reports archived at `<path>`. No body claim may cite a round or an agent. |
| 1.17 | §5 L289; §11 L481 | "Elegance is real; shippability is not." / "Ship B." | Colloquial/imperative register. Replace with declarative statements (the design is adopted because it is the unique Pareto-optimum and is implementable). |
| 1.18 | Abstract, L61; footer L486 | "twenty-seven independent adversarial agent invocations across eight review rounds" / "compiled 2026-04-22 from 27 adversarial agent rounds" | Provenance presented as if it were evidence of correctness. Strike from the argument; correctness rests on the derivation, not the headcount of rounds. |

---

## Category 2 — Conditions C1–C12 referenced before defined

C1–C12 are enumerated in §2.5 (L132–147). The faults are forward labels and a
one-statement-two-places violation, not deep ordering errors (C3–C12 are not used
before §2.5).

| # | Location | Offending text | Intent the rewrite must convey |
|---|----------|----------------|-------------------------------|
| 2.1 | Abstract, L61 | "Twelve conditions, denoted C1–C12, make seven of the ten core invariants of §11 structurally unreachable." | The label `C1–C12` is meaningless in the abstract. Either name what the conditions are (the discipline set on the three maps) or defer the label. |
| 2.2 | §2.2, L122 | "Both are required. This is **C1**." | C1 is introduced inline here, then re-stated verbatim in the §2.5 list (L135). Single-statement violation. Decide one home: either define C1–C12 once at §2.5 and let §2.2/§2.3 reach them, or fold the §2.5 list into the points of first use. Do not state twice. |
| 2.3 | §2.3, L130 | "Induction over the event stream gives the global invariant. This is **C2**." | Same double-statement as 2.2 (C2 re-stated at L136). One home only. |
| 2.4 | §8, L315–323 | P1/P3/P5/P6/P7/P9/P10 each cite C-conditions | These come after §2.5, so the C-references are sound. No forward-reference fault; listed only to confirm it was checked. |

---

## Category 3 — Abstraction stated before it is grounded in a concrete case

The abstract claims the four test cases "force the design," yet §2 (The Ruling)
presents the three maps and all twelve conditions as fiat, and §4 (the cases)
arrives only afterwards as illustration. Result-first is correct for the one-line
answer; it is wrong for the *conditions*, which are derived obligations and read as
inevitable only once the case that forces each is on the page.

| # | Location | Abstraction stated early | Concrete case that grounds it (later) | Intent |
|---|----------|--------------------------|----------------------------------------|--------|
| 3.1 | §2.5 (L132–147) vs §4 (L169–264) | C1–C12 enumerated as a list before any case | Futures (§4.1), managed account (§4.2), QIS (§4.3), untraded (§4.4) | Each condition should be derived at the case that forces it (C1 ← futures/untraded, C8 ← bond amendment, C9 ← untraded zero-holder, C12 ← managed account), then collected. The bare list precedes its own justification. |
| 3.2 | §2.2, L118–119 | "Option accessor" and "monotone carrier" disciplines | Futures ghost rows (§4.1 L190), untraded `None` (§4.4 L254), wash-sale/VM-settle readings | State why `None` ≠ `Some(zero)` and why rows persist *at the case that needs it*; do not assert the discipline before the reader has seen the demand. |
| 3.3 | §2.4, L126–130 | "$\sum_w \Delta f(w,u)=0$ structurally per event class" | Futures Trade/SettleVM zero-sum (§4.1 L183) | The concrete buyer-delta + seller-delta = 0 example is the argument; the abstract statement currently leads and the example re-narrates it. Lead with the worked case. |
| 3.4 | §2 (L99) | "the $W$-sector is empty of economic state and collapses into PositionState" | Managed-account mandate-as-unit (§4.2 L195–217) | The collapse is *asserted* in the ruling and only *grounded* two sections later. The mandate-as-unit derivation must precede or accompany the collapse claim. |
| 3.5 | §6 (L313) | "7 of 10 core invariants structurally unreachable … No other candidate exceeds 3" | Rejected designs A–F (§5) | The comparative claim depends on the alternatives; it currently leads them in reading weight. Order so the alternatives and their faults precede the "no other exceeds 3" verdict. |

---

## Category 4 — Undefined notation

Every symbol and term-of-art below is used without definition. The rewrite must
introduce each once, at first use, or replace it with defined vocabulary. Grouped
by kind.

**Type / map notation**
| # | Location | Notation | Intent |
|---|----------|----------|--------|
| 4.1 | §2, L88–90 | `Map[...]`, `NonEmptyList[TermsVersion]`, "total on registered u", "append-only, versioned", "mutable, shared", "monotone carrier", "Option accessor" | Define the map/type vocabulary once (what `Map[K,V]`, `NonEmptyList`, "total", "append-only" mean in this spec) before the schema, or adopt the spec's existing notation if v10.3 fixes it. `CONSULT:formalis` for the canonical v10.3 type vocabulary. |
| 4.2 | §2, L96 | `Map[WalletId, WalletMetadata]`, "audit cursor" | Same vocabulary; define "audit cursor". |
| 4.3 | §2.2, L118; §4 throughout | `Option[PositionState]`, `None`, `Some(zero)`, `zero_P` (L163) | Define the Option type and the zero element `zero_P` once. `Some(zero)` and `zero_P` must be the same defined object. |
| 4.4 | §2.5, L139, L141 | "registration-total" | Define once: total on the set of registered units, undefined elsewhere. Currently used as if standard; it is project coinage. |
| 4.5 | §2, L146 | "$W$-sector", "schema" | Define "$W$-sector" (the hypothetical wallet-keyed state map) at first use; it recurs (L99, L306, §5, F8). |

**Mathematical notation**
| # | Location | Notation | Intent |
|---|----------|----------|--------|
| 4.6 | §2.4, L128 | $\sum_w \Delta f(w,u)=0$ | Define the index set of `w` (all wallets? holders of `u`?) and `Δf`. The quantifier domain is load-bearing for the vacuous (zero-holder) case and must be exact. |
| 4.7 | §4.2, L197 | $w_\mathrm{manager}(u_\mathrm{MA})=-1$, $\sum_w w(u_\mathrm{MA})=0$ | `w(u)` (holding/quantity of unit `u` in wallet `w`) is never defined and overloads `w`, which elsewhere denotes a wallet. Introduce the holding function with a distinct symbol. `CONSULT:formalis` for the v10.3 symbol for quantity/holding. |
| 4.8 | L163 | $\mathcal{U}$, $zero_P$ | Define the unit universe $\mathcal{U}$ and `zero_P` at first use. |
| 4.9 | §4.4, L253, L262 | "`view.unit_status(u)` is total", `is_fungibility_preserving : ProductTerms × TermsAmendment → {Preserving, Breaking}`, `TermsAmendment` | Define the `view.*` accessor surface and the `TermsAmendment` type once. The predicate signature is fine once its domain types are defined. |
| 4.10 | §5 table, L279 | $\sigma : W \times U \rightharpoonup S_u$ | Partial-function arrow `⇀` and state space `S_u` undefined. This is a rejected design; define minimally or describe in words. `CONSULT:correctness-architect` for `S_u` if the row is kept quantitative. |
| 4.11 | §5 table, L281 | $H_t \subseteq W \times U$ | "held set at time t" never defined. Define or describe in words (rejected design). |
| 4.12 | §5 table/prose, L282, L290 | universe wallet $w_\star$ | Define `w_⋆` (the synthetic wallet holding unlisted/universe inventory) at first use. |
| 4.13 | §5.1, L301–304 | "(i)–(iii)" | Labels are fine once the three constraints are stated; ensure they are introduced before being referenced ("Removing any of the three breaks one of (i)–(iii)"). |

**Invariant and unit-subscript labels**
| # | Location | Notation | Intent |
|---|----------|----------|--------|
| 4.14 | §2 onward | `u_MA`, `u_QIS`, `u_∅`, `u_ES`, `u_NQ`, `u_YM`, `u_bench`, `u_MA,C`, `u_new`, `u_old` | Subscripted unit identifiers used before introduction. Introduce the subscript convention once (a unit and its role), or gloss each at first use. `u_∅` in particular appears (§4.2, §5) before the rejected design that defines it. |
| 4.15 | §8, L316–322 | P1, P3, P5, P6, P7, P9, P10 | Defined only by a parenthetical gloss; full statements live in v10.3 §11, which the reader does not have. Either inline the exact invariant statements or pin the reference: "v10.3 §11, invariant Pn (version X)". `CONSULT:formalis` / source v10.3 §11 for the exact statements. |

**Quantitative / tooling notation**
| # | Location | Notation | Intent |
|---|----------|----------|--------|
| 4.16 | §7, L338 | `|W|=3, |U|=2, depth≤6`, `10^5–10^6`, "TLC-tractable" | Define the model-checking bound and "TLC" (TLA+ model checker) at first use, or cite the tool with a version. |
| 4.17 | §7, L341 | "CDM enum × product-type cross-product", "generator universe" | Define the generator universe and the CDM enumeration referenced. `CONSULT:rosetta-cdm-engineer` for the precise CDM artefact and version. |
| 4.18 | §9, F3, L358 | "$10^7 \times 10^6$ scale", "tombstone-compaction", "retention horizon" | Define the scale figure's units (wallets × units?) and the compaction policy term. |
| 4.19 | §10 reference impl, L435 | `FIELD_SPEC` tags "conserved" / "monotone" / "handler" | The code is self-contained; ensure the prose maps these tags to C2 (conserved), C1 (monotone), C11 (handler) so the example carries the argument rather than restating it. |

---

## Category 5 — Pareto A–F table with no legible argument

| # | Location | Problem | Intent |
|---|----------|---------|--------|
| 5.1 | §5, L271–284 | Six designs scored 0–10 on Testability / Correctness / Simplicity, with "simplicity axis inverted for display." No rubric, no derivation of any number; "inverted for display" is internally confusing (the column reads higher = better, contradicting "inverted"). The table is the load-bearing justification for "Ship B" yet is illegible. | The argument that forces B is the *qualitative forcing reason each alternative loses* (sentinel breaks conservation; fourth sector economically empty; sheaf needs unavailable tooling; two-map re-introduces a carve-out). That reasoning already exists in the "Domination findings" prose (L286–292) and in the checklist. Lead with it. If the numeric scores are kept, each must show the rubric that yields it. `CONSULT:testcommittee, correctness-architect` for the scoring rubric — STYLUS cannot state the intent behind individual scores (why B=9/9/8, E=8/9/2) without it. |
| 5.2 | §5, L294 | "B is the unique Pareto-optimum under any correctness gate ≥ 7" | Depends entirely on the scores in 5.1. Either derive it from the qualitative dominations or, if quantitative, justify the "≥ 7" gate and the scores together. Not legible as written. |
| 5.3 | §7, L334–339 | Mutation scores 85–90% / 70–80% / ≥80% and the state-space figures asserted as commitments with no derivation | These are quantitative claims STYLUS cannot ground. `CONSULT:testcommittee` for the basis of each figure and for whether "Feathers threshold" (4 / 1.14) is a citable source or a project choice. Preserve the numbers exactly (checklist §10 forbids changing them); the rewrite governs only their framing. |

---

## Enforceability flags (struck appeals and unbacked references, for the owning agents)

These overlap the categories above but are collected here because they are
external-reference faults the rewrite must not silently keep:

- **"Feathers change-safety threshold"** (§7 L337) — appeal to an authority by name with no pinned source. `CONSULT:testcommittee`: derive the 80% target or bind it to a citable, versioned source.
- **"sheaf generators require non-existent libraries"** (§5 L289) — time-bound, unenforceable claim about tooling availability. `CONSULT:correctness-architect`: state the precise structural reason the sheaf design is not implementable, or strike.
- **SFTR / EMIR** (§9 F5 L362) — real regulations, but cited without identifier or version, and the claim "mandate-as-unit creates a reporting surface" is content, not form. `CONSULT:institutional-brake` (regulatory): pin SFTR/EMIR by identifier and version and confirm the reporting-surface claim.
- **CDM / "Rosetta NS1–7"** (§9 F6 L364) — internal mapping label, not an enforceable reference. `CONSULT:rosetta-cdm-engineer`: name the CDM artefact and version against which alignment is asserted.
- **"1099-B reconstruction", "wash-sale lookback"** (§4.1 L190, §2.2 L118) — US tax concepts used as justification; admissible only if pinned to the governing rule. `CONSULT:institutional-brake` (regulatory): bind to the citable IRS provision or restate as a derived requirement.

## Conformance-gap flags (derivation present, conformance not demonstrated)

- The three-map schema is derived from the primitives (§5.1 forcing constraints) but its conformance to v10.3 §11 (the ten core invariants P1–P10) is asserted by gloss, not demonstrated, because the invariant statements are external. `CONSULT:formalis`: supply the exact v10.3 §11 invariant statements so the "7 of 10 unreachable" claim can be shown rather than asserted.
- Mandate-as-unit is derived from the issuance law (§4.2) but its conformance to the regulatory reporting regime is open (F5). Flagged above.

---

## Summary

The addendum's pervasive defect is that it documents a deliberation instead of
presenting a derivation. The five categories are symptoms of that one cause:
codenames and round citations (Cat 1) stand in for arguments; the condition labels
C1–C12 (Cat 2) and the whole-document order (Cat 3) present obligations before the
cases that force them; the type, mathematical, and tooling vocabulary (Cat 4) is
used as if shared; and the decisive comparison (Cat 5) is a score table with no
rubric. The rewrite must (a) strike every agent name and work-file cite, keeping
only the reason each stood for; (b) define every symbol and term-of-art once, at
first use; (c) reorder so each condition is derived at the concrete case that
forces it; and (d) replace the Pareto scores with the qualitative forcing reasons
already latent in the prose. Items STYLUS cannot resolve without content are marked
`CONSULT:` against testcommittee, correctness-architect, formalis,
rosetta-cdm-engineer, and institutional-brake; STYLUS stops at those gaps rather
than inventing intent. No numeric commitment (§5 scores, §7 mutation scores, §10
process counts) is altered — only its framing.
