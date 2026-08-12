% ============================================================
% Independent verification of the observability Gramian for the
% n=4 example (eq. 14) of CHAOS-D-26-04430.
%
% This solves the DAE E*Xdot = A(t)*X + X*B(t) + eps*G(t)*sin(2*pi*t)*X
% directly, WITHOUT assuming the algebraic reduction x3=x4=0 in
% advance -- x3,x4 are solved algebraically at every RHS evaluation,
% so if that reduction is wrong, this script will show it (x3,x4
% will come out nonzero).
%
% Run this exactly as-is first. Compare console output against:
%   Wo0 singular values (paper claims): 0.198, 0.142
%   Wo0 singular values (independent Python cross-check): 1.435, 0.0327
% ============================================================

clear; clc;
T = 1.0;
N = 2000;
ts = linspace(0, T, N+1);

eps_list = [0.00, 0.04, 0.08, 0.12, 0.18, 0.25];

% ---- system matrices, exactly as eq. (14) ----
Afun = @(t) [-2, cos(t), 0, 0;
              sin(t), -1, 1, 0;
              0, 0, -1, cos(t);
              0, 0, 0, 1];
Bfun = @(t) diag([cos(t), sin(t), 0, 0]);
Gfun = @(t) diag([1, cos(t), sin(t), 1]);
Cfun = @(t) [cos(t), 1, 0, 0; 0, sin(t), 1, 0];
bcol = {@(t) cos(t), @(t) sin(t), @(t) 0, @(t) 0};

% ---- Phi0: column by column, algebraic x3,x4 solved at every step ----
Phi0_cols = cell(1,4);
ics = {[1;0], [0;1], [0;0], [0;0]};
opts = odeset('RelTol',1e-10,'AbsTol',1e-13);

for j = 1:4
    rhs = @(t,x12) reduced_rhs(t, x12, Afun, bcol{j});
    [~, y] = ode45(rhs, ts, ics{j}, opts);
    Phi0_cols{j} = y';  % 2 x (N+1)
end

Phi0_red = zeros(2,2,N+1);
Phi0_red(:,1,:) = Phi0_cols{1};
Phi0_red(:,2,:) = Phi0_cols{2};

% sanity check: verify x3,x4 stay zero (independent algebraic solve)
maxdev = 0;
for j = 1:2
    for k = 1:200:N+1
        t = ts(k);
        x12 = Phi0_cols{j}(:,k);
        M = Afun(t) + bcol{j}(t)*eye(4);
        Aalg = M(3:4,3:4);
        rhs_alg = -M(3:4,1:2) * x12;
        x34 = lsqminnorm(Aalg, rhs_alg);
        maxdev = max(maxdev, max(abs(x34)));
    end
end
fprintf('Max |x3|,|x4| found (should be ~0): %.2e\n', maxdev);

% ---- Wo^(0) via trapezoidal quadrature ----
integrand0 = zeros(2,2,N+1);
for k = 1:N+1
    t = ts(k);
    Ch = [cos(t), 1; 0, sin(t)];
    P0 = Phi0_red(:,:,k);
    integrand0(:,:,k) = P0' * (Ch' * Ch) * P0;
end
Wo0 = trapz_matrix(ts, integrand0);
fprintf('\nWo^(0) =\n'); disp(Wo0);
sv0 = svd(Wo0);
fprintf('singular values of Wo^(0): %.4f  %.4f\n', sv0(1), sv0(2));

% ---- Phi1: variational equation, exactly as stated in the paper ----
%  E*Phi1dot = A(t)*Phi1 + G(t)*sin(2*pi*t)*Phi0(t,0),  Phi1(0,0)=0
rhs1 = @(t,y) phi1_rhs(t, y, Afun, Gfun, ts, Phi0_red);
[~, y1] = ode45(rhs1, ts, zeros(4,1), opts);
Phi1_red = reshape(y1', 2, 2, N+1);

integrand1 = zeros(2,2,N+1);
integrand2 = zeros(2,2,N+1);
for k = 1:N+1
    t = ts(k);
    Ch = [cos(t), 1; 0, sin(t)];
    P0 = Phi0_red(:,:,k);
    P1 = Phi1_red(:,:,k);
    integrand1(:,:,k) = P1'*(Ch'*Ch)*P0 + P0'*(Ch'*Ch)*P1;
    integrand2(:,:,k) = P1'*(Ch'*Ch)*P1;
end
Wo1 = trapz_matrix(ts, integrand1);
Wo2 = trapz_matrix(ts, integrand2);

fprintf('\n||Wo^(1)||_2 = %.4f\n', norm(Wo1,2));
fprintf('||Wo^(2)||_2 = %.4f\n', norm(Wo2,2));

fprintf('\n=== sigma1, sigma2 at the papers 6 eps values ===\n');
for e = eps_list
    W = Wo0 + e*Wo1 + e^2*Wo2;
    sv = svd(W);
    fprintf('eps=%.2f  sigma1=%.4f  sigma2=%.4f\n', e, sv(1), sv(2));
end

% ============================================================
function dx = reduced_rhs(t, x12, Afun, bfun)
    M = Afun(t) + bfun(t)*eye(4);
    Aalg = M(3:4,3:4);
    rhs_alg = -M(3:4,1:2) * x12;
    x34 = lsqminnorm(Aalg, rhs_alg);
    xfull = [x12; x34];
    dx = M(1:2,1:2)*xfull(1:2) + M(1:2,3:4)*xfull(3:4);
end

function dy = phi1_rhs(t, y, Afun, Gfun, ts, Phi0_red)
    Phi1 = reshape(y, 2, 2);
    A = Afun(t); Ared = A(1:2,1:2);
    G = Gfun(t); Ghat = diag([G(1,1), G(2,2)]);
    [~, idx] = min(abs(ts - t));
    P0 = Phi0_red(:,:,idx);
    dPhi1 = Ared*Phi1 + sin(2*pi*t) * (Ghat * P0);
    dy = dPhi1(:);
end

function I = trapz_matrix(ts, integrand)
    % trapezoidal rule for a (2,2,N+1) array of matrices over ts
    I = zeros(2,2);
    for k = 1:length(ts)-1
        h = ts(k+1) - ts(k);
        I = I + 0.5*h*(integrand(:,:,k) + integrand(:,:,k+1));
    end
end
