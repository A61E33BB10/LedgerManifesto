# The Ledger — Project Memory

## The Ledger Framework Constitution

The file `LedgerManifesto/leddeger_manifesto.tex` (with `.pdf` and `.md` siblings) is the
Ledger Framework Constitution — the authoritative statement of intent, principle, and
minimum requirement for this project. The direction of authority is one-way: the
constitution is rated against nothing; every specification, implementation, test, and
review in this repository is rated against it. Where a genuine improvement requires
departing from it, the constitution is amended explicitly first (see its closing section,
"Authority and Amendment"). Its vocabulary is fixed — unit, wallet, balance, move,
transaction, watch, the immutable log, projection, the Event Monitor, the Events Executor,
the Transaction Executor, smart contract, the market data operator, the three homes,
virtual wallet, virtual ledger — one name per component; no synonyms.

## Purpose

Specify a single internal system of record for post-trade activity, so that the activity
within its scope has one source of truth and internal reconciliation failure cannot arise.
Positions, moves, lifecycle events, and valuations are recorded as one immutable event
stream; every other view — balances, profit and loss, balance sheets, reports — is a
projection of that stream.

## Scope

In scope: the recording, valuation, and lifecycle of trading-book positions held at fair
value, and the interface that projects committed activity into settlement.

Out of scope: price formation, legal agreements, the settlement infrastructure itself,
regulatory submission, and reference-data authority. These are external authorities the
ledger reconciles against at its boundary, not functions it performs.

## Principles

The project is governed by four commitments, in this order.

- **Correctness.** Properties hold by construction; illegal states are not representable.
  A claim is proved, not asserted. Designs are derived from first principles, then shown to
  satisfy the regulation and standards that bind them — never adopted because a standard
  mandates them, and never resting on custom or typical practice.
- **Minimalism.** The fewest primitives that suffice. A design is the minimum basis of its
  problem, not a compromise. Nothing is added that an existing primitive already covers.
- **Simplicity.** A design that ships and can be reasoned about is preferred to one that is
  elegant and cannot. Elegance is real; shippability decides.
- **Clarity.** Each statement is stated once, result first, in deductive order and
  declarative register.

## Method

The specification advances by adversarial review among named specialist agents, converging
on the design that is Pareto-optimal across correctness, testability, and simplicity.

## Writing convention

All specification prose passes through STYLUS (`.claude/agents/stylus.md`), which enforces
the clarity and minimalism above. STYLUS writes; it does not source facts. Subject-matter
agents establish and prove content; STYLUS makes settled content short and ordered, and
flags what is unsettled rather than filling it.

## Not established here

Repository layout, build and run commands, and the implementation language are not fixed by
the specification. The owner supplies them here.
