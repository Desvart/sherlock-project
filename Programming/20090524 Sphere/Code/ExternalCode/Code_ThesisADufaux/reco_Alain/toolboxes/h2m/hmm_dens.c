/*
 * MATLAB Compiler: 2.0
 * Date: Fri Dec 10 17:52:28 1999
 * Arguments: "-x" "hmm_dens.m" 
 */
#include "hmm_dens.h"

/*
 * The function "Mhmm_dens" is the implementation version of the "hmm_dens"
 * M-function from file "s:\matlab5\reco\toolboxes\pc\h2m\hmm_dens.m" (lines
 * 1-62). It contains the actual compiled code for that M-function. It is a
 * static function and must only be called from one of the interface functions,
 * appearing below.
 */
/*
 * function [mu, Sigma, gamma] = hmm_dens (X, alpha, beta, DIAG_COV, QUIET);
 */
static mxArray * Mhmm_dens(mxArray * * Sigma,
                           mxArray * * gamma,
                           int nargout_,
                           mxArray * X,
                           mxArray * alpha,
                           mxArray * beta,
                           mxArray * DIAG_COV,
                           mxArray * QUIET) {
    mxArray * mu = mclGetUninitializedArray();
    mxArray * N = mclGetUninitializedArray();
    mxArray * T = mclGetUninitializedArray();
    mxArray * ans = mclInitializeAns();
    mxArray * i = mclGetUninitializedArray();
    mclForLoopIterator iterator_0;
    mclForLoopIterator iterator_1;
    mxArray * j = mclGetUninitializedArray();
    mxArray * nargin_ = mclGetUninitializedArray();
    mxArray * p = mclGetUninitializedArray();
    mxArray * time = mclGetUninitializedArray();
    mlfAssign(&nargin_, mlfNargin(0, X, alpha, beta, DIAG_COV, QUIET, NULL));
    mclValidateInputs("hmm_dens", 5, &X, &alpha, &beta, &DIAG_COV, &QUIET);
    mclCopyArray(&QUIET);
    /*
     * 
     * %hmm_dens  Reestimates the parameters of the Gaussian distributions for an HMM.
     * %	Use: [mu,Sigma,gamma] = hmm_dens(X,alpha,beta,DIAG_COV).
     * 
     * % Version 1.3
     * % Olivier Cappé, 14/03/96 - 17/03/97
     * % ENST Dpt. Signal / CNRS URA 820, Paris
     * 
     * % Check input data
     * error(nargchk(4, 5, nargin));
     */
    mlfError(mlfNargchk(mlfScalar(4.0), mlfScalar(5.0), nargin_));
    /*
     * if (nargin < 5)
     */
    if (mlfTobool(mlfLt(nargin_, mlfScalar(5.0)))) {
        /*
         * QUIET = 0;
         */
        mlfAssign(&QUIET, mlfScalar(0.0));
    /*
     * end;
     */
    }
    /*
     * if (size(alpha) ~= size(beta))
     */
    if (mlfTobool(
          mlfNe(
            mlfSize(mclValueVarargout(), alpha, NULL),
            mlfSize(mclValueVarargout(), beta, NULL)))) {
        /*
         * error('Check the size of forward and backward probability matrices.');
         */
        mlfError(
          mxCreateString(
            "Check the size of forward and backward probability matrices."));
    /*
     * end;
     */
    }
    /*
     * [T, N] = size(alpha);
     */
    mlfSize(mlfVarargout(&T, &N, NULL), alpha, NULL);
    /*
     * if (length(X(:,1)) ~= T)
     */
    if (mlfTobool(
          mlfNe(
            mlfLength(
              mlfIndexRef(X, "(?,?)", mlfCreateColonIndex(), mlfScalar(1.0))),
            T))) {
        /*
         * error('Check the number of observation vectors.');
         */
        mlfError(mxCreateString("Check the number of observation vectors."));
    /*
     * end;
     */
    }
    /*
     * p = length(X(1,:));
     */
    mlfAssign(
      &p,
      mlfLength(
        mlfIndexRef(X, "(?,?)", mlfScalar(1.0), mlfCreateColonIndex())));
    /*
     * 
     * % Compute state occupation probabilities
     * if (~QUIET)
     */
    if (mlfTobool(mlfNot(QUIET))) {
        /*
         * fprintf(1, 'Reestimating gaussian parameters...'); time = cputime;
         */
        mclAssignAns(
          &ans,
          mlfFprintf(
            mlfScalar(1.0),
            mxCreateString("Reestimating gaussian parameters..."), NULL));
        mlfAssign(&time, mlfCputime());
    /*
     * end;
     */
    }
    /*
     * gamma = alpha .* beta;
     */
    mlfAssign(gamma, mlfTimes(alpha, beta));
    /*
     * gamma = gamma ./ (sum(gamma')' * ones(1,N));
     */
    mlfAssign(
      gamma,
      mlfRdivide(
        *gamma,
        mlfMtimes(
          mlfCtranspose(mlfSum(mlfCtranspose(*gamma), NULL)),
          mlfOnes(mlfScalar(1.0), N, NULL))));
    /*
     * 
     * mu = zeros(N, p);
     */
    mlfAssign(&mu, mlfZeros(N, p, NULL));
    /*
     * if (DIAG_COV)
     */
    if (mlfTobool(DIAG_COV)) {
        /*
         * Sigma = zeros(N, p);
         */
        mlfAssign(Sigma, mlfZeros(N, p, NULL));
        /*
         * for i=1:N
         */
        for (mclForStart(&iterator_0, mlfScalar(1.0), N, NULL);
             mclForNext(&iterator_0, &i);
             ) {
            /*
             * mu(i,:) = sum (X .* (gamma(:,i) * ones(1,p)));
             */
            mlfIndexAssign(
              &mu,
              "(?,?)",
              i,
              mlfCreateColonIndex(),
              mlfSum(
                mlfTimes(
                  X,
                  mlfMtimes(
                    mlfIndexRef(*gamma, "(?,?)", mlfCreateColonIndex(), i),
                    mlfOnes(mlfScalar(1.0), p, NULL))),
                NULL));
            /*
             * Sigma(i,:) = sum(X.^2 .* (gamma(:,i) * ones(1,p)));
             */
            mlfIndexAssign(
              Sigma,
              "(?,?)",
              i,
              mlfCreateColonIndex(),
              mlfSum(
                mlfTimes(
                  mlfPower(X, mlfScalar(2.0)),
                  mlfMtimes(
                    mlfIndexRef(*gamma, "(?,?)", mlfCreateColonIndex(), i),
                    mlfOnes(mlfScalar(1.0), p, NULL))),
                NULL));
        /*
         * end;
         */
        }
        /*
         * % Normalization
         * mu = mu ./ (sum(gamma)' * ones(1,p));
         */
        mlfAssign(
          &mu,
          mlfRdivide(
            mu,
            mlfMtimes(
              mlfCtranspose(mlfSum(*gamma, NULL)),
              mlfOnes(mlfScalar(1.0), p, NULL))));
        /*
         * Sigma = Sigma ./ (sum(gamma)' * ones(1,p));
         */
        mlfAssign(
          Sigma,
          mlfRdivide(
            *Sigma,
            mlfMtimes(
              mlfCtranspose(mlfSum(*gamma, NULL)),
              mlfOnes(mlfScalar(1.0), p, NULL))));
        /*
         * % Sigma
         * Sigma = Sigma - mu.^2;
         */
        mlfAssign(Sigma, mlfMinus(*Sigma, mlfPower(mu, mlfScalar(2.0))));
    /*
     * else
     */
    } else {
        /*
         * Sigma = zeros(N*p, p);
         */
        mlfAssign(Sigma, mlfZeros(mlfMtimes(N, p), p, NULL));
        /*
         * for i = 1:N
         */
        for (mclForStart(&iterator_0, mlfScalar(1.0), N, NULL);
             mclForNext(&iterator_0, &i);
             ) {
            /*
             * for j = 1:T
             */
            for (mclForStart(&iterator_1, mlfScalar(1.0), T, NULL);
                 mclForNext(&iterator_1, &j);
                 ) {
                /*
                 * mu(i,:) = mu(i,:) + gamma(j,i)*X(j,:);
                 */
                mlfIndexAssign(
                  &mu,
                  "(?,?)",
                  i,
                  mlfCreateColonIndex(),
                  mlfPlus(
                    mlfIndexRef(mu, "(?,?)", i, mlfCreateColonIndex()),
                    mlfMtimes(
                      mlfIndexRef(*gamma, "(?,?)", j, i),
                      mlfIndexRef(X, "(?,?)", j, mlfCreateColonIndex()))));
                /*
                 * Sigma(((1+(i-1)*p):(i*p)),:) = Sigma(((1+(i-1)*p):(i*p)),:)...
                 */
                mlfIndexAssign(
                  Sigma,
                  "(?,?)",
                  mlfColon(
                    mlfPlus(
                      mlfScalar(1.0),
                      mlfMtimes(mlfMinus(i, mlfScalar(1.0)), p)),
                    mlfMtimes(i, p),
                    NULL),
                  mlfCreateColonIndex(),
                  mlfPlus(
                    mlfIndexRef(
                      *Sigma,
                      "(?,?)",
                      mlfColon(
                        mlfPlus(
                          mlfScalar(1.0),
                          mlfMtimes(mlfMinus(i, mlfScalar(1.0)), p)),
                        mlfMtimes(i, p),
                        NULL),
                      mlfCreateColonIndex()),
                    mlfMtimes(
                      mlfIndexRef(*gamma, "(?,?)", j, i),
                      mlfMtimes(
                        mlfCtranspose(
                          mlfIndexRef(X, "(?,?)", j, mlfCreateColonIndex())),
                        mlfIndexRef(X, "(?,?)", j, mlfCreateColonIndex())))));
            /*
             * + gamma(j,i)*(X(j,:)'*X(j,:));
             * end;
             */
            }
            /*
             * % Normalization
             * mu(i,:) = mu(i,:)/sum(gamma(:,i));
             */
            mlfIndexAssign(
              &mu,
              "(?,?)",
              i,
              mlfCreateColonIndex(),
              mlfMrdivide(
                mlfIndexRef(mu, "(?,?)", i, mlfCreateColonIndex()),
                mlfSum(
                  mlfIndexRef(*gamma, "(?,?)", mlfCreateColonIndex(), i),
                  NULL)));
            /*
             * Sigma(((1+(i-1)*p):(i*p)),:) = Sigma(((1+(i-1)*p):(i*p)),:) /sum(gamma(:,i));
             */
            mlfIndexAssign(
              Sigma,
              "(?,?)",
              mlfColon(
                mlfPlus(
                  mlfScalar(1.0), mlfMtimes(mlfMinus(i, mlfScalar(1.0)), p)),
                mlfMtimes(i, p),
                NULL),
              mlfCreateColonIndex(),
              mlfMrdivide(
                mlfIndexRef(
                  *Sigma,
                  "(?,?)",
                  mlfColon(
                    mlfPlus(
                      mlfScalar(1.0),
                      mlfMtimes(mlfMinus(i, mlfScalar(1.0)), p)),
                    mlfMtimes(i, p),
                    NULL),
                  mlfCreateColonIndex()),
                mlfSum(
                  mlfIndexRef(*gamma, "(?,?)", mlfCreateColonIndex(), i),
                  NULL)));
            /*
             * % Sigma
             * Sigma(((1+(i-1)*p):(i*p)),:) = Sigma(((1+(i-1)*p):(i*p)),:)...
             */
            mlfIndexAssign(
              Sigma,
              "(?,?)",
              mlfColon(
                mlfPlus(
                  mlfScalar(1.0), mlfMtimes(mlfMinus(i, mlfScalar(1.0)), p)),
                mlfMtimes(i, p),
                NULL),
              mlfCreateColonIndex(),
              mlfMinus(
                mlfIndexRef(
                  *Sigma,
                  "(?,?)",
                  mlfColon(
                    mlfPlus(
                      mlfScalar(1.0),
                      mlfMtimes(mlfMinus(i, mlfScalar(1.0)), p)),
                    mlfMtimes(i, p),
                    NULL),
                  mlfCreateColonIndex()),
                mlfMtimes(
                  mlfCtranspose(
                    mlfIndexRef(mu, "(?,?)", i, mlfCreateColonIndex())),
                  mlfIndexRef(mu, "(?,?)", i, mlfCreateColonIndex()))));
        /*
         * - mu(i,:)'*mu(i,:);
         * end;
         */
        }
    /*
     * end;
     */
    }
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
    mclValidateOutputs("hmm_dens", 3, nargout_, &mu, Sigma, gamma);
    mxDestroyArray(N);
    mxDestroyArray(QUIET);
    mxDestroyArray(T);
    mxDestroyArray(ans);
    mxDestroyArray(i);
    mxDestroyArray(j);
    mxDestroyArray(nargin_);
    mxDestroyArray(p);
    mxDestroyArray(time);
    return mu;
}

/*
 * The function "mlfHmm_dens" contains the normal interface for the "hmm_dens"
 * M-function from file "s:\matlab5\reco\toolboxes\pc\h2m\hmm_dens.m" (lines
 * 1-62). This function processes any input arguments and passes them to the
 * implementation version of the function, appearing above.
 */
mxArray * mlfHmm_dens(mxArray * * Sigma,
                      mxArray * * gamma,
                      mxArray * X,
                      mxArray * alpha,
                      mxArray * beta,
                      mxArray * DIAG_COV,
                      mxArray * QUIET) {
    int nargout = 1;
    mxArray * mu = mclGetUninitializedArray();
    mxArray * Sigma__ = mclGetUninitializedArray();
    mxArray * gamma__ = mclGetUninitializedArray();
    mlfEnterNewContext(2, 5, Sigma, gamma, X, alpha, beta, DIAG_COV, QUIET);
    if (Sigma != NULL) {
        ++nargout;
    }
    if (gamma != NULL) {
        ++nargout;
    }
    mu
      = Mhmm_dens(
          &Sigma__, &gamma__, nargout, X, alpha, beta, DIAG_COV, QUIET);
    mlfRestorePreviousContext(
      2, 5, Sigma, gamma, X, alpha, beta, DIAG_COV, QUIET);
    if (Sigma != NULL) {
        mclCopyOutputArg(Sigma, Sigma__);
    } else {
        mxDestroyArray(Sigma__);
    }
    if (gamma != NULL) {
        mclCopyOutputArg(gamma, gamma__);
    } else {
        mxDestroyArray(gamma__);
    }
    return mlfReturnValue(mu);
}

/*
 * The function "mlxHmm_dens" contains the feval interface for the "hmm_dens"
 * M-function from file "s:\matlab5\reco\toolboxes\pc\h2m\hmm_dens.m" (lines
 * 1-62). The feval function calls the implementation version of hmm_dens
 * through this function. This function processes any input arguments and
 * passes them to the implementation version of the function, appearing above.
 */
void mlxHmm_dens(int nlhs, mxArray * plhs[], int nrhs, mxArray * prhs[]) {
    mxArray * mprhs[5];
    mxArray * mplhs[3];
    int i;
    if (nlhs > 3) {
        mlfError(
          mxCreateString(
            "Run-time Error: File: hmm_dens Line: 1 Column:"
            " 0 The function \"hmm_dens\" was called with m"
            "ore than the declared number of outputs (3)"));
    }
    if (nrhs > 5) {
        mlfError(
          mxCreateString(
            "Run-time Error: File: hmm_dens Line: 1 Column:"
            " 0 The function \"hmm_dens\" was called with m"
            "ore than the declared number of inputs (5)"));
    }
    for (i = 0; i < 3; ++i) {
        mplhs[i] = NULL;
    }
    for (i = 0; i < 5 && i < nrhs; ++i) {
        mprhs[i] = prhs[i];
    }
    for (; i < 5; ++i) {
        mprhs[i] = NULL;
    }
    mlfEnterNewContext(0, 5, mprhs[0], mprhs[1], mprhs[2], mprhs[3], mprhs[4]);
    mplhs[0]
      = Mhmm_dens(
          &mplhs[1],
          &mplhs[2],
          nlhs,
          mprhs[0],
          mprhs[1],
          mprhs[2],
          mprhs[3],
          mprhs[4]);
    mlfRestorePreviousContext(
      0, 5, mprhs[0], mprhs[1], mprhs[2], mprhs[3], mprhs[4]);
    plhs[0] = mplhs[0];
    for (i = 1; i < 3 && i < nlhs; ++i) {
        plhs[i] = mplhs[i];
    }
    for (; i < 3; ++i) {
        mxDestroyArray(mplhs[i]);
    }
}
