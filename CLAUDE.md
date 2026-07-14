# The Ledger — Project Memory

This file is the standing brief for every agent working in this repository. It is read
before any other instruction and it overrides any habit, convention, or preference an agent
brings with it. Where a task prompt and this file conflict, this file wins; where this file
and the Constitution conflict, the Constitution wins.

---

## 1. The Constitution is non-negotiable

`LedgerManifesto/ledger_manifesto.tex` (with its `.pdf` and `.md` siblings) is the Ledger
Framework Constitution — the authoritative statement of intent, principle, and minimum
requirement for this project.

**The direction of authority is one-way.** The Constitution is rated against nothing. Every
specification, implementation, test, and review in this repository is rated against it.

Three rules follow, and none of them bends:

- **No agent may edit the Constitution.** Not to fix a typo, not to resolve a conflict, not
  to make a chapter come out clean. Amendment is the owner's alone.
- **No agent may draft around it.** A design that quietly narrows a constitutional guarantee
  and then relabels the residue so the guarantee still reads as true is a *worse* failure
  than an open conflict, because it hides. If you find yourself writing "…which is not
  really a deposit / not really a rewrite / not really a second store," stop: you are
  narrowing.
- **A genuine conflict is parked, never fudged.** It goes into the open-problems index with
  the **exact proposed amendment text** and the **exact clause it replaces**, and the work
  continues around it. Parking is not failure. Parking is the mechanism working. **An empty
  parking index across a long specification is not a sign of health — it is a sign the
  mechanism has never been exercised.**

The Constitution's vocabulary is fixed — unit, wallet, balance, move, transaction, watch,
the immutable log, projection, the Event Monitor, the Events Executor, the Transaction
Executor, smart contract, the market data operator, the three homes, virtual wallet, virtual
ledger. One name per component. No synonyms, ever, in any document.

---

## 2. Purpose

Specify a single internal system of record for post-trade activity, so that the activity
within its scope has one source of truth and internal reconciliation failure cannot arise.

Positions, moves, lifecycle events, and valuations are recorded as one immutable stream of
admitted transactions. Every other view — balances, profit and loss, balance sheets, reports
— is a projection of that stream.

**In scope:** the recording, valuation, and lifecycle of trading-book positions held at fair
value, and the interface that projects committed activity into settlement.

**Out of scope:** price formation, legal enforceability, the settlement infrastructure
itself, regulatory submission, and reference-data authority. These are external authorities
the ledger reconciles against at its boundary — never functions it performs.

---

## 3. Correctness is the point, and correctness means *checked*

Correctness outranks every other value in this project, including elegance, including
brevity, including the deadline.

- **Properties hold by construction.** Illegal states are not checked for; they are not
  representable. A check can be forgotten or bypassed. A type cannot.
- **A claim is proved, not asserted.** "Clearly," "obviously," "it follows that" are not
  proofs; they are the places defects hide. If a step cannot be justified, it is not yet
  understood, and it is marked unsettled rather than dressed up.
- **Every statement and every calculation is independently verified.** The agent who wrote a
  claim does not certify it. A second, named agent re-derives it and signs. **This is not a
  courtesy review — it is a gate, and it carries a veto.** No number, no invariant, no proof
  ships without a signature from an agent who did not write it.
- **Every guarantee is executable.** An invariant defended only in prose is not an invariant.
  It goes into the property-test regime, over generated products, events, and histories — and
  it must be shown to *fire*. A property whose precondition is never generated passes without
  witnessing anything. **Zero firings is a defect, not a green test.**
- **Designs are derived from first principles**, then shown to satisfy the regulation and
  standards that bind them. Never adopted because a standard mandates them. Never resting on
  custom or typical practice.

---

## 4. Category theory is not the point

Every conclusion in this project is reached, stated, and proved **without** category-theoretic
language. Category theory may then be used, afterwards, as a *second telling* — a short,
marked box that restates a result already established, for a reader who wants the residual
ambiguity removed.

The rules:

- **Nothing is ever introduced categorically first.** Plain terms and a concrete example
  come first, always.
- **No proof may depend on a box.** Delete every categorical box in a document and it must
  remain complete, and every proof must remain intact. If that is not true, the box was
  load-bearing and the document is wrong.
- **Boxes are rare.** If you are reaching for a functor to explain something, you have not
  yet explained it. Write the explanation. Then decide whether the box adds anything.

This is a specification of a financial system of record. It is not a paper about categories.
An agent who cannot state a result without a commutative diagram has not finished thinking.

---

## 5. Haskell is illustration, never specification

Code in these documents appears only as **short typed signatures and data declarations**, to
make concrete something the prose has already said.

- The code **illustrates**; the prose **specifies**. Where they appear to disagree, the prose
  governs and the code is wrong.
- The reference implementation lives **outside** the specification entirely. The language it
  is written in is not fixed by the specification and must not be assumed by it.
- A signature is there so a reader can see the shape of a thing at a glance. If a block of
  code is doing explanatory work the prose should be doing, cut the code and write the prose.
- The same rule governs pseudocode, TLA⁺, and any other formalism: **say which it is**, and
  either machine-check it and name the tool, or label it honestly as illustration. A
  half-formalism is worse than either.

---

## 6. Language: short, clear, and readable by a good undergraduate

**The target reader is a strong final-year undergraduate in mathematics or computer science
with no prior exposure to this project.** Every sentence must be easy for that reader. If it
is not, the sentence is wrong — not the reader.

- **Short sentences beat long ones.** Result first, then the reason.
- **No pedantic language. No obscure jargon.** A precise ordinary word always beats an
  impressive rare one. Precision is kept; ornament is cut.
- **Concrete before abstract, always.** The example comes first; the generalisation earns its
  place afterwards, or does not appear.
- **No abstraction unless it is used twice, or it makes a statement checkable.** One-use
  abstractions are ornament.
- **State each thing once**, in deductive order, in a declarative register. A fact fixed in
  one place is *referred to* elsewhere, never re-established. Repetition is a defect, not
  emphasis.
- **Use "data," not "datum."** "Data" is the mass noun throughout: *the data crosses the
  boundary as a recorded observation*; *the data-kind registry*; *a data kind is registered
  before it crosses*. The singular "datum" and the plural "data are" do not appear anywhere
  in this project's documents, in prose, in type names, or in identifiers.

---

## 7. Design values, in priority order

When two of these conflict, the earlier wins.

1. **Correctness.** Proved, checked by an independent agent, and executable.
2. **Minimalism.** The fewest primitives that suffice. A design is the minimum basis of its
   problem, not a compromise. Nothing is added that an existing primitive already covers.
3. **Simplicity.** A design that ships and can be reasoned about beats one that is elegant
   and cannot. Elegance is real; shippability decides.
4. **Clarity.** Stated once, result first, in a register the target reader can follow.

---

## 8. Method

The specification advances by **adversarial review among named specialist agents**, converging
on the design that is Pareto-optimal across correctness, testability, and simplicity.

- **Authors draft. Adversaries critique. Certifiers sign.** The three roles are separate, and
  **no agent certifies work it authored.**
- **A critique without a counterexample or a named missing case is not a critique** and is
  discarded before voting.
- **A certifier's veto reopens the work.** Convergence among the authors is necessary and not
  sufficient; the work is done when the certifiers sign, not when the authors agree.
- **Escalation to the owner is not a move available mid-run.** Anything that would escalate is
  parked, with exact text, and the work continues.
- **Surgical addition.** No reformatting, no scope creep, no backward references to superseded
  versions. Change what the task requires and nothing else.

---

## 9. Writing convention

All specification prose passes through **STYLUS** (`.claude/agents/stylus.md`), which enforces
§6 above.

STYLUS **writes; it does not source facts.** Subject-matter agents establish and prove content;
STYLUS makes settled content short and ordered, and **flags what is unsettled rather than
filling it.** A gap that STYLUS papers over is a defect worse than the gap.

---

## 10. Not established here

Repository layout, build and run commands, and the implementation language are not fixed by
the specification. The owner supplies them.