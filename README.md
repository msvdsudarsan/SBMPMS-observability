# SBMPMS-O: Melnikov-Based Observability Breakdown in Singular Bilinear Periodic Matrix Differential Systems

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![MATLAB](https://img.shields.io/badge/MATLAB-R2024a-orange.svg)](https://www.mathworks.com)
[![Status: Under Review](https://img.shields.io/badge/Status-Under%20Review-yellow.svg)]()

---

## Paper Information

**Title:**
Melnikov-Based Observability Breakdown in Singular Bilinear Periodic Matrix Differential Systems

**Authors:**
- Sri Venkata Durga Sudarsan Madhyannapu
  (Freshmen Engineering Department, Dr. RVR NRI Institute of Technology (Deemed to be University), Pothavarappadu Village, Agiripalli Mandal 521212, Vijayawada Rural, Andhra Pradesh, India)
  Email: msvdsudarsan@gmail.com
- Sravanam Pradheep Kumar
  (School of Basic Sciences, SRM University AP, Andhra Pradesh, India)
  Email: sravanampradheepkumar@gmail.com

**Status:** Under Review, 2026

**Keywords:**
Singular bilinear systems, Melnikov perturbation, Observability breakdown,
Kalman-Hewer observability equivalence, Impulsive modes,
Blind control regime, Kronecker-free computation

---

## Repository Contents

```
SBMPMS-O-Observability-2026/
│
├── README.md                          ← This file
├── LICENSE                            ← MIT License
│
├── MATLAB/
│   ├── Melnikov_Observability.m       ← Main script (Algorithm 1)
│   └── MATLAB_Output_Values_Melnikov-Based_Observability.txt
│                                      ← All numerical output values
│
├── Figures/
│   ├── Fig1_obs_sigma_vs_epsilon.pdf  ← Singular values vs epsilon
│   ├── Fig2_comparative_sensitivity.pdf  ← Observability vs controllability
│   └── Fig3_obs_rank_vs_epsilon.pdf   ← Gramian rank vs epsilon
│
|
```

---

## Key Results

| Quantity | Value |
|---|---|
| Observability breakdown threshold $\varepsilon^\dagger$ | $\approx 0.118$ |
| Controllability threshold $\varepsilon^*$ (companion paper) | $\approx 0.17$ |
| Gap: observability breaks down earlier by | $\approx 31\%$ |
| Algorithm 1 speedup at $n=4$ | $59\times$ |
| Algorithm 1 speedup at $n=16$ | $1200\times$ |
| Algorithm 1 speedup at $n=50$ | $105{,}800\times$ |
| Safe operating region (guaranteed observable) | $\varepsilon < 0.086$ |
| Tolerance sensitivity range | $\varepsilon^\dagger \in [0.114, 0.123]$ |

---

## How to Reproduce All Results

### Requirements
- MATLAB R2020a or later (R2024a recommended)
- No additional toolboxes required — the script uses only base MATLAB functions

### Steps

**Step 1:** Clone or download this repository:
```
git clone https://github.com/msvdsudarsan/SBMPMS-observability.git
```

**Step 2:** Open MATLAB and navigate to the `MATLAB/` folder:
```matlab
cd('path/to/SBMPMS-O-Observability-2026/MATLAB')
```

**Step 3:** Run the main script:
```matlab
run('Melnikov_Observability.m')
```

**Step 4:** The script will:
- Print all tabulated values (Table 1, Table 2, Table 3) to the Command Window
- Generate and save Figures 1, 2, and 3 as PDF files at 600 DPI
- Print the key results: $\varepsilon^\dagger$, $\varepsilon^*$, and the gap percentage

**Step 5:** Compare the Command Window output with the file
`MATLAB_Output_Values_Melnikov-Based_Observability.txt` — they should match exactly.

### Expected Output (Key Lines)

```
PAPER 2: Melnikov-Based Observability Breakdown
=================================================

Dense grid eps_dag = 0.1180

TOLERANCE SENSITIVITY TEST
----------------------------------------------
tol        eps_dag
0.0100     0.1140
0.0050     0.1180
0.0010     0.1230
----------------------------------------------

KEY RESULTS
eps† = 0.1180
eps* = 0.1700
Gap  = 30.59%

ALL FIGURES GENERATED + OUTPUT PRINTED

ADDITIONAL VALIDATION (PERTURBED CASE)
----------------------------------------------
Perturbed eps_dag = 0.1190
----------------------------------------------
```

---

## Algorithm 1: Kronecker-Free Computation

The core computational method of this paper avoids vectorisation
of the matrix state (which would incur $O(Nn^6)$ cost) and instead
works column by column in the natural $n \times n$ matrix space
at cost $O(Nn^3)$.

**Speedup table:**

| $n$ | Algorithm 1 (s) | Kronecker est. (s) | Speedup |
|---|---|---|---|
| 4  | ≈ 0.31  | ≈ 18.3               | **59×**        |
| 8  | ≈ 2.46  | ≈ 1,180              | **481×**       |
| 10 | ≈ 4.82  | ≈ 4,550              | **944×**       |
| 16 | ≈ 19.7  | ≈ 23,600             | **1,200×**     |
| 20 | ≈ 48.1  | ≈ 76,800             | **1,597×**     |
| 32 | ≈ 158   | ≈ 1,070,000          | **6,800×**     |
| 50 | ≈ 605   | ≈ 64,000,000         | **105,800×**   |

---

## Companion Paper

This paper is the observability companion to:

> S. V. D. S. Madhyannapu and S. Pradheep Kumar,
> "Controllability Breakdown in Singular Bilinear Periodic Systems
> under Melnikov-Type Perturbations,"
> *Journal of the Franklin Institute*, Submitted 12 April 2026.
> DOI: https://doi.org/10.2139/ssrn.6275668

The companion paper establishes $\varepsilon^* \approx 0.17$ for the
controllability threshold. The present paper shows
$\varepsilon^\dagger \approx 0.118 < \varepsilon^* \approx 0.17$,
meaning observability breaks down approximately 31% earlier —
creating a "blind control" regime of practical significance.

---

## Citation

If you use this code or results in your work, please cite:

```bibtex
@article{Madhyannapu2026obs,
  author    = {Madhyannapu, Sri Venkata Durga Sudarsan and
               {Pradheep Kumar}, S.},
  title     = {Melnikov-Based Observability Breakdown in
               Singular Bilinear Periodic Matrix Differential Systems},
  journal   = {Under Review},
  year      = {2026},
  note      = {GitHub: https://github.com/SVDSMadhyannapu/SBMPMS-O-Observability-2026}
}
```

---

## Research Series

This paper is part of a systematic series on Kalman-Hewer
controllability and observability equivalence for singular bilinear
periodic matrix systems. Related published and submitted papers include:

1. Sudarsan et al. (2025) — Lyapunov periodic systems
   *i-manager's Journal on Mathematics*, vol. 14, no. 1, pp. 33-42.
   DOI: https://doi.org/10.26634/jmat.14.1.21822

2. Sudarsan et al. (2026) — Sylvester periodic systems
   *Archives of Control Sciences* (Under Review)

3. Madhyannapu & Pradheep Kumar (2026) — Generalised bilinear periodic
   *International Journal of Control* (Under Review)

4. Madhyannapu & Pradheep Kumar (2026) — Observability equivalence
   *Systems & Control Letters* (Under Review)

5. Madhyannapu & Pradheep Kumar (2026) — Kronecker-free Gramian computation
   *International Journal of Computer Mathematics* (Under Review)

---

## License

This repository is released under the MIT License.
See [LICENSE](LICENSE) for full details.

---

*Last updated: April 2026*
