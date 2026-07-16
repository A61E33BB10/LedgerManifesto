# S1 — CARTAN: Architecture charter for `ledgerentropy.tex`

**Seminar: Ledger Entropy — Session 1 (independent formalization).**
Exploratory, non-normative. A negative result is a successful outcome. This memo fixes the
*architecture only*; it settles no mathematics and binds no design.

---

## 1. Setting — definition sequence (dependency order, one sentence each)

The Setting section introduces exactly these ten objects, in this order, each in one
sentence, no forward references. Prerequisites assumed: finite-dimensional Gaussians, `log det`,
KL divergence — nothing beyond a strong undergraduate.

1. **Log** `L` — a finite append-only sequence of admitted events, ordered by admission.
2. **Event** `e_i` — one admitted record appended to the log at position `i`.
3. **Observed-value event** — an event that carries a numerical reading `y_i ∈ ℝ^{d_i}` together with its accuracy layer `p_i > 0`.
4. **Noise model** — the assumption `y_i = A_i x + ε_i` with `ε_i ∼ N(0, p_i^{-1} I)`, independent across events, and `A_i` a fixed observation map.
5. **Candidate-log configuration** — a finite log together with its fixed noise model and prior, i.e. the complete data on which any functional is evaluated.
6. **True state** `x ∈ ℝ^n` — the unobserved vector of which the events are noisy readings.
7. **The fold as a measurable map** — the map `fold : configurations → (μ, Σ)` sending a configuration to its posterior parameters, measurable in the observations `(y_i)`.
8. **The posterior** — the Gaussian law `N(μ, Σ)` on the true state induced by the noise model and prior via `fold`.
9. **Attestation** — a refinement of an observed-value event that raises its accuracy `p_i` (equivalently, shrinks its noise), leaving `A_i` fixed.
10. **The constraint subspace** `V ⊆ ℝ^n` — the affine subspace on which conserved quantities are fixed, so the posterior is supported on `V` (its ambient covariance is rank-deficient).

A single **notation table** is fixed at the end of Setting: `L, e_i, y_i, p_i, A_i, x, μ, Σ, V, H(·)` (differential entropy), `D(·‖·)` (KL). No symbol is introduced anywhere else.

## 2. Candidate definitions and the six-criteria table

Three candidates, defined once, evaluated against six columns. Verdict vocabulary is exactly
**three symbols**: **✓** holds unconditionally; **✗** fails, and a counterexample is named in
Results; **◐** holds only under a stated side-condition, named in a footnote.

| Column | Precise meaning (a candidate earns ✓ only if…) |
|---|---|
| **well-posed** | finite and uniquely fixed by the configuration, with no arbitrary reference the configuration does not supply |
| **invariant** | unchanged under the admissible group: event reordering, orthogonal change of state coordinates, and change of unit scale |
| **compositional** | its value on the concatenation of two independent sub-logs is a fixed function (ideally the sum) of its values on the parts |
| **attestation-monotone** | raising any `p_i` moves it weakly in one fixed direction |
| **conservation-compatible** | finite and meaningful when the posterior is supported on a proper `V` (degenerate ambient `Σ`) |
| **computable** | evaluable in closed form from `(μ, Σ)` in polynomial time (`log det`, inverse) |

- **E1 — posterior differential entropy:** `H = ½ log det(2πe Σ)`.
- **E2 — information gain (relative entropy):** `D(posterior ‖ prior)`, the KL from prior to posterior.
- **E3 — subspace log-precision:** `½ log det(Σ|_V^{-1})`, the log-determinant of posterior precision restricted to the free directions of `V`.

Anticipated shape of the table (to be *proved*, not assumed, in Results): E1 fails **invariant**
and **conservation-compatible**; E2 is ✓ across the board except **well-posed** (◐: needs a prior);
E3 repairs conservation but is ◐ on **invariant** (reference-dependent scale).

## 3. Page budget (hard cap 5; worked example protected)

| Section | Pages |
|---|---|
| Non-normative banner + The Question | 0.4 |
| Setting | 1.0 |
| Candidate Definitions + six-criteria table | 1.0 |
| Results | 0.75 |
| **Worked Example (protected — do not compress)** | 0.75 |
| Verdict | 0.30 |
| Open Questions and Related Work | 0.40 |
| Declaration | 0.20 |
| **Total** | **4.80** |

If overflow occurs, absorb it from Setting and Related Work; the Worked Example is inviolate.

## 4. The three committee-note failures, and the guard for each

1. **Symbol drift between sections** (`Σ` vs `C`, `p_i` vs `τ_i`, `H` vs `S`).
   *Guard:* one frozen notation table in Setting, mirrored by LaTeX macros in the preamble;
   every symbol is a macro, none is typed literally, and a final diff pass confirms no section
   introduces a symbol absent from the table.
2. **The toy example using different numbers from the Results hypotheses.**
   *Guard:* the Worked Example opens by naming the exact Results proposition it instantiates and
   tabulating each numeric binding against that proposition's symbols; the example uses the same
   `n`, same `A_i`, same prior — a checker verifies each binding satisfies the hypothesis.
3. **The Verdict restating instead of deciding.**
   *Guard:* the Verdict contains exactly one sentence of the form *"‘Ledger entropy’ does not make
   sense because E1 fails {invariant, conservation-compatible}; the functional that does is E2
   (information gain),"* naming failing criteria and the chosen functional by their table labels,
   with no new symbol. A Verdict with no named failing criterion is rejected.

## 5. Skeleton `ledgerentropy.tex` for the chair

```latex
\documentclass[11pt]{article}
\usepackage[margin=1in]{geometry}
\usepackage{amsmath,amssymb,amsthm,mathtools}
\usepackage{booktabs}
\usepackage{enumitem}
\usepackage[hidelinks]{hyperref}

\theoremstyle{definition}\newtheorem{definition}{Definition}
\theoremstyle{plain}\newtheorem{theorem}{Theorem}
  \newtheorem{proposition}{Proposition}\newtheorem{lemma}{Lemma}
\theoremstyle{remark}\newtheorem{remark}{Remark}

% ---- FROZEN NOTATION: single source of truth (guard 1). Never type a symbol literally. ----
\newcommand{\Log}{L}                 % log
\newcommand{\ev}{e}                  % event
\newcommand{\obs}{y}                 % observed value
\newcommand{\st}{x}                  % true state
\newcommand{\acc}{p}                 % accuracy layer  (NB: never redefine \prec)
\newcommand{\Amap}{A}                % observation map
\newcommand{\mean}{\mu}              % posterior mean
\newcommand{\cov}{\Sigma}            % posterior covariance
\newcommand{\Vsub}{V}                % constraint subspace
\newcommand{\Ent}{H}                 % differential entropy (E1)
\newcommand{\KL}{D}                  % relative entropy / information gain (E2)
\DeclareMathOperator{\fold}{fold}
\newcommand{\Rn}{\mathbb{R}^{n}}
\newcommand{\Ncal}{\mathcal{N}}

\title{Ledger Entropy: Does an Entropy of the Log Exist?}
\author{Ledger Entropy Seminar}
\date{\today}

\begin{document}
\maketitle

\begin{center}\fbox{\parbox{0.95\linewidth}{\small\textbf{Non-normative.}
This note is an exploratory seminar work product. It states no requirement, binds no design,
and amends no part of the specification or the Constitution. A negative result is a successful
outcome.}}\end{center}

\section{The Question}          % 0.4 pp incl. banner
% Does a "ledger entropy" of an observed-value log make sense? If not entropy, what functional?

\section{Setting}               % 1.0 pp
% Definitions 1--10 in dependency order, one sentence each; close with the notation table.

\section{Candidate Definitions} % 1.0 pp
% E1 posterior differential entropy; E2 information gain; E3 subspace log-precision.
% Six-criteria table: columns well-posed/invariant/compositional/attestation-monotone/
% conservation-compatible/computable; verdicts in {\checkmark, \times, \newmoon(=half)}.

\section{Results}               % 0.75 pp
% One proposition per non-obvious table cell; each \times cell carries a named counterexample.

\section{Worked Example}        % 0.75 pp -- PROTECTED, do not compress.
% Opens by naming the Results proposition it instantiates; tabulates numeric bindings to its
% symbols; same n, same A_i, same prior as the hypotheses.

\section{Verdict}               % 0.30 pp
% Exactly one decision sentence: names failing criteria and the chosen functional by table label.

\section{Open Questions and Related Work} % 0.40 pp

\section{Declaration}           % 0.20 pp
% Authorship, independent-verification signature, non-normative restatement.

\end{document}
```
