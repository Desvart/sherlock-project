/*
 * MATLAB Compiler: 2.0
 * Date: Fri Dec 10 17:50:53 1999
 * Arguments: "-x" "gauslogv.m" 
 */
#include "gauslogv.h"

/*
 * The function "Mgauslogv" is the implementation version of the "gauslogv"
 * M-function from file "s:\matlab5\reco\toolboxes\pc\h2m\gauslogv.m" (lines
 * 1-91). It contains the actual compiled code for that M-function. It is a
 * static function and must only be called from one of the interface functions,
 * appearing below.
 */
/*
 * function logdens = gauslogv(X, mu, Sigma, QUIET);
 */
static mxArray * Mgauslogv(int nargout_,
                           mxArray * X,
                           mxArray * mu,
                           mxArray * Sigma,
                           mxArray * QUIET) {
    mxArray * logdens = mclGetUninitializedArray();
    mxArray * DIAG_COV = mclGetUninitializedArray();
    mxArray * N = mclGetUninitializedArray();
    mxArray * Nc = mclGetUninitializedArray();
    mxArray * Nr = mclGetUninitializedArray();
    mxArray * Pr = mclGetUninitializedArray();
    mxArray * T = mclGetUninitializedArray();
    mxArray * ans = mclInitializeAns();
    mxArray * i = mclGetUninitializedArray();
    mclForLoopIterator iterator_0;
    mclForLoopIterator iterator_1;
    mxArray * j = mclGetUninitializedArray();
    mxArray * nargin_ = mclGetUninitializedArray();
    mxArray * nm = mclGetUninitializedArray();
    mxArray * p = mclGetUninitializedArray();
    mxArray * time = mclGetUninitializedArray();
    mlfAssign(&nargin_, mlfNargin(0, X, mu, Sigma, QUIET, NULL));
    mclValidateInputs("gauslogv", 4, &X, &mu, &Sigma, &QUIET);
    mclCopyArray(&QUIET);
    /*
     * 
     * %gauslogv  Computes a set of multivariate normal log-density values.
     * %	Use : logdens = gauslval(X, mu, Sigma) where
     * %	X (T,p)		T observed vectors of dimension p
     * %	mu (N,p)	N mean vectors
     * %	Sigma (N,p)	diagonals of the covariance matrices
     * %   or	Sigma (N,p*p)	Full covariance matrices
     * %	logdens (T,N)	Log-Prob. density for vector and each Gaussian dist.
     * 
     * % Version 1.3
     * % Olivier Cappé, 17/06/97 - 16/07/97
     * % ENST Dpt. Signal / CNRS URA 820, Paris
     * 
     * % Input arguments
     * error(nargchk(3, 4, nargin));
     */
    mlfError(mlfNargchk(mlfScalar(3.0), mlfScalar(4.0), nargin_));
    /*
     * if (nargin < 4)
     */
    if (mlfTobool(mlfLt(nargin_, mlfScalar(4.0)))) {
        /*
         * QUIET = 0;
         */
        mlfAssign(&QUIET, mlfScalar(0.0));
    /*
     * end;
     */
    }
    /*
     * % Dimension of the observations
     * [T, p] = size(X);
     */
    mlfSize(mlfVarargout(&T, &p, NULL), X, NULL);
    /*
     * % Check means of Gaussian densities
     * [N, Nc] = size(mu);
     */
    mlfSize(mlfVarargout(&N, &Nc, NULL), mu, NULL);
    /*
     * if (Nc ~= p)
     */
    if (mlfTobool(mlfNe(Nc, p))) {
        /*
         * error('Dimension of mean vectors is incorrect.');
         */
        mlfError(mxCreateString("Dimension of mean vectors is incorrect."));
    /*
     * end;
     */
    }
    /*
     * % Check covariance matrices
     * [Nr, Nc] = size(Sigma);
     */
    mlfSize(mlfVarargout(&Nr, &Nc, NULL), Sigma, NULL);
    /*
     * if (Nc ~= p)
     */
    if (mlfTobool(mlfNe(Nc, p))) {
        /*
         * error('The size of the covariance matrices is incorrect.');
         */
        mlfError(
          mxCreateString("The size of the covariance matrices is incorrect."));
    /*
     * end;
     */
    }
    /*
     * if (Nr == N)
     */
    if (mlfTobool(mlfEq(Nr, N))) {
        /*
         * DIAG_COV = 1;         % Also true when the dimension of the vector is 1
         */
        mlfAssign(&DIAG_COV, mlfScalar(1.0));
    /*
     * elseif (Nr == p*N)
     */
    } else if (mlfTobool(mlfEq(Nr, mlfMtimes(p, N)))) {
        /*
         * DIAG_COV = 0;
         */
        mlfAssign(&DIAG_COV, mlfScalar(0.0));
    /*
     * else
     */
    } else {
        /*
         * error('The size of the covariance matrices is incorrect.');
         */
        mlfError(
          mxCreateString("The size of the covariance matrices is incorrect."));
    /*
     * end;
     */
    }
    /*
     * 
     * % Compute density values
     * if (~QUIET)
     */
    if (mlfTobool(mlfNot(QUIET))) {
        /*
         * fprintf(1, 'Computing log-density values...'); time = cputime;
         */
        mclAssignAns(
          &ans,
          mlfFprintf(
            mlfScalar(1.0),
            mxCreateString("Computing log-density values..."), NULL));
        mlfAssign(&time, mlfCputime());
    /*
     * end;
     */
    }
    /*
     * logdens = zeros(T, N);
     */
    mlfAssign(&logdens, mlfZeros(T, N, NULL));
    /*
     * if (DIAG_COV)
     */
    if (mlfTobool(DIAG_COV)) {
        /*
         * if (p > 1)
         */
        if (mlfTobool(mlfGt(p, mlfScalar(1.0)))) {
            /*
             * nm = prod(Sigma');
             */
            mlfAssign(&nm, mlfProd(mlfCtranspose(Sigma), NULL));
        /*
         * else
         */
        } else {
            /*
             * % Beware of prod when the dimension of the vector is 1 (!)
             * nm = Sigma';
             */
            mlfAssign(&nm, mlfCtranspose(Sigma));
        /*
         * end;
         */
        }
        /*
         * if (any(nm < realmin))
         */
        if (mlfTobool(mlfAny(mlfLt(nm, mlfRealmin()), NULL))) {
            /*
             * error('Determinant is negative or zero.');
             */
            mlfError(mxCreateString("Determinant is negative or zero."));
        /*
         * else
         */
        } else {
            /*
             * %nm = 1 ./ sqrt((2*pi)^p * nm);
             * % Replace by the following line if you are using the MATLAB compiler
             * nm = 1 ./ realsqrt((2*pi)^p * nm);
             */
            mlfAssign(
              &nm,
              mlfRdivide(
                mlfScalar(1.0),
                mlfRealsqrt(
                  mlfMtimes(
                    mlfMpower(mlfMtimes(mlfScalar(2.0), mlfPi()), p), nm))));
        /*
         * end
         */
        }
        /*
         * for i=1:T
         */
        for (mclForStart(&iterator_0, mlfScalar(1.0), T, NULL);
             mclForNext(&iterator_0, &i);
             ) {
            /*
             * for j=1:N
             */
            for (mclForStart(&iterator_1, mlfScalar(1.0), N, NULL);
                 mclForNext(&iterator_1, &j);
                 ) {
                /*
                 * logdens(i,j) = sum((X(i,:)-mu(j,:)) .^2 ./ Sigma(j,:));
                 */
                mlfIndexAssign(
                  &logdens,
                  "(?,?)",
                  i,
                  j,
                  mlfSum(
                    mlfRdivide(
                      mlfPower(
                        mlfMinus(
                          mlfIndexRef(X, "(?,?)", i, mlfCreateColonIndex()),
                          mlfIndexRef(mu, "(?,?)", j, mlfCreateColonIndex())),
                        mlfScalar(2.0)),
                      mlfIndexRef(Sigma, "(?,?)", j, mlfCreateColonIndex())),
                    NULL));
            /*
             * end;
             */
            }
            /*
             * logdens(i,:) = log(nm) -0.5 * logdens(i,:);
             */
            mlfIndexAssign(
              &logdens,
              "(?,?)",
              i,
              mlfCreateColonIndex(),
              mlfMinus(
                mlfLog(nm),
                mlfMtimes(
                  mlfScalar(0.5),
                  mlfIndexRef(logdens, "(?,?)", i, mlfCreateColonIndex()))));
        /*
         * end;
         */
        }
    /*
     * else
     */
    } else {
        /*
         * Pr = zeros(size(Sigma));
         */
        mlfAssign(
          &Pr, mlfZeros(mlfSize(mclValueVarargout(), Sigma, NULL), NULL));
        /*
         * nm = zeros(1, N);
         */
        mlfAssign(&nm, mlfZeros(mlfScalar(1.0), N, NULL));
        /*
         * % Compute precision matrices and normalization constant once
         * for i=1:N
         */
        for (mclForStart(&iterator_0, mlfScalar(1.0), N, NULL);
             mclForNext(&iterator_0, &i);
             ) {
            /*
             * Pr((1+(i-1)*p):(i*p),:) = inv(Sigma((1+(i-1)*p):(i*p),:));
             */
            mlfIndexAssign(
              &Pr,
              "(?,?)",
              mlfColon(
                mlfPlus(
                  mlfScalar(1.0), mlfMtimes(mlfMinus(i, mlfScalar(1.0)), p)),
                mlfMtimes(i, p),
                NULL),
              mlfCreateColonIndex(),
              mlfInv(
                mlfIndexRef(
                  Sigma,
                  "(?,?)",
                  mlfColon(
                    mlfPlus(
                      mlfScalar(1.0),
                      mlfMtimes(mlfMinus(i, mlfScalar(1.0)), p)),
                    mlfMtimes(i, p),
                    NULL),
                  mlfCreateColonIndex())));
            /*
             * nm(i) = det(Sigma((1+(i-1)*p):(i*p),:));
             */
            mlfIndexAssign(
              &nm,
              "(?)",
              i,
              mlfDet(
                mlfIndexRef(
                  Sigma,
                  "(?,?)",
                  mlfColon(
                    mlfPlus(
                      mlfScalar(1.0),
                      mlfMtimes(mlfMinus(i, mlfScalar(1.0)), p)),
                    mlfMtimes(i, p),
                    NULL),
                  mlfCreateColonIndex())));
        /*
         * end;
         */
        }
        /*
         * if (any(nm < realmin))
         */
        if (mlfTobool(mlfAny(mlfLt(nm, mlfRealmin()), NULL))) {
            /*
             * error('Determinant is negative or zero.');
             */
            mlfError(mxCreateString("Determinant is negative or zero."));
        /*
         * else
         */
        } else {
            /*
             * %nm = 1 ./ sqrt((2*pi)^p * nm);
             * % Replace by the following line if you are using the MATLAB compiler
             * nm = 1 ./ realsqrt((2*pi)^p * nm);
             */
            mlfAssign(
              &nm,
              mlfRdivide(
                mlfScalar(1.0),
                mlfRealsqrt(
                  mlfMtimes(
                    mlfMpower(mlfMtimes(mlfScalar(2.0), mlfPi()), p), nm))));
        /*
         * end
         */
        }
        /*
         * % Compute values for all densities and all observations
         * for i=1:T
         */
        for (mclForStart(&iterator_0, mlfScalar(1.0), T, NULL);
             mclForNext(&iterator_0, &i);
             ) {
            /*
             * for j=1:N
             */
            for (mclForStart(&iterator_1, mlfScalar(1.0), N, NULL);
                 mclForNext(&iterator_1, &j);
                 ) {
                /*
                 * logdens(i,j) = (X(i,:)-mu(j,:)) * Pr((1+(j-1)*p):(j*p),:) * (X(i,:)-mu(j,:))';
                 */
                mlfIndexAssign(
                  &logdens,
                  "(?,?)",
                  i,
                  j,
                  mlfMtimes(
                    mlfMtimes(
                      mlfMinus(
                        mlfIndexRef(X, "(?,?)", i, mlfCreateColonIndex()),
                        mlfIndexRef(mu, "(?,?)", j, mlfCreateColonIndex())),
                      mlfIndexRef(
                        Pr,
                        "(?,?)",
                        mlfColon(
                          mlfPlus(
                            mlfScalar(1.0),
                            mlfMtimes(mlfMinus(j, mlfScalar(1.0)), p)),
                          mlfMtimes(j, p),
                          NULL),
                        mlfCreateColonIndex())),
                    mlfCtranspose(
                      mlfMinus(
                        mlfIndexRef(X, "(?,?)", i, mlfCreateColonIndex()),
                        mlfIndexRef(mu, "(?,?)", j, mlfCreateColonIndex())))));
            /*
             * end;
             */
            }
            /*
             * logdens(i,:) = log(nm) - 0.5 * logdens(i,:);
             */
            mlfIndexAssign(
              &logdens,
              "(?,?)",
              i,
              mlfCreateColonIndex(),
              mlfMinus(
                mlfLog(nm),
                mlfMtimes(
                  mlfScalar(0.5),
                  mlfIndexRef(logdens, "(?,?)", i, mlfCreateColonIndex()))));
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
    mclValidateOutputs("gauslogv", 1, nargout_, &logdens);
    mxDestroyArray(DIAG_COV);
    mxDestroyArray(N);
    mxDestroyArray(Nc);
    mxDestroyArray(Nr);
    mxDestroyArray(Pr);
    mxDestroyArray(QUIET);
    mxDestroyArray(T);
    mxDestroyArray(ans);
    mxDestroyArray(i);
    mxDestroyArray(j);
    mxDestroyArray(nargin_);
    mxDestroyArray(nm);
    mxDestroyArray(p);
    mxDestroyArray(time);
    return logdens;
}

/*
 * The function "mlfGauslogv" contains the normal interface for the "gauslogv"
 * M-function from file "s:\matlab5\reco\toolboxes\pc\h2m\gauslogv.m" (lines
 * 1-91). This function processes any input arguments and passes them to the
 * implementation version of the function, appearing above.
 */
mxArray * mlfGauslogv(mxArray * X,
                      mxArray * mu,
                      mxArray * Sigma,
                      mxArray * QUIET) {
    int nargout = 1;
    mxArray * logdens = mclGetUninitializedArray();
    mlfEnterNewContext(0, 4, X, mu, Sigma, QUIET);
    logdens = Mgauslogv(nargout, X, mu, Sigma, QUIET);
    mlfRestorePreviousContext(0, 4, X, mu, Sigma, QUIET);
    return mlfReturnValue(logdens);
}

/*
 * The function "mlxGauslogv" contains the feval interface for the "gauslogv"
 * M-function from file "s:\matlab5\reco\toolboxes\pc\h2m\gauslogv.m" (lines
 * 1-91). The feval function calls the implementation version of gauslogv
 * through this function. This function processes any input arguments and
 * passes them to the implementation version of the function, appearing above.
 */
void mlxGauslogv(int nlhs, mxArray * plhs[], int nrhs, mxArray * prhs[]) {
    mxArray * mprhs[4];
    mxArray * mplhs[1];
    int i;
    if (nlhs > 1) {
        mlfError(
          mxCreateString(
            "Run-time Error: File: gauslogv Line: 1 Column:"
            " 0 The function \"gauslogv\" was called with m"
            "ore than the declared number of outputs (1)"));
    }
    if (nrhs > 4) {
        mlfError(
          mxCreateString(
            "Run-time Error: File: gauslogv Line: 1 Column:"
            " 0 The function \"gauslogv\" was called with m"
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
    mplhs[0] = Mgauslogv(nlhs, mprhs[0], mprhs[1], mprhs[2], mprhs[3]);
    mlfRestorePreviousContext(0, 4, mprhs[0], mprhs[1], mprhs[2], mprhs[3]);
    plhs[0] = mplhs[0];
}
