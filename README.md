# SBMPMS-observability

## Melnikov-Based Observability Breakdown in Singular Bilinear Periodic Matrix Differential Systems

**Authors:** Sri Venkata Durga Sudarsan Madhyannapu¹ and Sravanam Pradheep Kumar²

¹ Department of Mathematics — School of SHM, Dr. RVR NRI Institute of Technology (Deemed to be University), Pothavarappadu Village, Agiripalli Mandal 521212, Vijayawada Rural, Andhra Pradesh, India. Email: msvdsudarsan@gmail.com · ORCID: 0009-0001-2126-6428

² School of Basic Sciences, SRM University AP, Neerukonda, Mangalagiri, Guntur 522240, Andhra Pradesh, India. Email: sravanampradheepkumar@gmail.com

**Target Journal:** Chaos, Solitons and Fractals (Elsevier) · IF 5.3 · Q1 · SCI/SCIE · Hybrid (no mandatory APC)

**Status:** Submitted, April 2026

---

## Abstract

Singular bilinear periodic matrix systems subject to Melnikov-type oscillatory forcing arise in chemical reaction networks, constrained mechanical systems, and biological oscillator monitoring. This paper addresses a fundamental question: at what critical forcing amplitude does the ability to reconstruct the internal state from sensor output fail irreversibly?

We introduce the **Singular Bilinear Melnikov Periodic Matrix System for Observability (SBMPMS-O)** and establish four results:

1. A second-order perturbation expansion of the observability Gramian W_o(0,T;ε) with Kronecker-free coefficient matrices
2. A critical **observability phase transition** threshold ε† with closed-form lower bound — the minimum singular value of W_o acts as an order parameter that collapses to zero at ε†
3. A Kalman–Hewer observability equivalence theorem valid for |ε| < ε†
4. A controllability–observability duality identifying a **blind control regime** ε† < |ε| < ε* where the system remains steerable yet two distinct state trajectories produce identical sensor outputs

**Key numerical result:** ε† ≈ 0.118 < ε* ≈ 0.170 — observability fails **31% earlier** than controllability. A Kronecker-free O(Nn³) algorithm achieves **105,800× speedup** at n=50.

---

## Repository Structure

```
SBMPMS-observability/
│
├── README.md                                      ← This file
│
├── MATLAB_Codes/
│   └── Melnikov_Observability.m                   ← Main script: all figures + tables
│
├── MATLAB_Outputs/
│   └── MATLAB_Output_Values_Melnikov_Observability.txt  ← Verified output
│
├── Figures/
│   ├── Fig1_obs_sigma_vs_epsilon.pdf              ← Observability phase transition
│   ├── Fig2_comparative_sensitivity.pdf           ← Blind control regime visualization
│   ├── Fig3_obs_rank_vs_epsilon.pdf               ← Rank vs epsilon
│   └── Fig4_log_sigma_min.pdf                     ← Log-scale order parameter decay
│
├── CITATION.cff                                   ← Citation metadata
└── LICENSE                                        ← MIT License
```

---

## Numerical Results Summary

### Table 1 — Observability Gramian Verification (n=4)

| ε | σ₁(W_o) | σ₂(W_o) | Rank | Observable? |
|---|---|---|---|---|
| 0.00 | 0.1980 | 0.1420 | 2 | ✅ Yes |
| 0.04 | 0.1650 | 0.1080 | 2 | ✅ Yes |
| 0.08 | 0.1210 | 0.0580 | 2 | ✅ Yes |
| 0.12 | 0.0470 | 0.0030 | 1 | ⚠️ Partial |
| 0.18 | 0.0090 | 0.0000 | 1 | ❌ No |
| 0.25 | 0.0000 | 0.0000 | 0 | ❌ No |

**Observability phase transition:** ε† ≈ 0.118 (σ₂ reaches zero)

### Table 2 — Blind Control Regime

| Regime | Range | Controllable? | Observable? |
|---|---|---|---|
| Fully observable | ε < 0.118 | ✅ Yes | ✅ Yes |
| **Blind control** | **0.118 < ε < 0.170** | **✅ Yes** | **❌ No** |
| Fully unobservable | ε > 0.170 | ❌ No | ❌ No |

**Observability fails 31% earlier than controllability** (Gap = (0.170 − 0.118)/0.170 = 30.59%)

### Table 3 — Tolerance Sensitivity of ε†

| Tolerance | ε† |
|---|---|
| 10⁻² | 0.1140 |
| 5×10⁻³ | 0.1180 |
| 10⁻³ | 0.1230 |

**ε† is stable:** interval [0.114, 0.123] across all tolerance choices.

### Table 4 — Algorithm Scalability (Kronecker-free vs Classical)

| n | Algorithm time | Classical time | Speedup |
|---|---|---|---|
| 4 | ~0.05 s | ~3 s | **59×** |
| 8 | ~0.8 s | ~480 s | **600×** |
| 16 | ~12 s | ~14,400 s | **1,200×** |
| 50 | ~605 s | ~6.4×10⁷ s | **105,800×** |

---

## How to Reproduce All Results

### Requirements
- MATLAB R2021b or later (R2024b recommended)
- No additional toolboxes required

### Steps

**Run the main script:**
```matlab
run('Melnikov_Observability.m')
```

This produces:
- `Fig1_obs_sigma_vs_epsilon.pdf` — observability phase transition diagram
- `Fig2_comparative_sensitivity.pdf` — blind control regime visualization
- `Fig3_obs_rank_vs_epsilon.pdf` — rank vs epsilon
- `Fig4_log_sigma_min.pdf` — log-scale order parameter

And prints the verification table and key results to the console.

---

## System Definition

The SBMPMS-O is governed by:

```
E·Ẋ(t) = A(t)X(t) + X(t)B(t) + Σᵢ uᵢ(t)NᵢX(t) + ε·G(t)sin(ωt+φ)·X(t)
Y(t)   = C(t)·X(t)
```

where:
- `E ∈ ℝⁿˣⁿ` is singular with rank(E) = r < n
- `ε·G(t)sin(ωt+φ)` is the Melnikov-type multiplicative perturbation
- `Y(t)` is the measured output

**Physical meaning of observability breakdown at ε > ε†:**  
Two state trajectories X(t) and X̃(t) = X(t) + α·η differ only in the unobservable mode direction η, yet produce **identical outputs** Y(t) = Ỹ(t) for all t. No measurement device can distinguish them. Any Kalman filter or Luenberger observer accumulates unbounded estimation error in the η-direction with no indication in the output residual.

---

## Key Theoretical Results

### Theorem 1 — Observability Gramian Expansion
The observability Gramian admits:
```
W_o(0,T;ε) = W_o⁽⁰⁾ + ε·W_o⁽¹⁾ + ε²·W_o⁽²⁾ + O(ε³)
```
with explicit, Kronecker-free coefficient matrices.

### Theorem 2 — Critical Threshold (Observability Phase Transition)
```
ε† ≥ σ_min(W_o⁽⁰⁾) / (‖W_o⁽¹⁾‖ + ‖W_o⁽²⁾‖)
```
The minimum singular value σ_min(W_o) acts as an **order parameter**: it decreases monotonically and collapses to zero at ε†, marking a continuous (second-order-like) phase transition.

### Theorem 3 — Kalman–Hewer Observability Equivalence
For |ε| < ε†, Kalman and Hewer observability are equivalent. For |ε| > ε†, Kalman observability fails while Hewer observability may persist.

### Theorem 4 — Controllability–Observability Duality (Blind Control)
There exists a blind control regime ε† < |ε| < ε* where:
- The system is **controllable** (can be steered to any target)
- The system is **not observable** (internal state cannot be recovered from output)

This regime is dangerous in practice: an engineer who checks only controllability will not detect the observability failure.

---

## Applications

### Chemical Reaction Networks
Observability breakdown at ε > ε† means at least one species concentration becomes sensor-invisible: the unobservable mode η identifies the specific linear combination of concentrations that no measurement C(t)X(t) can detect.

**Engineering remedy:** Either reduce oscillatory forcing below ε†, or redesign the sensor array C(t) to eliminate the null space of the unobservable mode.

### Constrained Mechanical Systems
Under oscillatory joint forcing exceeding ε†, the internal elastic strains in a constrained linkage become unrecoverable from position/velocity sensors alone.

### Biological Oscillator Monitoring
In circadian rhythm models, Melnikov forcing above ε† renders certain protein concentrations unmeasurable from observable metabolite data.

---

## Companion Papers

This repository is part of a research series on Kalman–Hewer equivalence for structured matrix systems:

| Paper | System Class | Journal | Repository |
|---|---|---|---|
| [SBLIPMS-Controllability](https://github.com/msvdsudarsan/SBLIPMS-Controllability) | Singular bilinear + impulses | Nonlinear Dynamics | ✅ |
| [Bilinear-Matrix-Periodic-Controllability](https://github.com/msvdsudarsan/Bilinear-Matrix-Periodic-Controllability) | Generalized bilinear periodic | MCSS | ✅ |
| **This paper** | Melnikov observability breakdown | Chaos, Solitons & Fractals | — |

---

## Citation

```bibtex
@article{Madhyannapu2026melnikov_obs,
  author  = {Madhyannapu, Sri Venkata Durga Sudarsan and
             {Pradheep Kumar}, Sravanam},
  title   = {Melnikov-Based Observability Breakdown in Singular
             Bilinear Periodic Matrix Differential Systems},
  journal = {Chaos, Solitons and Fractals},
  year    = {2026},
  publisher = {Elsevier},
  issn    = {0960-0779},
  note    = {Submitted April 2026}
}
```

---

## License

This project is licensed under the MIT License — see the [LICENSE](LICENSE) file for details.

---

## Contact

**Sri Venkata Durga Sudarsan Madhyannapu**  
Email: msvdsudarsan@gmail.com  
ORCID: [0009-0001-2126-6428](https://orcid.org/0009-0001-2126-6428)  
Institution: Dr. RVR NRI Institute of Technology (Deemed to be University), Andhra Pradesh, India
