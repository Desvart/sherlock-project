/*
 * MATLAB Compiler: 2.0.1
 * Date: Tue Dec 21 14:04:33 1999
 * Arguments: "-x" "hmm_vit.m" 
 */
#include "hmm_vit.h"
#include "gauslogv.h"
#include "hmm_chk.h"

/*
 * The function "Mhmm_vit" is the implementation version of the "hmm_vit"
 * M-function from file "s:\matlab5\reco\toolboxes\pc\h2m\hmm_vit.m" (lines
 * 1-59). It contains the actual compiled code for that M-function. It is a
 * static function and must only be called from one of the interface functions,
 * appearing below.
 */
/*
 * function [logl, path, plogl, logdens, framelogl] = hmm_vit (X, A, pi0, mu, Sigma, QUIET);
 */
static mxArray * Mhmm_vit(mxArray * * path,
                          mxArray * * plogl,
                          mxArray * * logdens,
                          mxArray * * framelogl,
                          int nargout_,
                          mxArray * X,
                          mxArray * A,
                          mxArray * pi0,
                          mxArray * mu,
                          mxArray * Sigma,
                          mxArray * QUIET) {
    mxArray * logl = mclGetUninitializedArray();
    mxArray * DIAG_COV = mclGetUninitializedArray();
    mxArray * N = mclGetUninitializedArray();
    mxArray * Nc = mclGetUninitializedArray();
    mxArray * T = mclGetUninitializedArray();
    mxArray * ans = mclInitializeAns();
    mxArray * bcktr = mclGetUninitializedArray();
    mxArray * i = mclGetUninitializedArray();
    mclForLoopIterator iterator_0;
    mxArray * nargin_ = mclGetUninitializedArray();
    mxArray * p = mclGetUninitializedArray();
    mxArray * time = mclGetUninitializedArray();
    mlfAssign(&nargin_, mlfNargin(0, X, A, pi0, mu, Sigma, QUIET, NULL));
    mclValidateInputs("hmm_vit", 6, &X, &A, &pi0, &mu, &Sigma, &QUIET);
    mclCopyArray(&A);
    mclCopyArray(&pi0);
    mclCopyArray(&QUIET);
    /*
     * 
     * %hmm_vit   Computes the most likely sequence of states (Viterbi DP algorithm).
     * %	Use: [logl,path,plogl,dens] = hmm_vit(X,A,pi0,mu,Sigma). The
     * %	computation is peformed using partial log-likelihoods.
     * 
     * %	The mex-file 'c_dgaus' will be used in the diagonal case if it is
     * %	found in MATLAB's search path.
     * 
     * % Version 1.3
     * % Olivier Cappé, 05/07/96 - 17/06/97
     * % ENST Dpt. Signal / CNRS URA 820, Paris
     * 
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
     * logdens = gauslogv(X, mu, Sigma, QUIET);
     */
    mlfAssign(logdens, mlfGauslogv(X, mu, Sigma, QUIET));
    /*
     * 
     * % Viterbi recursion
     * if (~QUIET)
     */
    if (mlfTobool(mlfNot(QUIET))) {
        /*
         * fprintf(1, 'Viterbi recursion...'); time = cputime;
         */
        mclAssignAns(
          &ans,
          mlfFprintf(
            mlfScalar(1.0), mxCreateString("Viterbi recursion..."), NULL));
        mlfAssign(&time, mlfCputime());
    /*
     * end;
     */
    }
    /*
     * % HMM probabilities in log
     * A = log(A + realmin);
     */
    mlfAssign(&A, mlfLog(mlfPlus(A, mlfRealmin())));
    /*
     * pi0 = log(pi0 + realmin);
     */
    mlfAssign(&pi0, mlfLog(mlfPlus(pi0, mlfRealmin())));
    /*
     * % Partial loglikelihood array and bactracking array
     * plogl = zeros(T, N);
     */
    mlfAssign(plogl, mlfZeros(T, N, NULL));
    /*
     * bcktr = zeros(T-1, N);
     */
    mlfAssign(&bcktr, mlfZeros(mlfMinus(T, mlfScalar(1.0)), N, NULL));
    /*
     * plogl(1,:) = pi0 + logdens(1,:);
     */
    mlfIndexAssign(
      plogl,
      "(?,?)",
      mlfScalar(1.0),
      mlfCreateColonIndex(),
      mlfPlus(
        pi0,
        mlfIndexRef(*logdens, "(?,?)", mlfScalar(1.0), mlfCreateColonIndex())));
    /*
     * for i=2:T
     */
    for (mclForStart(&iterator_0, mlfScalar(2.0), T, NULL);
         mclForNext(&iterator_0, &i);
         ) {
        /*
         * [plogl(i,:), bcktr(i-1,:)] = max((plogl(i-1,:)' * ones(1,N)) + A);
         */
        mlfFeval(
          mlfIndexVarargout(
            plogl, "(?,?)", i, mlfCreateColonIndex(),
            &bcktr, "(?,?)", mlfMinus(i, mlfScalar(1.0)), mlfCreateColonIndex(),
            NULL),
          mlxMax,
          mlfPlus(
            mlfMtimes(
              mlfCtranspose(
                mlfIndexRef(
                  *plogl,
                  "(?,?)",
                  mlfMinus(i, mlfScalar(1.0)),
                  mlfCreateColonIndex())),
              mlfOnes(mlfScalar(1.0), N, NULL)),
            A),
          NULL);
        /*
         * plogl(i,:) = plogl(i,:) + logdens(i,:);
         */
        mlfIndexAssign(
          plogl,
          "(?,?)",
          i,
          mlfCreateColonIndex(),
          mlfPlus(
            mlfIndexRef(*plogl, "(?,?)", i, mlfCreateColonIndex()),
            mlfIndexRef(*logdens, "(?,?)", i, mlfCreateColonIndex())));
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
    /*
     * 
     * % Backtracking
     * if (~QUIET)
     */
    if (mlfTobool(mlfNot(QUIET))) {
        /*
         * fprintf(1, 'Backtracking...'); time = cputime;
         */
        mclAssignAns(
          &ans,
          mlfFprintf(mlfScalar(1.0), mxCreateString("Backtracking..."), NULL));
        mlfAssign(&time, mlfCputime());
    /*
     * end;
     */
    }
    /*
     * path = zeros(T,1);
     */
    mlfAssign(path, mlfZeros(T, mlfScalar(1.0), NULL));
    /*
     * [logl, path(T)] = max(plogl(T,:));
     */
    mlfFeval(
      mlfIndexVarargout(&logl, "", path, "(?)", T, NULL),
      mlxMax,
      mlfIndexRef(*plogl, "(?,?)", T, mlfCreateColonIndex()),
      NULL);
    /*
     * for i=(T-1):-1:1
     */
    for (mclForStart(
           &iterator_0,
           mlfMinus(T, mlfScalar(1.0)),
           mlfScalar(-1.0),
           mlfScalar(1.0));
         mclForNext(&iterator_0, &i);
         ) {
        /*
         * path(i) = bcktr(i, path(i+1));
         */
        mlfIndexAssign(
          path,
          "(?)",
          i,
          mlfIndexRef(
            bcktr,
            "(?,?)",
            i,
            mlfIndexRef(*path, "(?)", mlfPlus(i, mlfScalar(1.0)))));
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
    /*
     * 
     * framelogl=max(plogl');
     */
    mlfAssign(framelogl, mlfMax(NULL, mlfCtranspose(*plogl), NULL, NULL));
    mclValidateOutputs(
      "hmm_vit", 5, nargout_, &logl, path, plogl, logdens, framelogl);
    mxDestroyArray(A);
    mxDestroyArray(DIAG_COV);
    mxDestroyArray(N);
    mxDestroyArray(Nc);
    mxDestroyArray(QUIET);
    mxDestroyArray(T);
    mxDestroyArray(ans);
    mxDestroyArray(bcktr);
    mxDestroyArray(i);
    mxDestroyArray(nargin_);
    mxDestroyArray(p);
    mxDestroyArray(pi0);
    mxDestroyArray(time);
    return logl;
}

/*
 * The function "mlfHmm_vit" contains the normal interface for the "hmm_vit"
 * M-function from file "s:\matlab5\reco\toolboxes\pc\h2m\hmm_vit.m" (lines
 * 1-59). This function processes any input arguments and passes them to the
 * implementation version of the function, appearing above.
 */
mxArray * mlfHmm_vit(mxArray * * path,
                     mxArray * * plogl,
                     mxArray * * logdens,
                     mxArray * * framelogl,
                     mxArray * X,
                     mxArray * A,
                     mxArray * pi0,
                     mxArray * mu,
                     mxArray * Sigma,
                     mxArray * QUIET) {
    int nargout = 1;
    mxArray * logl = mclGetUninitializedArray();
    mxArray * path__ = mclGetUninitializedArray();
    mxArray * plogl__ = mclGetUninitializedArray();
    mxArray * logdens__ = mclGetUninitializedArray();
    mxArray * framelogl__ = mclGetUninitializedArray();
    mlfEnterNewContext(
      4, 6, path, plogl, logdens, framelogl, X, A, pi0, mu, Sigma, QUIET);
    if (path != NULL) {
        ++nargout;
    }
    if (plogl != NULL) {
        ++nargout;
    }
    if (logdens != NULL) {
        ++nargout;
    }
    if (framelogl != NULL) {
        ++nargout;
    }
    logl
      = Mhmm_vit(
          &path__,
          &plogl__,
          &logdens__,
          &framelogl__,
          nargout,
          X,
          A,
          pi0,
          mu,
          Sigma,
          QUIET);
    mlfRestorePreviousContext(
      4, 6, path, plogl, logdens, framelogl, X, A, pi0, mu, Sigma, QUIET);
    if (path != NULL) {
        mclCopyOutputArg(path, path__);
    } else {
        mxDestroyArray(path__);
    }
    if (plogl != NULL) {
        mclCopyOutputArg(plogl, plogl__);
    } else {
        mxDestroyArray(plogl__);
    }
    if (logdens != NULL) {
        mclCopyOutputArg(logdens, logdens__);
    } else {
        mxDestroyArray(logdens__);
    }
    if (framelogl != NULL) {
        mclCopyOutputArg(framelogl, framelogl__);
    } else {
        mxDestroyArray(framelogl__);
    }
    return mlfReturnValue(logl);
}

/*
 * The function "mlxHmm_vit" contains the feval interface for the "hmm_vit"
 * M-function from file "s:\matlab5\reco\toolboxes\pc\h2m\hmm_vit.m" (lines
 * 1-59). The feval function calls the implementation version of hmm_vit
 * through this function. This function processes any input arguments and
 * passes them to the implementation version of the function, appearing above.
 */
void mlxHmm_vit(int nlhs, mxArray * plhs[], int nrhs, mxArray * prhs[]) {
    mxArray * mprhs[6];
    mxArray * mplhs[5];
    int i;
    if (nlhs > 5) {
        mlfError(
          mxCreateString(
            "Run-time Error: File: hmm_vit Line: 1 Column: "
            "0 The function \"hmm_vit\" was called with mor"
            "e than the declared number of outputs (5)"));
    }
    if (nrhs > 6) {
        mlfError(
          mxCreateString(
            "Run-time Error: File: hmm_vit Line: 1 Column:"
            " 0 The function \"hmm_vit\" was called with m"
            "ore than the declared number of inputs (6)"));
    }
    for (i = 0; i < 5; ++i) {
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
      = Mhmm_vit(
          &mplhs[1],
          &mplhs[2],
          &mplhs[3],
          &mplhs[4],
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
    for (i = 1; i < 5 && i < nlhs; ++i) {
        plhs[i] = mplhs[i];
    }
    for (; i < 5; ++i) {
        mxDestroyArray(mplhs[i]);
    }
}
