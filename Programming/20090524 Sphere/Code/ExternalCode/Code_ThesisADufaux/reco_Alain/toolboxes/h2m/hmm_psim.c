/*
 * MATLAB Compiler: 2.0
 * Date: Fri Dec 10 17:53:45 1999
 * Arguments: "-x" "hmm_psim.m" 
 */
#include "hmm_psim.h"
#include "gauseval.h"
#include "hmm_chk.h"
#include "randindx.h"

/*
 * The function "Mhmm_psim" is the implementation version of the "hmm_psim"
 * M-function from file "s:\matlab5\reco\toolboxes\pc\h2m\hmm_psim.m" (lines
 * 1-63). It contains the actual compiled code for that M-function. It is a
 * static function and must only be called from one of the interface functions,
 * appearing below.
 */
/*
 * function s = hmm_psim (X, A, pi0, mu, Sigma, QUIET);
 */
static mxArray * Mhmm_psim(int nargout_,
                           mxArray * X,
                           mxArray * A,
                           mxArray * pi0,
                           mxArray * mu,
                           mxArray * Sigma,
                           mxArray * QUIET) {
    mxArray * s = mclGetUninitializedArray();
    mxArray * DIAG_COV = mclGetUninitializedArray();
    mxArray * N = mclGetUninitializedArray();
    mxArray * Nc = mclGetUninitializedArray();
    mxArray * T = mclGetUninitializedArray();
    mxArray * alpha = mclGetUninitializedArray();
    mxArray * ans = mclInitializeAns();
    mxArray * dens = mclGetUninitializedArray();
    mclForLoopIterator iterator_0;
    mxArray * nargin_ = mclGetUninitializedArray();
    mxArray * p = mclGetUninitializedArray();
    mxArray * scale = mclGetUninitializedArray();
    mxArray * t = mclGetUninitializedArray();
    mxArray * time = mclGetUninitializedArray();
    mlfAssign(&nargin_, mlfNargin(0, X, A, pi0, mu, Sigma, QUIET, NULL));
    mclValidateInputs("hmm_psim", 6, &X, &A, &pi0, &mu, &Sigma, &QUIET);
    mclCopyArray(&QUIET);
    /*
     * 
     * %hmm_psim  Generates a random sequence of conditional HMM states.
     * %	Use: s = hmm_psim(X,A,pi0,mu,Sigma) where s is a sequence of states
     * %	of the HMM drawn conditionnaly to the observed vectors X.
     * 
     * % Version 1.3
     * % Olivier Cappé, 11/07/97 - 16/07/97
     * % ENST Dpt. Signal / CNRS URA 820, Paris
     * 
     * % Needed functions
     * if (~((exist('randindx') == 2) | (exist('randindx') == 3)))
     */
    if (mlfTobool(
          mlfNot(
            mlfOr(
              mlfEq(mlfExist(mxCreateString("randindx"), NULL), mlfScalar(2.0)),
              mlfEq(
                mlfExist(mxCreateString("randindx"), NULL),
                mlfScalar(3.0)))))) {
        /*
         * error('Function randindx is missing.');
         */
        mlfError(mxCreateString("Function randindx is missing."));
    /*
     * end;
     */
    }
    /*
     * 
     * % Input args.
     * error(nargchk(5, 6, nargin));
     */
    mlfError(mlfNargchk(mlfScalar(5.0), mlfScalar(6.0), nargin_));
    /*
     * if (nargin < 6)
     */
    if (mlfTobool(mlfLt(nargin_, mlfScalar(6.0)))) {
        /*
         * QUIET = 0;
         */
        mlfAssign(&QUIET, mlfScalar(0.0));
    /*
     * end;
     */
    }
    /*
     * [N, p, DIAG_COV] = hmm_chk(A, pi0, mu, Sigma);
     */
    mlfAssign(&N, mlfHmm_chk(&p, &DIAG_COV, A, pi0, mu, Sigma));
    /*
     * [T, Nc] = size(X);
     */
    mlfSize(mlfVarargout(&T, &Nc, NULL), X, NULL);
    /*
     * if (Nc ~= p)
     */
    if (mlfTobool(mlfNe(Nc, p))) {
        /*
         * error('Observation vectors have an incorrect dimension.');
         */
        mlfError(
          mxCreateString("Observation vectors have an incorrect dimension."));
    /*
     * end;
     */
    }
    /*
     * 
     * % Compute density values
     * dens = gauseval(X, mu, Sigma, QUIET);
     */
    mlfAssign(&dens, mlfGauseval(X, mu, Sigma, QUIET));
    /*
     * 
     * % Forward pass
     * if (~QUIET)
     */
    if (mlfTobool(mlfNot(QUIET))) {
        /*
         * fprintf(1, 'Forward pass...'); time = cputime;
         */
        mclAssignAns(
          &ans,
          mlfFprintf(mlfScalar(1.0), mxCreateString("Forward pass..."), NULL));
        mlfAssign(&time, mlfCputime());
    /*
     * end;
     */
    }
    /*
     * alpha = zeros(T, N);
     */
    mlfAssign(&alpha, mlfZeros(T, N, NULL));
    /*
     * alpha(1,:) = pi0.*dens(1,:);
     */
    mlfIndexAssign(
      &alpha,
      "(?,?)",
      mlfScalar(1.0),
      mlfCreateColonIndex(),
      mlfTimes(
        pi0,
        mlfIndexRef(dens, "(?,?)", mlfScalar(1.0), mlfCreateColonIndex())));
    /*
     * for t=2:T
     */
    for (mclForStart(&iterator_0, mlfScalar(2.0), T, NULL);
         mclForNext(&iterator_0, &t);
         ) {
        /*
         * alpha(t,:) = (alpha(t-1,:) * A) .* dens(t,:);
         */
        mlfIndexAssign(
          &alpha,
          "(?,?)",
          t,
          mlfCreateColonIndex(),
          mlfTimes(
            mlfMtimes(
              mlfIndexRef(
                alpha,
                "(?,?)",
                mlfMinus(t, mlfScalar(1.0)),
                mlfCreateColonIndex()),
              A),
            mlfIndexRef(dens, "(?,?)", t, mlfCreateColonIndex())));
        /*
         * % Systematic scaling
         * scale = sum(alpha(t,:));
         */
        mlfAssign(
          &scale,
          mlfSum(mlfIndexRef(alpha, "(?,?)", t, mlfCreateColonIndex()), NULL));
        /*
         * alpha(t,:) = alpha(t,:) / scale;
         */
        mlfIndexAssign(
          &alpha,
          "(?,?)",
          t,
          mlfCreateColonIndex(),
          mlfMrdivide(
            mlfIndexRef(alpha, "(?,?)", t, mlfCreateColonIndex()), scale));
    /*
     * end;
     */
    }
    /*
     * if (~QUIET)
     */
    if (mlfTobool(mlfNot(QUIET))) {
        /*
         * time = cputime - time;
         */
        mlfAssign(&time, mlfMinus(mlfCputime(), time));
        /*
         * fprintf(1, ' (%.2f s)\n', time);
         */
        mclAssignAns(
          &ans,
          mlfFprintf(
            mlfScalar(1.0), mxCreateString(" (%.2f s)\\n"), time, NULL));
    /*
     * end;
     */
    }
    /*
     * 
     * % Simulation of the sequence
     * s = zeros(T,1);
     */
    mlfAssign(&s, mlfZeros(T, mlfScalar(1.0), NULL));
    /*
     * if (~QUIET)
     */
    if (mlfTobool(mlfNot(QUIET))) {
        /*
         * fprintf(1, 'Generating random sequence...'); time = cputime;
         */
        mclAssignAns(
          &ans,
          mlfFprintf(
            mlfScalar(1.0),
            mxCreateString("Generating random sequence..."), NULL));
        mlfAssign(&time, mlfCputime());
    /*
     * end;
     */
    }
    /*
     * % Generate last index (assumes that the last forward variable is normalized !)
     * s(T) = randindx(alpha(T,:),1,1);
     */
    mlfIndexAssign(
      &s,
      "(?)",
      T,
      mlfRandindx(
        mlfIndexRef(alpha, "(?,?)", T, mlfCreateColonIndex()),
        mlfScalar(1.0),
        mlfScalar(1.0)));
    /*
     * for t=(T-1):-1:1
     */
    for (mclForStart(
           &iterator_0,
           mlfMinus(T, mlfScalar(1.0)),
           mlfScalar(-1.0),
           mlfScalar(1.0));
         mclForNext(&iterator_0, &t);
         ) {
        /*
         * % Compute probabilities conditionnal to X and s(t+1:T)
         * p = A(:,s(t+1))'.*alpha(t,:);
         */
        mlfAssign(
          &p,
          mlfTimes(
            mlfCtranspose(
              mlfIndexRef(
                A,
                "(?,?)",
                mlfCreateColonIndex(),
                mlfIndexRef(s, "(?)", mlfPlus(t, mlfScalar(1.0))))),
            mlfIndexRef(alpha, "(?,?)", t, mlfCreateColonIndex())));
        /*
         * p = p./sum(p);
         */
        mlfAssign(&p, mlfRdivide(p, mlfSum(p, NULL)));
        /*
         * s(t) = randindx(p,1,1);
         */
        mlfIndexAssign(
          &s, "(?)", t, mlfRandindx(p, mlfScalar(1.0), mlfScalar(1.0)));
    /*
     * end;
     */
    }
    /*
     * if (~QUIET)
     */
    if (mlfTobool(mlfNot(QUIET))) {
        /*
         * time = cputime - time; fprintf(1, ' (%.2f s)\n',time);
         */
        mlfAssign(&time, mlfMinus(mlfCputime(), time));
        mclAssignAns(
          &ans,
          mlfFprintf(
            mlfScalar(1.0), mxCreateString(" (%.2f s)\\n"), time, NULL));
    /*
     * end;
     */
    }
    mclValidateOutputs("hmm_psim", 1, nargout_, &s);
    mxDestroyArray(DIAG_COV);
    mxDestroyArray(N);
    mxDestroyArray(Nc);
    mxDestroyArray(QUIET);
    mxDestroyArray(T);
    mxDestroyArray(alpha);
    mxDestroyArray(ans);
    mxDestroyArray(dens);
    mxDestroyArray(nargin_);
    mxDestroyArray(p);
    mxDestroyArray(scale);
    mxDestroyArray(t);
    mxDestroyArray(time);
    return s;
}

/*
 * The function "mlfHmm_psim" contains the normal interface for the "hmm_psim"
 * M-function from file "s:\matlab5\reco\toolboxes\pc\h2m\hmm_psim.m" (lines
 * 1-63). This function processes any input arguments and passes them to the
 * implementation version of the function, appearing above.
 */
mxArray * mlfHmm_psim(mxArray * X,
                      mxArray * A,
                      mxArray * pi0,
                      mxArray * mu,
                      mxArray * Sigma,
                      mxArray * QUIET) {
    int nargout = 1;
    mxArray * s = mclGetUninitializedArray();
    mlfEnterNewContext(0, 6, X, A, pi0, mu, Sigma, QUIET);
    s = Mhmm_psim(nargout, X, A, pi0, mu, Sigma, QUIET);
    mlfRestorePreviousContext(0, 6, X, A, pi0, mu, Sigma, QUIET);
    return mlfReturnValue(s);
}

/*
 * The function "mlxHmm_psim" contains the feval interface for the "hmm_psim"
 * M-function from file "s:\matlab5\reco\toolboxes\pc\h2m\hmm_psim.m" (lines
 * 1-63). The feval function calls the implementation version of hmm_psim
 * through this function. This function processes any input arguments and
 * passes them to the implementation version of the function, appearing above.
 */
void mlxHmm_psim(int nlhs, mxArray * plhs[], int nrhs, mxArray * prhs[]) {
    mxArray * mprhs[6];
    mxArray * mplhs[1];
    int i;
    if (nlhs > 1) {
        mlfError(
          mxCreateString(
            "Run-time Error: File: hmm_psim Line: 1 Column:"
            " 0 The function \"hmm_psim\" was called with m"
            "ore than the declared number of outputs (1)"));
    }
    if (nrhs > 6) {
        mlfError(
          mxCreateString(
            "Run-time Error: File: hmm_psim Line: 1 Column:"
            " 0 The function \"hmm_psim\" was called with m"
            "ore than the declared number of inputs (6)"));
    }
    for (i = 0; i < 1; ++i) {
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
      = Mhmm_psim(
          nlhs, mprhs[0], mprhs[1], mprhs[2], mprhs[3], mprhs[4], mprhs[5]);
    mlfRestorePreviousContext(
      0, 6, mprhs[0], mprhs[1], mprhs[2], mprhs[3], mprhs[4], mprhs[5]);
    plhs[0] = mplhs[0];
}
