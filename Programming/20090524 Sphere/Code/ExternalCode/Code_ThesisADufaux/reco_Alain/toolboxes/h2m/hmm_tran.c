/*
 * MATLAB Compiler: 2.0
 * Date: Fri Dec 10 17:54:00 1999
 * Arguments: "-x" "hmm_tran.m" 
 */
#include "hmm_tran.h"

/*
 * The function "Mhmm_tran" is the implementation version of the "hmm_tran"
 * M-function from file "s:\matlab5\reco\toolboxes\pc\h2m\hmm_tran.m" (lines
 * 1-56). It contains the actual compiled code for that M-function. It is a
 * static function and must only be called from one of the interface functions,
 * appearing below.
 */
/*
 * function [A_, pi0_] = hmm_tran (alpha, beta, dens, A, pi0, QUIET);
 */
static mxArray * Mhmm_tran(mxArray * * pi0_,
                           int nargout_,
                           mxArray * alpha,
                           mxArray * beta,
                           mxArray * dens,
                           mxArray * A,
                           mxArray * pi0,
                           mxArray * QUIET) {
    mxArray * A_ = mclGetUninitializedArray();
    mxArray * N = mclGetUninitializedArray();
    mxArray * T = mclGetUninitializedArray();
    mxArray * ans = mclInitializeAns();
    mxArray * i = mclGetUninitializedArray();
    mxArray * ind = mclGetUninitializedArray();
    mclForLoopIterator iterator_0;
    mxArray * nargin_ = mclGetUninitializedArray();
    mxArray * num = mclGetUninitializedArray();
    mxArray * time = mclGetUninitializedArray();
    mlfAssign(&nargin_, mlfNargin(0, alpha, beta, dens, A, pi0, QUIET, NULL));
    mclValidateInputs("hmm_tran", 6, &alpha, &beta, &dens, &A, &pi0, &QUIET);
    mclCopyArray(&QUIET);
    /*
     * 
     * %hmm_tran  Reestimation the transition part of an HMM.
     * %	Use : [A_,pi0_] = hmm_tran(alpha,beta,dens,A,pi0). If A and
     * %	piO are sparse, the output estimates are also sparse (and
     * %	only the relevant values are reestimated).
     * 
     * % Version 1.3
     * % Olivier Cappé, 12/03/96 - 17/03/97
     * % ENST Dpt. Signal / CNRS URA 820, Paris
     * 
     * % Dimensions (without checking A and pi0)
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
     * if ((size(alpha) ~= size(beta)) | (size(alpha) ~= size(dens)))
     */
    {
        mxArray * a_ = mclInitialize(
                         mlfNe(
                           mlfSize(mclValueVarargout(), alpha, NULL),
                           mlfSize(mclValueVarargout(), beta, NULL)));
        if (mlfTobool(a_)
            || mlfTobool(
                 mlfOr(
                   a_,
                   mlfNe(
                     mlfSize(mclValueVarargout(), alpha, NULL),
                     mlfSize(mclValueVarargout(), dens, NULL))))) {
            mxDestroyArray(a_);
            /*
             * error('First three matrices should have the same size.');
             */
            mlfError(
              mxCreateString(
                "First three matrices should have the same size."));
        } else {
            mxDestroyArray(a_);
        }
    /*
     * end;
     */
    }
    /*
     * [T, N] = size(alpha);
     */
    mlfSize(mlfVarargout(&T, &N, NULL), alpha, NULL);
    /*
     * 
     * % Initial probabilities
     * if (~QUIET)
     */
    if (mlfTobool(mlfNot(QUIET))) {
        /*
         * fprintf(1, 'Reestimating transition parameters...'); time = cputime;
         */
        mclAssignAns(
          &ans,
          mlfFprintf(
            mlfScalar(1.0),
            mxCreateString("Reestimating transition parameters..."), NULL));
        mlfAssign(&time, mlfCputime());
    /*
     * end;
     */
    }
    /*
     * if (issparse(pi0))
     */
    if (mlfTobool(mlfIssparse(pi0))) {
        /*
         * ind = find(pi0);
         */
        mlfAssign(&ind, mlfFind(NULL, NULL, pi0));
        /*
         * pi0_ = sparse(zeros(1,N));
         */
        mlfAssign(
          pi0_,
          mlfSparse(
            mlfZeros(mlfScalar(1.0), N, NULL), NULL, NULL, NULL, NULL, NULL));
        /*
         * pi0_(ind) = alpha(1,ind) .* beta(1,ind) / sum(alpha(1,ind) .* beta(1,ind));
         */
        mlfIndexAssign(
          pi0_,
          "(?)",
          ind,
          mlfMrdivide(
            mlfTimes(
              mlfIndexRef(alpha, "(?,?)", mlfScalar(1.0), ind),
              mlfIndexRef(beta, "(?,?)", mlfScalar(1.0), ind)),
            mlfSum(
              mlfTimes(
                mlfIndexRef(alpha, "(?,?)", mlfScalar(1.0), ind),
                mlfIndexRef(beta, "(?,?)", mlfScalar(1.0), ind)),
              NULL)));
    /*
     * else
     */
    } else {
        /*
         * pi0_ = alpha(1,:) .* beta(1,:) / sum(alpha(1,:) .* beta(1,:));
         */
        mlfAssign(
          pi0_,
          mlfMrdivide(
            mlfTimes(
              mlfIndexRef(
                alpha, "(?,?)", mlfScalar(1.0), mlfCreateColonIndex()),
              mlfIndexRef(
                beta, "(?,?)", mlfScalar(1.0), mlfCreateColonIndex())),
            mlfSum(
              mlfTimes(
                mlfIndexRef(
                  alpha, "(?,?)", mlfScalar(1.0), mlfCreateColonIndex()),
                mlfIndexRef(
                  beta, "(?,?)", mlfScalar(1.0), mlfCreateColonIndex())),
              NULL)));
    /*
     * end;
     */
    }
    /*
     * 
     * % Transition matrix
     * if (issparse(A))
     */
    if (mlfTobool(mlfIssparse(A))) {
        /*
         * A_ = sparse(zeros(size(A)));
         */
        mlfAssign(
          &A_,
          mlfSparse(
            mlfZeros(mlfSize(mclValueVarargout(), A, NULL), NULL),
            NULL,
            NULL,
            NULL,
            NULL,
            NULL));
        /*
         * for i=1:N
         */
        for (mclForStart(&iterator_0, mlfScalar(1.0), N, NULL);
             mclForNext(&iterator_0, &i);
             ) {
            /*
             * ind = find(A(i,:));
             */
            mlfAssign(
              &ind,
              mlfFind(
                NULL, NULL, mlfIndexRef(A, "(?,?)", i, mlfCreateColonIndex())));
            /*
             * num = (alpha(1:(T-1),i) * ones(1,length(ind))) .* dens(2:T,ind) .* beta(2:T,ind);
             */
            mlfAssign(
              &num,
              mlfTimes(
                mlfTimes(
                  mlfMtimes(
                    mlfIndexRef(
                      alpha,
                      "(?,?)",
                      mlfColon(
                        mlfScalar(1.0), mlfMinus(T, mlfScalar(1.0)), NULL),
                      i),
                    mlfOnes(mlfScalar(1.0), mlfLength(ind), NULL)),
                  mlfIndexRef(
                    dens, "(?,?)", mlfColon(mlfScalar(2.0), T, NULL), ind)),
                mlfIndexRef(
                  beta, "(?,?)", mlfColon(mlfScalar(2.0), T, NULL), ind)));
            /*
             * A_(i,ind) = A(i,ind) .* sum(num);
             */
            mlfIndexAssign(
              &A_,
              "(?,?)",
              i,
              ind,
              mlfTimes(mlfIndexRef(A, "(?,?)", i, ind), mlfSum(num, NULL)));
            /*
             * A_(i,ind) = A_(i,ind) / sum(A_(i,ind));
             */
            mlfIndexAssign(
              &A_,
              "(?,?)",
              i,
              ind,
              mlfMrdivide(
                mlfIndexRef(A_, "(?,?)", i, ind),
                mlfSum(mlfIndexRef(A_, "(?,?)", i, ind), NULL)));
        /*
         * end;
         */
        }
    /*
     * else
     */
    } else {
        /*
         * A_ = zeros(size(A));
         */
        mlfAssign(&A_, mlfZeros(mlfSize(mclValueVarargout(), A, NULL), NULL));
        /*
         * for i=1:N
         */
        for (mclForStart(&iterator_0, mlfScalar(1.0), N, NULL);
             mclForNext(&iterator_0, &i);
             ) {
            /*
             * % Compute unnormalized transition probabilities
             * num = (alpha(1:(T-1),i) * ones(1,N)) .* dens(2:T,:) .* beta(2:T,:);
             */
            mlfAssign(
              &num,
              mlfTimes(
                mlfTimes(
                  mlfMtimes(
                    mlfIndexRef(
                      alpha,
                      "(?,?)",
                      mlfColon(
                        mlfScalar(1.0), mlfMinus(T, mlfScalar(1.0)), NULL),
                      i),
                    mlfOnes(mlfScalar(1.0), N, NULL)),
                  mlfIndexRef(
                    dens,
                    "(?,?)",
                    mlfColon(mlfScalar(2.0), T, NULL),
                    mlfCreateColonIndex())),
                mlfIndexRef(
                  beta,
                  "(?,?)",
                  mlfColon(mlfScalar(2.0), T, NULL),
                  mlfCreateColonIndex())));
            /*
             * A_(i,:) = A(i,:) .* sum(num);
             */
            mlfIndexAssign(
              &A_,
              "(?,?)",
              i,
              mlfCreateColonIndex(),
              mlfTimes(
                mlfIndexRef(A, "(?,?)", i, mlfCreateColonIndex()),
                mlfSum(num, NULL)));
            /*
             * % Normalization
             * A_(i,:) = A_(i,:) / sum(A_(i,:));
             */
            mlfIndexAssign(
              &A_,
              "(?,?)",
              i,
              mlfCreateColonIndex(),
              mlfMrdivide(
                mlfIndexRef(A_, "(?,?)", i, mlfCreateColonIndex()),
                mlfSum(
                  mlfIndexRef(A_, "(?,?)", i, mlfCreateColonIndex()), NULL)));
        /*
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
    mclValidateOutputs("hmm_tran", 2, nargout_, &A_, pi0_);
    mxDestroyArray(N);
    mxDestroyArray(QUIET);
    mxDestroyArray(T);
    mxDestroyArray(ans);
    mxDestroyArray(i);
    mxDestroyArray(ind);
    mxDestroyArray(nargin_);
    mxDestroyArray(num);
    mxDestroyArray(time);
    return A_;
}

/*
 * The function "mlfHmm_tran" contains the normal interface for the "hmm_tran"
 * M-function from file "s:\matlab5\reco\toolboxes\pc\h2m\hmm_tran.m" (lines
 * 1-56). This function processes any input arguments and passes them to the
 * implementation version of the function, appearing above.
 */
mxArray * mlfHmm_tran(mxArray * * pi0_,
                      mxArray * alpha,
                      mxArray * beta,
                      mxArray * dens,
                      mxArray * A,
                      mxArray * pi0,
                      mxArray * QUIET) {
    int nargout = 1;
    mxArray * A_ = mclGetUninitializedArray();
    mxArray * pi0___ = mclGetUninitializedArray();
    mlfEnterNewContext(1, 6, pi0_, alpha, beta, dens, A, pi0, QUIET);
    if (pi0_ != NULL) {
        ++nargout;
    }
    A_ = Mhmm_tran(&pi0___, nargout, alpha, beta, dens, A, pi0, QUIET);
    mlfRestorePreviousContext(1, 6, pi0_, alpha, beta, dens, A, pi0, QUIET);
    if (pi0_ != NULL) {
        mclCopyOutputArg(pi0_, pi0___);
    } else {
        mxDestroyArray(pi0___);
    }
    return mlfReturnValue(A_);
}

/*
 * The function "mlxHmm_tran" contains the feval interface for the "hmm_tran"
 * M-function from file "s:\matlab5\reco\toolboxes\pc\h2m\hmm_tran.m" (lines
 * 1-56). The feval function calls the implementation version of hmm_tran
 * through this function. This function processes any input arguments and
 * passes them to the implementation version of the function, appearing above.
 */
void mlxHmm_tran(int nlhs, mxArray * plhs[], int nrhs, mxArray * prhs[]) {
    mxArray * mprhs[6];
    mxArray * mplhs[2];
    int i;
    if (nlhs > 2) {
        mlfError(
          mxCreateString(
            "Run-time Error: File: hmm_tran Line: 1 Column:"
            " 0 The function \"hmm_tran\" was called with m"
            "ore than the declared number of outputs (2)"));
    }
    if (nrhs > 6) {
        mlfError(
          mxCreateString(
            "Run-time Error: File: hmm_tran Line: 1 Column:"
            " 0 The function \"hmm_tran\" was called with m"
            "ore than the declared number of inputs (6)"));
    }
    for (i = 0; i < 2; ++i) {
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
      = Mhmm_tran(
          &mplhs[1],
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
    for (i = 1; i < 2 && i < nlhs; ++i) {
        plhs[i] = mplhs[i];
    }
    for (; i < 2; ++i) {
        mxDestroyArray(mplhs[i]);
    }
}
