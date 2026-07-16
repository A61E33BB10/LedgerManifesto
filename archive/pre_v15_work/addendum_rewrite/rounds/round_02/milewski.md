# Round 2 Scorecard — MILEWSKI

**Artifacts:** `addendum_rewrite/addendum_stateshome_v2.tex`, `addendum_rewrite/reference/StatesHome.hs`
**Lens:** Expressibility — does each concept map cleanly to Haskell? An awkward type or claim is a signal about the prose, notation, or design, not only the code.

## Grade: B (88%)

Round 1's four blocking issues are substantially resolved, and the resolutions are the
right ones, not cosmetic:

- **B1 (amend over-claim) — fixed.** §4.4 now states the holder move is "a *separate*
  paired-issuance event, not part of the amendment ... a burn on u_old and a mint on u_new,
  each conserving on its own unit," and cites S1. The prose now matches what `amend`
  actually does. Correct.
- **B2 (C11 over-claim) — resolved via the acceptable path.** The tex took the round-1
  downgrade option (ii): C11 is now "a type error at the writer's authorship site; the tag
  is erased once writes share one delta row, so the guarantee binds at authorship, not at
  the stored row (S3)," and §9's preamble explicitly defines "unrepresentable" per-mechanism
  ("a per-field tag is a type error at authorship, then erased at the stored row (P10)") and
  disclaims that every guarantee is a type fact. The prose now matches the encoding. The
  stronger fix (i) — a real `settleHandler :: ... -> Map WalletId (FieldWrite 'Settle)`
  routed through `main` — was not taken, so the GADT's purchase is still only *asserted* in
  S3, not *exercised* in the runnable path. Acceptable, but see B6.
- **B3 (handler vocabulary divergence) — fixed.** C11 now states outright that the
  field-writers (settle, trade, transfer, fee_crystallise, subscribe) "are a different axis
  from the event classes of C2 (Trade, SettleVM, CorporateAction, QISRebalance,
  MandateAmend) ... the two name-sets are not meant to coincide." Exactly the missing
  sentence.
- **B4 (psBalance/Transfer ungrounded) — only partially fixed.** See B5 below.

The load-bearing structures remain clean and faithful, and round 2 did not regress them:
three maps, abstract `Ledger` with no row deleter, `ValidDelta` abstract with `validate` the
sole constructor, conservation as `foldMap ... conserved` into the `PosDelta` monoid with
the vacuous C9 base case falling out of the empty fold, `NonEmpty` making "registered but
versionless" untypable, the `Maybe` accessor distinguishing never-held from held-and-flat,
replay as a Kleisli fold, exact `Integer` minor units. That is the heart of my lens and it
is sound.

It is not an A because two defects in my own domain survive: a field (`balance`) whose
relationship to the framework holding `h(w,u)` a one-pass reader cannot pin down, and a
categorical mislabel where the document's cleanest law is named wrongly.

---

## Blocking issues

### B5 — `balance` is anchored in notation but not reconciled with `h(w,u)`, and is absent from the canonical §3 inventory
**Location:** tex notation table (line 123, "accumulated_cost and balance"), C11 (line 300, `balance→transfer`); §3 home-of-each-datum table PositionState row (lines 193–196) — `balance` not listed; notation `h(w,u)` (lines 105–107); .hs `psBalance` (line 167), `WBalance`/`Transfer` (lines 193, 199).

Round 1 B4 asked for one of three fixes: name `psBalance` as `h(w,u)`, add it to the §3
table, or remove it. The chosen fix added it to the *notation* conserved-field definition
only — so its mutation discipline (conserved, transfer-written) is now stated, which is real
progress. But its **meaning** is still unpinned, and two frictions a careful one-pass reader
hits remain:

1. The notation defines `h(w,u)` as "the signed quantity of unit u held in wallet w" with
   conservation `Σ_w h(w,u)=0`. `balance` is then defined as "a PositionState field that
   nets to zero across wallets ... moved by a transfer" — i.e. a conserved, signed,
   transferable quantity. These descriptions are nearly identical. Is `balance` the holding
   `h(w,u)`, a separate cash balance, or a demonstrative second conserved field? The reader
   cannot tell, and `balance` is a loaded word that invites the wrong guess.
2. The §3 "Home of each datum" table is the canonical PositionState inventory
   (accumulated_cost, ccp_binding, entry_nav, hwm, fees, benchmark_nav, breach_flags). It
   does **not** list `balance`. So the reference's `PositionState` carries a conserved field
   the spec's own inventory omits — the exact top-down faithfulness gap B4 named, now
   narrowed but not closed.

**Fix (pick one, per round 1):** (a) if `balance` is the framework holding, say so in the
notation row and in the .hs comment, and align the §3 table; (b) if it is a distinct field
(e.g. a cash balance), give it a one-line gloss in §3 and add it to the table; (c) if it
exists only to demonstrate multi-field conservation (PosDelta carrying both `dAc` and
`dBalance`), say *that* in the .hs comment ("a second conserved field, included to show the
homomorphism handles a product of conserved fields") and add a half-line to §3. Any of the
three closes it; the present half-anchor does not.

### B6 — replay's law is mislabelled "(anti)homomorphism"; it is a homomorphism
**Location:** .hs `replay` comment (line 369, "the Kleisli (anti)homomorphism law").

This is the document's cleanest categorical claim, and the name is wrong in my domain. The
law as written, `replay (xs <> ys) = replay xs >=> replay ys`, is order-*preserving*: lists
under `++` map to Kleisli arrows under `>=>` with order intact, and `replay []` maps to
`return`. That is a monoid homomorphism. An *anti*homomorphism would reverse the order
(`replay ys >=> replay xs`), which is not what holds. The parenthetical "(anti)" introduces
doubt where the structure is exactly clean, and a reader who knows the difference will read
it as hedging a law the author did not actually verify. (The tex §10 P3, line 676, states
the law without the hedge — correct there; only the .hs comment is wrong.)
**Fix:** delete "(anti)". Call it the Kleisli monoid homomorphism. One word.

---

## Non-blocking (noted, not gating)

- **Migration alias naming/notation (tex line 604–605).** `get_unit_state(u)` is glossed as
  "a deprecated alias for `product_terms(u) ++ unit_status(u)`" — but `++` between a
  `ProductTerms` and a `UnitStatus` does not typecheck; they are different record types. It
  reads as informal "the pair of the two," which is fine as intent but type-incorrect as
  notation. And line 605 names the per-position accessor `position_state(w,u)` while the
  reference exports `position` and the rest of the tex (lines 278, 455) says `position(w,u)`.
  Pick one name; replace `++` with "the pair" or a tuple.
- **§7 still silent on C4 (carryover from round 1).** §7's "the encoding carries the
  conditions structurally" enumerates C1, C2/C9, C6/C7, C11, C3/C10, C8 and omits C4 (and
  C12). The omission is explained elsewhere (S2 in the .hs; §10 P9), so it is covered overall
  — but §7 itself should say in one clause that C4 is not a data shape and lives in the
  capability layer (S2). This is the correct expressibility call; only the silence persists.
- **C11 GADT earns its keep only by assertion.** Round 1's stronger fix (i) — define one real
  handler typed by its output and route `main`'s deltas through it — was not taken; `main`
  still builds `SomeWrite (WAc ...)` directly, bypassing the authorship check, and the GADT's
  payoff is shown only by the trivial `_c11_ok_*` aliases and the commented `_c11_bad`. S3
  defends stopping at the authorship-site guarantee under the restraint rule, and the prose is
  now honest about it, so this is not blocking. But the DataKinds/GADT apparatus is the one
  structure in the file whose concrete purchase is described rather than demonstrated; fix (i)
  would have made it an unambiguous win. Recorded as the weakest mapping, not a defect.

---

## What is right (so revision does not regress it)

- All four round-1 blocking issues addressed; B1/B2/B3 fully and correctly, B4 partially (B5).
- Conservation as a monoid homomorphism into `PosDelta`, vacuous C9 from the empty `foldMap`,
  abstract `Ledger`/`ValidDelta`/`ProductTerms` with the purchase named, `NonEmpty`,
  `Maybe`-accessor, registration guard keeping PT⇔US by construction, exact `Integer`. Keep.
- The honest downgrade of C11/P10 and the per-mechanism definition of "unrepresentable" in
  §9's preamble — this is the restraint rule applied correctly to the prose. Keep.
