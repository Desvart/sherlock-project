/*
 * MATLAB Compiler: 2.0
 * Date: Fri Dec 10 17:50:07 1999
 * Arguments: "-x" "mix_post.m" 
 */

#ifndef MLF_V2
#define MLF_V2 1
#endif

#ifndef __mix_post_h
#define __mix_post_h 1

#include "matlab.h"

extern mxArray * mlfNMix_post(int nargout,
                              mxArray * * logl,
                              mxArray * * framelogl,
                              mxArray * X,
                              mxArray * w,
                              mxArray * mu,
                              mxArray * Sigma,
                              mxArray * QUIET);
extern mxArray * mlfMix_post(mxArray * * logl,
                             mxArray * * framelogl,
                             mxArray * X,
                             mxArray * w,
                             mxArray * mu,
                             mxArray * Sigma,
                             mxArray * QUIET);
extern void mlfVMix_post(mxArray * X,
                         mxArray * w,
                         mxArray * mu,
                         mxArray * Sigma,
                         mxArray * QUIET);
extern void mlxMix_post(int nlhs, mxArray * plhs[], int nrhs, mxArray * prhs[]);

#endif
