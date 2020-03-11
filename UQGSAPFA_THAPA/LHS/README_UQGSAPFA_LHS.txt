Read Me for LHS:

Units: stress in MPA and displacement in mm
This framework includes .
The code runs for three types of loading as  mentioned in the paper.
'TENS': inplane uniaxial tension
'COMP': inplane uniaxial compression
'TRAN': out of plane transverse loading

Scripts:
-> MAINCODE_LHS.m: this code generates samples for Monte Carlo simulations using Latin Hypercube samples
->PDF_PLOTS.m: plots the final response pdfs during post-processing
->pfa_response.m: inputs the samples, write the material properties for given samples, calls the NASTRAN, and returns the FEA responses
->postprocess_nastrandata.m: after running FEA, this extracts the data and pass it to the pfa_response.m

nastran files for FEA:
The MATLAB SCRIPT writes the material properties based on samples in FAILURE_MAT_PROP_PUCK_BULK2.bdf using pfa_response.m
which is called by the NASTRAN files given below for progressive failure analysis using FEA.

->OMHARE_PUCK_BULK2_IA_TENSION: for tension
->OMHARE_PUCK_BULK2_IA_COMPRESSION.bdf: for compression
->OMHARE_PUCK_BULK2_IA_TRANSVERSEDISP.bdf: for out of plane transverse loading