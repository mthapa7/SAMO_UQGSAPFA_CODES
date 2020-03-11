
function OUTPUT=multiorthopoly(MULTIIND,BASIS_ONESAMPLE)

%%Comments
%% THIS SCRIPT FILE FINDS THE MULTIORHTOPOLY or calculates all the multivariate orthogonal polynomials evaluated at a particular single sample point!
%The complete Multiindices are in MULTIIND and the one sample at a time are
%used!!!

%%%[DISTRIBUTION means the distribution of the random variables!
%%1=Normal distribution
%%2=Uniform distribution
%---------------------------------------
global UQGSAPFA
STATS=UQGSAPFA.STATS;
DISTRIBUTION=UQGSAPFA.DISTRIBUTION;
%---------------------------------------
% global ASPCETCTV
% STATS=ASPCETCTV.STATS;
% DISTRIBUTION=ASPCETCTV.DISTRIBUTION;

multiind_dimension=size(MULTIIND);
ROWITRMAX=multiind_dimension(1) ;   %this means the number or multi-indices in the sequence
NVARS=multiind_dimension(2)  ;   %this means the number of variables or multidex in a kth multiindices sequence
MULTIIORTHOPOLY=zeros(ROWITRMAX,1);
for ROWITR=1:ROWITRMAX
    OUTPUTDUM=1;  %Initially assume the product is 1. then loop finds the product for given number and types of variables!!
    for VARCOLITR=1:NVARS
        if DISTRIBUTION(VARCOLITR)==1
        OUTPUTDUM=OUTPUTDUM*HERMITEPOLY(MULTIIND(ROWITR,VARCOLITR),BASIS_ONESAMPLE(VARCOLITR));
		elseif DISTRIBUTION(VARCOLITR)==2
        OUTPUTDUM=OUTPUTDUM*LEGENPOLY(MULTIIND(ROWITR,VARCOLITR),BASIS_ONESAMPLE(VARCOLITR));
		end
        
    end
    
    MULTIIORTHOPOLY(ROWITR)=OUTPUTDUM;
    
end
OUTPUT=MULTIIORTHOPOLY;
end