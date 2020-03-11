clc
% clear all
% close all
load('STOT.mat')
X=STOT(:,:,end);


x = [1:11];
figure;
fs=16;
subplot(1,4,1);
ax=gca;
set(ax,'FontName','Times','Fontsize',fs,'FontWeight','bold');
box on
hold all
set(gcf,'color',[1 1 1])   %to make the backgroung white
barh(x,X(:,1),'grouped','r'); % groups by row
title('\it \delta_{FPF}')
grid on
grid minor
xlim([0 1])
ylim([0.25 11.75])
yticks([1:1:11])
xticks([0:0.25:1])
yticklabels({'\it E_{11}','\it E_{22}','\it \nu_{12}','\it G_{12}','\it X_{T}','\it X_{C}','\it Y_{T}','\it Y_{C}','\it S','\it P_{12T}','\it P_{12C}'})
xlabel('\it S_{i}^{T}')

subplot(1,4,2);
ax=gca;
set(ax,'FontName','Times','Fontsize',fs,'FontWeight','bold');
box on
hold all
set(gcf,'color',[1 1 1])   %to make the backgroung white
barh(x,X(:,2),'grouped','b'); % stacks values in each row together
title('\it P_{FPF}')
grid on
grid minor
xlim([0 1])
ylim([0.25 11.75])
yticks([1:1:11])
xticks([0:0.25:1])
yticklabels({'\it E_{11}','\it E_{22}','\it \nu_{12}','\it G_{12}','\it X_{T}','\it X_{C}','\it Y_{T}','\it Y_{C}','\it S','\it P_{12T}','\it P_{12C}'})
xlabel('\it S_{i}^{T}')

subplot(1,4,3);
ax=gca;
set(ax,'FontName','Times','Fontsize',fs,'FontWeight','bold');
box on
hold all
set(gcf,'color',[1 1 1])   %to make the backgroung white
barh(x,X(:,3),'grouped','g'); % centers bars over x values
title('\it \delta_{LPF}')
grid on
grid minor
xlim([0 1])
ylim([0.25 11.75])
yticks([1:1:11])
xticks([0:0.25:1])
yticklabels({'\it E_{11}','\it E_{22}','\it \nu_{12}','\it G_{12}','\it X_{T}','\it X_{C}','\it Y_{T}','\it Y_{C}','\it S','\it P_{12T}','\it P_{12C}'})
xlabel('\it S_{i}^{T}')
xlabel('\it S_{i}^{T}')

subplot(1,4,4);
ax=gca;
set(ax,'FontName','Times','Fontsize',fs,'FontWeight','bold');
box on
hold all
set(gcf,'color',[1 1 1])   %to make the backgroung white
barh(x,X(:,4),'grouped','y'); % spans bars over x values
xlim([0 1])
ylim([0.25 11.75])
title('\it P_{LPF}')
grid on
grid minor
yticks([1:1:11])
xticks([0:0.25:1])
yticklabels({'\it E_{11}','\it E_{22}','\it \nu_{12}','\it G_{12}','\it X_{T}','\it X_{C}','\it Y_{T}','\it Y_{C}','\it S','\it P_{12T}','\it P_{12C}'})
xlabel('\it S_{i}^{T}')
