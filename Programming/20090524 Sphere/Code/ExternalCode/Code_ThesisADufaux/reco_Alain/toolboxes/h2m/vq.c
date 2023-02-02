/*
 * MATLAB Compiler: 2.0
 * Date: Fri Dec 10 17:55:10 1999
 * Arguments: "-x" "vq.m" 
 */
#include "vq.h"

/*
 * The function "Mvq" is the implementation version of the "vq" M-function from
 * file "s:\matlab5\reco\toolboxes\pc\h2m\vq.m" (lines 1-65). It contains the
 * actual compiled code for that M-function. It is a static function and must
 * only be called from one of the interface functions, appearing below.
 */
/*
 * function [CODE_n, label, dist] = vq(X, CODE, n_it, QUIET);
 */
static mxArray * Mvq(mxArray * * label,
                     mxArray * * dist,
                     int nargout_,
                     mxArray * X,
                     mxArray * CODE,
                     mxArray * n_it,
                     mxArray * QUIET) {
    mxArray * CODE_n = mclGetUninitializedArray();
    mxArray * DIST = mclGetUninitializedArray();
    mxArray * ans = mclInitializeAns();
    mxArray * i = mclGetUninitializedArray();
    mxArray * ind = mclGetUninitializedArray();
    mxArray * iter = mclGetUninitializedArray();
    mclForLoopIterator iterator_0;
    mclForLoopIterator iterator_1;
    mxArray * m = mclGetUninitializedArray();
    mxArray * n = mclGetUninitializedArray();
    mxArray * n_out = mclGetUninitializedArray();
    mxArray * nargin_ = mclGetUninitializedArray();
    mxArray * p = mclGetUninitializedArray();
    mxArray * vm = mclGetUninitializedArray();
    mlfAssign(&nargin_, mlfNargin(0, X, CODE, n_it, QUIET, NULL));
    mclValidateInputs("vq", 4, &X, &CODE, &n_it, &QUIET);
    mclCopyArray(&QUIET);
    /*
     * 
     * %vq        Vector quantization using the K-means (or LBG) algorithm.
     * %       Use: [CODE_n,label,dist] = vq(X,CODE,n_it)
     * %	Performs n_it iterations of the K-means algorithm on X, using
     * %	CODE as initial codebook.
     * 
     * % Version 1.3
     * % Olivier Cappé, 28/09/94 - 16/07/97
     * % ENST Dpt. Signal / CNRS URA 820, Paris
     * 
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
     * 
     * % Dimensions of X
     * [n,p] = size(X);
     */
    mlfSize(mlfVarargout(&n, &p, NULL), X, NULL);
    /*
     * % Codebook size
     * m  = length(CODE(:,1));
     */
    mlfAssign(
      &m,
      mlfLength(
        mlfIndexRef(CODE, "(?,?)", mlfCreateColonIndex(), mlfScalar(1.0))));
    /*
     * % Initialialize label array
     * label = zeros(1,n);
     */
    mlfAssign(label, mlfZeros(mlfScalar(1.0), n, NULL));
    /*
     * % As well as distortion values
     * dist = zeros(1,n_it);
     */
    mlfAssign(dist, mlfZeros(mlfScalar(1.0), n_it, NULL));
    /*
     * 
     * % Main loop
     * CODE_n = CODE;
     */
    mlfAssign(&CODE_n, CODE);
    /*
     * for iter = 1:n_it
     */
    for (mclForStart(&iterator_0, mlfScalar(1.0), n_it, NULL);
         mclForNext(&iterator_0, &iter);
         ) {
        /*
         * % 1. Find nearest neighbor for the squared distortion
         * DIST = zeros(m,n);
         */
        mlfAssign(&DIST, mlfZeros(m, n, NULL));
        /*
         * if (p > 1)
         */
        if (mlfTobool(mlfGt(p, mlfScalar(1.0)))) {
            /*
             * for i = 1:m
             */
            for (mclForStart(&iterator_1, mlfScalar(1.0), m, NULL);
                 mclForNext(&iterator_1, &i);
                 ) {
                /*
                 * DIST(i,:) = sum(((X - ones(n,1)*CODE_n(i,:))').^2);
                 */
                mlfIndexAssign(
                  &DIST,
                  "(?,?)",
                  i,
                  mlfCreateColonIndex(),
                  mlfSum(
                    mlfPower(
                      mlfCtranspose(
                        mlfMinus(
                          X,
                          mlfMtimes(
                            mlfOnes(n, mlfScalar(1.0), NULL),
                            mlfIndexRef(
                              CODE_n, "(?,?)", i, mlfCreateColonIndex())))),
                      mlfScalar(2.0)),
                    NULL));
            /*
             * end;
             */
            }
        /*
         * else
         */
        } else {
            /*
             * % Beware of sum when p = 1 (!)
             * DIST = (ones(m,1)*X' - CODE_n*ones(1,n)).^2;
             */
            mlfAssign(
              &DIST,
              mlfPower(
                mlfMinus(
                  mlfMtimes(mlfOnes(m, mlfScalar(1.0), NULL), mlfCtranspose(X)),
                  mlfMtimes(CODE_n, mlfOnes(mlfScalar(1.0), n, NULL))),
                mlfScalar(2.0)));
        /*
         * end;
         */
        }
        /*
         * [vm,label] = min(DIST);
         */
        mlfAssign(&vm, mlfMin(label, DIST, NULL, NULL));
        /*
         * % Mean distortion
         * dist(iter) = mean(vm);
         */
        mlfIndexAssign(dist, "(?)", iter, mlfMean(vm, NULL));
        /*
         * % 2. Update the codebook
         * n_out = 0;
         */
        mlfAssign(&n_out, mlfScalar(0.0));
        /*
         * for i = 1:m
         */
        for (mclForStart(&iterator_1, mlfScalar(1.0), m, NULL);
             mclForNext(&iterator_1, &i);
             ) {
            /*
             * ind = (1:n);
             */
            mlfAssign(&ind, mlfColon(mlfScalar(1.0), n, NULL));
            /*
             * ind = ind((label == i));
             */
            mlfAssign(&ind, mlfIndexRef(ind, "(?)", mlfEq(*label, i)));
            /*
             * if (length(ind) == 0)
             */
            if (mlfTobool(mlfEq(mlfLength(ind), mlfScalar(0.0)))) {
                /*
                 * % Isolated centroid are not modified
                 * n_out = n_out + 1;
                 */
                mlfAssign(&n_out, mlfPlus(n_out, mlfScalar(1.0)));
            /*
             * elseif (length(ind) == 1)
             */
            } else if (mlfTobool(mlfEq(mlfLength(ind), mlfScalar(1.0)))) {
                /*
                 * % When there is only one nearest neighbor for a given codebook entry
                 * CODE_n(i,:) = X(ind,:);
                 */
                mlfIndexAssign(
                  &CODE_n,
                  "(?,?)",
                  i,
                  mlfCreateColonIndex(),
                  mlfIndexRef(X, "(?,?)", ind, mlfCreateColonIndex()));
            /*
             * else
             */
            } else {
                /*
                 * CODE_n(i,:) = mean(X(ind,:));
                 */
                mlfIndexAssign(
                  &CODE_n,
                  "(?,?)",
                  i,
                  mlfCreateColonIndex(),
                  mlfMean(
                    mlfIndexRef(X, "(?,?)", ind, mlfCreateColonIndex()), NULL));
            /*
             * end;
             */
            }
        /*
         * end;
         */
        }
        /*
         * % Affichage
         * if (~QUIET)
         */
        if (mlfTobool(mlfNot(QUIET))) {
            /*
             * fprintf(1,'Iteration %d:\t%.3f\n',iter,dist(iter));
             */
            mclAssignAns(
              &ans,
              mlfFprintf(
                mlfScalar(1.0),
                mxCreateString("Iteration %d:\\t%.3f\\n"),
                iter,
                mlfIndexRef(*dist, "(?)", iter),
                NULL));
        /*
         * end;
         */
        }
        /*
         * if (n_out > 0)
         */
        if (mlfTobool(mlfGt(n_out, mlfScalar(0.0)))) {
            /*
             * fprintf(1,'  Warning : %.0f isolated centroids\n',n_out);
             */
            mclAssignAns(
              &ans,
              mlfFprintf(
                mlfScalar(1.0),
                mxCreateString("  Warning : %.0f isolated centroids\\n"),
                n_out,
                NULL));
        /*
         * end;
         */
        }
    /*
     * end;
     */
    }
    mclValidateOutputs("vq", 3, nargout_, &CODE_n, label, dist);
    mxDestroyArray(DIST);
    mxDestroyArray(QUIET);
    mxDestroyArray(ans);
    mxDestroyArray(i);
    mxDestroyArray(ind);
    mxDestroyArray(iter);
    mxDestroyArray(m);
    mxDestroyArray(n);
    mxDestroyArray(n_out);
    mxDestroyArray(nargin_);
    mxDestroyArray(p);
    mxDestroyArray(vm);
    return CODE_n;
}

/*
 * The function "mlfVq" contains the normal interface for the "vq" M-function
 * from file "s:\matlab5\reco\toolboxes\pc\h2m\vq.m" (lines 1-65). This
 * function processes any input arguments and passes them to the implementation
 * version of the function, appearing above.
 */
mxArray * mlfVq(mxArray * * label,
                mxArray * * dist,
                mxArray * X,
                mxArray * CODE,
                mxArray * n_it,
                mxArray * QUIET) {
    int nargout = 1;
    mxArray * CODE_n = mclGetUninitializedArray();
    mxArray * label__ = mclGetUninitializedArray();
    mxArray * dist__ = mclGetUninitializedArray();
    mlfEnterNewContext(2, 4, label, dist, X, CODE, n_it, QUIET);
    if (label != NULL) {
        ++nargout;
    }
    if (dist != NULL) {
        ++nargout;
    }
    CODE_n = Mvq(&label__, &dist__, nargout, X, CODE, n_it, QUIET);
    mlfRestorePreviousContext(2, 4, label, dist, X, CODE, n_it, QUIET);
    if (label != NULL) {
        mclCopyOutputArg(label, label__);
    } else {
        mxDestroyArray(label__);
    }
    if (dist != NULL) {
        mclCopyOutputArg(dist, dist__);
    } else {
        mxDestroyArray(dist__);
    }
    return mlfReturnValue(CODE_n);
}

/*
 * The function "mlxVq" contains the feval interface for the "vq" M-function
 * from file "s:\matlab5\reco\toolboxes\pc\h2m\vq.m" (lines 1-65). The feval
 * function calls the implementation version of vq through this function. This
 * function processes any input arguments and passes them to the implementation
 * version of the function, appearing above.
 */
void mlxVq(int nlhs, mxArray * plhs[], int nrhs, mxArray * prhs[]) {
    mxArray * mprhs[4];
    mxArray * mplhs[3];
    int i;
    if (nlhs > 3) {
        mlfError(
          mxCreateString(
            "Run-time Error: File: vq Line: 1 Column: 0 The function \"vq\" "
            "was called with more than the declared number of outputs (3)"));
    }
    if (nrhs > 4) {
        mlfError(
          mxCreateString(
            "Run-time Error: File: vq Line: 1 Column: 0 The function \"vq\" "
            "was called with more than the declared number of inputs (4)"));
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
      = Mvq(
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
