"""
Independent Python/SciPy cross-check of Melnikov_Observability.m.

Directly integrates eq. (14) of the manuscript (no algebraic
reduction assumed in advance -- x3, x4 are solved at every RHS
evaluation) and reports the observability Gramian's singular values
at the paper's six eps values plus an extended sweep.

Run:  python3 verify_observability.py

Expected agreement with the MATLAB script: 4 decimal places.
"""
import numpy as np
from scipy.integrate import solve_ivp


def Afun(t):
    return np.array([[-2, np.cos(t), 0, 0],
                      [np.sin(t), -1, 1, 0],
                      [0, 0, -1, np.cos(t)],
                      [0, 0, 0, 1]])


def bcol_val(j, t):
    return [np.cos(t), np.sin(t), 0.0, 0.0][j]


def Cfun(t):
    return np.array([[np.cos(t), 1], [0, np.sin(t)]])


def trapz_matrix(ts, integrand):
    I = np.zeros((2, 2))
    for k in range(len(ts) - 1):
        h = ts[k + 1] - ts[k]
        I += 0.5 * h * (integrand[:, :, k] + integrand[:, :, k + 1])
    return I


def Afun_full(t, eps):
    G = np.diag([1, np.cos(t), np.sin(t), 1])
    return Afun(t) + eps * np.sin(2 * np.pi * t) * G


def reduced_rhs_eps(t, x12, bfun, eps):
    M = Afun_full(t, eps) + bfun(t) * np.eye(4)
    Aalg = M[2:4, 2:4]
    rhs_alg = -M[2:4, 0:2] @ x12
    x34 = np.linalg.lstsq(Aalg, rhs_alg, rcond=None)[0]
    xfull = np.concatenate([x12, x34])
    return M[0:2, 0:2] @ xfull[0:2] + M[0:2, 2:4] @ xfull[2:4]


def sigma_for_eps(eps, T=1.0, N=2000):
    ts = np.linspace(0, T, N + 1)
    ics = [np.array([1., 0.]), np.array([0., 1.])]
    Phired = np.zeros((2, 2, N + 1))
    for j in range(2):
        bfun = lambda t, j=j: bcol_val(j, t)
        sol = solve_ivp(lambda t, x: reduced_rhs_eps(t, x, bfun, eps),
                         [0, T], ics[j], t_eval=ts,
                         rtol=1e-10, atol=1e-13, method='RK45')
        Phired[:, j, :] = sol.y
    integ = np.zeros((2, 2, N + 1))
    for k, t in enumerate(ts):
        Ch = Cfun(t)
        P0 = Phired[:, :, k]
        integ[:, :, k] = P0.T @ (Ch.T @ Ch) @ P0
    W = trapz_matrix(ts, integ)
    return np.linalg.svd(W, compute_uv=False)


if __name__ == "__main__":
    print("VERIFICATION TABLE (direct integration, eq. 14)")
    print("-" * 48)
    print("eps     sigma1     sigma2")
    for e in [0.00, 0.04, 0.08, 0.12, 0.18, 0.25]:
        sv = sigma_for_eps(e)
        print(f"{e:.2f}   {sv[0]:.4f}     {sv[1]:.4f}")

    print("\nEXTENDED SWEEP")
    print("-" * 48)
    for e in [-1.0, -0.5, -0.25, 0.0, 0.25, 0.5, 1.0, 2.0]:
        sv = sigma_for_eps(e)
        print(f"eps={e:6.2f}   sigma1={sv[0]:.4f}   sigma2={sv[1]:.4f}")
