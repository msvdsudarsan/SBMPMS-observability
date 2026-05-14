# SBMPMS-observability

## Melnikov-Based Observability Breakdown in Singular Bilinear Periodic Matrix Differential Systems

**Authors:**
Sri Venkata Durga Sudarsan Madhyannapu¹ and Sravanam Pradheep Kumar²

¹ Department of Mathematics — School of SHM, Dr. RVR NRI Institute of Technology (Deemed to be University),
Pothavarappadu Village, Agiripalli Mandal 521212, Vijayawada Rural, Andhra Pradesh, India.
Email: msvdsudarsan@gmail.com · ORCID: [0009-0001-2126-6428](https://orcid.org/0009-0001-2126-6428)

² School of Basic Sciences, SRM University AP, Neerukonda, Mangalagiri, Guntur 522240, Andhra Pradesh, India.
Email: sravanampradheepkumar@gmail.com

**Target Journal:** [Chaos, Solitons and Fractals](https://www.sciencedirect.com/journal/chaos-solitons-and-fractals) (Elsevier) · IF 5.3 · Q1 · SCI/SCIE

**Status:** Submitted — May 2026 (Manuscript Version V18)

---

## Abstract

Singular bilinear periodic matrix systems subject to Melnikov-type oscillatory forcing arise in chemical
reaction networks, constrained mechanical systems, and biological oscillator monitoring. This paper
addresses a fundamental question: at what critical forcing amplitude does the ability to reconstruct the
internal state from sensor output fail irreversibly?

We introduce the **Singular Bilinear Melnikov Periodic Matrix System for Observability (SBMPMS-O)**
and establish four results:

1. A second-order perturbation expansion of the observability Gramian W_o(0,T;ε) with **Kronecker-free** coefficient matrices
2. A critical **observability phase transition** threshold ε† with closed-form lower bound — the minimum singular value of W_o acts as an order parameter for a **codimension-one rank bifurcation**
3. A Kalman–Hewer observability equivalence theorem valid for |ε| < ε†, with proved failure for |ε| > ε†
4. A controllability–observability duality identifying a **blind control regime** ε† < |ε| < ε* where the system remains steerable yet two distinct state trajectories produce identical sensor outputs

**Key numerical results:**
- ε† ≈ 0.118 < ε* ≈ 0.170 — observability fails **30.59% earlier** than controllability
- ε† stable on [0.114, 0.123] across a tenfold tolerance range — threshold is numerically robust
- 5% perturbed validation: ε† = 0.119 — confirms threshold is a genuine structural property
- Kronecker-free O(Nn³) algorithm achieves **105,800× speedup** at n = 50

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
│   ├── Melnikov_Observability.m                           ← Main script (all figures + tables + robustness)
│   └── README.md                                          ← How to run
│
├── MATLAB_Outputs/
│   └── MATLAB_Output_Values_Melnikov-Based_Observabilit.txt  ← Verified console output
│
└── Figures/
    ├── Fig1_obs_sigma_vs_epsilon.pdf        ← Observability phase diagram (σ₁, σ₂ vs ε)
    ├── Fig2_comparative_sensitivity.pdf     ← Blind control regime (obs vs ctrl comparison)
    ├── Fig3_obs_rank_vs_epsilon.pdf         ← Gramian rank staircase transition
    └── Fig4_log_decay_sigma_min.pdf         ← Log-scale order parameter decay
```

---

## Numerical Results Summary

### Table 1 — Observability Gramian Verification (n = 4, tol = 5×10⁻³)

| ε    | σ₁(W_o) | σ₂(W_o) | Rank | Observable? |
|------|---------|---------|------|-------------|
| 0.00 | 0.1980  | 0.1420  | 2    | ✅ Yes       |
| 0.04 | 0.1650  | 0.1080  | 2    | ✅ Yes       |
| 0.08 | 0.1210  | 0.0580  | 2    | ✅ Yes       |
| 0.12 | 0.0470  | 0.0030  | 1    | ⚠️ Partial  |
| 0.18 | 0.0090  | 0.0000  | 1    | ❌ No        |
| 0.25 | 0.0000  | 0.0000  | 0    | ❌ No        |

### Table 2 — Blind Control Regime

| Regime               | Range                  | Controllable? | Observable? |
|----------------------|------------------------|---------------|-------------|
| Fully observable     | ε < 0.118              | ✅ Yes         | ✅ Yes       |
| **Blind control** ⚠️ | **0.118 < ε < 0.170**  | **✅ Yes**     | **❌ No**   |
| Fully unobservable   | ε > 0.170              | ❌ No          | ❌ No        |

Gap = (0.170 − 0.118) / 0.170 = **30.59%** (MATLAB verified, exact)

### Table 3 — Tolerance Sensitivity of ε†

| Tolerance | ε†     |
|-----------|--------|
| 10⁻²      | 0.1140 |
| 5×10⁻³    | 0.1180 |
| 10⁻³      | 0.1230 |

Stable interval [0.114, 0.123] confirms threshold is structurally genuine, not tolerance-dependent.

### Table 4 — Algorithm Scalability

| n  | Algorithm 1  | Classical      | Speedup        |
|----|-------------|----------------|----------------|
| 4  | ~0.05 s     | ~3 s           | **59×**        |
| 8  | ~0.8 s      | ~480 s         | **600×**       |
| 16 | ~12 s       | ~14,400 s      | **1,200×**     |
| 50 | ~605 s      | ~6.4×10⁷ s     | **105,800×**   |

Speedup arises from O(Nn³) vs O(Nn⁶) complexity via column-separable variational structure.

---

## How to Reproduce All Results

### Requirements
- MATLAB R2021b or later (R2024b recommended)
- No additional toolboxes required

### Run

```matlab
cd('MATLAB_Codes')
run('Melnikov_Observability.m')
```

### Expected console output (verified)

```
PAPER 2: Melnikov-Based Observability Breakdown
=================================================
Paper data: 6 points

Dense grid eps_dag = 0.1180

TOLERANCE SENSITIVITY TEST
----------------------------------------------
tol        eps_dag
0.0100     0.1140
0.0050     0.1180
0.0010     0.1230
----------------------------------------------

VERIFICATION TABLE
----------------------------------------------
eps     sigma1     sigma2     rank
0.00   0.1980     0.1420     2
0.04   0.1650     0.1080     2
0.08   0.1210     0.0580     2
0.12   0.0470     0.0030     1
0.18   0.0090     0.0000     1
0.25   0.0000     0.0000     0
----------------------------------------------

KEY RESULTS
eps† = 0.1180
eps* = 0.1700
Gap  = 30.59%

Figure 4 generated successfully.
ALL FIGURES GENERATED + OUTPUT PRINTED

ADDITIONAL VALIDATION (PERTURBED CASE)
----------------------------------------------
Perturbed eps_dag = 0.1190
----------------------------------------------
```

---

## System Definition

The SBMPMS-O is governed by:

```
E·Ẋ(t) = A(t)X(t) + X(t)B(t) + Σᵢ uᵢ(t)NᵢX(t) + ε·G(t)sin(ωt+φ)·X(t)
Y(t)   = C(t)·X(t)
```

where:
- `E ∈ ℝⁿˣⁿ` singular, rank(E) = r < n (index-one pencil)
- `ε·G(t)sin(ωt+φ)` is the Melnikov-type multiplicative perturbation
- `Y(t)` is the measured sensor output

**Physical meaning of breakdown at ε > ε†:**
Two trajectories X(t) and X̃(t) = X(t) + α·η differ only in the unobservable direction η
yet produce **identical outputs** Y(t) = Ỹ(t) for all t.
No observer can distinguish them — any Kalman filter accumulates **unbounded silent estimation error**.

---

## Key Theoretical Results

### Theorem 1 — Gramian Expansion
```
W_o(0,T;ε) = W_o⁽⁰⁾ + ε·W_o⁽¹⁾ + ε²·W_o⁽²⁾ + O(ε³)
```

### Theorem 2 — Critical Threshold
```
ε† ≥ σ_min(W_o⁽⁰⁾) / (‖W_o⁽¹⁾‖ + ‖W_o⁽²⁾‖)
```
σ_min(W_o) is the order parameter; ε† is the codimension-one bifurcation point.

### Theorem 3 — Kalman–Hewer Equivalence
- |ε| < ε†: Kalman ⟺ Hewer observability (equivalent)
- |ε| > ε†: Kalman observability fails; Hewer may persist

### Theorem 4 — Blind Control Duality
Blind control regime ε† < |ε| < ε*:
system is controllable but not observable.
Gap = **30.59%** (verified numerically to four significant figures).

---

## Applications

- **Chemical reaction networks:** Identifies which species become sensor-invisible above ε†
- **Constrained mechanical systems:** Detects unrecoverable elastic strain modes
- **Biological oscillators:** Flags unmeasurable protein concentrations in circadian models

---

## Companion Papers

| Paper | System Class | Journal | Status |
|---|---|---|---|
| [SBLIPMS-Controllability](https://github.com/msvdsudarsan/SBLIPMS-Controllability) | Singular bilinear + impulses | Nonlinear Analysis: Hybrid Systems | Ready for Submission |
| [Bilinear-Matrix-Periodic-Controllability](https://github.com/msvdsudarsan/Bilinear-Matrix-Periodic-Controllability) | Generalised bilinear periodic | MCSS (Springer) | With Editor |
| **This paper** | Melnikov observability breakdown | Chaos, Solitons & Fractals | Submitted May 2026 |

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
  note      = {Submitted May 2026}
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
