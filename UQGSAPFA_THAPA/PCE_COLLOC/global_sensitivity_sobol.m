%% GLOBAL SENSITIVITY ANALYSIS BASED ON SOBOL INDICES
%%VARNUM= NUMBER OF VAR_MULTIIABLES
%%%NUMOUT=NUMBER OF OUTPUTS OR FUNCTIONS!!
function [STOT, STOTNORM]=global_sensitivity_sobol(VARNUM, NUMOUTPUT, MULTIIND,PCcoeffs)
%VAR_MULTIIANCE OF THE ORTHOPOLY POLYNOMIAL FOR HERMITE POLYNOMIALS!!!

%% TOTAL VAR_MULTIIANCE

for outitr=1:NUMOUTPUT
SUMMM=0;
count=0;
for itr=2:size(PCcoeffs,1)
    SUMMM=SUMMM+PCcoeffs(itr,outitr)^2*VAR_MULTI(MULTIIND(itr,:));
    count=count+1;
end
DVAR_MULTITOT_OUTPUT(outitr)=SUMMM;
count;
end

%% THE VAR_MULTIIANCE OF THE MULTIORTHOPLOYNOMIALS!!

LTHP1=size(MULTIIND,1);
for ITR=1:LTHP1
%     ROWJK=ITR-1    %%START THE FIRST INDEX IN THE VAR_MULTIPOLY FROM 1. HOWEVER, THE ITR IS 2 SO SUBTRACT!!!
VAR_MULTIPOLY(ITR,1)=VAR_MULTI(MULTIIND(ITR,:));
end
% disp('THE SIZE OF THE VAR_MULTIIANCE OF THE POLYNOMIALS!!')
% disp(size(VAR_MULTIPOLY))


%% GSA TYPE1!!!
%% GLOBAL SENSITIVIY ANALYSIS BASED ON SOBOL INDICES
%%SOBOL INDICES!!
% disp('THE SIZE OF THE PCE COEFFICIENTS FOR ALL THE RESPONSES!!')
% 
% disp(size(PCcoeffs));   %%THE PCcoeffs contain the PCE coefficients for 4 elements responses!!!

%FOR DIFFERENT RESPONSE
for RESPNUM_ITR=1:NUMOUTPUT     %for all the RESPONSES!!!!

%FOR ALL THE VAR_MULTIIABLES!!
 for XVAR_MULTI_ITR=1:VARNUM
LOCST=find(MULTIIND(:,XVAR_MULTI_ITR)>0);

DVAR_MULTI=sum(((PCcoeffs(LOCST,RESPNUM_ITR)).^2).*VAR_MULTIPOLY(LOCST));
STOT(XVAR_MULTI_ITR,RESPNUM_ITR)=DVAR_MULTI/DVAR_MULTITOT_OUTPUT(RESPNUM_ITR);

 end
end

STOTNORM=STOT./sum(STOT);     %%NORMALIZED TOTATL GSA1!!



% disp('GLOBAL SENSITIVITY INDICES FOR THE RESPONSES!!')
% disp('----------------------------------------------')
% disp(STOT)
% fprintf('\n')
% disp('SUM TOTAL OF GLOBAL SENSITIVITY INDICES FOR THE RESPONSES!!')
% 
% disp(sum(STOT))



%% PLOT THE GSA FOR DIFFERENT RESPONSES!!
%XX=[1:VARNUM];
% figure(3);
% %FOR RESPONSE 1
% % subplot(1,2,1); 
% ax=gca;
% set(ax,'FontName','Times','Fontsize',17,'FontWeight','bold');
% box on
% set(gcf,'color',[1 1 1])   %to make the backgroung white
% % legend(' ');
% % barh(XX,STOT(:,1)/sum(STOT(:,1)),'r'); % groups by row
% bar(XX,STOTNORM(:,1),'r'); % groups by row
% 
% title('NORMALIZED GSA')
% % ylim([0,VARNUM+1])
% ylim([0, 1])
% 
% grid on


end