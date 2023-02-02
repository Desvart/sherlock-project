/*
 * MATLAB Compiler: 2.0
 * Date: Fri Dec 10 17:53:28 1999
 * Arguments: "-x" "hmm_mint.m" 
 */
#include "hmm_mint.h"

/*
 * The function "Mhmm_mint" is the implementation version of the "hmm_mint"
 * M-function from file "s:\matlab5\reco\toolboxes\pc\h2m\hmm_mint.m" (lines
 * 1-89). It contains the actual compiled code for that M-function. It is a
 * static function and must only be called from one of the interface functions,
 * appearing below.
 */
/*
 * function [mu, Sigma] = hmm_mint (X, st, N, DIAG_COV, QUIET);
 */
static mxArray * Mhmm_mint(mxArray * * Sigma,
                           int nargout_,
                           mxArray * X,
                           mxArray * st,
                           mxArray * N,
                           mxArray * DIAG_COV,
                           mxArray * QUIET) {
    mxArray * mu = mclGetUninitializedArray();
    mxArray * K = mclGetUninitializedArray();
    mxArray * KT = mclGetUninitializedArray();
    mxArray * ans = mclInitializeAns();
    mxArray * count = mclGetUninitializedArray();
    mxArray * first = mclGetUninitializedArray();
    mxArray * i = mclGetUninitializedArray();
    mclForLoopIterator iterator_0;
    mclForLoopIterator iterator_1;
    mxArray * j = mclGetUninitializedArray();
    mxArray * last = mclGetUninitializedArray();
    mxArray * nargin_ = mclGetUninitializedArray();
    mxArray * p = mclGetUninitializedArray();
    mxArray * seg = mclGetUninitializedArray();
    mxArray * time = mclGetUninitializedArray();
    mlfAssign(&nargin_, mlfNargin(0, X, st, N, DIAG_COV, QUIET, NULL));
    mclValidateInputs("hmm_mint", 5, &X, &st, &N, &DIAG_COV, &QUIET);
    mclCopyArray(&QUIET);
    /*
     * 
     * %hmm_mint  Initializes the model parameters using multiple observations
     * %          for a left-to-right HMM.
     * %	Use: [mu,Sigma] = hmm_mint(X,st,N,DIAG_COV).
     * 
     * % Version 1.3
     * % Olivier Cappé, 1995 - 22/03/96
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
     * 
     * % Dimensions
     * [KT, p] = size(X);
     */
    mlfSize(mlfVarargout(&KT, &p, NULL), X, NULL);
    /*
     * K = length(st);
     */
    mlfAssign(&K, mlfLength(st));
    /*
     * % Check
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
     * if (any((diff(st)*K/N) < 2))
     */
    if (mlfTobool(
          mlfAny(
            mlfLt(
              mlfMrdivide(mlfMtimes(mlfDiff(st, NULL, NULL), K), N),
              mlfScalar(2.0)),
            NULL))) {
        /*
         * error('Too much states or not enough data.');
         */
        mlfError(mxCreateString("Too much states or not enough data."));
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
         * fprintf(1, 'Initializing gaussian parameters...'); time = cputime;
         */
        mclAssignAns(
          &ans,
          mlfFprintf(
            mlfScalar(1.0),
            mxCreateString("Initializing gaussian parameters..."), NULL));
        mlfAssign(&time, mlfCputime());
    /*
     * end;
     */
    }
    /*
     * mu = zeros(N,p);
     */
    mlfAssign(&mu, mlfZeros(N, p, NULL));
    /*
     * count = zeros(1, N);
     */
    mlfAssign(&count, mlfZeros(mlfScalar(1.0), N, NULL));
    /*
     * if (DIAG_COV)
     */
    if (mlfTobool(DIAG_COV)) {
        /*
         * % Initialization
         * Sigma = zeros(N,p);
         */
        mlfAssign(Sigma, mlfZeros(N, p, NULL));
        /*
         * for i=1:K
         */
        for (mclForStart(&iterator_0, mlfScalar(1.0), K, NULL);
             mclForNext(&iterator_0, &i);
             ) {
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
             * % Uniform segmentation
             * seg = linspace(first, last, N+1);
             */
            mlfAssign(
              &seg, mlfLinspace(first, last, mlfPlus(N, mlfScalar(1.0))));
            /*
             * % Frame count
             * count = count + (seg(2:N+1)-seg(1:N)+1);
             */
            mlfAssign(
              &count,
              mlfPlus(
                count,
                mlfPlus(
                  mlfMinus(
                    mlfIndexRef(
                      seg,
                      "(?)",
                      mlfColon(
                        mlfScalar(2.0), mlfPlus(N, mlfScalar(1.0)), NULL)),
                    mlfIndexRef(seg, "(?)", mlfColon(mlfScalar(1.0), N, NULL))),
                  mlfScalar(1.0))));
            /*
             * % Estimate for each state
             * for j=1:N
             */
            for (mclForStart(&iterator_1, mlfScalar(1.0), N, NULL);
                 mclForNext(&iterator_1, &j);
                 ) {
                /*
                 * mu(j,:) = mu(j,:) + sum(X(seg(j):seg(j+1),:));
                 */
                mlfIndexAssign(
                  &mu,
                  "(?,?)",
                  j,
                  mlfCreateColonIndex(),
                  mlfPlus(
                    mlfIndexRef(mu, "(?,?)", j, mlfCreateColonIndex()),
                    mlfSum(
                      mlfIndexRef(
                        X,
                        "(?,?)",
                        mlfColon(
                          mlfIndexRef(seg, "(?)", j),
                          mlfIndexRef(seg, "(?)", mlfPlus(j, mlfScalar(1.0))),
                          NULL),
                        mlfCreateColonIndex()),
                      NULL)));
                /*
                 * Sigma(j,:) = Sigma(j,:) + sum(X(seg(j):seg(j+1),:).^2);
                 */
                mlfIndexAssign(
                  Sigma,
                  "(?,?)",
                  j,
                  mlfCreateColonIndex(),
                  mlfPlus(
                    mlfIndexRef(*Sigma, "(?,?)", j, mlfCreateColonIndex()),
                    mlfSum(
                      mlfPower(
                        mlfIndexRef(
                          X,
                          "(?,?)",
                          mlfColon(
                            mlfIndexRef(seg, "(?)", j),
                            mlfIndexRef(seg, "(?)", mlfPlus(j, mlfScalar(1.0))),
                            NULL),
                          mlfCreateColonIndex()),
                        mlfScalar(2.0)),
                      NULL)));
            /*
             * end;
             */
            }
        /*
         * end;
         */
        }
        /*
         * % Normalization
         * mu = mu ./ (count' * ones(1,p));
         */
        mlfAssign(
          &mu,
          mlfRdivide(
            mu,
            mlfMtimes(mlfCtranspose(count), mlfOnes(mlfScalar(1.0), p, NULL))));
        /*
         * Sigma = Sigma ./ (count' * ones(1,p)) - mu.^2;
         */
        mlfAssign(
          Sigma,
          mlfMinus(
            mlfRdivide(
              *Sigma,
              mlfMtimes(
                mlfCtranspose(count), mlfOnes(mlfScalar(1.0), p, NULL))),
            mlfPower(mu, mlfScalar(2.0))));
    /*
     * else
     */
    } else {
        /*
         * % Initialization
         * Sigma = zeros(N*p,p);
         */
        mlfAssign(Sigma, mlfZeros(mlfMtimes(N, p), p, NULL));
        /*
         * for i=1:K
         */
        for (mclForStart(&iterator_0, mlfScalar(1.0), K, NULL);
             mclForNext(&iterator_0, &i);
             ) {
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
                 * last = st(i+1);
                 */
                mlfAssign(
                  &last, mlfIndexRef(st, "(?)", mlfPlus(i, mlfScalar(1.0))));
            /*
             * end;
             */
            }
            /*
             * % Uniform segmentation
             * seg = linspace(first, last, N+1);
             */
            mlfAssign(
              &seg, mlfLinspace(first, last, mlfPlus(N, mlfScalar(1.0))));
            /*
             * % Frame count
             * count = count + (seg(2:N+1)-seg(1:N)+1);
             */
            mlfAssign(
              &count,
              mlfPlus(
                count,
                mlfPlus(
                  mlfMinus(
                    mlfIndexRef(
                      seg,
                      "(?)",
                      mlfColon(
                        mlfScalar(2.0), mlfPlus(N, mlfScalar(1.0)), NULL)),
                    mlfIndexRef(seg, "(?)", mlfColon(mlfScalar(1.0), N, NULL))),
                  mlfScalar(1.0))));
            /*
             * % Estimate for each state
             * for j=1:N
             */
            for (mclForStart(&iterator_1, mlfScalar(1.0), N, NULL);
                 mclForNext(&iterator_1, &j);
                 ) {
                /*
                 * mu(j,:) = mu(j,:) + sum(X(seg(j):seg(j+1),:));
                 */
                mlfIndexAssign(
                  &mu,
                  "(?,?)",
                  j,
                  mlfCreateColonIndex(),
                  mlfPlus(
                    mlfIndexRef(mu, "(?,?)", j, mlfCreateColonIndex()),
                    mlfSum(
                      mlfIndexRef(
                        X,
                        "(?,?)",
                        mlfColon(
                          mlfIndexRef(seg, "(?)", j),
                          mlfIndexRef(seg, "(?)", mlfPlus(j, mlfScalar(1.0))),
                          NULL),
                        mlfCreateColonIndex()),
                      NULL)));
                /*
                 * Sigma(1+(j-1)*p:j*p,:) = Sigma(1+(j-1)*p:j*p,:)...
                 */
                mlfIndexAssign(
                  Sigma,
                  "(?,?)",
                  mlfColon(
                    mlfPlus(
                      mlfScalar(1.0),
                      mlfMtimes(mlfMinus(j, mlfScalar(1.0)), p)),
                    mlfMtimes(j, p),
                    NULL),
                  mlfCreateColonIndex(),
                  mlfPlus(
                    mlfIndexRef(
                      *Sigma,
                      "(?,?)",
                      mlfColon(
                        mlfPlus(
                          mlfScalar(1.0),
                          mlfMtimes(mlfMinus(j, mlfScalar(1.0)), p)),
                        mlfMtimes(j, p),
                        NULL),
                      mlfCreateColonIndex()),
                    mlfMtimes(
                      mlfCtranspose(
                        mlfIndexRef(
                          X,
                          "(?,?)",
                          mlfColon(
                            mlfIndexRef(seg, "(?)", j),
                            mlfIndexRef(seg, "(?)", mlfPlus(j, mlfScalar(1.0))),
                            NULL),
                          mlfCreateColonIndex())),
                      mlfIndexRef(
                        X,
                        "(?,?)",
                        mlfColon(
                          mlfIndexRef(seg, "(?)", j),
                          mlfIndexRef(seg, "(?)", mlfPlus(j, mlfScalar(1.0))),
                          NULL),
                        mlfCreateColonIndex()))));
            /*
             * + X(seg(j):seg(j+1),:)'*X(seg(j):seg(j+1),:);
             * end;
             */
            }
        /*
         * end;
         */
        }
        /*
         * % Normalization
         * mu = mu ./ (count' * ones(1,p));whos
         */
        mlfAssign(
          &mu,
          mlfRdivide(
            mu,
            mlfMtimes(mlfCtranspose(count), mlfOnes(mlfScalar(1.0), p, NULL))));
        mclPrintAns(&ans, mlfWhos(NULL));
        /*
         * for j = 1:N
         */
        for (mclForStart(&iterator_0, mlfScalar(1.0), N, NULL);
             mclForNext(&iterator_0, &j);
             ) {
            /*
             * Sigma(1+(j-1)*p:j*p,:) = Sigma(1+(j-1)*p:j*p,:) / count(j)...
             */
            mlfIndexAssign(
              Sigma,
              "(?,?)",
              mlfColon(
                mlfPlus(
                  mlfScalar(1.0), mlfMtimes(mlfMinus(j, mlfScalar(1.0)), p)),
                mlfMtimes(j, p),
                NULL),
              mlfCreateColonIndex(),
              mlfMinus(
                mlfMrdivide(
                  mlfIndexRef(
                    *Sigma,
                    "(?,?)",
                    mlfColon(
                      mlfPlus(
                        mlfScalar(1.0),
                        mlfMtimes(mlfMinus(j, mlfScalar(1.0)), p)),
                      mlfMtimes(j, p),
                      NULL),
                    mlfCreateColonIndex()),
                  mlfIndexRef(count, "(?)", j)),
                mlfMtimes(
                  mlfCtranspose(
                    mlfIndexRef(mu, "(?,?)", j, mlfCreateColonIndex())),
                  mlfIndexRef(mu, "(?,?)", j, mlfCreateColonIndex()))));
        /*
         * - mu(j,:)' * mu(j,:);
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
    mclValidateOutputs("hmm_mint", 2, nargout_, &mu, Sigma);
    mxDestroyArray(K);
    mxDestroyArray(KT);
    mxDestroyArray(QUIET);
    mxDestroyArray(ans);
    mxDestroyArray(count);
    mxDestroyArray(first);
    mxDestroyArray(i);
    mxDestroyArray(j);
    mxDestroyArray(last);
    mxDestroyArray(nargin_);
    mxDestroyArray(p);
    mxDestroyArray(seg);
    mxDestroyArray(time);
    return mu;
}

/*
 * The function "mlfHmm_mint" contains the normal interface for the "hmm_mint"
 * M-function from file "s:\matlab5\reco\toolboxes\pc\h2m\hmm_mint.m" (lines
 * 1-89). This function processes any input arguments and passes them to the
 * implementation version of the function, appearing above.
 */
mxArray * mlfHmm_mint(mxArray * * Sigma,
                      mxArray * X,
                      mxArray * st,
                      mxArray * N,
                      mxArray * DIAG_COV,
                      mxArray * QUIET) {
    int nargout = 1;
    mxArray * mu = mclGetUninitializedArray();
    mxArray * Sigma__ = mclGetUninitializedArray();
    mlfEnterNewContext(1, 5, Sigma, X, st, N, DIAG_COV, QUIET);
    if (Sigma != NULL) {
        ++nargout;
    }
    mu = Mhmm_mint(&Sigma__, nargout, X, st, N, DIAG_COV, QUIET);
    mlfRestorePreviousContext(1, 5, Sigma, X, st, N, DIAG_COV, QUIET);
    if (Sigma != NULL) {
        mclCopyOutputArg(Sigma, Sigma__);
    } else {
        mxDestroyArray(Sigma__);
    }
    return mlfReturnValue(mu);
}

/*
 * The function "mlxHmm_mint" contains the feval interface for the "hmm_mint"
 * M-function from file "s:\matlab5\reco\toolboxes\pc\h2m\hmm_mint.m" (lines
 * 1-89). The feval function calls the implementation version of hmm_mint
 * through this function. This function processes any input arguments and
 * passes them to the implementation version of the function, appearing above.
 */
void mlxHmm_mint(int nlhs, mxArray * plhs[], int nrhs, mxArray * prhs[]) {
    mxArray * mprhs[5];
    mxArray * mplhs[2];
    int i;
    if (nlhs > 2) {
        mlfError(
          mxCreateString(
            "Run-time Error: File: hmm_mint Line: 1 Column:"
            " 0 The function \"hmm_mint\" was called with m"
            "ore than the declared number of outputs (2)"));
    }
    if (nrhs > 5) {
        mlfError(
          mxCreateString(
            "Run-time Error: File: hmm_mint Line: 1 Column:"
            " 0 The function \"hmm_mint\" was called with m"
            "ore than the declared number of inputs (5)"));
    }
    for (i = 0; i < 2; ++i) {
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
      = Mhmm_mint(
          &mplhs[1], nlhs, mprhs[0], mprhs[1], mprhs[2], mprhs[3], mprhs[4]);
    mlfRestorePreviousContext(
      0, 5, mprhs[0], mprhs[1], mprhs[2], mprhs[3], mprhs[4]);
    plhs[0] = mplhs[0];
    for (i = 1; i < 2 && i < nlhs; ++i) {
        plhs[i] = mplhs[i];
    }
    for (; i < 2; ++i) {
        mxDestroyArray(mplhs[i]);
    }
}
