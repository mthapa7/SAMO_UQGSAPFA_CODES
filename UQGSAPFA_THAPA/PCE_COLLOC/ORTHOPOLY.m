%%This code calculate ths product of the multivariate polynomials for a kth (single) multindices sequence!!!
%%ORTHOGONAL POLYNOMIALS: GENERALIZED AND MIXED FOR NORMAL AND UNIFORM RANDOM VARIABLES!!
%%%CAN ADD OTHER TYPES OF VARIABLES AS WELL!!!
function OUTPUT=ORTHOPOLY(MULTIIND,BASIS_SAMP)
%%Comments
%%%[DISTRIBUTION means the distribution of the random variables!
%%1=Normal distribution
%%2=Uniform distribution
%---------------------------------------
global UQGSAPFA
STATS=UQGSAPFA.STATS;
DISTRIBUTION=UQGSAPFA.DISTRIBUTION;
OUTPUTDUM=1;  %Initially assume the product is 1. then loop finds the product for given number and types of variables!!
multiind_dimension=size(MULTIIND);
ROWITRMAX=multiind_dimension(1)  ;  %this means the number or multi-indices in the sequence
NVARS=multiind_dimension(2);

for itr=1:NVARS
    if DISTRIBUTION(itr)==1
    OUTPUTDUM=OUTPUTDUM*HERMITEPOLY(MULTIIND(itr),BASIS_SAMP(itr));
    elseif DISTRIBUTION(itr)==2
            OUTPUTDUM=OUTPUTDUM*LEGENPOLY(MULTIIND(itr),BASIS_SAMP(itr));
    end
end
OUTPUT=OUTPUTDUM;
end
