/*
 * MATLAB Compiler: 2.0
 * Date: Fri Dec 10 17:53:28 1999
 * Arguments: "-x" "hmm_mint.m" 
 */

#ifndef MLF_V2
#define MLF_V2 1
#endif

#ifndef __hmm_mint_h
#define __hmm_mint_h 1

#include "matlab.h"

extern mxArray * mlfHmm_mint(mxArray * * Sigma,
                             mxArray * X,
                             mxArray * st,
                             mxArray * N,
                             mxArray * DIAG_COV,
                             mxArray * QUIET);
extern void mlxHmm_mint(int nlhs, mxArray * plhs[], int nrhs, mxArray * prhs[]);

#endif
