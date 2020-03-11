%% THIS CODE INCLUDES THE FILES FOR POST-PROCESSING!!!
function postprocess_nastrandata_compression()
%% THIS CODE IS INCLUDE IN THE pfa_response and IS USED for post-processing of FEA results
clc
%clear all
% close all
%tic
format short e

A =  exist('omhare_puck_bulk2_ia_compression.f06','file');
%A =  exist('data_correct.dat','file');
if A ==0
    pause(20);
else
    disp('The .f06 file is existing!!!')
end

%% reading result from sampleCopy.pch
%% this file contains codes for reading the data from the punch file
clc
FID2 =  fopen('omhare_puck_bulk2_ia_compression.f06','r');
%FID2 =  fopen('data_correct.dat','r');

B = feof(FID2);
while B~=0
    pause(3);
end

NUMOUTPUT=75;   %maximum number of load-steps!!!
FAILURE_DATA_MAIN=[];   % TO STORE THE ALL FAILURE INFORMATION!!!
for MAINLOAD_COUNT=1:NUMOUTPUT
    
    for INNERCOUNT=1:4;
        if MAINLOAD_COUNT==1
            if INNERCOUNT==1
                ctval=1;
                InputText0=textscan(FID2,'%s %s %s %s %s %s',1,'delimiter','=','HeaderLines',6680);
                while(1)
                    %                     celldisp(InputText0)
                    
                    timestep=str2num(InputText0{2}{1});
                    InputText0{1};
                    InputText0{2};
                    %if isempty(timestep)~=1
                    if isempty(timestep)~=1
                        if (0<timestep)&&(timestep<=1)
                            disp('Reading proper time-step!!')
                            break;
                        end
                    else
                        InputText0=textscan(FID2,'%s %s %s %s %s %s',1,'delimiter','=','HeaderLines',1);
                        
                        disp('Reading another line!!!') ;
                        
                        ctval=ctval+1;
                        
                    end
                    if ctval>=100;
                        disp('Error in code!!!')
                        return;
                    end
                end
                % 1
            else
                InputText0=textscan(FID2,'%s %s %s %s %s %s',1,'delimiter','=','HeaderLines',4);
                timestep=str2num(InputText0{2}{1});
                
                %   2
            end
        elseif  MAINLOAD_COUNT>=2
            clear timestep
            if INNERCOUNT==1
                InputText0=textscan(FID2,'%s %s %s %s %s %s',1,'delimiter','=','HeaderLines',610);
                %                 celldisp(InputText0)
                
                while(1)
                    
                    timestep=str2num(InputText0{2}{1});
                    
                    [InputText0{1} InputText0{2}];
                    
                    if isempty(timestep)~=1
                        % disp('The good time-step found!!!')
                        %pause(5)
                        break;
                    elseif isempty(timestep)==1
                        InputText0=textscan(FID2,'%s %s %s %s %s %s',1,'delimiter','=');
                        
                    end
                end
                
                
                % 3
            else
                InputText0=textscan(FID2,'%s %s %s %s %s %s',1,'delimiter','=','HeaderLines',4);
                timestep=str2num(InputText0{2}{1});
                
                %  4
            end
        end
        

        ctpik=1;
        while(1)
            
            if (isempty(timestep)~=1)
                %disp('Time step found!')
                InputText1=textscan(FID2,'%s %s %s %s %s %s',1,'delimiter','=','HeaderLines',5);
                
                %                 celldisp(InputText1);
                xt=cell2mat(InputText1{1});
                if (length(xt)>=24)
                    if xt(24)=='H'
                        % disp('Good!!')
                        InputText1=textscan(FID2,'%s %s %s %s %s',64,'delimiter','PUCK','HeaderLines',1);
                        %                 InputText1{1}
                        %                 InputText1{5}
                        %                         clear timestep
                        break;
                        
                    else
                        timestep=[];
                        
                        InputText1=textscan(FID2,'%s %s %s %s %s %s',1,'delimiter','=');
                        
                        %  InputText1=textscan(FID2,'%s %s %s %s %s %s',1,'delimiter','=');  %,'HeaderLines',1);
                        % celldisp(InputText1)
                        ctpik=ctpik+1;
                        
                    end
                else
                    %  InputText1=textscan(FID2,'%s %s %s %s %s %s',1,'delimiter','=') ; %,'HeaderLines',1);
                    %celldisp(InputText1)
                    if ctpik>=100
                        disp('Problem with the code!!!')
                        return;
                    else
                        disp('Reading the new line!!!')
                        % continue;
                    end
                    ctpik=ctpik+1;
                    
                end
            else
                
                timestep=[];
                InputText1=textscan(FID2,'%s %s %s %s %s %s',1,'delimiter','=','HeaderLines',1);
                timestep=str2num(InputText1{2}{1});
                
                %                 celldisp(InputText1);
                if ctpik>=100
                    disp('Problem with the code!!!')
                    return;
                else
                    % disp('Reading the new line!!!')
                    % continue;
                end
                ctpik=ctpik+1;
                
                
            end
        end
        
        %% proper data format!!
        for itk=1:64
            
            loadstepval(itk,1)=timestep;
            numdata=str2num(InputText1{1}{itk});
            if length(numdata)==1
                elemid(itk,1)= elemid(itk-1,1);
                plyid(itk,1)= plyid(itk-1,1);
                pointid(itk,1)= numdata;
            elseif length(numdata)==2
                elemid(itk,1)= elemid(itk-1,1);
                
                plyid(itk,1)= numdata(1);
                
                pointid(itk,1)= numdata(2);
            elseif length(numdata)==3
                elemid(itk,1)= numdata(1);
                plyid(itk,1)= numdata(2);
                
                pointid(itk,1)= numdata(3);
                
            end
            
            %% failure data!!!
            faildata=str2num(InputText1{5}{itk});
            maxfi(itk,1)=faildata(1);
            srval(itk,1)=faildata(2);
            failmode(itk,1)=faildata(3);
            totdamage(itk,1)=faildata(4);
            fiberdamage(itk,1)=faildata(5);
            matrixdamage(itk,1)=faildata(6);
            
            % [loadstepval elemid plyid pointid maxfi srval failmode totdamage fiberdamage matrixdamage];
            
        end
        
        %%filter the maximum failure index point only for each ply and element!!!
        for evcount=1:16
            chkmax=maxfi(4*(evcount-1)+1:4*(evcount));
            
            locmaxfi=find(chkmax==max(chkmax));
            posi_locs_point(evcount,1)=4*(evcount-1)+locmaxfi(1);  %maximum fi for the integration point!!!
        end
        
        
        %% refined data!
        loadstepval_new=loadstepval(posi_locs_point);
        elemid_new=elemid(posi_locs_point);
        plyid_new=plyid(posi_locs_point);
        pointid_new=pointid(posi_locs_point);
        
        maxfi_new=maxfi(posi_locs_point);
        srval_new=srval(posi_locs_point);
        failmode_new=failmode(posi_locs_point);
        totdamage_new=totdamage(posi_locs_point);
        fiberdamage_new=fiberdamage(posi_locs_point);
        matrixdamage_new=matrixdamage(posi_locs_point);
        
        FAILURE_DATA=[loadstepval_new elemid_new plyid_new pointid_new maxfi_new srval_new failmode_new totdamage_new fiberdamage_new matrixdamage_new];
        FAILURE_DATA_MAIN=[FAILURE_DATA_MAIN;FAILURE_DATA];
        clear loadstepval elemid plyid pointid maxfi srval failmode totdamage fiberdamage matrixdamage
        clear loadstepval_new elemid_new plyid_new pointid_new maxfi_new srval_new failmode_new totdamage_new fiberdamage_new matrixdamage_new
        
        if INNERCOUNT==4
            % disp('Data for current time-step acquired!!!');
            break
        else
            % fprintf('The inner count value is %d and main count is %d.\n',INNERCOUNT,MAINLOAD_COUNT)
            %             pause(0.5)
            INNERCOUNT=INNERCOUNT+1;
        end
        
    end
    
end

fclose(FID2);
%toc

disp('LoadStep         ELEMENT       PLYID       GRIDPT       MAXIMUMFI      SR        FAILUREMODE   TOTALDAMAGE     FIBER DAMAGE     MATRIX DAMAGE')

disp(FAILURE_DATA_MAIN(1:100,:))
highest_FI_locs=find(FAILURE_DATA_MAIN(:,5)==max(FAILURE_DATA_MAIN(:,5)));
FAILURE_DATA_MAIN(highest_FI_locs(1),:)
highest_TD_locs=find(FAILURE_DATA_MAIN(:,8)==max(FAILURE_DATA_MAIN(:,8)));
FAILURE_DATA_MAIN(highest_TD_locs(1:5),:)

size(FAILURE_DATA_MAIN)
FAILURE_DATA_MAIN(end,:)


%% MAXIMUM FOR THE ELEMENTS!!
save('FAILURE_DATA_MAIN.mat','FAILURE_DATA_MAIN')
save('FAILURE_DATA_MAIN.dat','FAILURE_DATA_MAIN','-ascii')


%% THIS CODE IS INCLUDE IN THE pfa_response and IS USED for post-processing of FEA results
%% IT READS THE FORCE/DISPLACEMENT results
clc
%clear all
%close all
% tic
format short e

A =  exist('omhare_puck_bulk2_ia_compression.f06','file');
if A ==0
    pause(4);
else
    disp('The .f06 file is existing!!!')
end

%% reading result from sampleCopy.pch
%% this file contains codes for reading the data from the punch file
clc
% FID2 =  fopen('omhare_puck_ia.f06','r');  omhare_puck_bulk2_ia_compression
FID2 =  fopen('omhare_puck_bulk2_ia_compression.f06','r');
B = feof(FID2);
ctval=1;
RESPONSE_DATA_MAIN=[];
FILENUM_DATA_MAIN=[];

%% FINDING THE STARTING LINE!!
STARTLINEVAL=74300;
LINENUMBERTEST=textscan(FID2,'%s %s %s',1,'HeaderLines',STARTLINEVAL); %for my computer!!!!
while(1)
    %     celldisp(LINENUMBERTEST);
    if strcmp(cell2mat(LINENUMBERTEST{3}),'SPCFORCES')==1
        GOOD_STARTLINENO=STARTLINEVAL;
        fclose(FID2);
        
        break;
    else
        STARTLINEVAL=STARTLINEVAL+1;
        LINENUMBERTEST=textscan(FID2,'%s %s %s %s',1,'HeaderLines',1); %for my computer!!!!
    end
    
end
disp('Test and good lines numbers:')
disp(GOOD_STARTLINENO)

% GOOD_STARTLINENO=71983
%% START READING THE LOAD DISPLACEMENT DATA!!
FID2 =  fopen('omhare_puck_bulk2_ia_compression.f06','r');
B = feof(FID2);

while(1)
    if ctval==1
        %InputText1=textscan(FID2,'%s %s %s',1,'HeaderLines',74850) %for my computer!!!!
        InputText1=textscan(FID2,'%s %s %s',1,'HeaderLines',GOOD_STARTLINENO) ;%for my computer!!!!
        
        %         celldisp(InputText1);
        linerecount=1;
        while(1)
            %             celldisp(InputText1);
            
            xt=cell2mat(InputText1{1});
            xt22=cell2mat(InputText1{3});
            %                         if (isempty(xt)~=1)&&(xt(1)=='D')
            if (xt(1)=='D')
                
                if (length(xt)>=3)&&(xt(3)=='R')
                    if (length(xt22)>=2)&&(strcmp(xt22,'T1'))
                        disp('Good!!')
                        
                        InputText1=textscan(FID2,'%f %f %f %f %f %f %f %f',24,'HeaderLines',1);
                        %                         celldisp(InputText1);
                        
                        break;
                    else
                        InputText1=textscan(FID2,'%s %s %s',1,'HeaderLines',1);
                        
                        
                        celldisp(InputText1);
                        linerecount=linerecount+1;
                    end
                else
                    InputText1=textscan(FID2,'%s %s %s',1,'HeaderLines',1);
                    
                    
                    %                     celldisp(InputText1);
                    linerecount=linerecount+1;
                end
                
            else
                % InputText1=textscan(FID2,'%s',1,'HeaderLines',1);
                InputText1=textscan(FID2,'%s %s %s',1,'HeaderLines',1);
                
                
                %                 celldisp(InputText1);
                
                
                if linerecount>=100
                    fclose(FID2);
                    FID2 =  fopen('omhare_puck_bulk2_ia_compression.f06','r');
                    pause(3)
                    
                    %InputText1=textscan(FID2,'%s %s %s',1,'HeaderLines',74380);
                    InputText1=textscan(FID2,'%s %s %s',1,'HeaderLines',74380) %for my computer!!!!
                    
                    
                    if linerecount>=150
                        disp('Problem with the code!!!')
                        return;
                    end
                else
                    disp('Reading the new line!!!')
                end
                
                linerecount=linerecount+1;
                
            end
            
        end
        
        
        
    else
        
        
        ctpik=1;
        while(1)
            if ctpik==1
                InputText1=textscan(FID2,'%s',1,'HeaderLines',6);
                InputText1{1};
                % InputText1=textscan(FID2,'%f %f %f %f %f %f %f %f',1,'HeaderLines',7)
            else
                InputText1=textscan(FID2,'%s',1);
            end
            xt=cell2mat(InputText1{1});
            %xt22=cell2mat(InputText1{3})
            if (isempty(xt)~=1)&&(xt(1)=='D')
                
                if (length(xt)>=3)&&(xt(3)=='R')
                    
                    % disp('Good!!')
                    if ctval==1
                        InputText1=textscan(FID2,'%f %f %f %f %f %f %f %f',24,'HeaderLines',1);
                    elseif ctval>=2
                        if  FILENUM_DATA_MAIN(end)==72
                            InputText1=textscan(FID2,'%f %f %f %f %f %f %f %f',3,'HeaderLines',1);
                            
                        else
                            
                            InputText1=textscan(FID2,'%f %f %f %f %f %f %f %f',24,'HeaderLines',1);
                            
                        end
                        
                        break;
                        
                    else
                        if ctpik>=20
                            fclose(FID2);
                            
                            InputText1=textscan(FID2,'%s',1,'HeaderLines',74410);
                            if ctpik>=50
                                disp('Problem with the code!!!')
                                return;
                            end
                        else
                            disp('Reading the new line!!!')
                            %continue;
                        end
                        ctpik=ctpik+1;
                        
                    end
                end
                
            end
        end
    end
    
    FILENUM=InputText1{2};
    RESPONSE=[InputText1{3} InputText1{4} InputText1{5}];
    
    %% save the data!!
    
    RESPONSE_DATA_MAIN=[RESPONSE_DATA_MAIN;RESPONSE];
    FILENUM_DATA_MAIN=[FILENUM_DATA_MAIN;FILENUM];
    clear RESPONSE FILENUM
    
    ctval=ctval+1;
    
    if length(RESPONSE_DATA_MAIN)>=150;
        fprintf('The lenght of the data is %d and has been read properly!!!\n',size(RESPONSE_DATA_MAIN,1)/2)
        break;
    end
    
end

fclose(FID2);

[FILENUM_DATA_MAIN RESPONSE_DATA_MAIN];
DISPLACEMENT=[0;RESPONSE_DATA_MAIN(76:end,2)];
LOAD=[0;RESPONSE_DATA_MAIN(1:75,2)];



%% THIS CODE IS INCLUDE IN THE pfa_response and IS USED for post-processing of FEA results
%% IT READS THE FPF AND ULTIMATE FAILURE results
clc
load('FAILURE_DATA_MAIN.mat')

%% FIRST PLY FAILURE DATA FOR THE ELEMENTS!!
for elemcount=1:8
    offelem=8*(elemcount-1);
    for plyitk=1:8
        ply_fpf=FAILURE_DATA_MAIN([offelem+plyitk:64:end],:);
        ply_fi=FAILURE_DATA_MAIN([offelem+plyitk:64:end],8);
        fpf_loadlocs=find(ply_fi==max(ply_fi));
        fpf_disp(plyitk)=ply_fpf(fpf_loadlocs(1),1)*1.5 ; %gives the failure displacement at which the ply fails for first time!!!
        %FPF_DATA(plyitk,1:4,elemcount)=[ply_fpf(fpf_loadlocs(1),2),  ply_fpf(fpf_loadlocs(1),3),fpf_disp(plyitk), max(ply_fi)];
        FPF_DATA(plyitk,1:11,elemcount)=[ply_fpf(fpf_loadlocs(1),:),fpf_disp(plyitk)];
        
    end
    FPF_DATA;
end


%% CRITICAL PLY for FPF!!!
critical_element=4;
fpf_critical_element=FPF_DATA(:,:,critical_element);
disp_cols=11;
fpf_disp=min(FPF_DATA(:,disp_cols,critical_element));
fpf_critical_plies=find(FPF_DATA(:,disp_cols,4)==fpf_disp);
fpf_critical_plies_data=FPF_DATA(fpf_critical_plies,:,critical_element)  % the data for the critical plies at First Ply Failure Load!!!!
save('fpf_critical_plies.mat','fpf_critical_plies')


%% find the FPF load!

FPF_LOCS=find(FAILURE_DATA_MAIN(:,8)>0);
FPF_DATA=FAILURE_DATA_MAIN(FPF_LOCS(1),:)
fpf_disp=FPF_DATA(1)*DISPLACEMENT(end) ;  % displacement is in mm.
LOCS_FPFLOAD=find(abs(DISPLACEMENT-fpf_disp)<=1E-2);
FPF_load=LOAD(LOCS_FPFLOAD);
fprintf('The first ply failure is at %f mm with FPF load of %f N.\n',fpf_disp,FPF_load(1) )
FPF_DATA=[fpf_disp FPF_load(1)];

save('fpf_disp.mat','fpf_disp')
save('FPF_load.mat','FPF_load')
save('FPF_DATA.mat','FPF_DATA')

%%Ultimate Loads!
ULT_load=max(LOAD);
ult_locs=find(LOAD==max(LOAD));
ult_disp=DISPLACEMENT(ult_locs);
fprintf('\nThe ultimate failure is at %f mm with LPF load of %f N.\n',ult_disp,ULT_load )
% fprintf('\nThe peak-sttress is %f MPa.\n',ULT_load/(76.2*sum(tlay)) )

ULT_DATA=[ult_disp ULT_load];
save('ult_disp.mat','ult_disp')
save('ULT_load.mat','ULT_load')
save('ULT_DATA.mat','ULT_DATA')

end

