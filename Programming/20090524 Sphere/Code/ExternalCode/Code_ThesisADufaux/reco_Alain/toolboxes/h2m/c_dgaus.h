/*
 * MATLAB Compiler: 2.0
 * Date: Fri Dec 10 17:50:34 1999
 * Arguments: "-x" "gauseval.m" 
 */

#ifndef MLF_V2
#define MLF_V2 1
#endif

#ifndef __c_dgaus_h
#define __c_dgaus_h 1

#include "matlab.h"

extern mxArray * mlfC_dgaus(mxArray * X, mxArray * mu, mxArray * Sigma);
extern void mlxC_dgaus(int nlhs, mxArray * plhs[], int nrhs, mxArray * prhs[]);

#endif
