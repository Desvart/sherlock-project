/*
 * MATLAB Compiler: 2.0
 * Date: Fri Dec 10 17:53:12 1999
 * Arguments: "-x" "hmm_mest.m" 
 */

#ifndef MLF_V2
#define MLF_V2 1
#endif

#ifndef __hmm_fb_h
#define __hmm_fb_h 1

#include "matlab.h"

extern mxArray * mlfHmm_fb(mxArray * * beta,
                           mxArray * * logscale,
                           mxArray * * dens,
                           mxArray * X,
                           mxArray * A,
                           mxArray * pi0,
                           mxArray * mu,
                           mxArray * Sigma,
                           mxArray * QUIET);
extern void mlxHmm_fb(int nlhs, mxArray * plhs[], int nrhs, mxArray * prhs[]);

#endif
