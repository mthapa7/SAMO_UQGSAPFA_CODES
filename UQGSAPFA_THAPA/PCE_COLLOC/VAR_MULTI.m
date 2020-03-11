
function OUTPUT=VAR_MULTI(MULTIIND_ITR)
%
%% THIS CALCULATES THE VARIANCE FOR THE NORMAL AS WELL UNIFORM AND OTHER  RANDOM VARIABELS ORTHOPOLY FOR A PARTICULAR kth MULTIINDEX! 
%%eg:- OUTPUT=VAR_MULTI([1 0 1 1]) 
%%CAN BE MODIFIED FOR UNIFORM AND NORMAL COMBINED!!!!
%-------------------------------------------------
global UQGSAPFA
STATS=UQGSAPFA.STATS;
DISTRIBUTION=UQGSAPFA.DISTRIBUTION;

%%run the calculation!!!
OUTPUTDUM=1;  %Initially assume the product is 1. then loop finds the product for given number and types of variables!!
for itr=1:length(MULTIIND_ITR)
    if DISTRIBUTION(itr)==1   %%%1 for normal, 2 for uniform
        OUTPUTDUM=OUTPUTDUM*factorial(MULTIIND_ITR(itr));
        
    elseif DISTRIBUTION(itr)==2   % 2 for uniform
        OUTPUTDUM=OUTPUTDUM*1/(2*MULTIIND_ITR(itr)+1);
        %CAN ADD OTHER DISTRIBUTIONS AS WELL!!
    end
end
OUTPUT=OUTPUTDUM;
end