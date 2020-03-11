%% DIMENSION ADAPTIVE MULTI-INDICES ARE GENERATED ALSO SELECTED DIMENSIONS IN VARLOC_ADAPT_INCREM
%% CAN GENERATE REGULAR MULTIINDICES OR SPARSE ADAPTIVE MULTIINDICES
function MULTIND_NEWBBB=DIM_MULTIND_ADAPTIVE(NVARS,VARLOC_ADAPT_INCREM, ORDER, ORDERINCREM)

%%THIS IS THE CODE FOR GETTING NEW PCE TERMS FOR DIMENSION ADPATIVE PCE!!! INCREASE THE POLYNOMIAL
%%ALONG SELECTED DIMENSIONS ONLY!!!
%%HERE RIGHT NOW INCREASE THE ALL DIMENSIONS BUT CAN USE GSA TO MAKE IT
%%DIMENSION ADAPTIVE!!!
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%{
VARLOC_ADAPT_INCREM: give the dimensions for the increment of PC order
VARNUMFINAL_AFTERTRIM: number of dimensions only used for PCE. this is
equal to length of VARLOC_ADAPT_INCREM...i.e. length(VARLOC_ADAPT_INCREM)
%}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
MULTIIND_ORIGINAL=polymultiindex(NVARS,ORDER);
SIZEMULTIND_OLD=size(MULTIIND_ORIGINAL);

%% INCREASE THE DIMENSION ORDER FOR VARIABLES ALONG THE PARTICULAR DIMENSIONS FOR ADAPTIVE DIMENSION AND ALL DIMENSIONS FOR REGULAR ADAPTIVE!!!
MULTIIND_NEW=polymultiindex(NVARS,ORDERINCREM);
SIZEMULTIND_NEW=size(MULTIIND_NEW);
ITRINIT=SIZEMULTIND_OLD(1)+1;
ITRFINAL=SIZEMULTIND_NEW(1);
MULTIIND_NEW_DUMMY=MULTIIND_NEW(ITRINIT:end,:) ;  %THIS CONTAINS MULTIINDEX ONLY GREATER THAN THE PREVIOUS ORDER!!!!
NUM_NEWROWS=SIZEMULTIND_NEW(1)-SIZEMULTIND_OLD(1);

%DIMENSION ADAPTIVE WITH THE RESULTING  SUM  OF THE MULTIINDICES OF INCREMENTAL DIMENSIONS GREATER THAN THE PREVIOUS ORDER AND EQUAL TO CURRENT ORDER!!!
for ITTT=1:NUM_NEWROWS
    MULTIIND_NEW_DUMMY(ITTT,VARLOC_ADAPT_INCREM);
    MULTIIND_NEW_DUMMY(ITTT,:);
    
    ADDORDER(ITTT)=sum(MULTIIND_NEW_DUMMY(ITTT,VARLOC_ADAPT_INCREM));
end
LOCS_DIMADAPTIVE=find(ADDORDER==ORDERINCREM)  ; %DIMENSIONS ADAPTIVE WITH THE INCREMENTAL DIMENSIONS HAVING SUM EQUAL TO THE NEW INCREMENTED CHAOS ORDER!!!
[MULTIIND_NEW_DUMMY(LOCS_DIMADAPTIVE,VARLOC_ADAPT_INCREM) MULTIIND_NEW_DUMMY(LOCS_DIMADAPTIVE,:)];
FINAL_MI_ROWLENGTH=length(LOCS_DIMADAPTIVE);
DUMMY_MAT=zeros(FINAL_MI_ROWLENGTH,NVARS);
DUMMY_MAT(:,:)=MULTIIND_NEW_DUMMY(LOCS_DIMADAPTIVE,:) ;  % MULTIIND_NEW_DUMMY(LOCS_DIMADAPTIVE,VARLOC_ADAPT_INCREM)
NEWNUM=FINAL_MI_ROWLENGTH ;  %NUMBER OF ADDITIONAL TERMS
MULTIND_NEWBBB=DUMMY_MAT;
%% ADD THE PREVIOUS MULTIINDICES WITH THE NEW MULTIINDICES
% MULTIND_MAIN=[MULTIIND_ORIGINAL; MULTIND_NEWBBB];    %THIS IS THE NEW MULTIINDEX SET!!!!
end
