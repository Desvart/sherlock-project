/*
 * MATLAB Compiler: 2.0
 * Date: Fri Dec 10 17:53:12 1999
 * Arguments: "-x" "hmm_mest.m" 
 */

#ifndef MLF_V2
#define MLF_V2 1
#endif

#ifndef __hmm_mest_h
#define __hmm_mest_h 1

#include "matlab.h"

extern mxArray * mlfHmm_mest(mxArray * * logl,
                             mxArray * * gamma,
                             mxArray * X,
                             mxArray * st,
                             mxArray * A,
                             mxArray * mu,
                             mxArray * Sigma,
                             mxArray * QUIET);
extern void mlxHmm_mest(int nlhs, mxArray * plhs[], int nrhs, mxArray * prhs[]);

#endif
