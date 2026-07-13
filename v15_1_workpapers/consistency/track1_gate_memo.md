# v15.1 Consistency Pass — Track-1 Constitutional-Delta Gate Memo

Base: certified Ledger_Spec_v15.1. Authority: Constitution v1.1 (read-only). Four deltas; each STOPS
at the USER GATE. No agent touches the Constitution; nothing freezes until the owner rules. If an
amendment is declined, the specification conforms.

---

## D1 — Deposit-neutrality stated conditionally  →  RECOMMEND **AMEND** (already filed as PARK-4)
- **Constitution §8:** a deposit "cannot change net owned value" — unconditional.
- **Spec (Prop 7.3):** a theorem "exactly when the declared financing rate equals the fair rate"; off-market,
  NAV moves (+$2 on 100-cash/98-fair). v15.1 already states this openly and PARKS it (does NOT relabel).
- **Objection ("a save by redefinition is still a save") — discharged:** Prop 7.3 says NAV moves and parks
  the conflict; it does not define the residue away.
- **Amendment (PARK-4 / C-8.7), clause replaced (Const §8 case 2):** "a contribution or financing received
  against an equal obligation created in the same transaction — collateral received under title transfer,
  cash included, is this case, owned by the receiver against an equivalent-return obligation that is itself
  a unit"
  **→ replacement:** "a contribution or financing received against an obligation created in the same
  transaction **and valued at fair value**, any day-one difference between the inflow amount and the
  obligation's fair value being **recognised as financing basis** — collateral received under title
  transfer, cash included, is this case, owned by the receiver against an equivalent-return obligation that
  is itself a unit"
- **DECISION NEEDED:** ratify this amendment, or decline (then spec must conform — but the fair-rate
  dependence is mathematically forced, so declining reopens Prop 7.3's correctness).

## D2 — Invented conflict-arbitration ORDER among the six commitments  →  RECOMMEND **CONFORM spec**
- **Constitution §2:** six commitments "non-negotiable"; NO lexical order.
- **Spec §1.2:** "The commitments are **ordered** by what arbitrates a conflict…"
- **Divergence:** a rule arbitrating BETWEEN the six is constitutional material the Constitution withholds;
  the spec's own examples resolve under plain conjunction, so "ordered" over-claims and is not load-bearing.
- **Conform text — replace** "The commitments are ordered by what arbitrates a conflict: a design that is
  auditable and reproducible but untestable is redesigned; a design that is elegant but cannot be replayed
  is rejected." **→ with** "The commitments are jointly non-negotiable, and a design is admitted only if it
  satisfies all six: a design that is auditable and reproducible but untestable is redesigned, and a design
  that is elegant but cannot be replayed is rejected — not because one commitment outranks another, but
  because each is required and none is waived."
- **DECISION NEEDED:** conform spec (recommended), or amend §2 to add an order.

## D3 — Trade-date booking of `owned`  →  RECOMMEND **CONFORM spec** (declared term; keep §4)
- **Constitution §4:** defines the atomic move + owned as value-bearing; fixes NO booking moment. Scope
  section puts "accounting-policy decisions" OUT of scope.
- **Spec:** "Owned re-books at instruction — trade-date booking" (universal, no branch for other agreements).
- **Divergence:** silence, not conflict — the spec decides a matter §4 leaves open, and states it universally
  with no settlement-date branch (a completeness gap, not a contradiction).
- **Conform text — add after the Timing paragraph (ch09), cross-ref ch11:** "The booking moment is itself a
  declared term of the governing agreement, not a constant of the ledger. Trade-date booking — owned
  re-books at instruction — is the default this specification carries… Where an agreement instead declares
  settlement-date booking, owned re-books only on the recorded settlement-confirmation event: no
  instruction-to-settlement gap opens, so no market claim or mirror can arise inside one, and a
  bought-not-yet-settled position is not deliverable because its owned balance does not yet exist. The ledger
  records whichever event the declared term names; the meaning of the owned coordinate… is fixed by §4 and is
  unchanged by which event writes it."
- **DECISION NEEDED:** conform spec (recommended), or amend §4 to pin trade-date constitutionally.

## D4 — F2 observations-as-transactions  →  RECOMMEND **Option 1 + ratify CLARIFYING amendment to C-4.8**
- **F2 ruling (KLEPPMANN/NAZAROV): Option 1** — observations are moveless admitted transactions through the
  ONE door; the record IS the log; `contract :: Event -> Ledger -> Transaction` unchanged. Option 2 (second
  store) REJECTED: contradicts C-1.4 (one canonical record) + C-5.1/5.4 (one writer) — it is the "second
  store" the architecture exists to abolish; and Theorem 14.4 (certified) already assumes Option 1.
- **D4 is CLARIFYING, not guarantee-narrowing** (unlike D1). Clause replaced (Const C-4.8): "the **record** is
  everything that has been recorded — the log and all it carries, transactions, events, and observations
  alike… the watch reads the Record while the contract and apply consume the Ledger."
  **→ replacement:** "the **record** is everything the log carries. Every datum whose reproduction the
  framework guarantees… enters the record only as a moveless transaction admitted through the one Transaction
  Executor and folded into a home… the *observation-recording transaction*. An event is a trigger — it
  carries timing, not data… No recorded datum is exempt from the one door; the single canonical record of §1
  and the single writer of §5 therefore extend, without exception, to every observation… In the typed picture
  of §3 the contract and apply consume the Ledger unchanged, because the observations a contract reads are
  UnitStatus facts folded into the Ledger; the watch reads the Record."
- **The fork:** choosing Option 2 instead is the strictly LARGER amendment (amend C-1.4 & C-5.1 for a second
  store + writer; change §3 arrows to take Record; re-prove Thm 14.4 over a two-store merge). Ruling
  recommends AGAINST it.
- **Spec-side (conforms to Option 1, ~2.5–3pp, no renumber):** ch03 §3.5 re-state record=log; ch08 recast
  `data Ingest` as untrusted ingestion contract proposing a moveless obs-recording transaction; ch04 Events
  Executor "proposes, never writes"; ch05 ground "previous close" as a UnitStatus/ledger read; ch02
  typed-picture note; ch14 new subsection + restate Thm 14.5 over the record; ch15 prop_replayReconstructsRecord.
- **DECISION NEEDED:** Option 1 + ratify the clarifying C-4.8 amendment (recommended), or Option 2 (larger
  amendment).

---

## Disposition summary (all pending owner ratification)
| Δ | Recommendation | Touches Constitution? |
|---|---|---|
| D1 | AMEND (ratify PARK-4/C-8.7) | yes — ratify |
| D2 | CONFORM spec (strike "ordered") | no |
| D3 | CONFORM spec (booking = declared term) | no |
| D4 | Option 1 + ratify clarifying C-4.8 | yes — ratify (clarifying) |
