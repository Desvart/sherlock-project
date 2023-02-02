static char mc_version[] = "MATLAB Compiler 1.2 Jan 17 1998 infun";
/*
 *  MATLAB Compiler: 1.2
 *  Date: Jan 17 1998
 *  Arguments: dbayes 
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

/***************** Compiler Assumptions ****************
 *
 *       B0_         	boolean scalar temporary
 *       C0_         	complex scalar temporary
 *       C1_         	complex scalar temporary
 *       C2_         	complex scalar temporary
 *       CM0_        	complex vector/matrix temporary
 *       CM1_        	complex vector/matrix temporary
 *       CM2_        	complex vector/matrix temporary
 *       CM3_        	complex vector/matrix temporary
 *       CM4_        	complex vector/matrix temporary
 *       CM5_        	complex vector/matrix temporary
 *       I0_         	integer scalar temporary
 *       IM0_        	integer vector/matrix temporary
 *       K           	integer scalar
 *       M           	integer scalar
 *       N           	integer scalar
 *       c           	complex vector/matrix
 *       class_extract	<function>
 *       class_multi 	<function>
 *       cx          	complex vector/matrix
 *       d           	complex vector/matrix
 *       dbayes      	<function being defined>
 *       det         	<function>
 *       dg          	complex vector/matrix
 *       diag        	<function>
 *       eig         	<function>
 *       i           	integer scalar
 *       log         	<function>
 *       m           	complex vector/matrix
 *       mx          	complex vector/matrix
 *       nargin      	<function>
 *       ones        	<function>
 *       pw          	complex vector/matrix
 *       size        	<function>
 *       sqrt        	<function>
 *       sum         	<function>
 *       v           	complex vector/matrix
 *       x           	complex vector/matrix
 *       yx          	complex vector/matrix
 *       yy          	complex vector/matrix
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
   mxArray *Mprhs_[3];
   

   if (nrhs_ > 4 )
   {
      mexErrMsgTxt( "Too many input arguments." );
   }

   if (nlhs_ > 1 )
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
      mxArray dg;
      mxArray x;
      mxArray m;
      mxArray c;
      mxArray pw;
      int M = 0;
      int N = 0;
      int K = 0;
      int i = 0;
      mxArray M_mx;
      mxArray cx;
      mxArray yx;
      mxArray v;
      mxArray d;
      mxArray yy;
      int I0_ = 0;
      unsigned short B0_ = 0;
      mxArray IM0_;
      mxArray CM0_;
      mxArray CM1_;
      mxArray CM2_;
      mxArray CM3_;
      mxArray CM4_;
      mxArray CM5_;
      double C0__r=0.0, C0__i=0.0;
      double C1__r=0.0, C1__i=0.0;
      double C2__r=0.0, C2__i=0.0;
      
      mccComplexInit(x);
      mccImport(&x, ((nrhs_>0) ? prhs_[0] : 0), 0, 0);
      mccComplexInit(m);
      mccImportCopy(&m, ((nrhs_>1) ? prhs_[1] : 0), 0, 0);
      mccComplexInit(c);
      mccImportCopy(&c, ((nrhs_>2) ? prhs_[2] : 0), 0, 0);
      mccComplexInit(pw);
      mccImportCopy(&pw, ((nrhs_>3) ? prhs_[3] : 0), 0, 0);
      mccComplexInit(dg);
      mccComplexInit(M_mx);
      mccComplexInit(cx);
      mccComplexInit(yx);
      mccComplexInit(v);
      mccComplexInit(d);
      mccComplexInit(yy);
      mccIntInit(IM0_);
      mccComplexInit(CM0_);
      mccComplexInit(CM1_);
      mccComplexInit(CM2_);
      mccComplexInit(CM3_);
      mccComplexInit(CM4_);
      mccComplexInit(CM5_);
      
      /* % DBAYES		Calculate distance of points to Gaussian clusters */
      /* %  */
      /* % Usage:		D = DBAYES( X, MEANS, COVS [, PW] ) */
      /* %  */
      /* % This function returns the squared bayesian distances for each point  */
      /* % in X from the MEANS of Gaussian distributions, described */
      /* % by their COVS.  Similarity transforms are used to normalize */
      /* % units of comparison. */
      /* %  */
      /* % The distance D is defined such that */
      /* % p(wi)*p(x|wi) = exp(-D)*(2*pi)^(-M/2) */
      /* % which yields */
      /* % D = -log((2*pi)^(M/2)*p(wi)*p(x|wi)) */
      /* % where p(x|wi) is defined as */
      /* % p(x|wi)=exp(-0.5*(x-m)'*inv(c)*(x-m))/sqrt((2*pi)^M*det(c)) */
      /* %  */
      /* % If PW (the probability of class i) is not specified, the values */
      /* % are assume uniform. */
      /* %  */
      /* % See also MAHALANOBIS */
      /*  */
      /* % (c) Copyright 1993-1994 by Dave Caughey.  All rights reserved. */
      /* [M,N] = size( x ); */
      if(mccNOTSET(&x))
      {
         mexErrMsgTxt( "variable x undefined, line 24" );
      }
      mccGetMatrixSize(&M,&N, &x);
      /* [m,c] = class_multi(m,c); */
      if(mccNOTSET(&m))
      {
         mexErrMsgTxt( "variable m undefined, line 25" );
      }
      if(mccNOTSET(&c))
      {
         mexErrMsgTxt( "variable c undefined, line 25" );
      }
      Mprhs_[0] = &m;
      Mprhs_[1] = &c;
      Mplhs_[0] = &m;
      Mplhs_[1] = &c;
      mccCallMATLAB(2, Mplhs_, 2, Mprhs_, "class_multi", 25);
      /* K = size(c,1); */
      K = mccGetDimensionSize(&c, 1);
      /* if nargin == 3, */
      I0_ = mccNargin();
      B0_ = (I0_ == 3);
      if ((double)B0_)
      {
         /* pw = ones(K,1)/K; */
         mccOnesMN(&IM0_, K, 1);
         {
            int i_, j_;
            int m_=1, n_=1, cx_ = 0;
            double *p_pw;
            int I_pw=1;
            double *q_pw;
            int *p_IM0_;
            int I_IM0_=1;
            m_ = mcmCalcResultSize(m_, &n_, mccM(&IM0_), mccN(&IM0_));
            mccAllocateMatrix(&pw, m_, n_);
            I_pw = (mccM(&pw) != 1 || mccN(&pw) != 1);
            p_pw = mccPR(&pw);
            q_pw = mccPI(&pw);
            I_IM0_ = (mccM(&IM0_) != 1 || mccN(&IM0_) != 1);
            p_IM0_ = mccIPR(&IM0_);
            if (m_ != 0)
            {
               for (j_=0; j_<n_; ++j_)
               {
                  for (i_=0; i_<m_; ++i_, p_pw+=I_pw, q_pw+=I_pw, p_IM0_+=I_IM0_)
                  {
                     *p_pw = (((int)*p_IM0_) / (double) K);
                     *q_pw = 0.;
                  }
               }
            }
         }
         /* end; */
      }
      /* pw = log(pw); */
      if(mccNOTSET(&pw))
      {
         mexErrMsgTxt( "variable pw undefined, line 30" );
      }
      Mprhs_[0] = &pw;
      Mplhs_[0] = &pw;
      mccCallMATLAB(1, Mplhs_, 1, Mprhs_, "log", 30);
      /* for i = 1:K, */
      for (I0_ = 1; I0_ <= K; I0_ = I0_ + 1)
      {
         i = I0_;
         /* [mx,cx] = class_extract( m, c, i ); */
         Mprhs_[0] = &m;
         Mprhs_[1] = &c;
         Mprhs_[2] = mccTempMatrix(i, 0., mccINT, 0 );
         Mplhs_[0] = &M_mx;
         Mplhs_[1] = &cx;
         mccCallMATLAB(2, Mplhs_, 3, Mprhs_, "class_extract", 32);
         /* yx = x-mx*ones(1,N); */
         mccOnesMN(&IM0_, 1, N);
         mccMultiply(&CM0_, &M_mx, &IM0_);
         {
            int i_, j_;
            int m_=1, n_=1, cx_ = 0;
            double *p_yx;
            int I_yx=1;
            double *q_yx;
            double *p_x;
            int I_x=1;
            double *q_x;
            double *p_CM0_;
            int I_CM0_=1;
            double *q_CM0_;
            m_ = mcmCalcResultSize(m_, &n_, mccM(&x), mccN(&x));
            m_ = mcmCalcResultSize(m_, &n_, mccM(&CM0_), mccN(&CM0_));
            mccAllocateMatrix(&yx, m_, n_);
            I_yx = (mccM(&yx) != 1 || mccN(&yx) != 1);
            p_yx = mccPR(&yx);
            q_yx = mccPI(&yx);
            I_x = (mccM(&x) != 1 || mccN(&x) != 1);
            p_x = mccPR(&x);
            q_x = mccPI(&x);
            I_CM0_ = (mccM(&CM0_) != 1 || mccN(&CM0_) != 1);
            p_CM0_ = mccPR(&CM0_);
            q_CM0_ = mccPI(&CM0_);
            if (m_ != 0)
            {
               for (j_=0; j_<n_; ++j_)
               {
                  for (i_=0; i_<m_; ++i_, p_yx+=I_yx, q_yx+=I_yx, p_x+=I_x, q_x+=I_x, p_CM0_+=I_CM0_, q_CM0_+=I_CM0_)
                  {
                     *p_yx = (*p_x - *p_CM0_);
                     *q_yx = (*q_x - *q_CM0_);
                  }
               }
            }
         }
         /* [v d] = eig(cx); */
         Mprhs_[0] = &cx;
         Mplhs_[0] = &v;
         Mplhs_[1] = &d;
         mccCallMATLAB(2, Mplhs_, 1, Mprhs_, "eig", 34);
         /* yy = diag(1./sqrt(diag(d)))*v'*yx; */
         Mprhs_[0] = &d;
         Mplhs_[0] = &CM0_;
         mccCallMATLAB(1, Mplhs_, 1, Mprhs_, "diag", 35);
         Mprhs_[0] = &CM0_;
         Mplhs_[0] = &CM1_;
         mccCallMATLAB(1, Mplhs_, 1, Mprhs_, "sqrt", 35);
         {
            int i_, j_;
            int m_=1, n_=1, cx_ = 0;
            double *p_CM2_;
            int I_CM2_=1;
            double *q_CM2_;
            double *p_CM1_;
            int I_CM1_=1;
            double *q_CM1_;
            m_ = mcmCalcResultSize(m_, &n_, mccM(&CM1_), mccN(&CM1_));
            mccAllocateMatrix(&CM2_, m_, n_);
            I_CM2_ = (mccM(&CM2_) != 1 || mccN(&CM2_) != 1);
            p_CM2_ = mccPR(&CM2_);
            q_CM2_ = mccPI(&CM2_);
            I_CM1_ = (mccM(&CM1_) != 1 || mccN(&CM1_) != 1);
            p_CM1_ = mccPR(&CM1_);
            q_CM1_ = mccPI(&CM1_);
            if (m_ != 0)
            {
               for (j_=0; j_<n_; ++j_)
               {
                  for (i_=0; i_<m_; ++i_, p_CM2_+=I_CM2_, q_CM2_+=I_CM2_, p_CM1_+=I_CM1_, q_CM1_+=I_CM1_)
                  {
                     {
                        double t_ = mcmDivideRealpart(1, 0., *p_CM1_, *q_CM1_);
                        *q_CM2_ = mcmDivideImagPart(1, 0., *p_CM1_, *q_CM1_);
                        *p_CM2_ = t_;
                     }
                  }
               }
            }
         }
         Mprhs_[0] = &CM2_;
         Mplhs_[0] = &CM3_;
         mccCallMATLAB(1, Mplhs_, 1, Mprhs_, "diag", 35);
         mccConjTrans(&CM4_, &v);
         mccMultiply(&CM5_, &CM3_, &CM4_);
         mccMultiply(&yy, &CM5_, &yx);
         /* if M > 1, */
         if ((M > 1))
         {
            /* dg(i,:) = -pw(i) + log(det(cx))/2 + (sum(yy.^2))/2; */
            Mprhs_[0] = &cx;
            Mplhs_[0] = 0;
            mccCallMATLAB(1, Mplhs_, 1, Mprhs_, "det", 37);
            C0__r = mccImportScalar(&C0__i, 0, 0, Mplhs_[ 0 ], 1, " (dbayes, line 37): C0_");
            mcmLog(&C1__r, &C1__i, C0__r, C0__i);
            C2__r = ((-(mccGetRealVectorElement(&pw, mccRint(i)))) + (C1__r / (double) 2));
            C2__i = ((- mccGetImagVectorElement(&pw, mccRint(i))) + (C1__i / (double) 2));
            mccArrayPower(&CM5_, &yy, mccTempMatrix(2, 0., mccINT, 0 ));
            Mprhs_[0] = &CM5_;
            Mplhs_[0] = &CM4_;
            mccCallMATLAB(1, Mplhs_, 1, Mprhs_, "sum", 37);
            {
               int i_, j_;
               int m_=1, n_=1, cx_ = 0;
               double *p_dg;
               int I_dg=1, J_dg;
               double *q_dg;
               double *p_CM4_;
               int I_CM4_=1;
               double *q_CM4_;
               m_ = mcmCalcResultSize(m_, &n_, mccM(&CM4_), mccN(&CM4_));
               mccGrowMatrix(&dg, i, n_);
               if (mccN(&dg) == 1) { I_dg = J_dg = 0;}
               else { I_dg = 1; J_dg=mccM(&dg)-m_; }
               p_dg = mccPR(&dg) + (i-1) + mccM(&dg) * 0;
               q_dg = mccPI(&dg) + (i-1) + mccM(&dg) * 0;
               I_CM4_ = (mccM(&CM4_) != 1 || mccN(&CM4_) != 1);
               p_CM4_ = mccPR(&CM4_);
               q_CM4_ = mccPI(&CM4_);
               if (m_ != 0)
               {
                  for (j_=0; j_<n_; ++j_, p_dg += J_dg, q_dg += J_dg)
                  {
                     for (i_=0; i_<m_; ++i_, p_dg+=I_dg, q_dg+=I_dg, p_CM4_+=I_CM4_, q_CM4_+=I_CM4_)
                     {
                        *p_dg = (C2__r + (*p_CM4_ / (double) 2));
                        *q_dg = (C2__i + (*q_CM4_ / (double) 2));
                     }
                  }
               }
            }
         }
         else
         {
            /* else */
            /* dg(i,:) = -pw(i) + log(cx)/2 + (yy.^2)/2; */
            C2__r = (-(mccGetRealVectorElement(&pw, mccRint(i))));
            C2__i = (- mccGetImagVectorElement(&pw, mccRint(i)));
            Mprhs_[0] = &cx;
            Mplhs_[0] = &CM4_;
            mccCallMATLAB(1, Mplhs_, 1, Mprhs_, "log", 39);
            mccArrayPower(&CM5_, &yy, mccTempMatrix(2, 0., mccINT, 0 ));
            {
               int i_, j_;
               int m_=1, n_=1, cx_ = 0;
               double *p_dg;
               int I_dg=1, J_dg;
               double *q_dg;
               double *p_CM4_;
               int I_CM4_=1;
               double *q_CM4_;
               double *p_CM5_;
               int I_CM5_=1;
               double *q_CM5_;
               m_ = mcmCalcResultSize(m_, &n_, mccM(&CM4_), mccN(&CM4_));
               m_ = mcmCalcResultSize(m_, &n_, mccM(&CM5_), mccN(&CM5_));
               mccGrowMatrix(&dg, i, n_);
               if (mccN(&dg) == 1) { I_dg = J_dg = 0;}
               else { I_dg = 1; J_dg=mccM(&dg)-m_; }
               p_dg = mccPR(&dg) + (i-1) + mccM(&dg) * 0;
               q_dg = mccPI(&dg) + (i-1) + mccM(&dg) * 0;
               I_CM4_ = (mccM(&CM4_) != 1 || mccN(&CM4_) != 1);
               p_CM4_ = mccPR(&CM4_);
               q_CM4_ = mccPI(&CM4_);
               I_CM5_ = (mccM(&CM5_) != 1 || mccN(&CM5_) != 1);
               p_CM5_ = mccPR(&CM5_);
               q_CM5_ = mccPI(&CM5_);
               if (m_ != 0)
               {
                  for (j_=0; j_<n_; ++j_, p_dg += J_dg, q_dg += J_dg)
                  {
                     for (i_=0; i_<m_; ++i_, p_dg+=I_dg, q_dg+=I_dg, p_CM4_+=I_CM4_, q_CM4_+=I_CM4_, p_CM5_+=I_CM5_, q_CM5_+=I_CM5_)
                     {
                        *p_dg = ((C2__r + (*p_CM4_ / (double) 2)) + (*p_CM5_ / (double) 2));
                        *q_dg = ((C2__i + (*q_CM4_ / (double) 2)) + (*q_CM5_ / (double) 2));
                     }
                  }
               }
            }
            /* end */
         }
         /* end; */
      }
      mccReturnFirstValue(&plhs_[0], &dg);
   }
   else
   {
/***************** Compiler Assumptions ****************
 *
 *       B0_         	boolean scalar temporary
 *       C0_         	complex scalar temporary
 *       C1_         	complex scalar temporary
 *       C2_         	complex scalar temporary
 *       CM0_        	complex vector/matrix temporary
 *       CM1_        	complex vector/matrix temporary
 *       CM2_        	complex vector/matrix temporary
 *       CM3_        	complex vector/matrix temporary
 *       CM4_        	complex vector/matrix temporary
 *       CM5_        	complex vector/matrix temporary
 *       I0_         	integer scalar temporary
 *       IM0_        	integer vector/matrix temporary
 *       K           	integer scalar
 *       M           	integer scalar
 *       N           	integer scalar
 *       R0_         	real scalar temporary
 *       RM0_        	real vector/matrix temporary
 *       c           	real vector/matrix
 *       class_extract	<function>
 *       class_multi 	<function>
 *       cx          	real vector/matrix
 *       d           	complex vector/matrix
 *       dbayes      	<function being defined>
 *       det         	<function>
 *       dg          	complex vector/matrix
 *       diag        	<function>
 *       eig         	<function>
 *       i           	integer scalar
 *       log         	<function>
 *       m           	real vector/matrix
 *       mx          	real vector/matrix
 *       nargin      	<function>
 *       ones        	<function>
 *       pw          	real vector/matrix
 *       pw          	complex vector/matrix  => pw_1
 *       size        	<function>
 *       sqrt        	<function>
 *       sum         	<function>
 *       v           	complex vector/matrix
 *       x           	real vector/matrix
 *       yx          	real vector/matrix
 *       yy          	complex vector/matrix
 *******************************************************/
      mxArray dg;
      mxArray x;
      mxArray m;
      mxArray c;
      mxArray pw;
      int M = 0;
      int N = 0;
      int K = 0;
      mxArray pw_1;
      int i = 0;
      mxArray M_mx;
      mxArray cx;
      mxArray yx;
      mxArray v;
      mxArray d;
      mxArray yy;
      int I0_ = 0;
      unsigned short B0_ = 0;
      mxArray IM0_;
      mxArray RM0_;
      mxArray CM0_;
      mxArray CM1_;
      mxArray CM2_;
      mxArray CM3_;
      mxArray CM4_;
      mxArray CM5_;
      double C0__r=0.0, C0__i=0.0;
      double R0_ = 0.0;
      double C1__r=0.0, C1__i=0.0;
      double C2__r=0.0, C2__i=0.0;
      
      mccRealInit(x);
      mccImport(&x, ((nrhs_>0) ? prhs_[0] : 0), 0, 0);
      mccRealInit(m);
      mccImportCopy(&m, ((nrhs_>1) ? prhs_[1] : 0), 0, 0);
      mccRealInit(c);
      mccImportCopy(&c, ((nrhs_>2) ? prhs_[2] : 0), 0, 0);
      mccRealInit(pw);
      mccImportCopy(&pw, ((nrhs_>3) ? prhs_[3] : 0), 0, 0);
      mccComplexInit(dg);
      mccComplexInit(pw_1);
      mccRealInit(M_mx);
      mccRealInit(cx);
      mccRealInit(yx);
      mccComplexInit(v);
      mccComplexInit(d);
      mccComplexInit(yy);
      mccIntInit(IM0_);
      mccRealInit(RM0_);
      mccComplexInit(CM0_);
      mccComplexInit(CM1_);
      mccComplexInit(CM2_);
      mccComplexInit(CM3_);
      mccComplexInit(CM4_);
      mccComplexInit(CM5_);
      
      /* % DBAYES		Calculate distance of points to Gaussian clusters */
      /* %  */
      /* % Usage:		D = DBAYES( X, MEANS, COVS [, PW] ) */
      /* %  */
      /* % This function returns the squared bayesian distances for each point  */
      /* % in X from the MEANS of Gaussian distributions, described */
      /* % by their COVS.  Similarity transforms are used to normalize */
      /* % units of comparison. */
      /* %  */
      /* % The distance D is defined such that */
      /* % p(wi)*p(x|wi) = exp(-D)*(2*pi)^(-M/2) */
      /* % which yields */
      /* % D = -log((2*pi)^(M/2)*p(wi)*p(x|wi)) */
      /* % where p(x|wi) is defined as */
      /* % p(x|wi)=exp(-0.5*(x-m)'*inv(c)*(x-m))/sqrt((2*pi)^M*det(c)) */
      /* %  */
      /* % If PW (the probability of class i) is not specified, the values */
      /* % are assume uniform. */
      /* %  */
      /* % See also MAHALANOBIS */
      /*  */
      /* % (c) Copyright 1993-1994 by Dave Caughey.  All rights reserved. */
      /* [M,N] = size( x ); */
      if(mccNOTSET(&x))
      {
         mexErrMsgTxt( "variable x undefined, line 24" );
      }
      mccGetMatrixSize(&M,&N, &x);
      /* [m,c] = class_multi(m,c); */
      if(mccNOTSET(&m))
      {
         mexErrMsgTxt( "variable m undefined, line 25" );
      }
      if(mccNOTSET(&c))
      {
         mexErrMsgTxt( "variable c undefined, line 25" );
      }
      Mprhs_[0] = &m;
      Mprhs_[1] = &c;
      Mplhs_[0] = &m;
      Mplhs_[1] = &c;
      mccCallMATLAB(2, Mplhs_, 2, Mprhs_, "class_multi", 25);
      /* K = size(c,1); */
      K = mccGetDimensionSize(&c, 1);
      /* if nargin == 3, */
      I0_ = mccNargin();
      B0_ = (I0_ == 3);
      if ((double)B0_)
      {
         /* pw = ones(K,1)/K; */
         mccOnesMN(&IM0_, K, 1);
         {
            int i_, j_;
            int m_=1, n_=1, cx_ = 0;
            double *p_pw;
            int I_pw=1;
            int *p_IM0_;
            int I_IM0_=1;
            m_ = mcmCalcResultSize(m_, &n_, mccM(&IM0_), mccN(&IM0_));
            mccAllocateMatrix(&pw, m_, n_);
            I_pw = (mccM(&pw) != 1 || mccN(&pw) != 1);
            p_pw = mccPR(&pw);
            I_IM0_ = (mccM(&IM0_) != 1 || mccN(&IM0_) != 1);
            p_IM0_ = mccIPR(&IM0_);
            if (m_ != 0)
            {
               for (j_=0; j_<n_; ++j_)
               {
                  for (i_=0; i_<m_; ++i_, p_pw+=I_pw, p_IM0_+=I_IM0_)
                  {
                     *p_pw = (((int)*p_IM0_) / (double) K);
                  }
               }
            }
         }
         /* end; */
      }
      /* pw = log(pw); */
      if(mccNOTSET(&pw))
      {
         mexErrMsgTxt( "variable pw undefined, line 30" );
      }
      Mprhs_[0] = &pw;
      Mplhs_[0] = &pw_1;
      mccCallMATLAB(1, Mplhs_, 1, Mprhs_, "log", 30);
      /* for i = 1:K, */
      for (I0_ = 1; I0_ <= K; I0_ = I0_ + 1)
      {
         i = I0_;
         /* [mx,cx] = class_extract( m, c, i ); */
         Mprhs_[0] = &m;
         Mprhs_[1] = &c;
         Mprhs_[2] = mccTempMatrix(i, 0., mccINT, 0 );
         Mplhs_[0] = &M_mx;
         Mplhs_[1] = &cx;
         mccCallMATLAB(2, Mplhs_, 3, Mprhs_, "class_extract", 32);
         /* yx = x-mx*ones(1,N); */
         mccOnesMN(&IM0_, 1, N);
         mccRealMatrixMultiply(&RM0_, &M_mx, &IM0_);
         {
            int i_, j_;
            int m_=1, n_=1, cx_ = 0;
            double *p_yx;
            int I_yx=1;
            double *p_x;
            int I_x=1;
            double *p_RM0_;
            int I_RM0_=1;
            m_ = mcmCalcResultSize(m_, &n_, mccM(&x), mccN(&x));
            m_ = mcmCalcResultSize(m_, &n_, mccM(&RM0_), mccN(&RM0_));
            mccAllocateMatrix(&yx, m_, n_);
            I_yx = (mccM(&yx) != 1 || mccN(&yx) != 1);
            p_yx = mccPR(&yx);
            I_x = (mccM(&x) != 1 || mccN(&x) != 1);
            p_x = mccPR(&x);
            I_RM0_ = (mccM(&RM0_) != 1 || mccN(&RM0_) != 1);
            p_RM0_ = mccPR(&RM0_);
            if (m_ != 0)
            {
               for (j_=0; j_<n_; ++j_)
               {
                  for (i_=0; i_<m_; ++i_, p_yx+=I_yx, p_x+=I_x, p_RM0_+=I_RM0_)
                  {
                     *p_yx = (*p_x - *p_RM0_);
                  }
               }
            }
         }
         /* [v d] = eig(cx); */
         Mprhs_[0] = &cx;
         Mplhs_[0] = &v;
         Mplhs_[1] = &d;
         mccCallMATLAB(2, Mplhs_, 1, Mprhs_, "eig", 34);
         /* yy = diag(1./sqrt(diag(d)))*v'*yx; */
         Mprhs_[0] = &d;
         Mplhs_[0] = &CM0_;
         mccCallMATLAB(1, Mplhs_, 1, Mprhs_, "diag", 35);
         Mprhs_[0] = &CM0_;
         Mplhs_[0] = &CM1_;
         mccCallMATLAB(1, Mplhs_, 1, Mprhs_, "sqrt", 35);
         {
            int i_, j_;
            int m_=1, n_=1, cx_ = 0;
            double *p_CM2_;
            int I_CM2_=1;
            double *q_CM2_;
            double *p_CM1_;
            int I_CM1_=1;
            double *q_CM1_;
            m_ = mcmCalcResultSize(m_, &n_, mccM(&CM1_), mccN(&CM1_));
            mccAllocateMatrix(&CM2_, m_, n_);
            I_CM2_ = (mccM(&CM2_) != 1 || mccN(&CM2_) != 1);
            p_CM2_ = mccPR(&CM2_);
            q_CM2_ = mccPI(&CM2_);
            I_CM1_ = (mccM(&CM1_) != 1 || mccN(&CM1_) != 1);
            p_CM1_ = mccPR(&CM1_);
            q_CM1_ = mccPI(&CM1_);
            if (m_ != 0)
            {
               for (j_=0; j_<n_; ++j_)
               {
                  for (i_=0; i_<m_; ++i_, p_CM2_+=I_CM2_, q_CM2_+=I_CM2_, p_CM1_+=I_CM1_, q_CM1_+=I_CM1_)
                  {
                     {
                        double t_ = mcmDivideRealpart(1, 0., *p_CM1_, *q_CM1_);
                        *q_CM2_ = mcmDivideImagPart(1, 0., *p_CM1_, *q_CM1_);
                        *p_CM2_ = t_;
                     }
                  }
               }
            }
         }
         Mprhs_[0] = &CM2_;
         Mplhs_[0] = &CM3_;
         mccCallMATLAB(1, Mplhs_, 1, Mprhs_, "diag", 35);
         mccConjTrans(&CM4_, &v);
         mccMultiply(&CM5_, &CM3_, &CM4_);
         mccMultiply(&yy, &CM5_, &yx);
         /* if M > 1, */
         if ((M > 1))
         {
            /* dg(i,:) = -pw(i) + log(det(cx))/2 + (sum(yy.^2))/2; */
            Mprhs_[0] = &cx;
            Mplhs_[0] = 0;
            mccCallMATLAB(1, Mplhs_, 1, Mprhs_, "det", 37);
            C0__r = mccImportScalar(&C0__i, 0, 0, Mplhs_[ 0 ], 1, " (dbayes, line 37): C0_");
            R0_ = C0__r;
            mcmLog(&C1__r, &C1__i, R0_, 0.);
            C2__r = ((-(mccGetRealVectorElement(&pw_1, mccRint(i)))) + (C1__r / (double) 2));
            C2__i = ((- mccGetImagVectorElement(&pw_1, mccRint(i))) + (C1__i / (double) 2));
            mccArrayPower(&CM5_, &yy, mccTempMatrix(2, 0., mccINT, 0 ));
            Mprhs_[0] = &CM5_;
            Mplhs_[0] = &CM4_;
            mccCallMATLAB(1, Mplhs_, 1, Mprhs_, "sum", 37);
            {
               int i_, j_;
               int m_=1, n_=1, cx_ = 0;
               double *p_dg;
               int I_dg=1, J_dg;
               double *q_dg;
               double *p_CM4_;
               int I_CM4_=1;
               double *q_CM4_;
               m_ = mcmCalcResultSize(m_, &n_, mccM(&CM4_), mccN(&CM4_));
               mccGrowMatrix(&dg, i, n_);
               if (mccN(&dg) == 1) { I_dg = J_dg = 0;}
               else { I_dg = 1; J_dg=mccM(&dg)-m_; }
               p_dg = mccPR(&dg) + (i-1) + mccM(&dg) * 0;
               q_dg = mccPI(&dg) + (i-1) + mccM(&dg) * 0;
               I_CM4_ = (mccM(&CM4_) != 1 || mccN(&CM4_) != 1);
               p_CM4_ = mccPR(&CM4_);
               q_CM4_ = mccPI(&CM4_);
               if (m_ != 0)
               {
                  for (j_=0; j_<n_; ++j_, p_dg += J_dg, q_dg += J_dg)
                  {
                     for (i_=0; i_<m_; ++i_, p_dg+=I_dg, q_dg+=I_dg, p_CM4_+=I_CM4_, q_CM4_+=I_CM4_)
                     {
                        *p_dg = (C2__r + (*p_CM4_ / (double) 2));
                        *q_dg = (C2__i + (*q_CM4_ / (double) 2));
                     }
                  }
               }
            }
         }
         else
         {
            /* else */
            /* dg(i,:) = -pw(i) + log(cx)/2 + (yy.^2)/2; */
            C2__r = (-(mccGetRealVectorElement(&pw_1, mccRint(i))));
            C2__i = (- mccGetImagVectorElement(&pw_1, mccRint(i)));
            Mprhs_[0] = &cx;
            Mplhs_[0] = &CM4_;
            mccCallMATLAB(1, Mplhs_, 1, Mprhs_, "log", 39);
            mccArrayPower(&CM5_, &yy, mccTempMatrix(2, 0., mccINT, 0 ));
            {
               int i_, j_;
               int m_=1, n_=1, cx_ = 0;
               double *p_dg;
               int I_dg=1, J_dg;
               double *q_dg;
               double *p_CM4_;
               int I_CM4_=1;
               double *q_CM4_;
               double *p_CM5_;
               int I_CM5_=1;
               double *q_CM5_;
               m_ = mcmCalcResultSize(m_, &n_, mccM(&CM4_), mccN(&CM4_));
               m_ = mcmCalcResultSize(m_, &n_, mccM(&CM5_), mccN(&CM5_));
               mccGrowMatrix(&dg, i, n_);
               if (mccN(&dg) == 1) { I_dg = J_dg = 0;}
               else { I_dg = 1; J_dg=mccM(&dg)-m_; }
               p_dg = mccPR(&dg) + (i-1) + mccM(&dg) * 0;
               q_dg = mccPI(&dg) + (i-1) + mccM(&dg) * 0;
               I_CM4_ = (mccM(&CM4_) != 1 || mccN(&CM4_) != 1);
               p_CM4_ = mccPR(&CM4_);
               q_CM4_ = mccPI(&CM4_);
               I_CM5_ = (mccM(&CM5_) != 1 || mccN(&CM5_) != 1);
               p_CM5_ = mccPR(&CM5_);
               q_CM5_ = mccPI(&CM5_);
               if (m_ != 0)
               {
                  for (j_=0; j_<n_; ++j_, p_dg += J_dg, q_dg += J_dg)
                  {
                     for (i_=0; i_<m_; ++i_, p_dg+=I_dg, q_dg+=I_dg, p_CM4_+=I_CM4_, q_CM4_+=I_CM4_, p_CM5_+=I_CM5_, q_CM5_+=I_CM5_)
                     {
                        *p_dg = ((C2__r + (*p_CM4_ / (double) 2)) + (*p_CM5_ / (double) 2));
                        *q_dg = ((C2__i + (*q_CM4_ / (double) 2)) + (*q_CM5_ / (double) 2));
                     }
                  }
               }
            }
            /* end */
         }
         /* end; */
      }
      mccReturnFirstValue(&plhs_[0], &dg);
   }
   return;
}
