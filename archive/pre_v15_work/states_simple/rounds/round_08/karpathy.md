# karpathy — Round 8 — States.tex

## Verdict: NOT-YET

The construction (the Haskell) is clean and the listings reproduce `States.hs`
faithfully (`applyMove`, `leg`, `register`, `settle`, `appendVersion`, `netBal`
are line-for-line). Conservation and deterministic-replay arguments land in one
pass: one writer touches `psBal`, it writes cancelling legs of one unit, the base
case is empty, the constructor is sealed — I can follow that top to bottom without
a jump. The 2×2 framing (dependency × correction-discipline) and the three
occupied cells are crisp, and the benchmark-identity-vs-level example pre-empts the
"who authors it?" confusion well.

What stops OBVIOUS is the *emptiness of the fourth cell* and the *foundation the
whole dichotomy stands on*. These are the load-bearing claims of "The Answer," and
each currently demands a re-read or a leap. Residue, located and actionable:

### 1. Internal contradiction inside the empty-cell paragraph (§Why Three, ~line 152)
The sentence "Every (holder, unit) fact is the ledger's own, **folded from its own
move stream** and replay-recoverable" is contradicted by the *same paragraph* three
lines above: "The valuation event writes the high-water mark beside `applyMove`."
The high-water mark is a (holder, unit) fact that is **not** folded from the move
stream — it comes from valuation events. A careful reader hits the counterexample
and backtracks to check whether the empty-cell argument actually covers `psHwm`.
Fix: replace "folded from its own move stream" with "owned by one of the ledger's
own writers (`applyMove` or the valuation event)" / "folded from its own event
stream." This costs nothing and removes the stumble.

### 2. The seal chain hides its key lemma (§Why Three, ~lines 153–156)
"A correctable definition on the (holder, unit) key would version an artifact
received at the boundary **about a holding** — but the holding is a fact `applyMove`
already owns, so the definition would be a second writer." The step that does the
work is unstated: *why must any (holder, unit) definition be "about a holding"?*
That holds only via the lemma "the only (holder, unit) facts that are ledger state
are owned facts (held quantity, or a write-once owned field); external
per-(holder, unit) figures are reconciliation inputs, not state." That lemma is
real and is in the text — but scattered across three later sentences (the custodian
report, the entry-NAV write-once field, the "every economic fact is owned" line).
The reader has to assemble the closure himself before the chain is valid. Fix:
state the lemma once, immediately before the chain, then "version an owned fact →
second writer → seal broken" follows in a single pass.

### 3. The answer rests on an admittedly-unestablished assumption (§The Answer, lines 62–64)
The entire dependency dichotomy — that there are exactly two keys, `unit` and
`(holder, unit)` — depends on "a relationship spanning several instruments is
itself a unit issued to its parties," and the text says outright that this "covers
every multi-instrument relationship is assumed, not established here." The mandate
discharges exactly one case. By my bar this is a leap of faith by the document's
own admission: the correctness of the answer is *conditional* on a premise the
reader is asked to grant. That is acceptable scoping only if the conditionality is
surfaced where the claim is made. Fix: at the answer, state plainly that the
three-home result is conditional on the relationship-as-unit reduction, and either
give the one-line reason the reduction generalizes beyond the mandate, or mark the
result explicitly conditional. As written, a first-time reader either misses the
load-bearing assumption or takes the answer on trust.

## Why these block OBVIOUS, not just polish
1 is a flat contradiction the reader must resolve. 2 forces forward-and-back
assembly of a lemma to validate the central negative claim (the empty cell). 3 is
an unproven premise the answer is built on. Each is single-pass-breaking, and each
sits on the two sentences the whole document exists to deliver: *three homes, and
why no fourth.* Fix the three and I expect this clears the bar — the machinery
underneath is already right.
