function [MEANCOLL, STDCOLL, PCcoeffs]=COLLOC_PC(MULTIIND,NUMSAMP,BASIS_SAMP_ALL,EXACT_OUTPUT)
%% SOLVE THE POLYNOMIAL CHAOS USING THE STOCHASTIC COLLOCATION APPROACH
%-----------------------------------------------
P1=length(MULTIIND);
Amatrix=Amatrix_fun22(MULTIIND, NUMSAMP, BASIS_SAMP_ALL);  
PCcoeffs=linsolve(Amatrix,EXACT_OUTPUT);    %these two provide same
pause(0.5)
save('Amatrix.mat','Amatrix');
% save('PCcoeffs.mat','PCcoeffs');
%% STATISTICAL MOMENTS
for respcount=1:size(PCcoeffs,2)
[MEANCOLL(respcount),STDCOLL(respcount)]=STAT_MOMENTS(PCcoeffs(:,respcount),MULTIIND);
end
end