static char mc_version[] = "MATLAB Compiler 1.2 Jan 17 1998 infun";
/*
 *  MATLAB Compiler: 1.2
 *  Date: Jan 17 1998
 *  Arguments: class_multi 
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

/* static array S0_ (1 x 11) text, line 16: 'class_multi' */
static unsigned short S0__r_[] =
{
         99,  108,   97,  115,  115,   95,  109,  117,
        108,  116,  105,
};
static mxArray S0_ = mccCINIT( mccTEXT,  1, 11, S0__r_, 0);
/* static array S1_ (1 x 50) text, line 34: 'class_multi: incorrect st...' */
static unsigned short S1__r_[] =
{
         99,  108,   97,  115,  115,   95,  109,  117,
        108,  116,  105,   58,   32,  105,  110,   99,
        111,  114,  114,  101,   99,  116,   32,  115,
        116,   97,  116,  105,  115,  116,  105,   99,
        115,   32,  115,  112,  101,   99,  105,  102,
        105,   99,   97,  116,  105,  111,  110,  115,
         92,  110,
};
static mxArray S1_ = mccCINIT( mccTEXT,  1, 50, S1__r_, 0);
/* static array S2_ (1 x 11) text, line 16: 'class_multi' */
static unsigned short S2__r_[] =
{
         99,  108,   97,  115,  115,   95,  109,  117,
        108,  116,  105,
};
static mxArray S2_ = mccCINIT( mccTEXT,  1, 11, S2__r_, 0);
/* static array S3_ (1 x 50) text, line 34: 'class_multi: incorrect st...' */
static unsigned short S3__r_[] =
{
         99,  108,   97,  115,  115,   95,  109,  117,
        108,  116,  105,   58,   32,  105,  110,   99,
        111,  114,  114,  101,   99,  116,   32,  115,
        116,   97,  116,  105,  115,  116,  105,   99,
        115,   32,  115,  112,  101,   99,  105,  102,
        105,   99,   97,  116,  105,  111,  110,  115,
         92,  110,
};
static mxArray S3_ = mccCINIT( mccTEXT,  1, 50, S3__r_, 0);
/***************** Compiler Assumptions ****************
 *
 *       B0_         	boolean scalar temporary
 *       BM0_        	boolean vector/matrix temporary
 *       BM1_        	boolean vector/matrix temporary
 *       BM2_        	boolean vector/matrix temporary
 *       BM3_        	boolean vector/matrix temporary
 *       CM0_        	complex vector/matrix temporary
 *       I0_         	integer scalar temporary
 *       I1_         	integer scalar temporary
 *       IM0_        	integer vector/matrix temporary
 *       IM1_        	integer vector/matrix temporary
 *       K           	real vector/matrix
 *       M           	real vector/matrix
 *       RM0_        	real vector/matrix temporary
 *       RM1_        	real vector/matrix temporary
 *       RM2_        	real vector/matrix temporary
 *       all         	<function>
 *       class_multi 	<function being defined>
 *       cnew        	complex vector/matrix
 *       cold        	complex vector/matrix
 *       csize       	integer vector/matrix
 *       fprintf     	<function>
 *       help        	<function>
 *       length      	<function>
 *       mnew        	complex vector/matrix
 *       mold        	complex vector/matrix
 *       msize       	integer vector/matrix
 *       nargin      	<function>
 *       nargout     	<function>
 *       prod        	<function>
 *       size        	<function>
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
   mxArray *Mprhs_[2];
   

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
      mxArray mnew;
      mxArray cnew;
      mxArray mold;
      mxArray cold;
      mxArray msize;
      mxArray csize;
      mxArray M;
      mxArray K;
      int I0_ = 0;
      int I1_ = 0;
      unsigned short B0_ = 0;
      mxArray IM0_;
      mxArray RM0_;
      mxArray BM0_;
      mxArray BM1_;
      mxArray IM1_;
      mxArray RM1_;
      mxArray RM2_;
      mxArray BM2_;
      mxArray BM3_;
      mxArray CM0_;
      
      mccComplexInit(mold);
      mccImport(&mold, ((nrhs_>0) ? prhs_[0] : 0), 0, 0);
      mccComplexInit(cold);
      mccImport(&cold, ((nrhs_>1) ? prhs_[1] : 0), 0, 0);
      mccComplexInit(mnew);
      mccComplexInit(cnew);
      mccIntInit(msize);
      mccIntInit(csize);
      mccRealInit(M);
      mccRealInit(K);
      mccIntInit(IM0_);
      mccRealInit(RM0_);
      mccBoolInit(BM0_);
      mccBoolInit(BM1_);
      mccIntInit(IM1_);
      mccRealInit(RM1_);
      mccRealInit(RM2_);
      mccBoolInit(BM2_);
      mccBoolInit(BM3_);
      mccComplexInit(CM0_);
      
      /* % CLASS_MULTI	Force class statistics into multi-class lists of statistics */
      /* %  */
      /* % Usage:		[M_NEW,C_NEW] = CLASS_MULTI( M_OLD, C_OLD ) */
      /* %  */
      /* % This function eliminates ambiguity over the dimensionality and */
      /* % number of classes that can exist when examining only either the */
      /* % means or covariances alone. */
      /* %  */
      /* % Multi-class lists of statistics are returned.  If M_OLD and C_OLD */
      /* % are already multi-class lists, nothing is done. */
      /*  */
      /* % (c) Copyright 1993-1995 by Dave Caughey.  All rights reserved. */
      /*  */
      /* if nargin ~= 2 | nargout ~= 2, */
      I0_ = mccNargin();
      B0_ = (I0_ != 2);
      if (!(double)B0_)
      {
         I1_ = mccNargout();
         B0_ = (I1_ != 2);
      }
      if ((double)B0_)
      {
         /* help class_multi */
         Mprhs_[0] = &S0_;
         Mplhs_[0] = 0;
         mccCallMATLAB(0, Mplhs_, 1, Mprhs_, "help", 16);
         /* return */
         goto MretC;
         /* end */
      }
      /*  */
      /* msize = prod(size(mold)); */
      if(mccNOTSET(&mold))
      {
         mexErrMsgTxt( "variable mold undefined, line 20" );
      }
      mccSize(&IM0_, &mold);
      Mprhs_[0] = &IM0_;
      Mplhs_[0] = &msize;
      mccCallMATLAB(1, Mplhs_, 1, Mprhs_, "prod", 20);
      /* csize = prod(size(cold)); */
      if(mccNOTSET(&cold))
      {
         mexErrMsgTxt( "variable cold undefined, line 21" );
      }
      mccSize(&IM0_, &cold);
      Mprhs_[0] = &IM0_;
      Mplhs_[0] = &csize;
      mccCallMATLAB(1, Mplhs_, 1, Mprhs_, "prod", 21);
      /* M = csize/msize; */
      mccRealRightDivide(&M, &csize, &msize);
      /* K = msize/M; */
      mccRealRightDivide(&K, &msize, &M);
      /*  */
      /* if all( size(mold) == [K M] ) & all( size(cold) == [K M^2] ), */
      mccSize(&IM0_, &mold);
      mccCatenateColumns(&RM0_, &K, &M);
      {
         int i_, j_;
         int m_=1, n_=1, cx_ = 0;
         unsigned short *p_BM0_;
         int I_BM0_=1;
         int *p_IM0_;
         int I_IM0_=1;
         double *p_RM0_;
         int I_RM0_=1;
         m_ = mcmCalcResultSize(m_, &n_, mccM(&IM0_), mccN(&IM0_));
         m_ = mcmCalcResultSize(m_, &n_, mccM(&RM0_), mccN(&RM0_));
         mccAllocateMatrix(&BM0_, m_, n_);
         I_BM0_ = (mccM(&BM0_) != 1 || mccN(&BM0_) != 1);
         p_BM0_ = mccSPR(&BM0_);
         I_IM0_ = (mccM(&IM0_) != 1 || mccN(&IM0_) != 1);
         p_IM0_ = mccIPR(&IM0_);
         I_RM0_ = (mccM(&RM0_) != 1 || mccN(&RM0_) != 1);
         p_RM0_ = mccPR(&RM0_);
         if (m_ != 0)
         {
            for (j_=0; j_<n_; ++j_)
            {
               for (i_=0; i_<m_; ++i_, p_BM0_+=I_BM0_, p_IM0_+=I_IM0_, p_RM0_+=I_RM0_)
               {
                  *p_BM0_ = ( (((int)*p_IM0_) == *p_RM0_) && !mccREL_NAN(*p_RM0_) );
               }
            }
         }
      }
      mccAll(&BM1_, &BM0_);
      B0_ = mccIfCondition(&BM1_);
      if ((double)B0_)
      {
         mccSize(&IM1_, &cold);
         mccPower(&RM1_, &M, mccTempMatrix(2, 0., mccINT, 0 ));
         mccCatenateColumns(&RM2_, &K, &RM1_);
         {
            int i_, j_;
            int m_=1, n_=1, cx_ = 0;
            unsigned short *p_BM2_;
            int I_BM2_=1;
            int *p_IM1_;
            int I_IM1_=1;
            double *p_RM2_;
            int I_RM2_=1;
            m_ = mcmCalcResultSize(m_, &n_, mccM(&IM1_), mccN(&IM1_));
            m_ = mcmCalcResultSize(m_, &n_, mccM(&RM2_), mccN(&RM2_));
            mccAllocateMatrix(&BM2_, m_, n_);
            I_BM2_ = (mccM(&BM2_) != 1 || mccN(&BM2_) != 1);
            p_BM2_ = mccSPR(&BM2_);
            I_IM1_ = (mccM(&IM1_) != 1 || mccN(&IM1_) != 1);
            p_IM1_ = mccIPR(&IM1_);
            I_RM2_ = (mccM(&RM2_) != 1 || mccN(&RM2_) != 1);
            p_RM2_ = mccPR(&RM2_);
            if (m_ != 0)
            {
               for (j_=0; j_<n_; ++j_)
               {
                  for (i_=0; i_<m_; ++i_, p_BM2_+=I_BM2_, p_IM1_+=I_IM1_, p_RM2_+=I_RM2_)
                  {
                     *p_BM2_ = ( (((int)*p_IM1_) == *p_RM2_) && !mccREL_NAN(*p_RM2_) );
                  }
               }
            }
         }
         mccAll(&BM3_, &BM2_);
         B0_ = mccIfCondition(&BM3_);
      }
      if ((double)B0_)
      {
         /* mnew = mold; */
         mccCopy(&mnew, &mold);
         mccLOG(&mnew) = mccLOG(&mold);
         mccSTRING(&mnew) = mccSTRING(&mold);
         /* cnew = cold; */
         mccCopy(&cnew, &cold);
         mccLOG(&cnew) = mccLOG(&cold);
         mccSTRING(&cnew) = mccSTRING(&cold);
      }
      else
      {
         /* elseif length(mold(:)) == M & all( size(cold) == [M M] ), */
         mccCopy(&CM0_, &mold);
         mxSetM( &CM0_, mccM(&CM0_) * mccN(&CM0_));
         mxSetN( &CM0_, 1);
         I1_ = mccGetLength(&CM0_);
         {
            int i_, j_;
            int m_=1, n_=1, cx_ = 0;
            unsigned short *p_BM3_;
            int I_BM3_=1;
            double *p_M;
            int I_M=1;
            m_ = mcmCalcResultSize(m_, &n_, mccM(&M), mccN(&M));
            mccAllocateMatrix(&BM3_, m_, n_);
            I_BM3_ = (mccM(&BM3_) != 1 || mccN(&BM3_) != 1);
            p_BM3_ = mccSPR(&BM3_);
            I_M = (mccM(&M) != 1 || mccN(&M) != 1);
            p_M = mccPR(&M);
            if (m_ != 0)
            {
               for (j_=0; j_<n_; ++j_)
               {
                  for (i_=0; i_<m_; ++i_, p_BM3_+=I_BM3_, p_M+=I_M)
                  {
                     *p_BM3_ = ( (I1_ == *p_M) && !mccREL_NAN(*p_M) );
                  }
               }
            }
         }
         B0_ = mccIfCondition(&BM3_);
         if ((double)B0_)
         {
            mccSize(&IM1_, &cold);
            mccCatenateColumns(&RM2_, &M, &M);
            {
               int i_, j_;
               int m_=1, n_=1, cx_ = 0;
               unsigned short *p_BM2_;
               int I_BM2_=1;
               int *p_IM1_;
               int I_IM1_=1;
               double *p_RM2_;
               int I_RM2_=1;
               m_ = mcmCalcResultSize(m_, &n_, mccM(&IM1_), mccN(&IM1_));
               m_ = mcmCalcResultSize(m_, &n_, mccM(&RM2_), mccN(&RM2_));
               mccAllocateMatrix(&BM2_, m_, n_);
               I_BM2_ = (mccM(&BM2_) != 1 || mccN(&BM2_) != 1);
               p_BM2_ = mccSPR(&BM2_);
               I_IM1_ = (mccM(&IM1_) != 1 || mccN(&IM1_) != 1);
               p_IM1_ = mccIPR(&IM1_);
               I_RM2_ = (mccM(&RM2_) != 1 || mccN(&RM2_) != 1);
               p_RM2_ = mccPR(&RM2_);
               if (m_ != 0)
               {
                  for (j_=0; j_<n_; ++j_)
                  {
                     for (i_=0; i_<m_; ++i_, p_BM2_+=I_BM2_, p_IM1_+=I_IM1_, p_RM2_+=I_RM2_)
                     {
                        *p_BM2_ = ( (((int)*p_IM1_) == *p_RM2_) && !mccREL_NAN(*p_RM2_) );
                     }
                  }
               }
            }
            mccAll(&BM1_, &BM2_);
            B0_ = mccIfCondition(&BM1_);
         }
         if ((double)B0_)
         {
            /* mnew = mold(:)'; */
            mccCopy(&CM0_, &mold);
            mxSetM( &CM0_, mccM(&CM0_) * mccN(&CM0_));
            mxSetN( &CM0_, 1);
            mccConjTrans(&mnew, &CM0_);
            /* cnew = cold(:)'; */
            mccCopy(&CM0_, &cold);
            mxSetM( &CM0_, mccM(&CM0_) * mccN(&CM0_));
            mxSetN( &CM0_, 1);
            mccConjTrans(&cnew, &CM0_);
         }
         else
         {
            /* else */
            /* mnew = []; */
            mccCreateEmpty(&mnew);
            /* cnew = []; */
            mccCreateEmpty(&cnew);
            /* fprintf( 'class_multi: incorrect statistics specifications\n' ); */
            Mprhs_[0] = &S1_;
            Mplhs_[0] = 0;
            mccCallMATLAB(0, Mplhs_, 1, Mprhs_, "fprintf", 34);
            /* end; */
         }
      }
      MretC: ;
      mccReturnFirstValue(&plhs_[0], &mnew);
      mccReturnValue(&plhs_[1], &cnew);
   }
   else
   {
/***************** Compiler Assumptions ****************
 *
 *       B0_         	boolean scalar temporary
 *       BM0_        	boolean vector/matrix temporary
 *       BM1_        	boolean vector/matrix temporary
 *       BM2_        	boolean vector/matrix temporary
 *       BM3_        	boolean vector/matrix temporary
 *       I0_         	integer scalar temporary
 *       I1_         	integer scalar temporary
 *       IM0_        	integer vector/matrix temporary
 *       IM1_        	integer vector/matrix temporary
 *       K           	real vector/matrix
 *       M           	real vector/matrix
 *       RM0_        	real vector/matrix temporary
 *       RM1_        	real vector/matrix temporary
 *       RM2_        	real vector/matrix temporary
 *       all         	<function>
 *       class_multi 	<function being defined>
 *       cnew        	real vector/matrix
 *       cold        	real vector/matrix
 *       csize       	integer vector/matrix
 *       fprintf     	<function>
 *       help        	<function>
 *       length      	<function>
 *       mnew        	real vector/matrix
 *       mold        	real vector/matrix
 *       msize       	integer vector/matrix
 *       nargin      	<function>
 *       nargout     	<function>
 *       prod        	<function>
 *       size        	<function>
 *******************************************************/
      mxArray mnew;
      mxArray cnew;
      mxArray mold;
      mxArray cold;
      mxArray msize;
      mxArray csize;
      mxArray M;
      mxArray K;
      int I0_ = 0;
      int I1_ = 0;
      unsigned short B0_ = 0;
      mxArray IM0_;
      mxArray RM0_;
      mxArray BM0_;
      mxArray BM1_;
      mxArray IM1_;
      mxArray RM1_;
      mxArray RM2_;
      mxArray BM2_;
      mxArray BM3_;
      
      mccRealInit(mold);
      mccImport(&mold, ((nrhs_>0) ? prhs_[0] : 0), 0, 0);
      mccRealInit(cold);
      mccImport(&cold, ((nrhs_>1) ? prhs_[1] : 0), 0, 0);
      mccRealInit(mnew);
      mccRealInit(cnew);
      mccIntInit(msize);
      mccIntInit(csize);
      mccRealInit(M);
      mccRealInit(K);
      mccIntInit(IM0_);
      mccRealInit(RM0_);
      mccBoolInit(BM0_);
      mccBoolInit(BM1_);
      mccIntInit(IM1_);
      mccRealInit(RM1_);
      mccRealInit(RM2_);
      mccBoolInit(BM2_);
      mccBoolInit(BM3_);
      
      /* % CLASS_MULTI	Force class statistics into multi-class lists of statistics */
      /* %  */
      /* % Usage:		[M_NEW,C_NEW] = CLASS_MULTI( M_OLD, C_OLD ) */
      /* %  */
      /* % This function eliminates ambiguity over the dimensionality and */
      /* % number of classes that can exist when examining only either the */
      /* % means or covariances alone. */
      /* %  */
      /* % Multi-class lists of statistics are returned.  If M_OLD and C_OLD */
      /* % are already multi-class lists, nothing is done. */
      /*  */
      /* % (c) Copyright 1993-1995 by Dave Caughey.  All rights reserved. */
      /*  */
      /* if nargin ~= 2 | nargout ~= 2, */
      I0_ = mccNargin();
      B0_ = (I0_ != 2);
      if (!(double)B0_)
      {
         I1_ = mccNargout();
         B0_ = (I1_ != 2);
      }
      if ((double)B0_)
      {
         /* help class_multi */
         Mprhs_[0] = &S2_;
         Mplhs_[0] = 0;
         mccCallMATLAB(0, Mplhs_, 1, Mprhs_, "help", 16);
         /* return */
         goto MretR;
         /* end */
      }
      /*  */
      /* msize = prod(size(mold)); */
      if(mccNOTSET(&mold))
      {
         mexErrMsgTxt( "variable mold undefined, line 20" );
      }
      mccSize(&IM0_, &mold);
      Mprhs_[0] = &IM0_;
      Mplhs_[0] = &msize;
      mccCallMATLAB(1, Mplhs_, 1, Mprhs_, "prod", 20);
      /* csize = prod(size(cold)); */
      if(mccNOTSET(&cold))
      {
         mexErrMsgTxt( "variable cold undefined, line 21" );
      }
      mccSize(&IM0_, &cold);
      Mprhs_[0] = &IM0_;
      Mplhs_[0] = &csize;
      mccCallMATLAB(1, Mplhs_, 1, Mprhs_, "prod", 21);
      /* M = csize/msize; */
      mccRealRightDivide(&M, &csize, &msize);
      /* K = msize/M; */
      mccRealRightDivide(&K, &msize, &M);
      /*  */
      /* if all( size(mold) == [K M] ) & all( size(cold) == [K M^2] ), */
      mccSize(&IM0_, &mold);
      mccCatenateColumns(&RM0_, &K, &M);
      {
         int i_, j_;
         int m_=1, n_=1, cx_ = 0;
         unsigned short *p_BM0_;
         int I_BM0_=1;
         int *p_IM0_;
         int I_IM0_=1;
         double *p_RM0_;
         int I_RM0_=1;
         m_ = mcmCalcResultSize(m_, &n_, mccM(&IM0_), mccN(&IM0_));
         m_ = mcmCalcResultSize(m_, &n_, mccM(&RM0_), mccN(&RM0_));
         mccAllocateMatrix(&BM0_, m_, n_);
         I_BM0_ = (mccM(&BM0_) != 1 || mccN(&BM0_) != 1);
         p_BM0_ = mccSPR(&BM0_);
         I_IM0_ = (mccM(&IM0_) != 1 || mccN(&IM0_) != 1);
         p_IM0_ = mccIPR(&IM0_);
         I_RM0_ = (mccM(&RM0_) != 1 || mccN(&RM0_) != 1);
         p_RM0_ = mccPR(&RM0_);
         if (m_ != 0)
         {
            for (j_=0; j_<n_; ++j_)
            {
               for (i_=0; i_<m_; ++i_, p_BM0_+=I_BM0_, p_IM0_+=I_IM0_, p_RM0_+=I_RM0_)
               {
                  *p_BM0_ = ( (((int)*p_IM0_) == *p_RM0_) && !mccREL_NAN(*p_RM0_) );
               }
            }
         }
      }
      mccAll(&BM1_, &BM0_);
      B0_ = mccIfCondition(&BM1_);
      if ((double)B0_)
      {
         mccSize(&IM1_, &cold);
         mccPower(&RM1_, &M, mccTempMatrix(2, 0., mccINT, 0 ));
         mccCatenateColumns(&RM2_, &K, &RM1_);
         {
            int i_, j_;
            int m_=1, n_=1, cx_ = 0;
            unsigned short *p_BM2_;
            int I_BM2_=1;
            int *p_IM1_;
            int I_IM1_=1;
            double *p_RM2_;
            int I_RM2_=1;
            m_ = mcmCalcResultSize(m_, &n_, mccM(&IM1_), mccN(&IM1_));
            m_ = mcmCalcResultSize(m_, &n_, mccM(&RM2_), mccN(&RM2_));
            mccAllocateMatrix(&BM2_, m_, n_);
            I_BM2_ = (mccM(&BM2_) != 1 || mccN(&BM2_) != 1);
            p_BM2_ = mccSPR(&BM2_);
            I_IM1_ = (mccM(&IM1_) != 1 || mccN(&IM1_) != 1);
            p_IM1_ = mccIPR(&IM1_);
            I_RM2_ = (mccM(&RM2_) != 1 || mccN(&RM2_) != 1);
            p_RM2_ = mccPR(&RM2_);
            if (m_ != 0)
            {
               for (j_=0; j_<n_; ++j_)
               {
                  for (i_=0; i_<m_; ++i_, p_BM2_+=I_BM2_, p_IM1_+=I_IM1_, p_RM2_+=I_RM2_)
                  {
                     *p_BM2_ = ( (((int)*p_IM1_) == *p_RM2_) && !mccREL_NAN(*p_RM2_) );
                  }
               }
            }
         }
         mccAll(&BM3_, &BM2_);
         B0_ = mccIfCondition(&BM3_);
      }
      if ((double)B0_)
      {
         /* mnew = mold; */
         mccCopy(&mnew, &mold);
         mccLOG(&mnew) = mccLOG(&mold);
         mccSTRING(&mnew) = mccSTRING(&mold);
         /* cnew = cold; */
         mccCopy(&cnew, &cold);
         mccLOG(&cnew) = mccLOG(&cold);
         mccSTRING(&cnew) = mccSTRING(&cold);
      }
      else
      {
         /* elseif length(mold(:)) == M & all( size(cold) == [M M] ), */
         mccCopy(&RM2_, &mold);
         mxSetM( &RM2_, mccM(&RM2_) * mccN(&RM2_));
         mxSetN( &RM2_, 1);
         I1_ = mccGetLength(&RM2_);
         {
            int i_, j_;
            int m_=1, n_=1, cx_ = 0;
            unsigned short *p_BM3_;
            int I_BM3_=1;
            double *p_M;
            int I_M=1;
            m_ = mcmCalcResultSize(m_, &n_, mccM(&M), mccN(&M));
            mccAllocateMatrix(&BM3_, m_, n_);
            I_BM3_ = (mccM(&BM3_) != 1 || mccN(&BM3_) != 1);
            p_BM3_ = mccSPR(&BM3_);
            I_M = (mccM(&M) != 1 || mccN(&M) != 1);
            p_M = mccPR(&M);
            if (m_ != 0)
            {
               for (j_=0; j_<n_; ++j_)
               {
                  for (i_=0; i_<m_; ++i_, p_BM3_+=I_BM3_, p_M+=I_M)
                  {
                     *p_BM3_ = ( (I1_ == *p_M) && !mccREL_NAN(*p_M) );
                  }
               }
            }
         }
         B0_ = mccIfCondition(&BM3_);
         if ((double)B0_)
         {
            mccSize(&IM1_, &cold);
            mccCatenateColumns(&RM1_, &M, &M);
            {
               int i_, j_;
               int m_=1, n_=1, cx_ = 0;
               unsigned short *p_BM2_;
               int I_BM2_=1;
               int *p_IM1_;
               int I_IM1_=1;
               double *p_RM1_;
               int I_RM1_=1;
               m_ = mcmCalcResultSize(m_, &n_, mccM(&IM1_), mccN(&IM1_));
               m_ = mcmCalcResultSize(m_, &n_, mccM(&RM1_), mccN(&RM1_));
               mccAllocateMatrix(&BM2_, m_, n_);
               I_BM2_ = (mccM(&BM2_) != 1 || mccN(&BM2_) != 1);
               p_BM2_ = mccSPR(&BM2_);
               I_IM1_ = (mccM(&IM1_) != 1 || mccN(&IM1_) != 1);
               p_IM1_ = mccIPR(&IM1_);
               I_RM1_ = (mccM(&RM1_) != 1 || mccN(&RM1_) != 1);
               p_RM1_ = mccPR(&RM1_);
               if (m_ != 0)
               {
                  for (j_=0; j_<n_; ++j_)
                  {
                     for (i_=0; i_<m_; ++i_, p_BM2_+=I_BM2_, p_IM1_+=I_IM1_, p_RM1_+=I_RM1_)
                     {
                        *p_BM2_ = ( (((int)*p_IM1_) == *p_RM1_) && !mccREL_NAN(*p_RM1_) );
                     }
                  }
               }
            }
            mccAll(&BM1_, &BM2_);
            B0_ = mccIfCondition(&BM1_);
         }
         if ((double)B0_)
         {
            /* mnew = mold(:)'; */
            mccCopy(&RM1_, &mold);
            mxSetM( &RM1_, mccM(&RM1_) * mccN(&RM1_));
            mxSetN( &RM1_, 1);
            mccConjTrans(&mnew, &RM1_);
            /* cnew = cold(:)'; */
            mccCopy(&RM1_, &cold);
            mxSetM( &RM1_, mccM(&RM1_) * mccN(&RM1_));
            mxSetN( &RM1_, 1);
            mccConjTrans(&cnew, &RM1_);
         }
         else
         {
            /* else */
            /* mnew = []; */
            mccCreateEmpty(&mnew);
            /* cnew = []; */
            mccCreateEmpty(&cnew);
            /* fprintf( 'class_multi: incorrect statistics specifications\n' ); */
            Mprhs_[0] = &S3_;
            Mplhs_[0] = 0;
            mccCallMATLAB(0, Mplhs_, 1, Mprhs_, "fprintf", 34);
            /* end; */
         }
      }
      MretR: ;
      mccReturnFirstValue(&plhs_[0], &mnew);
      mccReturnValue(&plhs_[1], &cnew);
   }
   return;
}
