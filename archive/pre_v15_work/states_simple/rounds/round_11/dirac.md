# dirac — States, Round 11

Verdict: **NOT-YET**

## What is beautiful here

The placement is derived, not asserted, and the derivation is genuinely
clean over most of its span:

- **The 2×2 is the right notation.** Two binary questions —
  holder-dependence and authorship — span the space of facts. The three
  homes are exactly the three occupied cells. Given the two axes, the
  count *three* is forced, not chosen. That is the inevitability the bar
  asks for.
- **The empty cell is defended, not waved away.** "No external authority
  issues a fact about one holder's position" is the crux, and it carries
  its weight: custodian/PB statements are reconciliation inputs, not
  adopted records; the managed-account apparent counterexample is folded
  back into a (client, mandate-unit) position. The fourth home does not
  exist, and the reader can see *why*.
- **Competing criteria are explicitly foreclosed.** Correction-recording
  "follows from authorship; it is not a separate axis." Conserved vs.
  non-conserved (psBal vs psHwm) is within-home, not a placement axis.
  Wallet-alone keying is excluded as identity, not economic state. No
  second criterion competes with the 2×2 for placement.
- **3 homes / 2 maps** resolves elegantly: terms and status share the
  unit key, so co-presence becomes the *shape* of the map rather than a
  policed invariant. The mismatch is a payoff, not a fudge.

So the three-home *structure* reads as inevitable. The crack is one
level down: the reason given for the two per-unit homes having different
*storage shapes* does not, as written, discriminate between them.

## The residue (one, two coordinates)

The document distinguishes Status (overwrite-in-place, scalar) from
Terms (append-only, non-empty version list) and pins the distinction on
**authorship**:

> "Status is the ledger's own: a settlement is the ledger's event, so
> the ledger overwrites the status it produced, *its event log the only
> history it needs*." (§The Answer ~ll.96–101; restated §Why Three
> ll.124–138)

But §Deterministic replay says the event stream is the sole history of
**everything**, terms included:

> "every view is a projection of the stream … each terms value from its
> Registered event with one version" (ll.379–381)

So "the event log is the only history it needs" is true of **terms** too
— terms history lives in the Registered/amendment events and replay
rebuilds it. The offered discriminator therefore **fails to
discriminate**: it applies verbatim to both homes. The true
discriminator is left unstated — *terms are temporally valid* (a past
fee or computation must be reproducible at the terms then in effect),
whereas *status is always consumed at its current value* (a position is
marked at the last settlement price, never at a superseded one). That,
not authorship, is what forces terms to materialize prior versions while
status keeps only the current one. Authorship correlates with it but
does not entail it: a ledger-authored fact could need in-state history,
and an externally-authored fact consumed only-current would not.

Consequence the reader hits in-scope: within this file the NonEmpty list
is **always a singleton** (amendment is out of scope), so the
terms↔status shape distinction is exercised only as writer *discipline*
(`appendVersion` keeps, `settle` discards), justified by an out-of-scope
future. As presented, the list shape reads as *anticipatory* rather than
*inevitable*, because the in-scope reason given (authorship → "event log
is the only history needed") is exactly the property §replay assigns to
status as well.

This does not break the three homes — terms and status sit in different
authorship cells regardless. It breaks the *inevitability of why they
store differently*, which the document spends two paragraphs asserting.

## Actionable fix

State the missing bridge once: terms carry temporal validity (past
computations must be reproducible at the version then in force), so the
current-and-prior versions are all live state; status is consumed only
at its current value, so prior stages are never live state and need not
be materialized. Then "authorship" can stay as the *correlate* that
selects which discipline applies, without being asked to *cause* the
storage shape — and the claim "the event log is the only history status
needs" stops contradicting "every view is a projection of the stream."
