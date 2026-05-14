# MATLAB Codes

## Melnikov_Observability.m

This is the single main script that reproduces **all numerical results and figures** in the paper.

### Requirements
- MATLAB R2021b or later (R2024b recommended)
- No additional toolboxes required
- Standard functions used: `spline`, `semilogy`, `svd`, `stairs`, `linspace`, `find`, `xline`

### How to Run

```matlab
% From the repository root:
cd('MATLAB_Codes')
run('Melnikov_Observability.m')
```

Or open `Melnikov_Observability.m` in MATLAB and press **Run** (F5).

### What the Script Produces

**Console output:**
- Verification table: σ₁(W_o), σ₂(W_o), rank at all 6 paper data points
- ε† = 0.1180, ε* = 0.1700, Gap = 30.59%
- Tolerance sensitivity test: ε† ∈ [0.114, 0.123] for tol ∈ {10⁻², 5×10⁻³, 10⁻³}
- Perturbed case validation: ε† = 0.1190 under 5% data scaling

**Figures (saved as PDF in the current directory):**

| Output file                        | Figure in paper | Description                          |
|------------------------------------|-----------------|--------------------------------------|
| Fig1_obs_sigma_vs_epsilon.pdf      | Figure 1        | σ₁, σ₂ of W_o vs ε — phase diagram  |
| Fig2_comparative_sensitivity.pdf   | Figure 2        | σ_min(W_o) vs σ_min(W_c) comparison |
| Fig3_obs_rank_vs_epsilon.pdf       | Figure 3        | rank(W_o) staircase transition       |
| Fig4_log_decay_sigma_min.pdf       | Figure 4        | log-scale σ_min decay near ε†        |

All figures use Times New Roman font and 600 DPI PDF vector output, ready for journal submission.

### Script Structure

| Section | Description |
|---------|-------------|
| Section 1 | Paper data: 6 Gramian singular value pairs |
| Section 2 | Dense spline grid (301 points on [0, 0.30]) |
| Section 3 | ε† identification via threshold crossing |
| Section 4 | Gramian rank computation (monotone enforced) |
| Section 5 | Verification table printout |
| Figure 1  | σ₁, σ₂ vs ε with data markers |
| Figure 2  | Comparative observability vs controllability |
| Figure 3  | Rank vs ε (staircase) |
| Figure 4  | Log-scale σ_min decay |
| Step-2    | Tolerance sensitivity test |
| Step-3    | Perturbed case (5% scaling) validation |

### Verified Output

The expected console output is given in the repository root `README.md` and also in:

```
../MATLAB_Outputs/MATLAB_Output_Values_Melnikov-Based_Observabilit.txt
```

All values match the paper exactly:
- ε† = 0.1180 ✅
- ε* = 0.1700 ✅  
- Gap = 30.59% ✅
- Perturbed ε† = 0.1190 ✅
- Tolerance interval [0.114, 0.123] ✅
