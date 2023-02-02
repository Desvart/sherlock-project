/*
 * MATLAB Compiler: 2.0
 * Date: Fri Dec 10 17:53:45 1999
 * Arguments: "-x" "hmm_psim.m" 
 */

#ifndef MLF_V2
#define MLF_V2 1
#endif

#include "matlab.h"
#include "randindx.h"
#include "hmm_chk.h"
#include "gauseval.h"
#include "hmm_psim.h"

static mlfFunctionTableEntry function_table[1]
  = { { "hmm_psim", mlxHmm_psim, 6, 1 } };

static mxArray * Mrandindx(int nargout_,
                           mxArray * p,
                           mxArray * T,
                           mxArray * NO_CHK) {
    mxArray * I = mclGetUninitializedArray();
    mclFevalCallMATLAB(
      mclNVarargout(nargout_, 0, &I, NULL), "randindx", p, T, NO_CHK, NULL);
    return I;
}

static mxArray * Mhmm_chk(mxArray * * p,
                          mxArray * * DIAG_COV,
                          int nargout_,
                          mxArray * A,
                          mxArray * pi0,
                          mxArray * mu,
                          mxArray * Sigma) {
    mxArray * N = mclGetUninitializedArray();
    mclFevalCallMATLAB(
      mclNVarargout(nargout_, 0, &N, p, DIAG_COV, NULL),
      "hmm_chk",
      A, pi0, mu, Sigma, NULL);
    return N;
}

static mxArray * Mgauseval(int nargout_,
                           mxArray * X,
                           mxArray * mu,
                           mxArray * Sigma,
                           mxArray * QUIET) {
    mxArray * dens = mclGetUninitializedArray();
    mclFevalCallMATLAB(
      mclNVarargout(nargout_, 0, &dens, NULL),
      "gauseval",
      X, mu, Sigma, QUIET, NULL);
    return dens;
}

/*
 * The function "mexFunction" is a Compiler-generated mex wrapper, suitable for
 * building a MEX-function. It initializes any persistent variables as well as
 * a function table for use by the feval function. It then calls the function
 * "mlxHmm_psim". Finally, it clears the feval table and exits.
 */
void mexFunction(int nlhs, mxArray * * plhs, int nrhs, mxArray * * prhs) {
    mlfTry {
        mlfFunctionTableSetup(1, function_table);
        mclImportGlobal(0, NULL);
        mlxHmm_psim(nlhs, plhs, nrhs, prhs);
        mlfFunctionTableTakedown(1, function_table);
    } mlfCatch {
        mlfFunctionTableTakedown(1, function_table);
        mclMexError();
    } mlfEndCatch
}

void mlxRandindx(int nlhs, mxArray * plhs[], int nrhs, mxArray * prhs[]) {
    mxArray * mprhs[3];
    mxArray * mplhs[1];
    int i;
    if (nlhs > 1) {
        mlfError(
          mxCreateString(
            "Run-time Error: File: randindx Line: 1 Column:"
            " 0 The function \"randindx\" was called with m"
            "ore than the declared number of outputs (1)"));
    }
    if (nrhs > 3) {
        mlfError(
          mxCreateString(
            "Run-time Error: File: randindx Line: 1 Column:"
            " 0 The function \"randindx\" was called with m"
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
    mplhs[0] = Mrandindx(nlhs, mprhs[0], mprhs[1], mprhs[2]);
    mlfRestorePreviousContext(0, 3, mprhs[0], mprhs[1], mprhs[2]);
    plhs[0] = mplhs[0];
}

mxArray * mlfRandindx(mxArray * p, mxArray * T, mxArray * NO_CHK) {
    int nargout = 1;
    mxArray * I = mclGetUninitializedArray();
    mlfEnterNewContext(0, 3, p, T, NO_CHK);
    I = Mrandindx(nargout, p, T, NO_CHK);
    mlfRestorePreviousContext(0, 3, p, T, NO_CHK);
    return mlfReturnValue(I);
}

void mlxHmm_chk(int nlhs, mxArray * plhs[], int nrhs, mxArray * prhs[]) {
    mxArray * mprhs[4];
    mxArray * mplhs[3];
    int i;
    if (nlhs > 3) {
        mlfError(
          mxCreateString(
            "Run-time Error: File: hmm_chk Line: 1 Column: "
            "0 The function \"hmm_chk\" was called with mor"
            "e than the declared number of outputs (3)"));
    }
    if (nrhs > 4) {
        mlfError(
          mxCreateString(
            "Run-time Error: File: hmm_chk Line: 1 Column:"
            " 0 The function \"hmm_chk\" was called with m"
            "ore than the declared number of inputs (4)"));
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
      = Mhmm_chk(
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

mxArray * mlfHmm_chk(mxArray * * p,
                     mxArray * * DIAG_COV,
                     mxArray * A,
                     mxArray * pi0,
                     mxArray * mu,
                     mxArray * Sigma) {
    int nargout = 1;
    mxArray * N = mclGetUninitializedArray();
    mxArray * p__ = mclGetUninitializedArray();
    mxArray * DIAG_COV__ = mclGetUninitializedArray();
    mlfEnterNewContext(2, 4, p, DIAG_COV, A, pi0, mu, Sigma);
    if (p != NULL) {
        ++nargout;
    }
    if (DIAG_COV != NULL) {
        ++nargout;
    }
    N = Mhmm_chk(&p__, &DIAG_COV__, nargout, A, pi0, mu, Sigma);
    mlfRestorePreviousContext(2, 4, p, DIAG_COV, A, pi0, mu, Sigma);
    if (p != NULL) {
        mclCopyOutputArg(p, p__);
    } else {
        mxDestroyArray(p__);
    }
    if (DIAG_COV != NULL) {
        mclCopyOutputArg(DIAG_COV, DIAG_COV__);
    } else {
        mxDestroyArray(DIAG_COV__);
    }
    return mlfReturnValue(N);
}

void mlxGauseval(int nlhs, mxArray * plhs[], int nrhs, mxArray * prhs[]) {
    mxArray * mprhs[4];
    mxArray * mplhs[1];
    int i;
    if (nlhs > 1) {
        mlfError(
          mxCreateString(
            "Run-time Error: File: gauseval Line: 1 Column:"
            " 0 The function \"gauseval\" was called with m"
            "ore than the declared number of outputs (1)"));
    }
    if (nrhs > 4) {
        mlfError(
          mxCreateString(
            "Run-time Error: File: gauseval Line: 1 Column:"
            " 0 The function \"gauseval\" was called with m"
            "ore than the declared number of inputs (4)"));
    }
    for (i = 0; i < 1; ++i) {
        mplhs[i] = NULL;
    }
    for (i = 0; i < 4 && i < nrhs; ++i) {
        mprhs[i] = prhs[i];
    }
    for (; i < 4; ++i) {
        mprhs[i] = NULL;
    }
    mlfEnterNewContext(0, 4, mprhs[0], mprhs[1], mprhs[2], mprhs[3]);
    mplhs[0] = Mgauseval(nlhs, mprhs[0], mprhs[1], mprhs[2], mprhs[3]);
    mlfRestorePreviousContext(0, 4, mprhs[0], mprhs[1], mprhs[2], mprhs[3]);
    plhs[0] = mplhs[0];
}

mxArray * mlfGauseval(mxArray * X,
                      mxArray * mu,
                      mxArray * Sigma,
                      mxArray * QUIET) {
    int nargout = 1;
    mxArray * dens = mclGetUninitializedArray();
    mlfEnterNewContext(0, 4, X, mu, Sigma, QUIET);
    dens = Mgauseval(nargout, X, mu, Sigma, QUIET);
    mlfRestorePreviousContext(0, 4, X, mu, Sigma, QUIET);
    return mlfReturnValue(dens);
}
