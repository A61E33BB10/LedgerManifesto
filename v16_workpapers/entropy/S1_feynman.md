# Ledger Entropy — S1 (FEYNMAN, honesty gate)

*Exploratory, non-normative. A negative result is a success. "The first principle is that you must not fool yourself."*

## 0. The toy (built first, so it disciplines the claims)

One instrument. Wallets A, B, issuer I. Latent quantity = the instrument's **true price** `p`.

| e  | event | effect | noise |
|----|-------|--------|-------|
| e1 | issue 100 to A | I:−100, A:+100 (exact move) | none |
| e2 | observe price | y1 = 50.00 | σ1 = 0.10 (var 0.01) |
| e3 | transfer A→B qty 40 | A:−40, B:+40 (exact move) | none on qty |
| e4 | attest e2 | y2 = 50.04 (2nd independent obs) | σ2 = 0.05 (var 0.0025) |

**Decision, and I defend it: quantities are EXACT; only VALUES (prices) carry noise.** The restriction says observed *values*. A move is an *instruction*, not a measurement — conservation "vanishes by paired-leg construction" only because the two legs are the *same* number posted with opposite signs. If the 40 were a noisy observation, either (a) both legs share it and the noise cancels in the wallet sum — conservation survives but the "σ=1 on the transfer" is illusory, or (b) the legs are two independent draws and **conservation is violated in expectation**. The framework forbids (b). So the only place noise lives is the market-data price. After e3, A holds exactly 60 units, B exactly 40; the *value* of each holding is `p × qty` with all uncertainty inherited from `p`.

## 1. Posterior, TWO independent ways — agree to the digit

- **Sequential Kalman** (flat prior; e2 sets N(50.00, 0.01); update with e4): gain K = 0.01/0.0125 = 0.8, mean = 50.00 + 0.8·0.04 = **50.0320000000**, var = 0.2·0.01 = **0.0020000000**.
- **Batch precision-weighting** (τ1=100, τ2=400): var = 1/(100+400) = **0.0020000000**, mean = var·(100·50.00 + 400·50.04) = **50.0320000000**.

Posterior `p ~ N(50.032, 0.002)`, σ = **0.0447213595**. Two derivations, identical to 10 digits.

## 2. Candidate entropy, TWO independent ways — agree to the digit

Differential entropy of the Gaussian state. Closed form `H = ½ ln(2πe σ²)`; cross-checked by direct numerical quadrature of `−∫ f ln f dx` (4M points, ±12σ).

| state | var | H (closed) | H (integral) |
|-------|-----|-----------|--------------|
| after e2 | 0.01 | −0.883647 nats | — |
| after e4 | 0.002 | **−1.688366** nats | **−1.688366** nats |

Closed form and integral agree. Entropy **drops** 0.883647 → −1.688366 at the attestation: **ΔH = 0.804719 nats = 1.160964 bits**. Cross-check: ΔH = ½ ln(var_before/var_after) = ½ ln 5 = 0.804719. ✔

## 3. Jaynes / max-entropy angle — consistent, but partly circular

The Gaussian posterior **is** the max-entropy distribution over `p` for its mean and variance — that is Gaussian's defining property. So "the ledger state = max-ent consistent with attested facts" holds **only if the attested facts are read as constraints on the first two moments**, which they are under a Gaussian noise model. Honest caveat: Gaussian-ness is an *input* (the noise model), not a *consequence* of attestation. The non-trivial, real content is that attestation *tightens the variance constraint*, so the max-entropy value *falls*. The level is assumption-laden; the fall is not.

## 4. Second-law heuristic — HALF FALSE (vacuous) on this toy; here's what fixes it

"Entropy non-decreasing between attestations, dropping at each." The **drop half is TRUE and non-vacuous** (0.8047 nats at e4). The **growth half is VACUOUS**: the fold is deterministic and the latent `p` is *static*, so between e2 and e4 the posterior is frozen — H is *constant*, witnessing nothing. Worse for the metaphor: a pure append-only observation ledger has entropy that **only ever ratchets DOWN** — that is the *opposite* of a thermodynamic second law. To make growth real, add a **diffusion prior**: `p` drifts as `dp = √Q dW` between events, so var += Q·Δt and H rises by ½ ln((σ²+QΔt)/σ²) (e.g. QΔt=0.02 ⇒ +0.549 nats). *Only with a genuine forgetting/diffusion process does the sawtooth — growth between, drop at attestation — exist.* Without one, there is no arrow of time in the log.

## 5. What "the number" means to an operator — and the better number

Differential entropy is the **wrong headline**: it is unit-dependent (change 50.00 from dollars to cents and every H shifts by ln 100), can go negative (−1.69 above), and needs a reference measure. Two quantities survive that critique and *are* what an operator should read:
1. **Posterior σ per position** = a confidence interval on the mark. Here the book's price is 50.032 ± 0.045; A's 60-unit line is 3001.9 ± 2.7, B's 40-unit line 2001.3 ± 1.8. That is directly actionable: "how tight is my mark."
2. **Information gain at each attestation**, as a *relative* entropy — unit-invariant and always ≥ 0. Mutual information I(p; y2|y1) = ½ ln(var_before/var_after) = **0.8047 nats**; KL(posterior‖prior) = **0.4559 nats = 0.658 bits**. This reads as: "the second observation was worth ~0.66 bits of confirmation; the two marks were mutually consistent (|Δ|=0.04 vs σ1=0.10, ~0.4σ — no attestation dispute."

**Verdict.** Ledger entropy is *computable and self-consistent* but is the wrong scalar to publish: the differential-entropy **level** is a unit-dependent artifact, while the **change** at attestation is exactly a mutual information / KL and is the honest, invariant quantity. Report per-position posterior σ (a mark confidence interval) and per-attestation information gain in bits — not H itself.
