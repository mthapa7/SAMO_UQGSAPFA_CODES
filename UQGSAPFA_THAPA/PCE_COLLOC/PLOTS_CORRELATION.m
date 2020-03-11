%%IMPORTANT OUTPUTS
% plot the LHS and PCE response correlations for four different responses!
%RESULTS1, STOT, STOTNORM, MEAN_ERROR, STD_ERROR, COV_WTS, ERRLOO_VALS, XI_ORDER, FUN_ORDER, XI_LHS, FUN_LHS
clc
%close all
format short e

%% PLOTS

load('PCE_RESP_CV.mat')
load('EXACT_OUTPUT_CV.mat')
fontsize=18; linewidth=3;
sz=60;
figure
ax=gca;
set(ax,'FontName','Times','Fontsize',fontsize,'FontWeight','bold');
box on
set(gcf,'color',[1 1 1])   %to make the backgroung white
hold all
scatter(PCE_RESP_CV(:,1)/mean(PCE_RESP_CV(:,1)),EXACT_OUTPUT_CV(:,1)/mean(EXACT_OUTPUT_CV(:,1)),sz,'r','filled')
scatter(PCE_RESP_CV(:,2)/mean(PCE_RESP_CV(:,2)),EXACT_OUTPUT_CV(:,2)/mean(EXACT_OUTPUT_CV(:,2)),sz,'bs','filled')
scatter(PCE_RESP_CV(:,3)/mean(PCE_RESP_CV(:,3)),EXACT_OUTPUT_CV(:,3)/mean(EXACT_OUTPUT_CV(:,3)),sz,'d','filled',....
    'MarkerFaceColor',[0.184313725490196 0.87843137254902 0.0784313725490196])
scatter(PCE_RESP_CV(:,4)/mean(PCE_RESP_CV(:,4)),EXACT_OUTPUT_CV(:,4)/mean(EXACT_OUTPUT_CV(:,4)),sz,'m','filled')
grid on
grid minor
hold off
legend('\it \delta_{FPF}','\it P_{FPF}','\it \delta_{LPF}','\it P_{LPF}')
xlabel('\it y_{PCE}^{norm}')
ylabel('\it y_{exact}^{norm}')
lb=min(min(EXACT_OUTPUT_CV./mean(EXACT_OUTPUT_CV)));
ub=max(max(EXACT_OUTPUT_CV./mean(EXACT_OUTPUT_CV)));
axis([lb-0.2 ub+0.2 lb-0.2 ub+0.2])