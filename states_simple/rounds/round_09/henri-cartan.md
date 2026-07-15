# henri-cartan — Round 9 — States.tex

## Verdict: NOT-YET

## Lens

Rigour. Does the answer follow from its definitions so directly that the omitted
proof is not missed? A competent engineer, new to the problem, should not have to
supply a load-bearing inference the document leaves unstated.

## What is sound

The construction's two named properties are established essentially completely and
are obvious from the code:

- **Conservation.** A clean induction over events from `emptyLedger`: `applyMove`
  is the sole writer of `psBal`, writing two cancelling legs `negQty q <> q =
  mempty`; `register`/`settle` never touch `ledgerPS`; base case zero. The case
  `from == to` still cancels (second leg reads the first leg's row). Nothing missed.
- **Deterministic replay.** `apply` is pure and total (Maybe-valued, no partial
  match — `Event` is exhausted, `NE.last` total); `replay` folds; checkpointing by
  the foldM split law. Direct.
- **Illegal states unrepresentable.** `Active Price` fuses stage and price;
  `NonEmpty` forbids a versionless registered unit; unexported constructors seal the
  writers. All visible from the listings.

The single architectural assumption — a multi-instrument relationship reifies as a
unit issued to its parties — is *explicitly flagged* as assumed, not established
(lines 62–64). A flagged premise is not a hidden gap; that honesty is correct.

## Residue (located, actionable)

### R1 — The placement test's hinge is decreed, not derived. (root)

**Location:** §The Answer, lines 86–89: "Both are replay-recoverable; what places a
fact is not recoverability but whether a past-dated value is read at the boundary."
Also §Why Three, "Terms", lines 134–146.

**Blocker:** The whole correction-discipline axis of the 2×2 turns on one rule: a
past-dated boundary read forces a *materialized version list* (terms), whereas a
fact whose past values are not read is *overwritten* and any past value *recovered
by replay* (status). The document itself raises the obvious objection — "both are
replay-recoverable" — and then answers it by fiat: the distinction is "whether a
past-dated value is read at the boundary." But it never establishes *why a
past-dated boundary read cannot be served by replay*, exactly as status's past
values are. The missing premise is that boundary reads must be served from
materialized current state (replay being a recovery mechanism, not a query
primitive), so a fact whose past values are demanded at the boundary must keep those
versions co-resident now. Grant that premise and the terms/status split is forced;
omit it and terms could be overwrite-in-place + replay just like status, collapsing
the correction-discipline axis and leaving only "what it depends on." The reader
misses precisely this step because the text flags the question and then steps over
it. State the premise (boundary = served from current state; replay = recovery
only) and the split follows.

### R2 — The fourth cell's emptiness rests on an asserted enumeration. (downstream of R1)

**Location:** §Why Three, "The fourth cell is empty", lines 148–164.

**Blocker:** The general claim "no (holder, unit) fact is read past-dated at the
boundary" (lines 155–156) is supported by enumerating three facts (held quantity,
high-water mark, entry NAV) and asserting that any external per-(holder, unit)
figure is "a reconciliation input, not a fact the ledger adopts as a definition."
The second, seal-based prong does not close the gap in general: it argues only that
a definition *versioning the held quantity* would be a second writer of a fact
`applyMove` already owns. It says nothing about a *novel* (holder, unit) definition
over a fact no current writer owns — such a definition would not collide with any
existing writer, so the seal does not bar it. The emptiness of the fourth cell
therefore rests entirely on the completeness of the enumeration plus the boundary
test of R1, both asserted. Either prove the enumeration exhaustive (every
economically relevant (holder, unit) fact is the ledger's own, derived, current-only)
or strengthen the seal prong to bar *any* (holder, unit) definition, not only one
over an already-owned fact.

## Disposition

The engineering core is right and obviously so. The architectural verdict — three
homes forced — is not yet obvious: its decisive criterion (R1) is announced rather
than derived, and the empty-cell claim that depends on it (R2) leans on an asserted
enumeration. Two short additions — the boundary-versus-replay premise, and either an
exhaustiveness argument or a strengthened seal — would carry the document to
OBVIOUS. As written, the omitted proofs are missed.
