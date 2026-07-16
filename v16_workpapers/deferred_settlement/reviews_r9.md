# Round 9 Reviews — on candidate_r8.md (convergence attempt #5: NOT converged)

Tally: 4 APPROVE (jane-street-cto, rosetta-cdm, minsky, sbl-specialist), 3 BREAK — every
break a statement-level fix (one paragraph / one line / one sentence), no mechanism
changes. All R8 items across all seven reviewers RESOLVED. Notable: minsky's FIRST
APPROVE of the process (red-teamed the minting rule across all four per-coordinate
direction combinations including the unworked fourth — holds); jane-street calls r8 "the
cleanest the candidate has been."

## BREAKS

### R9-B1 (nazarov) — the cut-off declared term is untyped trust
The LMFP/SEFP boundary (and WHICH PARTY bears the flipped day) compares an attested
operand (the CSD's matching timestamp) against OUR declared cut-off, whose faithfulness
to the CSD's actual cut-off is untyped. The Spine gives replay determinism, not
correctness — it faithfully replays a WRONG cut-off. Numbers: real cut-off 16:00, our
stale declared 15:00, matched Fri 15:30 ⇒ we expect LMFP $15,600 vs correct advice
$10,400 → BREAK on a correct advice + the flipped $5,200 silently mis-attributed between
us and the counterparty.
**Fix (one paragraph, the candidate's own TA-TERMS precedent):** cite the venue
calendar/cut-off faithfulness to TA-TERMS ("a declared term faithfully renders the
venue's convention"); owner = calendar/venue governance; detection = a boundary-day
advice whose IMPLIED cut-off contradicts our declared value is a distinct named signal
(not a generic mischarge BREAK); replay rides the Spine as-is.

### R9-B2 (regulatory-reporter) — the SEFP right-endpoint set omits CANCELLATION
RTS 2018/1229: SEFP accrues until actual settlement OR CANCELLATION of the instruction.
The fold enumerates only settlement and buy-in — yet the design's own cancel-and-
re-instruct routinely cancels a FAILING instruction. The old reference's window then
never closes: REF-001 fails Wed+Thu, cancelled Fri (re-instructed as REF-002) ⇒ correct
advice caps REF-001 SEFP at $10,400; our fold keeps accruing $5,200/day past Friday ⇒
check-3 BREAKs a correct advice on every amended-while-failing trade.
**Fix (one line, data already recorded):** SEFP accrues over
[max(ISD, matching), min(settlement, buy-in, CANCELLATION)), exclusive; the old root
reference closes at its recorded cancellation; the successor accrues from its own ISD.

### R9-B3 (correctness-architect) — the minting rule is a FALSE BIJECTION vs the certified partial split
"One root reference = one CSD instruction = one unit" contradicts E4/N3 (held this same
round): the CSD auto-partial splits SO-1 → SO-1s + SO-1r, BOTH inheriting REF-001 (and
the inheritance is load-bearing — the penalty fold groups the fragment tree under one
root reference; per-split fresh references would break DS14). Enforced literally, the
minting door would REFUSE the certified split.
**Fix (one sentence):** state it as a FUNCTION, not a bijection — each unit's legs belong
to exactly ONE CSD instruction (unit → one root reference); a reference carries multiple
units only via the certified partial split. R8-B1's mixed-case argument (legs spanning
two instructions ⇒ two units) survives verbatim; only the injective half was wrong.

## Non-blocking carries for the .tex
1. (regulatory-reporter) Row 15's reference price = PER-BUSINESS-DAY close (say it;
   prices move across a multi-day fail). Row-16 net keys per (participant, CURRENCY,
   period) — multi-currency mints one penalty unit per currency.
2. (sbl-specialist) The mixed-case net decomposition (FoP + cash return) presumes
   SETTLEMENT NETTING (ISLA Clause Library outcome); under gross settlement it re-forms
   as DvP-70 + cash compensation — both conserve identically. The netting mode rides a
   DECLARED TERM, not a universal assumption, else a gross-settling counterparty
   mis-matches.
3. (nazarov, carried from R9-B1's context) The matching timestamp stays CSD-asserted
   single-source, honestly inside the named TA-CUSTODY residual (already stated in r8 —
   keep it through the .tex).

## Convergence note
Round 10 is the cap. All three breaks are STATEMENT fixes to machinery whose mechanisms
all seven have now individually verified: no reviewer contests any mechanism, only how
three facts are stated/typed/enumerated. The four approvers this round red-teamed the
heaviest new surfaces (four-quadrant totality, atomicity, CDM images, SBL netting) and
found nothing. Expected: adopt all three verbatim + the carries, and Round 10 converges.
