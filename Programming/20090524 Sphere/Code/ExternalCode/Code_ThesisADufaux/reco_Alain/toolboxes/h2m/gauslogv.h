/*
 * MATLAB Compiler: 2.0.1
 * Date: Tue Dec 21 14:04:33 1999
 * Arguments: "-x" "hmm_vit.m" 
 */

#ifndef MLF_V2
#define MLF_V2 1
#endif

#ifndef __gauslogv_h
#define __gauslogv_h 1

#include "matlab.h"

extern mxArray * mlfGauslogv(mxArray * X,
                             mxArray * mu,
                             mxArray * Sigma,
                             mxArray * QUIET);
extern void mlxGauslogv(int nlhs, mxArray * plhs[], int nrhs, mxArray * prhs[]);

#endif
