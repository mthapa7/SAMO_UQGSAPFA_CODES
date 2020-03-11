%GENEREATE THE PCE TERMS using the multi-indices at given samples
function Amatrix=Amatrix_fun22(MULTIIND, NUMSAMP, BASIS_SAMP_ALL)
P1=size(MULTIIND,1);
Amatrix=zeros(NUMSAMP,P1);
for SAMP_ITR=1:NUMSAMP
    for MULTIIND_SEQ_ITR=1:P1
        Amatrix(SAMP_ITR,MULTIIND_SEQ_ITR)=ORTHOPOLY(MULTIIND(MULTIIND_SEQ_ITR,:),BASIS_SAMP_ALL(SAMP_ITR,:)); 
    end
end
% disp(size(Amatrix));
end