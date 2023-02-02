/*
 * MATLAB Compiler: 2.0.1
 * Date: Tue Dec 21 14:04:33 1999
 * Arguments: "-x" "hmm_vit.m" 
 */

#ifndef MLF_V2
#define MLF_V2 1
#endif

#ifndef __hmm_vit_h
#define __hmm_vit_h 1

#include "matlab.h"

extern mxArray * mlfHmm_vit(mxArray * * path,
                            mxArray * * plogl,
                            mxArray * * logdens,
                            mxArray * * framelogl,
                            mxArray * X,
                            mxArray * A,
                            mxArray * pi0,
                            mxArray * mu,
                            mxArray * Sigma,
                            mxArray * QUIET);
extern void mlxHmm_vit(int nlhs, mxArray * plhs[], int nrhs, mxArray * prhs[]);

#endif
