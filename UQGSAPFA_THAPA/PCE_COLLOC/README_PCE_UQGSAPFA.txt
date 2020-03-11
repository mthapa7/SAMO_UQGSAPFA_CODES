Read Me for COLLOC:
This framework includes least-squares based PCE. But other approaches can be included easily as well.
This folder PCE_COLLOC contains the codes for framework and also integrates the MSC NASTRAN software files to 
obtain the response samples required for PCE.

Units: stress in MPA and displacement in mm
The code runs for three types of loading as  mentioned in the paper.
'TENS': inplane uniaxial tension
'COMP': inplane uniaxial compression
'TRAN': out of plane transverse loading

Scripts:
-> MAINCODE_COLLOC_UQGSAPFA.m: this code implements the main framework in Fig.2 of Section 4
-> Amatrix_fun22.m: generate information matrix of a given PCE order and samples
->COLLOC_PC.m: solve the least-squares problem for PCE coefficients
-> DIM_MULTIND_ADAPTIVE.m, polymultiind_loworder.m, polymultiind_rearrange.m, polymultiindex.m: these scripts selects proper multi-indices for PCE
->global_sensitivity_sobol.m: estimates the Sobol indices for Global sensitivity analysis
->HERMITEPOLY.m: returns the Hermite orhtogonal polynomial value at given sampling point
->LEGENPOLY.m: returns the Legendre orhtogonal polynomial value at given sampling point
->multiorthopoly.m->returns the evaluation of multivariate Orthogonal polynomials
->ORTHOPOLY.m: similar to multiorthopoly.m returns the evaluation of multivariate Orthogonal polynomials
->PCESURROG.m: PCE surrogate based on the evaluated PCE coefficients and multiindices
->PDF_PLOTS_MAIN.m: plots the final response pdfs during post-processing
->PLOTS_CORRELATION.m: plots the cross validation correlation of the responses
->PLOTS_PIE_HBAR.m: plots the Sobol indices of the responses
->getresponses_nastran.m: selects proper file (as given below) based on the loading type for FEA simulations and resturns the response i.e. FEA samples
	->pfa_response_tension.m:  (for TENSION) inputs the samples, write the material properties for given samples, calls the NASTRAN, and returns the FEA responses
	->pfa_response_compression.m:  (for COMPRESSION) inputs the samples, write the material properties for given samples, calls the NASTRAN, and returns the FEA responses
	->pfa_response_transverse.m:  (for  TRANSVERSE LOADING) inputs the samples, write the material properties for given samples, calls the NASTRAN, and returns the FEA responses
->postprocess_nastrandata_tension.m: (for TENSION)after running FEA, this extracts the data and pass it to the pfa_response.m
->postprocess_nastrandata_compression.m: (for COMPRESSION)after running FEA, this extracts the data and pass it to the pfa_response.m
->postprocess_nastrandata_transverse.m: (for TRANSVERSE LOADING)after running FEA, this extracts the data and pass it to the pfa_response.m
->samples_generate.m: generates the sampling points based on the Sobol sequence sampling
->STAT_MOMENTS.m: returns the analytical mean and variance of PCE based on PC coefficients (coded for normal and uniform random variables)
->VAR_MULTI.m:returns the variance of the response based on the coefficients and orthogonal polynomials 



nastran files for FEA:
The MATLAB SCRIPT writes the material properties based on samples in FAILURE_MAT_PROP_PUCK_BULK2.bdf using pfa_response.m
which is called by the NASTRAN files given below for progressive failure analysis using FEA.

->OMHARE_PUCK_BULK2_IA_TENSION.bdf: for tension
->OMHARE_PUCK_BULK2_IA_COMPRESSION.bdf: for compression
->OMHARE_PUCK_BULK2_IA_TRANSVERSEDISP.bdf: for out of plane transverse loading