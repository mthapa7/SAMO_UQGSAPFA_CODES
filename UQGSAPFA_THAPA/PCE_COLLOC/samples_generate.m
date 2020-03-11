%% this subfunction is to generate the samples!!
function OUTPUT=samples_generate(nsamp,VARNUM,COUNT)
global UQGSAPFA;
% %% Latin Hypercube design!!
% KS_SAMPLES = lhsdesign(SAMPNUM,VARNUM,'criterion','correlation','iterations',10);

%% CAN USE SOBOL SEQUENCE FOR SAMPLING AS WELL!!!
%% GENERATE THE SOBOL SAMPLES!!!!
if COUNT==1
    pbank_sobol = sobolset(VARNUM,'Skip',1e3,'Leap',1e2);
    pbank_sobol = scramble(pbank_sobol,'MatousekAffineOwen');
    save('pbank_sobol.mat','pbank_sobol')        ;
else
    load('pbank_sobol.mat','pbank_sobol')        ;
    
end
KS_SAMPLES=pbank_sobol(1:nsamp,:);  %generate largeset but use sequentially!!!

%% MATERIAL PROPERTIES: RANDOM INPUT PROPERTIES
E11m=172400; E22m= 10300;  v12m=0.32 ;   G12m= 5520;   G23=G12m;   G13=G12m;
XTm=2826.5; XCm=1620; YTm=65.5; YCm=248;  Sm=122;
P12Tm=0.35; P12Cm=0.3;  %assume this as epistemic uncertainty. Consider as uniform random variables!!

%% BASIS RANDOM VARIABLES SAMPLES FOR MCS!
% USING GAUSSIN RANDOM VARIABLES BUT CAN USE OTHER DISTRIBUTION AS WELL
covals=0.1;
E11=icdf('normal',KS_SAMPLES(:,1),E11m,covals*E11m);
E22=icdf('normal',KS_SAMPLES(:,2),E22m,covals*E22m);
v12=icdf('normal',KS_SAMPLES(:,3),v12m,covals*v12m);
G12=icdf('normal',KS_SAMPLES(:,4),G12m,covals*G12m);
G23=G12; G13=G12;
XT=icdf('normal',KS_SAMPLES(:,5),XTm,covals*XTm);  %Longitudinal Tensile Strength of Fiber
XC=icdf('normal',KS_SAMPLES(:,6),XCm,covals*XCm);   %Tensile  Strength of Matrix
YT=icdf('normal',KS_SAMPLES(:,7),YTm,covals*YTm);  %Compressive  Strength of Matrix
YC=icdf('normal',KS_SAMPLES(:,8),YCm,covals*YCm);  %Shear Strength of Matrix
SS=icdf('normal',KS_SAMPLES(:,9),Sm,covals*Sm);  %Shear Strength of Matrix
P12T=icdf('normal',KS_SAMPLES(:,10),P12Tm,covals*P12Tm);  %PUCK PARAMETER
P12C=icdf('normal',KS_SAMPLES(:,11),P12Cm,covals*P12Cm);  %PUCK PARAMETER
%% BASIS SAMPLES: 11 RANDOM INPUTS
matprop_basis=[E11 E22 v12 G12 XT XC YT YC SS P12T P12C];

BASISSAMPLES_PFA=matprop_basis;     % ONLY THE MATERIAL PROPERTIES ARE RANDOM VARIABLES!!!!
size(BASISSAMPLES_PFA);
save('BASISSAMPLES_PFA.mat', 'BASISSAMPLES_PFA');
OUTPUT=BASISSAMPLES_PFA;
end

