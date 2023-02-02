/*
 * MATLAB Compiler: 2.0
 * Date: Fri Dec 10 17:53:45 1999
 * Arguments: "-x" "hmm_psim.m" 
 */

#ifndef MLF_V2
#define MLF_V2 1
#endif

#ifndef __hmm_psim_h
#define __hmm_psim_h 1

#include "matlab.h"

extern mxArray * mlfHmm_psim(mxArray * X,
                             mxArray * A,
                             mxArray * pi0,
                             mxArray * mu,
                             mxArray * Sigma,
                             mxArray * QUIET);
extern void mlxHmm_psim(int nlhs, mxArray * plhs[], int nrhs, mxArray * prhs[]);

#endif
