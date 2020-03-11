%%%Author: Mishal Thapa
%%%Contact: mthapa@crimson.ua.edu
%%Date: 02/2019-10/2019
%%%-----------------------------------------------
%% CODE DETAILS
%%%THIS FILE GENERATES THE LHS SAMPLES FOR THE 11 RANDOM MATERIAL
%%%PROPERTIES USING LATIN HYPERCUBE SAMPLING!!!
%%HERE CAN USE SOBOL SEQUENCE SAMPLING FOR MONTE CARLO SIMULATION!!!!
%%% PUCK  FAILURE CRITERIA!!
%%this code run for three types of loading mentioned in the paper: 
%%TENS: inplane uniaxial tension
%%COMP: inplane uniaxial compression
%%TRAN: out of plane transverse loading

%% START THE PROGRAM
clc
clear all
close all
tic
delete('*.mat'); delete('*.dat')

%% SPECIFY THE LOAD TYPE: TENS (TENSION), COMP (COMPRESSION), TRAN (OUT OF PLANE TRANSVERSE LOADING)
global UQGSAPFA
UQGSAPFA.NASTRANEXE_FILEPATH='C:\MSC.Software\MSC_Nastran\20131\bin\nastranw.exe';
UQGSAPFA.loadtype='TENS';  % FOR EXAMPLE TENSION USED HERE!!!

%% GENERATE THE RANDOM NUMBERS FOR THE VARIABLES!
VARNUM=11;   %FOR MATEIRAL PROPERTIES: 11 INCLUDING PUCK, 8 PLY-THICKNESS, 8 PLY-ORIENTATIONS..
SAMPNUM=3    %5e3;  %% TOTAL NUMBER OF SAMPLES

%% Latin Hypercube design!!
KS_SAMPLES = lhsdesign(SAMPNUM,VARNUM,'criterion','correlation','iterations',10);

%% CAN USE SOBOL SEQUENCE FOR SAMPLING AS WELL!!!
% %% GENERATE THE SOBOL SAMPLES!!!!
% pbank_sobol = sobolset(VARNUM,'Skip',1e3,'Leap',1e2);
% pbank_sobol = scramble(pbank_sobol,'MatousekAffineOwen');
% save('pbank_sobol.mat','pbank_sobol')        ;
% KS_SAMPLES=pbank_sobol(1:SAMPNUM,:);

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

%%thickness
t_tot=0.125*8;
t_ply=0.125;   %mm
t1=t_ply*ones(SAMPNUM,1);       %icdf('normal',KS_SAMPLES(:,1),t_ply,covals*t_ply);
t2=t_ply*ones(SAMPNUM,1);       %icdf('normal',KS_SAMPLES(:,2),t_ply,covals*t_ply);
t3=t_ply*ones(SAMPNUM,1);       %icdf('normal',KS_SAMPLES(:,3),t_ply,covals*t_ply);
t4=t_ply*ones(SAMPNUM,1);       %icdf('normal',KS_SAMPLES(:,4),t_ply,covals*t_ply);
t5=t_ply*ones(SAMPNUM,1);       %icdf('normal',KS_SAMPLES(:,5),t_ply,covals*t_ply);
t6=t_ply*ones(SAMPNUM,1);       %icdf('normal',KS_SAMPLES(:,6),t_ply,covals*t_ply);
t7=t_ply*ones(SAMPNUM,1);       %icdf('normal',KS_SAMPLES(:,7),t_ply,covals*t_ply);
t8=t_ply*ones(SAMPNUM,1);       %icdf('normal',KS_SAMPLES(:,8),t_ply,covals*t_ply);

%%angles
STACK_SEQ=[45,0,-45,90,90,-45,0,45] ;% QUASI-ISOTROPIC
ang1=STACK_SEQ(1)*ones(SAMPNUM,1);       %icdf('normal',KS_SAMPLES(:,9),STACK_SEQ(1),3);   %STANDARD DEVIATION OF 5 DEGREES FOR ALL THE PLIES!
ang2=STACK_SEQ(2)*ones(SAMPNUM,1);       %icdf('normal',KS_SAMPLES(:,10),STACK_SEQ(2),3);
ang3=STACK_SEQ(3)*ones(SAMPNUM,1);       %icdf('normal',KS_SAMPLES(:,11),STACK_SEQ(3),3);
ang4=STACK_SEQ(4)*ones(SAMPNUM,1);       %icdf('normal',KS_SAMPLES(:,12),STACK_SEQ(4),3);
ang5=STACK_SEQ(5)*ones(SAMPNUM,1);       %icdf('normal',KS_SAMPLES(:,13),STACK_SEQ(5),3);
ang6=STACK_SEQ(6)*ones(SAMPNUM,1);       %icdf('normal',KS_SAMPLES(:,14),STACK_SEQ(6),3);
ang7=STACK_SEQ(7)*ones(SAMPNUM,1);       %icdf('normal',KS_SAMPLES(:,15),STACK_SEQ(7),3);
ang8=STACK_SEQ(8)*ones(SAMPNUM,1);       %icdf('normal',KS_SAMPLES(:,16),STACK_SEQ(8),3);

%% BASIS SAMPLES: 11 RANDOM INPUTS
matprop=[E11 E22 v12 G12 XT XC YT YC SS P12T P12C];

% %% Geometric properties
tlay=[t1,t2,t3,t4,t5,t6,t7,t8];
orientlay=[ang1, ang2, ang3, ang4,ang5, ang6, ang7, ang8];

%%combine all random parameters!!!
MCSSAMPLES_PFA_NASTRAN=[matprop tlay orientlay];
save('MCSSAMPLES_PFA_NASTRAN.mat', 'MCSSAMPLES_PFA_NASTRAN')

SAMPLES_PFA=MCSSAMPLES_PFA_NASTRAN;   %DIVIDE THE SAMPLES_PFA!
SAMPNUM_PFA=length(SAMPLES_PFA(:,1));
save('SAMPLES_PFA.mat','SAMPLES_PFA'); save('SAMPLES_PFA.dat','SAMPLES_PFA','-ascii');
[mean(SAMPLES_PFA) std(SAMPLES_PFA)];

%% NOW GET THE RESPONSES FOR LHS SAMPLES BY CALLING NASTRAN
LHSMAIN_OUTPUTMAIN=pfa_response(SAMPLES_PFA);
LHSMAIN_SAMPLES=SAMPLES_PFA;
[size(LHSMAIN_OUTPUTMAIN) size(LHSMAIN_SAMPLES)]


%% POST-PROCESS THE MCS DATA
LHSMEAN_PFA=mean(LHSMAIN_OUTPUTMAIN);
LHSSTD_PFA=std(LHSMAIN_OUTPUTMAIN);

%% SAVE THE DATA
save('LHSMAIN_OUTPUTMAIN.mat','LHSMAIN_OUTPUTMAIN'); save('LHSMAIN_OUTPUTMAIN.dat','LHSMAIN_OUTPUTMAIN','-ascii');
save('LHSMAIN_SAMPLES.mat','LHSMAIN_SAMPLES'); save('LHSMAIN_SAMPLES.dat','LHSMAIN_SAMPLES','-ascii');
save('LHSMEAN_PFA.mat','LHSMEAN_PFA'); save('LHSMEAN_PFA.dat','LHSMEAN_PFA','-ascii');
save('LHSSTD_PFA.mat','LHSSTD_PFA'); save('LHSSTD_PFA.dat','LHSSTD_PFA','-ascii');
