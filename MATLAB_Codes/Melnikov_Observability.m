%% ============================================================
%% PAPER 2 — Melnikov-Based Observability Breakdown (FINAL + ROBUSTNESS)
%% ============================================================
clc; clear; close all;

fprintf('PAPER 2: Melnikov-Based Observability Breakdown\n');
fprintf('=================================================\n\n');

%% ================= SECTION 1 — DATA =================
eps_paper = [0.00, 0.04, 0.08, 0.12, 0.18, 0.25];
s1_paper  = [0.198, 0.165, 0.121, 0.047, 0.009, 0.000];
s2_paper  = [0.142, 0.108, 0.058, 0.003, 0.000, 0.000];

eps_ctrl = 0.17;

%% ================= STEP-1: DENSE GRID =================
eps_vec  = linspace(0,0.30,301);

fprintf('Paper data: %d points\n\n', length(eps_paper));

%% ================= SECTION 2 — SPLINE =================
s1 = max(spline(eps_paper,s1_paper,eps_vec),0);
s2 = max(spline(eps_paper,s2_paper,eps_vec),0);

for k = 1:length(eps_vec)
    if s1(k) < s2(k)
        tmp = s1(k); s1(k) = s2(k); s2(k) = tmp;
    end
end

%% ================= SECTION 3 — eps† =================
tol = 0.005;
idx = find(s2 < tol,1);
eps_dag = eps_vec(idx);

fprintf('Dense grid eps_dag = %.4f\n', eps_dag);

gap = (eps_ctrl - eps_dag)/eps_ctrl*100;

%% ================= STEP-2: TOLERANCE TEST =================
tol_values = [1e-2, 5e-3, 1e-3];

fprintf('\nTOLERANCE SENSITIVITY TEST\n');
fprintf('----------------------------------------------\n');
fprintf('tol        eps_dag\n');

for i = 1:length(tol_values)
    tol_i = tol_values(i);
    idx_i = find(s2 < tol_i,1);
    eps_i = eps_vec(idx_i);
    fprintf('%.4f     %.4f\n', tol_i, eps_i);
end
fprintf('----------------------------------------------\n\n');

%% ================= SECTION 4 — RANK =================
rkv = double(s1>tol) + double(s2>tol);
for k = 2:length(rkv)
    rkv(k) = min(rkv(k), rkv(k-1));
end

%% ================= SECTION 5 — NUMERICAL OUTPUT =================
fprintf('VERIFICATION TABLE\n');
fprintf('----------------------------------------------\n');
fprintf('eps     sigma1     sigma2     rank\n');

for j = 1:length(eps_paper)
    ep   = eps_paper(j);
    s1_j = max(spline(eps_paper,s1_paper,ep),0);
    s2_j = max(spline(eps_paper,s2_paper,ep),0);
    rk   = double(s1_j>tol)+double(s2_j>tol);

    fprintf('%.2f   %.4f     %.4f     %d\n',ep,s1_j,s2_j,rk);
end
fprintf('----------------------------------------------\n\n');

fprintf('KEY RESULTS\n');
fprintf('eps† = %.4f\n',eps_dag);
fprintf('eps* = %.4f\n',eps_ctrl);
fprintf('Gap  = %.2f%%\n\n',gap);

%% ================= FIGURE 1 =================
fig1 = figure(1);
set(fig1,'Position',[50 50 860 540],'Toolbar','none');

plot(eps_vec,s1,'b-','LineWidth',2.5); hold on;
plot(eps_vec,s2,'r-','LineWidth',2.5);

plot(eps_paper,s1_paper,'bs','MarkerFaceColor','b');
plot(eps_paper,s2_paper,'rs','MarkerFaceColor','r');

xline(eps_dag,'k--','LineWidth',2);

xlabel('Epsilon');
ylabel('Singular values of Wo');
title('Observability Gramian Singular Values vs Epsilon');

legend({'sigma1(Wo)','sigma2(Wo)','Data sigma1','Data sigma2'},...
       'Location','northeast');

grid on; box on;
set(gca,'FontName','Times New Roman');

print(fig1,'Fig1_obs_sigma_vs_epsilon','-dpdf','-painters','-r600');

%% ================= FIGURE 2 =================
fig2 = figure(2);
set(fig2,'Position',[100 100 900 520],'Toolbar','none');

plot(eps_vec,s2,'r-','LineWidth',2.5); hold on;

eps_c = [0.00,0.05,0.10,0.15,0.17,0.22,0.30];
s2_c  = [0.187,0.151,0.098,0.021,0.002,0.000,0.000];
eps_c_vec = linspace(0,0.30,301);
s2c = max(spline(eps_c,s2_c,eps_c_vec),0);

plot(eps_c_vec,s2c,'b-','LineWidth',2.5);

xline(eps_dag,'r--');
xline(eps_ctrl,'b--');

xlabel('Epsilon');
ylabel('sigma_min');
title('Observability vs Controllability');

legend({'sigma2(Wo)','sigma2(Wc)'},'Location','northeast');

grid on; box on;
set(gca,'FontName','Times New Roman');

print(fig2,'Fig2_comparative_sensitivity','-dpdf','-painters','-r600');

%% ================= FIGURE 3 =================
fig3 = figure(3);
set(fig3,'Position',[150 150 860 380],'Toolbar','none');

stairs(eps_vec,rkv,'b-','LineWidth',2.5); hold on;

xline(eps_dag,'r--');
yline(2,'m:');

xlabel('Epsilon');
ylabel('rank(Wo)');
title('Observability Gramian Rank vs Epsilon');

legend({'rank(Wo)'},'Location','southwest');

grid on; box on;
set(gca,'FontName','Times New Roman');

print(fig3,'Fig3_obs_rank_vs_epsilon','-dpdf','-painters','-r600');

%% ================= FIGURE 4 =================
fig4 = figure(4);
set(fig4,'Position',[180 180 860 500],'Toolbar','none');

% avoid log(0)
s2_plot = s2;
s2_plot(s2_plot <= 1e-8) = 1e-8;

semilogy(eps_vec, s2_plot,'r-','LineWidth',2.5); hold on;

plot(eps_paper, max(s2_paper,1e-8), ...
    'ks','MarkerFaceColor','k','MarkerSize',7);

xline(eps_dag,'b--','LineWidth',2);

xlabel('\epsilon');
ylabel('log-scale \sigma_{min}(W_o)');
title('Log-Scale Decay of Minimum Singular Value');

legend({'\sigma_{min}(W_o)','Paper data','\epsilon^\dagger'}, ...
    'Location','southwest');

grid on;
box on;
set(gca,'FontName','Times New Roman');

print(fig4,'Fig4_log_decay_sigma_min','-dpdf','-painters','-r600');

fprintf('Figure 4 generated successfully.\n');

fprintf('ALL FIGURES GENERATED + OUTPUT PRINTED\n');

%% ================= STEP-3: ADDITIONAL VALIDATION =================
fprintf('\nADDITIONAL VALIDATION (PERTURBED CASE)\n');
fprintf('----------------------------------------------\n');

% 5% perturbation
s1_paper_pert = 1.05 * s1_paper;
s2_paper_pert = 1.05 * s2_paper;

% spline
s1p = max(spline(eps_paper,s1_paper_pert,eps_vec),0);
s2p = max(spline(eps_paper,s2_paper_pert,eps_vec),0);

for k = 1:length(eps_vec)
    if s1p(k) < s2p(k)
        tmp = s1p(k); s1p(k) = s2p(k); s2p(k) = tmp;
    end
end

% threshold
idx_p = find(s2p < tol,1);
eps_dag_p = eps_vec(idx_p);

fprintf('Perturbed eps_dag = %.4f\n', eps_dag_p);
fprintf('----------------------------------------------\n');