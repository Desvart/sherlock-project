/*
 * MATLAB Compiler: 2.0
 * Date: Fri Dec 10 17:52:53 1999
 * Arguments: "-x" "hmm_fb.m" 
 */
#include "hmm_fb.h"
#include "gauseval.h"
#include "hmm_chk.h"

static double __Array0_r[1] = { 1.0 };

/*
 * The function "Mhmm_fb" is the implementation version of the "hmm_fb"
 * M-function from file "s:\matlab5\reco\toolboxes\pc\h2m\hmm_fb.m" (lines
 * 1-67). It contains the actual compiled code for that M-function. It is a
 * static function and must only be called from one of the interface functions,
 * appearing below.
 */
/*
 * function [alpha, beta, logscale, dens] = hmm_fb (X, A, pi0, mu, Sigma, QUIET);
 */
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
    mxArray * DIAG_COV = mclGetUninitializedArray();
    mxArray * N = mclGetUninitializedArray();
    mxArray * Nc = mclGetUninitializedArray();
    mxArray * T = mclGetUninitializedArray();
    mxArray * ans = mclInitializeAns();
    mxArray * i = mclGetUninitializedArray();
    mclForLoopIterator iterator_0;
    mxArray * nargin_ = mclGetUninitializedArray();
    mxArray * p = mclGetUninitializedArray();
    mxArray * scale = mclGetUninitializedArray();
    mxArray * time = mclGetUninitializedArray();
    mlfAssign(&nargin_, mlfNargin(0, X, A, pi0, mu, Sigma, QUIET, NULL));
    mclValidateInputs("hmm_fb", 6, &X, &A, &pi0, &mu, &Sigma, &QUIET);
    mclCopyArray(&QUIET);
    /*
     * 
     * %hmm_fb    Implements the forward-backward recursions (with scaling).
     * %	Use: [alpha,beta,logscale,dens] = hmm_fb(X,A,pi0,mu,Sigma) where
     * %	alpha and beta are the forward and backward variables and logscale
     * %	is the logarithmic sum of the scaling factors (for computing the
     * %	likelihood). dens contains the values of all gaussian densities for
     * %	each time index (usefull for the estimation of the transition
     * %	probabilities).
     * 
     * %	To compute the log-likehood, use: log(sum(alpha(T,:))) + logscale.
     * 
     * % Version 1.3
     * % Olivier Cappé, 11/03/96 - 15/07/97
     * % ENST Dpt. Signal / CNRS URA 820, Paris
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
    mlfAssign(dens, mlfGauseval(X, mu, Sigma, QUIET));
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
     * scale = [1 ; zeros(T-1, 1)];
     */
    mlfAssign(
      &scale,
      mlfVertcat(
        mlfDoubleMatrix(1, 1, __Array0_r, NULL),
        mlfHorzcat(
          mlfZeros(mlfMinus(T, mlfScalar(1.0)), mlfScalar(1.0), NULL), NULL),
        NULL));
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
        mlfIndexRef(*dens, "(?,?)", mlfScalar(1.0), mlfCreateColonIndex())));
    /*
     * for i=2:T
     */
    for (mclForStart(&iterator_0, mlfScalar(2.0), T, NULL);
         mclForNext(&iterator_0, &i);
         ) {
        /*
         * alpha(i,:) = (alpha(i-1,:) * A) .* dens(i,:);
         */
        mlfIndexAssign(
          &alpha,
          "(?,?)",
          i,
          mlfCreateColonIndex(),
          mlfTimes(
            mlfMtimes(
              mlfIndexRef(
                alpha,
                "(?,?)",
                mlfMinus(i, mlfScalar(1.0)),
                mlfCreateColonIndex()),
              A),
            mlfIndexRef(*dens, "(?,?)", i, mlfCreateColonIndex())));
        /*
         * % Systematic scaling
         * scale(i) = sum(alpha(i,:));
         */
        mlfIndexAssign(
          &scale,
          "(?)",
          i,
          mlfSum(mlfIndexRef(alpha, "(?,?)", i, mlfCreateColonIndex()), NULL));
        /*
         * alpha(i,:) = alpha(i,:) / scale(i);
         */
        mlfIndexAssign(
          &alpha,
          "(?,?)",
          i,
          mlfCreateColonIndex(),
          mlfMrdivide(
            mlfIndexRef(alpha, "(?,?)", i, mlfCreateColonIndex()),
            mlfIndexRef(scale, "(?)", i)));
    /*
     * end;
     */
    }
    /*
     * % This is not computationnaly efficient but log(prod()) won't work here !
     * logscale = sum(log(scale));
     */
    mlfAssign(logscale, mlfSum(mlfLog(scale), NULL));
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
     * % Backward pass
     * if (~QUIET)
     */
    if (mlfTobool(mlfNot(QUIET))) {
        /*
         * fprintf(1, 'Backward pass...'); time = cputime;
         */
        mclAssignAns(
          &ans,
          mlfFprintf(mlfScalar(1.0), mxCreateString("Backward pass..."), NULL));
        mlfAssign(&time, mlfCputime());
    /*
     * end;
     */
    }
    /*
     * % Scale the backward variable with the forward scale factors (this ensures
     * % that the reestimation of the transition matrix is correct)
     * beta = zeros(T, N);
     */
    mlfAssign(beta, mlfZeros(T, N, NULL));
    /*
     * beta(T, :) = ones(1, N);
     */
    mlfIndexAssign(
      beta,
      "(?,?)",
      T,
      mlfCreateColonIndex(),
      mlfOnes(mlfScalar(1.0), N, NULL));
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
         * beta(i, :) = (beta(i+1,:).* dens(i+1,:)) * A';
         */
        mlfIndexAssign(
          beta,
          "(?,?)",
          i,
          mlfCreateColonIndex(),
          mlfMtimes(
            mlfTimes(
              mlfIndexRef(
                *beta,
                "(?,?)",
                mlfPlus(i, mlfScalar(1.0)),
                mlfCreateColonIndex()),
              mlfIndexRef(
                *dens,
                "(?,?)",
                mlfPlus(i, mlfScalar(1.0)),
                mlfCreateColonIndex())),
            mlfCtranspose(A)));
        /*
         * % Apply scaling if needed
         * beta(i,:) = beta(i,:) / scale(i);
         */
        mlfIndexAssign(
          beta,
          "(?,?)",
          i,
          mlfCreateColonIndex(),
          mlfMrdivide(
            mlfIndexRef(*beta, "(?,?)", i, mlfCreateColonIndex()),
            mlfIndexRef(scale, "(?)", i)));
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
    mclValidateOutputs("hmm_fb", 4, nargout_, &alpha, beta, logscale, dens);
    mxDestroyArray(DIAG_COV);
    mxDestroyArray(N);
    mxDestroyArray(Nc);
    mxDestroyArray(QUIET);
    mxDestroyArray(T);
    mxDestroyArray(ans);
    mxDestroyArray(i);
    mxDestroyArray(nargin_);
    mxDestroyArray(p);
    mxDestroyArray(scale);
    mxDestroyArray(time);
    return alpha;
}

/*
 * The function "mlfHmm_fb" contains the normal interface for the "hmm_fb"
 * M-function from file "s:\matlab5\reco\toolboxes\pc\h2m\hmm_fb.m" (lines
 * 1-67). This function processes any input arguments and passes them to the
 * implementation version of the function, appearing above.
 */
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

/*
 * The function "mlxHmm_fb" contains the feval interface for the "hmm_fb"
 * M-function from file "s:\matlab5\reco\toolboxes\pc\h2m\hmm_fb.m" (lines
 * 1-67). The feval function calls the implementation version of hmm_fb through
 * this function. This function processes any input arguments and passes them
 * to the implementation version of the function, appearing above.
 */
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
