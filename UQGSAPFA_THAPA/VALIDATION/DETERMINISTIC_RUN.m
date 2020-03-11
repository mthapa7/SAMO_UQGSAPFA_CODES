%% THIS CODE IS FOR DETERMINISTIC RUN FOR VALIDATION
%% LIU EXPERIMENTDAL COMPARISON: SECTION 5.1
%% IT CALLS THE NASTRAN BASED ON THE DATA PROVIDED HERE
clc
clear all
close all
tic
global UQGSAPFA
UQGSAPFA.NASTRANEXE_FILEPATH='C:\MSC.Software\MSC_Nastran\20131\bin\nastranw.exe';
UQGSAPFA.loadtype='TENS'; %%TENS: inplane uniaxial tension

%% MATERIAL PROPERTIES units in SI.
E11m=172400; E22m= 10300;  v12m=0.32 ;   G12m= 5520;   G23=G12m;   G13=G12m;
XTm=2826.5; XCm=1620; YTm=65.5; YCm=248;  Sm=122;
P12Tm=0.35; P12Cm=0.3;  %assume this as epistemic uncertainty. Consider as uniform random variables!!
STACK_SEQ=[45,0,-45,90,90,-45,0,45] ;% QUASI-ISOTROPIC ply sequence
matprop=[E11m E22m v12m G12m XTm XCm YTm YCm Sm P12Tm P12Cm]

%% Geometric properties
t_ply=0.125;   %mm  (ply thickness)
tlay=t_ply*ones(1,8);

LHSSAMPLES_PFA_NASTRAN=[matprop tlay STACK_SEQ];
pfa_response(LHSSAMPLES_PFA_NASTRAN);
toc