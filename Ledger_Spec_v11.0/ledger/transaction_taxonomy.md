# Transaction Taxonomy (canonical)

The decided vocabulary. Every section, appendix, and listing uses these terms
consistently. Implemented in `reference/Ledger.hs` Part C.

## Primitives

**Move** — one indivisible transfer of a positive quantity of ONE unit from a source
wallet to a destination. It is the *edge* presentation of a conserved flow. A Move names
both parties, so a single Move conserves by construction.

**Transaction** — THE one atomic event recorded in the log: an ordered list of moves PLUS
the state delta they ride with — non-balance per-wallet bookkeeping (accumulated_cost,
high-water mark, entry NAV), shared UnitStatus writes, and a ProductTerms introduction
(`txIntroduce`) or append (`txAppend`).

The implemented record (six fields):
`txUnit, txMoves, txRows, txStatus, txIntroduce, txAppend`.

## Conservation by construction

Conservation holds BY CONSTRUCTION from the signed edge-sum of the moves. An empty move
list is `mempty`, so the move-less cases are conserved for free.

- There is NO separate validate step.
- There is NO `StateDelta` / `ValidDelta` type.
- A balance changes ONLY via a Move (the FieldWrite table has no balance writer), so
  "a balance change without a conserving move" is unrepresentable.
- `applyTx` is the sole door; the Ledger is sealed.

## Where each event sits

- **Registration IS a transaction** — a move-less Transaction with
  `txIntroduce = Just` (built by `registerTx`), vacuously conserved. `register` is
  `applyTx . registerTx`, not a separate operation.
- **Trade / settlement / transfer** — a Transaction with `txIntroduce = Nothing`,
  carrying moves (and non-balance rows).
- **Preserving amendment** — a move-less Transaction with `txAppend = Just`
  (built by `appendTx`).
- **Breaking amendment** — a composite of TWO Transactions (introduce the successor unit,
  then stamp `superseded_by` on the predecessor). The single justified exception to
  one-Transaction-per-event, spanning two units, made atomic to callers by `amend`.

One type, one apply (`applyTx`), one fold (`replay = foldM applyTx`) cover registration,
trade, settlement, and amendment alike.

## Boundary types (distinct names, project onto the core)

Boundary types keep DISTINCT names and PROJECT onto the core Transaction. They are NOT the
core Transaction.

- **CDM `BusinessEvent`** — projects via a forgetful map `forget :: BusinessEvent ->
  CdmTransaction`; its move list *are* the edges a core Transaction records.
- **Settlement-layer instruction** (`SettlementTx`) — a committed core Transaction
  projects onto it via the contract's unit -> Asset resolution.
