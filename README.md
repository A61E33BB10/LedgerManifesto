# The Ledger

A specification for a single internal system of record for post-trade activity. Positions,
moves, lifecycle events, and valuations are recorded as one immutable stream of admitted
transactions. Every other view — balances, profit and loss, reports — is a projection of
that stream. Within its scope there is one source of truth, so internal reconciliation
failure cannot arise.

The project is governed by a Constitution with one-way authority: the Constitution is
rated against nothing, and every specification, test, and review is rated against it.

## Current state (July 2026)

| Document | Status | Where |
|---|---|---|
| Constitution v1.4 (116 clauses) | In force — sole authority (owner declaration 2026-07-16; the document's own date field awaits the owner) | `LedgerManifesto/ledger_manifesto_v1_4.tex` / `.pdf` |
| Constitution v1.3 (115 clauses) | Superseded by v1.4 | `LedgerManifesto/ledger_manifesto_v1_3.tex` / `.pdf` |
| Specification v16.1 (113 pp) | Content-certified (FORMALIS signed, CONCORDIA signed last; 5 review iterations, supervised by TuringAward). One open item: the 112-page cap is exceeded by one page of normative content — the owner's decision | `Ledger_Spec_v16.1/ledger/ledger_v16_1.tex` / `.pdf` |
| Specification v16.0 (108 pp) | Superseded by v16.1 (was certified against Constitution v1.3) | `Ledger_Spec_v16.0/ledger/ledger_v16_0.tex` / `.pdf` |
| Deferred Settlement v2.0 (5 pp) | Converged — design cell + 7-reviewer board, 10 rounds | `LedgerManifesto/deferredSettlement.tex` / `.pdf` |
| Temporal execution addendum | Adopted register (5-engineer consensus) | `LedgerManifesto/temporalv16.tex` / `.pdf` |
| TuringAward advisory review | Advisory | `LedgerManifesto/TuringReview.tex` / `.pdf` |
| next_step_v16 (v11.0 archaeology) | Advisory — gap register | `LedgerManifesto/next_step_v16.tex` / `.pdf` |
| Ledger entropy note (5 pp) | Non-normative research (verdict: yes-but) | `LedgerManifesto/ledgerentropy.tex` / `.pdf` |

## Layout

```
LedgerManifesto/     The Constitution (all versions) and the standalone notes above.
Ledger_Spec_v16.1/   The current specification, one self-contained file.
Ledger_Spec_v16.0/   The superseded v16.0 specification.
v16_workpapers/      Working papers of the v16 passes: deferred settlement (10 rounds
                     of candidates and reviews), temporal, entropy, and the v16.1
                     conformance pass (5 supervised review rounds, decision log,
                     certification records).
archive/             Full project history.
  specs/             Superseded specifications v11.0 through v15.3.
  workpapers/        Workpapers of the v15.x passes, including pass records and
                     CONCORDIA sign-offs.
  pre_v15_work/      Work products that predate the v15 line.
CLAUDE.md            Standing brief for agents working in this repository.
EXCLUSIONS.md        What the system deliberately does not do.
```

## Reading order

1. The Constitution: `LedgerManifesto/ledger_manifesto_v1_4.pdf`.
2. The specification: `Ledger_Spec_v16.1/ledger/ledger_v16_1.pdf`.
3. The deferred-settlement design: `LedgerManifesto/deferredSettlement.pdf`.
4. For execution on Temporal: `LedgerManifesto/temporalv16.pdf`.

The constitution files `ledger_manifesto.tex`, `ledger_manifesto_v1_2.tex`,
`ledger_manifesto_v1_3.tex`, and `ledger_manifesto_v1_4.tex` are v1.1 through v1.4.
v1.4 governs (declared in force by the owner, 2026-07-16); earlier versions are kept
because pass records cite them.
