/*
 * MATLAB Compiler: 2.0
 * Date: Fri Dec 10 17:50:07 1999
 * Arguments: "-x" "mix_post.m" 
 */
#include "mix_post.h"
#include "gauseval.h"
#include "mix_chk.h"

/*
 * The function "Mmix_post" is the implementation version of the "mix_post"
 * M-function from file "s:\matlab5\reco\toolboxes\pc\h2m\mix_post.m" (lines
 * 1-52). It contains the actual compiled code for that M-function. It is a
 * static function and must only be called from one of the interface functions,
 * appearing below.
 */
/*
 * function [gamma, logl, framelogl] = mix_post (X, w, mu, Sigma, QUIET);
 */
static mxArray * Mmix_post(mxArray * * logl,
                           mxArray * * framelogl,
                           int nargout_,
                           mxArray * X,
                           mxArray * w,
                           mxArray * mu,
                           mxArray * Sigma,
                           mxArray * QUIET) {
    mxArray * gamma = mclGetUninitializedArray();
    mxArray * DIAG_COV = mclGetUninitializedArray();
    mxArray * EPSILON = mclGetUninitializedArray();
    mxArray * N = mclGetUninitializedArray();
    mxArray * Nc = mclGetUninitializedArray();
    mxArray * T = mclGetUninitializedArray();
    mxArray * ans = mclInitializeAns();
    mclForLoopIterator iterator_0;
    mxArray * l = mclGetUninitializedArray();
    mxArray * leng = mclGetUninitializedArray();
    mxArray * nargin_ = mclGetUninitializedArray();
    mxArray * nargout = mclInitialize(mlfScalar(nargout_));
    mxArray * p = mclGetUninitializedArray();
    mxArray * time = mclGetUninitializedArray();
    mlfAssign(&nargin_, mlfNargin(0, X, w, mu, Sigma, QUIET, NULL));
    mclValidateInputs("mix_post", 5, &X, &w, &mu, &Sigma, &QUIET);
    mclCopyArray(&QUIET);
    /*
     * 
     * %mix_post  A posteriori probabilities for a gaussian mixture model.
     * %	Use: [gamma,logl] = mix_post (X,w,mu,Sigma) returns the a posteriori
     * %	probabilities. logl is the log-likehood of X.
     * 
     * % Version 1.3
     * % Olivier Cappé, 1995 - 06/06/97
     * % ENST Dpt. Signal / CNRS URA 820, Paris
     * 
     * %LB
     * EPSILON=1e-50;
     */
    mlfAssign(&EPSILON, mlfScalar(1e-50));
    /*
     * 
     * % Input args.
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
     * [N, p, DIAG_COV] = mix_chk(w, mu, Sigma);
     */
    mlfAssign(&N, mlfMix_chk(&p, &DIAG_COV, w, mu, Sigma));
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
     * gamma = gauseval(X, mu, Sigma, QUIET);
     */
    mlfAssign(&gamma, mlfGauseval(X, mu, Sigma, QUIET));
    /*
     * 
     * % A posteriori probabilities
     * if (~QUIET)
     */
    if (mlfTobool(mlfNot(QUIET))) {
        /*
         * fprintf(1, 'Computing a posteriori probabilities...'); time = cputime;
         */
        mclAssignAns(
          &ans,
          mlfFprintf(
            mlfScalar(1.0),
            mxCreateString("Computing a posteriori probabilities..."), NULL));
        mlfAssign(&time, mlfCputime());
    /*
     * end;
     */
    }
    /*
     * gamma = gamma .* (ones(T,1) * w);
     */
    mlfAssign(
      &gamma, mlfTimes(gamma, mlfMtimes(mlfOnes(T, mlfScalar(1.0), NULL), w)));
    /*
     * if (nargout > 1)
     */
    if (mlfTobool(mlfGt(nargout, mlfScalar(1.0)))) {
        /*
         * %Compute Log-Likelihood - TEST LB if sum(gamma')==0 then sum gamma'=EPSILON - SLOWER BUT SAFER
         * framelogl=sum(gamma');
         */
        mlfAssign(framelogl, mlfSum(mlfCtranspose(gamma), NULL));
        /*
         * leng=size(framelogl,2);
         */
        mlfAssign(
          &leng, mlfSize(mclValueVarargout(), *framelogl, mlfScalar(2.0)));
        /*
         * for l=1:leng
         */
        for (mclForStart(&iterator_0, mlfScalar(1.0), leng, NULL);
             mclForNext(&iterator_0, &l);
             ) {
            /*
             * if framelogl(1,l)==0
             */
            if (mlfTobool(
                  mlfEq(
                    mlfIndexRef(*framelogl, "(?,?)", mlfScalar(1.0), l),
                    mlfScalar(0.0)))) {
                /*
                 * framelogl(1,l)=EPSILON;
                 */
                mlfIndexAssign(framelogl, "(?,?)", mlfScalar(1.0), l, EPSILON);
            /*
             * end;
             */
            }
        /*
         * end;
         */
        }
        /*
         * logl = sum(log(framelogl));
         */
        mlfAssign(logl, mlfSum(mlfLog(*framelogl), NULL));
    /*
     * % Compute log-likelihood
     * %logl = sum(log(sum(gamma')));
     * end;
     */
    }
    /*
     * %LB
     * gamma = gamma ./ (framelogl' * ones(1,N));
     */
    mlfAssign(
      &gamma,
      mlfRdivide(
        gamma,
        mlfMtimes(
          mlfCtranspose(*framelogl), mlfOnes(mlfScalar(1.0), N, NULL))));
    /*
     * %gamma = gamma ./ ((sum(gamma'))' * ones(1,N));
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
    mclValidateOutputs("mix_post", 3, nargout_, &gamma, logl, framelogl);
    mxDestroyArray(DIAG_COV);
    mxDestroyArray(EPSILON);
    mxDestroyArray(N);
    mxDestroyArray(Nc);
    mxDestroyArray(QUIET);
    mxDestroyArray(T);
    mxDestroyArray(ans);
    mxDestroyArray(l);
    mxDestroyArray(leng);
    mxDestroyArray(nargin_);
    mxDestroyArray(nargout);
    mxDestroyArray(p);
    mxDestroyArray(time);
    return gamma;
}

/*
 * The function "mlfNMix_post" contains the nargout interface for the
 * "mix_post" M-function from file
 * "s:\matlab5\reco\toolboxes\pc\h2m\mix_post.m" (lines 1-52). This interface
 * is only produced if the M-function uses the special variable "nargout". The
 * nargout interface allows the number of requested outputs to be specified via
 * the nargout argument, as opposed to the normal interface which dynamically
 * calculates the number of outputs based on the number of non-NULL inputs it
 * receives. This function processes any input arguments and passes them to the
 * implementation version of the function, appearing above.
 */
mxArray * mlfNMix_post(int nargout,
                       mxArray * * logl,
                       mxArray * * framelogl,
                       mxArray * X,
                       mxArray * w,
                       mxArray * mu,
                       mxArray * Sigma,
                       mxArray * QUIET) {
    mxArray * gamma = mclGetUninitializedArray();
    mxArray * logl__ = mclGetUninitializedArray();
    mxArray * framelogl__ = mclGetUninitializedArray();
    mlfEnterNewContext(2, 5, logl, framelogl, X, w, mu, Sigma, QUIET);
    gamma = Mmix_post(&logl__, &framelogl__, nargout, X, w, mu, Sigma, QUIET);
    mlfRestorePreviousContext(2, 5, logl, framelogl, X, w, mu, Sigma, QUIET);
    if (logl != NULL) {
        mclCopyOutputArg(logl, logl__);
    } else {
        mxDestroyArray(logl__);
    }
    if (framelogl != NULL) {
        mclCopyOutputArg(framelogl, framelogl__);
    } else {
        mxDestroyArray(framelogl__);
    }
    return mlfReturnValue(gamma);
}

/*
 * The function "mlfMix_post" contains the normal interface for the "mix_post"
 * M-function from file "s:\matlab5\reco\toolboxes\pc\h2m\mix_post.m" (lines
 * 1-52). This function processes any input arguments and passes them to the
 * implementation version of the function, appearing above.
 */
mxArray * mlfMix_post(mxArray * * logl,
                      mxArray * * framelogl,
                      mxArray * X,
                      mxArray * w,
                      mxArray * mu,
                      mxArray * Sigma,
                      mxArray * QUIET) {
    int nargout = 1;
    mxArray * gamma = mclGetUninitializedArray();
    mxArray * logl__ = mclGetUninitializedArray();
    mxArray * framelogl__ = mclGetUninitializedArray();
    mlfEnterNewContext(2, 5, logl, framelogl, X, w, mu, Sigma, QUIET);
    if (logl != NULL) {
        ++nargout;
    }
    if (framelogl != NULL) {
        ++nargout;
    }
    gamma = Mmix_post(&logl__, &framelogl__, nargout, X, w, mu, Sigma, QUIET);
    mlfRestorePreviousContext(2, 5, logl, framelogl, X, w, mu, Sigma, QUIET);
    if (logl != NULL) {
        mclCopyOutputArg(logl, logl__);
    } else {
        mxDestroyArray(logl__);
    }
    if (framelogl != NULL) {
        mclCopyOutputArg(framelogl, framelogl__);
    } else {
        mxDestroyArray(framelogl__);
    }
    return mlfReturnValue(gamma);
}

/*
 * The function "mlfVMix_post" contains the void interface for the "mix_post"
 * M-function from file "s:\matlab5\reco\toolboxes\pc\h2m\mix_post.m" (lines
 * 1-52). The void interface is only produced if the M-function uses the
 * special variable "nargout", and has at least one output. The void interface
 * function specifies zero output arguments to the implementation version of
 * the function, and in the event that the implementation version still returns
 * an output (which, in MATLAB, would be assigned to the "ans" variable), it
 * deallocates the output. This function processes any input arguments and
 * passes them to the implementation version of the function, appearing above.
 */
void mlfVMix_post(mxArray * X,
                  mxArray * w,
                  mxArray * mu,
                  mxArray * Sigma,
                  mxArray * QUIET) {
    mxArray * gamma = mclUnassigned();
    mxArray * logl = mclUnassigned();
    mxArray * framelogl = mclUnassigned();
    mlfEnterNewContext(0, 5, X, w, mu, Sigma, QUIET);
    gamma = Mmix_post(&logl, &framelogl, 0, X, w, mu, Sigma, QUIET);
    mlfRestorePreviousContext(0, 5, X, w, mu, Sigma, QUIET);
    mxDestroyArray(gamma);
    mxDestroyArray(logl);
    mxDestroyArray(framelogl);
}

/*
 * The function "mlxMix_post" contains the feval interface for the "mix_post"
 * M-function from file "s:\matlab5\reco\toolboxes\pc\h2m\mix_post.m" (lines
 * 1-52). The feval function calls the implementation version of mix_post
 * through this function. This function processes any input arguments and
 * passes them to the implementation version of the function, appearing above.
 */
void mlxMix_post(int nlhs, mxArray * plhs[], int nrhs, mxArray * prhs[]) {
    mxArray * mprhs[5];
    mxArray * mplhs[3];
    int i;
    if (nlhs > 3) {
        mlfError(
          mxCreateString(
            "Run-time Error: File: mix_post Line: 1 Column:"
            " 0 The function \"mix_post\" was called with m"
            "ore than the declared number of outputs (3)"));
    }
    if (nrhs > 5) {
        mlfError(
          mxCreateString(
            "Run-time Error: File: mix_post Line: 1 Column:"
            " 0 The function \"mix_post\" was called with m"
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
      = Mmix_post(
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
