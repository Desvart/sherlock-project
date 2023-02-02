/*
 * MATLAB Compiler: 2.0
 * Date: Fri Dec 10 17:55:10 1999
 * Arguments: "-x" "vq.m" 
 */

#ifndef MLF_V2
#define MLF_V2 1
#endif

#ifndef __vq_h
#define __vq_h 1

#include "matlab.h"

extern mxArray * mlfVq(mxArray * * label,
                       mxArray * * dist,
                       mxArray * X,
                       mxArray * CODE,
                       mxArray * n_it,
                       mxArray * QUIET);
extern void mlxVq(int nlhs, mxArray * plhs[], int nrhs, mxArray * prhs[]);

#endif
