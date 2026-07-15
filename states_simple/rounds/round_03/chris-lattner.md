# chris-lattner — Round 3 — States.tex

## Verdict: NOT-YET

The structure is good. The first axis (key: unit vs (holder, unit)) is forced cleanly
— the buyer +1000 / seller -1000 argument is exactly the kind of concrete derivation
that makes a placement obviously right, and the empty-fourth-cell argument is honest and
mostly carried. The construction section earns its claims: the sealed constructor, the
single balance writer, the cancelling legs, and the `foldM` replay argument are tight.

But the headline answer is a *count* — "three homes" — and that count rests on one joint
that is asserted, not derived. A competent engineer who has never seen this will stop
exactly where I stopped.

## Residue

### 1. The retention axis — the one that produces "three" — is asserted, not forced
Location: §The Answer, lines 56–59 and 75–78; §Why Three, lines 108–117.

The second distinction (history kept in-store vs overwritten) is the *only* thing
separating Terms from Status — both share the unit key (you say so at line 73). So the
count "three" instead of "two" depends entirely on Terms *requiring* an in-store version
list while Status does not.

The justification given is access pattern: "prior versions are queried directly for audit
while a prior settlement value is only ever needed as the current projection" (114–115),
and "Retention follows provenance" (75). But the document also commits — here and in
§Why It Is Right — to the thesis that every view is a projection of the event stream, and
states outright "Both are rebuilt by replay" (112–113). If replay reconstructs prior
terms exactly as it reconstructs prior status, then "auditable" is satisfied by the
stream for *both*, and nothing shown forces terms' history to be *materialized in the
store* rather than replayed on demand. "Must stay auditable" (76) is conflated with "must
be retained in-store as a version list" — the first is a correctness property satisfied by
the event stream; the second is a materialization choice. The leap from one to the other
is the unproven step.

Consequence: if replay suffices for terms as you concede it does for status, Terms and
Status collapse into one unit-keyed home and the answer is *two* homes. The minimalism
defense at 115–117 ("combined, the home would carry two disciplines at once") only bites
*after* you have established that terms need in-store retention at all — it cannot
establish that need, it presupposes it.

Actionable: derive what query or correctness property replay *cannot* serve for terms but
*can* for status/position — i.e., show the thing that forces terms' history into the store
— or fold terms and status into one unit-keyed home and report two. Right now the headline
count stands on an asserted access pattern.

### 2. The load-bearing sub-claim is questionable on its face
Location: §Why Three, lines 114–115: "a prior settlement value is only ever needed as the
current projection."

This is doing real work in the Terms/Status split, and for a ledger of trading-book
positions held *at fair value* it is at best unsupported and likely false: historical
settlement prices are routinely queried directly — P&L attribution, mark history,
period-over-period valuation. The document elsewhere keeps closed-out positions "for
audit" (line 332), conceding that positions and their valuation history are audit targets
too. So the asymmetry "terms are queried historically, settlement values never are" is not
self-evident and is contradicted by the domain. Either support it (name the property that
makes terms-history a direct query but settlement-history never one) or remove the reliance
on it.

### 3. Minor: a permanently-dead field carried for illustration
Location: §The Construction, lines 209–224; §Why It Is Right, lines 300–302.

`psHwm` is, by the document's own statement, always zero with its only writer out of scope,
"present only to show a non-conserved field beside the conserved balance." It does serve
the conservation point (a field in the same home that adds but is not written as cancelling
legs), so it is defensible — but against the bar "nothing present that does not serve the
answer," a field that is structurally inert in every code path it appears in costs the
reader a double-take. Not a blocker on its own; flagging it because items 1–2 already put
the retention story under load and `psHwm` is the same story's residue inside the Position
home. If the conservation claim can be made without carrying a dead field, carrying it is
not free.

## What would flip this to OBVIOUS
Close item 1: show the property that forces terms-history into the store and leaves
status/position-history to replay. Once "three" is forced rather than asserted, the rest of
the document already earns its keep, and items 2–3 fall out with it.
