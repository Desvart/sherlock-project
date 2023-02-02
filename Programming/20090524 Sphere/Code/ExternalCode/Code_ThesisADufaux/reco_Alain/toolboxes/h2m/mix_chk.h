/*
 * MATLAB Compiler: 2.0
 * Date: Fri Dec 10 17:50:07 1999
 * Arguments: "-x" "mix_post.m" 
 */

#ifndef MLF_V2
#define MLF_V2 1
#endif

#ifndef __mix_chk_h
#define __mix_chk_h 1

#include "matlab.h"

extern mxArray * mlfMix_chk(mxArray * * p,
                            mxArray * * DIAG_COV,
                            mxArray * w,
                            mxArray * mu,
                            mxArray * Sigma);
extern void mlxMix_chk(int nlhs, mxArray * plhs[], int nrhs, mxArray * prhs[]);

#endif
