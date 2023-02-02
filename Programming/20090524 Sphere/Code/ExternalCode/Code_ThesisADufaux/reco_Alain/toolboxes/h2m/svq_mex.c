/*
 * MATLAB Compiler: 2.0
 * Date: Fri Dec 10 17:54:51 1999
 * Arguments: "-x" "svq.m" 
 */

#ifndef MLF_V2
#define MLF_V2 1
#endif

#include "matlab.h"
#include "vq.h"
#include "svq.h"

static mlfFunctionTableEntry function_table[1] = { { "svq", mlxSvq, 3, 3 } };

static mxArray * Mvq(mxArray * * label,
                     mxArray * * dist,
                     int nargout_,
                     mxArray * X,
                     mxArray * CODE,
                     mxArray * n_it,
                     mxArray * QUIET) {
    mxArray * CODE_n = mclGetUninitializedArray();
    mclFevalCallMATLAB(
      mclNVarargout(nargout_, 0, &CODE_n, label, dist, NULL),
      "vq",
      X, CODE, n_it, QUIET, NULL);
    return CODE_n;
}

/*
 * The function "mexFunction" is a Compiler-generated mex wrapper, suitable for
 * building a MEX-function. It initializes any persistent variables as well as
 * a function table for use by the feval function. It then calls the function
 * "mlxSvq". Finally, it clears the feval table and exits.
 */
void mexFunction(int nlhs, mxArray * * plhs, int nrhs, mxArray * * prhs) {
    mlfTry {
        mlfFunctionTableSetup(1, function_table);
        mclImportGlobal(0, NULL);
        mlxSvq(nlhs, plhs, nrhs, prhs);
        mlfFunctionTableTakedown(1, function_table);
    } mlfCatch {
        mlfFunctionTableTakedown(1, function_table);
        mclMexError();
    } mlfEndCatch
}

void mlxVq(int nlhs, mxArray * plhs[], int nrhs, mxArray * prhs[]) {
    mxArray * mprhs[4];
    mxArray * mplhs[3];
    int i;
    if (nlhs > 3) {
        mlfError(
          mxCreateString(
            "Run-time Error: File: vq Line: 1 Column: 0 The function \"vq\" "
            "was called with more than the declared number of outputs (3)"));
    }
    if (nrhs > 4) {
        mlfError(
          mxCreateString(
            "Run-time Error: File: vq Line: 1 Column: 0 The function \"vq\" "
            "was called with more than the declared number of inputs (4)"));
    }
    for (i = 0; i < 3; ++i) {
        mplhs[i] = NULL;
    }
    for (i = 0; i < 4 && i < nrhs; ++i) {
        mprhs[i] = prhs[i];
    }
    for (; i < 4; ++i) {
        mprhs[i] = NULL;
    }
    mlfEnterNewContext(0, 4, mprhs[0], mprhs[1], mprhs[2], mprhs[3]);
    mplhs[0]
      = Mvq(
          &mplhs[1], &mplhs[2], nlhs, mprhs[0], mprhs[1], mprhs[2], mprhs[3]);
    mlfRestorePreviousContext(0, 4, mprhs[0], mprhs[1], mprhs[2], mprhs[3]);
    plhs[0] = mplhs[0];
    for (i = 1; i < 3 && i < nlhs; ++i) {
        plhs[i] = mplhs[i];
    }
    for (; i < 3; ++i) {
        mxDestroyArray(mplhs[i]);
    }
}

mxArray * mlfVq(mxArray * * label,
                mxArray * * dist,
                mxArray * X,
                mxArray * CODE,
                mxArray * n_it,
                mxArray * QUIET) {
    int nargout = 1;
    mxArray * CODE_n = mclGetUninitializedArray();
    mxArray * label__ = mclGetUninitializedArray();
    mxArray * dist__ = mclGetUninitializedArray();
    mlfEnterNewContext(2, 4, label, dist, X, CODE, n_it, QUIET);
    if (label != NULL) {
        ++nargout;
    }
    if (dist != NULL) {
        ++nargout;
    }
    CODE_n = Mvq(&label__, &dist__, nargout, X, CODE, n_it, QUIET);
    mlfRestorePreviousContext(2, 4, label, dist, X, CODE, n_it, QUIET);
    if (label != NULL) {
        mclCopyOutputArg(label, label__);
    } else {
        mxDestroyArray(label__);
    }
    if (dist != NULL) {
        mclCopyOutputArg(dist, dist__);
    } else {
        mxDestroyArray(dist__);
    }
    return mlfReturnValue(CODE_n);
}
