/*
 * MATLAB Compiler: 2.0
 * Date: Fri Dec 10 17:54:00 1999
 * Arguments: "-x" "hmm_tran.m" 
 */

#ifndef MLF_V2
#define MLF_V2 1
#endif

#ifndef __hmm_tran_h
#define __hmm_tran_h 1

#include "matlab.h"

extern mxArray * mlfHmm_tran(mxArray * * pi0_,
                             mxArray * alpha,
                             mxArray * beta,
                             mxArray * dens,
                             mxArray * A,
                             mxArray * pi0,
                             mxArray * QUIET);
extern void mlxHmm_tran(int nlhs, mxArray * plhs[], int nrhs, mxArray * prhs[]);

#endif
