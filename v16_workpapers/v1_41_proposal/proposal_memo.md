# v1.41 Clarifying Proposal — Cover Memo to the Owner

The constitution in force, `ledger_manifesto_v1_4.tex`, is untouched. A new file,
`ledger_manifesto_v1_41.tex`, carries a clarifying revision of the time envelope in C-2.7 and
C-12.6 and awaits the owner's ratification. Only the time-envelope language changes. No
normative commitment is added, removed, or altered. The covered-call example (C-2.7) and every
other clause are byte-identical to v1.4. The file compiles clean (pdflatex ×2, 0 errors, 15
pages).

The twelve clarifying items from the precision review are all discharged. Nine are carried by
revised text; three are already carried by text v1.4 keeps, and adding a second statement would
either repeat an existing clause or edit the preserve-intact covered call. Each is recorded
below. The five material items are excluded and listed in Part 2, each with the question the
owner alone can settle.

---

## Part 1 — The changes, before and after

### Change 1 — the naming triad and execution time's authority (C-2.7)

*Register shapes D1, D2; enables the C1/C2 reading.*

**Before.**
> An event bears three times: the **execution time** at which it happened in the world --- the
> time that would be enforced in court, asserted by its source, contestable only in the world
> and corrected only by a later event, never edited at the door; the **monitor time** at which
> the Event Monitor observed it at the boundary; and the **door time** at which the single
> writer admitted it through the one door.

**After.**
> An event bears three times: the **execution time** at which it happened in the world; the
> **monitor time** at which the Event Monitor observed it at the boundary; and the **door
> time** at which the single writer admitted it through the one door. Execution time is the
> time that would be enforced in court --- asserted by its source, contestable only in the
> world, corrected only by a later event, never edited at the door.

*Clarifying, not material.* The naming triad now names the three coordinates with equal, short
locating clauses; execution time's five qualifications move, verbatim, into the following
sentence, where the paragraph already turns to execution order. Every qualification survives;
one word of joinery ("and" between *contestable* and *corrected*) becomes a comma so the four
beat evenly. No claim changes.

### Change 2 — the fold order and the order of arrival (C-2.7)

*Register shape D3; items C3, C4.*

**Before.**
> Events are processed as they arrive at the door; meaning lives in execution order, so the
> fold's order is execution order --- a late arrival whose execution time precedes events
> already folded takes its place among them, and everything after it is refolded.

**After.**
> Events are processed as they arrive at the door; meaning lives in execution order, so the
> fold's order is execution order. A late arrival takes its place among the events already
> folded whenever its execution time precedes theirs, and everything after it is refolded. This
> honours the execution order the events always had, and leaves the order of their arrival at
> the door untouched.

*Clarifying, not material (C4).* The principle (the fold's order is execution order) and the
mechanism (a late arrival inserts, the tail refolds) become separate sentences, and the two
orders v1.4 already carries over one record — the order events arrive at the door, and the
execution order the fold obeys — are named as distinct.

*Clarifying, not material (C3).* The last sentence states the scope of the refusal already in
C-2.7 ("the refusal to reorder anything unless harmlessness is proved," unchanged). A refold
honours the execution order the events always had; it does not touch the order of their
arrival. Re-sequencing the fold to an order the events always possessed is not the reorder the
refusal forbids. Internal consistency forces this reading; no rule is added.

### Change 3 — the total order, the hash tiebreak, and totality's premise (C-2.7)

*Register shape D4; items C5, C6(a).*

**Before.**
> The log's total order is decided by execution time, then door time, then the event's hash ---
> deterministic, total, and computable by any party from the record alone, resting only on the
> time the world would enforce and the time the door assigns.

**After.**
> The log's total order is decided by execution time, then door time, then the event's hash ---
> deterministic, total, and computable by any party from the record alone. The time the world
> would enforce and the time the door assigns decide the order; the event's hash settles only
> the tie those two can leave, and changes no order they fix. Its totality rests on no two
> distinct events sharing a hash.

*Clarifying, not material (C5).* The three-key rule ("execution time, then door time, then the
event's hash") is unchanged. The old tail said the order rests "only on" two of the three keys,
appearing to contradict it. The revision separates the property claim from the key
characterization and states what the tail meant: execution and door decide the order; the hash
settles only a residual tie and never overrides what those two fix. The paired-key phrase is
kept verbatim.

*Clarifying, not material (C6(a)).* "Its totality rests on no two distinct events sharing a
hash" names a premise the word *total* already presupposes: a level-three tiebreak orders
totally only where its values are distinct. It is stated as a premise the totality rests on,
not as a guarantee the system makes. **Owner's confirmation invited.** The precision review
rated this clarifying and separated it from the material question of door-time uniqueness (M3);
the boundary is that no hash algorithm is named and no uniqueness is imposed on the writer.

### Change 4 — monitor time's absence and its effect on lateness (C-2.7)

*Items C1, C2, C8.*

**Before.**
> The monitor's clock orders nothing: it is provenance, recorded so that an event's lateness
> splits into the world's delay, execution to monitor, and ours, monitor to door.

**After.**
> The monitor's clock orders nothing: it is provenance, recorded so that an event's lateness
> splits into the world's delay, execution to monitor, and ours, monitor to door. An event the
> Event Monitor emits rather than observes at the boundary bears no monitor time; its world's
> segment is zero and its lateness is wholly ours.

*Clarifying, not material (C1, C2).* v1.4 already distinguishes events that arrive from events
the Monitor emits (C-5.4, "arrived or emitted"; C-3.7, C-5.2, the Monitor emits events onto the
record). Monitor time is the record of a boundary observation. An emitted event has no boundary
observation, so it bears no monitor time. This states plainly what "the monitor time at which
the Event Monitor observed it at the boundary" already means, and corrects the reading that
every event carries all three times. The count "three times" is kept, not softened to "up to
three," precisely so the door slot's universality is left exactly as v1.4 states it (that is the
excluded question M1).

*Clarifying, not material (C8).* The two-segment split presumes a monitor time between
execution and door. For an emitted event there is none, so the world's segment is zero and the
whole lateness is ours. This follows from C1 and the split already stated; nothing new.

### Change 5 — "the head" defined (C-12.6)

*Item C11.*

**Before.**
> A late arrival that takes its place before the head is never silent.

**After.**
> A late arrival that takes its place before the head --- the latest event in the fold's order,
> the frontier the fold has reached --- is never silent.

*Clarifying, not material.* "The head" was used without definition. It is the frontier of the
fold's order — the same object C-2.7 describes when a late arrival's execution time "precedes
events already folded." Definition before use; no new content.

### Change 6 — the lateness split as a decomposition, not a choice (C-12.6)

*Register shape D5; item C7.*

**Before.**
> ... and to the segment of its lateness: the world's, from execution to monitor, or ours, from
> monitor to the door.

**After.**
> ... and to the segment of its lateness. That lateness splits into the world's, from execution
> to monitor, and ours, from monitor to the door.

*Clarifying, not material.* C-2.7 decomposes an event's lateness into both segments — the
world's *and* ours. C-12.6 read "or," inviting the reading that the explain attributes the
lateness to one segment. The connective is harmonised to "and," and the split is given its own
sentence rather than nested inside the attribution triad. The split now matches C-2.7's
canonical wording. The attribution is a decomposition across both segments, as C-2.7 and the
covered call already require. No normative change.

### Items already carried by unchanged text — no new statement added

- **C6(b) — "the record alone" includes derived events.** Already fixed by C-3.7: "The event
  the Monitor emits is recorded, so everything downstream of it is a function of the record
  alone ... anyone can recompute which events should have been emitted." Restating it in C-2.7
  would duplicate C-3.7 and break the one-statement-one-place rule. No text added.
- **C9 — "corrected only by a later event" means later-arriving.** The signature phrase is
  preserved verbatim (never reworded). The axis is pinned by the newly-explicit distinction
  between the order of arrival and execution order (Change 2) and by the covered call, where the
  Tuesday assignment arrives Thursday and corrects the Wednesday book while asserting an earlier
  execution time. No text added.
- **C10 — a fact-correction and a money-compensation are distinct.** Stated by the preserved
  signature "Views recompute automatically; money never does" (C-12.4, C-12.6) and by the clause
  separation: a wrong execution time is corrected by a later forward event (C-2.7); a settled
  money delta moves only as an authorised compensating transaction under C-12.4 (C-12.6). No
  text added.
- **C12 — "moves back" in the covered call is a new compensating transaction, not a clawback.**
  Carried by C-12.4's preserved governing pair "repaired forward, never edited" and C-12.6's
  "compensating transaction." The covered call is preserve-intact and is not edited. No text
  added.

### Metadata

Header comment gains a v1.41 block (drafted 2026-07-20, ratification pending — owner's date).
Title line reads Version 1.41, 20 July 2026. A new amendment-record entry is added after v1.4's,
which stays untouched. Its one-sentence-per-theme summary closes with: "No normative commitment
is added, removed, or altered."

---

## Part 2 — Material items, excluded from v1.41 (for the owner)

Each of the five is a real question the constitution leaves open. A clarifying sentence states
what the text already unambiguously means; none of these is unambiguous, so none can be settled
by v1.41. They are recorded here, not drafted around.

**M1 — the door slot of an event that never crosses the door.**
An event the fold derives during a refold (a synthesised firing) never separately crosses the
door, yet must sit in the total order at its execution instant — an equal-execution-time tie
that needs the door tiebreak. *The owner's question:* what door value does such an event carry,
and how are several within one instant ordered? Deciding it fixes the fold order of derived
firings, hence economic outcomes. That is a new normative commitment, not a clarification. v1.41
may say only that emitted and derived events participate in the same order; it does not, and the
constitution does not, assign them a door slot.

**M2 — the door tiebreak versus the refusal, at equal execution time.**
Two simultaneous non-commuting events with distinct door times: read one way, the total order
decides them by door time (by admission latency); read the other, the refusal declines to order
what is not provably harmless and fails closed. *The owner's question:* which governs? Both are
constitutionally coherent. Choosing "order by door" lets arrival latency fabricate a world fact;
choosing "refuse" narrows the plain word *total*. Either choice adds a commitment. A clarifying
sentence cannot settle it; that is why Change 3 asserts totality over the admitted stream and
goes no further.

**M3 — door-time uniqueness.**
The tiebreak's determinism leans on door times being distinct within a lineage. *The owner's
question:* is door time a strictly unique sequence index, or a timestamp that may repeat (with
the hash as backstop)? Asserting strict uniqueness constrains the single writer — a commitment
the constitution does not need and does not make. v1.41 may say door time is assigned in
admission order; the distinct-per-lineage claim is left to the specification.

**M4 — is correcting an execution time itself an authorised act?**
C-2.7 says a wrong execution time is "corrected only by a later event." C-12.6 gates settled
money on authorised compensation under C-12.4. *The owner's question:* is a fact-correction
itself gated (counterparty agreement, human authorisation), or does it flow as an ordinary
forward event? Answering either way adds or affirms an authorisation requirement — normative.
The clarifying part (that the two are distinct operations) is C10, done.

**M5 — is the lateness split exhaustive?**
The split covers execution to door in two segments. A quarantined late arrival sits between the
door and the fold before it is routed — a span the two segments do not name. *The owner's
question:* should the explain carry a third, door-to-fold, segment? That is a new attribution.
Stating that the two segments are exhaustive of execution-to-door is clarifying; adding a third
segment is material and excluded.

---

## Part 3 — Status

`ledger_manifesto_v1_4.tex` is untouched and remains the constitution in force.
`ledger_manifesto_v1_41.tex` is a clarifying proposal that awaits the owner's ratification and
ratification date. Until ratified it carries no authority.
