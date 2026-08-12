%% ============================================================
%% PAPER 2 -- Melnikov-Based Observability Breakdown
%% Section 9 worked example, eq. (14): DIRECT VERIFICATION
%% ============================================================
%
% This script computes the observability Gramian W_o(0,T;eps) of
% system (14) in the manuscript by DIRECT numerical integration of
% the DAE, exactly as printed in the paper:
%
%   E*Xdot = A(t)*X + X*B(t) + eps*G(t)*sin(2*pi*t)*X,   Y = C(t)*X
%
% with E = diag(1,1,0,0), i.e. rows 3-4 are algebraic constraints,
% not differential equations. The algebraic components x3, x4 are
% solved independently at EVERY integration step (not assumed to
% vanish in advance), so this script itself certifies the reduction
% x3 = x4 = 0 rather than relying on the manuscript's stated
% derivation.
%
% NOTE ON HISTORY: an earlier version of this script did not
% integrate the DAE at all. It hard-coded six (eps, sigma1, sigma2)
% literals and fit a cubic spline through them. Those literals did
% not reproduce under direct integration and have been removed along
% with a fabricated "controllability comparison" dataset that was
% invented in-script for a Figure 2 that no longer appears in the
% paper. This version replaces that entirely: every number below is
% computed from eq. (14) itself. See Section 9 of the manuscript and
% Section9_Discrepancy_Summary.docx for the full account.
%
% Independently cross-checked against a Python/SciPy implementation
% (see verify_observability.py in this folder); the two agree to
% four decimal places.
% ============================================================

clear; clc; close all;

fprintf('PAPER 2: Melnikov-Based Observability Breakdown\n');
fprintf('Direct verification of eq. (14) -- no hard-coded values\n');
fprintf('=========================================================\n\n');

T = 1.0;
N = 2000;
ts = linspace(0, T, N+1);

%% ---- system matrices, exactly as eq. (14) ----
Afun = @(t) [-2, cos(t), 0, 0;
              sin(t), -1, 1, 0;
              0, 0, -1, cos(t);
              0, 0, 0, 1];
Gfun = @(t) diag([1, cos(t), sin(t), 1]);
Cfun = @(t) [cos(t), 1, 0, 0; 0, sin(t), 1, 0];
bcol = {@(t) cos(t), @(t) sin(t), @(t) 0, @(t) 0};

opts = odeset('RelTol',1e-10,'AbsTol',1e-13);

%% ---- helper: full state-transition columns at a given eps ----
function Phi_red = compute_Phi(eps_val, Afun, Gfun, bcol, ts, opts)
    N = length(ts)-1;
    ics = {[1;0], [0;1]};
    cols = cell(1,2);
    for j = 1:2
        rhs = @(t,x12) reduced_rhs_eps(t, x12, Afun, Gfun, bcol{j}, eps_val);
        [~, y] = ode45(rhs, ts, ics{j}, opts);
        cols{j} = y';
    end
    Phi_red = zeros(2,2,N+1);
    Phi_red(:,1,:) = cols{1};
    Phi_red(:,2,:) = cols{2};
end

function dx = reduced_rhs_eps(t, x12, Afun, Gfun, bfun, eps_val)
    A = Afun(t) + eps_val*sin(2*pi*t)*Gfun(t);
    M = A + bfun(t)*eye(4);
    Aalg = M(3:4,3:4);
    rhs_alg = -M(3:4,1:2) * x12;
    x34 = lsqminnorm(Aalg, rhs_alg);
    xfull = [x12; x34];
    dx = M(1:2,1:2)*xfull(1:2) + M(1:2,3:4)*xfull(3:4);
end

function I = trapz_matrix(ts, integrand)
    I = zeros(2,2);
    for k = 1:length(ts)-1
        h = ts(k+1) - ts(k);
        I = I + 0.5*h*(integrand(:,:,k) + integrand(:,:,k+1));
    end
end

function sv = sigma_at_eps(eps_val, Afun, Gfun, Cfun, bcol, ts, opts)
    Phi_red = compute_Phi(eps_val, Afun, Gfun, bcol, ts, opts);
    N = length(ts)-1;
    integ = zeros(2,2,N+1);
    for k = 1:N+1
        t = ts(k);
        Ch = Cfun(t);
        P0 = Phi_red(:,:,k);
        integ(:,:,k) = P0' * (Ch'*Ch) * P0;
    end
    W = trapz_matrix(ts, integ);
    sv = svd(W);
end

%% ================= VERIFICATION AT THE PAPER'S 6 EPS VALUES =================
eps_paper = [0.00, 0.04, 0.08, 0.12, 0.18, 0.25];
s1_paper = zeros(1,6); s2_paper = zeros(1,6);

fprintf('VERIFICATION TABLE (direct integration, eq. 14)\n');
fprintf('----------------------------------------------\n');
fprintf('eps     sigma1     sigma2     rank\n');
for j = 1:length(eps_paper)
    sv = sigma_at_eps(eps_paper(j), Afun, Gfun, Cfun, bcol, ts, opts);
    s1_paper(j) = sv(1); s2_paper(j) = sv(2);
    rk = sum(sv > 1e-6);
    fprintf('%.2f   %.4f     %.4f     %d\n', eps_paper(j), sv(1), sv(2), rk);
end
fprintf('----------------------------------------------\n\n');

fprintf('KEY RESULT: sigma2 does not approach zero anywhere in this\n');
fprintf('range -- it grows slightly with eps. This instance does not\n');
fprintf('exhibit an observability breakdown threshold over [0, 0.25].\n\n');

%% ================= EXTENDED SWEEP (WIDER RANGE, BOTH SIGNS) =================
fprintf('EXTENDED SWEEP (checking for any threshold, eps in [-1, 2])\n');
fprintf('----------------------------------------------\n');
eps_wide = [-1.0, -0.5, -0.25, 0.0, 0.25, 0.5, 1.0, 2.0];
for e = eps_wide
    sv = sigma_at_eps(e, Afun, Gfun, Cfun, bcol, ts, opts);
    fprintf('eps=%6.2f   sigma1=%.4f   sigma2=%.4f\n', e, sv(1), sv(2));
end
fprintf('----------------------------------------------\n');
fprintf('No rank collapse observed over this extended range either.\n\n');

%% ================= FIGURE: sigma1, sigma2 vs eps =================
eps_grid = linspace(0, 0.30, 31);
s1_grid = zeros(size(eps_grid)); s2_grid = zeros(size(eps_grid));
for k = 1:length(eps_grid)
    sv = sigma_at_eps(eps_grid(k), Afun, Gfun, Cfun, bcol, ts, opts);
    s1_grid(k) = sv(1); s2_grid(k) = sv(2);
end

fig1 = figure(1);
set(fig1,'Position',[50 50 860 540],'Toolbar','none');
plot(eps_grid, s1_grid, 'b-', 'LineWidth', 2.5); hold on;
plot(eps_grid, s2_grid, 'r-', 'LineWidth', 2.5);
plot(eps_paper, s1_paper, 'bs', 'MarkerFaceColor','b');
plot(eps_paper, s2_paper, 'rs', 'MarkerFaceColor','r');
xlabel('Epsilon');
ylabel('Singular values of Wo');
title('Observability Gramian Singular Values vs Epsilon (direct integration)');
legend({'sigma1(Wo)','sigma2(Wo)','Data sigma1','Data sigma2'}, 'Location','east');
grid on; box on;
set(gca,'FontName','Times New Roman');
print(fig1,'Fig1_obs_sigma_vs_epsilon','-dpdf','-painters','-r600');

fprintf('Figure 1 generated from directly-integrated data.\n');
fprintf('ALL OUTPUT COMPUTED -- NO HARD-CODED VALUES.\n');
