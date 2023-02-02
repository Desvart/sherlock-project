/*
 * MATLAB Compiler: 2.0
 * Date: Fri Dec 10 17:54:51 1999
 * Arguments: "-x" "svq.m" 
 */

#ifndef MLF_V2
#define MLF_V2 1
#endif

#ifndef __svq_h
#define __svq_h 1

#include "matlab.h"

extern mxArray * mlfSvq(mxArray * * label,
                        mxArray * * dist,
                        mxArray * X,
                        mxArray * lev,
                        mxArray * n_it);
extern void mlxSvq(int nlhs, mxArray * plhs[], int nrhs, mxArray * prhs[]);

#endif
