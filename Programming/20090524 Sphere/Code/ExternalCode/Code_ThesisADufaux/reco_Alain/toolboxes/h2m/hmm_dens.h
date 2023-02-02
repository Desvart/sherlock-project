/*
 * MATLAB Compiler: 2.0
 * Date: Fri Dec 10 17:52:28 1999
 * Arguments: "-x" "hmm_dens.m" 
 */

#ifndef MLF_V2
#define MLF_V2 1
#endif

#ifndef __hmm_dens_h
#define __hmm_dens_h 1

#include "matlab.h"

extern mxArray * mlfHmm_dens(mxArray * * Sigma,
                             mxArray * * gamma,
                             mxArray * X,
                             mxArray * alpha,
                             mxArray * beta,
                             mxArray * DIAG_COV,
                             mxArray * QUIET);
extern void mlxHmm_dens(int nlhs, mxArray * plhs[], int nrhs, mxArray * prhs[]);

#endif
