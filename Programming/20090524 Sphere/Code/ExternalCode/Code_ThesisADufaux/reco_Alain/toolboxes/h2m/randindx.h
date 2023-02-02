/*
 * MATLAB Compiler: 2.0
 * Date: Fri Dec 10 17:53:45 1999
 * Arguments: "-x" "hmm_psim.m" 
 */

#ifndef MLF_V2
#define MLF_V2 1
#endif

#ifndef __randindx_h
#define __randindx_h 1

#include "matlab.h"

extern mxArray * mlfRandindx(mxArray * p, mxArray * T, mxArray * NO_CHK);
extern void mlxRandindx(int nlhs, mxArray * plhs[], int nrhs, mxArray * prhs[]);

#endif
