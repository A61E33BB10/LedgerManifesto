---
name: spec-unitstatus-wording
description: UnitStatus canonical verbatim block, its tagged sites, and dash-spacing variance
metadata:
  type: project
---

Canonical UnitStatus wording (must appear verbatim at every cached-state site):

> UnitStatus holds one value per unit, shared --- read identically by every holder. Its value changes over time, but UnitStatus is not a separate source of truth: the immutable event log is. Every change is caused by a logged event; the stored value is overwritten in place only as a read cache. Replaying the events up to any point rebuilds the exact value that held then, so nothing is lost by overwriting and there is no other way to change the value. A value exists from registration onward.

**Sites verified present (words verbatim):** sec03, sec04 (canonical home, §sec:sec04-unitstatus), sec06, sec07, sec08, sec09, sec10, sec11, sec13, sec15, sec16, sec20, appB, appE. §14 adapts it for the *obligation store* ("Obligation state holds one value per obligation..."); §12 and appI adapt it for settlement status. These adaptations are intentional and consistent with the discipline.

**Why:** Coverage map requires the correction reach every mutable-dictionary site or cache/log drift is re-admitted.

**How to apply:** Words are verbatim everywhere — PASS. Only variance is em-dash spacing: canonical is "shared --- read" (spaces); most sites use "shared---read" (no spaces). Rendered output is identical (both are em-dash); treat as cosmetic, not a verbatim violation. Normalise to spaced form only if doing a typographic pass.
