/*
 * MATLAB Compiler: 2.0
 * Date: Fri Dec 10 17:53:12 1999
 * Arguments: "-x" "hmm_mest.m" 
 */
#include "hmm_mest.h"
#include "hmm_chk.h"
#include "hmm_fb.h"

/*
 * The function "Mhmm_mest" is the implementation version of the "hmm_mest"
 * M-function from file "s:\matlab5\reco\toolboxes\pc\h2m\hmm_mest.m" (lines
 * 1-73). It contains the actual compiled code for that M-function. It is a
 * static function and must only be called from one of the interface functions,
 * appearing below.
 */
/*
 * function [A_, logl, gamma] = hmm_mest (X, st, A, mu, Sigma, QUIET);
 */
static mxArray * Mhmm_mest(mxArray * * logl,
                           mxArray * * gamma,
                           int nargout_,
                           mxArray * X,
                           mxArray * st,
                           mxArray * A,
                           mxArray * mu,
                           mxArray * Sigma,
                           mxArray * QUIET) {
    mxArray * A_ = mclGetUninitializedArray();
    mxArray * A_i = mclGetUninitializedArray();
    mxArray * DIAG_COV = mclGetUninitializedArray();
    mxArray * K = mclGetUninitializedArray();
    mxArray * KT = mclGetUninitializedArray();
    mxArray * N = mclGetUninitializedArray();
    mxArray * T = mclGetUninitializedArray();
    mxArray * alpha = mclGetUninitializedArray();
    mxArray * ans = mclInitializeAns();
    mxArray * beta = mclGetUninitializedArray();
    mxArray * den = mclGetUninitializedArray();
    mxArray * dens = mclGetUninitializedArray();
    mxArray * first = mclGetUninitializedArray();
    mxArray * i = mclGetUninitializedArray();
    mclForLoopIterator iterator_0;
    mclForLoopIterator iterator_1;
    mxArray * j = mclGetUninitializedArray();
    mxArray * last = mclGetUninitializedArray();
    mxArray * logscale = mclGetUninitializedArray();
    mxArray * nargin_ = mclGetUninitializedArray();
    mxArray * nc = mclGetUninitializedArray();
    mxArray * p = mclGetUninitializedArray();
    mxArray * pi0 = mclGetUninitializedArray();
    mxArray * time = mclGetUninitializedArray();
    mlfAssign(&nargin_, mlfNargin(0, X, st, A, mu, Sigma, QUIET, NULL));
    mclValidateInputs("hmm_mest", 6, &X, &st, &A, &mu, &Sigma, &QUIET);
    mclCopyArray(&A);
    mclCopyArray(&QUIET);
    /*
     * 
     * %hmm_mest  Reestimates transition parameters for multiple observation sequences
     * %          (left-to-right HMM).
     * %	Use: [A_,logl,gamma] = hmm_mest(X,st,A,mu,Sigma)
     * %	gamma can be used to reestimate the gaussian parameters.
     * 
     * % Version 1.3
     * % Olivier Cappé, 22/03/96 - 04/03/97
     * % ENST Dpt. Signal / CNRS URA 820, Paris
     * 
     * % Check input data and dimensions
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
     * N = length(A(1,:));
     */
    mlfAssign(
      &N,
      mlfLength(
        mlfIndexRef(A, "(?,?)", mlfScalar(1.0), mlfCreateColonIndex())));
    /*
     * pi0 = [1 zeros(1,N-1)];
     */
    mlfAssign(
      &pi0,
      mlfHorzcat(
        mlfScalar(1.0),
        mlfZeros(mlfScalar(1.0), mlfMinus(N, mlfScalar(1.0)), NULL),
        NULL));
    /*
     * [N,p,DIAG_COV] = hmm_chk(A, pi0, mu, Sigma);
     */
    mlfAssign(&N, mlfHmm_chk(&p, &DIAG_COV, A, pi0, mu, Sigma));
    /*
     * [KT, nc] = size(X);
     */
    mlfSize(mlfVarargout(&KT, &nc, NULL), X, NULL);
    /*
     * if (nc ~= p)
     */
    if (mlfTobool(mlfNe(nc, p))) {
        /*
         * error('Dimension of the observation vectors is incorrect.');
         */
        mlfError(
          mxCreateString("Dimension of the observation vectors is incorrect."));
    /*
     * end;
     */
    }
    /*
     * K = length(st);
     */
    mlfAssign(&K, mlfLength(st));
    /*
     * if ((st(1) ~= 1) | (st(K) >= KT))
     */
    {
        mxArray * a_ = mclInitialize(
                         mlfNe(
                           mlfIndexRef(st, "(?)", mlfScalar(1.0)),
                           mlfScalar(1.0)));
        if (mlfTobool(a_)
            || mlfTobool(mlfOr(a_, mlfGe(mlfIndexRef(st, "(?)", K), KT)))) {
            mxDestroyArray(a_);
            /*
             * error('Check the limits of the observation sequences.');
             */
            mlfError(
              mxCreateString("Check the limits of the observation sequences."));
        } else {
            mxDestroyArray(a_);
        }
    /*
     * end;
     */
    }
    /*
     * 
     * if (~QUIET)
     */
    if (mlfTobool(mlfNot(QUIET))) {
        /*
         * fprintf(1, 'Reestimating transition parameters..'); time = cputime;
         */
        mclAssignAns(
          &ans,
          mlfFprintf(
            mlfScalar(1.0),
            mxCreateString("Reestimating transition parameters.."), NULL));
        mlfAssign(&time, mlfCputime());
    /*
     * end;
     */
    }
    /*
     * % Force A to be sparse
     * A = sparse(A);
     */
    mlfAssign(&A, mlfSparse(A, NULL, NULL, NULL, NULL, NULL));
    /*
     * A_ = sparse(zeros(N));
     */
    mlfAssign(&A_, mlfSparse(mlfZeros(N, NULL), NULL, NULL, NULL, NULL, NULL));
    /*
     * gamma = zeros(KT, N);
     */
    mlfAssign(gamma, mlfZeros(KT, N, NULL));
    /*
     * den = 0;
     */
    mlfAssign(&den, mlfScalar(0.0));
    /*
     * logl = 0;
     */
    mlfAssign(logl, mlfScalar(0.0));
    /*
     * for i=1:K
     */
    for (mclForStart(&iterator_0, mlfScalar(1.0), K, NULL);
         mclForNext(&iterator_0, &i);
         ) {
        /*
         * if (~QUIET)
         */
        if (mlfTobool(mlfNot(QUIET))) {
            /*
             * if (rem(i,5) == 1)
             */
            if (mlfTobool(mlfEq(mlfRem(i, mlfScalar(5.0)), mlfScalar(1.0)))) {
                /*
                 * fprintf(1, '.');
                 */
                mclAssignAns(
                  &ans, mlfFprintf(mlfScalar(1.0), mxCreateString("."), NULL));
            /*
             * end;
             */
            }
        /*
         * end;
         */
        }
        /*
         * % Limits of the observation sequence
         * first = st(i);
         */
        mlfAssign(&first, mlfIndexRef(st, "(?)", i));
        /*
         * if (i == K)
         */
        if (mlfTobool(mlfEq(i, K))) {
            /*
             * last = KT;
             */
            mlfAssign(&last, KT);
        /*
         * else
         */
        } else {
            /*
             * last = st(i+1)-1;
             */
            mlfAssign(
              &last,
              mlfMinus(
                mlfIndexRef(st, "(?)", mlfPlus(i, mlfScalar(1.0))),
                mlfScalar(1.0)));
        /*
         * end;
         */
        }
        /*
         * T = last - first + 1;
         */
        mlfAssign(&T, mlfPlus(mlfMinus(last, first), mlfScalar(1.0)));
        /*
         * [alpha, beta, logscale, dens] = hmm_fb (X(first:last,:), A, pi0, mu, Sigma, 1);
         */
        mlfAssign(
          &alpha,
          mlfHmm_fb(
            &beta,
            &logscale,
            &dens,
            mlfIndexRef(
              X, "(?,?)", mlfColon(first, last, NULL), mlfCreateColonIndex()),
            A,
            pi0,
            mu,
            Sigma,
            mlfScalar(1.0)));
        /*
         * % Compute log-likelihood
         * logl = logl + log(sum(alpha(length(alpha(:,1)),:))) + logscale;
         */
        mlfAssign(
          logl,
          mlfPlus(
            mlfPlus(
              *logl,
              mlfLog(
                mlfSum(
                  mlfIndexRef(
                    alpha,
                    "(?,?)",
                    mlfLength(
                      mlfIndexRef(
                        alpha, "(?,?)", mlfCreateColonIndex(), mlfScalar(1.0))),
                    mlfCreateColonIndex()),
                  NULL))),
            logscale));
        /*
         * % Reestimate transition parameters
         * % Numerator
         * for j=1:T-1
         */
        for (mclForStart(
               &iterator_1, mlfScalar(1.0), mlfMinus(T, mlfScalar(1.0)), NULL);
             mclForNext(&iterator_1, &j);
             ) {
            /*
             * A_i = alpha(j,:)' * (dens(j+1,:) .* beta(j+1,:)) .* A;
             */
            mlfAssign(
              &A_i,
              mlfTimes(
                mlfMtimes(
                  mlfCtranspose(
                    mlfIndexRef(alpha, "(?,?)", j, mlfCreateColonIndex())),
                  mlfTimes(
                    mlfIndexRef(
                      dens,
                      "(?,?)",
                      mlfPlus(j, mlfScalar(1.0)),
                      mlfCreateColonIndex()),
                    mlfIndexRef(
                      beta,
                      "(?,?)",
                      mlfPlus(j, mlfScalar(1.0)),
                      mlfCreateColonIndex()))),
                A));
            /*
             * A_i = A_i /sum(sum(A_i));
             */
            mlfAssign(&A_i, mlfMrdivide(A_i, mlfSum(mlfSum(A_i, NULL), NULL)));
            /*
             * A_ = A_ + A_i;
             */
            mlfAssign(&A_, mlfPlus(A_, A_i));
        /*
         * end;
         */
        }
        /*
         * % Denominator
         * % Memorize state probabilities
         * gamma(first:last,:) = alpha .* beta;
         */
        mlfIndexAssign(
          gamma,
          "(?,?)",
          mlfColon(first, last, NULL),
          mlfCreateColonIndex(),
          mlfTimes(alpha, beta));
        /*
         * gamma(first:last,:) = gamma(first:last,:) ./ (sum(gamma(first:last,:)')' * ones(1,N));
         */
        mlfIndexAssign(
          gamma,
          "(?,?)",
          mlfColon(first, last, NULL),
          mlfCreateColonIndex(),
          mlfRdivide(
            mlfIndexRef(
              *gamma,
              "(?,?)",
              mlfColon(first, last, NULL),
              mlfCreateColonIndex()),
            mlfMtimes(
              mlfCtranspose(
                mlfSum(
                  mlfCtranspose(
                    mlfIndexRef(
                      *gamma,
                      "(?,?)",
                      mlfColon(first, last, NULL),
                      mlfCreateColonIndex())),
                  NULL)),
              mlfOnes(mlfScalar(1.0), N, NULL))));
        /*
         * den = den + sum(gamma(first:first+T-2,:));
         */
        mlfAssign(
          &den,
          mlfPlus(
            den,
            mlfSum(
              mlfIndexRef(
                *gamma,
                "(?,?)",
                mlfColon(
                  first, mlfMinus(mlfPlus(first, T), mlfScalar(2.0)), NULL),
                mlfCreateColonIndex()),
              NULL)));
    /*
     * end;
     */
    }
    /*
     * % Normalize transition matrix
     * A_ = A_ ./ (den' * ones(1,N));
     */
    mlfAssign(
      &A_,
      mlfRdivide(
        A_, mlfMtimes(mlfCtranspose(den), mlfOnes(mlfScalar(1.0), N, NULL))));
    /*
     * if (~QUIET)
     */
    if (mlfTobool(mlfNot(QUIET))) {
        /*
         * time = cputime - time; fprintf(1, ' (%.2f s)\n', time);
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
    mclValidateOutputs("hmm_mest", 3, nargout_, &A_, logl, gamma);
    mxDestroyArray(A);
    mxDestroyArray(A_i);
    mxDestroyArray(DIAG_COV);
    mxDestroyArray(K);
    mxDestroyArray(KT);
    mxDestroyArray(N);
    mxDestroyArray(QUIET);
    mxDestroyArray(T);
    mxDestroyArray(alpha);
    mxDestroyArray(ans);
    mxDestroyArray(beta);
    mxDestroyArray(den);
    mxDestroyArray(dens);
    mxDestroyArray(first);
    mxDestroyArray(i);
    mxDestroyArray(j);
    mxDestroyArray(last);
    mxDestroyArray(logscale);
    mxDestroyArray(nargin_);
    mxDestroyArray(nc);
    mxDestroyArray(p);
    mxDestroyArray(pi0);
    mxDestroyArray(time);
    return A_;
}

/*
 * The function "mlfHmm_mest" contains the normal interface for the "hmm_mest"
 * M-function from file "s:\matlab5\reco\toolboxes\pc\h2m\hmm_mest.m" (lines
 * 1-73). This function processes any input arguments and passes them to the
 * implementation version of the function, appearing above.
 */
mxArray * mlfHmm_mest(mxArray * * logl,
                      mxArray * * gamma,
                      mxArray * X,
                      mxArray * st,
                      mxArray * A,
                      mxArray * mu,
                      mxArray * Sigma,
                      mxArray * QUIET) {
    int nargout = 1;
    mxArray * A_ = mclGetUninitializedArray();
    mxArray * logl__ = mclGetUninitializedArray();
    mxArray * gamma__ = mclGetUninitializedArray();
    mlfEnterNewContext(2, 6, logl, gamma, X, st, A, mu, Sigma, QUIET);
    if (logl != NULL) {
        ++nargout;
    }
    if (gamma != NULL) {
        ++nargout;
    }
    A_ = Mhmm_mest(&logl__, &gamma__, nargout, X, st, A, mu, Sigma, QUIET);
    mlfRestorePreviousContext(2, 6, logl, gamma, X, st, A, mu, Sigma, QUIET);
    if (logl != NULL) {
        mclCopyOutputArg(logl, logl__);
    } else {
        mxDestroyArray(logl__);
    }
    if (gamma != NULL) {
        mclCopyOutputArg(gamma, gamma__);
    } else {
        mxDestroyArray(gamma__);
    }
    return mlfReturnValue(A_);
}

/*
 * The function "mlxHmm_mest" contains the feval interface for the "hmm_mest"
 * M-function from file "s:\matlab5\reco\toolboxes\pc\h2m\hmm_mest.m" (lines
 * 1-73). The feval function calls the implementation version of hmm_mest
 * through this function. This function processes any input arguments and
 * passes them to the implementation version of the function, appearing above.
 */
void mlxHmm_mest(int nlhs, mxArray * plhs[], int nrhs, mxArray * prhs[]) {
    mxArray * mprhs[6];
    mxArray * mplhs[3];
    int i;
    if (nlhs > 3) {
        mlfError(
          mxCreateString(
            "Run-time Error: File: hmm_mest Line: 1 Column:"
            " 0 The function \"hmm_mest\" was called with m"
            "ore than the declared number of outputs (3)"));
    }
    if (nrhs > 6) {
        mlfError(
          mxCreateString(
            "Run-time Error: File: hmm_mest Line: 1 Column:"
            " 0 The function \"hmm_mest\" was called with m"
            "ore than the declared number of inputs (6)"));
    }
    for (i = 0; i < 3; ++i) {
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
      = Mhmm_mest(
          &mplhs[1],
          &mplhs[2],
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
    for (i = 1; i < 3 && i < nlhs; ++i) {
        plhs[i] = mplhs[i];
    }
    for (; i < 3; ++i) {
        mxDestroyArray(mplhs[i]);
    }
}
