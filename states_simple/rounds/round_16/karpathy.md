# KARPATHY review — States.tex, Round 16

Verdict: NOT-YET (one located, actionable residue).

## What is obvious (and genuinely good)

The spine reads in one pass and earns its conclusion:

- The two-question framing (holder-dependent? / who authors?) yields a clean
  2x2, and the partition of keys into {unit} vs {(holder, unit)} is argued, not
  asserted: wallet-alone facts are excluded as identity, wider keys are excluded
  by the reification premise.
- The premise (every relationship is a unit) is flagged as proved for one
  mandate and *assumed* for the multi-instrument case. This is a declared
  boundary, not a hidden leap; the reader sees exactly what rests on it. I do
  not count it as residue.
- The three "why" reasons (buyer/seller differ; one settlement number read
  identically; two change disciplines cannot share one value) are each concrete
  and sufficient. The empty-fourth-cell argument plus the managed-account
  counterexample is convincing.
- The construction is deductive: Qty group -> keys -> status (price rides on
  Active, illegal states unspellable) -> NonEmpty terms -> Ledger pair under one
  key -> register/settle/applyMove. I checked the code: applyMove nets per
  wallet before writing, self-move and zero-move collapse to mempty and write no
  row, the two legs cancel, the seal closes the back door. Conservation and
  deterministic-replay arguments hold.

## The residue (blocker for single-pass obviousness)

Location: section "The Construction", paragraph "A position carries more than a
balance." (States.tex, lines ~221-234), the psHwm exposition.

Blocker: this is the one paragraph that forces backtracking, and it does so
because it withholds the single concrete fact that would make psHwm obvious.

1. It never says what a high-water mark *is* or why it fails to conserve. It
   says only that "what a high-water mark measures ... is fixed by its writer ...
   out of scope here." So a reader meeting psHwm for the first time is told it
   does not conserve and is asked to accept that on faith — the very "leap" the
   bar forbids. (Notably, States.hs lines 374 and 580 give the missing anchor:
   "it ratchets up and is kept for tax reporting even after the position closes."
   That one clause makes non-conservation self-evident. The .tex dropped it.)

2. It reverses itself mid-stream: "psHwm is typed Qty ... but the file leans on
   none of Qty's group structure for it." The reader first accepts Qty, then has
   to walk it back, then is left wondering why Qty was chosen — answered only by
   the vague "matching the source."

3. It restates its conclusion ("stays zero in this file" / "Its writer out of
   scope, psHwm stays zero in this file"), so the reader re-reads to check the
   two statements are the same point, not two.

Net effect: an inert field, present for a real reason (to witness the
non-conserved per-(holder, unit) fact named in the Position cell), is justified
by an abstract, self-reversing, repetitive paragraph instead of by its purpose
stated result-first. This collides with the document's own promise that each
piece is "forced by the one before" — psHwm is not forced; it is illustrative,
and the prose hides that rather than owning it.

Fix (actionable): lead with purpose and the concrete anchor — "the Position
cell holds one non-conserved fact too, the high-water mark: a peak that ratchets
up and is retained after close-out for tax. psHwm witnesses it. Its writer (a
valuation event) is out of scope, so here it stays zero." Then state the Qty
typing once ("a high-water mark is a quantity, so Qty; nothing here leans on its
group structure"), without the mid-sentence reversal and without the second
"stays zero." That removes the only backtrack on the page.
