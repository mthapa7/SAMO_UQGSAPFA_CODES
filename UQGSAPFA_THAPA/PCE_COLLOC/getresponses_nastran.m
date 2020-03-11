%% THIS CODE IS TO get the samples run for PFA!!!
%%TENSION
%% it reads the material properties in SAMPLES and returns the FPF AND ULT DATA in output
function output=getresponses_nastran(SAMPLES)
global UQGSAPFA
loadtype=UQGSAPFA.loadtype;
%% RUN THE CODES FOR NASTRAN!!
%% THIS SELECTES THE CODE BASED ON THE TYPE OF LOADING
if strcmp(loadtype,'TENS')
    output=pfa_response_tension(SAMPLES);
elseif strcmp(loadtype,'COMP')
    output=pfa_response_compression(SAMPLES);
elseif strcmp(loadtype,'TRAN')
    output=pfa_response_transverse(SAMPLES);
end


end
