# jane-street-cto — States.tex, Round 12

**Verdict: NOT-YET.**

The design and the code are right. I checked the substance hard and found no
logical gap, no listing/prose mismatch, and no surviving overclaim. What blocks
OBVIOUS is navigation: the document defers its proofs by cross-reference, and two
load-bearing references point at a section that does not contain the substantiation.
A fresh reader who follows them will not find what was promised, and will write a
margin note. In a deductive spec whose whole method is "state once, reference
elsewhere," a wrong reference reads as a missing proof.

## What is right (so this is not a substance complaint)

- The 2×2 (holder-dependence × authorship) sorts cleanly; three cells occupied, the
  fourth argued empty with the managed-account counterexample disarmed by reframing
  it as a `(client, mandate-unit)` position. Sound.
- Listings match the prose throughout. `register` refuses duplicates; `settle`
  adjusts only the status half via `Map.adjust` over `snd`; `appendVersion` appends
  at the end and `currentTerms = NE.last`; `applyMove` writes two cancelling legs and
  skips zero-net rows. All correct.
- Self-move and zero-quantity move both net to `mempty` and write no row; "held =
  named in a move that nets nonzero" is consistent with the `position` Maybe semantics
  (Nothing = never held, Just-zero = held and flat). They thought it through.
- Conservation is argued honestly as a *writer* invariant plus the seal, not as a type
  invariant — the doc explicitly concedes the store type "can hold a non-conserving
  assignment." No overclaim in "by construction": it is qualified where it matters.
- `foldM`-split / checkpointing claim is a real monad law and holds. `apply` is total
  in the Maybe sense (all three constructors covered, failure reflected as `Nothing`,
  `Integer` unbounded).

## Residue (located, actionable)

1. **Line 103 — misdirected cross-reference.** "...they ride together as a pair — a
   third home, a third kind of state, not a third map (§ref{sec:right})." The claim
   that the pair is *not a third map* is substantiated in **§The Construction**, the
   "three homes, two maps" paragraph (lines 249–269, esp. 250–251 co-presence as the
   shape of the map, and 259–260 "the seal no longer carries coherence — the pair
   does"). §Why It Is Right (sec:right) contains only Conservation and Deterministic
   replay; it never argues pair-not-map. A reader flipping to §right finds nothing on
   point. Repoint to §The Construction.

2. **Line 217 — misdirected cross-reference.** "...`register`, the one writer that lays
   down version one, refuses a unit already present (§ref{sec:right})." §right mentions
   `register` only as "touches only `ledgerUnit`, never `psBal`"; it does not restate
   the duplicate-refusal or its append-only consequence. The refusal is *shown* in §The
   Construction (the `register` listing, lines 284–288) and its history-preservation
   purpose is argued in §Why Three (terms paragraph, lines 126–141). Repoint to one of
   those.

3. **Line 161 — §The Construction carries no `\label`.** This is the section that
   actually constructs the homes, the maps, and the writers, and is the natural target
   for the two references above (and for any future "where is this built?" pointer). It
   cannot currently be cited. Add a label, then fix (1) and (2) to target it.

## Not residue (checked, deliberately not withheld)

- `psHwm`: an inert field (always `mempty`, no in-scope writer, no invariant, no
  aggregate). Against the Minimalism principle this invites a "why is this here?"
  question — but the text pre-answers it at lines 234–239 and 358 ("non-conserved field
  beside the conserved balance, writer out of scope, stays zero here"). The *code* is
  fully understandable without knowing what a high-water mark is; the field's role is
  stated. Adequately flagged; not a comprehension blocker.
- `TermsVersion = TermsVersion String`: terms collapsed to an opaque string. Acceptable
  — the point is the container discipline (`NonEmpty`, append-only), declared as a slice.

## Bottom line

Fix the two cross-references and label §The Construction. With the deferred proofs
resolving where they claim to, the document clears the bar. Until then a fresh reader
hits a reference that does not deliver and annotates — which is exactly the failure the
"no commentary" standard names.
