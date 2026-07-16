# chris-lattner — Round 2 — States.tex

**Verdict: NOT-YET**

The architecture is strong: invariants held by construction (sealed constructors,
`NonEmpty` forbidding the versionless unit, `Price` as a non-group so it cannot sum into a
balance), and each construction piece forced by the one before. Conservation as a property
of the *writer* not the *store type* is exactly right and well argued. But the document
promises two payoffs in its first sentence — "conservation and deterministic replay" — and
the replay path does not close. A competent first-time reader hits a wall.

## Primary residue — registration is a writer but not an event; replay cannot start

- **Location:** `data Event = Moved Move | Settled UnitId Price` (line 279), against
  "Two writers, two disciplines / Registration writes a unit's terms and status together"
  (lines 216–219) and "Settled is an event, so replay rebuilds status with positions:
  every view is a projection of the stream" (lines 295–296).
- **Blocker:** Registration is named as a writer of both terms and status, but there is no
  `Registered` event constructor and no `register` shown. `applyMove` gates on
  `Map.member u (ledgerPT l)` (line 237) and `settle` gates on `Map.member u (ledgerUS l)`
  (line 224). So `replay [...] emptyLedger` returns `Nothing` on the first `Moved` or
  `Settled` — no unit is ever registered through the stream. The reader is left with two
  readings, and the document commits to neither:
  1. Registration *should* be an event — then `Event` is incomplete and the replay claim
     is true only after the type is fixed.
  2. Terms are external reference-data authority (out of scope per the project memory),
     seeded into `l0` before replay — a defensible design, but then status *written at
     registration* is also not in the stream, so "every view is a projection of the
     stream" is false exactly for the registration-written status, and `l0` is a view that
     is not a projection.
  Pick one and state it. As written, the document's central guarantee ("every view is a
  projection of the stream") and its `Event` type contradict each other, and a fresh
  reader cannot tell how a unit enters the ledger under replay.
- **Knock-on:** The conservation induction (lines 257–268) enumerates `applyMove` and
  `settle` and concludes "the sealed constructor leaves no other door." Registration also
  walks through that sealed door (it builds a `Ledger`). The argument needs "register
  writes no `psBal`" stated, not left implicit, or the enumeration of writers is
  incomplete on its face.

## Secondary residue — the second axis silently bundles two independent properties

- **Location:** "Unit-keyed state divides again by discipline: an externally-sourced
  authority, versioned and never rewritten, or an internal value overwritten in place"
  (lines 53–56), and the fourth-cell paragraph (lines 111–122).
- **Blocker:** "Discipline" fuses *source* (external vs internal) and *mutability*
  (versioned/append-only vs overwritten-in-place) into one binary. Presented as one axis it
  is a 2×2 with three cells; treated as independent it is a 2×2×2 with eight. The coupling
  — external ⟹ versioned, internal ⟹ overwritten — is the exact move that forces the count
  to "three," yet it is asserted, never derived. A reader cannot reconstruct why
  "external + overwritten" and "internal + versioned" are not homes. There *is* a unifying
  principle latent in the text ("each home has one writer and one provenance"): provenance
  fuses source and retention, because external facts are kept for audit while internal
  projections live in the event stream. State that principle as the axis. Until then the
  headline "three" is not forced for the reader — it is magic they cannot replicate.

## Minor — undefined load-bearing names

- `emptyLedger` (line 266, the conservation base case) and `zeroP` (line 242, the
  `applyMove` default) carry weight in arguments but are never defined in the document, and
  `Move` / `register` are referenced without definition. "The Haskell is States.hs"
  (line 128) covers code completeness, but `emptyLedger`'s "sum is zero" and `zeroP`'s
  all-zero value are left to inference inside proofs. One line each fixes this. This alone
  would not move the verdict.

The first item is what stakes NOT-YET: the document's own thesis sentence cannot be
demonstrated from the definitions it gives.
