Read Me for VALIDATE:

Units: stress in MPA and displacement in mm
Validation with Experimental results and reference in Section 5.1 for inplane uniaxial tensile loading
'TENS': inplane uniaxial tension

Scripts:
-> DETERMINISTIC_RUN.m: this code runs the NASTRAN codes for tensile loading based on the details in Section 5.1 
->pfa_response.m: inputs the samples, write the material properties for given samples, calls the NASTRAN, and returns the FEA responses
->postprocess_nastrandata.m: after running FEA, this extracts the data and pass it to the pfa_response.m
nastran files for FEA:
->OMHARE_PUCK_BULK2_IA_TENSION: for tension

The MATLAB SCRIPT writes the material properties based on samples in FAILURE_MAT_PROP_PUCK_BULK2.bdf using pfa_response.m
which is called by the NASTRAN files given below for progressive failure analysis using FEA.

