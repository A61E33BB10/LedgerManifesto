# Verified End-to-End Numerical Example (conservation-checked)

One managed account `w_C` under mandate `u_MA` issued by manager `w_M`; virtual market wallet
`w_mkt`; client external funding wallet `w_ext`. USD reference. `ProductTerms[u_MA]`: management
fee 2%/yr, performance fee 20% over a high-water mark (no hurdle/benchmark in the fee),
quarterly crystallisation. `u_MA` is a **non-valued memo unit** — excluded from
`V_t = Σ_u w(u)P_t(u)` (cluster A6). Conventions: management fee on **end-of-period NAV** at
2%/yr × 0.25; performance fee on NAV **net of management fee**, above the HWM; HWM set at
subscription to entry NAV and ratchets monotonically (C11 writer `fee_crystallise`).

All figures verified by a decimal conservation check: `Σ_w w(u) = 0` holds for **every** unit
after **every** move; fee zero-sum holds at crystallisation.

| Step | Moves (each `src → dst : qty unit`) | `w_C` after | NAV |
|---|---|---|---|
| A. Mandate issuance | `w_M → w_C : 1 u_MA` | u_MA +1 | — (u_MA non-valued) |
| B. Subscription | `w_ext → w_C : 1,000,000 USD` | USD 1,000,000 | 1,000,000 |
| C. Trade (buy 5,000 AAPL @100) | `w_C → w_mkt : 500,000 USD`; `w_mkt → w_C : 5,000 AAPL` | USD 500,000; AAPL 5,000 | 1,000,000 |
| D. Q1 NAV (AAPL → 130) | (price move, no ledger move) | unchanged | **1,150,000** |
| E. Fee crystallisation | `w_C → w_M : 5,750 USD` (mgmt); `w_C → w_M : 28,850 USD` (perf) | USD 465,400; AAPL 5,000 | **1,115,400** |
| F. Wind-down (liquidate + redeem + return mandate) | `w_C → w_mkt : 5,000 AAPL`; `w_mkt → w_C : 650,000 USD`; `w_C → w_ext : 1,115,400 USD`; `w_C → w_M : 1 u_MA` | all 0 (rows retained) | 0 |

**Fee arithmetic (Step E).** `Perf = (V_{t1} − B_0) − netFlow = (1,150,000 − 1,000,000) − 0 =
150,000` (gross of fees, net of capital flows — clusters A2/A3). Management fee
`= 1,150,000 × 0.02 × 0.25 = 5,750`. NAV net of mgmt `= 1,144,250`. Performance fee
`= 0.20 × (1,144,250 − 1,000,000) = 28,850`. NAV after both fees `= 1,115,400`. New HWM
`= max(1,000,000, 1,115,400) = 1,115,400`; reset baseline `B_1 = 1,115,400` (post-settlement
capital base — cluster A3). Fee zero-sum: `Σ_w Δ(USD)_fee = −34,600 (w_C) + 34,600 (w_M) = 0`.

**Closing identity (global, all wallets).** Final non-zero balances:
`w_M = +34,600` (fee revenue), `w_mkt = −150,000` (gross gain paid out by the market),
`w_ext = +115,400` (client net). Sum `= 34,600 − 150,000 + 115,400 = 0`. Client received
principal 1,000,000 + net gain 115,400; gross gain 150,000 = net 115,400 + fees 34,600. ✓

**Per-unit conservation across the whole chain.** `u_MA`: issued (+1/−1) then returned (0/0),
`Σ_w = 0` throughout. `USD`: `w_C` nets to 0; global `Σ_w w(USD) = 0` after every move. `AAPL`:
`w_C` +5,000 then −5,000, `w_mkt` mirror, `Σ_w = 0`. All position rows (`w_C`'s AAPL, both
`u_MA` rows) are **retained at zero** under the monotone carrier for audit and tax.
