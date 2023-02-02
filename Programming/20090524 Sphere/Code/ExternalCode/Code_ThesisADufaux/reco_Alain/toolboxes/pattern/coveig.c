static char mc_version[] = "MATLAB Compiler 1.2 Jan 17 1998 infun";
/*
 *  MATLAB Compiler: 1.2
 *  Date: Jan 17 1998
 *  Arguments: coveig 
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
 *       CM0_        	complex vector/matrix temporary
 *       IM0_        	integer vector/matrix temporary
 *       cov         	<function>
 *       coveig      	<function being defined>
 *       cx          	complex vector/matrix
 *       d           	complex vector/matrix
 *       di          	integer vector/matrix
 *       diag        	<function>
 *       du          	complex vector/matrix
 *       eig         	<function>
 *       sort        	<function>
 *       v           	complex vector/matrix
 *       x           	complex vector/matrix
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
   

   if (nrhs_ > 1 )
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
      mxArray v;
      mxArray d;
      mxArray cx;
      mxArray x;
      mxArray du;
      mxArray di;
      mxArray CM0_;
      mxArray IM0_;
      
      mccComplexInit(x);
      mccImport(&x, ((nrhs_>0) ? prhs_[0] : 0), 0, 0);
      mccComplexInit(v);
      mccComplexInit(d);
      mccComplexInit(cx);
      mccComplexInit(du);
      mccIntInit(di);
      mccComplexInit(CM0_);
      mccIntInit(IM0_);
      
      /* % COVEIG		Perform eigenanalysis on the covariance matrix of a data set */
      /* %  */
      /* % Usage:		[V,D,CX] = COVEIG( X ) */
      /* %  */
      /* % This function performs eigenanalysis on a matrix of feature vectors X. */
      /* %  */
      /* % The eigenvectors V and eigenvalues D are returned sorted by descending */
      /* % eigenvalue. */
      /*  */
      /* % (c) Copyright 1993-1994 by Dave Caughey.  All rights reserved. */
      /* cx = cov(x'); */
      if(mccNOTSET(&x))
      {
         mexErrMsgTxt( "variable x undefined, line 12" );
      }
      mccConjTrans(&CM0_, &x);
      Mprhs_[0] = &CM0_;
      Mplhs_[0] = &cx;
      mccCallMATLAB(1, Mplhs_, 1, Mprhs_, "cov", 12);
      /* [v,d] = eig(cx); */
      Mprhs_[0] = &cx;
      Mplhs_[0] = &v;
      Mplhs_[1] = &d;
      mccCallMATLAB(2, Mplhs_, 1, Mprhs_, "eig", 13);
      /* du=diag(d); */
      Mprhs_[0] = &d;
      Mplhs_[0] = &du;
      mccCallMATLAB(1, Mplhs_, 1, Mprhs_, "diag", 14);
      /* [d di] = sort(-du);d=-d;v=v(:,di); */
      {
         int i_, j_;
         int m_=1, n_=1, cx_ = 0;
         double *p_CM0_;
         int I_CM0_=1;
         double *q_CM0_;
         double *p_du;
         int I_du=1;
         double *q_du;
         m_ = mcmCalcResultSize(m_, &n_, mccM(&du), mccN(&du));
         mccAllocateMatrix(&CM0_, m_, n_);
         I_CM0_ = (mccM(&CM0_) != 1 || mccN(&CM0_) != 1);
         p_CM0_ = mccPR(&CM0_);
         q_CM0_ = mccPI(&CM0_);
         I_du = (mccM(&du) != 1 || mccN(&du) != 1);
         p_du = mccPR(&du);
         q_du = mccPI(&du);
         if (m_ != 0)
         {
            for (j_=0; j_<n_; ++j_)
            {
               for (i_=0; i_<m_; ++i_, p_CM0_+=I_CM0_, q_CM0_+=I_CM0_, p_du+=I_du, q_du+=I_du)
               {
                  *p_CM0_ = (-*p_du);
                  *q_CM0_ = (- *q_du);
               }
            }
         }
      }
      mccSTRING(&CM0_) = 0;
      Mprhs_[0] = &CM0_;
      Mplhs_[0] = &d;
      Mplhs_[1] = &di;
      mccCallMATLAB(2, Mplhs_, 1, Mprhs_, "sort", 15);
      {
         int i_, j_;
         int m_=1, n_=1, cx_ = 0;
         double *p_d;
         int I_d=1;
         double *q_d;
         double *p_1d;
         int I_1d=1;
         double *q_1d;
         m_ = mcmCalcResultSize(m_, &n_, mccM(&d), mccN(&d));
         mccAllocateMatrix(&d, m_, n_);
         I_d = (mccM(&d) != 1 || mccN(&d) != 1);
         p_d = mccPR(&d);
         q_d = mccPI(&d);
         I_1d = (mccM(&d) != 1 || mccN(&d) != 1);
         p_1d = mccPR(&d);
         q_1d = mccPI(&d);
         if (m_ != 0)
         {
            for (j_=0; j_<n_; ++j_)
            {
               for (i_=0; i_<m_; ++i_, p_d+=I_d, q_d+=I_d, p_1d+=I_1d, q_1d+=I_1d)
               {
                  *p_d = (-*p_1d);
                  *q_d = (- *q_1d);
               }
            }
         }
      }
      mccFindIndex(&IM0_, &di);
      {
         int i_, j_;
         int m_=1, n_=1, cx_ = 0;
         double *p_CM0_;
         int I_CM0_=1;
         double *q_CM0_;
         double *p_v;
         int I_v=1;
         double *q_v;
         int *p_IM0_;
         int I_IM0_=1;
         m_ = mcmCalcResultSize(m_, &n_, mccM(&v), (mccM(&IM0_) * mccN(&IM0_)));
         mccAllocateMatrix(&CM0_, m_, n_);
         mccCheckMatrixSize(&v, mccM(&v), mccGetMaxIndex(&IM0_ ,mccN(&v)));
         I_CM0_ = (mccM(&CM0_) != 1 || mccN(&CM0_) != 1);
         p_CM0_ = mccPR(&CM0_);
         q_CM0_ = mccPI(&CM0_);
         I_IM0_ = (mccM(&IM0_) != 1 || mccN(&IM0_) != 1);
         p_IM0_ = mccIPR(&IM0_);
         if (m_ != 0)
         {
            for (j_=0; j_<n_; ++j_, p_IM0_ += I_IM0_)
            {
               p_v = mccPR(&v) + mccM(&v) * ((int)(*p_IM0_ - .5)) + 0;
               q_v = mccPI(&v) + mccM(&v) * ((int)(*p_IM0_ - .5)) + 0;
               for (i_=0; i_<m_; ++i_, p_CM0_+=I_CM0_, q_CM0_+=I_CM0_, p_v+=I_v, q_v+=I_v)
               {
                  *p_CM0_ = *p_v;
                  *q_CM0_ = *q_v;
               }
            }
         }
      }
      mccCopy(&v, &CM0_);
      mccReturnFirstValue(&plhs_[0], &v);
      mccReturnValue(&plhs_[1], &d);
      mccReturnValue(&plhs_[2], &cx);
   }
   else
   {
/***************** Compiler Assumptions ****************
 *
 *       CM0_        	complex vector/matrix temporary
 *       IM0_        	integer vector/matrix temporary
 *       RM0_        	real vector/matrix temporary
 *       cov         	<function>
 *       coveig      	<function being defined>
 *       cx          	real vector/matrix
 *       d           	complex vector/matrix
 *       di          	integer vector/matrix
 *       diag        	<function>
 *       du          	complex vector/matrix
 *       eig         	<function>
 *       sort        	<function>
 *       v           	complex vector/matrix
 *       x           	real vector/matrix
 *******************************************************/
      mxArray v;
      mxArray d;
      mxArray cx;
      mxArray x;
      mxArray du;
      mxArray di;
      mxArray RM0_;
      mxArray CM0_;
      mxArray IM0_;
      
      mccRealInit(x);
      mccImport(&x, ((nrhs_>0) ? prhs_[0] : 0), 0, 0);
      mccComplexInit(v);
      mccComplexInit(d);
      mccRealInit(cx);
      mccComplexInit(du);
      mccIntInit(di);
      mccRealInit(RM0_);
      mccComplexInit(CM0_);
      mccIntInit(IM0_);
      
      /* % COVEIG		Perform eigenanalysis on the covariance matrix of a data set */
      /* %  */
      /* % Usage:		[V,D,CX] = COVEIG( X ) */
      /* %  */
      /* % This function performs eigenanalysis on a matrix of feature vectors X. */
      /* %  */
      /* % The eigenvectors V and eigenvalues D are returned sorted by descending */
      /* % eigenvalue. */
      /*  */
      /* % (c) Copyright 1993-1994 by Dave Caughey.  All rights reserved. */
      /* cx = cov(x'); */
      if(mccNOTSET(&x))
      {
         mexErrMsgTxt( "variable x undefined, line 12" );
      }
      mccConjTrans(&RM0_, &x);
      Mprhs_[0] = &RM0_;
      Mplhs_[0] = &cx;
      mccCallMATLAB(1, Mplhs_, 1, Mprhs_, "cov", 12);
      /* [v,d] = eig(cx); */
      Mprhs_[0] = &cx;
      Mplhs_[0] = &v;
      Mplhs_[1] = &d;
      mccCallMATLAB(2, Mplhs_, 1, Mprhs_, "eig", 13);
      /* du=diag(d); */
      Mprhs_[0] = &d;
      Mplhs_[0] = &du;
      mccCallMATLAB(1, Mplhs_, 1, Mprhs_, "diag", 14);
      /* [d di] = sort(-du);d=-d;v=v(:,di); */
      {
         int i_, j_;
         int m_=1, n_=1, cx_ = 0;
         double *p_CM0_;
         int I_CM0_=1;
         double *q_CM0_;
         double *p_du;
         int I_du=1;
         double *q_du;
         m_ = mcmCalcResultSize(m_, &n_, mccM(&du), mccN(&du));
         mccAllocateMatrix(&CM0_, m_, n_);
         I_CM0_ = (mccM(&CM0_) != 1 || mccN(&CM0_) != 1);
         p_CM0_ = mccPR(&CM0_);
         q_CM0_ = mccPI(&CM0_);
         I_du = (mccM(&du) != 1 || mccN(&du) != 1);
         p_du = mccPR(&du);
         q_du = mccPI(&du);
         if (m_ != 0)
         {
            for (j_=0; j_<n_; ++j_)
            {
               for (i_=0; i_<m_; ++i_, p_CM0_+=I_CM0_, q_CM0_+=I_CM0_, p_du+=I_du, q_du+=I_du)
               {
                  *p_CM0_ = (-*p_du);
                  *q_CM0_ = (- *q_du);
               }
            }
         }
      }
      mccSTRING(&CM0_) = 0;
      Mprhs_[0] = &CM0_;
      Mplhs_[0] = &d;
      Mplhs_[1] = &di;
      mccCallMATLAB(2, Mplhs_, 1, Mprhs_, "sort", 15);
      {
         int i_, j_;
         int m_=1, n_=1, cx_ = 0;
         double *p_d;
         int I_d=1;
         double *q_d;
         double *p_1d;
         int I_1d=1;
         double *q_1d;
         m_ = mcmCalcResultSize(m_, &n_, mccM(&d), mccN(&d));
         mccAllocateMatrix(&d, m_, n_);
         I_d = (mccM(&d) != 1 || mccN(&d) != 1);
         p_d = mccPR(&d);
         q_d = mccPI(&d);
         I_1d = (mccM(&d) != 1 || mccN(&d) != 1);
         p_1d = mccPR(&d);
         q_1d = mccPI(&d);
         if (m_ != 0)
         {
            for (j_=0; j_<n_; ++j_)
            {
               for (i_=0; i_<m_; ++i_, p_d+=I_d, q_d+=I_d, p_1d+=I_1d, q_1d+=I_1d)
               {
                  *p_d = (-*p_1d);
                  *q_d = (- *q_1d);
               }
            }
         }
      }
      mccFindIndex(&IM0_, &di);
      {
         int i_, j_;
         int m_=1, n_=1, cx_ = 0;
         double *p_CM0_;
         int I_CM0_=1;
         double *q_CM0_;
         double *p_v;
         int I_v=1;
         double *q_v;
         int *p_IM0_;
         int I_IM0_=1;
         m_ = mcmCalcResultSize(m_, &n_, mccM(&v), (mccM(&IM0_) * mccN(&IM0_)));
         mccAllocateMatrix(&CM0_, m_, n_);
         mccCheckMatrixSize(&v, mccM(&v), mccGetMaxIndex(&IM0_ ,mccN(&v)));
         I_CM0_ = (mccM(&CM0_) != 1 || mccN(&CM0_) != 1);
         p_CM0_ = mccPR(&CM0_);
         q_CM0_ = mccPI(&CM0_);
         I_IM0_ = (mccM(&IM0_) != 1 || mccN(&IM0_) != 1);
         p_IM0_ = mccIPR(&IM0_);
         if (m_ != 0)
         {
            for (j_=0; j_<n_; ++j_, p_IM0_ += I_IM0_)
            {
               p_v = mccPR(&v) + mccM(&v) * ((int)(*p_IM0_ - .5)) + 0;
               q_v = mccPI(&v) + mccM(&v) * ((int)(*p_IM0_ - .5)) + 0;
               for (i_=0; i_<m_; ++i_, p_CM0_+=I_CM0_, q_CM0_+=I_CM0_, p_v+=I_v, q_v+=I_v)
               {
                  *p_CM0_ = *p_v;
                  *q_CM0_ = *q_v;
               }
            }
         }
      }
      mccCopy(&v, &CM0_);
      mccReturnFirstValue(&plhs_[0], &v);
      mccReturnValue(&plhs_[1], &d);
      mccReturnValue(&plhs_[2], &cx);
   }
   return;
}
