# DIRAC — Round 10 scorecard

**Target:** `/home/renaud/Ledger/addendum_rewrite/addendum_stateshome_v2.tex`
**Reference checked:** `/home/renaud/Ledger/addendum_rewrite/reference/StatesHome.hs`
**Lens:** Notation minimal and revealing; special-case sprawl unified where one structure
exists, but every unified symbol introduced concretely — never dumped.

**Grade: A (91%)**

I re-read the `.tex` cold and re-walked the spine against the reference, symbol for symbol.
The substance is unchanged from Round 9 (line offsets drift by a handful — `settleHandler`
prose now at 815–818 vs. 809–812 — consistent with minor edits above §13, no structural
change). Nothing in my domain has regressed; every unification holds and every unified symbol
is introduced concretely before use. Correctness is preserved. The residuals are the same
small set, none cryptic, none cuttable without loss. I hold at 91 — neither inflating nor
cutting — and stake my lens on A.

---

## Verified this round (cold, against the reference)

- **One conservation structure, not a branch per instrument.** C2 (254–266) states
  $\sum_w \Delta f(w,u)=0$ once; 2-leg, K-leg, VM fan-out, and the vacuous zero-holder case
  are *instances*, not separate rules. The reference realises it as
  `conserved :: FieldWrite h -> PosDelta` (ref. 271–276) `foldMap`-ed to `mempty` in
  `validate` (ref. 308–314); C9 is literally the empty fold over no wallets, no special case.
  Prose and code coincide. This is the Dirac moment of the document.
- **The conserved fields are a *product*, demonstrated not asserted.** `PosDelta` carries
  `(dAc, dBalance)` (ref. 264–269); conservation is a monoid homomorphism into that product,
  landing at the identity componentwise (`mempty = PosDelta mempty mempty`, ref. 268–269).
  `balance` exists to give the product its second conserved component and C11 a second writer
  (`transfer`) distinct from `ac`'s — a thing `hwm`/`entry_nav` (non-conserved) cannot show.
  Prose is transparent about this pedagogical role (122–127, 203–205) and excludes `balance`
  from the economic inventory by intent.
- **W-sector collapse is concrete, not gestured.** C12 (§4.2) shows the "inherently
  wallet-attached" managed account is $(w,u_{\mathrm{MA}})$-keyed because the mandate is a
  unit, conserving by the standard issuance law (327–331). The would-be fourth map is named,
  typed (`Map[WalletId, WalletState]`, 176–177), and shown empty; the rejected sentinel
  (design C) is the concrete contrast that *breaks* $\sum_w h=0$ (361–366).
- **The two name-axes are enumerated and declared disjoint** (313–316): C11 field-writers
  {settle, trade, transfer, fee\_crystallise, subscribe} vs C2 event classes {Trade,
  SettleVM, CorporateAction, QISRebalance, MandateAmend}. Exactly the name-collision this
  lens exists to catch, pre-empted in prose and matched by the GADT (ref. 197–205).
- **`FieldWrite h` GADT *is* the C11 writer table** (ref. 200–205:
  `WAc`/`WAcTrade`/`WBalance`/`WHwm`/`WEntryNav`, then `SomeWrite` erasing the index,
  ref. 212–213). Type error at authorship, index erased at the stored row (signal S3). The
  prose's `erase = fmap (map SomeWrite)` and
  `settleHandler :: ... -> Map WalletId [FieldWrite 'Settle]` (815–818) match ref. 231–239
  verbatim. The commented `_c11_bad` (ref. 462–463) witnesses the rejected cross-handler
  write; `main` builds `tradeSD`/`closeSD` as `erase . settleHandler` (ref. 539, 562), so the
  authorship→erasure pipeline runs on the live path, not only in an alias.
- **P3 typechecks as a homomorphism.** `replay (xs <> ys) = replay xs >=> replay ys`
  (684–688) is Kleisli composition in `Either LedgerError`, matching `replay = foldM …`
  (ref. 396–397). Checkpoint independence is a consequence of C1(b), not a test.
- **Counts close.** §10 names exactly seven invariants (P1, P3, P5, P6, P7, P9, P10) —
  "seven of the ten." All twelve labels C1–C12 appear in the body and in the §5 index, which
  is itself in clean numerical order; the abstract's "twelve disciplines" matches.

## Residual blemishes (non-blocking — do not deny A)

- **C1–C12 are in index order, not first-appearance order** (212–218): a reader meets C2,
  then C1, C11, C12, C3, … forcing the disclaimer at 213–214. For the target reader the
  "stable tag" justification reads as out-of-order labels with a caveat. The §5 index
  resolves every lookup and the rule is stated once and obeyed. Friction, not crypticness.
- **Prose/reference accessor-name drift.** Prose writes `product_terms(u)` /
  `unit_status(u)` / `position(w,u)`; the reference exports `productTerms` / `unitStatus` /
  `position`. Map names are explicitly bridged (161–164 → `ledgerUS`/`ledgerPS`); accessor
  names are not. snake_case = spec convention, camelCase = Haskell; a competent reader maps
  them on sight. Cosmetic.
- **`balance` is a deliberately demonstrative conserved field** (122–127, 203–205). A
  minimalist may ask whether it is cuttable. It is not cleanly so — it is what makes
  `PosDelta` a product with a second conserved component and gives C11 a conserved field with
  a writer distinct from `ac`'s. The document is explicit about its non-economic role. This
  is a minimalism call other lenses own more than mine.
- **Signals S1–S4 are defined in the reference comment block** (ref. 465–507) and referenced
  parenthetically earlier (216, and at each call site). Announced once at 216 and stated
  inline where invoked; the pointer is parenthetical. Harmless.

## Why A and not higher

The four residuals — index-ordered labels needing a disclaimer, accessor-name drift, the
demonstrative `balance`, the S-signal forward refs — are real but none is cryptic and none
costs correctness. They hold the score at 91 rather than higher. On notation and unification
the document is at target: every unified symbol (the conservation sum, the W-sector collapse,
the `FieldWrite` writer table, the `replay` homomorphism, the `PosDelta` product) is
introduced concretely and corroborated by the reference. I stake my lens on A.
