/*
 * MATLAB Compiler: 2.0
 * Date: Fri Dec 10 17:53:12 1999
 * Arguments: "-x" "hmm_mest.m" 
 */

#ifndef MLF_V2
#define MLF_V2 1
#endif

#include "matlab.h"
#include "hmm_fb.h"
#include "hmm_chk.h"
#include "hmm_mest.h"

static mlfFunctionTableEntry function_table[1]
  = { { "hmm_mest", mlxHmm_mest, 6, 3 } };

static mxArray * Mhmm_fb(mxArray * * beta,
                         mxArray * * logscale,
                         mxArray * * dens,
                         int nargout_,
                         mxArray * X,
                         mxArray * A,
                         mxArray * pi0,
                         mxArray * mu,
                         mxArray * Sigma,
                         mxArray * QUIET) {
    mxArray * alpha = mclGetUninitializedArray();
    mclFevalCallMATLAB(
      mclNVarargout(nargout_, 0, &alpha, beta, logscale, dens, NULL),
      "hmm_fb",
      X, A, pi0, mu, Sigma, QUIET, NULL);
    return alpha;
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

/*
 * The function "mexFunction" is a Compiler-generated mex wrapper, suitable for
 * building a MEX-function. It initializes any persistent variables as well as
 * a function table for use by the feval function. It then calls the function
 * "mlxHmm_mest". Finally, it clears the feval table and exits.
 */
void mexFunction(int nlhs, mxArray * * plhs, int nrhs, mxArray * * prhs) {
    mlfTry {
        mlfFunctionTableSetup(1, function_table);
        mclImportGlobal(0, NULL);
        mlxHmm_mest(nlhs, plhs, nrhs, prhs);
        mlfFunctionTableTakedown(1, function_table);
    } mlfCatch {
        mlfFunctionTableTakedown(1, function_table);
        mclMexError();
    } mlfEndCatch
}

void mlxHmm_fb(int nlhs, mxArray * plhs[], int nrhs, mxArray * prhs[]) {
    mxArray * mprhs[6];
    mxArray * mplhs[4];
    int i;
    if (nlhs > 4) {
        mlfError(
          mxCreateString(
            "Run-time Error: File: hmm_fb Line: 1 Column: "
            "0 The function \"hmm_fb\" was called with mor"
            "e than the declared number of outputs (4)"));
    }
    if (nrhs > 6) {
        mlfError(
          mxCreateString(
            "Run-time Error: File: hmm_fb Line: 1 Column: "
            "0 The function \"hmm_fb\" was called with mor"
            "e than the declared number of inputs (6)"));
    }
    for (i = 0; i < 4; ++i) {
        mplhs[i] = NULL;
    }
    for (i = 0; i < 6 && i < nrhs; ++i) {
        mprhs[i] = prhs[i];
    }
    for (; i < 6; ++i) {
        mprhs[i] = NULL;
    }
    mlfEnterNewContext(
      0, 6, mprhs[0], mprhs[1], mprhs[2], mprhs[3], mprhs[4], mprhs[5]);
    mplhs[0]
      = Mhmm_fb(
          &mplhs[1],
          &mplhs[2],
          &mplhs[3],
          nlhs,
          mprhs[0],
          mprhs[1],
          mprhs[2],
          mprhs[3],
          mprhs[4],
          mprhs[5]);
    mlfRestorePreviousContext(
      0, 6, mprhs[0], mprhs[1], mprhs[2], mprhs[3], mprhs[4], mprhs[5]);
    plhs[0] = mplhs[0];
    for (i = 1; i < 4 && i < nlhs; ++i) {
        plhs[i] = mplhs[i];
    }
    for (; i < 4; ++i) {
        mxDestroyArray(mplhs[i]);
    }
}

mxArray * mlfHmm_fb(mxArray * * beta,
                    mxArray * * logscale,
                    mxArray * * dens,
                    mxArray * X,
                    mxArray * A,
                    mxArray * pi0,
                    mxArray * mu,
                    mxArray * Sigma,
                    mxArray * QUIET) {
    int nargout = 1;
    mxArray * alpha = mclGetUninitializedArray();
    mxArray * beta__ = mclGetUninitializedArray();
    mxArray * logscale__ = mclGetUninitializedArray();
    mxArray * dens__ = mclGetUninitializedArray();
    mlfEnterNewContext(3, 6, beta, logscale, dens, X, A, pi0, mu, Sigma, QUIET);
    if (beta != NULL) {
        ++nargout;
    }
    if (logscale != NULL) {
        ++nargout;
    }
    if (dens != NULL) {
        ++nargout;
    }
    alpha
      = Mhmm_fb(
          &beta__, &logscale__, &dens__, nargout, X, A, pi0, mu, Sigma, QUIET);
    mlfRestorePreviousContext(
      3, 6, beta, logscale, dens, X, A, pi0, mu, Sigma, QUIET);
    if (beta != NULL) {
        mclCopyOutputArg(beta, beta__);
    } else {
        mxDestroyArray(beta__);
    }
    if (logscale != NULL) {
        mclCopyOutputArg(logscale, logscale__);
    } else {
        mxDestroyArray(logscale__);
    }
    if (dens != NULL) {
        mclCopyOutputArg(dens, dens__);
    } else {
        mxDestroyArray(dens__);
    }
    return mlfReturnValue(alpha);
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
