%% THIS SCRIPT GENERATES THE PDF OF THE RESPONSES BASED ON THE PCE SOLUTION
clc
%close all
global UQGSAPFA
loadtype=UQGSAPFA.loadtype;
%% CHANGE THE   SAMPLES DATA FOLDER ACCORDINGLY FOR TENSION OR COMPRESSION
load('pbank_sobol.mat')

%% CONTINUE!!!
% covals=0.1;
LHS_SAMPNUM_PDFGEN=1e4;   %this is inexpensive since it is a post-processing!!!
KS_SAMPLES=pbank_sobol(1:LHS_SAMPNUM_PDFGEN,:);
E11_BASIS=icdf('normal',KS_SAMPLES(:,1),0,1);
E22_BASIS=icdf('normal',KS_SAMPLES(:,2),0,1);
v12_BASIS=icdf('normal',KS_SAMPLES(:,3),0,1);
G12_BASIS=icdf('normal',KS_SAMPLES(:,4),0,1);
% G23=G12; G13=G12;
XT_BASIS=icdf('normal',KS_SAMPLES(:,5),0,1);  %Longitudinal Tensile Strength of Fiber
XC_BASIS=icdf('normal',KS_SAMPLES(:,6),0,1);   %Tensile  Strength of Matrix
YT_BASIS=icdf('normal',KS_SAMPLES(:,7),0,1);  %Compressive  Strength of Matrix
YC_BASIS=icdf('normal',KS_SAMPLES(:,8),0,1);  %Shear Strength of Matrix
SS_BASIS=icdf('normal',KS_SAMPLES(:,9),0,1);  %Shear Strength of Matrix
P12T_BASIS=icdf('normal',KS_SAMPLES(:,10),0,1);  %PUCK PARAMETER 1
P12C_BASIS=icdf('normal',KS_SAMPLES(:,11),0,1);  %PUCK PARAMETER 2

BASISSAMPLES_PFA=[E11_BASIS E22_BASIS v12_BASIS G12_BASIS XT_BASIS XC_BASIS YT_BASIS YC_BASIS SS_BASIS P12T_BASIS P12C_BASIS];

if size(BASISSAMPLES_PFA,2)~=11
    disp('HUGE ERROR IN THE NUMBER OF RANDOM INPUTS!')
end
load('EXACT_OUTPUT.mat')
NUMOUTPUT=size(EXACT_OUTPUT,2);


%% GENERATE THE NEW RESPONES AND PDF FROM PCE MODELS!!!!
clear PCCOEFFVAL MULTIINDEX
load('PCCOEFFVAL.mat')
load('MULTIINDEX.mat')
[size(PCCOEFFVAL) size(MULTIINDEX)];

%% RESPONSE FOR GIVEN ORDER
for ORDER=1:size(MULTIINDEX,3);
    P1vals=find(sum(MULTIINDEX(:,:,ORDER),2)>0);
    P1=P1vals(end);
    MULTIINDEX_ORDER=MULTIINDEX(1:P1,:,ORDER);
    PCCOEFFVAL_ORDER=PCCOEFFVAL(1:P1,:,ORDER);
    for itk=1:NUMOUTPUT
        RESPPCE_ORDER(:,itk,ORDER)=PCESURROG(PCCOEFFVAL_ORDER(:,itk), MULTIINDEX_ORDER, BASISSAMPLES_PFA);
        [FUN_ORDER(:,itk,ORDER),XI_ORDER(:,itk,ORDER)] = ksdensity(RESPPCE_ORDER(:,itk,ORDER));
    end
end
% KLDVALUES
[size(XI_ORDER) size(FUN_ORDER)];
save('XI_ORDER.mat','XI_ORDER')
save('FUN_ORDER.mat','FUN_ORDER')



%% PLOTS
fontsize=18; linewidth=3;
%%%FOR THE FPP AND ULT DISPLACEMENTS
figure
ax=gca;
set(ax,'FontName','Times','Fontsize',fontsize,'FontWeight','bold');
box on
set(gcf,'color',[1 1 1])   %to make the backgroung white
hold all
plot(XI_ORDER(:,1,PCORD-1),FUN_ORDER(:,1,PCORD-1),'--b','LineWidth',linewidth)
plot(XI_ORDER(:,1,PCORD),FUN_ORDER(:,1,PCORD),'-.r','LineWidth',linewidth)
% plot(XI_LHS(:,1),FUN_LHS(:,1),'-k','LineWidth',linewidth)
plot(XI_ORDER(:,3,PCORD-1),FUN_ORDER(:,3,PCORD-1),'--m','LineWidth',linewidth)
plot(XI_ORDER(:,3,PCORD),FUN_ORDER(:,3,PCORD),'-.g','LineWidth',linewidth)
% plot(XI_LHS(:,3),FUN_LHS(:,3),':b','LineWidth',linewidth)
grid on
grid minor
hold off
% xlim([0.1 1])
legend(strcat('\it PC, p=',num2str(PCORD-1),' (FPF)'),strcat('\it PC, p=',num2str(PCORD),' (FPF)'),....
    strcat('\it PC, p=',num2str(PCORD-1),' (LPF)'),strcat('\it PC, p=',num2str(PCORD),' (LPF)'),'NumColumns',2,'FontSize',14)
xlabel('Stochastic Failure Displacement (mm)')
ylabel('PDF')
% ylim([0 13])


%%%FOR THE  FPF AND ULT LOADS
figure
ax=gca;
set(ax,'FontName','Times','Fontsize',fontsize,'FontWeight','bold');
box on
set(gcf,'color',[1 1 1])   %to make the backgroung white
hold all
plot(XI_ORDER(:,2,PCORD-1),FUN_ORDER(:,2,PCORD-1),'--b','LineWidth',linewidth)
plot(XI_ORDER(:,2,PCORD),FUN_ORDER(:,2,PCORD),'-.r','LineWidth',linewidth)
% plot(XI_LHS(:,2),FUN_LHS(:,2),'-k','LineWidth',linewidth)
plot(XI_ORDER(:,4,PCORD-1),FUN_ORDER(:,4,PCORD-1),'--m','LineWidth',linewidth)
plot(XI_ORDER(:,4,PCORD),FUN_ORDER(:,4,PCORD),'-.g','LineWidth',linewidth)
% plot(XI_LHS(:,4),FUN_LHS(:,4),':b','LineWidth',linewidth)
grid on
grid minor
hold off
% xlim([0*1e4 4*1e4])
xlabel('Stochastic Failure Load (N)')
ylabel('PDF')
legend(strcat('\it PC, p=',num2str(PCORD-1),' (FPF)'),strcat('\it PC, p=',num2str(PCORD),' (FPF)'),....
    strcat('\it PC, p=',num2str(PCORD-1),' (LPF)'),strcat('\it PC, p=',num2str(PCORD),' (LPF)'),'NumColumns',2,'FontSize',14)
% xticks([0:500:4000])
% ylim([0 2.0e-4])
