/*
 * MATLAB Compiler: 2.0
 * Date: Fri Dec 10 17:50:34 1999
 * Arguments: "-x" "gauseval.m" 
 */

#ifndef MLF_V2
#define MLF_V2 1
#endif

#include "matlab.h"
#include "c_dgaus.h"
#include "gauseval.h"

static mlfFunctionTableEntry function_table[1]
  = { { "gauseval", mlxGauseval, 4, 1 } };

static mxArray * Mc_dgaus(int nargout_,
                          mxArray * X,
                          mxArray * mu,
                          mxArray * Sigma) {
    mxArray * dens = mclGetUninitializedArray();
    mclFevalCallMATLAB(
      mclNVarargout(nargout_, 0, &dens, NULL), "c_dgaus", X, mu, Sigma, NULL);
    return dens;
}

/*
 * The function "mexFunction" is a Compiler-generated mex wrapper, suitable for
 * building a MEX-function. It initializes any persistent variables as well as
 * a function table for use by the feval function. It then calls the function
 * "mlxGauseval". Finally, it clears the feval table and exits.
 */
void mexFunction(int nlhs, mxArray * * plhs, int nrhs, mxArray * * prhs) {
    mlfTry {
        mlfFunctionTableSetup(1, function_table);
        mclImportGlobal(0, NULL);
        mlxGauseval(nlhs, plhs, nrhs, prhs);
        mlfFunctionTableTakedown(1, function_table);
    } mlfCatch {
        mlfFunctionTableTakedown(1, function_table);
        mclMexError();
    } mlfEndCatch
}

void mlxC_dgaus(int nlhs, mxArray * plhs[], int nrhs, mxArray * prhs[]) {
    mxArray * mprhs[3];
    mxArray * mplhs[1];
    int i;
    if (nlhs > 1) {
        mlfError(
          mxCreateString(
            "Run-time Error: File: c_dgaus Line: 1 Column: "
            "0 The function \"c_dgaus\" was called with mor"
            "e than the declared number of outputs (1)"));
    }
    if (nrhs > 3) {
        mlfError(
          mxCreateString(
            "Run-time Error: File: c_dgaus Line: 1 Column:"
            " 0 The function \"c_dgaus\" was called with m"
            "ore than the declared number of inputs (3)"));
    }
    for (i = 0; i < 1; ++i) {
        mplhs[i] = NULL;
    }
    for (i = 0; i < 3 && i < nrhs; ++i) {
        mprhs[i] = prhs[i];
    }
    for (; i < 3; ++i) {
        mprhs[i] = NULL;
    }
    mlfEnterNewContext(0, 3, mprhs[0], mprhs[1], mprhs[2]);
    mplhs[0] = Mc_dgaus(nlhs, mprhs[0], mprhs[1], mprhs[2]);
    mlfRestorePreviousContext(0, 3, mprhs[0], mprhs[1], mprhs[2]);
    plhs[0] = mplhs[0];
}

mxArray * mlfC_dgaus(mxArray * X, mxArray * mu, mxArray * Sigma) {
    int nargout = 1;
    mxArray * dens = mclGetUninitializedArray();
    mlfEnterNewContext(0, 3, X, mu, Sigma);
    dens = Mc_dgaus(nargout, X, mu, Sigma);
    mlfRestorePreviousContext(0, 3, X, mu, Sigma);
    return mlfReturnValue(dens);
}
