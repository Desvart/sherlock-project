static char mc_version[] = "MATLAB Compiler 1.2 Jan 17 1998 infun";
/*
 *  MATLAB Compiler: 1.2
 *  Date: Jan 17 1998
 *  Arguments: estimate 
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

/* static array S0_ (1 x 60) text, line 18: 'estimate: class %d contai...' */
static unsigned short S0__r_[] =
{
        101,  115,  116,  105,  109,   97,  116,  101,
         58,   32,   99,  108,   97,  115,  115,   32,
         37,  100,   32,   99,  111,  110,  116,   97,
        105,  110,  115,   32,  110,  111,   32,  100,
         97,  116,   97,   33,   32,   32,   69,  115,
        116,  105,  109,   97,  116,  101,  115,   32,
        115,  101,  116,   32,  116,  111,   32,   78,
         97,   78,   92,  110,
};
static mxArray S0_ = mccCINIT( mccTEXT,  1, 60, S0__r_, 0);
/* static array S1_ (1 x 41) text, line 22: 'estimate: class %d contai...' */
static unsigned short S1__r_[] =
{
        101,  115,  116,  105,  109,   97,  116,  101,
         58,   32,   99,  108,   97,  115,  115,   32,
         37,  100,   32,   99,  111,  110,  116,   97,
        105,  110,  115,   32,  111,  110,  101,   32,
        118,  101,   99,  116,  111,  114,   33,   92,
        110,
};
static mxArray S1_ = mccCINIT( mccTEXT,  1, 41, S1__r_, 0);
/* static array S2_ (1 x 58) text, line 27: 'estimate: class %d contai...' */
static unsigned short S2__r_[] =
{
        101,  115,  116,  105,  109,   97,  116,  101,
         58,   32,   99,  108,   97,  115,  115,   32,
         37,  100,   32,   99,  111,  110,  116,   97,
        105,  110,  115,   32,   37,  100,   32,  118,
        101,   99,  116,  111,  114,  115,   32,  105,
        110,   32,   37,  100,   32,  100,  105,  109,
        101,  110,  115,  105,  111,  110,  115,   33,
         92,  110,
};
static mxArray S2_ = mccCINIT( mccTEXT,  1, 58, S2__r_, 0);
/* static array S3_ (1 x 60) text, line 18: 'estimate: class %d contai...' */
static unsigned short S3__r_[] =
{
        101,  115,  116,  105,  109,   97,  116,  101,
         58,   32,   99,  108,   97,  115,  115,   32,
         37,  100,   32,   99,  111,  110,  116,   97,
        105,  110,  115,   32,  110,  111,   32,  100,
         97,  116,   97,   33,   32,   32,   69,  115,
        116,  105,  109,   97,  116,  101,  115,   32,
        115,  101,  116,   32,  116,  111,   32,   78,
         97,   78,   92,  110,
};
static mxArray S3_ = mccCINIT( mccTEXT,  1, 60, S3__r_, 0);
/* static array S4_ (1 x 41) text, line 22: 'estimate: class %d contai...' */
static unsigned short S4__r_[] =
{
        101,  115,  116,  105,  109,   97,  116,  101,
         58,   32,   99,  108,   97,  115,  115,   32,
         37,  100,   32,   99,  111,  110,  116,   97,
        105,  110,  115,   32,  111,  110,  101,   32,
        118,  101,   99,  116,  111,  114,   33,   92,
        110,
};
static mxArray S4_ = mccCINIT( mccTEXT,  1, 41, S4__r_, 0);
/* static array S5_ (1 x 58) text, line 27: 'estimate: class %d contai...' */
static unsigned short S5__r_[] =
{
        101,  115,  116,  105,  109,   97,  116,  101,
         58,   32,   99,  108,   97,  115,  115,   32,
         37,  100,   32,   99,  111,  110,  116,   97,
        105,  110,  115,   32,   37,  100,   32,  118,
        101,   99,  116,  111,  114,  115,   32,  105,
        110,   32,   37,  100,   32,  100,  105,  109,
        101,  110,  115,  105,  111,  110,  115,   33,
         92,  110,
};
static mxArray S5_ = mccCINIT( mccTEXT,  1, 58, S5__r_, 0);
/***************** Compiler Assumptions ****************
 *
 *       B0_         	boolean scalar temporary
 *       BM0_        	boolean vector/matrix temporary
 *       CM0_        	complex vector/matrix temporary
 *       CM1_        	complex vector/matrix temporary
 *       CM2_        	complex vector/matrix temporary
 *       CM3_        	complex vector/matrix temporary
 *       I0_         	integer scalar temporary
 *       I1_         	integer scalar temporary
 *       IM0_        	integer vector/matrix temporary
 *       IM1_        	integer vector/matrix temporary
 *       K           	complex vector/matrix
 *       M           	integer scalar
 *       NaN         	<function>
 *       R0_         	real scalar temporary
 *       c           	complex vector/matrix
 *       cov         	<function>
 *       estimate    	<function being defined>
 *       find        	<function>
 *       fprintf     	<function>
 *       i           	integer scalar
 *       length      	<function>
 *       m           	complex vector/matrix
 *       max         	<function>
 *       mean        	<function>
 *       member      	complex vector/matrix
 *       ones        	<function>
 *       reshape     	<function>
 *       size        	<function>
 *       x           	complex vector/matrix
 *       y           	integer vector/matrix
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
   mxArray *Mplhs_[2];
   mxArray *Mprhs_[4];
   

   if (nrhs_ > 2 )
   {
      mexErrMsgTxt( "Too many input arguments." );
   }

   if (nlhs_ > 2 )
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
      mxArray m;
      mxArray c;
      mxArray x;
      mxArray member;
      int M = 0;
      mxArray K;
      int i = 0;
      mxArray y;
      int I0_ = 0;
      mxArray BM0_;
      int I1_ = 0;
      unsigned short B0_ = 0;
      double R0_ = 0.0;
      mxArray IM0_;
      mxArray IM1_;
      mxArray CM0_;
      mxArray CM1_;
      mxArray CM2_;
      mxArray CM3_;
      
      mccComplexInit(x);
      mccImport(&x, ((nrhs_>0) ? prhs_[0] : 0), 0, 0);
      mccComplexInit(member);
      mccImport(&member, ((nrhs_>1) ? prhs_[1] : 0), 0, 0);
      mccComplexInit(m);
      mccComplexInit(c);
      mccComplexInit(K);
      mccIntInit(y);
      mccBoolInit(BM0_);
      mccIntInit(IM0_);
      mccIntInit(IM1_);
      mccComplexInit(CM0_);
      mccComplexInit(CM1_);
      mccComplexInit(CM2_);
      mccComplexInit(CM3_);
      
      /* % ESTIMATE	Estimate the statistics of data sets */
      /* %  */
      /* % Usage:		[M,C] = ESTIMATE( X, MEMBERSHIP ) */
      /* %  */
      /* % This function performs estimates the means and covariances */
      /* % of the column vectors of X for the classes defined by MEMBER. */
      /* %  */
      /* % The results of class i are return as rows within the M and C */
      /* % matrices.  The covariance has been RESHAPED to a 1x(m^2) vector. */
      /*  */
      /* % (c) Copyright 1993-1994 by Dave Caughey.  All rights reserved. */
      /* M = size(x,1); */
      if(mccNOTSET(&x))
      {
         mexErrMsgTxt( "variable x undefined, line 13" );
      }
      M = mccGetDimensionSize(&x, 1);
      /* K = max( member ); */
      if(mccNOTSET(&member))
      {
         mexErrMsgTxt( "variable member undefined, line 14" );
      }
      Mprhs_[0] = &member;
      Mplhs_[0] = &K;
      mccCallMATLAB(1, Mplhs_, 1, Mprhs_, "max", 14);
      /* for i = 1:K, */
      for (I0_ = 1; I0_ <= *mccPR(&K); I0_ = I0_ + 1)
      {
         i = I0_;
         /* y = find(member==i); */
         {
            int i_, j_;
            int m_=1, n_=1, cx_ = 0;
            unsigned short *p_BM0_;
            int I_BM0_=1;
            double *p_member;
            int I_member=1;
            double *q_member;
            m_ = mcmCalcResultSize(m_, &n_, mccM(&member), mccN(&member));
            mccAllocateMatrix(&BM0_, m_, n_);
            I_BM0_ = (mccM(&BM0_) != 1 || mccN(&BM0_) != 1);
            p_BM0_ = mccSPR(&BM0_);
            I_member = (mccM(&member) != 1 || mccN(&member) != 1);
            p_member = mccPR(&member);
            q_member = mccPI(&member);
            if (m_ != 0)
            {
               for (j_=0; j_<n_; ++j_)
               {
                  for (i_=0; i_<m_; ++i_, p_BM0_+=I_BM0_, p_member+=I_member, q_member+=I_member)
                  {
                     *p_BM0_ = ( ( (*p_member == i) && !mccREL_NAN(*p_member) ) && (*q_member == 0.));
                  }
               }
            }
         }
         mccFind(&y, &BM0_);
         /* if ( length(y) == 0 ), */
         I1_ = mccGetLength(&y);
         B0_ = (I1_ == 0);
         if ((double)B0_)
         {
            /* fprintf( 'estimate: class %d contains no data!  Estimates set to NaN\n', i); */
            Mprhs_[0] = &S0_;
            Mprhs_[1] = mccTempMatrix(i, 0., mccINT, 0 );
            Mplhs_[0] = 0;
            mccCallMATLAB(0, Mplhs_, 2, Mprhs_, "fprintf", 18);
            /* m(i,:) = NaN*ones(1,M); */
            R0_ = mxGetNaN();
            mccOnesMN(&IM0_, 1, M);
            {
               int i_, j_;
               int m_=1, n_=1, cx_ = 0;
               double *p_m;
               int I_m=1, J_m;
               double *q_m;
               int *p_IM0_;
               int I_IM0_=1;
               m_ = mcmCalcResultSize(m_, &n_, mccM(&IM0_), mccN(&IM0_));
               mccGrowMatrix(&m, i, n_);
               if (mccN(&m) == 1) { I_m = J_m = 0;}
               else { I_m = 1; J_m=mccM(&m)-m_; }
               p_m = mccPR(&m) + (i-1) + mccM(&m) * 0;
               q_m = mccPI(&m) + (i-1) + mccM(&m) * 0;
               I_IM0_ = (mccM(&IM0_) != 1 || mccN(&IM0_) != 1);
               p_IM0_ = mccIPR(&IM0_);
               if (m_ != 0)
               {
                  for (j_=0; j_<n_; ++j_, p_m += J_m, q_m += J_m)
                  {
                     for (i_=0; i_<m_; ++i_, p_m+=I_m, q_m+=I_m, p_IM0_+=I_IM0_)
                     {
                        *p_m = (R0_ * (double) ((int)*p_IM0_));
                        *q_m = 0.;
                     }
                  }
               }
            }
            /* c(i,:) = NaN*ones(1,M^2); */
            R0_ = mxGetNaN();
            mccOnesMN(&IM0_, 1, ((int)mcmIntPowerInt(M, 2)));
            {
               int i_, j_;
               int m_=1, n_=1, cx_ = 0;
               double *p_c;
               int I_c=1, J_c;
               double *q_c;
               int *p_IM0_;
               int I_IM0_=1;
               m_ = mcmCalcResultSize(m_, &n_, mccM(&IM0_), mccN(&IM0_));
               mccGrowMatrix(&c, i, n_);
               if (mccN(&c) == 1) { I_c = J_c = 0;}
               else { I_c = 1; J_c=mccM(&c)-m_; }
               p_c = mccPR(&c) + (i-1) + mccM(&c) * 0;
               q_c = mccPI(&c) + (i-1) + mccM(&c) * 0;
               I_IM0_ = (mccM(&IM0_) != 1 || mccN(&IM0_) != 1);
               p_IM0_ = mccIPR(&IM0_);
               if (m_ != 0)
               {
                  for (j_=0; j_<n_; ++j_, p_c += J_c, q_c += J_c)
                  {
                     for (i_=0; i_<m_; ++i_, p_c+=I_c, q_c+=I_c, p_IM0_+=I_IM0_)
                     {
                        *p_c = (R0_ * (double) ((int)*p_IM0_));
                        *q_c = 0.;
                     }
                  }
               }
            }
         }
         else
         {
            /* elseif length(y) == 1, */
            I1_ = mccGetLength(&y);
            B0_ = (I1_ == 1);
            if ((double)B0_)
            {
               /* fprintf( 'estimate: class %d contains one vector!\n', i ); */
               Mprhs_[0] = &S1_;
               Mprhs_[1] = mccTempMatrix(i, 0., mccINT, 0 );
               Mplhs_[0] = 0;
               mccCallMATLAB(0, Mplhs_, 2, Mprhs_, "fprintf", 22);
               /* m(i,:) = x(:,y)'; */
               mccFindIndex(&IM0_, &y);
               mccFindIndex(&IM1_, &IM0_);
               {
                  int i_, j_;
                  int m_=1, n_=1, cx_ = 0;
                  double *p_CM0_;
                  int I_CM0_=1;
                  double *q_CM0_;
                  double *p_x;
                  int I_x=1;
                  double *q_x;
                  int *p_IM1_;
                  int I_IM1_=1;
                  m_ = mcmCalcResultSize(m_, &n_, mccM(&x), (mccM(&IM1_) * mccN(&IM1_)));
                  mccAllocateMatrix(&CM0_, m_, n_);
                  mccCheckMatrixSize(&x, mccM(&x), mccGetMaxIndex(&IM1_ ,mccN(&x)));
                  I_CM0_ = (mccM(&CM0_) != 1 || mccN(&CM0_) != 1);
                  p_CM0_ = mccPR(&CM0_);
                  q_CM0_ = mccPI(&CM0_);
                  I_IM1_ = (mccM(&IM1_) != 1 || mccN(&IM1_) != 1);
                  p_IM1_ = mccIPR(&IM1_);
                  if (m_ != 0)
                  {
                     for (j_=0; j_<n_; ++j_, p_IM1_ += I_IM1_)
                     {
                        p_x = mccPR(&x) + mccM(&x) * ((int)(*p_IM1_ - .5)) + 0;
                        q_x = mccPI(&x) + mccM(&x) * ((int)(*p_IM1_ - .5)) + 0;
                        for (i_=0; i_<m_; ++i_, p_CM0_+=I_CM0_, q_CM0_+=I_CM0_, p_x+=I_x, q_x+=I_x)
                        {
                           *p_CM0_ = *p_x;
                           *q_CM0_ = *q_x;
                        }
                     }
                  }
               }
               mccConjTrans(&CM1_, &CM0_);
               {
                  int i_, j_;
                  int m_=1, n_=1, cx_ = 0;
                  double *p_m;
                  int I_m=1, J_m;
                  double *q_m;
                  double *p_CM1_;
                  int I_CM1_=1;
                  double *q_CM1_;
                  m_ = mcmCalcResultSize(m_, &n_, mccM(&CM1_), mccN(&CM1_));
                  mccGrowMatrix(&m, i, n_);
                  if (mccN(&m) == 1) { I_m = J_m = 0;}
                  else { I_m = 1; J_m=mccM(&m)-m_; }
                  p_m = mccPR(&m) + (i-1) + mccM(&m) * 0;
                  q_m = mccPI(&m) + (i-1) + mccM(&m) * 0;
                  I_CM1_ = (mccM(&CM1_) != 1 || mccN(&CM1_) != 1);
                  p_CM1_ = mccPR(&CM1_);
                  q_CM1_ = mccPI(&CM1_);
                  if (m_ != 0)
                  {
                     for (j_=0; j_<n_; ++j_, p_m += J_m, q_m += J_m)
                     {
                        for (i_=0; i_<m_; ++i_, p_m+=I_m, q_m+=I_m, p_CM1_+=I_CM1_, q_CM1_+=I_CM1_)
                        {
                           *p_m = *p_CM1_;
                           *q_m = *q_CM1_;
                        }
                     }
                  }
               }
               /* c(i,:) = zeros(1,M^2); */
               mccZerosMN(&IM1_, 1, ((int)mcmIntPowerInt(M, 2)));
               {
                  int i_, j_;
                  int m_=1, n_=1, cx_ = 0;
                  double *p_c;
                  int I_c=1, J_c;
                  double *q_c;
                  int *p_IM1_;
                  int I_IM1_=1;
                  m_ = mcmCalcResultSize(m_, &n_, mccM(&IM1_), mccN(&IM1_));
                  mccGrowMatrix(&c, i, n_);
                  if (mccN(&c) == 1) { I_c = J_c = 0;}
                  else { I_c = 1; J_c=mccM(&c)-m_; }
                  p_c = mccPR(&c) + (i-1) + mccM(&c) * 0;
                  q_c = mccPI(&c) + (i-1) + mccM(&c) * 0;
                  I_IM1_ = (mccM(&IM1_) != 1 || mccN(&IM1_) != 1);
                  p_IM1_ = mccIPR(&IM1_);
                  if (m_ != 0)
                  {
                     for (j_=0; j_<n_; ++j_, p_c += J_c, q_c += J_c)
                     {
                        for (i_=0; i_<m_; ++i_, p_c+=I_c, q_c+=I_c, p_IM1_+=I_IM1_)
                        {
                           *p_c = ((int)*p_IM1_);
                           *q_c = 0.;
                        }
                     }
                  }
               }
            }
            else
            {
               /* else */
               /* if length(y) <= M, */
               I1_ = mccGetLength(&y);
               B0_ = (I1_ <= M);
               if ((double)B0_)
               {
                  /* fprintf( 'estimate: class %d contains %d vectors in %d dimensions!\n', i, length(y), M ); */
                  I1_ = mccGetLength(&y);
                  Mprhs_[0] = &S2_;
                  Mprhs_[1] = mccTempMatrix(i, 0., mccINT, 0 );
                  Mprhs_[2] = mccTempMatrix(I1_, 0., mccINT, 0 );
                  Mprhs_[3] = mccTempMatrix(M, 0., mccINT, 0 );
                  Mplhs_[0] = 0;
                  mccCallMATLAB(0, Mplhs_, 4, Mprhs_, "fprintf", 27);
                  /* end; */
               }
               /* m(i,:) = mean(x(:,y)'); */
               mccFindIndex(&IM1_, &y);
               mccFindIndex(&IM0_, &IM1_);
               {
                  int i_, j_;
                  int m_=1, n_=1, cx_ = 0;
                  double *p_CM1_;
                  int I_CM1_=1;
                  double *q_CM1_;
                  double *p_x;
                  int I_x=1;
                  double *q_x;
                  int *p_IM0_;
                  int I_IM0_=1;
                  m_ = mcmCalcResultSize(m_, &n_, mccM(&x), (mccM(&IM0_) * mccN(&IM0_)));
                  mccAllocateMatrix(&CM1_, m_, n_);
                  mccCheckMatrixSize(&x, mccM(&x), mccGetMaxIndex(&IM0_ ,mccN(&x)));
                  I_CM1_ = (mccM(&CM1_) != 1 || mccN(&CM1_) != 1);
                  p_CM1_ = mccPR(&CM1_);
                  q_CM1_ = mccPI(&CM1_);
                  I_IM0_ = (mccM(&IM0_) != 1 || mccN(&IM0_) != 1);
                  p_IM0_ = mccIPR(&IM0_);
                  if (m_ != 0)
                  {
                     for (j_=0; j_<n_; ++j_, p_IM0_ += I_IM0_)
                     {
                        p_x = mccPR(&x) + mccM(&x) * ((int)(*p_IM0_ - .5)) + 0;
                        q_x = mccPI(&x) + mccM(&x) * ((int)(*p_IM0_ - .5)) + 0;
                        for (i_=0; i_<m_; ++i_, p_CM1_+=I_CM1_, q_CM1_+=I_CM1_, p_x+=I_x, q_x+=I_x)
                        {
                           *p_CM1_ = *p_x;
                           *q_CM1_ = *q_x;
                        }
                     }
                  }
               }
               mccConjTrans(&CM0_, &CM1_);
               Mprhs_[0] = &CM0_;
               Mplhs_[0] = &CM2_;
               mccCallMATLAB(1, Mplhs_, 1, Mprhs_, "mean", 29);
               {
                  int i_, j_;
                  int m_=1, n_=1, cx_ = 0;
                  double *p_m;
                  int I_m=1, J_m;
                  double *q_m;
                  double *p_CM2_;
                  int I_CM2_=1;
                  double *q_CM2_;
                  m_ = mcmCalcResultSize(m_, &n_, mccM(&CM2_), mccN(&CM2_));
                  mccGrowMatrix(&m, i, n_);
                  if (mccN(&m) == 1) { I_m = J_m = 0;}
                  else { I_m = 1; J_m=mccM(&m)-m_; }
                  p_m = mccPR(&m) + (i-1) + mccM(&m) * 0;
                  q_m = mccPI(&m) + (i-1) + mccM(&m) * 0;
                  I_CM2_ = (mccM(&CM2_) != 1 || mccN(&CM2_) != 1);
                  p_CM2_ = mccPR(&CM2_);
                  q_CM2_ = mccPI(&CM2_);
                  if (m_ != 0)
                  {
                     for (j_=0; j_<n_; ++j_, p_m += J_m, q_m += J_m)
                     {
                        for (i_=0; i_<m_; ++i_, p_m+=I_m, q_m+=I_m, p_CM2_+=I_CM2_, q_CM2_+=I_CM2_)
                        {
                           *p_m = *p_CM2_;
                           *q_m = *q_CM2_;
                        }
                     }
                  }
               }
               /* c(i,:) = reshape( cov(x(:,y)'), 1, M^2 ); */
               mccFindIndex(&IM0_, &y);
               mccFindIndex(&IM1_, &IM0_);
               {
                  int i_, j_;
                  int m_=1, n_=1, cx_ = 0;
                  double *p_CM2_;
                  int I_CM2_=1;
                  double *q_CM2_;
                  double *p_x;
                  int I_x=1;
                  double *q_x;
                  int *p_IM1_;
                  int I_IM1_=1;
                  m_ = mcmCalcResultSize(m_, &n_, mccM(&x), (mccM(&IM1_) * mccN(&IM1_)));
                  mccAllocateMatrix(&CM2_, m_, n_);
                  mccCheckMatrixSize(&x, mccM(&x), mccGetMaxIndex(&IM1_ ,mccN(&x)));
                  I_CM2_ = (mccM(&CM2_) != 1 || mccN(&CM2_) != 1);
                  p_CM2_ = mccPR(&CM2_);
                  q_CM2_ = mccPI(&CM2_);
                  I_IM1_ = (mccM(&IM1_) != 1 || mccN(&IM1_) != 1);
                  p_IM1_ = mccIPR(&IM1_);
                  if (m_ != 0)
                  {
                     for (j_=0; j_<n_; ++j_, p_IM1_ += I_IM1_)
                     {
                        p_x = mccPR(&x) + mccM(&x) * ((int)(*p_IM1_ - .5)) + 0;
                        q_x = mccPI(&x) + mccM(&x) * ((int)(*p_IM1_ - .5)) + 0;
                        for (i_=0; i_<m_; ++i_, p_CM2_+=I_CM2_, q_CM2_+=I_CM2_, p_x+=I_x, q_x+=I_x)
                        {
                           *p_CM2_ = *p_x;
                           *q_CM2_ = *q_x;
                        }
                     }
                  }
               }
               mccConjTrans(&CM0_, &CM2_);
               Mprhs_[0] = &CM0_;
               Mplhs_[0] = &CM1_;
               mccCallMATLAB(1, Mplhs_, 1, Mprhs_, "cov", 30);
               mccReshape(&CM3_, &CM1_, 1, ((int)mcmIntPowerInt(M, 2)));
               {
                  int i_, j_;
                  int m_=1, n_=1, cx_ = 0;
                  double *p_c;
                  int I_c=1, J_c;
                  double *q_c;
                  double *p_CM3_;
                  int I_CM3_=1;
                  double *q_CM3_;
                  m_ = mcmCalcResultSize(m_, &n_, mccM(&CM3_), mccN(&CM3_));
                  mccGrowMatrix(&c, i, n_);
                  if (mccN(&c) == 1) { I_c = J_c = 0;}
                  else { I_c = 1; J_c=mccM(&c)-m_; }
                  p_c = mccPR(&c) + (i-1) + mccM(&c) * 0;
                  q_c = mccPI(&c) + (i-1) + mccM(&c) * 0;
                  I_CM3_ = (mccM(&CM3_) != 1 || mccN(&CM3_) != 1);
                  p_CM3_ = mccPR(&CM3_);
                  q_CM3_ = mccPI(&CM3_);
                  if (m_ != 0)
                  {
                     for (j_=0; j_<n_; ++j_, p_c += J_c, q_c += J_c)
                     {
                        for (i_=0; i_<m_; ++i_, p_c+=I_c, q_c+=I_c, p_CM3_+=I_CM3_, q_CM3_+=I_CM3_)
                        {
                           *p_c = *p_CM3_;
                           *q_c = *q_CM3_;
                        }
                     }
                  }
               }
               /* end */
            }
         }
         /* end; */
      }
      mccReturnFirstValue(&plhs_[0], &m);
      mccReturnValue(&plhs_[1], &c);
   }
   else
   {
/***************** Compiler Assumptions ****************
 *
 *       B0_         	boolean scalar temporary
 *       BM0_        	boolean vector/matrix temporary
 *       I0_         	integer scalar temporary
 *       I1_         	integer scalar temporary
 *       IM0_        	integer vector/matrix temporary
 *       IM1_        	integer vector/matrix temporary
 *       K           	real vector/matrix
 *       M           	integer scalar
 *       NaN         	<function>
 *       R0_         	real scalar temporary
 *       RM0_        	real vector/matrix temporary
 *       RM1_        	real vector/matrix temporary
 *       RM2_        	real vector/matrix temporary
 *       RM3_        	real vector/matrix temporary
 *       c           	real vector/matrix
 *       cov         	<function>
 *       estimate    	<function being defined>
 *       find        	<function>
 *       fprintf     	<function>
 *       i           	integer scalar
 *       length      	<function>
 *       m           	real vector/matrix
 *       max         	<function>
 *       mean        	<function>
 *       member      	real vector/matrix
 *       ones        	<function>
 *       reshape     	<function>
 *       size        	<function>
 *       x           	real vector/matrix
 *       y           	integer vector/matrix
 *       zeros       	<function>
 *******************************************************/
      mxArray m;
      mxArray c;
      mxArray x;
      mxArray member;
      int M = 0;
      mxArray K;
      int i = 0;
      mxArray y;
      int I0_ = 0;
      mxArray BM0_;
      int I1_ = 0;
      unsigned short B0_ = 0;
      double R0_ = 0.0;
      mxArray IM0_;
      mxArray IM1_;
      mxArray RM0_;
      mxArray RM1_;
      mxArray RM2_;
      mxArray RM3_;
      
      mccRealInit(x);
      mccImport(&x, ((nrhs_>0) ? prhs_[0] : 0), 0, 0);
      mccRealInit(member);
      mccImport(&member, ((nrhs_>1) ? prhs_[1] : 0), 0, 0);
      mccRealInit(m);
      mccRealInit(c);
      mccRealInit(K);
      mccIntInit(y);
      mccBoolInit(BM0_);
      mccIntInit(IM0_);
      mccIntInit(IM1_);
      mccRealInit(RM0_);
      mccRealInit(RM1_);
      mccRealInit(RM2_);
      mccRealInit(RM3_);
      
      /* % ESTIMATE	Estimate the statistics of data sets */
      /* %  */
      /* % Usage:		[M,C] = ESTIMATE( X, MEMBERSHIP ) */
      /* %  */
      /* % This function performs estimates the means and covariances */
      /* % of the column vectors of X for the classes defined by MEMBER. */
      /* %  */
      /* % The results of class i are return as rows within the M and C */
      /* % matrices.  The covariance has been RESHAPED to a 1x(m^2) vector. */
      /*  */
      /* % (c) Copyright 1993-1994 by Dave Caughey.  All rights reserved. */
      /* M = size(x,1); */
      if(mccNOTSET(&x))
      {
         mexErrMsgTxt( "variable x undefined, line 13" );
      }
      M = mccGetDimensionSize(&x, 1);
      /* K = max( member ); */
      if(mccNOTSET(&member))
      {
         mexErrMsgTxt( "variable member undefined, line 14" );
      }
      mccMax(&K, &member);
      /* for i = 1:K, */
      for (I0_ = 1; I0_ <= mccGetRealVectorElement(&K, 1); I0_ = I0_ + 1)
      {
         i = I0_;
         /* y = find(member==i); */
         {
            int i_, j_;
            int m_=1, n_=1, cx_ = 0;
            unsigned short *p_BM0_;
            int I_BM0_=1;
            double *p_member;
            int I_member=1;
            m_ = mcmCalcResultSize(m_, &n_, mccM(&member), mccN(&member));
            mccAllocateMatrix(&BM0_, m_, n_);
            I_BM0_ = (mccM(&BM0_) != 1 || mccN(&BM0_) != 1);
            p_BM0_ = mccSPR(&BM0_);
            I_member = (mccM(&member) != 1 || mccN(&member) != 1);
            p_member = mccPR(&member);
            if (m_ != 0)
            {
               for (j_=0; j_<n_; ++j_)
               {
                  for (i_=0; i_<m_; ++i_, p_BM0_+=I_BM0_, p_member+=I_member)
                  {
                     *p_BM0_ = ( (*p_member == i) && !mccREL_NAN(*p_member) );
                  }
               }
            }
         }
         mccFind(&y, &BM0_);
         /* if ( length(y) == 0 ), */
         I1_ = mccGetLength(&y);
         B0_ = (I1_ == 0);
         if ((double)B0_)
         {
            /* fprintf( 'estimate: class %d contains no data!  Estimates set to NaN\n', i); */
            Mprhs_[0] = &S3_;
            Mprhs_[1] = mccTempMatrix(i, 0., mccINT, 0 );
            Mplhs_[0] = 0;
            mccCallMATLAB(0, Mplhs_, 2, Mprhs_, "fprintf", 18);
            /* m(i,:) = NaN*ones(1,M); */
            R0_ = mxGetNaN();
            mccOnesMN(&IM0_, 1, M);
            {
               int i_, j_;
               int m_=1, n_=1, cx_ = 0;
               double *p_m;
               int I_m=1, J_m;
               int *p_IM0_;
               int I_IM0_=1;
               m_ = mcmCalcResultSize(m_, &n_, mccM(&IM0_), mccN(&IM0_));
               mccGrowMatrix(&m, i, n_);
               if (mccN(&m) == 1) { I_m = J_m = 0;}
               else { I_m = 1; J_m=mccM(&m)-m_; }
               p_m = mccPR(&m) + (i-1) + mccM(&m) * 0;
               I_IM0_ = (mccM(&IM0_) != 1 || mccN(&IM0_) != 1);
               p_IM0_ = mccIPR(&IM0_);
               if (m_ != 0)
               {
                  for (j_=0; j_<n_; ++j_, p_m += J_m)
                  {
                     for (i_=0; i_<m_; ++i_, p_m+=I_m, p_IM0_+=I_IM0_)
                     {
                        *p_m = (R0_ * (double) ((int)*p_IM0_));
                     }
                  }
               }
            }
            /* c(i,:) = NaN*ones(1,M^2); */
            R0_ = mxGetNaN();
            mccOnesMN(&IM0_, 1, ((int)mcmIntPowerInt(M, 2)));
            {
               int i_, j_;
               int m_=1, n_=1, cx_ = 0;
               double *p_c;
               int I_c=1, J_c;
               int *p_IM0_;
               int I_IM0_=1;
               m_ = mcmCalcResultSize(m_, &n_, mccM(&IM0_), mccN(&IM0_));
               mccGrowMatrix(&c, i, n_);
               if (mccN(&c) == 1) { I_c = J_c = 0;}
               else { I_c = 1; J_c=mccM(&c)-m_; }
               p_c = mccPR(&c) + (i-1) + mccM(&c) * 0;
               I_IM0_ = (mccM(&IM0_) != 1 || mccN(&IM0_) != 1);
               p_IM0_ = mccIPR(&IM0_);
               if (m_ != 0)
               {
                  for (j_=0; j_<n_; ++j_, p_c += J_c)
                  {
                     for (i_=0; i_<m_; ++i_, p_c+=I_c, p_IM0_+=I_IM0_)
                     {
                        *p_c = (R0_ * (double) ((int)*p_IM0_));
                     }
                  }
               }
            }
         }
         else
         {
            /* elseif length(y) == 1, */
            I1_ = mccGetLength(&y);
            B0_ = (I1_ == 1);
            if ((double)B0_)
            {
               /* fprintf( 'estimate: class %d contains one vector!\n', i ); */
               Mprhs_[0] = &S4_;
               Mprhs_[1] = mccTempMatrix(i, 0., mccINT, 0 );
               Mplhs_[0] = 0;
               mccCallMATLAB(0, Mplhs_, 2, Mprhs_, "fprintf", 22);
               /* m(i,:) = x(:,y)'; */
               mccFindIndex(&IM0_, &y);
               mccFindIndex(&IM1_, &IM0_);
               {
                  int i_, j_;
                  int m_=1, n_=1, cx_ = 0;
                  double *p_RM0_;
                  int I_RM0_=1;
                  double *p_x;
                  int I_x=1;
                  int *p_IM1_;
                  int I_IM1_=1;
                  m_ = mcmCalcResultSize(m_, &n_, mccM(&x), (mccM(&IM1_) * mccN(&IM1_)));
                  mccAllocateMatrix(&RM0_, m_, n_);
                  mccCheckMatrixSize(&x, mccM(&x), mccGetMaxIndex(&IM1_ ,mccN(&x)));
                  I_RM0_ = (mccM(&RM0_) != 1 || mccN(&RM0_) != 1);
                  p_RM0_ = mccPR(&RM0_);
                  I_IM1_ = (mccM(&IM1_) != 1 || mccN(&IM1_) != 1);
                  p_IM1_ = mccIPR(&IM1_);
                  if (m_ != 0)
                  {
                     for (j_=0; j_<n_; ++j_, p_IM1_ += I_IM1_)
                     {
                        p_x = mccPR(&x) + mccM(&x) * ((int)(*p_IM1_ - .5)) + 0;
                        for (i_=0; i_<m_; ++i_, p_RM0_+=I_RM0_, p_x+=I_x)
                        {
                           *p_RM0_ = *p_x;
                        }
                     }
                  }
               }
               mccConjTrans(&RM1_, &RM0_);
               {
                  int i_, j_;
                  int m_=1, n_=1, cx_ = 0;
                  double *p_m;
                  int I_m=1, J_m;
                  double *p_RM1_;
                  int I_RM1_=1;
                  m_ = mcmCalcResultSize(m_, &n_, mccM(&RM1_), mccN(&RM1_));
                  mccGrowMatrix(&m, i, n_);
                  if (mccN(&m) == 1) { I_m = J_m = 0;}
                  else { I_m = 1; J_m=mccM(&m)-m_; }
                  p_m = mccPR(&m) + (i-1) + mccM(&m) * 0;
                  I_RM1_ = (mccM(&RM1_) != 1 || mccN(&RM1_) != 1);
                  p_RM1_ = mccPR(&RM1_);
                  if (m_ != 0)
                  {
                     for (j_=0; j_<n_; ++j_, p_m += J_m)
                     {
                        for (i_=0; i_<m_; ++i_, p_m+=I_m, p_RM1_+=I_RM1_)
                        {
                           *p_m = *p_RM1_;
                        }
                     }
                  }
               }
               /* c(i,:) = zeros(1,M^2); */
               mccZerosMN(&IM1_, 1, ((int)mcmIntPowerInt(M, 2)));
               {
                  int i_, j_;
                  int m_=1, n_=1, cx_ = 0;
                  double *p_c;
                  int I_c=1, J_c;
                  int *p_IM1_;
                  int I_IM1_=1;
                  m_ = mcmCalcResultSize(m_, &n_, mccM(&IM1_), mccN(&IM1_));
                  mccGrowMatrix(&c, i, n_);
                  if (mccN(&c) == 1) { I_c = J_c = 0;}
                  else { I_c = 1; J_c=mccM(&c)-m_; }
                  p_c = mccPR(&c) + (i-1) + mccM(&c) * 0;
                  I_IM1_ = (mccM(&IM1_) != 1 || mccN(&IM1_) != 1);
                  p_IM1_ = mccIPR(&IM1_);
                  if (m_ != 0)
                  {
                     for (j_=0; j_<n_; ++j_, p_c += J_c)
                     {
                        for (i_=0; i_<m_; ++i_, p_c+=I_c, p_IM1_+=I_IM1_)
                        {
                           *p_c = ((int)*p_IM1_);
                        }
                     }
                  }
               }
            }
            else
            {
               /* else */
               /* if length(y) <= M, */
               I1_ = mccGetLength(&y);
               B0_ = (I1_ <= M);
               if ((double)B0_)
               {
                  /* fprintf( 'estimate: class %d contains %d vectors in %d dimensions!\n', i, length(y), M ); */
                  I1_ = mccGetLength(&y);
                  Mprhs_[0] = &S5_;
                  Mprhs_[1] = mccTempMatrix(i, 0., mccINT, 0 );
                  Mprhs_[2] = mccTempMatrix(I1_, 0., mccINT, 0 );
                  Mprhs_[3] = mccTempMatrix(M, 0., mccINT, 0 );
                  Mplhs_[0] = 0;
                  mccCallMATLAB(0, Mplhs_, 4, Mprhs_, "fprintf", 27);
                  /* end; */
               }
               /* m(i,:) = mean(x(:,y)'); */
               mccFindIndex(&IM1_, &y);
               mccFindIndex(&IM0_, &IM1_);
               {
                  int i_, j_;
                  int m_=1, n_=1, cx_ = 0;
                  double *p_RM1_;
                  int I_RM1_=1;
                  double *p_x;
                  int I_x=1;
                  int *p_IM0_;
                  int I_IM0_=1;
                  m_ = mcmCalcResultSize(m_, &n_, mccM(&x), (mccM(&IM0_) * mccN(&IM0_)));
                  mccAllocateMatrix(&RM1_, m_, n_);
                  mccCheckMatrixSize(&x, mccM(&x), mccGetMaxIndex(&IM0_ ,mccN(&x)));
                  I_RM1_ = (mccM(&RM1_) != 1 || mccN(&RM1_) != 1);
                  p_RM1_ = mccPR(&RM1_);
                  I_IM0_ = (mccM(&IM0_) != 1 || mccN(&IM0_) != 1);
                  p_IM0_ = mccIPR(&IM0_);
                  if (m_ != 0)
                  {
                     for (j_=0; j_<n_; ++j_, p_IM0_ += I_IM0_)
                     {
                        p_x = mccPR(&x) + mccM(&x) * ((int)(*p_IM0_ - .5)) + 0;
                        for (i_=0; i_<m_; ++i_, p_RM1_+=I_RM1_, p_x+=I_x)
                        {
                           *p_RM1_ = *p_x;
                        }
                     }
                  }
               }
               mccConjTrans(&RM0_, &RM1_);
               Mprhs_[0] = &RM0_;
               Mplhs_[0] = &RM2_;
               mccCallMATLAB(1, Mplhs_, 1, Mprhs_, "mean", 29);
               {
                  int i_, j_;
                  int m_=1, n_=1, cx_ = 0;
                  double *p_m;
                  int I_m=1, J_m;
                  double *p_RM2_;
                  int I_RM2_=1;
                  m_ = mcmCalcResultSize(m_, &n_, mccM(&RM2_), mccN(&RM2_));
                  mccGrowMatrix(&m, i, n_);
                  if (mccN(&m) == 1) { I_m = J_m = 0;}
                  else { I_m = 1; J_m=mccM(&m)-m_; }
                  p_m = mccPR(&m) + (i-1) + mccM(&m) * 0;
                  I_RM2_ = (mccM(&RM2_) != 1 || mccN(&RM2_) != 1);
                  p_RM2_ = mccPR(&RM2_);
                  if (m_ != 0)
                  {
                     for (j_=0; j_<n_; ++j_, p_m += J_m)
                     {
                        for (i_=0; i_<m_; ++i_, p_m+=I_m, p_RM2_+=I_RM2_)
                        {
                           *p_m = *p_RM2_;
                        }
                     }
                  }
               }
               /* c(i,:) = reshape( cov(x(:,y)'), 1, M^2 ); */
               mccFindIndex(&IM0_, &y);
               mccFindIndex(&IM1_, &IM0_);
               {
                  int i_, j_;
                  int m_=1, n_=1, cx_ = 0;
                  double *p_RM2_;
                  int I_RM2_=1;
                  double *p_x;
                  int I_x=1;
                  int *p_IM1_;
                  int I_IM1_=1;
                  m_ = mcmCalcResultSize(m_, &n_, mccM(&x), (mccM(&IM1_) * mccN(&IM1_)));
                  mccAllocateMatrix(&RM2_, m_, n_);
                  mccCheckMatrixSize(&x, mccM(&x), mccGetMaxIndex(&IM1_ ,mccN(&x)));
                  I_RM2_ = (mccM(&RM2_) != 1 || mccN(&RM2_) != 1);
                  p_RM2_ = mccPR(&RM2_);
                  I_IM1_ = (mccM(&IM1_) != 1 || mccN(&IM1_) != 1);
                  p_IM1_ = mccIPR(&IM1_);
                  if (m_ != 0)
                  {
                     for (j_=0; j_<n_; ++j_, p_IM1_ += I_IM1_)
                     {
                        p_x = mccPR(&x) + mccM(&x) * ((int)(*p_IM1_ - .5)) + 0;
                        for (i_=0; i_<m_; ++i_, p_RM2_+=I_RM2_, p_x+=I_x)
                        {
                           *p_RM2_ = *p_x;
                        }
                     }
                  }
               }
               mccConjTrans(&RM0_, &RM2_);
               Mprhs_[0] = &RM0_;
               Mplhs_[0] = &RM1_;
               mccCallMATLAB(1, Mplhs_, 1, Mprhs_, "cov", 30);
               mccReshape(&RM3_, &RM1_, 1, ((int)mcmIntPowerInt(M, 2)));
               {
                  int i_, j_;
                  int m_=1, n_=1, cx_ = 0;
                  double *p_c;
                  int I_c=1, J_c;
                  double *p_RM3_;
                  int I_RM3_=1;
                  m_ = mcmCalcResultSize(m_, &n_, mccM(&RM3_), mccN(&RM3_));
                  mccGrowMatrix(&c, i, n_);
                  if (mccN(&c) == 1) { I_c = J_c = 0;}
                  else { I_c = 1; J_c=mccM(&c)-m_; }
                  p_c = mccPR(&c) + (i-1) + mccM(&c) * 0;
                  I_RM3_ = (mccM(&RM3_) != 1 || mccN(&RM3_) != 1);
                  p_RM3_ = mccPR(&RM3_);
                  if (m_ != 0)
                  {
                     for (j_=0; j_<n_; ++j_, p_c += J_c)
                     {
                        for (i_=0; i_<m_; ++i_, p_c+=I_c, p_RM3_+=I_RM3_)
                        {
                           *p_c = *p_RM3_;
                        }
                     }
                  }
               }
               /* end */
            }
         }
         /* end; */
      }
      mccReturnFirstValue(&plhs_[0], &m);
      mccReturnValue(&plhs_[1], &c);
   }
   return;
}
