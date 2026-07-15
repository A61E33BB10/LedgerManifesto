# Round 9 — chris-lattner — States.tex

## Verdict: NOT-YET

## What is right (so the verdict reads calibrated, not dismissive)

The architecture is sound and I would defend it. The answer is a 2x2 over two
orthogonal questions — *what key does a fact depend on?* and *how is a correction
recorded?* — yielding three forced homes and one empty cell. That is a minimum
basis, not a compromise: each cell is justified by one concrete reason, the empty
cell by the same test that fills the other three. The code is faithful and small:
two maps, a sealed constructor, single-writer-per-fact, `NonEmpty` so a registered
unit is never versionless, `Active Price` so "active without price" is unspellable,
`Qty`'s group structure forcing a move's two legs to cancel. Conservation and
deterministic replay are proved cleanly from `emptyLedger`. Illegal states are not
representable; this is the kind of "by construction" I want. No correctness gap
found (I checked `register`/`settle`/`applyMove` guards, the self-transfer case,
the zero-leg skip, and the `foldM` checkpoint law).

So the *structure* is obvious. The verdict fails on my literal bar — "nothing
present that does not serve the answer" — at the document's core, where the prose
re-states rather than discloses.

## Residue (located, actionable)

### R1 (primary) — The Answer, lines 66-75: the keying conclusion is stated three times

The economic-state paragraph carries exactly two new claims:
(a) "economic" is *defined* as a fact entering conservation, valuation, or P&L;
(b) what stays wallet-keyed (KYC, permissions, audit cursor) enters none of the
three, so it is identity, not economic state. Everything else is the same
conclusion — "only the unit and the (holder, unit) pair carry economic state" —
restated. It appears at the paragraph's open, again mid ("No economic fact is about
a wallet and no unit"), and again at the close (lines 73-75: "both excluded ...
only the unit and the (holder, unit) pair carry economic state"). Lines 73-75 are
present and add nothing the reader did not just receive; the reification they
invoke was already established in lines 55-64.

This lands at the worst possible spot — the central derivation — where a cold
reader most needs to distinguish new information from echo. The restatement makes
the reader re-read to confirm nothing new arrived. That is the opposite of
progressive disclosure.

Action: collapse 66-75 to the two new claims. Roughly: "Economic state — a fact
entering conservation, valuation, or profit and loss — is reckoned per holding, so
every economic fact about a wallet is a (holder, unit) position; what stays
wallet-keyed (KYC, permissions, audit cursor) enters none of the three, so it is
identity, not economic state. With multi-instrument relationships reified as units
(above), the unit and the (holder, unit) pair carry all economic state." One
statement of the conclusion, not three.

### R2 (secondary) — Why Three, lines 148-164: the fourth cell is proved empty twice

The paragraph proves emptiness by the boundary test (no (holder, unit) fact is read
past-dated, so none is a correctable definition), then proves it *again* by the seal
(a definition versioning the held quantity would be a second writer, breaking
conservation), and flags the redundancy in its own words: "A definition there could
not be admitted in any case." Two independent proofs of one negative claim. The
answer needs the cell empty once.

Action: choose the canonical proof. The boundary test is the one that "fills the
other three," so it is the load-bearing argument; demote the seal argument to a
one-clause corroboration or drop it. Do not present two full proofs of the same
emptiness.

## Note (not counted as residue)

The "out of scope here" refrain (amendment event, `psHwm` writer, entry NAV) and
the inert `psHwm` field describe part of the model by its absence. I considered
these as residue and rejected it: the scoping is honest, and `psHwm` earns its
place as the in-code realization of the managed-account high-water mark that
discharges the central assumption (line 167). Leave them. The two items above are
what stand between this and OBVIOUS.
