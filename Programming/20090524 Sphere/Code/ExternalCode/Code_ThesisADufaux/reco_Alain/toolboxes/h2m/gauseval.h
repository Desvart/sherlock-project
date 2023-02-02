/*
 * MATLAB Compiler: 2.0
 * Date: Fri Dec 10 17:53:45 1999
 * Arguments: "-x" "hmm_psim.m" 
 */

#ifndef MLF_V2
#define MLF_V2 1
#endif

#ifndef __gauseval_h
#define __gauseval_h 1

#include "matlab.h"

extern mxArray * mlfGauseval(mxArray * X,
                             mxArray * mu,
                             mxArray * Sigma,
                             mxArray * QUIET);
extern void mlxGauseval(int nlhs, mxArray * plhs[], int nrhs, mxArray * prhs[]);

#endif
