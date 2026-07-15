---
name: spec-gloss-convention
description: House style for glossing categorical/Haskell jargon at first use; known bare spots
metadata:
  type: project
---

House gloss style: a categorical term is followed by an em-dash appositive in plain words, e.g. "a catamorphism---meaning replaying the events always rebuilds the exact value"; "a group homomorphism---a structure-preserving map, here meaning..."; "forgetful: it drops the legal detail the ledger does not track". Forward-introduced types get a one-line meaning plus a pointer: §3 introduces ProductTerms/PositionState/UnitStatus with one-line descriptions and "(Section~\ref{sec:sec04})".

**Why:** Clarity gate requires every categorical term glossed in plain words at first use (document order).

**How to apply:** Well-glossed: catamorphism, homomorphism, monoid/foldMap, free monoid, forgetful map F, monotone carrier (sec04:260), Option accessor (sec04), telescoping. "monadic left-fold" (sec04:489) is OK — surrounding prose explains it; do NOT flag.

ROUND 2 (2026-06-28) RESOLVED — all three prior gloss gaps now fixed in source, do NOT reflag:
- "Kleisli" — sec08:589 now reads "a Kleisli fold (an error-stopping fold whose combining step halts at the first failure)". RESOLVED.
- "GADT" — sec04:375 now reads "a GADT (a generalised algebraic data type, in which each constructor fixes its own type index)". RESOLVED.
- "saga" — sec16:417 now reads "a saga---a long-running workflow split into steps, each with a compensating action that undoes it on failure". RESOLVED.

ROUND 5 coordinate-abbreviation legend gap — ROUND 6 (2026-06-28) RESOLVED, do NOT reflag: legends now precede the first abbreviated table in both files. sec16:399 reads "Columns abbreviate the coordinates: onl = onloan, c\_p = coll\_post, c\_r = coll\_recv, c\_rh = coll\_rehyp; avail = own − onl + borr is the read projection." (table at 402). appI:54 reads "...abbreviated own, onl, borr, c\_p, c\_r, c\_rh." (table at 57). appG:8/13 and appH:25 also define them. CONSISTENT.

NAV/VM/HWM/CSA/UTI/LEI/CCP/CSD are unexpanded but FINE — do NOT flag: domain-standard finance acronyms, audience is subject experts; house gloss style targets categorical/Haskell jargon only. VM symbol (sec08:88) has "variation margin" full form earlier at sec08:12. CSA/UTI/LEI/CCP are NEVER expanded anywhere (consistent, intentional).

DvP (ROUND 4, 2026-06-28) RESOLVED by STYLUS: doc DEFINES DvP (sec12:154 "Delivery versus Payment (DvP) is the principle...") and spells it out at sec08:530 + sec20:19, but used the bare acronym first at sec01:76 — a define-after-use gap. FIXED at sec01:76: "real-world delivery-versus-payment (DvP)". FoP is fine: expanded "Free of Payment" at first prose use sec12:108 (code constructors precede it but the gloss follows in the same section). DvP was the ONLY self-defined-late acronym; do NOT reflag.

See also [[spec-house-spelling]] for P&L/tokenized/GMSLA identifier+spelling deviations found same round.
