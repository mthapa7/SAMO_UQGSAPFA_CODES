%% THIS CODE IS TO get the samples run for PFA!!!
%% TRANSVERSE!!
%% it reads the material properties in SAMPLES and returns the FPF AND ULT DATA in output
function output=pfa_response_transverse(SAMPLES)
global UQGSAPFA
NASTRANEXE_FILEPATH=UQGSAPFA.NASTRANEXE_FILEPATH;
loadtype=UQGSAPFA.loadtype;
size(SAMPLES);
nsamples=length(SAMPLES(:,1))


%% START THE LOOP
for samples_count=1:nsamples
    clc
    fprintf('Running %d sample out of %d samples.\n',samples_count,nsamples)

    %delete FAILURE_MAT_PROP_PUCK.bdf
    delete FAILURE_MAT_PROP_PUCK_BULK2_TRANSVERSE.bdf
    
    %% MATERIAL PROPERTIES
    E11=SAMPLES(samples_count,1); E22=SAMPLES(samples_count,2);  v12=SAMPLES(samples_count,3);   G12= SAMPLES(samples_count,4);
    G23=SAMPLES(samples_count,4); G13=SAMPLES(samples_count,4);
    XT=SAMPLES(samples_count,5); XC=SAMPLES(samples_count,6); YT=SAMPLES(samples_count,7); YC=SAMPLES(samples_count,8);  SS=SAMPLES(samples_count,9);
    %P12T=0.35; P12C=0.3;  %assume this as epistemic uncertainty. Consider as uniform random variables!!
    P12T=SAMPLES(samples_count,10); P12C=SAMPLES(samples_count,11);  %assume this as epistemic uncertainty. Consider as uniform random variables!!
    %%thickness
    t_ply=0.125;   %mm
    %%angles
    STACK_SEQ=[45,0,-45,90,90,-45,0,45] ;% QUASI-ISOTROPIC
    tlay=t_ply*ones(1,8);
    orientlay=STACK_SEQ;
    xcurrent=[E11 E22 v12 G12 XT XC YT YC SS P12T P12C tlay orientlay];
    
    
    %% WRITE THE NEW .BDF FILE!!!!
    FIL_PUCK_BULK2 = fopen('FAILURE_MAT_PROP_PUCK_BULK2_TRANSVERSE.bdf','w');
    %                       $234567812345678$234567812345678$234567812345678$234567812345678$234567812345678
    fprintf(FIL_PUCK_BULK2,'MAT8   * 1              %16.7f%16.7f%16.12f +0001VD\n', E11,E22,v12);
    fprintf(FIL_PUCK_BULK2,'*+0001VD%16.7f%16.7f%16.7f                 +0001VE\n',G12,G23,G13);
    fprintf(FIL_PUCK_BULK2,'MATF   * 1               3                                               +0001VF\n');
    fprintf(FIL_PUCK_BULK2,'*+0001VF                                                                 +0001VG\n');
    fprintf(FIL_PUCK_BULK2,'*+0001VG CRI             8              %16.7f%16.7f +0001VH\n',XT,XC);
    fprintf(FIL_PUCK_BULK2,'*+0001VH%16.7f%16.7f                                 +0001VI\n',YT,YC);
    fprintf(FIL_PUCK_BULK2,'*+0001VI                                                                 +0001VJ\n');
    fprintf(FIL_PUCK_BULK2,'*+0001VJ%16.7f                                %16.12f +0001VK\n',SS,P12T);
    fprintf(FIL_PUCK_BULK2,'*+0001VK%16.12f%16.12f%16.12f                 +0001VL\n',P12T,P12C,P12C);
    fprintf(FIL_PUCK_BULK2,'*+0001VL                                                                 +0001VM\n');
    fprintf(FIL_PUCK_BULK2,'*+0001VM PF                                                              +0001VN\n');
    fprintf(FIL_PUCK_BULK2,'*+0001VN                                                                 +0001VO\n');
    fprintf(FIL_PUCK_BULK2,'++0001VO                                                                 +0001VP\n');
    fprintf(FIL_PUCK_BULK2,'NLSTEP   1      1.                                                       +000001\n');
    fprintf(FIL_PUCK_BULK2,'++000001 GENERAL 10      1       10                                      +000002\n');
    %fprintf(FIL_PUCK_BULK2,'++000002 ADAPT  .01     1.-5    .0100    4      1.2      75      5000    +000003\n');
    fprintf(FIL_PUCK_BULK2,'++000002 ADAPT  .01     1.-5    .0135    4      1.2      75      5000    +000003\n');
    fprintf(FIL_PUCK_BULK2,'++000003         6      2.-4                                             +000004\n');
    fprintf(FIL_PUCK_BULK2,'++000004 MECH    PV                              PFNT                    +000005\n');
    fprintf(FIL_PUCK_BULK2,'++000005                                .2                               +000006\n');
    fprintf(FIL_PUCK_BULK2,'PARAM  * LGDISP          2                                                      \n');
    fprintf(FIL_PUCK_BULK2,'PARAM  * POST            0                                                      \n');
    fprintf(FIL_PUCK_BULK2,'PARAM  * PRTMAXIM        YES                                                    \n');
    fprintf(FIL_PUCK_BULK2,'PCOMP  * 1                                                               +000007\n');
    fprintf(FIL_PUCK_BULK2,'*+000007                                                                 +000008\n');
    %                       $234567812345678$234567812345678$234567812345678$234567812345678$234567812345678
    fprintf(FIL_PUCK_BULK2,'*+000008 1              %16.14f%16.12f YES             +000009\n',tlay(1),orientlay(1));
    fprintf(FIL_PUCK_BULK2,'*+000009 1              %16.14f%16.12f YES             +00000A\n',tlay(2),orientlay(2));
    fprintf(FIL_PUCK_BULK2,'*+00000A 1              %16.14f%16.12f YES             +00000B\n',tlay(3),orientlay(3));
    fprintf(FIL_PUCK_BULK2,'*+00000B 1              %16.14f%16.12f YES             +00000C\n',tlay(4),orientlay(4));
    fprintf(FIL_PUCK_BULK2,'*+00000C 1              %16.14f%16.12f YES             +00000D\n',tlay(5),orientlay(5));
    fprintf(FIL_PUCK_BULK2,'*+00000D 1              %16.14f%16.12f YES             +00000E\n',tlay(6),orientlay(6));
    fprintf(FIL_PUCK_BULK2,'*+00000E 1              %16.14f%16.12f YES             +00000F\n',tlay(7),orientlay(7));
    fprintf(FIL_PUCK_BULK2,'*+00000F 1              %16.14f%16.12f YES             +00000G\n',tlay(8),orientlay(8));
    fprintf(FIL_PUCK_BULK2,'PSHLN1 * 1                                                               +00000H\n');
    fprintf(FIL_PUCK_BULK2,'*+00000H                                                                 +00000I\n');
    %                       $234567812345678$234567812345678$234567812345678$234567812345678$234567812345678
    deltamax=-5.5;
    fprintf(FIL_PUCK_BULK2,'SPCD   * 1               2048            3              %16.12f +0003UC\n',deltamax);
    fprintf(FIL_PUCK_BULK2,'*+0003UC                                                                 +0003UD\n');
    
    fclose(FIL_PUCK_BULK2);
    disp('Material properties changed!!!')
        disp('Please wait, the FEA simulation is running!!!')

    %delete *.mat
    delete *.dat *.f0* *.f04 *.f06 *.log* *.sts* *MAS *IF* *DBALL *MAS* *asm* *pch* *becho* *plt* *aeso* *op2* *bat *rcf
    pause(1)
    
    %% RUN THE CODES FOR NASTRAN!!
    %% RUN THE CODES FOR NASTRAN!!
    %% THIS SELECTES THE CODE BASED ON THE TYPE OF LOADING
    if strcmp(loadtype,'TENS')
        NASTRAN_filename='OMHARE_PUCK_BULK2_IA_TENSION.bdf';
    elseif strcmp(loadtype,'COMP')
        NASTRAN_filename='OMHARE_PUCK_BULK2_IA_COMPRESSION.bdf';
    elseif strcmp(loadtype,'TRAN')
        NASTRAN_filename='OMHARE_PUCK_BULK2_IA_TRANSVERSEDISP.bdf';
    end
    command_mattonastran=strcat([NASTRANEXE_FILEPATH, ' ', NASTRAN_filename, ' ', 'scr=yes old=no delete=f04,log,xdb']);
    system(command_mattonastran);
    pause(300);    %wait for six minutes to complete the simulation!!!
    
    %% EXTRACT THE DATA!!!
postprocess_nastrandata_transverse()
%     run CODE2_LOADDISP_ERR_RESP_2.m  %this code runs for any broken simulations early!!!
%     run CODE1_READ_DATA.m
%     %%run CODE2_FORCE_DISP_READ.m
%     run CODE3_FPF_ULT_DATA.m
     
    %% SAVE THE DATA!!    %%% CAN SAVE MORE DATA!!!
    load('FPF_DATA.mat')
    load('ULT_DATA.mat')
    OUTPUT_FI(samples_count,:)=[FPF_DATA ULT_DATA];
    output=OUTPUT_FI;
    %% SAVE THE DATA FOR EACH RUN
    OUTPUT=OUTPUT_FI;
    save('OUTPUT.mat','OUTPUT'); save('OUTPUT.dat','OUTPUT','-ascii');
    fprintf('Time for simulation of %d out of nsamples=%d is %f secs.\n',samples_count,nsamples,toc)
    
end

end
