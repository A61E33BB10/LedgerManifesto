# DIRAC — Round 1 scorecard

**Target:** `/home/renaud/Ledger/addendum_rewrite/addendum_stateshome_v2.tex`
**Lens:** Notation minimal and revealing; special-case sprawl unified where one structure
exists, but every unified symbol introduced concretely — never dumped.

**Grade: B (85%)**

---

## What is beautiful here (and should survive every later round)

The spine of the document is one unification done right:

- **One conservation law subsumes every event class.** `C2` states
  $\sum_{w}\Delta f(w,u)=0$ once, then discharges 2-leg, $K$-leg, VM fan-out, and the
  vacuous zero-holder case as instances of the *same* identity. The Haskell carries this as
  a monoid homomorphism into `PosDelta` landing at `mempty`, so the empty fold (C9) falls
  out for free with no special case. This is the document's Dirac moment: no branch per
  instrument, the special cases fall out of the general law.
- **The $W$-sector collapse (C12)** is the second unification: the "inherently
  wallet-attached" managed-account state is shown to be $(w,u_{\mathrm{MA}})$-keyed because
  *the mandate is a unit*, conserving by the standard issuance law. The would-be fourth map
  is named, typed (`Map[WalletId, WalletState]`), and then shown empty. The rejected
  sentinel (design C) is explicitly contrasted as the thing that *breaks* $\sum_w h=0$.
  The opposite is introduced concretely, not asserted.
- **Notation table (§2)** earns its place: every symbol used later is fixed there, with the
  worked-example symbols ($u_{\mathrm{MA}}, u_{\mathrm{QIS}}, u_{\mathrm{ES}}, 0_P, \Delta
  f$) introduced concretely before use.
- The reference's `FieldWrite h` GADT *is* the C11 writer table — a write by the wrong
  handler is literally a type error. Minimal and revealing.

Most of the document passes in one careful read. The grade is held below A by two localized
notational defects in my exact domain plus two minor blemishes.

---

## Blocking issues

### B1 — The P3 "fold identity" is ill-typed as written (lines 630–631)

> `apply_all(events[:k]) ++ events[k:] ≡ apply_all(events)`

The left side puts a **ledger** (`apply_all` of a prefix) on the left of `++` and an
**event list** on the right. `++` cannot join a ledger to events; the equation does not
typecheck, so it obscures the very structure it claims to reveal. The correct statement
already exists in the reference (`StatesHome.hs`, line 369–371):

> `replay (xs <> ys) = replay xs >=> replay ys`   (Kleisli composition in `Either LedgerError`)

A Dirac reviewer cannot pass an equation that does not parse. Replace the prose form with
the Kleisli/fold-composition law (or `apply_all(events[k:]) ∘ apply_all(events[:k]) =
apply_all(events)` in state-transformer form), matching the reference. The point — that
checkpoint placement is irrelevant *because* of an associativity/homomorphism law, not a
test — is correct and worth stating in a form that holds.

### B2 — "conserved field" is load-bearing but its extension is never given in prose

The partition of `PositionState` fields into **conserved** (`ac`, `balance`) and
**non-conserved** (`hwm`, `entry_nav`) is what `C2` ($\sum\Delta f=0$ binds only conserved
fields), `0_P` ("all conserved fields zero", line 123), and `C1(a)` ($\mathrm{Some}(0_P)$ =
held-and-flat) all rest on. The prose uses "conserved field" repeatedly but **never
enumerates which fields are conserved** — only the Haskell reference (lines 156–162,
`conserved`) carries the partition. A prose-only reader cannot tell whether `hwm` is bound
by $\sum\Delta f=0$. The unified term is introduced; its concrete extension is dumped to the
appendix. Add one line at the first use (§4.1, near line 224 or the `0_P` row of the
notation table) naming the conserved fields explicitly, e.g. "conserved fields are `ac` and
`balance`; `hwm` and `entry_nav` are non-conserved (monotone / write-once)."

This also sharpens a latent imprecision: line 123 correctly qualifies "both are $0_P$ *in
their conserved fields*", but `C1(a)` (line 265) drops the qualifier and equates
$\mathrm{Some}(0_P)$ with "held once, now flat" — yet a flat row that crystallised a fee
has `hwm`$\neq 0$ and so is not literally $0_P$. Enumerating the partition lets `C1(a)`
inherit the qualifier instead of overstating.

### B3 — Sector name collides with value-type name in the listing (lines 146–148)

```
UnitStatus    : Map[UnitId, UnitStatus]
PositionState : Map[(WalletId, UnitId), PositionState]
```

The same symbol (`UnitStatus`, `PositionState`) denotes both the sector/map and the
per-key value type — the one place in the document where one symbol carries two meanings.
The reference disambiguates cleanly (`ledgerUS :: Map UnitId UnitStatus`). Recoverable by
position, so minor, but it is exactly the same-symbol-two-meanings pattern the lens flags;
rename the value type in the listing (e.g. `Map[UnitId, StatusRow]`) or annotate that the
sector and its row share a name by design.

### B4 — "sheaf" is dropped as a label, not introduced (line 587)

Design E is "a sheaf over the held set $\{(w,u): \texttt{position}(w,u)=\mathrm{Some}\}$".
"Sheaf" is invoked without concretization for the target reader. It is harmless because E
is rejected for shippability regardless, but by the lens a unified term should be
introduced or not used; either gloss it in three words or drop the word and keep only the
forcing reason ("no implementation in available tooling").

---

## Why B and not A

B1 is a genuine notational failure in my domain — an equation that does not typecheck,
standing where the reference already has the correct law. B2 is friction that forces a
prose reader into the appendix to recover a partition the prose depends on. Neither is
cryptic enough, nor are B3/B4 severe enough, to push below B: the core unifications are
excellent and every other symbol is introduced concretely. Fix B1 and B2 and this is an A
on my lens.

## Why not below B

The central structure is sound and elegant; correctness is preserved; nothing in the spine
is cryptic on a careful pass. The defects are localized to two equations/terms and two
cosmetic name choices, all actionable in a single revision.
