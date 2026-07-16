# Round 12 — milewski review of states_simple/States.{tex,hs}

**Verdict: OBVIOUS.**

Lens: representation + the Hutton bar (each step obvious from the last; no
abstraction before it is earned). Reader = a competent engineer who has never
seen this problem. No GHC in env — type-correctness and totality verified by
reading.

## What R12 changed (delta from R11, which I cleared)

R12 is a **comment-only scrub of the `.hs`** plus the `.tex` prose it mirrors;
no type, signature, or function body changed. Three things were removed/reground,
all of which *tighten* the Hutton bar rather than relax it:

1. **Two path (rejected-design) narrations removed.** Step 5 no longer narrates
   "an earlier shape kept them apart — a stage and a separate `Maybe Price`"; it
   states positively that the price rides on `Active`, so active-but-unpriced and
   listed-but-priced are unspellable (States.hs:274-279). Step 8 no longer narrates
   "we could keep two maps and *promise*…"; it states positively that terms and
   status are both unit-keyed so they ride as one pair-valued map (States.hs:407-419).
   Grep for path phrasing (`we could|earlier shape|promise|previously|…`) is clean
   in both files.

2. **False discriminator removed.** The R11 NOT-YET (dirac) was the `.hs` claim that
   status's "event log is the only history needed" — false, because replay rebuilds
   terms from `Registered` events too, so that clause failed to discriminate
   terms from status. The terms-vs-status split is now grounded on the **change
   discipline** (append-and-keep vs overwrite-on-settle), which is exactly what the
   code enforces (`NonEmpty` + `appendVersion` vs single value + `settle`).
   Authorship survives only as the *reason* terms are append-only (externally
   authored ⇒ prior versions preserved), not as a clause that fails to discriminate.
   Grep for the bad pattern (`only history needed`, `status … source of truth`) is
   clean. The lone surviving "single-source-of-truth" mention (.tex:135) is the
   legitimate statement of the system's purpose, not the discriminator.

3. **"history" word-collision softened** (step 5: "the stored status keeps no prior
   price — each settle replaces it"), removing the collision with
   replay-rebuilds-prior-status.

## Fresh Hutton-bar pass

- **Every abstraction is named after the thing it already is.** `Qty` is a monoid
  then a group, the group introduced exactly where the two cancelling legs need it
  (States.hs:111-118). `foldMap` for conservation appears only after the monoid
  exists (192-199, 597-598). `foldM` for replay is named only once the failable
  left-fold is on the page (707-713). No construction precedes its motivation.
- **The destination is derived, not assumed.** Three homes emerge bottom-up (balance
  → keys → shared status → versioned terms → enriched position → the two maps); the
  `.tex` 2×2 (holder-dependence × authorship) is an orthogonal, independently
  motivated decomposition with each occupied cell justified concretely in §Why Three
  and the empty cell justified by the mandate-unit reification. "No fourth home" is
  stated **conditionally** (shown for n=1, assumed in general) in both artifacts —
  the file does not assume its own headline.
- **Laws honestly classified.** Conservation = writer-invariant (the store type *can*
  hold a non-conserving map; the seal makes the reach from `emptyLedger` exhaustive,
  and the only `psBal` writer lays down two inverse legs). Replay determinism = purity
  of `apply` + the monadic left-fold law for checkpoint-independence; row retention is
  separately disclosed as an audit property, not the cause of determinism. The closing
  shape-enforced-vs-soundness-argued split (States.hs:803-820) keeps the reader from
  taking a writer discipline on faith as a shape.
- **Totality / determinism by reading.** All accessors total (`currentTerms` via
  `NonEmpty`; `settlementPrice` covers both reachable cases). All three writers return
  `Maybe` and guard the same out-of-bounds condition (`Map.member u (ledgerUnit l)`).
  `applyMove` nets per wallet first, so zero-quantity and self-move both reduce to one
  rule (net `mempty` ⇒ no row) — "held" = named in a move that nets nonzero. No
  partiality, no hidden state.
- **Listings type-correct.** Every `.tex` listing typechecks and matches the `.hs`
  semantics (Qty group; Price no-monoid; `Lifecycle = Listed | Active Price`; NonEmpty
  terms; `ledgerUnit` pair; net-first `applyMove`; `foldM` replay;
  `Map.foldrWithKey :: (k->a->b->b)->b->Map k a->b` applied correctly).

## Carried non-blocking note (NOT residue — 7 rounds, deliberately left to author)

The `.tex` renders `TermsVersion` (:221) and `Move` (:305) as **positional**
constructors where the `.hs` uses **records** (`tvLabel`; `mvUnit/mvFrom/mvTo/mvQty`).
This mildly overstates ".tex listings reproduce its declarations, deriving clauses
elided" (the difference is more than deriving). It is not a defect: the `.tex` is
internally consistent — it never uses the record accessors — so a reader of the
`.tex` alone is not misled. Left to STYLUS/author; outside my correctness lens.

## Residue

Empty.
