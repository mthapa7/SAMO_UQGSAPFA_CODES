function [MEANCOLL,STDCOLL]=STAT_MOMENTS(PCcoeffs,MULTIIND)

%% TO FIND THE MEAN AND VARIANCE FROM THE PCCOEFFS AND MULTIINDICES!
%-----------------------------------------------------------------------
SUM=0;
COUNT=0;
for itr=2:length(PCcoeffs)
    SUM=SUM+PCcoeffs(itr)^2*VAR_MULTI(MULTIIND(itr,:));
    COUNT=COUNT+1;
end
VarCOLL=SUM;
MEANCOLL=PCcoeffs(1);
STDCOLL=sqrt(VarCOLL);
end

