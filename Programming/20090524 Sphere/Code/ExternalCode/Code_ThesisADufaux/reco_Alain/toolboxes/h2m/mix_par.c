static char mc_version[] = "MATLAB Compiler 1.2 Jan 17 1998 infun";
/*
 *  MATLAB Compiler: 1.2
 *  Date: Jan 17 1998
 *  Arguments: mix_par 
 */
#ifndef ARRAY_ACCESS_INLINING
#error You must use the -inline option when compiling MATLAB compiler generated code with MEX or MBUILD
#endif
#ifndef MATLAB_COMPILER_GENERATED_CODE
#define MATLAB_COMPILER_GENERATED_CODE
#endif

#include <math.h>
#include "mex.h"
#include "mcc.h"

/* static array S0_ (1 x 40) text, line 19: 'Check the number of obser...' */
static unsigned short S0__r_[] =
{
         67,  104,  101,   99,  107,   32,  116,  104,
        101,   32,  110,  117,  109,   98,  101,  114,
         32,  111,  102,   32,  111,   98,  115,  101,
        114,  118,   97,  116,  105,  111,  110,   32,
        118,  101,   99,  116,  111,  114,  115,   46,
};
static mxArray S0_ = mccCINIT( mccTEXT,  1, 40, S0__r_, 0);
/* static array S1_ (1 x 34) text, line 24: 'Reestimating mixture para...' */
static unsigned short S1__r_[] =
{
         82,  101,  101,  115,  116,  105,  109,   97,
        116,  105,  110,  103,   32,  109,  105,  120,
        116,  117,  114,  101,   32,  112,   97,  114,
         97,  109,  101,  116,  101,  114,  115,   46,
         46,   46,
};
static mxArray S1_ = mccCINIT( mccTEXT,  1, 34, S1__r_, 0);
/* static array S2_ (1 x 11) text, line 60: ' (%.2f s)\n' */
static unsigned short S2__r_[] =
{
         32,   40,   37,   46,   50,  102,   32,  115,
         41,   92,  110,
};
static mxArray S2_ = mccCINIT( mccTEXT,  1, 11, S2__r_, 0);
/* static array S3_ (1 x 40) text, line 19: 'Check the number of obser...' */
static unsigned short S3__r_[] =
{
         67,  104,  101,   99,  107,   32,  116,  104,
        101,   32,  110,  117,  109,   98,  101,  114,
         32,  111,  102,   32,  111,   98,  115,  101,
        114,  118,   97,  116,  105,  111,  110,   32,
        118,  101,   99,  116,  111,  114,  115,   46,
};
static mxArray S3_ = mccCINIT( mccTEXT,  1, 40, S3__r_, 0);
/* static array S4_ (1 x 34) text, line 24: 'Reestimating mixture para...' */
static unsigned short S4__r_[] =
{
         82,  101,  101,  115,  116,  105,  109,   97,
        116,  105,  110,  103,   32,  109,  105,  120,
        116,  117,  114,  101,   32,  112,   97,  114,
         97,  109,  101,  116,  101,  114,  115,   46,
         46,   46,
};
static mxArray S4_ = mccCINIT( mccTEXT,  1, 34, S4__r_, 0);
/* static array S5_ (1 x 11) text, line 60: ' (%.2f s)\n' */
static unsigned short S5__r_[] =
{
         32,   40,   37,   46,   50,  102,   32,  115,
         41,   92,  110,
};
static mxArray S5_ = mccCINIT( mccTEXT,  1, 11, S5__r_, 0);
/***************** Compiler Assumptions ****************
 *
 *       B0_         	boolean scalar temporary
 *       BM0_        	boolean vector/matrix temporary
 *       C0_         	complex scalar temporary
 *       CM0_        	complex vector/matrix temporary
 *       CM1_        	complex vector/matrix temporary
 *       CM2_        	complex vector/matrix temporary
 *       CM3_        	complex vector/matrix temporary
 *       CM4_        	complex vector/matrix temporary
 *       DIAG_COV    	complex vector/matrix
 *       I0_         	integer scalar temporary
 *       I1_         	integer scalar temporary
 *       IM0_        	integer vector/matrix temporary
 *       N           	integer scalar
 *       QUIET       	complex vector/matrix
 *       R0_         	real scalar temporary
 *       RM0_        	real vector/matrix temporary
 *       RM1_        	real vector/matrix temporary
 *       Sigma       	complex vector/matrix
 *       T           	integer scalar
 *       TM0_        	string vector/matrix temporary
 *       X           	complex vector/matrix
 *       cputime     	<function>
 *       error       	<function>
 *       fprintf     	<function>
 *       gamma       	complex vector/matrix
 *       i           	integer scalar
 *       j           	integer scalar
 *       length      	<function>
 *       mix_par     	<function being defined>
 *       mu          	complex vector/matrix
 *       nargchk     	<function>
 *       nargin      	<function>
 *       nargout     	<function>
 *       ones        	<function>
 *       p           	integer scalar
 *       size        	<function>
 *       sum         	<function>
 *       time        	real scalar
 *       w           	complex vector/matrix
 *       zeros       	<function>
 *******************************************************/

void
mexFunction(
    int nlhs_,
    mxArray *plhs_[],
    int nrhs_,
    const mxArray *prhs_[]
)
{
   int ci_;
   int i_;
   mxArray *Mplhs_[1];
   mxArray *Mprhs_[3];
   

   if (nrhs_ > 4 )
   {
      mexErrMsgTxt( "Too many input arguments." );
   }

   if (nlhs_ > 3 )
   {
      mexErrMsgTxt( "Too many output arguments." );
   }

   for (ci_=i_=0; i_<nrhs_; ++i_)
   {
      if ( mccPI(prhs_[i_]) )
      {
         ci_ = 1;
         break;
      }
   }
   if (ci_)
   {
      mxArray mu;
      mxArray Sigma;
      mxArray w;
      mxArray X;
      mxArray gamma;
      mxArray DIAG_COV;
      mxArray QUIET;
      int T = 0;
      int N = 0;
      int p = 0;
      double time = 0.0;
      int i = 0;
      int j = 0;
      int I0_ = 0;
      mxArray TM0_;
      unsigned short B0_ = 0;
      mxArray CM0_;
      mxArray BM0_;
      mxArray IM0_;
      mxArray CM1_;
      mxArray CM2_;
      mxArray CM3_;
      mxArray CM4_;
      int I1_ = 0;
      double C0__r=0.0, C0__i=0.0;
      mxArray RM0_;
      mxArray RM1_;
      double R0_ = 0.0;
      
      mccComplexInit(X);
      mccImport(&X, ((nrhs_>0) ? prhs_[0] : 0), 0, 0);
      mccComplexInit(gamma);
      mccImport(&gamma, ((nrhs_>1) ? prhs_[1] : 0), 0, 0);
      mccComplexInit(DIAG_COV);
      mccImport(&DIAG_COV, ((nrhs_>2) ? prhs_[2] : 0), 0, 0);
      mccComplexInit(QUIET);
      mccImportCopy(&QUIET, ((nrhs_>3) ? prhs_[3] : 0), 0, 0);
      mccComplexInit(mu);
      mccComplexInit(Sigma);
      mccComplexInit(w);
      mccTextInit(TM0_);
      mccComplexInit(CM0_);
      mccBoolInit(BM0_);
      mccIntInit(IM0_);
      mccComplexInit(CM1_);
      mccComplexInit(CM2_);
      mccComplexInit(CM3_);
      mccComplexInit(CM4_);
      mccRealInit(RM0_);
      mccRealInit(RM1_);
      
      
      /* % mix_par   Reestimate mixture parameters. */
      /* % Use: [mu,Sigma,w] = mix_par(X,gamma,DIAG_COV). */
      /* % Note that mix_par can also be used for re-estimating HMM parameters */
      /* % from posterior state probabilities (w is omitted in this case). */
      
      /* % Version 1.3 */
      /* % Olivier Cappé, 25/03/96 - 17/03/97 */
      /* % ENST Dpt. Signal / CNRS URA 820, Paris */
      
      /* % Check input data */
      /* error(nargchk(3, 4, nargin)); */
      I0_ = mccNargin();
      Mprhs_[0] = mccTempMatrix(3, 0., mccINT, 0 );
      Mprhs_[1] = mccTempMatrix(4, 0., mccINT, 0 );
      Mprhs_[2] = mccTempMatrix(I0_, 0., mccINT, 0 );
      Mplhs_[0] = &TM0_;
      mccCallMATLAB(1, Mplhs_, 3, Mprhs_, "nargchk", 13);
      mccError(&TM0_);
      /* if (nargin < 4) */
      I0_ = mccNargin();
      B0_ = (I0_ < 4);
      if ((double)B0_)
      {
         /* QUIET = 0; */
         {
            double tr_ = 0;
            mccAllocateMatrix(&QUIET, 1, 1);
            *mccPR(&QUIET) = tr_;
         }
         *mccPI(&QUIET) = 0.;
         /* end; */
      }
      /* [T, N] = size(gamma); */
      if(mccNOTSET(&gamma))
      {
         mexErrMsgTxt( "variable gamma undefined, line 17" );
      }
      mccGetMatrixSize(&T,&N, &gamma);
      /* if (length(X(:,1)) ~= T) */
      if(mccNOTSET(&X))
      {
         mexErrMsgTxt( "variable X undefined, line 18" );
      }
      {
         int i_, j_;
         int m_=1, n_=1, cx_ = 0;
         double *p_CM0_;
         int I_CM0_=1;
         double *q_CM0_;
         double *p_X;
         int I_X=1, J_X;
         double *q_X;
         m_ = mcmCalcResultSize(m_, &n_, mccM(&X), 1);
         mccAllocateMatrix(&CM0_, m_, n_);
         mccCheckMatrixSize(&X, mccM(&X), 1);
         I_CM0_ = (mccM(&CM0_) != 1 || mccN(&CM0_) != 1);
         p_CM0_ = mccPR(&CM0_);
         q_CM0_ = mccPI(&CM0_);
         if (mccM(&X) == 1) { I_X = J_X = 0;}
         else { I_X = 1; J_X=mccM(&X)-m_; }
         p_X = mccPR(&X) + 0 + mccM(&X) * (1-1);
         q_X = mccPI(&X) + 0 + mccM(&X) * (1-1);
         if (m_ != 0)
         {
            for (j_=0; j_<n_; ++j_, p_X += J_X, q_X += J_X)
            {
               for (i_=0; i_<m_; ++i_, p_CM0_+=I_CM0_, q_CM0_+=I_CM0_, p_X+=I_X, q_X+=I_X)
               {
                  *p_CM0_ = *p_X;
                  *q_CM0_ = *q_X;
               }
            }
         }
      }
      I0_ = mccGetLength(&CM0_);
      B0_ = (I0_ != T);
      if ((double)B0_)
      {
         /* error('Check the number of observation vectors.'); */
         mccError(&S0_);
         /* end; */
      }
      /* p = length(X(1,:)); */
      {
         int i_, j_;
         int m_=1, n_=1, cx_ = 0;
         double *p_CM0_;
         int I_CM0_=1;
         double *q_CM0_;
         double *p_X;
         int I_X=1, J_X;
         double *q_X;
         m_ = mcmCalcResultSize(m_, &n_, 1, mccN(&X));
         mccAllocateMatrix(&CM0_, m_, n_);
         mccCheckMatrixSize(&X, 1, mccN(&X));
         I_CM0_ = (mccM(&CM0_) != 1 || mccN(&CM0_) != 1);
         p_CM0_ = mccPR(&CM0_);
         q_CM0_ = mccPI(&CM0_);
         if (mccN(&X) == 1) { I_X = J_X = 0;}
         else { I_X = 1; J_X=mccM(&X)-m_; }
         p_X = mccPR(&X) + (1-1) + mccM(&X) * 0;
         q_X = mccPI(&X) + (1-1) + mccM(&X) * 0;
         if (m_ != 0)
         {
            for (j_=0; j_<n_; ++j_, p_X += J_X, q_X += J_X)
            {
               for (i_=0; i_<m_; ++i_, p_CM0_+=I_CM0_, q_CM0_+=I_CM0_, p_X+=I_X, q_X+=I_X)
               {
                  *p_CM0_ = *p_X;
                  *q_CM0_ = *q_X;
               }
            }
         }
      }
      p = mccGetLength(&CM0_);
      
      /* if (~QUIET) */
      if(mccNOTSET(&QUIET))
      {
         mexErrMsgTxt( "variable QUIET undefined, line 23" );
      }
      {
         int i_, j_;
         int m_=1, n_=1, cx_ = 0;
         unsigned short *p_BM0_;
         int I_BM0_=1;
         double *p_QUIET;
         int I_QUIET=1;
         double *q_QUIET;
         m_ = mcmCalcResultSize(m_, &n_, mccM(&QUIET), mccN(&QUIET));
         mccAllocateMatrix(&BM0_, m_, n_);
         I_BM0_ = (mccM(&BM0_) != 1 || mccN(&BM0_) != 1);
         p_BM0_ = mccSPR(&BM0_);
         I_QUIET = (mccM(&QUIET) != 1 || mccN(&QUIET) != 1);
         p_QUIET = mccPR(&QUIET);
         q_QUIET = mccPI(&QUIET);
         if (m_ != 0)
         {
            for (j_=0; j_<n_; ++j_)
            {
               for (i_=0; i_<m_; ++i_, p_BM0_+=I_BM0_, p_QUIET+=I_QUIET, q_QUIET+=I_QUIET)
               {
                  *p_BM0_ = !*p_QUIET&&!*q_QUIET;
               }
            }
         }
      }
      if (mccIfCondition(&BM0_))
      {
         /* fprintf(1, 'Reestimating mixture parameters...'); time = cputime; */
         Mprhs_[0] = mccTempMatrix(1, 0., mccINT, 0 );
         Mprhs_[1] = &S1_;
         Mplhs_[0] = 0;
         mccCallMATLAB(0, Mplhs_, 2, Mprhs_, "fprintf", 24);
         Mplhs_[0] = 0;
         mccCallMATLAB(1, Mplhs_, 0, Mprhs_, "cputime", 24);
         time = mccImportReal(0, 0, Mplhs_[ 0 ], 1, " (mix_par, line 24): time");
         /* end; */
      }
      /* mu = zeros(N, p); */
      mccZerosMN(&mu, N, p);
      mccLOG(&mu) = 0;
      mccSTRING(&mu) = 0;
      /* if (DIAG_COV) */
      if(mccNOTSET(&DIAG_COV))
      {
         mexErrMsgTxt( "variable DIAG_COV undefined, line 27" );
      }
      if (mccIfCondition(&DIAG_COV))
      {
         /* Sigma = zeros(N, p); */
         mccZerosMN(&Sigma, N, p);
         /* for i=1:N */
         for (I0_ = 1; I0_ <= N; I0_ = I0_ + 1)
         {
            i = I0_;
            /* mu(i,:) = sum (X .* (gamma(:,i) * ones(1,p))); */
            {
               int i_, j_;
               int m_=1, n_=1, cx_ = 0;
               double *p_CM0_;
               int I_CM0_=1;
               double *q_CM0_;
               double *p_gamma;
               int I_gamma=1, J_gamma;
               double *q_gamma;
               m_ = mcmCalcResultSize(m_, &n_, mccM(&gamma), 1);
               mccAllocateMatrix(&CM0_, m_, n_);
               mccCheckMatrixSize(&gamma, mccM(&gamma), i);
               I_CM0_ = (mccM(&CM0_) != 1 || mccN(&CM0_) != 1);
               p_CM0_ = mccPR(&CM0_);
               q_CM0_ = mccPI(&CM0_);
               if (mccM(&gamma) == 1) { I_gamma = J_gamma = 0;}
               else { I_gamma = 1; J_gamma=mccM(&gamma)-m_; }
               p_gamma = mccPR(&gamma) + 0 + mccM(&gamma) * (i-1);
               q_gamma = mccPI(&gamma) + 0 + mccM(&gamma) * (i-1);
               if (m_ != 0)
               {
                  for (j_=0; j_<n_; ++j_, p_gamma += J_gamma, q_gamma += J_gamma)
                  {
                     for (i_=0; i_<m_; ++i_, p_CM0_+=I_CM0_, q_CM0_+=I_CM0_, p_gamma+=I_gamma, q_gamma+=I_gamma)
                     {
                        *p_CM0_ = *p_gamma;
                        *q_CM0_ = *q_gamma;
                     }
                  }
               }
            }
            mccOnesMN(&IM0_, 1, p);
            mccMultiply(&CM1_, &CM0_, &IM0_);
            {
               int i_, j_;
               int m_=1, n_=1, cx_ = 0;
               double *p_CM2_;
               int I_CM2_=1;
               double *q_CM2_;
               double *p_X;
               int I_X=1;
               double *q_X;
               double *p_CM1_;
               int I_CM1_=1;
               double *q_CM1_;
               m_ = mcmCalcResultSize(m_, &n_, mccM(&X), mccN(&X));
               m_ = mcmCalcResultSize(m_, &n_, mccM(&CM1_), mccN(&CM1_));
               mccAllocateMatrix(&CM2_, m_, n_);
               I_CM2_ = (mccM(&CM2_) != 1 || mccN(&CM2_) != 1);
               p_CM2_ = mccPR(&CM2_);
               q_CM2_ = mccPI(&CM2_);
               I_X = (mccM(&X) != 1 || mccN(&X) != 1);
               p_X = mccPR(&X);
               q_X = mccPI(&X);
               I_CM1_ = (mccM(&CM1_) != 1 || mccN(&CM1_) != 1);
               p_CM1_ = mccPR(&CM1_);
               q_CM1_ = mccPI(&CM1_);
               if (m_ != 0)
               {
                  for (j_=0; j_<n_; ++j_)
                  {
                     for (i_=0; i_<m_; ++i_, p_CM2_+=I_CM2_, q_CM2_+=I_CM2_, p_X+=I_X, q_X+=I_X, p_CM1_+=I_CM1_, q_CM1_+=I_CM1_)
                     {
                        {
                           double t_ = (*p_X * *p_CM1_ - *q_X * *q_CM1_);
                           *q_CM2_ = (*p_X * *q_CM1_ + *q_X * *p_CM1_);
                           *p_CM2_ = t_;
                        }
                     }
                  }
               }
            }
            Mprhs_[0] = &CM2_;
            Mplhs_[0] = &CM3_;
            mccCallMATLAB(1, Mplhs_, 1, Mprhs_, "sum", 30);
            {
               int i_, j_;
               int m_=1, n_=1, cx_ = 0;
               double *p_mu;
               int I_mu=1, J_mu;
               double *q_mu;
               double *p_CM3_;
               int I_CM3_=1;
               double *q_CM3_;
               m_ = mcmCalcResultSize(m_, &n_, mccM(&CM3_), mccN(&CM3_));
               mccGrowMatrix(&mu, i, n_);
               if (mccN(&mu) == 1) { I_mu = J_mu = 0;}
               else { I_mu = 1; J_mu=mccM(&mu)-m_; }
               p_mu = mccPR(&mu) + (i-1) + mccM(&mu) * 0;
               q_mu = mccPI(&mu) + (i-1) + mccM(&mu) * 0;
               I_CM3_ = (mccM(&CM3_) != 1 || mccN(&CM3_) != 1);
               p_CM3_ = mccPR(&CM3_);
               q_CM3_ = mccPI(&CM3_);
               if (m_ != 0)
               {
                  for (j_=0; j_<n_; ++j_, p_mu += J_mu, q_mu += J_mu)
                  {
                     for (i_=0; i_<m_; ++i_, p_mu+=I_mu, q_mu+=I_mu, p_CM3_+=I_CM3_, q_CM3_+=I_CM3_)
                     {
                        *p_mu = *p_CM3_;
                        *q_mu = *q_CM3_;
                     }
                  }
               }
            }
            /* Sigma(i,:) = sum(X.^2 .* (gamma(:,i) * ones(1,p))); */
            mccArrayPower(&CM3_, &X, mccTempMatrix(2, 0., mccINT, 0 ));
            {
               int i_, j_;
               int m_=1, n_=1, cx_ = 0;
               double *p_CM2_;
               int I_CM2_=1;
               double *q_CM2_;
               double *p_gamma;
               int I_gamma=1, J_gamma;
               double *q_gamma;
               m_ = mcmCalcResultSize(m_, &n_, mccM(&gamma), 1);
               mccAllocateMatrix(&CM2_, m_, n_);
               mccCheckMatrixSize(&gamma, mccM(&gamma), i);
               I_CM2_ = (mccM(&CM2_) != 1 || mccN(&CM2_) != 1);
               p_CM2_ = mccPR(&CM2_);
               q_CM2_ = mccPI(&CM2_);
               if (mccM(&gamma) == 1) { I_gamma = J_gamma = 0;}
               else { I_gamma = 1; J_gamma=mccM(&gamma)-m_; }
               p_gamma = mccPR(&gamma) + 0 + mccM(&gamma) * (i-1);
               q_gamma = mccPI(&gamma) + 0 + mccM(&gamma) * (i-1);
               if (m_ != 0)
               {
                  for (j_=0; j_<n_; ++j_, p_gamma += J_gamma, q_gamma += J_gamma)
                  {
                     for (i_=0; i_<m_; ++i_, p_CM2_+=I_CM2_, q_CM2_+=I_CM2_, p_gamma+=I_gamma, q_gamma+=I_gamma)
                     {
                        *p_CM2_ = *p_gamma;
                        *q_CM2_ = *q_gamma;
                     }
                  }
               }
            }
            mccOnesMN(&IM0_, 1, p);
            mccMultiply(&CM1_, &CM2_, &IM0_);
            {
               int i_, j_;
               int m_=1, n_=1, cx_ = 0;
               double *p_CM0_;
               int I_CM0_=1;
               double *q_CM0_;
               double *p_CM3_;
               int I_CM3_=1;
               double *q_CM3_;
               double *p_CM1_;
               int I_CM1_=1;
               double *q_CM1_;
               m_ = mcmCalcResultSize(m_, &n_, mccM(&CM3_), mccN(&CM3_));
               m_ = mcmCalcResultSize(m_, &n_, mccM(&CM1_), mccN(&CM1_));
               mccAllocateMatrix(&CM0_, m_, n_);
               I_CM0_ = (mccM(&CM0_) != 1 || mccN(&CM0_) != 1);
               p_CM0_ = mccPR(&CM0_);
               q_CM0_ = mccPI(&CM0_);
               I_CM3_ = (mccM(&CM3_) != 1 || mccN(&CM3_) != 1);
               p_CM3_ = mccPR(&CM3_);
               q_CM3_ = mccPI(&CM3_);
               I_CM1_ = (mccM(&CM1_) != 1 || mccN(&CM1_) != 1);
               p_CM1_ = mccPR(&CM1_);
               q_CM1_ = mccPI(&CM1_);
               if (m_ != 0)
               {
                  for (j_=0; j_<n_; ++j_)
                  {
                     for (i_=0; i_<m_; ++i_, p_CM0_+=I_CM0_, q_CM0_+=I_CM0_, p_CM3_+=I_CM3_, q_CM3_+=I_CM3_, p_CM1_+=I_CM1_, q_CM1_+=I_CM1_)
                     {
                        {
                           double t_ = (*p_CM3_ * *p_CM1_ - *q_CM3_ * *q_CM1_);
                           *q_CM0_ = (*p_CM3_ * *q_CM1_ + *q_CM3_ * *p_CM1_);
                           *p_CM0_ = t_;
                        }
                     }
                  }
               }
            }
            Mprhs_[0] = &CM0_;
            Mplhs_[0] = &CM4_;
            mccCallMATLAB(1, Mplhs_, 1, Mprhs_, "sum", 31);
            {
               int i_, j_;
               int m_=1, n_=1, cx_ = 0;
               double *p_Sigma;
               int I_Sigma=1, J_Sigma;
               double *q_Sigma;
               double *p_CM4_;
               int I_CM4_=1;
               double *q_CM4_;
               m_ = mcmCalcResultSize(m_, &n_, mccM(&CM4_), mccN(&CM4_));
               mccGrowMatrix(&Sigma, i, n_);
               if (mccN(&Sigma) == 1) { I_Sigma = J_Sigma = 0;}
               else { I_Sigma = 1; J_Sigma=mccM(&Sigma)-m_; }
               p_Sigma = mccPR(&Sigma) + (i-1) + mccM(&Sigma) * 0;
               q_Sigma = mccPI(&Sigma) + (i-1) + mccM(&Sigma) * 0;
               I_CM4_ = (mccM(&CM4_) != 1 || mccN(&CM4_) != 1);
               p_CM4_ = mccPR(&CM4_);
               q_CM4_ = mccPI(&CM4_);
               if (m_ != 0)
               {
                  for (j_=0; j_<n_; ++j_, p_Sigma += J_Sigma, q_Sigma += J_Sigma)
                  {
                     for (i_=0; i_<m_; ++i_, p_Sigma+=I_Sigma, q_Sigma+=I_Sigma, p_CM4_+=I_CM4_, q_CM4_+=I_CM4_)
                     {
                        *p_Sigma = *p_CM4_;
                        *q_Sigma = *q_CM4_;
                     }
                  }
               }
            }
            /* end; */
         }
         /* % Normalization */
         /* mu = mu ./ (sum(gamma)' * ones(1,p)); */
         Mprhs_[0] = &gamma;
         Mplhs_[0] = &CM4_;
         mccCallMATLAB(1, Mplhs_, 1, Mprhs_, "sum", 34);
         mccConjTrans(&CM0_, &CM4_);
         mccOnesMN(&IM0_, 1, p);
         mccMultiply(&CM1_, &CM0_, &IM0_);
         mccArrayRightDivide(&mu, &mu, &CM1_);
         mccLOG(&mu) = 0;
         mccSTRING(&mu) = 0;
         /* Sigma = Sigma ./ (sum(gamma)' * ones(1,p)); */
         Mprhs_[0] = &gamma;
         Mplhs_[0] = &CM1_;
         mccCallMATLAB(1, Mplhs_, 1, Mprhs_, "sum", 35);
         mccConjTrans(&CM0_, &CM1_);
         mccOnesMN(&IM0_, 1, p);
         mccMultiply(&CM4_, &CM0_, &IM0_);
         mccArrayRightDivide(&Sigma, &Sigma, &CM4_);
         /* % Sigma */
         /* Sigma = Sigma - mu.^2; */
         mccArrayPower(&CM4_, &mu, mccTempMatrix(2, 0., mccINT, 0 ));
         {
            int i_, j_;
            int m_=1, n_=1, cx_ = 0;
            double *p_Sigma;
            int I_Sigma=1;
            double *q_Sigma;
            double *p_1Sigma;
            int I_1Sigma=1;
            double *q_1Sigma;
            double *p_CM4_;
            int I_CM4_=1;
            double *q_CM4_;
            m_ = mcmCalcResultSize(m_, &n_, mccM(&Sigma), mccN(&Sigma));
            m_ = mcmCalcResultSize(m_, &n_, mccM(&CM4_), mccN(&CM4_));
            mccAllocateMatrix(&Sigma, m_, n_);
            I_Sigma = (mccM(&Sigma) != 1 || mccN(&Sigma) != 1);
            p_Sigma = mccPR(&Sigma);
            q_Sigma = mccPI(&Sigma);
            I_1Sigma = (mccM(&Sigma) != 1 || mccN(&Sigma) != 1);
            p_1Sigma = mccPR(&Sigma);
            q_1Sigma = mccPI(&Sigma);
            I_CM4_ = (mccM(&CM4_) != 1 || mccN(&CM4_) != 1);
            p_CM4_ = mccPR(&CM4_);
            q_CM4_ = mccPI(&CM4_);
            if (m_ != 0)
            {
               for (j_=0; j_<n_; ++j_)
               {
                  for (i_=0; i_<m_; ++i_, p_Sigma+=I_Sigma, q_Sigma+=I_Sigma, p_1Sigma+=I_1Sigma, q_1Sigma+=I_1Sigma, p_CM4_+=I_CM4_, q_CM4_+=I_CM4_)
                  {
                     *p_Sigma = (*p_1Sigma - *p_CM4_);
                     *q_Sigma = (*q_1Sigma - *q_CM4_);
                  }
               }
            }
         }
         mccLOG(&Sigma) = 0;
         mccSTRING(&Sigma) = 0;
      }
      else
      {
         /* else */
         /* Sigma = zeros(N*p, p); */
         mccZerosMN(&Sigma, ((int)(N * (double) p)), p);
         mccLOG(&Sigma) = 0;
         mccSTRING(&Sigma) = 0;
         /* for i = 1:N */
         for (I0_ = 1; I0_ <= N; I0_ = I0_ + 1)
         {
            i = I0_;
            /* for j = 1:T */
            for (I1_ = 1; I1_ <= T; I1_ = I1_ + 1)
            {
               j = I1_;
               /* mu(i,:) = mu(i,:) + gamma(j,i)*X(j,:); */
               C0__r = (mccGetRealMatrixElement(&gamma, mccRint(j), mccRint(i)));
               C0__i = mccGetImagMatrixElement(&gamma, mccRint(j), mccRint(i));
               {
                  int i_, j_;
                  int m_=1, n_=1, cx_ = 0;
                  double *p_mu;
                  int I_mu=1, J_mu;
                  double *q_mu;
                  double *p_1mu;
                  int I_1mu=1, J_1mu;
                  double *q_1mu;
                  double *p_X;
                  int I_X=1, J_X;
                  double *q_X;
                  m_ = mcmCalcResultSize(m_, &n_, 1, mccN(&mu));
                  m_ = mcmCalcResultSize(m_, &n_, 1, mccN(&X));
                  mccGrowMatrix(&mu, i, n_);
                  mccCheckMatrixSize(&mu, i, mccN(&mu));
                  mccCheckMatrixSize(&X, j, mccN(&X));
                  if (mccN(&mu) == 1) { I_mu = J_mu = 0;}
                  else { I_mu = 1; J_mu=mccM(&mu)-m_; }
                  p_mu = mccPR(&mu) + (i-1) + mccM(&mu) * 0;
                  q_mu = mccPI(&mu) + (i-1) + mccM(&mu) * 0;
                  if (mccN(&mu) == 1) { I_1mu = J_1mu = 0;}
                  else { I_1mu = 1; J_1mu=mccM(&mu)-m_; }
                  p_1mu = mccPR(&mu) + (i-1) + mccM(&mu) * 0;
                  q_1mu = mccPI(&mu) + (i-1) + mccM(&mu) * 0;
                  if (mccN(&X) == 1) { I_X = J_X = 0;}
                  else { I_X = 1; J_X=mccM(&X)-m_; }
                  p_X = mccPR(&X) + (j-1) + mccM(&X) * 0;
                  q_X = mccPI(&X) + (j-1) + mccM(&X) * 0;
                  if (m_ != 0)
                  {
                     for (j_=0; j_<n_; ++j_, p_mu += J_mu, q_mu += J_mu, p_1mu += J_1mu, q_1mu += J_1mu, p_X += J_X, q_X += J_X)
                     {
                        for (i_=0; i_<m_; ++i_, p_mu+=I_mu, q_mu+=I_mu, p_1mu+=I_1mu, q_1mu+=I_1mu, p_X+=I_X, q_X+=I_X)
                        {
                           *p_mu = (*p_1mu + (C0__r * *p_X - C0__i * *q_X));
                           *q_mu = (*q_1mu + (C0__r * *q_X + C0__i * *p_X));
                        }
                     }
                  }
               }
               /* Sigma(((1+(i-1)*p):(i*p)),:) = Sigma(((1+(i-1)*p):(i*p)),:)... */
               mccColon2(&RM1_, (1 + ((i - 1) * (double) p)), (i * (double) p));
               C0__r = (mccGetRealMatrixElement(&gamma, mccRint(j), mccRint(i)));
               C0__i = mccGetImagMatrixElement(&gamma, mccRint(j), mccRint(i));
               {
                  int i_, j_;
                  int m_=1, n_=1, cx_ = 0;
                  double *p_CM4_;
                  int I_CM4_=1;
                  double *q_CM4_;
                  double *p_X;
                  int I_X=1, J_X;
                  double *q_X;
                  m_ = mcmCalcResultSize(m_, &n_, 1, mccN(&X));
                  mccAllocateMatrix(&CM4_, m_, n_);
                  mccCheckMatrixSize(&X, j, mccN(&X));
                  I_CM4_ = (mccM(&CM4_) != 1 || mccN(&CM4_) != 1);
                  p_CM4_ = mccPR(&CM4_);
                  q_CM4_ = mccPI(&CM4_);
                  if (mccN(&X) == 1) { I_X = J_X = 0;}
                  else { I_X = 1; J_X=mccM(&X)-m_; }
                  p_X = mccPR(&X) + (j-1) + mccM(&X) * 0;
                  q_X = mccPI(&X) + (j-1) + mccM(&X) * 0;
                  if (m_ != 0)
                  {
                     for (j_=0; j_<n_; ++j_, p_X += J_X, q_X += J_X)
                     {
                        for (i_=0; i_<m_; ++i_, p_CM4_+=I_CM4_, q_CM4_+=I_CM4_, p_X+=I_X, q_X+=I_X)
                        {
                           *p_CM4_ = *p_X;
                           *q_CM4_ = *q_X;
                        }
                     }
                  }
               }
               mccConjTrans(&CM0_, &CM4_);
               {
                  int i_, j_;
                  int m_=1, n_=1, cx_ = 0;
                  double *p_CM1_;
                  int I_CM1_=1;
                  double *q_CM1_;
                  double *p_X;
                  int I_X=1, J_X;
                  double *q_X;
                  m_ = mcmCalcResultSize(m_, &n_, 1, mccN(&X));
                  mccAllocateMatrix(&CM1_, m_, n_);
                  mccCheckMatrixSize(&X, j, mccN(&X));
                  I_CM1_ = (mccM(&CM1_) != 1 || mccN(&CM1_) != 1);
                  p_CM1_ = mccPR(&CM1_);
                  q_CM1_ = mccPI(&CM1_);
                  if (mccN(&X) == 1) { I_X = J_X = 0;}
                  else { I_X = 1; J_X=mccM(&X)-m_; }
                  p_X = mccPR(&X) + (j-1) + mccM(&X) * 0;
                  q_X = mccPI(&X) + (j-1) + mccM(&X) * 0;
                  if (m_ != 0)
                  {
                     for (j_=0; j_<n_; ++j_, p_X += J_X, q_X += J_X)
                     {
                        for (i_=0; i_<m_; ++i_, p_CM1_+=I_CM1_, q_CM1_+=I_CM1_, p_X+=I_X, q_X+=I_X)
                        {
                           *p_CM1_ = *p_X;
                           *q_CM1_ = *q_X;
                        }
                     }
                  }
               }
               mccMultiply(&CM2_, &CM0_, &CM1_);
               mccColon2(&RM0_, (1 + ((i - 1) * (double) p)), (i * (double) p));
               {
                  int i_, j_;
                  int m_=1, n_=1, cx_ = 0;
                  double *p_Sigma;
                  int I_Sigma=1, J_Sigma;
                  double *q_Sigma;
                  double *p_RM0_;
                  int I_RM0_=1;
                  double *p_1Sigma;
                  int I_1Sigma=1, J_1Sigma;
                  double *q_1Sigma;
                  double *p_RM1_;
                  int I_RM1_=1;
                  double *p_CM2_;
                  int I_CM2_=1;
                  double *q_CM2_;
                  m_ = mcmCalcResultSize(m_, &n_, (mccM(&RM1_) * mccN(&RM1_)), mccN(&Sigma));
                  m_ = mcmCalcResultSize(m_, &n_, mccM(&CM2_), mccN(&CM2_));
                  mccGrowMatrix(&Sigma, mccGetMaxIndex(&RM0_ ,mccM(&Sigma)), n_);
                  mccCheckMatrixSize(&Sigma, mccGetMaxIndex(&RM1_ ,mccM(&Sigma)), mccN(&Sigma));
                  J_Sigma = ((mccM(&Sigma) != 1 || mccN(&Sigma) != 1) ? mccM(&Sigma) : 0);
                  p_Sigma = mccPR(&Sigma) + mccM(&Sigma) * 0;
                  q_Sigma = mccPI(&Sigma) + mccM(&Sigma) * 0;
                  I_RM0_ = (mccM(&RM0_) != 1 || mccN(&RM0_) != 1);
                  J_1Sigma = ((mccM(&Sigma) != 1 || mccN(&Sigma) != 1) ? mccM(&Sigma) : 0);
                  p_1Sigma = mccPR(&Sigma) + mccM(&Sigma) * 0;
                  q_1Sigma = mccPI(&Sigma) + mccM(&Sigma) * 0;
                  I_RM1_ = (mccM(&RM1_) != 1 || mccN(&RM1_) != 1);
                  I_CM2_ = (mccM(&CM2_) != 1 || mccN(&CM2_) != 1);
                  p_CM2_ = mccPR(&CM2_);
                  q_CM2_ = mccPI(&CM2_);
                  if (m_ != 0)
                  {
                     for (j_=0; j_<n_; ++j_, p_Sigma += J_Sigma, q_Sigma += J_Sigma, p_1Sigma += J_1Sigma, q_1Sigma += J_1Sigma)
                     {
                        p_RM0_ = mccPR(&RM0_);
                        p_RM1_ = mccPR(&RM1_);
                        for (i_=0; i_<m_; ++i_, p_RM0_+=I_RM0_, p_RM1_+=I_RM1_, p_CM2_+=I_CM2_, q_CM2_+=I_CM2_)
                        {
                           p_Sigma[((int)(*p_RM0_ - .5))] = (p_1Sigma[((int)(*p_RM1_ - .5))] + (C0__r * *p_CM2_ - C0__i * *q_CM2_));
                           q_Sigma[((int)(*p_RM0_ - .5))] = (q_1Sigma[((int)(*p_RM1_ - .5))] + (C0__r * *q_CM2_ + C0__i * *p_CM2_));
                        }
                     }
                  }
               }
               /* end; */
            }
            /* % Normalization */
            /* mu(i,:) = mu(i,:)/sum(gamma(:,i)); */
            {
               int i_, j_;
               int m_=1, n_=1, cx_ = 0;
               double *p_CM2_;
               int I_CM2_=1;
               double *q_CM2_;
               double *p_mu;
               int I_mu=1, J_mu;
               double *q_mu;
               m_ = mcmCalcResultSize(m_, &n_, 1, mccN(&mu));
               mccAllocateMatrix(&CM2_, m_, n_);
               mccCheckMatrixSize(&mu, i, mccN(&mu));
               I_CM2_ = (mccM(&CM2_) != 1 || mccN(&CM2_) != 1);
               p_CM2_ = mccPR(&CM2_);
               q_CM2_ = mccPI(&CM2_);
               if (mccN(&mu) == 1) { I_mu = J_mu = 0;}
               else { I_mu = 1; J_mu=mccM(&mu)-m_; }
               p_mu = mccPR(&mu) + (i-1) + mccM(&mu) * 0;
               q_mu = mccPI(&mu) + (i-1) + mccM(&mu) * 0;
               if (m_ != 0)
               {
                  for (j_=0; j_<n_; ++j_, p_mu += J_mu, q_mu += J_mu)
                  {
                     for (i_=0; i_<m_; ++i_, p_CM2_+=I_CM2_, q_CM2_+=I_CM2_, p_mu+=I_mu, q_mu+=I_mu)
                     {
                        *p_CM2_ = *p_mu;
                        *q_CM2_ = *q_mu;
                     }
                  }
               }
            }
            {
               int i_, j_;
               int m_=1, n_=1, cx_ = 0;
               double *p_CM1_;
               int I_CM1_=1;
               double *q_CM1_;
               double *p_gamma;
               int I_gamma=1, J_gamma;
               double *q_gamma;
               m_ = mcmCalcResultSize(m_, &n_, mccM(&gamma), 1);
               mccAllocateMatrix(&CM1_, m_, n_);
               mccCheckMatrixSize(&gamma, mccM(&gamma), i);
               I_CM1_ = (mccM(&CM1_) != 1 || mccN(&CM1_) != 1);
               p_CM1_ = mccPR(&CM1_);
               q_CM1_ = mccPI(&CM1_);
               if (mccM(&gamma) == 1) { I_gamma = J_gamma = 0;}
               else { I_gamma = 1; J_gamma=mccM(&gamma)-m_; }
               p_gamma = mccPR(&gamma) + 0 + mccM(&gamma) * (i-1);
               q_gamma = mccPI(&gamma) + 0 + mccM(&gamma) * (i-1);
               if (m_ != 0)
               {
                  for (j_=0; j_<n_; ++j_, p_gamma += J_gamma, q_gamma += J_gamma)
                  {
                     for (i_=0; i_<m_; ++i_, p_CM1_+=I_CM1_, q_CM1_+=I_CM1_, p_gamma+=I_gamma, q_gamma+=I_gamma)
                     {
                        *p_CM1_ = *p_gamma;
                        *q_CM1_ = *q_gamma;
                     }
                  }
               }
            }
            Mprhs_[0] = &CM1_;
            Mplhs_[0] = &CM0_;
            mccCallMATLAB(1, Mplhs_, 1, Mprhs_, "sum", 47);
            mccRightDivide(&CM4_, &CM2_, &CM0_);
            {
               int i_, j_;
               int m_=1, n_=1, cx_ = 0;
               double *p_mu;
               int I_mu=1, J_mu;
               double *q_mu;
               double *p_CM4_;
               int I_CM4_=1;
               double *q_CM4_;
               m_ = mcmCalcResultSize(m_, &n_, mccM(&CM4_), mccN(&CM4_));
               mccGrowMatrix(&mu, i, n_);
               if (mccN(&mu) == 1) { I_mu = J_mu = 0;}
               else { I_mu = 1; J_mu=mccM(&mu)-m_; }
               p_mu = mccPR(&mu) + (i-1) + mccM(&mu) * 0;
               q_mu = mccPI(&mu) + (i-1) + mccM(&mu) * 0;
               I_CM4_ = (mccM(&CM4_) != 1 || mccN(&CM4_) != 1);
               p_CM4_ = mccPR(&CM4_);
               q_CM4_ = mccPI(&CM4_);
               if (m_ != 0)
               {
                  for (j_=0; j_<n_; ++j_, p_mu += J_mu, q_mu += J_mu)
                  {
                     for (i_=0; i_<m_; ++i_, p_mu+=I_mu, q_mu+=I_mu, p_CM4_+=I_CM4_, q_CM4_+=I_CM4_)
                     {
                        *p_mu = *p_CM4_;
                        *q_mu = *q_CM4_;
                     }
                  }
               }
            }
            /* Sigma(((1+(i-1)*p):(i*p)),:) = Sigma(((1+(i-1)*p):(i*p)),:) /sum(gamma(:,i)); */
            mccColon2(&RM0_, (1 + ((i - 1) * (double) p)), (i * (double) p));
            mccFindIndex(&IM0_, &RM0_);
            {
               int i_, j_;
               int m_=1, n_=1, cx_ = 0;
               double *p_CM4_;
               int I_CM4_=1;
               double *q_CM4_;
               double *p_Sigma;
               int I_Sigma=1, J_Sigma;
               double *q_Sigma;
               int *p_IM0_;
               int I_IM0_=1;
               m_ = mcmCalcResultSize(m_, &n_, (mccM(&IM0_) * mccN(&IM0_)), mccN(&Sigma));
               mccAllocateMatrix(&CM4_, m_, n_);
               mccCheckMatrixSize(&Sigma, mccGetMaxIndex(&IM0_ ,mccM(&Sigma)), mccN(&Sigma));
               I_CM4_ = (mccM(&CM4_) != 1 || mccN(&CM4_) != 1);
               p_CM4_ = mccPR(&CM4_);
               q_CM4_ = mccPI(&CM4_);
               J_Sigma = ((mccM(&Sigma) != 1 || mccN(&Sigma) != 1) ? mccM(&Sigma) : 0);
               p_Sigma = mccPR(&Sigma) + mccM(&Sigma) * 0;
               q_Sigma = mccPI(&Sigma) + mccM(&Sigma) * 0;
               I_IM0_ = (mccM(&IM0_) != 1 || mccN(&IM0_) != 1);
               if (m_ != 0)
               {
                  for (j_=0; j_<n_; ++j_, p_Sigma += J_Sigma, q_Sigma += J_Sigma)
                  {
                     p_IM0_ = mccIPR(&IM0_);
                     for (i_=0; i_<m_; ++i_, p_CM4_+=I_CM4_, q_CM4_+=I_CM4_, p_IM0_+=I_IM0_)
                     {
                        *p_CM4_ = p_Sigma[((int)(*p_IM0_ - .5))];
                        *q_CM4_ = q_Sigma[((int)(*p_IM0_ - .5))];
                     }
                  }
               }
            }
            {
               int i_, j_;
               int m_=1, n_=1, cx_ = 0;
               double *p_CM0_;
               int I_CM0_=1;
               double *q_CM0_;
               double *p_gamma;
               int I_gamma=1, J_gamma;
               double *q_gamma;
               m_ = mcmCalcResultSize(m_, &n_, mccM(&gamma), 1);
               mccAllocateMatrix(&CM0_, m_, n_);
               mccCheckMatrixSize(&gamma, mccM(&gamma), i);
               I_CM0_ = (mccM(&CM0_) != 1 || mccN(&CM0_) != 1);
               p_CM0_ = mccPR(&CM0_);
               q_CM0_ = mccPI(&CM0_);
               if (mccM(&gamma) == 1) { I_gamma = J_gamma = 0;}
               else { I_gamma = 1; J_gamma=mccM(&gamma)-m_; }
               p_gamma = mccPR(&gamma) + 0 + mccM(&gamma) * (i-1);
               q_gamma = mccPI(&gamma) + 0 + mccM(&gamma) * (i-1);
               if (m_ != 0)
               {
                  for (j_=0; j_<n_; ++j_, p_gamma += J_gamma, q_gamma += J_gamma)
                  {
                     for (i_=0; i_<m_; ++i_, p_CM0_+=I_CM0_, q_CM0_+=I_CM0_, p_gamma+=I_gamma, q_gamma+=I_gamma)
                     {
                        *p_CM0_ = *p_gamma;
                        *q_CM0_ = *q_gamma;
                     }
                  }
               }
            }
            Mprhs_[0] = &CM0_;
            Mplhs_[0] = &CM1_;
            mccCallMATLAB(1, Mplhs_, 1, Mprhs_, "sum", 48);
            mccRightDivide(&CM2_, &CM4_, &CM1_);
            mccColon2(&RM1_, (1 + ((i - 1) * (double) p)), (i * (double) p));
            {
               int i_, j_;
               int m_=1, n_=1, cx_ = 0;
               double *p_Sigma;
               int I_Sigma=1, J_Sigma;
               double *q_Sigma;
               double *p_RM1_;
               int I_RM1_=1;
               double *p_CM2_;
               int I_CM2_=1;
               double *q_CM2_;
               m_ = mcmCalcResultSize(m_, &n_, mccM(&CM2_), mccN(&CM2_));
               mccGrowMatrix(&Sigma, mccGetMaxIndex(&RM1_ ,mccM(&Sigma)), n_);
               J_Sigma = ((mccM(&Sigma) != 1 || mccN(&Sigma) != 1) ? mccM(&Sigma) : 0);
               p_Sigma = mccPR(&Sigma) + mccM(&Sigma) * 0;
               q_Sigma = mccPI(&Sigma) + mccM(&Sigma) * 0;
               I_RM1_ = (mccM(&RM1_) != 1 || mccN(&RM1_) != 1);
               I_CM2_ = (mccM(&CM2_) != 1 || mccN(&CM2_) != 1);
               p_CM2_ = mccPR(&CM2_);
               q_CM2_ = mccPI(&CM2_);
               if (m_ != 0)
               {
                  for (j_=0; j_<n_; ++j_, p_Sigma += J_Sigma, q_Sigma += J_Sigma)
                  {
                     p_RM1_ = mccPR(&RM1_);
                     for (i_=0; i_<m_; ++i_, p_RM1_+=I_RM1_, p_CM2_+=I_CM2_, q_CM2_+=I_CM2_)
                     {
                        p_Sigma[((int)(*p_RM1_ - .5))] = *p_CM2_;
                        q_Sigma[((int)(*p_RM1_ - .5))] = *q_CM2_;
                     }
                  }
               }
            }
            /* % Sigma */
            /* Sigma(((1+(i-1)*p):(i*p)),:) = Sigma(((1+(i-1)*p):(i*p)),:)... */
            mccColon2(&RM1_, (1 + ((i - 1) * (double) p)), (i * (double) p));
            {
               int i_, j_;
               int m_=1, n_=1, cx_ = 0;
               double *p_CM2_;
               int I_CM2_=1;
               double *q_CM2_;
               double *p_mu;
               int I_mu=1, J_mu;
               double *q_mu;
               m_ = mcmCalcResultSize(m_, &n_, 1, mccN(&mu));
               mccAllocateMatrix(&CM2_, m_, n_);
               mccCheckMatrixSize(&mu, i, mccN(&mu));
               I_CM2_ = (mccM(&CM2_) != 1 || mccN(&CM2_) != 1);
               p_CM2_ = mccPR(&CM2_);
               q_CM2_ = mccPI(&CM2_);
               if (mccN(&mu) == 1) { I_mu = J_mu = 0;}
               else { I_mu = 1; J_mu=mccM(&mu)-m_; }
               p_mu = mccPR(&mu) + (i-1) + mccM(&mu) * 0;
               q_mu = mccPI(&mu) + (i-1) + mccM(&mu) * 0;
               if (m_ != 0)
               {
                  for (j_=0; j_<n_; ++j_, p_mu += J_mu, q_mu += J_mu)
                  {
                     for (i_=0; i_<m_; ++i_, p_CM2_+=I_CM2_, q_CM2_+=I_CM2_, p_mu+=I_mu, q_mu+=I_mu)
                     {
                        *p_CM2_ = *p_mu;
                        *q_CM2_ = *q_mu;
                     }
                  }
               }
            }
            mccConjTrans(&CM1_, &CM2_);
            {
               int i_, j_;
               int m_=1, n_=1, cx_ = 0;
               double *p_CM0_;
               int I_CM0_=1;
               double *q_CM0_;
               double *p_mu;
               int I_mu=1, J_mu;
               double *q_mu;
               m_ = mcmCalcResultSize(m_, &n_, 1, mccN(&mu));
               mccAllocateMatrix(&CM0_, m_, n_);
               mccCheckMatrixSize(&mu, i, mccN(&mu));
               I_CM0_ = (mccM(&CM0_) != 1 || mccN(&CM0_) != 1);
               p_CM0_ = mccPR(&CM0_);
               q_CM0_ = mccPI(&CM0_);
               if (mccN(&mu) == 1) { I_mu = J_mu = 0;}
               else { I_mu = 1; J_mu=mccM(&mu)-m_; }
               p_mu = mccPR(&mu) + (i-1) + mccM(&mu) * 0;
               q_mu = mccPI(&mu) + (i-1) + mccM(&mu) * 0;
               if (m_ != 0)
               {
                  for (j_=0; j_<n_; ++j_, p_mu += J_mu, q_mu += J_mu)
                  {
                     for (i_=0; i_<m_; ++i_, p_CM0_+=I_CM0_, q_CM0_+=I_CM0_, p_mu+=I_mu, q_mu+=I_mu)
                     {
                        *p_CM0_ = *p_mu;
                        *q_CM0_ = *q_mu;
                     }
                  }
               }
            }
            mccMultiply(&CM4_, &CM1_, &CM0_);
            mccColon2(&RM0_, (1 + ((i - 1) * (double) p)), (i * (double) p));
            {
               int i_, j_;
               int m_=1, n_=1, cx_ = 0;
               double *p_Sigma;
               int I_Sigma=1, J_Sigma;
               double *q_Sigma;
               double *p_RM0_;
               int I_RM0_=1;
               double *p_1Sigma;
               int I_1Sigma=1, J_1Sigma;
               double *q_1Sigma;
               double *p_RM1_;
               int I_RM1_=1;
               double *p_CM4_;
               int I_CM4_=1;
               double *q_CM4_;
               m_ = mcmCalcResultSize(m_, &n_, (mccM(&RM1_) * mccN(&RM1_)), mccN(&Sigma));
               m_ = mcmCalcResultSize(m_, &n_, mccM(&CM4_), mccN(&CM4_));
               mccGrowMatrix(&Sigma, mccGetMaxIndex(&RM0_ ,mccM(&Sigma)), n_);
               mccCheckMatrixSize(&Sigma, mccGetMaxIndex(&RM1_ ,mccM(&Sigma)), mccN(&Sigma));
               J_Sigma = ((mccM(&Sigma) != 1 || mccN(&Sigma) != 1) ? mccM(&Sigma) : 0);
               p_Sigma = mccPR(&Sigma) + mccM(&Sigma) * 0;
               q_Sigma = mccPI(&Sigma) + mccM(&Sigma) * 0;
               I_RM0_ = (mccM(&RM0_) != 1 || mccN(&RM0_) != 1);
               J_1Sigma = ((mccM(&Sigma) != 1 || mccN(&Sigma) != 1) ? mccM(&Sigma) : 0);
               p_1Sigma = mccPR(&Sigma) + mccM(&Sigma) * 0;
               q_1Sigma = mccPI(&Sigma) + mccM(&Sigma) * 0;
               I_RM1_ = (mccM(&RM1_) != 1 || mccN(&RM1_) != 1);
               I_CM4_ = (mccM(&CM4_) != 1 || mccN(&CM4_) != 1);
               p_CM4_ = mccPR(&CM4_);
               q_CM4_ = mccPI(&CM4_);
               if (m_ != 0)
               {
                  for (j_=0; j_<n_; ++j_, p_Sigma += J_Sigma, q_Sigma += J_Sigma, p_1Sigma += J_1Sigma, q_1Sigma += J_1Sigma)
                  {
                     p_RM0_ = mccPR(&RM0_);
                     p_RM1_ = mccPR(&RM1_);
                     for (i_=0; i_<m_; ++i_, p_RM0_+=I_RM0_, p_RM1_+=I_RM1_, p_CM4_+=I_CM4_, q_CM4_+=I_CM4_)
                     {
                        p_Sigma[((int)(*p_RM0_ - .5))] = (p_1Sigma[((int)(*p_RM1_ - .5))] - *p_CM4_);
                        q_Sigma[((int)(*p_RM0_ - .5))] = (q_1Sigma[((int)(*p_RM1_ - .5))] - *q_CM4_);
                     }
                  }
               }
            }
            /* end; */
         }
         /* end; */
      }
      /* % Mixture proportions */
      /* if (nargout > 2) */
      I0_ = mccNargout();
      B0_ = (I0_ > 2);
      if ((double)B0_)
      {
         /* w = sum(gamma); */
         Mprhs_[0] = &gamma;
         Mplhs_[0] = &w;
         mccCallMATLAB(1, Mplhs_, 1, Mprhs_, "sum", 56);
         /* w = w / sum(w); */
         Mprhs_[0] = &w;
         Mplhs_[0] = &CM4_;
         mccCallMATLAB(1, Mplhs_, 1, Mprhs_, "sum", 57);
         mccRightDivide(&w, &w, &CM4_);
         /* end; */
      }
      /* if (~QUIET) */
      {
         int i_, j_;
         int m_=1, n_=1, cx_ = 0;
         unsigned short *p_BM0_;
         int I_BM0_=1;
         double *p_QUIET;
         int I_QUIET=1;
         double *q_QUIET;
         m_ = mcmCalcResultSize(m_, &n_, mccM(&QUIET), mccN(&QUIET));
         mccAllocateMatrix(&BM0_, m_, n_);
         I_BM0_ = (mccM(&BM0_) != 1 || mccN(&BM0_) != 1);
         p_BM0_ = mccSPR(&BM0_);
         I_QUIET = (mccM(&QUIET) != 1 || mccN(&QUIET) != 1);
         p_QUIET = mccPR(&QUIET);
         q_QUIET = mccPI(&QUIET);
         if (m_ != 0)
         {
            for (j_=0; j_<n_; ++j_)
            {
               for (i_=0; i_<m_; ++i_, p_BM0_+=I_BM0_, p_QUIET+=I_QUIET, q_QUIET+=I_QUIET)
               {
                  *p_BM0_ = !*p_QUIET&&!*q_QUIET;
               }
            }
         }
      }
      if (mccIfCondition(&BM0_))
      {
         /* time = cputime - time; fprintf(1, ' (%.2f s)\n', time); */
         Mplhs_[0] = 0;
         mccCallMATLAB(1, Mplhs_, 0, Mprhs_, "cputime", 60);
         R0_ = mccImportReal(0, 0, Mplhs_[ 0 ], 1, " (mix_par, line 60): R0_");
         time = (R0_ - time);
         Mprhs_[0] = mccTempMatrix(1, 0., mccINT, 0 );
         Mprhs_[1] = &S2_;
         Mprhs_[2] = mccTempMatrix(time, 0., mccREAL, 0 );
         Mplhs_[0] = 0;
         mccCallMATLAB(0, Mplhs_, 3, Mprhs_, "fprintf", 60);
         /* end; */
      }
      mccReturnFirstValue(&plhs_[0], &mu);
      mccReturnValue(&plhs_[1], &Sigma);
      mccReturnValue(&plhs_[2], &w);
   }
   else
   {
/***************** Compiler Assumptions ****************
 *
 *       B0_         	boolean scalar temporary
 *       BM0_        	boolean vector/matrix temporary
 *       DIAG_COV    	real vector/matrix
 *       I0_         	integer scalar temporary
 *       I1_         	integer scalar temporary
 *       IM0_        	integer vector/matrix temporary
 *       N           	integer scalar
 *       QUIET       	real vector/matrix
 *       R0_         	real scalar temporary
 *       RM0_        	real vector/matrix temporary
 *       RM1_        	real vector/matrix temporary
 *       RM2_        	real vector/matrix temporary
 *       RM3_        	real vector/matrix temporary
 *       RM4_        	real vector/matrix temporary
 *       RM5_        	real vector/matrix temporary
 *       Sigma       	real vector/matrix
 *       T           	integer scalar
 *       TM0_        	string vector/matrix temporary
 *       X           	real vector/matrix
 *       cputime     	<function>
 *       error       	<function>
 *       fprintf     	<function>
 *       gamma       	real vector/matrix
 *       i           	integer scalar
 *       j           	integer scalar
 *       length      	<function>
 *       mix_par     	<function being defined>
 *       mu          	real vector/matrix
 *       nargchk     	<function>
 *       nargin      	<function>
 *       nargout     	<function>
 *       ones        	<function>
 *       p           	integer scalar
 *       size        	<function>
 *       sum         	<function>
 *       time        	real scalar
 *       w           	real vector/matrix
 *       zeros       	<function>
 *******************************************************/
      mxArray mu;
      mxArray Sigma;
      mxArray w;
      mxArray X;
      mxArray gamma;
      mxArray DIAG_COV;
      mxArray QUIET;
      int T = 0;
      int N = 0;
      int p = 0;
      double time = 0.0;
      int i = 0;
      int j = 0;
      int I0_ = 0;
      mxArray TM0_;
      unsigned short B0_ = 0;
      mxArray RM0_;
      mxArray BM0_;
      mxArray IM0_;
      mxArray RM1_;
      mxArray RM2_;
      mxArray RM3_;
      int I1_ = 0;
      double R0_ = 0.0;
      mxArray RM4_;
      mxArray RM5_;
      
      mccRealInit(X);
      mccImport(&X, ((nrhs_>0) ? prhs_[0] : 0), 0, 0);
      mccRealInit(gamma);
      mccImport(&gamma, ((nrhs_>1) ? prhs_[1] : 0), 0, 0);
      mccRealInit(DIAG_COV);
      mccImport(&DIAG_COV, ((nrhs_>2) ? prhs_[2] : 0), 0, 0);
      mccRealInit(QUIET);
      mccImportCopy(&QUIET, ((nrhs_>3) ? prhs_[3] : 0), 0, 0);
      mccRealInit(mu);
      mccRealInit(Sigma);
      mccRealInit(w);
      mccTextInit(TM0_);
      mccRealInit(RM0_);
      mccBoolInit(BM0_);
      mccIntInit(IM0_);
      mccRealInit(RM1_);
      mccRealInit(RM2_);
      mccRealInit(RM3_);
      mccRealInit(RM4_);
      mccRealInit(RM5_);
      
      
      /* % mix_par   Reestimate mixture parameters. */
      /* % Use: [mu,Sigma,w] = mix_par(X,gamma,DIAG_COV). */
      /* % Note that mix_par can also be used for re-estimating HMM parameters */
      /* % from posterior state probabilities (w is omitted in this case). */
      
      /* % Version 1.3 */
      /* % Olivier Cappé, 25/03/96 - 17/03/97 */
      /* % ENST Dpt. Signal / CNRS URA 820, Paris */
      
      /* % Check input data */
      /* error(nargchk(3, 4, nargin)); */
      I0_ = mccNargin();
      Mprhs_[0] = mccTempMatrix(3, 0., mccINT, 0 );
      Mprhs_[1] = mccTempMatrix(4, 0., mccINT, 0 );
      Mprhs_[2] = mccTempMatrix(I0_, 0., mccINT, 0 );
      Mplhs_[0] = &TM0_;
      mccCallMATLAB(1, Mplhs_, 3, Mprhs_, "nargchk", 13);
      mccError(&TM0_);
      /* if (nargin < 4) */
      I0_ = mccNargin();
      B0_ = (I0_ < 4);
      if ((double)B0_)
      {
         /* QUIET = 0; */
         {
            double tr_ = 0;
            mccAllocateMatrix(&QUIET, 1, 1);
            *mccPR(&QUIET) = tr_;
         }
         /* end; */
      }
      /* [T, N] = size(gamma); */
      if(mccNOTSET(&gamma))
      {
         mexErrMsgTxt( "variable gamma undefined, line 17" );
      }
      mccGetMatrixSize(&T,&N, &gamma);
      /* if (length(X(:,1)) ~= T) */
      if(mccNOTSET(&X))
      {
         mexErrMsgTxt( "variable X undefined, line 18" );
      }
      {
         int i_, j_;
         int m_=1, n_=1, cx_ = 0;
         double *p_RM0_;
         int I_RM0_=1;
         double *p_X;
         int I_X=1, J_X;
         m_ = mcmCalcResultSize(m_, &n_, mccM(&X), 1);
         mccAllocateMatrix(&RM0_, m_, n_);
         mccCheckMatrixSize(&X, mccM(&X), 1);
         I_RM0_ = (mccM(&RM0_) != 1 || mccN(&RM0_) != 1);
         p_RM0_ = mccPR(&RM0_);
         if (mccM(&X) == 1) { I_X = J_X = 0;}
         else { I_X = 1; J_X=mccM(&X)-m_; }
         p_X = mccPR(&X) + 0 + mccM(&X) * (1-1);
         if (m_ != 0)
         {
            for (j_=0; j_<n_; ++j_, p_X += J_X)
            {
               for (i_=0; i_<m_; ++i_, p_RM0_+=I_RM0_, p_X+=I_X)
               {
                  *p_RM0_ = *p_X;
               }
            }
         }
      }
      I0_ = mccGetLength(&RM0_);
      B0_ = (I0_ != T);
      if ((double)B0_)
      {
         /* error('Check the number of observation vectors.'); */
         mccError(&S3_);
         /* end; */
      }
      /* p = length(X(1,:)); */
      {
         int i_, j_;
         int m_=1, n_=1, cx_ = 0;
         double *p_RM0_;
         int I_RM0_=1;
         double *p_X;
         int I_X=1, J_X;
         m_ = mcmCalcResultSize(m_, &n_, 1, mccN(&X));
         mccAllocateMatrix(&RM0_, m_, n_);
         mccCheckMatrixSize(&X, 1, mccN(&X));
         I_RM0_ = (mccM(&RM0_) != 1 || mccN(&RM0_) != 1);
         p_RM0_ = mccPR(&RM0_);
         if (mccN(&X) == 1) { I_X = J_X = 0;}
         else { I_X = 1; J_X=mccM(&X)-m_; }
         p_X = mccPR(&X) + (1-1) + mccM(&X) * 0;
         if (m_ != 0)
         {
            for (j_=0; j_<n_; ++j_, p_X += J_X)
            {
               for (i_=0; i_<m_; ++i_, p_RM0_+=I_RM0_, p_X+=I_X)
               {
                  *p_RM0_ = *p_X;
               }
            }
         }
      }
      p = mccGetLength(&RM0_);
      
      /* if (~QUIET) */
      if(mccNOTSET(&QUIET))
      {
         mexErrMsgTxt( "variable QUIET undefined, line 23" );
      }
      {
         int i_, j_;
         int m_=1, n_=1, cx_ = 0;
         unsigned short *p_BM0_;
         int I_BM0_=1;
         double *p_QUIET;
         int I_QUIET=1;
         m_ = mcmCalcResultSize(m_, &n_, mccM(&QUIET), mccN(&QUIET));
         mccAllocateMatrix(&BM0_, m_, n_);
         I_BM0_ = (mccM(&BM0_) != 1 || mccN(&BM0_) != 1);
         p_BM0_ = mccSPR(&BM0_);
         I_QUIET = (mccM(&QUIET) != 1 || mccN(&QUIET) != 1);
         p_QUIET = mccPR(&QUIET);
         if (m_ != 0)
         {
            for (j_=0; j_<n_; ++j_)
            {
               for (i_=0; i_<m_; ++i_, p_BM0_+=I_BM0_, p_QUIET+=I_QUIET)
               {
                  *p_BM0_ = (!*p_QUIET);
               }
            }
         }
      }
      if (mccIfCondition(&BM0_))
      {
         /* fprintf(1, 'Reestimating mixture parameters...'); time = cputime; */
         Mprhs_[0] = mccTempMatrix(1, 0., mccINT, 0 );
         Mprhs_[1] = &S4_;
         Mplhs_[0] = 0;
         mccCallMATLAB(0, Mplhs_, 2, Mprhs_, "fprintf", 24);
         Mplhs_[0] = 0;
         mccCallMATLAB(1, Mplhs_, 0, Mprhs_, "cputime", 24);
         time = mccImportReal(0, 0, Mplhs_[ 0 ], 1, " (mix_par, line 24): time");
         /* end; */
      }
      /* mu = zeros(N, p); */
      mccZerosMN(&mu, N, p);
      mccLOG(&mu) = 0;
      mccSTRING(&mu) = 0;
      /* if (DIAG_COV) */
      if(mccNOTSET(&DIAG_COV))
      {
         mexErrMsgTxt( "variable DIAG_COV undefined, line 27" );
      }
      if (mccIfCondition(&DIAG_COV))
      {
         /* Sigma = zeros(N, p); */
         mccZerosMN(&Sigma, N, p);
         /* for i=1:N */
         for (I0_ = 1; I0_ <= N; I0_ = I0_ + 1)
         {
            i = I0_;
            /* mu(i,:) = sum (X .* (gamma(:,i) * ones(1,p))); */
            {
               int i_, j_;
               int m_=1, n_=1, cx_ = 0;
               double *p_RM0_;
               int I_RM0_=1;
               double *p_gamma;
               int I_gamma=1, J_gamma;
               m_ = mcmCalcResultSize(m_, &n_, mccM(&gamma), 1);
               mccAllocateMatrix(&RM0_, m_, n_);
               mccCheckMatrixSize(&gamma, mccM(&gamma), i);
               I_RM0_ = (mccM(&RM0_) != 1 || mccN(&RM0_) != 1);
               p_RM0_ = mccPR(&RM0_);
               if (mccM(&gamma) == 1) { I_gamma = J_gamma = 0;}
               else { I_gamma = 1; J_gamma=mccM(&gamma)-m_; }
               p_gamma = mccPR(&gamma) + 0 + mccM(&gamma) * (i-1);
               if (m_ != 0)
               {
                  for (j_=0; j_<n_; ++j_, p_gamma += J_gamma)
                  {
                     for (i_=0; i_<m_; ++i_, p_RM0_+=I_RM0_, p_gamma+=I_gamma)
                     {
                        *p_RM0_ = *p_gamma;
                     }
                  }
               }
            }
            mccOnesMN(&IM0_, 1, p);
            mccRealMatrixMultiply(&RM1_, &RM0_, &IM0_);
            {
               int i_, j_;
               int m_=1, n_=1, cx_ = 0;
               double *p_RM2_;
               int I_RM2_=1;
               double *p_X;
               int I_X=1;
               double *p_RM1_;
               int I_RM1_=1;
               m_ = mcmCalcResultSize(m_, &n_, mccM(&X), mccN(&X));
               m_ = mcmCalcResultSize(m_, &n_, mccM(&RM1_), mccN(&RM1_));
               mccAllocateMatrix(&RM2_, m_, n_);
               I_RM2_ = (mccM(&RM2_) != 1 || mccN(&RM2_) != 1);
               p_RM2_ = mccPR(&RM2_);
               I_X = (mccM(&X) != 1 || mccN(&X) != 1);
               p_X = mccPR(&X);
               I_RM1_ = (mccM(&RM1_) != 1 || mccN(&RM1_) != 1);
               p_RM1_ = mccPR(&RM1_);
               if (m_ != 0)
               {
                  for (j_=0; j_<n_; ++j_)
                  {
                     for (i_=0; i_<m_; ++i_, p_RM2_+=I_RM2_, p_X+=I_X, p_RM1_+=I_RM1_)
                     {
                        *p_RM2_ = (*p_X * (double) *p_RM1_);
                     }
                  }
               }
            }
            mccSum(&RM3_, &RM2_);
            {
               int i_, j_;
               int m_=1, n_=1, cx_ = 0;
               double *p_mu;
               int I_mu=1, J_mu;
               double *p_RM3_;
               int I_RM3_=1;
               m_ = mcmCalcResultSize(m_, &n_, mccM(&RM3_), mccN(&RM3_));
               mccGrowMatrix(&mu, i, n_);
               if (mccN(&mu) == 1) { I_mu = J_mu = 0;}
               else { I_mu = 1; J_mu=mccM(&mu)-m_; }
               p_mu = mccPR(&mu) + (i-1) + mccM(&mu) * 0;
               I_RM3_ = (mccM(&RM3_) != 1 || mccN(&RM3_) != 1);
               p_RM3_ = mccPR(&RM3_);
               if (m_ != 0)
               {
                  for (j_=0; j_<n_; ++j_, p_mu += J_mu)
                  {
                     for (i_=0; i_<m_; ++i_, p_mu+=I_mu, p_RM3_+=I_RM3_)
                     {
                        *p_mu = *p_RM3_;
                     }
                  }
               }
            }
            /* Sigma(i,:) = sum(X.^2 .* (gamma(:,i) * ones(1,p))); */
            {
               int i_, j_;
               int m_=1, n_=1, cx_ = 0;
               double *p_RM3_;
               int I_RM3_=1;
               double *p_gamma;
               int I_gamma=1, J_gamma;
               m_ = mcmCalcResultSize(m_, &n_, mccM(&gamma), 1);
               mccAllocateMatrix(&RM3_, m_, n_);
               mccCheckMatrixSize(&gamma, mccM(&gamma), i);
               I_RM3_ = (mccM(&RM3_) != 1 || mccN(&RM3_) != 1);
               p_RM3_ = mccPR(&RM3_);
               if (mccM(&gamma) == 1) { I_gamma = J_gamma = 0;}
               else { I_gamma = 1; J_gamma=mccM(&gamma)-m_; }
               p_gamma = mccPR(&gamma) + 0 + mccM(&gamma) * (i-1);
               if (m_ != 0)
               {
                  for (j_=0; j_<n_; ++j_, p_gamma += J_gamma)
                  {
                     for (i_=0; i_<m_; ++i_, p_RM3_+=I_RM3_, p_gamma+=I_gamma)
                     {
                        *p_RM3_ = *p_gamma;
                     }
                  }
               }
            }
            mccOnesMN(&IM0_, 1, p);
            mccRealMatrixMultiply(&RM2_, &RM3_, &IM0_);
            {
               int i_, j_;
               int m_=1, n_=1, cx_ = 0;
               double *p_RM1_;
               int I_RM1_=1;
               double *p_X;
               int I_X=1;
               double *p_RM2_;
               int I_RM2_=1;
               m_ = mcmCalcResultSize(m_, &n_, mccM(&X), mccN(&X));
               m_ = mcmCalcResultSize(m_, &n_, mccM(&RM2_), mccN(&RM2_));
               mccAllocateMatrix(&RM1_, m_, n_);
               I_RM1_ = (mccM(&RM1_) != 1 || mccN(&RM1_) != 1);
               p_RM1_ = mccPR(&RM1_);
               I_X = (mccM(&X) != 1 || mccN(&X) != 1);
               p_X = mccPR(&X);
               I_RM2_ = (mccM(&RM2_) != 1 || mccN(&RM2_) != 1);
               p_RM2_ = mccPR(&RM2_);
               if (m_ != 0)
               {
                  for (j_=0; j_<n_; ++j_)
                  {
                     for (i_=0; i_<m_; ++i_, p_RM1_+=I_RM1_, p_X+=I_X, p_RM2_+=I_RM2_)
                     {
                        *p_RM1_ = (mcmRealPowerInt(*p_X, 2) * (double) *p_RM2_);
                     }
                  }
               }
            }
            mccSum(&RM0_, &RM1_);
            {
               int i_, j_;
               int m_=1, n_=1, cx_ = 0;
               double *p_Sigma;
               int I_Sigma=1, J_Sigma;
               double *p_RM0_;
               int I_RM0_=1;
               m_ = mcmCalcResultSize(m_, &n_, mccM(&RM0_), mccN(&RM0_));
               mccGrowMatrix(&Sigma, i, n_);
               if (mccN(&Sigma) == 1) { I_Sigma = J_Sigma = 0;}
               else { I_Sigma = 1; J_Sigma=mccM(&Sigma)-m_; }
               p_Sigma = mccPR(&Sigma) + (i-1) + mccM(&Sigma) * 0;
               I_RM0_ = (mccM(&RM0_) != 1 || mccN(&RM0_) != 1);
               p_RM0_ = mccPR(&RM0_);
               if (m_ != 0)
               {
                  for (j_=0; j_<n_; ++j_, p_Sigma += J_Sigma)
                  {
                     for (i_=0; i_<m_; ++i_, p_Sigma+=I_Sigma, p_RM0_+=I_RM0_)
                     {
                        *p_Sigma = *p_RM0_;
                     }
                  }
               }
            }
            /* end; */
         }
         /* % Normalization */
         /* mu = mu ./ (sum(gamma)' * ones(1,p)); */
         mccSum(&RM0_, &gamma);
         mccConjTrans(&RM1_, &RM0_);
         mccOnesMN(&IM0_, 1, p);
         mccRealMatrixMultiply(&RM2_, &RM1_, &IM0_);
         {
            int i_, j_;
            int m_=1, n_=1, cx_ = 0;
            double *p_mu;
            int I_mu=1;
            double *p_1mu;
            int I_1mu=1;
            double *p_RM2_;
            int I_RM2_=1;
            m_ = mcmCalcResultSize(m_, &n_, mccM(&mu), mccN(&mu));
            m_ = mcmCalcResultSize(m_, &n_, mccM(&RM2_), mccN(&RM2_));
            mccAllocateMatrix(&mu, m_, n_);
            I_mu = (mccM(&mu) != 1 || mccN(&mu) != 1);
            p_mu = mccPR(&mu);
            I_1mu = (mccM(&mu) != 1 || mccN(&mu) != 1);
            p_1mu = mccPR(&mu);
            I_RM2_ = (mccM(&RM2_) != 1 || mccN(&RM2_) != 1);
            p_RM2_ = mccPR(&RM2_);
            if (m_ != 0)
            {
               for (j_=0; j_<n_; ++j_)
               {
                  for (i_=0; i_<m_; ++i_, p_mu+=I_mu, p_1mu+=I_1mu, p_RM2_+=I_RM2_)
                  {
                     *p_mu = (*p_1mu / (double) *p_RM2_);
                  }
               }
            }
         }
         mccLOG(&mu) = 0;
         mccSTRING(&mu) = 0;
         /* Sigma = Sigma ./ (sum(gamma)' * ones(1,p)); */
         mccSum(&RM2_, &gamma);
         mccConjTrans(&RM1_, &RM2_);
         mccOnesMN(&IM0_, 1, p);
         mccRealMatrixMultiply(&RM0_, &RM1_, &IM0_);
         {
            int i_, j_;
            int m_=1, n_=1, cx_ = 0;
            double *p_Sigma;
            int I_Sigma=1;
            double *p_1Sigma;
            int I_1Sigma=1;
            double *p_RM0_;
            int I_RM0_=1;
            m_ = mcmCalcResultSize(m_, &n_, mccM(&Sigma), mccN(&Sigma));
            m_ = mcmCalcResultSize(m_, &n_, mccM(&RM0_), mccN(&RM0_));
            mccAllocateMatrix(&Sigma, m_, n_);
            I_Sigma = (mccM(&Sigma) != 1 || mccN(&Sigma) != 1);
            p_Sigma = mccPR(&Sigma);
            I_1Sigma = (mccM(&Sigma) != 1 || mccN(&Sigma) != 1);
            p_1Sigma = mccPR(&Sigma);
            I_RM0_ = (mccM(&RM0_) != 1 || mccN(&RM0_) != 1);
            p_RM0_ = mccPR(&RM0_);
            if (m_ != 0)
            {
               for (j_=0; j_<n_; ++j_)
               {
                  for (i_=0; i_<m_; ++i_, p_Sigma+=I_Sigma, p_1Sigma+=I_1Sigma, p_RM0_+=I_RM0_)
                  {
                     *p_Sigma = (*p_1Sigma / (double) *p_RM0_);
                  }
               }
            }
         }
         /* % Sigma */
         /* Sigma = Sigma - mu.^2; */
         {
            int i_, j_;
            int m_=1, n_=1, cx_ = 0;
            double *p_Sigma;
            int I_Sigma=1;
            double *p_1Sigma;
            int I_1Sigma=1;
            double *p_mu;
            int I_mu=1;
            m_ = mcmCalcResultSize(m_, &n_, mccM(&Sigma), mccN(&Sigma));
            m_ = mcmCalcResultSize(m_, &n_, mccM(&mu), mccN(&mu));
            mccAllocateMatrix(&Sigma, m_, n_);
            I_Sigma = (mccM(&Sigma) != 1 || mccN(&Sigma) != 1);
            p_Sigma = mccPR(&Sigma);
            I_1Sigma = (mccM(&Sigma) != 1 || mccN(&Sigma) != 1);
            p_1Sigma = mccPR(&Sigma);
            I_mu = (mccM(&mu) != 1 || mccN(&mu) != 1);
            p_mu = mccPR(&mu);
            if (m_ != 0)
            {
               for (j_=0; j_<n_; ++j_)
               {
                  for (i_=0; i_<m_; ++i_, p_Sigma+=I_Sigma, p_1Sigma+=I_1Sigma, p_mu+=I_mu)
                  {
                     *p_Sigma = (*p_1Sigma - mcmRealPowerInt(*p_mu, 2));
                  }
               }
            }
         }
         mccLOG(&Sigma) = 0;
         mccSTRING(&Sigma) = 0;
      }
      else
      {
         /* else */
         /* Sigma = zeros(N*p, p); */
         mccZerosMN(&Sigma, ((int)(N * (double) p)), p);
         mccLOG(&Sigma) = 0;
         mccSTRING(&Sigma) = 0;
         /* for i = 1:N */
         for (I0_ = 1; I0_ <= N; I0_ = I0_ + 1)
         {
            i = I0_;
            /* for j = 1:T */
            for (I1_ = 1; I1_ <= T; I1_ = I1_ + 1)
            {
               j = I1_;
               /* mu(i,:) = mu(i,:) + gamma(j,i)*X(j,:); */
               R0_ = (mccGetRealMatrixElement(&gamma, mccRint(j), mccRint(i)));
               {
                  int i_, j_;
                  int m_=1, n_=1, cx_ = 0;
                  double *p_mu;
                  int I_mu=1, J_mu;
                  double *p_1mu;
                  int I_1mu=1, J_1mu;
                  double *p_X;
                  int I_X=1, J_X;
                  m_ = mcmCalcResultSize(m_, &n_, 1, mccN(&mu));
                  m_ = mcmCalcResultSize(m_, &n_, 1, mccN(&X));
                  mccGrowMatrix(&mu, i, n_);
                  mccCheckMatrixSize(&mu, i, mccN(&mu));
                  mccCheckMatrixSize(&X, j, mccN(&X));
                  if (mccN(&mu) == 1) { I_mu = J_mu = 0;}
                  else { I_mu = 1; J_mu=mccM(&mu)-m_; }
                  p_mu = mccPR(&mu) + (i-1) + mccM(&mu) * 0;
                  if (mccN(&mu) == 1) { I_1mu = J_1mu = 0;}
                  else { I_1mu = 1; J_1mu=mccM(&mu)-m_; }
                  p_1mu = mccPR(&mu) + (i-1) + mccM(&mu) * 0;
                  if (mccN(&X) == 1) { I_X = J_X = 0;}
                  else { I_X = 1; J_X=mccM(&X)-m_; }
                  p_X = mccPR(&X) + (j-1) + mccM(&X) * 0;
                  if (m_ != 0)
                  {
                     for (j_=0; j_<n_; ++j_, p_mu += J_mu, p_1mu += J_1mu, p_X += J_X)
                     {
                        for (i_=0; i_<m_; ++i_, p_mu+=I_mu, p_1mu+=I_1mu, p_X+=I_X)
                        {
                           *p_mu = (*p_1mu + (R0_ * (double) *p_X));
                        }
                     }
                  }
               }
               /* Sigma(((1+(i-1)*p):(i*p)),:) = Sigma(((1+(i-1)*p):(i*p)),:)... */
               mccColon2(&RM1_, (1 + ((i - 1) * (double) p)), (i * (double) p));
               R0_ = (mccGetRealMatrixElement(&gamma, mccRint(j), mccRint(i)));
               {
                  int i_, j_;
                  int m_=1, n_=1, cx_ = 0;
                  double *p_RM2_;
                  int I_RM2_=1;
                  double *p_X;
                  int I_X=1, J_X;
                  m_ = mcmCalcResultSize(m_, &n_, 1, mccN(&X));
                  mccAllocateMatrix(&RM2_, m_, n_);
                  mccCheckMatrixSize(&X, j, mccN(&X));
                  I_RM2_ = (mccM(&RM2_) != 1 || mccN(&RM2_) != 1);
                  p_RM2_ = mccPR(&RM2_);
                  if (mccN(&X) == 1) { I_X = J_X = 0;}
                  else { I_X = 1; J_X=mccM(&X)-m_; }
                  p_X = mccPR(&X) + (j-1) + mccM(&X) * 0;
                  if (m_ != 0)
                  {
                     for (j_=0; j_<n_; ++j_, p_X += J_X)
                     {
                        for (i_=0; i_<m_; ++i_, p_RM2_+=I_RM2_, p_X+=I_X)
                        {
                           *p_RM2_ = *p_X;
                        }
                     }
                  }
               }
               mccConjTrans(&RM3_, &RM2_);
               {
                  int i_, j_;
                  int m_=1, n_=1, cx_ = 0;
                  double *p_RM4_;
                  int I_RM4_=1;
                  double *p_X;
                  int I_X=1, J_X;
                  m_ = mcmCalcResultSize(m_, &n_, 1, mccN(&X));
                  mccAllocateMatrix(&RM4_, m_, n_);
                  mccCheckMatrixSize(&X, j, mccN(&X));
                  I_RM4_ = (mccM(&RM4_) != 1 || mccN(&RM4_) != 1);
                  p_RM4_ = mccPR(&RM4_);
                  if (mccN(&X) == 1) { I_X = J_X = 0;}
                  else { I_X = 1; J_X=mccM(&X)-m_; }
                  p_X = mccPR(&X) + (j-1) + mccM(&X) * 0;
                  if (m_ != 0)
                  {
                     for (j_=0; j_<n_; ++j_, p_X += J_X)
                     {
                        for (i_=0; i_<m_; ++i_, p_RM4_+=I_RM4_, p_X+=I_X)
                        {
                           *p_RM4_ = *p_X;
                        }
                     }
                  }
               }
               mccRealMatrixMultiply(&RM5_, &RM3_, &RM4_);
               mccColon2(&RM0_, (1 + ((i - 1) * (double) p)), (i * (double) p));
               {
                  int i_, j_;
                  int m_=1, n_=1, cx_ = 0;
                  double *p_Sigma;
                  int I_Sigma=1, J_Sigma;
                  double *p_RM0_;
                  int I_RM0_=1;
                  double *p_1Sigma;
                  int I_1Sigma=1, J_1Sigma;
                  double *p_RM1_;
                  int I_RM1_=1;
                  double *p_RM5_;
                  int I_RM5_=1;
                  m_ = mcmCalcResultSize(m_, &n_, (mccM(&RM1_) * mccN(&RM1_)), mccN(&Sigma));
                  m_ = mcmCalcResultSize(m_, &n_, mccM(&RM5_), mccN(&RM5_));
                  mccGrowMatrix(&Sigma, mccGetMaxIndex(&RM0_ ,mccM(&Sigma)), n_);
                  mccCheckMatrixSize(&Sigma, mccGetMaxIndex(&RM1_ ,mccM(&Sigma)), mccN(&Sigma));
                  J_Sigma = ((mccM(&Sigma) != 1 || mccN(&Sigma) != 1) ? mccM(&Sigma) : 0);
                  p_Sigma = mccPR(&Sigma) + mccM(&Sigma) * 0;
                  I_RM0_ = (mccM(&RM0_) != 1 || mccN(&RM0_) != 1);
                  J_1Sigma = ((mccM(&Sigma) != 1 || mccN(&Sigma) != 1) ? mccM(&Sigma) : 0);
                  p_1Sigma = mccPR(&Sigma) + mccM(&Sigma) * 0;
                  I_RM1_ = (mccM(&RM1_) != 1 || mccN(&RM1_) != 1);
                  I_RM5_ = (mccM(&RM5_) != 1 || mccN(&RM5_) != 1);
                  p_RM5_ = mccPR(&RM5_);
                  if (m_ != 0)
                  {
                     for (j_=0; j_<n_; ++j_, p_Sigma += J_Sigma, p_1Sigma += J_1Sigma)
                     {
                        p_RM0_ = mccPR(&RM0_);
                        p_RM1_ = mccPR(&RM1_);
                        for (i_=0; i_<m_; ++i_, p_RM0_+=I_RM0_, p_RM1_+=I_RM1_, p_RM5_+=I_RM5_)
                        {
                           p_Sigma[((int)(*p_RM0_ - .5))] = (p_1Sigma[((int)(*p_RM1_ - .5))] + (R0_ * (double) *p_RM5_));
                        }
                     }
                  }
               }
               /* end; */
            }
            /* % Normalization */
            /* mu(i,:) = mu(i,:)/sum(gamma(:,i)); */
            {
               int i_, j_;
               int m_=1, n_=1, cx_ = 0;
               double *p_RM5_;
               int I_RM5_=1;
               double *p_mu;
               int I_mu=1, J_mu;
               m_ = mcmCalcResultSize(m_, &n_, 1, mccN(&mu));
               mccAllocateMatrix(&RM5_, m_, n_);
               mccCheckMatrixSize(&mu, i, mccN(&mu));
               I_RM5_ = (mccM(&RM5_) != 1 || mccN(&RM5_) != 1);
               p_RM5_ = mccPR(&RM5_);
               if (mccN(&mu) == 1) { I_mu = J_mu = 0;}
               else { I_mu = 1; J_mu=mccM(&mu)-m_; }
               p_mu = mccPR(&mu) + (i-1) + mccM(&mu) * 0;
               if (m_ != 0)
               {
                  for (j_=0; j_<n_; ++j_, p_mu += J_mu)
                  {
                     for (i_=0; i_<m_; ++i_, p_RM5_+=I_RM5_, p_mu+=I_mu)
                     {
                        *p_RM5_ = *p_mu;
                     }
                  }
               }
            }
            {
               int i_, j_;
               int m_=1, n_=1, cx_ = 0;
               double *p_RM4_;
               int I_RM4_=1;
               double *p_gamma;
               int I_gamma=1, J_gamma;
               m_ = mcmCalcResultSize(m_, &n_, mccM(&gamma), 1);
               mccAllocateMatrix(&RM4_, m_, n_);
               mccCheckMatrixSize(&gamma, mccM(&gamma), i);
               I_RM4_ = (mccM(&RM4_) != 1 || mccN(&RM4_) != 1);
               p_RM4_ = mccPR(&RM4_);
               if (mccM(&gamma) == 1) { I_gamma = J_gamma = 0;}
               else { I_gamma = 1; J_gamma=mccM(&gamma)-m_; }
               p_gamma = mccPR(&gamma) + 0 + mccM(&gamma) * (i-1);
               if (m_ != 0)
               {
                  for (j_=0; j_<n_; ++j_, p_gamma += J_gamma)
                  {
                     for (i_=0; i_<m_; ++i_, p_RM4_+=I_RM4_, p_gamma+=I_gamma)
                     {
                        *p_RM4_ = *p_gamma;
                     }
                  }
               }
            }
            mccSum(&RM3_, &RM4_);
            mccRealRightDivide(&RM2_, &RM5_, &RM3_);
            {
               int i_, j_;
               int m_=1, n_=1, cx_ = 0;
               double *p_mu;
               int I_mu=1, J_mu;
               double *p_RM2_;
               int I_RM2_=1;
               m_ = mcmCalcResultSize(m_, &n_, mccM(&RM2_), mccN(&RM2_));
               mccGrowMatrix(&mu, i, n_);
               if (mccN(&mu) == 1) { I_mu = J_mu = 0;}
               else { I_mu = 1; J_mu=mccM(&mu)-m_; }
               p_mu = mccPR(&mu) + (i-1) + mccM(&mu) * 0;
               I_RM2_ = (mccM(&RM2_) != 1 || mccN(&RM2_) != 1);
               p_RM2_ = mccPR(&RM2_);
               if (m_ != 0)
               {
                  for (j_=0; j_<n_; ++j_, p_mu += J_mu)
                  {
                     for (i_=0; i_<m_; ++i_, p_mu+=I_mu, p_RM2_+=I_RM2_)
                     {
                        *p_mu = *p_RM2_;
                     }
                  }
               }
            }
            /* Sigma(((1+(i-1)*p):(i*p)),:) = Sigma(((1+(i-1)*p):(i*p)),:) /sum(gamma(:,i)); */
            mccColon2(&RM3_, (1 + ((i - 1) * (double) p)), (i * (double) p));
            mccFindIndex(&IM0_, &RM3_);
            {
               int i_, j_;
               int m_=1, n_=1, cx_ = 0;
               double *p_RM4_;
               int I_RM4_=1;
               double *p_Sigma;
               int I_Sigma=1, J_Sigma;
               int *p_IM0_;
               int I_IM0_=1;
               m_ = mcmCalcResultSize(m_, &n_, (mccM(&IM0_) * mccN(&IM0_)), mccN(&Sigma));
               mccAllocateMatrix(&RM4_, m_, n_);
               mccCheckMatrixSize(&Sigma, mccGetMaxIndex(&IM0_ ,mccM(&Sigma)), mccN(&Sigma));
               I_RM4_ = (mccM(&RM4_) != 1 || mccN(&RM4_) != 1);
               p_RM4_ = mccPR(&RM4_);
               J_Sigma = ((mccM(&Sigma) != 1 || mccN(&Sigma) != 1) ? mccM(&Sigma) : 0);
               p_Sigma = mccPR(&Sigma) + mccM(&Sigma) * 0;
               I_IM0_ = (mccM(&IM0_) != 1 || mccN(&IM0_) != 1);
               if (m_ != 0)
               {
                  for (j_=0; j_<n_; ++j_, p_Sigma += J_Sigma)
                  {
                     p_IM0_ = mccIPR(&IM0_);
                     for (i_=0; i_<m_; ++i_, p_RM4_+=I_RM4_, p_IM0_+=I_IM0_)
                     {
                        *p_RM4_ = p_Sigma[((int)(*p_IM0_ - .5))];
                     }
                  }
               }
            }
            {
               int i_, j_;
               int m_=1, n_=1, cx_ = 0;
               double *p_RM5_;
               int I_RM5_=1;
               double *p_gamma;
               int I_gamma=1, J_gamma;
               m_ = mcmCalcResultSize(m_, &n_, mccM(&gamma), 1);
               mccAllocateMatrix(&RM5_, m_, n_);
               mccCheckMatrixSize(&gamma, mccM(&gamma), i);
               I_RM5_ = (mccM(&RM5_) != 1 || mccN(&RM5_) != 1);
               p_RM5_ = mccPR(&RM5_);
               if (mccM(&gamma) == 1) { I_gamma = J_gamma = 0;}
               else { I_gamma = 1; J_gamma=mccM(&gamma)-m_; }
               p_gamma = mccPR(&gamma) + 0 + mccM(&gamma) * (i-1);
               if (m_ != 0)
               {
                  for (j_=0; j_<n_; ++j_, p_gamma += J_gamma)
                  {
                     for (i_=0; i_<m_; ++i_, p_RM5_+=I_RM5_, p_gamma+=I_gamma)
                     {
                        *p_RM5_ = *p_gamma;
                     }
                  }
               }
            }
            mccSum(&RM1_, &RM5_);
            mccRealRightDivide(&RM0_, &RM4_, &RM1_);
            mccColon2(&RM2_, (1 + ((i - 1) * (double) p)), (i * (double) p));
            {
               int i_, j_;
               int m_=1, n_=1, cx_ = 0;
               double *p_Sigma;
               int I_Sigma=1, J_Sigma;
               double *p_RM2_;
               int I_RM2_=1;
               double *p_RM0_;
               int I_RM0_=1;
               m_ = mcmCalcResultSize(m_, &n_, mccM(&RM0_), mccN(&RM0_));
               mccGrowMatrix(&Sigma, mccGetMaxIndex(&RM2_ ,mccM(&Sigma)), n_);
               J_Sigma = ((mccM(&Sigma) != 1 || mccN(&Sigma) != 1) ? mccM(&Sigma) : 0);
               p_Sigma = mccPR(&Sigma) + mccM(&Sigma) * 0;
               I_RM2_ = (mccM(&RM2_) != 1 || mccN(&RM2_) != 1);
               I_RM0_ = (mccM(&RM0_) != 1 || mccN(&RM0_) != 1);
               p_RM0_ = mccPR(&RM0_);
               if (m_ != 0)
               {
                  for (j_=0; j_<n_; ++j_, p_Sigma += J_Sigma)
                  {
                     p_RM2_ = mccPR(&RM2_);
                     for (i_=0; i_<m_; ++i_, p_RM2_+=I_RM2_, p_RM0_+=I_RM0_)
                     {
                        p_Sigma[((int)(*p_RM2_ - .5))] = *p_RM0_;
                     }
                  }
               }
            }
            /* % Sigma */
            /* Sigma(((1+(i-1)*p):(i*p)),:) = Sigma(((1+(i-1)*p):(i*p)),:)... */
            mccColon2(&RM1_, (1 + ((i - 1) * (double) p)), (i * (double) p));
            {
               int i_, j_;
               int m_=1, n_=1, cx_ = 0;
               double *p_RM5_;
               int I_RM5_=1;
               double *p_mu;
               int I_mu=1, J_mu;
               m_ = mcmCalcResultSize(m_, &n_, 1, mccN(&mu));
               mccAllocateMatrix(&RM5_, m_, n_);
               mccCheckMatrixSize(&mu, i, mccN(&mu));
               I_RM5_ = (mccM(&RM5_) != 1 || mccN(&RM5_) != 1);
               p_RM5_ = mccPR(&RM5_);
               if (mccN(&mu) == 1) { I_mu = J_mu = 0;}
               else { I_mu = 1; J_mu=mccM(&mu)-m_; }
               p_mu = mccPR(&mu) + (i-1) + mccM(&mu) * 0;
               if (m_ != 0)
               {
                  for (j_=0; j_<n_; ++j_, p_mu += J_mu)
                  {
                     for (i_=0; i_<m_; ++i_, p_RM5_+=I_RM5_, p_mu+=I_mu)
                     {
                        *p_RM5_ = *p_mu;
                     }
                  }
               }
            }
            mccConjTrans(&RM4_, &RM5_);
            {
               int i_, j_;
               int m_=1, n_=1, cx_ = 0;
               double *p_RM3_;
               int I_RM3_=1;
               double *p_mu;
               int I_mu=1, J_mu;
               m_ = mcmCalcResultSize(m_, &n_, 1, mccN(&mu));
               mccAllocateMatrix(&RM3_, m_, n_);
               mccCheckMatrixSize(&mu, i, mccN(&mu));
               I_RM3_ = (mccM(&RM3_) != 1 || mccN(&RM3_) != 1);
               p_RM3_ = mccPR(&RM3_);
               if (mccN(&mu) == 1) { I_mu = J_mu = 0;}
               else { I_mu = 1; J_mu=mccM(&mu)-m_; }
               p_mu = mccPR(&mu) + (i-1) + mccM(&mu) * 0;
               if (m_ != 0)
               {
                  for (j_=0; j_<n_; ++j_, p_mu += J_mu)
                  {
                     for (i_=0; i_<m_; ++i_, p_RM3_+=I_RM3_, p_mu+=I_mu)
                     {
                        *p_RM3_ = *p_mu;
                     }
                  }
               }
            }
            mccRealMatrixMultiply(&RM2_, &RM4_, &RM3_);
            mccColon2(&RM0_, (1 + ((i - 1) * (double) p)), (i * (double) p));
            {
               int i_, j_;
               int m_=1, n_=1, cx_ = 0;
               double *p_Sigma;
               int I_Sigma=1, J_Sigma;
               double *p_RM0_;
               int I_RM0_=1;
               double *p_1Sigma;
               int I_1Sigma=1, J_1Sigma;
               double *p_RM1_;
               int I_RM1_=1;
               double *p_RM2_;
               int I_RM2_=1;
               m_ = mcmCalcResultSize(m_, &n_, (mccM(&RM1_) * mccN(&RM1_)), mccN(&Sigma));
               m_ = mcmCalcResultSize(m_, &n_, mccM(&RM2_), mccN(&RM2_));
               mccGrowMatrix(&Sigma, mccGetMaxIndex(&RM0_ ,mccM(&Sigma)), n_);
               mccCheckMatrixSize(&Sigma, mccGetMaxIndex(&RM1_ ,mccM(&Sigma)), mccN(&Sigma));
               J_Sigma = ((mccM(&Sigma) != 1 || mccN(&Sigma) != 1) ? mccM(&Sigma) : 0);
               p_Sigma = mccPR(&Sigma) + mccM(&Sigma) * 0;
               I_RM0_ = (mccM(&RM0_) != 1 || mccN(&RM0_) != 1);
               J_1Sigma = ((mccM(&Sigma) != 1 || mccN(&Sigma) != 1) ? mccM(&Sigma) : 0);
               p_1Sigma = mccPR(&Sigma) + mccM(&Sigma) * 0;
               I_RM1_ = (mccM(&RM1_) != 1 || mccN(&RM1_) != 1);
               I_RM2_ = (mccM(&RM2_) != 1 || mccN(&RM2_) != 1);
               p_RM2_ = mccPR(&RM2_);
               if (m_ != 0)
               {
                  for (j_=0; j_<n_; ++j_, p_Sigma += J_Sigma, p_1Sigma += J_1Sigma)
                  {
                     p_RM0_ = mccPR(&RM0_);
                     p_RM1_ = mccPR(&RM1_);
                     for (i_=0; i_<m_; ++i_, p_RM0_+=I_RM0_, p_RM1_+=I_RM1_, p_RM2_+=I_RM2_)
                     {
                        p_Sigma[((int)(*p_RM0_ - .5))] = (p_1Sigma[((int)(*p_RM1_ - .5))] - *p_RM2_);
                     }
                  }
               }
            }
            /* end; */
         }
         /* end; */
      }
      /* % Mixture proportions */
      /* if (nargout > 2) */
      I0_ = mccNargout();
      B0_ = (I0_ > 2);
      if ((double)B0_)
      {
         /* w = sum(gamma); */
         mccSum(&w, &gamma);
         /* w = w / sum(w); */
         mccSum(&RM2_, &w);
         mccRealRightDivide(&w, &w, &RM2_);
         /* end; */
      }
      /* if (~QUIET) */
      {
         int i_, j_;
         int m_=1, n_=1, cx_ = 0;
         unsigned short *p_BM0_;
         int I_BM0_=1;
         double *p_QUIET;
         int I_QUIET=1;
         m_ = mcmCalcResultSize(m_, &n_, mccM(&QUIET), mccN(&QUIET));
         mccAllocateMatrix(&BM0_, m_, n_);
         I_BM0_ = (mccM(&BM0_) != 1 || mccN(&BM0_) != 1);
         p_BM0_ = mccSPR(&BM0_);
         I_QUIET = (mccM(&QUIET) != 1 || mccN(&QUIET) != 1);
         p_QUIET = mccPR(&QUIET);
         if (m_ != 0)
         {
            for (j_=0; j_<n_; ++j_)
            {
               for (i_=0; i_<m_; ++i_, p_BM0_+=I_BM0_, p_QUIET+=I_QUIET)
               {
                  *p_BM0_ = (!*p_QUIET);
               }
            }
         }
      }
      if (mccIfCondition(&BM0_))
      {
         /* time = cputime - time; fprintf(1, ' (%.2f s)\n', time); */
         Mplhs_[0] = 0;
         mccCallMATLAB(1, Mplhs_, 0, Mprhs_, "cputime", 60);
         R0_ = mccImportReal(0, 0, Mplhs_[ 0 ], 1, " (mix_par, line 60): R0_");
         time = (R0_ - time);
         Mprhs_[0] = mccTempMatrix(1, 0., mccINT, 0 );
         Mprhs_[1] = &S5_;
         Mprhs_[2] = mccTempMatrix(time, 0., mccREAL, 0 );
         Mplhs_[0] = 0;
         mccCallMATLAB(0, Mplhs_, 3, Mprhs_, "fprintf", 60);
         /* end; */
      }
      mccReturnFirstValue(&plhs_[0], &mu);
      mccReturnValue(&plhs_[1], &Sigma);
      mccReturnValue(&plhs_[2], &w);
   }
   return;
}
