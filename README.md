# SBMPMS-observability

## Melnikov-Based Observability Breakdown in Singular Bilinear Periodic Matrix Differential Systems
DOI: https://doi.org/10.5281/zenodo.20196743

**Authors:**
Sri Venkata Durga Sudarsan Madhyannapu¹ and Sravanam Pradheep Kumar²

¹ Department of Mathematics — School of Sciences, Humanities and Management, Dr. RVR NRI Institute of Technology (Deemed to be University),
Pothavarappadu Village, Agiripalli Mandal 521212, Vijayawada Rural, Andhra Pradesh, India.
Email: msvdsudarsan@gmail.com · ORCID: [0009-0001-2126-6428](https://orcid.org/0009-0001-2126-6428)

² School of Basic Sciences, SRM University AP, Neerukonda, Mangalagiri, Guntur 522240, Andhra Pradesh, India.
Email: sravanampradheepkumar@gmail.com

**Target Journal:** [Chaos, Solitons and Fractals](https://www.sciencedirect.com/journal/chaos-solitons-and-fractals) (Elsevier) · IF 5.3 · Q1 · SCI/SCIE

**Status:** Under revision — August 2026

---

## A note on this revision

An earlier version of this repository and the accompanying manuscript
reported, for the worked example in Section 9 (eq. 14), a rank-collapse
threshold ε† ≈ 0.118 and a 30.59% gap relative to the companion
controllability paper's threshold. Those numbers did not reproduce
under direct numerical integration of eq. (14) — the script that
produced them did not actually integrate the system; it fit a spline
through six hard-coded literals with no identified source. Both the
manuscript and this repository have been corrected: eq. (14) is kept
exactly as originally stated, `Melnikov_Observability.m` now computes
everything directly from it, and Section 9 of the manuscript has been
rewritten to report what that direct computation actually shows (see
below). The theoretical results (Sections 3–7) do not depend on this
specific numerical instance and are unaffected.

---

## Abstract

Singular bilinear periodic matrix systems subject to Melnikov-type oscillatory forcing arise in chemical
reaction networks, constrained mechanical systems, and biological oscillator monitoring. This paper
addresses a fundamental question: at what critical forcing amplitude does the ability to reconstruct the
internal state from sensor output fail irreversibly?

We introduce the **Singular Bilinear Melnikov Periodic Matrix System for Observability (SBMPMS-O)**
and establish four results:

1. A second-order perturbation expansion of the observability Gramian W_o(0,T;ε) with **Kronecker-free** coefficient matrices
2. A critical **observability rank-loss** threshold ε† with a closed-form sufficient lower bound — the minimum singular value of W_o acts as an order parameter for a codimension-one rank bifurcation, for systems in this class that attain the threshold
3. A Kalman–Hewer observability equivalence theorem valid for |ε| < ε†, with proved failure for |ε| > ε†
4. A controllability–observability duality identifying a **blind control regime** ε† < |ε| < ε* where the system remains steerable yet two distinct state trajectories produce identical sensor outputs

**Key numerical results (worked example, eq. 14):**
- Directly integrating eq. (14) gives σ₁(W_o⁽⁰⁾) = 1.4353, σ₂(W_o⁽⁰⁾) = 0.0327 at ε = 0
- Over ε ∈ [0, 0.25] (and, in an extended check, ε ∈ [−1, 2]), σ₂ stays well clear of zero and grows mildly with ε — this instance does **not** exhibit an observability breakdown threshold
- Confirmed to 4 decimal places by two independent implementations (MATLAB R2026a and Python/SciPy)
- Kronecker-free O(Nn³) algorithm: **481×** measured speedup at n = 8 (feasible for direct Kronecker comparison), extrapolated to **105,800×** at n = 50 based on the proven complexity ratio

---

## Repository Structure

```
SBMPMS-observability/
│
├── README.md                                              ← This file
├── CITATION.cff                                           ← Citation metadata (CFF 1.2.0)
├── LICENSE                                                ← MIT License
│
├── MATLAB_Codes/
│   ├── Melnikov_Observability.m                           ← Main script (direct integration, no hard-coded values)
│   ├── verify_observability.py                            ← Independent Python/SciPy cross-check
│   └── README.md                                          ← How to run
│
├── MATLAB_Outputs/
│   └── MATLAB_Output_Values_Melnikov-Based_Observabilit.txt  ← Verified console output, with provenance note
│
└── Figures/
    └── Fig1_obs_sigma_vs_epsilon.pdf         ← σ₁, σ₂ vs ε, directly computed
```

Three figures present in an earlier version of this repository
(comparative observability-vs-controllability sensitivity, a rank
staircase, and a log-scale decay plot) have been removed: each was
built to illustrate a threshold crossing that this instance does not
exhibit. See the provenance note in `MATLAB_Outputs/` for details.

---

## Numerical Results Summary

### Observability Gramian, direct integration of eq. (14)

| ε    | σ₁(W_o) | σ₂(W_o) | Rank | Observable? |
|------|---------|---------|------|-------------|
| 0.00 | 1.4353  | 0.0327  | 2    | ✅ Yes       |
| 0.04 | 1.4539  | 0.0331  | 2    | ✅ Yes       |
| 0.08 | 1.4729  | 0.0335  | 2    | ✅ Yes       |
| 0.12 | 1.4923  | 0.0339  | 2    | ✅ Yes       |
| 0.18 | 1.5220  | 0.0345  | 2    | ✅ Yes       |
| 0.25 | 1.5578  | 0.0352  | 2    | ✅ Yes       |

This instance remains full rank throughout the tested range, and an
extended sweep to ε ∈ [−1, 2] shows the same pattern with no rank
collapse observed. The algebraic rank-loss criterion
(Theorem 4.6 in the manuscript) and the threshold bound (Theorem 4.3)
remain general results about the SBMPMS-O system class; this instance
simply does not satisfy the conditions under which a threshold is
attained. Constructing and verifying an instance that does attain the
threshold is identified in the manuscript as necessary follow-up work.

### Algorithm Scalability

| n  | Algorithm 1  | Classical (Kronecker)  | Speedup        | Basis |
|----|-------------|-------------------------|----------------|-------|
| 4  | measured    | measured                | 59×            | measured |
| 8  | measured    | measured                | **481×**       | measured |
| 16 | measured    | projected               | ~1,200×        | complexity-based projection |
| 50 | measured    | infeasible              | ~105,800×      | complexity-based projection (O(Nn³) vs O(Nn⁶)) |

Only Algorithm 1's own running time is measured for n > 8; the
Kronecker-baseline figures and all n > 8 comparisons are projections
from the proven complexity bounds, not benchmark runs, per the
manuscript's response to Reviewer #2 (Comment 8).

---

## How to Reproduce All Results

### MATLAB
```matlab
cd('MATLAB_Codes')
run('Melnikov_Observability.m')
```

### Python cross-check
```bash
python3 MATLAB_Codes/verify_observability.py
```

Both compute everything directly from eq. (14); neither reads or
depends on any hard-coded output value.

---

## System Definition

The SBMPMS-O is governed by:

```
E·Ẋ(t) = A(t)X(t) + X(t)B(t) + ε·G(t)sin(ωt+φ)·X(t)
Y(t)   = C(t)·X(t)
```

where:
- `E ∈ ℝⁿˣⁿ` singular, rank(E) = r < n (index-one pencil)
- `ε·G(t)sin(ωt+φ)` is the Melnikov-type multiplicative perturbation
- `Y(t)` is the measured sensor output

**Physical meaning of breakdown, for a system that attains ε > ε†:**
Two trajectories X(t) and X̃(t) = X(t) + α·η differ only in the unobservable direction η
yet produce identical outputs Y(t) = Ỹ(t) for all t.
No observer can distinguish them — any Kalman filter accumulates unbounded silent estimation error.
This mechanism is established at the level of the general theorems; the worked example in this
repository illustrates the surrounding machinery (Gramian expansion, Algorithm 1) but does not
itself reach this regime.

---

## Key Theoretical Results

### Theorem 1 — Gramian Expansion
```
W_o(0,T;ε) = W_o⁽⁰⁾ + ε·W_o⁽¹⁾ + ε²·W_o⁽²⁾ + O(ε³)
```

### Theorem 2 — Critical Threshold (sufficient condition)
```
ε† ≥ σ_min(W_o⁽⁰⁾) / (‖W_o⁽¹⁾‖ + ‖W_o⁽²⁾‖)
```
σ_min(W_o) is the order parameter; ε† is the codimension-one bifurcation point for systems that attain it.

### Theorem 3 — Kalman–Hewer Equivalence
- |ε| < ε†: Kalman ⟺ Hewer observability (equivalent)
- |ε| > ε†: Kalman observability fails; Hewer may persist

### Theorem 4 — Blind Control Duality
Blind control regime ε† < |ε| < ε*:
system is controllable but not observable, for systems in this class that attain both thresholds.

---

## Applications

- **Chemical reaction networks:** identifies which species would become sensor-invisible above a system's ε†, where one exists
- **Constrained mechanical systems:** detects unrecoverable elastic strain modes
- **Biological oscillators:** flags unmeasurable protein concentrations in circadian models

---

## Companion Papers

| Paper | System Class | Journal | Status |
|---|---|---|---|
| [SBLIPMS-Controllability](https://github.com/msvdsudarsan/SBLIPMS-Impulse-KH-Controllability) | Singular bilinear + impulses | ISA Transactions | Resubmitted |
| [Bilinear-Matrix-Periodic-Controllability](https://github.com/msvdsudarsan/Bilinear-Matrix-Periodic-Controllability) | Generalised bilinear periodic | MCSS (Springer) | With Editor |
| **This paper** | Melnikov observability breakdown | Chaos, Solitons & Fractals | Under revision |

---

## Citation

```bibtex
@article{Madhyannapu2026melnikov_obs,
  author    = {Madhyannapu, Sri Venkata Durga Sudarsan and
               {Pradheep Kumar}, Sravanam},
  title     = {Melnikov-Based Observability Breakdown in Singular
               Bilinear Periodic Matrix Differential Systems},
  journal   = {Chaos, Solitons and Fractals},
  year      = {2026},
  publisher = {Elsevier},
  issn      = {0960-0779},
  note      = {Under revision}
}
```

See also [CITATION.cff](CITATION.cff) for machine-readable metadata.

---

## License

MIT License — see [LICENSE](LICENSE) for details.

---

## Contact

**Sri Venkata Durga Sudarsan Madhyannapu** (Corresponding Author)
Email: msvdsudarsan@gmail.com
ORCID: [0009-0001-2126-6428](https://orcid.org/0009-0001-2126-6428)
Institution: Dr. RVR NRI Institute of Technology (Deemed to be University), Andhra Pradesh, India
