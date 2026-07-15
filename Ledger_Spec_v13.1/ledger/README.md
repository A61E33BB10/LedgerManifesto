# The Ledger — Unified Design Specification

A single internal system of record for post-trade activity: positions, moves, lifecycle
events, and valuations recorded as one immutable event stream, with every other view — balances,
profit and loss, balance sheets, reports — a projection of that stream. The specification is
rigorous (properties hold by construction; claims are proved, not asserted) and is illustrated
throughout in Haskell, with types chosen so that illegal states are unrepresentable.

The document is standalone and self-contained: it carries no version identity in its text or
metadata. The version is recorded here in git (tag `v13.1`).

## Layout

```
ledger_v13_1.tex      master document (\input's drafts/)
drafts/               the 31 section sources (front matter, body, appendices)
ledger_v13_1.pdf      rendered specification (191 pp)
reference/Ledger.hs   the consolidated runnable reference implementation
test/RunProps.hs      the property-suite harness
Makefile              build/test targets for the reference
docs/                 process & review records (not part of the specification)
```

## Build

The document (needs a TeX Live with latexmk):

```
latexmk -pdf ledger_v13_1.tex
```

The reference implementation and its property suite (GHC 9.10; only `base` + `containers`,
no network required):

```
make typecheck   # type-check reference/Ledger.hs, -Wall -Werror
make props       # build and run the property suite (test/RunProps.hs)
```

`make props` runs the full catalogue over deterministic seeds — the conservation, replay,
state-basis, and locate properties (P24, P25, P-DET…P-PARTITION, P26 and its companions, F8) —
16 properties × 1000 cases, all green.

## The reference is a witness, not a sketch

Every Haskell listing in the document is either **verbatim** (byte-for-byte from
`reference/Ledger.hs`) or **illustrative** (marked as such). The reference type-checks
`-Wall -Werror` clean and the property suite passes, so the "listings as theorems" claim is
mechanically backed.
