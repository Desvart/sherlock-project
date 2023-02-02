/*
 * MATLAB Compiler: 2.0
 * Date: Fri Dec 10 17:54:51 1999
 * Arguments: "-x" "svq.m" 
 */
#include "svq.h"
#include "vq.h"

/*
 * The function "Msvq" is the implementation version of the "svq" M-function
 * from file "s:\matlab5\reco\toolboxes\pc\h2m\svq.m" (lines 1-46). It contains
 * the actual compiled code for that M-function. It is a static function and
 * must only be called from one of the interface functions, appearing below.
 */
/*
 * function [CODE, label, dist] = svq(X, lev, n_it);
 */
static mxArray * Msvq(mxArray * * label,
                      mxArray * * dist,
                      int nargout_,
                      mxArray * X,
                      mxArray * lev,
                      mxArray * n_it) {
    mxArray * CODE = mclGetUninitializedArray();
    mxArray * CODE_tmp = mclGetUninitializedArray();
    mxArray * QUIET = mclGetUninitializedArray();
    mxArray * ans = mclInitializeAns();
    mxArray * i = mclGetUninitializedArray();
    mclForLoopIterator iterator_0;
    mclForLoopIterator iterator_1;
    mxArray * j = mclGetUninitializedArray();
    mxArray * n = mclGetUninitializedArray();
    mxArray * nargin_ = mclGetUninitializedArray();
    mxArray * nbs = mclGetUninitializedArray();
    mxArray * p = mclGetUninitializedArray();
    mxArray * perturb = mclGetUninitializedArray();
    mxArray * vdist = mclGetUninitializedArray();
    mlfAssign(&nargin_, mlfNargin(0, X, lev, n_it, NULL));
    mclValidateInputs("svq", 3, &X, &lev, &n_it);
    mclCopyArray(&lev);
    /*
     * 
     * %svq	  Vector quantization using successive binary splitting steps.
     * %	Use: [CODE,label,dist] = svq(X,lev,n_it).
     * %	The final codebook dimension lev should be a power of two. dist
     * %	returns the distorsion values at the end of intermediate step.
     * %	n_it is the number of iterations performed in each step.
     * 
     * % Version 1.3
     * % Olivier Cappé, 28/09/94 - 04/03/97
     * % ENST Dpt. Signal / CNRS URA 820, Paris
     * 
     * % Needed functions
     * if (exist('vq') ~= 2)
     */
    if (mlfTobool(
          mlfNe(mlfExist(mxCreateString("vq"), NULL), mlfScalar(2.0)))) {
        /*
         * error('Function vq is missing.');
         */
        mlfError(mxCreateString("Function vq is missing."));
    /*
     * end;
     */
    }
    /*
     * % Turn verbose mode off
     * QUIET = 1;
     */
    mlfAssign(&QUIET, mlfScalar(1.0));
    /*
     * % Input agruments
     * error(nargchk(3, 3, nargin));
     */
    mlfError(mlfNargchk(mlfScalar(3.0), mlfScalar(3.0), nargin_));
    /*
     * % Dimension of imput data
     * [n,p] = size(X);
     */
    mlfSize(mlfVarargout(&n, &p, NULL), X, NULL);
    /*
     * % Number of spliting steps
     * nbs = round(log2(lev));
     */
    mlfAssign(&nbs, mlfRound(mlfLog2(NULL, lev)));
    /*
     * lev = 2^nbs;
     */
    mlfAssign(&lev, mlfMpower(mlfScalar(2.0), nbs));
    /*
     * % Fixed perturbation
     * perturb = 0.01;
     */
    mlfAssign(&perturb, mlfScalar(0.01));
    /*
     * 
     * % Initialize first centroid with global mean
     * CODE = zeros(lev, p);
     */
    mlfAssign(&CODE, mlfZeros(lev, p, NULL));
    /*
     * CODE_tmp = zeros(lev, p);
     */
    mlfAssign(&CODE_tmp, mlfZeros(lev, p, NULL));
    /*
     * CODE(1,:) = mean(X);
     */
    mlfIndexAssign(
      &CODE, "(?,?)", mlfScalar(1.0), mlfCreateColonIndex(), mlfMean(X, NULL));
    /*
     * label = ones(n,1);
     */
    mlfAssign(label, mlfOnes(n, mlfScalar(1.0), NULL));
    /*
     * 
     * for i=1:nbs
     */
    for (mclForStart(&iterator_0, mlfScalar(1.0), nbs, NULL);
         mclForNext(&iterator_0, &i);
         ) {
        /*
         * % 1. Codebook splitting
         * for j=1:(2^(i-1))
         */
        for (mclForStart(
               &iterator_1,
               mlfScalar(1.0),
               mlfMpower(mlfScalar(2.0), mlfMinus(i, mlfScalar(1.0))),
               NULL);
             mclForNext(&iterator_1, &j);
             ) {
            /*
             * CODE_tmp(2*j-1,:) = (1+perturb) * CODE(j,:);
             */
            mlfIndexAssign(
              &CODE_tmp,
              "(?,?)",
              mlfMinus(mlfMtimes(mlfScalar(2.0), j), mlfScalar(1.0)),
              mlfCreateColonIndex(),
              mlfMtimes(
                mlfPlus(mlfScalar(1.0), perturb),
                mlfIndexRef(CODE, "(?,?)", j, mlfCreateColonIndex())));
            /*
             * CODE_tmp(2*j,:)   = (1-perturb) * CODE(j,:);
             */
            mlfIndexAssign(
              &CODE_tmp,
              "(?,?)",
              mlfMtimes(mlfScalar(2.0), j),
              mlfCreateColonIndex(),
              mlfMtimes(
                mlfMinus(mlfScalar(1.0), perturb),
                mlfIndexRef(CODE, "(?,?)", j, mlfCreateColonIndex())));
        /*
         * end;
         */
        }
        /*
         * % 2. K-means optimization
         * [CODE(1:2^i,:),label,vdist] = vq(X,CODE_tmp(1:2^i,:),n_it,QUIET);
         */
        mlfFeval(
          mlfIndexVarargout(
            &CODE,
            "(?,?)",
            mlfColon(mlfScalar(1.0), mlfMpower(mlfScalar(2.0), i), NULL),
            mlfCreateColonIndex(),
            label, "",
            &vdist, "",
            NULL),
          mlxVq,
          X,
          mlfIndexRef(
            CODE_tmp,
            "(?,?)",
            mlfColon(mlfScalar(1.0), mlfMpower(mlfScalar(2.0), i), NULL),
            mlfCreateColonIndex()),
          n_it,
          QUIET,
          NULL);
        /*
         * dist(i) = vdist(n_it);
         */
        mlfIndexAssign(dist, "(?)", i, mlfIndexRef(vdist, "(?)", n_it));
        /*
         * fprintf(1, 'Codebook size %d:\t%.3f\n',2^i,dist(i));
         */
        mclAssignAns(
          &ans,
          mlfFprintf(
            mlfScalar(1.0),
            mxCreateString("Codebook size %d:\\t%.3f\\n"),
            mlfMpower(mlfScalar(2.0), i),
            mlfIndexRef(*dist, "(?)", i),
            NULL));
    /*
     * end;
     */
    }
    mclValidateOutputs("svq", 3, nargout_, &CODE, label, dist);
    mxDestroyArray(CODE_tmp);
    mxDestroyArray(QUIET);
    mxDestroyArray(ans);
    mxDestroyArray(i);
    mxDestroyArray(j);
    mxDestroyArray(lev);
    mxDestroyArray(n);
    mxDestroyArray(nargin_);
    mxDestroyArray(nbs);
    mxDestroyArray(p);
    mxDestroyArray(perturb);
    mxDestroyArray(vdist);
    return CODE;
}

/*
 * The function "mlfSvq" contains the normal interface for the "svq" M-function
 * from file "s:\matlab5\reco\toolboxes\pc\h2m\svq.m" (lines 1-46). This
 * function processes any input arguments and passes them to the implementation
 * version of the function, appearing above.
 */
mxArray * mlfSvq(mxArray * * label,
                 mxArray * * dist,
                 mxArray * X,
                 mxArray * lev,
                 mxArray * n_it) {
    int nargout = 1;
    mxArray * CODE = mclGetUninitializedArray();
    mxArray * label__ = mclGetUninitializedArray();
    mxArray * dist__ = mclGetUninitializedArray();
    mlfEnterNewContext(2, 3, label, dist, X, lev, n_it);
    if (label != NULL) {
        ++nargout;
    }
    if (dist != NULL) {
        ++nargout;
    }
    CODE = Msvq(&label__, &dist__, nargout, X, lev, n_it);
    mlfRestorePreviousContext(2, 3, label, dist, X, lev, n_it);
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
    return mlfReturnValue(CODE);
}

/*
 * The function "mlxSvq" contains the feval interface for the "svq" M-function
 * from file "s:\matlab5\reco\toolboxes\pc\h2m\svq.m" (lines 1-46). The feval
 * function calls the implementation version of svq through this function. This
 * function processes any input arguments and passes them to the implementation
 * version of the function, appearing above.
 */
void mlxSvq(int nlhs, mxArray * plhs[], int nrhs, mxArray * prhs[]) {
    mxArray * mprhs[3];
    mxArray * mplhs[3];
    int i;
    if (nlhs > 3) {
        mlfError(
          mxCreateString(
            "Run-time Error: File: svq Line: 1 Column: 0 The function \"svq\""
            " was called with more than the declared number of outputs (3)"));
    }
    if (nrhs > 3) {
        mlfError(
          mxCreateString(
            "Run-time Error: File: svq Line: 1 Column: 0 The function \"svq\""
            " was called with more than the declared number of inputs (3)"));
    }
    for (i = 0; i < 3; ++i) {
        mplhs[i] = NULL;
    }
    for (i = 0; i < 3 && i < nrhs; ++i) {
        mprhs[i] = prhs[i];
    }
    for (; i < 3; ++i) {
        mprhs[i] = NULL;
    }
    mlfEnterNewContext(0, 3, mprhs[0], mprhs[1], mprhs[2]);
    mplhs[0] = Msvq(&mplhs[1], &mplhs[2], nlhs, mprhs[0], mprhs[1], mprhs[2]);
    mlfRestorePreviousContext(0, 3, mprhs[0], mprhs[1], mprhs[2]);
    plhs[0] = mplhs[0];
    for (i = 1; i < 3 && i < nlhs; ++i) {
        plhs[i] = mplhs[i];
    }
    for (; i < 3; ++i) {
        mxDestroyArray(mplhs[i]);
    }
}
