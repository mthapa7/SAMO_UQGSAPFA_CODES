%%%Author: Mishal Thapa
%%%Contact: mthapa@crimson.ua.edu
%%Date: 02/2019-10/2019
%%%-----------------------------------------------
%% CODE DETAILS:
%%----------------------------------------------
%%FRAMEWORK PRESENTED IN FIG.2 IN SECTION 4
%%THIS SCRIPT UTILIZES LEAST-SQUARES COLLOCATION FOR UQ AND GSA FOR PROGRESSIVE FAILURE OF COMPOSITES
%%this code run for three types of loading mentioned in the paper:
%%TENS: inplane uniaxial tension
%%COMP: inplane uniaxial compression
%%TRAN: out of plane transverse loading

%% START HERE
%%%-----------------------------------------
clc
clear all
close all
delete *.mat *.dat
format short e
global UQGSAPFA
UQGSAPFA.NASTRANEXE_FILEPATH='C:\MSC.Software\MSC_Nastran\20131\bin\nastranw.exe';
UQGSAPFA.loadtype='TENS' %input('Please enter the loading type among TENS, COMP, and TRAN:','s')  %if s at the end then it is string
VARIABLES_NUM=11;    %number of random input variables!!!!
DISTRIBUTION=ones(VARIABLES_NUM,1)   ; %1 for Normal and 2 for Uniform!!
VARNUM=length(DISTRIBUTION);  %NUMBER OF VARIABLES
NUMOUTPUT=1;  %NUMBER OF OUTPUTS!

%% STATS FOR GIVEN VARIABLES
disp('The input random variables are Gaussian!!!')
disp('---------------------------------------------------------------------------------------------------')

disp('The mean and std of the inputs are:')
disp('---------------------------------------------------------------------------------------------------')

%% RANDOM INPUT MATERIAL PROPERTIES
E11m=172400; E22m= 10300;  v12m=0.32 ;   G12m= 5520;   G23=G12m;   G13=G12m;
XTm=2826.5; XCm=1620; YTm=65.5; YCm=248;  Sm=122;
P12Tm=0.35; P12Cm=0.3;  %assume this as epistemic uncertainty. Consider as uniform random variables!!
% THE MEAN AND STD OF THE RANDOM INPUTS FOR GAUSSIAN DISTRIBUTION!!!
STATS=[E11m,0.1*E11m;
    E22m,0.1*E22m;
    v12m,0.1*v12m;
    G12m,0.1*G12m;
    XTm,0.1*XTm;
    XCm,0.1*XCm;
    YTm,0.1*YTm;
    YCm,0.1*YCm;
    Sm,0.1*Sm;
    P12Tm,0.1*P12Tm;
    P12Cm,0.1*P12Cm;
    ]

UQGSAPFA.DISTRIBUTION=DISTRIBUTION;
UQGSAPFA.STATS=STATS;
UQGSAPFA.VARNUM=VARNUM;
disp('---------------------------------------------------------------------------------------------------')

PCORD_MAX=2;   %MAXIMUM PC ORDER
COUNT=1;   %INITIALIZE THE TOTAL ITERATION COUNT!!!

%% START THE MAIN LOOP!
NP_INIT=2   %input('Please enter the initial sampling ratio:')  %if s at the end then it is string
NUMSAMP_NEW=0;  %initially assume the samling for adding sequentially is zero so that 2*NP used!
goodcount=0; %used for convergence!!
for PCORD=1:PCORD_MAX   %STARTS FROM PCORDER 1 AND UNTILL PCORDER 3!!
    %% GENERATE THE MULTIINDICES
    if PCORD==1
        MULTIIND=polymultiindex(VARNUM,PCORD);
    elseif PCORD>=2
        %% ADD NEW MULTI-INDICES FOR NEW ORDER!!!!
        TRUNC_DIM=[1:VARNUM];  %THIS IS FOR INITIAL PCE ORDER!!!
        MULTINDEX_ADDITION=DIM_MULTIND_ADAPTIVE(VARNUM,TRUNC_DIM, PCORD-1, PCORD);   %%NEW PCE TERMS FOR DIMENSION ADAPTIVE PCE!!
        MULTINDEX_ADDITION=polymultiind_rearrange(VARNUM,MULTINDEX_ADDITION);
        
        %% TRY WITH LOW-ORDER INTERACTION POLYNOMIALS
        interactionorder=2 ;  % 2 FOR TENS and COMP; 3 for TRAN
        pause(0.5)
        MULTINDEX_ADDITION_REFINED=polymultiind_loworder(VARNUM,interactionorder,MULTINDEX_ADDITION);
        % MULTIIND_OLD=[MULTIIND_OLD;MULTINDEX_ADDITION_REFINED]
        [size(MULTINDEX_ADDITION) size(MULTINDEX_ADDITION_REFINED)]
        MULTIIND=[MULTIIND;MULTINDEX_ADDITION_REFINED];  % add the multi-indices to previous
    end
    
    
    MULTIINDEX(1:length(MULTIIND),1:VARNUM,PCORD)=MULTIIND;
    save('MULTIINDEX.mat','MULTIINDEX');   save('MULTIIND.mat','MULTIIND');
    
    
    %%proper sampling ratio!!
    NP=NP_INIT;
    %%USE PCE!!!!
    NUMSAMP_OLD=NP*size(MULTIIND,1)   %floor(NP*factorial(VARNUM+PCORD)/(factorial(VARNUM)*factorial(PCORD))); %the number of samples must be greater than the number of coefficients!
    if NUMSAMP_OLD>=NUMSAMP_NEW
        NUMSAMP=NUMSAMP_OLD
    else
        NUMSAMP=NUMSAMP_NEW;
    end
    
    
    repeat=0;
    while(1)
        
        %% GENERATE THE BASIS SAMPLES!!!!
        if COUNT==1
            BASIS_SAMP=samples_generate(NUMSAMP,VARNUM,COUNT);
            %%GET THE RESPONSES FOR THE GIVEN STATS AND SAMPLES
            EXACT_OUTPUT=getresponses_nastran(BASIS_SAMP);   %the number of ROWS IN THE BASIS SAMPLES SHOULD BE EQUAL TO THE NUMBER OF SAMPLES.
        else   %add the new samples on the previous set!!!
            load BASIS_SAMP.mat; load EXACT_OUTPUT.mat;
            sampsize_old=size(BASIS_SAMP,1);
            samp_add=NUMSAMP-sampsize_old;
            if samp_add>0
                BASIS_SAMP_bank=samples_generate(NUMSAMP,VARNUM,COUNT);
                BASIS_SAMP_add=BASIS_SAMP_bank(sampsize_old+1:NUMSAMP,:);  %get responses for new samples only
                EXACT_OUTPUT_add=getresponses_nastran(BASIS_SAMP_bank(sampsize_old+1:NUMSAMP,:));  %get responses for new samples only
                BASIS_SAMP=[BASIS_SAMP;BASIS_SAMP_add];
                EXACT_OUTPUT=[EXACT_OUTPUT;EXACT_OUTPUT_add];
            end
        end
        
        save('BASIS_SAMP.mat','BASIS_SAMP'); save('BASIS_SAMP.dat','BASIS_SAMP','-ascii');
        save('EXACT_OUTPUT.mat','EXACT_OUTPUT');  save('EXACT_OUTPUT.dat','EXACT_OUTPUT','-ascii');
        [size(BASIS_SAMP) size(EXACT_OUTPUT)];
        
        %% MAIN ALGORITHM using least-squares PCE!!!
        [MEANCOLL, STDCOLL, PCcoeffs]=COLLOC_PC(MULTIIND,NUMSAMP,BASIS_SAMP,EXACT_OUTPUT);
        
        %% SAVE THIS FOR PDFs!!
        PCCOEFFVAL(1:size(MULTIIND,1),:,PCORD)=PCcoeffs;
        save('PCCOEFFVAL.mat','PCCOEFFVAL');
        
        %% SAVE THE STATISTICS!!!
        RESULTS1(PCORD,:)=[MEANCOLL, STDCOLL, NUMSAMP]  %STATISTICS OF THE RESPONSES!!!
        save('RESULTS1.mat','RESULTS1'); save('RESULTS1.dat','RESULTS1','-ascii');
        
        %% CALCULATE THE CV-ERROR
        CV_NUMSAMP=1E2;
        if COUNT==1    %% THE CV SAMPLES ARE GENERATED ONLY ONCE!!!!
            BASIS_SAMP_CROSSVALIDATE_BANK=samples_generate(2000,VARNUM,2);  %2: USE THE PREVIOUS sobol samples bank!!!!
            %%GET THE RESPONSES FOR THE GIVEN STATS AND SAMPLES
            BASISSAMP_CV=BASIS_SAMP_CROSSVALIDATE_BANK(end-CV_NUMSAMP+1:end,:);
            EXACT_OUTPUT_CV=getresponses_nastran(BASISSAMP_CV);   %the number of ROWS IN THE BASIS SAMPLES SHOULD BE EQUAL TO THE NUMBER OF SAMPLES.
            save('BASISSAMP_CV.mat','BASISSAMP_CV')
            save('EXACT_OUTPUT_CV.mat','EXACT_OUTPUT_CV')
            
        end
        
        
        %cross-validate!!!!
        for itk=1:NUMOUTPUT
            PCE_RESP_CV(:,itk)=PCESURROG(PCcoeffs(:,itk), MULTIIND, BASISSAMP_CV);  % PCE SURROGATE!!!!!
            RELATIVE_LE2ERR(COUNT,itk)=(sum((EXACT_OUTPUT_CV(:,itk)-PCE_RESP_CV(:,itk)).^2))^(1/2)./(sum((EXACT_OUTPUT_CV(:,itk)).^2))^(1/2);
            REL_ERR_CV(COUNT,itk)=(sum((EXACT_OUTPUT_CV(:,itk)-PCE_RESP_CV(:,itk)).^2))^(1)./(sum((EXACT_OUTPUT_CV(:,itk)-mean(EXACT_OUTPUT_CV(:,itk))).^2))^(1);
        end
        save('PCE_RESP_CV.mat','PCE_RESP_CV')
        save('RELATIVE_LE2ERR.mat','RELATIVE_LE2ERR')
        save('REL_ERR_CV.mat','REL_ERR_CV')
        
        
        %%   %%%GLOBAL SENSITIVITY ANALSYSIS!!
        NUMOUTPUT=size(EXACT_OUTPUT,2);
        [STOT(:,:,PCORD), STOTNORM(:,:,PCORD)]=global_sensitivity_sobol(VARNUM, NUMOUTPUT, MULTIIND,PCcoeffs);
        
        %% SAVE THE MAIN DATA
        save('PCCOEFFVAL.mat','PCCOEFFVAL');
        save('MULTIINDEX.mat','MULTIINDEX');
        save('STOT.mat','STOT');
        save('STOTNORM.mat','STOTNORM');
        
        
        %% CONVERGENCE CHECK AND RE-SAMPLES!!!!
        if PCORD==1
            COUNT=COUNT+1
            break;
        elseif PCORD>=2
            ERROR_STATISTICS(PCORD,:)=abs(RESULTS1(PCORD,1:2*NUMOUTPUT)-RESULTS1(PCORD-1,1:2*NUMOUTPUT))./RESULTS1(PCORD,1:2*NUMOUTPUT)*100
            COV_WTS=STDCOLL./MEANCOLL;
            
            %% ADD 50 SAMPLES UNTIL GOOD ACCURACY FOR 5 TIMES!!!!
            if max(abs(ERROR_STATISTICS(PCORD,:)))>=5    %%for accuracy check for different responses!!!!!
                %NP=NP+0.5;
                NUMSAMP=NUMSAMP+50;
                PCORD=PCORD;
            elseif (max(abs(ERROR_STATISTICS(PCORD,:)))<5)
                NUMSAMP_NEW=NUMSAMP
                goodcount=goodcount+1;
                break;
            end
        end
        repeat=repeat+1;
        COUNT=COUNT+1;
        
        %% SAVE THE DATA!!
        save('ERROR_STATISTICS.mat','ERROR_STATISTICS')
        save('COV_WTS.mat','COV_WTS');
        
        
        %% TO LIMIT THE MAXIMUMUM SAMPLE ADDITION!!!
        if strcmp(UQGSAPFA.loadtype,'TENS')|| strcmp(UQGSAPFA.loadtype,'TENS')
            if repeat>=10    %use 10 for TENS/COMP and 5 for TRAN
                break;
            end
        elseif strcmp(UQGSAPFA.loadtype,'COMP')||strcmp(UQGSAPFA.loadtype,'COMP')
            if repeat>=10    %use 10 for TENS/COMP and 5 for TRAN
                break;
            end
        elseif strcmp(UQGSAPFA.loadtype,'TRAN')|| strcmp(UQGSAPFA.loadtype,'TRAN')
            if repeat>=5    %use 10 for TENS/COMP and 5 for TRAN
                break;
            end
        end
        
    end
    %% CONVERGENCE ANALYSIS TO BREAK THE ITERATION!! (stops when satisfies tolerance or exceeds maximum PC order)
    if strcmp(UQGSAPFA.loadtype,'TENS')==1||strcmp(UQGSAPFA.loadtype,'COMP')==1
        if  (goodcount==2)||(PCORD>=5)
            disp('Maximum criterion reached!!')
            break;
        end
    elseif strcmp(UQGSAPFA.loadtype,'TRAN')==1
        if  (goodcount==1)||(PCORD>=3)
            disp('Maximum criterion reached!!')
            break;
        end
    end
end

%% PLOT THE PDFS AND CORRELATIONS OF SAMPLES AND PCE
run PDF_PLOTS_MAIN.m
run PLOTS_CORRELATION.m
run PLOTS_PIE_HBAR


