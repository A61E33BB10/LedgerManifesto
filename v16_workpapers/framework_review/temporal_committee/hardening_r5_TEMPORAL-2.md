# Red-team R5 — TEMPORAL-2 (reviewer): S4 retry storm vs the identity key

Canonical under test: txid = H(input-cut, model-version, recipe/dynamic-version); **env-version OUT of
the key**; door admit = atomic unique-key insert (exactly-once = total function of the durable log).
**Honest note:** env-out-of-key *corrects my own R3/R4 key*, which carried numerical-env-version in the
identity — a latent double-admit I confirmed in R4 (A3). All three sub-attacks **HOLD**.

## A1 — retry storm + door crash-restart (check-then-append vs atomic insert). HOLDS.
- **Break under check-then-append (anti-pattern):** door-1 SELECT X→absent; door-2 SELECT X→absent;
  door-1 APPEND X; door-1 crashes pre-ack; door-2 APPEND X → **two rows for X (double-admit)**. A TOCTOU
  window the storm widens.
- **Closed by atomic unique-key insert:** admission is one atomic INSERT under UNIQUE(txid)
  (compare-and-append conditional-on-absence). First insert of X wins; every concurrent or post-crash
  retry fails the constraint → **absorb**, never a second row. Admitted set = exactly {txids durably in
  the log}, independent of retry count and crash timing — a total function of the log. HOLDS.

## A2 — injectivity: can two distinct causes collide to one txid (false dedup)? HOLDS, under 3 conditions.
- **Distinct cuts:** C1≠C2 differing by one late quote are two facts (mark before/after) → distinct cut
  ids → both admitted, **provided the input-cut is an EXACT identifier** (as-at log position, or a
  content/Merkle hash of the resolved input set), **never a coarse label** (truncated timestamp, a
  "latest" pointer). A coarse cut absorbs a genuinely different input state → silent loss, the analogue
  of MD-1's over-coarse grain. **New containment to state: exact-grained input-cut.**
- **Versions + hash:** distinct model/recipe/dynamic versions → distinct keys *provided* versions are
  immutable append-only registered terms (MD-6, B2 "a correction is a new version, never an edit") — a
  silent version reuse would false-dedup, but violates an existing invariant, not the key; and H admits
  no collision on the finite tuple domain (the H-CR assumption the base cause-derived txid already rests on, §txexec).

## A3 — does env-out-of-key ever make two different facts share a txid? HOLDS (and fixes my prior key).
- Env-version is a **re-derivation term (how precisely a value reproduces), not a fact identity** (which
  mark of which unit at which cut under which model/recipe). Two derivations differing *only* in env are
  the SAME fact computed twice; they SHOULD dedup (first-wins canonical, P vs P′ is the known §3 bound).
  Env is not a degree of freedom in *what* is computed, so env-out never collides distinct facts.
- **Conversely, env-IN (my R3/R4) BREAKS:** a retry storm migrating across heterogeneous workers
  (GPU/BLAS) computes different env-versions → different txids → **double-admits one fact** → broken
  state. My R4 "key survives" confirmed a key with this latent flaw; the canonical corrects it. Env
  belongs in **lineage** (recorded for Tier-2 re-derivation), never identity — dispute-readiness
  (MD-14/VM-8) is preserved since read-back and the recorded env are both intact.

**Verdict:** A1 HOLDS (atomic unique-key insert closes the storm), A2 HOLDS (needs exact-grained
input-cut + immutable versions + H-CR), A3 HOLDS (env is a re-derivation term); env-out-of-key corrects my earlier wording — adopt it.
