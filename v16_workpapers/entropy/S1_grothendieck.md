# Ledger Entropy — Session 1

**GROTHENDIECK (Chair). Independent formalization. Exploratory, non-normative.**

Restriction in force: every event under study records an *observed value*, where
`observed = true + Gaussian noise`. Nothing else is in scope.

---

## 0. What kind of object is a "ledger entropy"? (before any number)

The seminar was handed a number-shaped question — *compute the entropy of a noisy
ledger* — and I refuse it in that shape. First fix the object. A functional does not
deserve the name *entropy* because it has a `−∑ p log p` on the page; it deserves it
if it is (i) **of a definite distribution**, over a **definite sample space**, and
(ii) **natural** — unchanged by the arbitrary choices a ledger tolerates (unit of
account, cents-vs-dollars, price-vs-log-price, the order of independent observations,
the padding of the log that folds to the same state). A functional that moves when
those choices move is measuring the choice, not the ledger.

So the discipline of this session is a single demand: **name the distribution, name the
reference, prove the invariance.** Everything below is that demand, worked once on the
smallest ledger that has anything to be uncertain about.

## 1. One miniature (concrete, before any abstraction)

Two wallets `A, B`, one unit, conservation `x_A + x_B = 0`. One recorded event: an
observation of A's position, `y = x_A + ε`, `ε ~ N(0, σ²)`. Prior belief before the
event, `x_A ~ N(0, τ²)` (a proper prior — I will insist on where it comes from below).

Bayes gives the posterior over the *true* value: `x_A | y ~ N(μ, s²)`, with
`1/s² = 1/τ² + 1/σ²` and `μ = (s²/σ²)·y`. Conservation makes this automatically a
posterior over the whole two-wallet state, supported on the line `x_B = −x_A`: the
observation of A *is* an observation of B. The sample space is the constraint surface,
not the product — this is where `(unit, coordinate, agreement)` conservation enters, as
the **support** of the distribution.

Now two candidate functionals of that posterior:

- **Differential entropy** `h = ½ log(2πe·s²)`. Record the position in cents instead
  of dollars (`x ↦ 100x`): `s ↦ 100s`, so `h ↦ h + log 100`. **The number moved and the
  ledger did not.** Differential entropy is *not natural* — a NATURALITY VIOLATION in the
  sense of the charter. It is the wrong functional. This is the negative half of the
  answer, and it is clean.

- **Relative entropy** of posterior against prior,
  `D(N(μ,s²) ‖ N(0,τ²)) = log(τ/s) + (s² + μ²)/(2τ²) − ½`. Rescale to cents: every term
  is a ratio or is divided by `τ²`, and the factors of 100 cancel. **The number does not
  move.** Averaged over the data `y`, it collapses to the mutual information
  `I(x_A ; y) = ½ log(1 + τ²/σ²)` — the amount of truth this event deposited into the
  ledger, in nats, independent of coordinates. As `σ → 0` (perfect verification) it
  diverges: pinning a real number exactly is infinite information, and that is honest.
  Partial verification lives in the finite regime `σ > 0`; an **attestation event** is a
  second observation that shrinks `σ` and deposits a further, finite increment of `D`.

## 2. The reshaping that survives

*Ledger entropy as an absolute scalar does not exist.* There is no coordinate-free
`−∑ p log p` on a continuum, and the true state is a fixed unknown, not a random variable,
until a reference belief is named. The naive question dissolves.

*Ledger information relative to a reference does exist,* and is forced:

> **The functional that deserves the name is relative entropy** —
> `D(posterior-over-true-states ‖ reference)` — the information a noisy event deposits
> about the truth. It is natural (invariant under any measurable relabelling of the
> sample space applied to both arguments), additive across independent events (the
> chain rule), and it respects conservation because both arguments are supported on the
> same constraint surface.

The fold is not an obstruction to this; it is the *mechanism* of it. The fold
`log ↦ state` is a deterministic map, and it is many-to-one (independent moves in either
order, padding, netting all fold to one state). Push the posterior forward through it and
relative entropy can only **decrease**: `D(fold_* p ‖ fold_* m) ≤ D(p ‖ m)`. That gap —
the data-processing deficit — *is* the Baez–Fritz–Leinster "information lost along a
morphism," realized in the continuous setting. Entropy is not a quantity attached to the
ledger; it is a **lax (monotone) structure carried along the fold.** That is the shape the
charter asked me to test for, and the fold has it.

## 3. Second telling (category theory — deletable; nothing above rests on it)

> Work in a Markov category (Kleisli of the Giry monad, or Fritz's `BorelStoch`). Objects:
> measurable spaces of true values, of records, of states. The noise `x ↦ N(x, σ²)` is a
> morphism `X → Y`; the fold `X → S` is a *deterministic* morphism; the posterior is the
> **Bayesian inverse** `Y → X` of the noise against the prior. Relative entropy is a lax
> monoidal functor from this category to `([0,∞], ≥)`: functorial (chain rule), monotone
> under all morphisms (data-processing), sending isomorphisms to `0` (naturality). BFL's
> theorem — entropy as the unique-up-to-scalar functor measuring information loss along
> measure-preserving maps — is the finite, absolute shadow of this; on a continuum the
> absolute functor does not descend, only the relative one does. Delete this box and
> Sections 0–2 stand unchanged.

## 4. Verdict of the Chair

Entropy, as a self-standing number, is the **wrong functional** for a noisy ledger — it
is not natural, and the charter's own test rejects it. The **right functional is relative
entropy**: information deposited by an event, measured against a reference belief, natural
by construction, additive across events, and monotone along the fold. The single unproven
load-bearing element is the **reference** — and that is precisely what I put to the
committee.

---

## Demands on the committee for Session 2

1. **Fix the category.** Name objects, morphisms (noise, fold, Bayesian inverse),
   identity, composition. No functional is discussed before the category is on the board.
2. **Supply the reference non-arbitrarily.** The prior is load-bearing; a posited prior is
   a hidden choice and voids naturality. I conjecture it is *given by bitemporality*: the
   reference is the `as-known-at` belief before the event, the posterior is the belief
   after, and `D` is the information deposited between two knowledge-times. Derive it from
   the ledger or report, as a negative result, that no natural reference exists.
3. **Prove naturality, three ways.** Invariance under (a) change of unit/coordinate,
   (b) reordering of independent observations, (c) the fold (data-processing). Any
   candidate functional failing any one is discarded before the vote — no counterexample,
   no critique.
4. **Prove additivity and locate conservation.** Chain rule across independent events;
   and show the functional decomposes per `(unit, coordinate, agreement)`, with the
   conservation constraint appearing as the common support, never as an extra term.
5. **Keep the two entropies apart.** Noise-uncertainty (this seminar) is not
   fold-degeneracy (representational multiplicity of logs). A construction that adds them
   is a CATEGORICAL CONFUSION and is returned unread.
6. **Confront the limits.** `σ → 0` (full verification) and the diffuse-prior limit.
   Demand the functional tie attestation/verification events to finite information
   deposits, and explain the honest divergence rather than hiding it.
