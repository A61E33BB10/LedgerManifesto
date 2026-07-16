# Phase 1 Consultation — finops-architect (treasury / funding / financial operations)

*Summoned by MINSKY. Logged in the Design Ruling memo's consultation annex. The bench advises; the owner decides.*

## (1) Answer to the question asked

### (i) Micro-case (a): daily cash VM on a running future — cleaner under the split.

The fact treasury lives by that both framings blur: **cleared-future VM is not collateral.** Since the 2017 CCP rulebook change, CME and LCH variation margin is *settled to market* (STM) — each day's mark-to-market is a realized cash settlement, the contract resets to the new settlement price, and the paid cash carries no return claim. There is nothing to give back. (ISDA's 2017 STM protocol extended this to bilateral CSAs that elect it.) So the *return obligation* that both the v13.1/v14 treatment and the coordinate proposal reach for **does not exist** in this case.

Moves — I am long, the future falls, I pay VM 100:

**Treatment A (split: cash on `own`, obligation unit only where one exists):**
- `own(cash)`: me −100 / CCP +100 (outright).
- realized PnL on the future unit: me −100 (daily reset).
- Assets −100 = Equity −100. No liability, no receivable. This *is* a futures book.

**Treatment B (universal coordinate: cash VM rides `coll_post`/`coll_recv`):**
- To respect the single-coordinate-move rule you must book an outright leg, then reclass into a collateral coordinate; and under the security-interest valuation V = Σ(own + coll_post)·P you keep valuing the posted 100 as yours. For a *settled* future that 100 is a realized loss and is gone. Treatment B shows phantom cash, fails to realize the loss, and breaks the daily reset.

**§8 unwind test.** Received VM is a case-(1) exchange (cash in; the exposure owed to me is extinguished as the contract resets). Treatment A books it so — on unwind nothing is returned, which is correct. Treatment B books received VM as case-(3) *custody-not-owned* (`coll_recv`), asserting a return obligation that does not legally exist; it **fails** the unwind test for settled margin. **Treatment A conserves §8 more faithfully and is the one a treasury desk can run.** No desk funds a ladder off a ledger that parks realized, spent cash on a no-economic-value coordinate.

The general rule: cash margin is not one object. STM VM = settlement (`own`, no obligation, §8 case 1). CTM / English-law-CSA title-transfer collateral = financing (`own` + explicit return-obligation unit, §8 case 2). Segregated cash IM under UMR = genuinely custody-not-owned (`coll_recv` legitimate, §8 case 3). The split keys off legal regime; the universal coordinate flattens three regimes into one and mis-books two of them.

### (ii) Under Q2 yes: encumbrance as projection — yes for the stock, insufficient alone.

Encumbrance (`encumb = onloan + coll_post`) does fall out cleanly as a read-time projection over the coordinate vector; the unencumbered pool and the asset-encumbrance ratio (EBA AE templates) become one query. That is a real win of the universal model. But **intraday liquidity (BCBS 248) and funding-cost attribution need two axes the coordinate stock does not carry:**
- *Settlement-state / value-date.* Treasury funds settled cash at a cut-off, not committed positions. Encumbrance must be projected over (coordinate × settlement-state), or the number is a balance-sheet-date stock — useless intraday.
- *Agreement rate + counterparty.* Cost attribution needs the rebate, the CSA rate (€STR/SOFR), the haircut, and whether IM cash is remunerated. That lives on the collateral-agreement unit, not the coordinate vector. The projection must join coordinate → agreement → counterparty.

So: sufficient for "what is pledged and free"; **not** sufficient for liquidity or cost until joined with settlement-state and agreement rates. Both inputs already exist in the model — the ruling must state that encumbrance is a projection over (coordinate × settlement-state × agreement), never over the coordinate vector alone.

### (iii) Failure mode the universal representation introduces, that the split avoids.

**The fungible-cash reconciliation break.** Cash has no earmark. Title-transfer collateral creates a debtor-creditor relationship — you owe a return; you do not hold specific coins (the *re Lehman* client-money jurisprudence). A `coll_recv` coordinate for cash presumes an identity cash does not have: received-collateral dollars are indistinguishable from owned dollars at the nostro, and the bank statement observes only their **sum**. To reinvest that cash, treasury must "promote" `coll_recv`→`own`, but cannot tag which dollar moved. The `coll_recv(cash)` balance and the actual nostro then diverge intraday — the exact internal-reconciliation-failure the Ledger exists to abolish. This also fails §4's *own* admission test: a coordinate is earned only when an action changes it *independently of ownership*; taking cash under title transfer **is** the change of ownership, so title-transfer cash earns no `coll_recv` coordinate. The split (cash always on `own`, matched by an explicit obligation/claim unit) reconciles own-cash to the statement one-for-one and never lets a liability compete with a balance for the same dollars. Secondary modes it avoids: mis-realized settled VM (above); and CSA interest — under the split the receiver's own cash earns real interest while the obligation unit accrues the CSA rate as an ordinary liability, avoiding a baroque manufactured-payment construction for cash.

## (2) Constraints my domain imposes on the ruling

- **STM vs CTM (CME/LCH 2017 rulebooks; ISDA 2017 VM/STM protocol).** Settled variation margin is realized settlement, not collateral, and has no return leg. Any representation that carries a return obligation on cleared/STM VM is legally wrong and mis-states PnL.
- **ISDA CSA governing law.** English-law CSA = title transfer (the Credit Support Balance is a debt claim; the receiver owns the cash). New York-law CSA = security interest (pledge). The books differ; the ledger must key off it.
- **UMR (BCBS-IOSCO).** Initial margin must be segregated at a third-party custodian and generally cannot be rehypothecated — this is the *only* cash case that is genuinely custody-not-owned and legitimately earns `coll_recv`.
- **BCBS 248 / LCR / NSFR / EBA AE.** Intraday liquidity and encumbrance reporting require the settlement-state and agreement-rate axes joined to the position stock.

## (3) Risk in answering Q1/Q2 "yes"

Answering Q1 "yes as a blanket" contradicts the physical-action *own* test inside the same §4, mis-books the majority of cash margin (all title-transfer and settled cash), and re-introduces internal reconciliation failure through cash fungibility — precisely the outcome the constitution's purpose forbids. §8's third limb ("cash received as collateral, recorded on the collateral-received coordinate") is correct **only** for the segregated security-interest regime; read as a blanket, it conflates settlement, financing, and custody. Q2 "yes" is defensible for *securities* (where received collateral is genuinely not owned and price risk stays with the poster) but must not be extended to cash without the regime carve-out, or it buys uniformity by hiding the one distinction treasury cannot operate without: legal title to cash.

## (4) Recommendation

Answer Q1 **no as a blanket, qualified yes by regime.** Cash rides the coordinate vector only where the firm truly holds cash it does not own — segregated, non-rehypothecable IM under security interest (§8 case 3). All title-transfer and settled cash — cleared VM, English-law CSA, repo/GMSLA cash — books on `own`, with the return leg (where one exists) as an explicit obligation unit (§8 case 2), and settled VM with no return leg at all (§8 case 1). This preserves nostro-to-bank reconciliation, states funding truthfully, values settled futures correctly, and still delivers encumbrance and funding cost as projections. Do not adopt a universal cash coordinate.
