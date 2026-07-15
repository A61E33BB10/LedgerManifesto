# States.tex — Round 2 review (jane-street-cto lens)

**Verdict: NOT-YET**

The core design — three homes (terms / status / position), the empty fourth cell,
the 2×2 — is presented obviously. The conservation argument (only `applyMove`
writes `psBal`, two legs from one quantity cancel, sealed constructor leaves no
other door) is tight and reads linearly. Deterministic-replay-as-`foldM` is clean.
That part needs no commentary.

The document fails the bar on `psHwm`, with two lesser items. A reader six months
on *will* write margin notes against the spots below.

## Residue

### 1. `psHwm` "ratchets / retained after close-out" is asserted, never shown, and not hedged (lines 191–201, 268)

The `.tex` introduces `psHwm` as a live, dynamic field — "rides alongside,
**ratchets**, and is retained after close-out" (line 194) — and then *leans on
it in the correctness argument*: "psHwm adds but is never written as cancelling
legs, so it carries no zero-sum invariant" (line 268).

But no writer for `psHwm` appears anywhere in the `.tex`. `applyMove` touches only
`psBal`; `settle` touches only status. A reader scans for the function that makes
the high-water mark "ratchet" and finds none. The companion `States.hs` is honest
about this — line 331–333 there states plainly that the hwm "is set by a valuation
event, which is out of scope for this file -- here it stays at its zero." The
`.tex` carries no such hedge. So a `.tex` reader either (a) believes a claim the
document cannot support, or (b) goes to the `.hs` to discover the ratchet is
aspirational — which is exactly the "write commentary / go ask elsewhere" the bar
forbids. Under the project's own principle ("a claim is proved, not asserted"),
"ratchets" is unproved in either file.

Fix: either drop the dynamic verbs and say what the `.hs` says — `psHwm` stays at
its zero here; its writer (a valuation event) is out of scope, and the field is
present only to exhibit a non-conserved column riding the conserved one — or show
the ratcheting writer. The conservation argument at line 268 should rest on "no
*shown* writer pairs it into cancelling legs," not on a behavior never exhibited.

### 2. `settle` forces `usLifecycle = Active` unconditionally; three of four lifecycle stages have no writer (lines 169, 221–228)

`Lifecycle = Listed | Active | Expired | Closed` is a four-value type, but the only
transition any shown writer produces is `→ Active` (line 227), and `register`
(unshown, in `.hs`) produces `Listed`. Nothing in either file ever writes `Expired`
or `Closed`. Worse, `settle` sets `Active` *unconditionally* — settling an expired
contract (expiry settlement is routine) would silently flip it back to `Active`.

A 3am reader debugging "why does my expired unit read `Active` after its final
settle?" lands exactly here, and the `.tex` gives no signal that the other two
stages are deferred or that the forced-`Active` is intentional. Either constrain
the transition (only advance the stage when the prior stage permits it), or state
in the prose that lifecycle progression beyond `Listed/Active` is out of scope and
say why `settle` may assert `Active`.

### 3. `register` is load-bearing but absent from the `.tex` (lines 207, 216–219, 237)

The whole coherence invariant — "a unit appears in the terms map exactly when it
appears in the status map" (line 207) — and the legitimacy of `applyMove` gating
on `ledgerPT` alone rest on `register` writing both maps together. The `.tex`
asserts this in prose ("Registration writes a unit's terms and status together",
line 217) but never shows the function, while it *does* show `settle` and
`applyMove`. The reader must take the one invariant that ties the three homes
together on faith. This is the one deferred symbol that carries an argument rather
than just a payload; show the two-line `register` so the coherence claim is visible,
not promised. (The other deferred symbols — `Move`, `zeroP`, `emptyLedger`,
`TermsVersion` — are fine to leave to `States.hs`; they carry no argument.)
