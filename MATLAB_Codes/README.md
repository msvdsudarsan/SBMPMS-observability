# MATLAB Codes

## Melnikov_Observability.m

This is the main script that reproduces the numerical results and
the figure in Section 9 of the paper, **by direct integration of
eq. (14)**. It does not hard-code any output values.

### Requirements
- MATLAB R2021b or later (R2026a used for the reported results)
- No additional toolboxes required
- Standard functions used: `ode45`, `lsqminnorm`, `svd`, `trapz`-style
  quadrature, `linspace`, `plot`

### How to Run

```matlab
% From the repository root:
cd('MATLAB_Codes')
run('Melnikov_Observability.m')
```

Or open `Melnikov_Observability.m` in MATLAB and press **Run** (F5).

### What the Script Does

For each requested `eps`, the script:
1. Solves the algebraic constraint on `x3, x4` independently at
   every integration step (it does **not** assume the reduction
   `x3 = x4 = 0` in advance -- if that reduction were wrong for a
   given `eps`, this script would show nonzero `x3, x4`).
2. Integrates the resulting 2-dimensional reduced system with
   `ode45` for each of the two initial-condition columns needed to
   build the state-transition matrix.
3. Assembles the observability Gramian `W_o` by trapezoidal
   quadrature and reports its singular values.

**Console output:**
- A verification table of `sigma1(W_o)`, `sigma2(W_o)`, and rank at
  the paper's six `eps` values.
- An extended sweep over `eps in [-1, 2]` checking whether the
  system loses rank anywhere in that wider range (it does not).

**Figure (saved as PDF in the current directory):**

| Output file                        | Figure in paper | Description                          |
|------------------------------------|-----------------|--------------------------------------|
| Fig1_obs_sigma_vs_epsilon.pdf      | Figure 1        | sigma1, sigma2 of W_o vs eps          |

Earlier drafts of this repository also produced three additional
figures (a comparative observability-vs-controllability sensitivity
plot, a rank-vs-eps staircase, and a log-scale decay plot). Those
were built around a fabricated breakdown threshold and have been
removed from both the script and the manuscript; see the note in
`../MATLAB_Outputs/MATLAB_Output_Values_Melnikov-Based_Observabilit.txt`
for the full history.

### Cross-Check

The same computation is implemented independently in Python/SciPy
(`verify_observability.py` in this folder). The two implementations
agree to four decimal places at every tested `eps`.
