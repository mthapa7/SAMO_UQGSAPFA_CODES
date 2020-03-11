%% THIS CODE INCLUDES THE FILES FOR POST-PROCESSING!!!
function postprocess_nastrandata_transverse()

%% THIS CODE IS INCLUDE IN THE pfa_response and IS USED for post-processing of FEA results
%% IT READS THE FORCE/DISPLACEMENT results
%%THIS CODE WILL READ ANY BORKEN SIMULATION AS WELL
format short e

A =  exist('omhare_puck_bulk2_ia_transversedisp.f06','file');
if A ==0
    pause(4);
else
    disp('The .f06 file is existing!!!')
end

%% reading result from sampleCopy.pch
%% this file contains codes for reading the data from the punch file
clc
% FID2 =  fopen('omhare_puck_ia.f06','r');  omhare_puck_bulk2_ia_transversedisp
FID2 =  fopen('omhare_puck_bulk2_ia_transversedisp.f06','r');
B = feof(FID2);
ctval=1;
RESPONSE_DATA_MAIN=[];
FILENUM_DATA_MAIN=[];

%% FINDING THE STARTING LINE!!
%%if code break early then use different start line
datafile_size=dir('omhare_puck_bulk2_ia_transversedisp.f06');
f06_size=datafile_size.bytes/1e6    %in megabytes

%takes longer but more robust
if f06_size<7.0
    STARTLINEVAL=60000;
elseif (f06_size>=7.0)&&(f06_size<8.0)
    STARTLINEVAL=70000;
elseif (f06_size>=8.0)&&(f06_size<9.0)
    STARTLINEVAL=80000;
elseif (f06_size>=9.0)
    STARTLINEVAL=90000;
end

%     STARTLINEVAL=60000;

LINENUMBERTEST=textscan(FID2,'%s',1,'Delimiter','','HeaderLines',STARTLINEVAL); %for my computer!!!!

celldisp(LINENUMBERTEST);

while(1)
    if (strcmp(cell2mat(LINENUMBERTEST{1}),'0                                                  MAXIMUM  SPCFORCES       ')==1)
        GOOD_STARTLINENO=STARTLINEVAL;
        % celldisp(LINENUMBERTEST);
        fclose(FID2);
        break;
    else
        clc
        STARTLINEVAL=STARTLINEVAL+1;
        
        LINENUMBERTEST=textscan(FID2,'%s',1,'Delimiter',''); %for my computer!!!!
        
        %celldisp(LINENUMBERTEST);
        currrline=STARTLINEVAL+1;
        continue;
        
    end
    
end

disp('Test and good lines numbers:')
disp(GOOD_STARTLINENO)
%toc

%% REDO AGAIN TO FIND THE LINE NUMBER OF MAXIMUM SPCFORCES
FID2 =  fopen('omhare_puck_bulk2_ia_transversedisp.f06','r'); pause(2);
LINENUMBERTEST=textscan(FID2,'%s %s %s',1,'HeaderLines',STARTLINEVAL); %for my computer!!!!
while(1)
    %     celldisp(LINENUMBERTEST);
    if strcmp(cell2mat(LINENUMBERTEST{3}),'SPCFORCES')==1
        GOOD_STARTLINENO=STARTLINEVAL+1;
        fclose(FID2);
        
        break;
    else
        STARTLINEVAL=STARTLINEVAL+1;
        LINENUMBERTEST=textscan(FID2,'%s %s %s %s',1,'HeaderLines',1); %for my computer!!!!
    end
    
end
disp('Test and good lines numbers:')
disp(GOOD_STARTLINENO)


%% START READING THE LOAD DISPLACEMENT DATA!!
FID2 =  fopen('omhare_puck_bulk2_ia_transversedisp.f06','r');
B = feof(FID2);

%%%break if the results are finished reading!!!!
RESPONSE_DATA_MAIN=[];
FILENUM_DATA_MAIN=[];
count=1;
while(1)
    if count==1
        InputText1=textscan(FID2,'%f %f %f %f %f %f %f %f','HeaderLines',GOOD_STARTLINENO+2);
        %celldisp(InputText1)
        NUMINCREMS=size(InputText1{2});
    else
        InputText1=textscan(FID2,'%f %f %f %f %f %f %f %f','HeaderLines',6);
        %celldisp(InputText1)
        NUMINCREMS=NUMINCREMS+size(InputText1{2});
    end
    
    %%break if no numerical data
    if (isempty(InputText1{2})==1)&&(isempty(InputText1{3})==1)
        disp('Final increments read properly!!!')
        break;
    end
    
    %%save the proper data
    FILENUM=InputText1{2};
    RESPONSE=[InputText1{3} InputText1{4} InputText1{5}];
    %% save the data!!
    
    RESPONSE_DATA_MAIN=[RESPONSE_DATA_MAIN;RESPONSE];
    FILENUM_DATA_MAIN=[FILENUM_DATA_MAIN;FILENUM];
    clear RESPONSE FILENUM
    
    count=count+1;
end

TOTAL_INCREMENTS_LOCS=find(FILENUM_DATA_MAIN==max(FILENUM_DATA_MAIN));
FINAL_INCREMENT=TOTAL_INCREMENTS_LOCS(1) ;  %THIS IS USEFUL when code breaks prematurely
fclose(FID2);

[FILENUM_DATA_MAIN RESPONSE_DATA_MAIN];
DISPLACEMENT=[0;RESPONSE_DATA_MAIN(FINAL_INCREMENT+1:end,3)];
LOAD=[0;RESPONSE_DATA_MAIN(1:FINAL_INCREMENT,3)];

%% THIS CODE IS INCLUDE IN THE pfa_response and IS USED for post-processing of FEA results
format short e

A =  exist('omhare_puck_bulk2_ia_transversedisp.f06','file');
%A =  exist('data_correct.dat','file');
if A ==0
    pause(20);
else
    disp('The .f06 file is existing!!!')
end

%% reading result from sampleCopy.pch
%% this file contains codes for reading the data from the punch file
clc
FID2 =  fopen('omhare_puck_bulk2_ia_transversedisp.f06','r');
%FID2 =  fopen('data_correct.dat','r');

B = feof(FID2);
while B~=0
    pause(3);
end

NUMOUTPUT=FINAL_INCREMENT;   %maximum number of load-steps!!! from CODE2
FAILURE_DATA_MAIN=[];   % TO STORE THE ALL FAILURE INFORMATION!!!
for MAINLOAD_COUNT=1:NUMOUTPUT
    
    for INNERCOUNT=1:4;
        if MAINLOAD_COUNT==1
            if INNERCOUNT==1
                ctval=1;
                InputText0=textscan(FID2,'%s %s %s %s %s %s',1,'delimiter','=','HeaderLines',7060);   %%FOR TENSION/COMPRESSION: 6680
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
                InputText0=textscan(FID2,'%s %s %s %s %s %s',1,'delimiter','=','HeaderLines',900);  %610 for tension and compression
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
%% IT READS THE FPF AND ULTIMATE FAILURE results

load('FAILURE_DATA_MAIN.mat')

%% FIRST PLY FAILURE DATA FOR THE ELEMENTS!!

%% find the FPF load!
FPF_LOCS=find(FAILURE_DATA_MAIN(:,8)>0);
FPF_DATA=FAILURE_DATA_MAIN(FPF_LOCS(1),:)
fpf_disp=FPF_DATA(1)*DISPLACEMENT(end) ;  % displacement is in mm.
LOCS_FPFLOAD=find(abs(DISPLACEMENT-fpf_disp)<=1E-1);
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