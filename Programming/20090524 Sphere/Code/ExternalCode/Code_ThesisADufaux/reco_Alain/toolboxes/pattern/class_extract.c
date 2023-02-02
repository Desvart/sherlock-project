static char mc_version[] = "MATLAB Compiler 1.2 Jan 17 1998 infun";
/*
 *  MATLAB Compiler: 1.2
 *  Date: Jan 17 1998
 *  Arguments: class_extract 
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

/* static array S0_ (1 x 13) text, line 14: 'class_extract' */
static unsigned short S0__r_[] =
{
         99,  108,   97,  115,  115,   95,  101,  120,
        116,  114,   97,   99,  116,
};
static mxArray S0_ = mccCINIT( mccTEXT,  1, 13, S0__r_, 0);
/* static array S1_ (1 x 46) text, line 20: 'class_extract: index out-...' */
static unsigned short S1__r_[] =
{
         99,  108,   97,  115,  115,   95,  101,  120,
        116,  114,   97,   99,  116,   58,   32,  105,
        110,  100,  101,  120,   32,  111,  117,  116,
         45,  111,  102,   45,  114,   97,  110,  103,
        101,   32,   40,   37,  100,   32,  111,  102,
         32,   37,  100,   41,   92,  110,
};
static mxArray S1_ = mccCINIT( mccTEXT,  1, 46, S1__r_, 0);
/* static array S2_ (1 x 13) text, line 14: 'class_extract' */
static unsigned short S2__r_[] =
{
         99,  108,   97,  115,  115,   95,  101,  120,
        116,  114,   97,   99,  116,
};
static mxArray S2_ = mccCINIT( mccTEXT,  1, 13, S2__r_, 0);
/* static array S3_ (1 x 46) text, line 20: 'class_extract: index out-...' */
static unsigned short S3__r_[] =
{
         99,  108,   97,  115,  115,   95,  101,  120,
        116,  114,   97,   99,  116,   58,   32,  105,
        110,  100,  101,  120,   32,  111,  117,  116,
         45,  111,  102,   45,  114,   97,  110,  103,
        101,   32,   40,   37,  100,   32,  111,  102,
         32,   37,  100,   41,   92,  110,
};
static mxArray S3_ = mccCINIT( mccTEXT,  1, 46, S3__r_, 0);
/***************** Compiler Assumptions ****************
 *
 *       B0_         	boolean scalar temporary
 *       BM0_        	boolean vector/matrix temporary
 *       BM1_        	boolean vector/matrix temporary
 *       CM0_        	complex vector/matrix temporary
 *       I0_         	integer scalar temporary
 *       I1_         	integer scalar temporary
 *       IM0_        	integer vector/matrix temporary
 *       K           	integer scalar
 *       M           	integer scalar
 *       class_extract	<function being defined>
 *       cnew        	complex vector/matrix
 *       cold        	complex vector/matrix
 *       fprintf     	<function>
 *       help        	<function>
 *       index       	real vector/matrix
 *       length      	<function>
 *       mnew        	complex vector/matrix
 *       mold        	complex vector/matrix
 *       nargin      	<function>
 *       nargout     	<function>
 *       reshape     	<function>
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
   mxArray *Mprhs_[3];
   

   if (nrhs_ > 3 )
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
      mxArray index;
      int K = 0;
      int M = 0;
      int I0_ = 0;
      int I1_ = 0;
      unsigned short B0_ = 0;
      mxArray BM0_;
      mxArray BM1_;
      mxArray IM0_;
      mxArray CM0_;
      
      mccComplexInit(mold);
      mccImport(&mold, ((nrhs_>0) ? prhs_[0] : 0), 0, 0);
      mccComplexInit(cold);
      mccImport(&cold, ((nrhs_>1) ? prhs_[1] : 0), 0, 0);
      mccRealInit(index);
      mccImport(&index, ((nrhs_>2) ? prhs_[2] : 0), 0, 0);
      mccComplexInit(mnew);
      mccComplexInit(cnew);
      mccBoolInit(BM0_);
      mccBoolInit(BM1_);
      mccIntInit(IM0_);
      mccComplexInit(CM0_);
      
      /* % CLASS_EXTRACT	Extract class statistics from multi-class lists of statistics */
      /* %  */
      /* % Usage:		[M_NEW,C_NEW] = CLASS_EXTRACT( M_OLD, C_OLD, INDEX ) */
      /* %  */
      /* % This function extracts a class defined by INDEX from an  */
      /* % existing list (M_OLD,C_OLD). */
      /* %  */
      /* % If INDEX is a array, multi-class lists are returned, otherwise */
      /* % single-class statistics are returned */
      /*  */
      /* % (c) Copyright 1993-1995 by Dave Caughey.  All rights reserved. */
      /* if nargin ~= 3 | nargout ~= 2, */
      I0_ = mccNargin();
      B0_ = (I0_ != 3);
      if (!(double)B0_)
      {
         I1_ = mccNargout();
         B0_ = (I1_ != 2);
      }
      if ((double)B0_)
      {
         /* help class_extract */
         Mprhs_[0] = &S0_;
         Mplhs_[0] = 0;
         mccCallMATLAB(0, Mplhs_, 1, Mprhs_, "help", 14);
         /* return */
         goto MretC;
         /* end */
      }
      /*  */
      /* [K,M] = size(mold); */
      if(mccNOTSET(&mold))
      {
         mexErrMsgTxt( "variable mold undefined, line 18" );
      }
      mccGetMatrixSize(&K,&M, &mold);
      /* if index < 1 | index > K */
      if(mccNOTSET(&index))
      {
         mexErrMsgTxt( "variable index undefined, line 19" );
      }
      {
         int i_, j_;
         int m_=1, n_=1, cx_ = 0;
         unsigned short *p_BM0_;
         int I_BM0_=1;
         double *p_index;
         int I_index=1;
         m_ = mcmCalcResultSize(m_, &n_, mccM(&index), mccN(&index));
         mccAllocateMatrix(&BM0_, m_, n_);
         I_BM0_ = (mccM(&BM0_) != 1 || mccN(&BM0_) != 1);
         p_BM0_ = mccSPR(&BM0_);
         I_index = (mccM(&index) != 1 || mccN(&index) != 1);
         p_index = mccPR(&index);
         if (m_ != 0)
         {
            for (j_=0; j_<n_; ++j_)
            {
               for (i_=0; i_<m_; ++i_, p_BM0_+=I_BM0_, p_index+=I_index)
               {
                  *p_BM0_ = ( (*p_index < 1) && !mccREL_NAN(*p_index) );
               }
            }
         }
      }
      B0_ = mccIfCondition(&BM0_);
      if (!(double)B0_)
      {
         if(mccNOTSET(&index))
         {
            mexErrMsgTxt( "variable index undefined, line 19" );
         }
         {
            int i_, j_;
            int m_=1, n_=1, cx_ = 0;
            unsigned short *p_BM1_;
            int I_BM1_=1;
            double *p_index;
            int I_index=1;
            m_ = mcmCalcResultSize(m_, &n_, mccM(&index), mccN(&index));
            mccAllocateMatrix(&BM1_, m_, n_);
            I_BM1_ = (mccM(&BM1_) != 1 || mccN(&BM1_) != 1);
            p_BM1_ = mccSPR(&BM1_);
            I_index = (mccM(&index) != 1 || mccN(&index) != 1);
            p_index = mccPR(&index);
            if (m_ != 0)
            {
               for (j_=0; j_<n_; ++j_)
               {
                  for (i_=0; i_<m_; ++i_, p_BM1_+=I_BM1_, p_index+=I_index)
                  {
                     *p_BM1_ = ( (*p_index > K) && !mccREL_NAN(*p_index) );
                  }
               }
            }
         }
         B0_ = mccIfCondition(&BM1_);
      }
      if ((double)B0_)
      {
         /* fprintf( 'class_extract: index out-of-range (%d of %d)\n', index, K ); */
         Mprhs_[0] = &S1_;
         Mprhs_[1] = &index;
         Mprhs_[2] = mccTempMatrix(K, 0., mccINT, 0 );
         Mplhs_[0] = 0;
         mccCallMATLAB(0, Mplhs_, 3, Mprhs_, "fprintf", 20);
         /* mnew = []; */
         mccCreateEmpty(&mnew);
         /* cnew = []; */
         mccCreateEmpty(&cnew);
      }
      else
      {
         /* elseif length( index ) == 1, */
         I1_ = mccGetLength(&index);
         B0_ = (I1_ == 1);
         if ((double)B0_)
         {
            /* mnew = mold(index,:)'; */
            mccFindIndex(&IM0_, &index);
            {
               int i_, j_;
               int m_=1, n_=1, cx_ = 0;
               double *p_CM0_;
               int I_CM0_=1;
               double *q_CM0_;
               double *p_mold;
               int I_mold=1, J_mold;
               double *q_mold;
               int *p_IM0_;
               int I_IM0_=1;
               m_ = mcmCalcResultSize(m_, &n_, (mccM(&IM0_) * mccN(&IM0_)), mccN(&mold));
               mccAllocateMatrix(&CM0_, m_, n_);
               mccCheckMatrixSize(&mold, mccGetMaxIndex(&IM0_ ,mccM(&mold)), mccN(&mold));
               I_CM0_ = (mccM(&CM0_) != 1 || mccN(&CM0_) != 1);
               p_CM0_ = mccPR(&CM0_);
               q_CM0_ = mccPI(&CM0_);
               J_mold = ((mccM(&mold) != 1 || mccN(&mold) != 1) ? mccM(&mold) : 0);
               p_mold = mccPR(&mold) + mccM(&mold) * 0;
               q_mold = mccPI(&mold) + mccM(&mold) * 0;
               I_IM0_ = (mccM(&IM0_) != 1 || mccN(&IM0_) != 1);
               if (m_ != 0)
               {
                  for (j_=0; j_<n_; ++j_, p_mold += J_mold, q_mold += J_mold)
                  {
                     p_IM0_ = mccIPR(&IM0_);
                     for (i_=0; i_<m_; ++i_, p_CM0_+=I_CM0_, q_CM0_+=I_CM0_, p_IM0_+=I_IM0_)
                     {
                        *p_CM0_ = p_mold[((int)(*p_IM0_ - .5))];
                        *q_CM0_ = q_mold[((int)(*p_IM0_ - .5))];
                     }
                  }
               }
            }
            mccLOG(&CM0_) = mccLOG(&mold);
            mccSTRING(&CM0_) = mccSTRING(&mold);
            mccConjTrans(&mnew, &CM0_);
            /* cnew = reshape(cold(index,:),M,M); */
            mccFindIndex(&IM0_, &index);
            {
               int i_, j_;
               int m_=1, n_=1, cx_ = 0;
               double *p_CM0_;
               int I_CM0_=1;
               double *q_CM0_;
               double *p_cold;
               int I_cold=1, J_cold;
               double *q_cold;
               int *p_IM0_;
               int I_IM0_=1;
               m_ = mcmCalcResultSize(m_, &n_, (mccM(&IM0_) * mccN(&IM0_)), mccN(&cold));
               mccAllocateMatrix(&CM0_, m_, n_);
               mccCheckMatrixSize(&cold, mccGetMaxIndex(&IM0_ ,mccM(&cold)), mccN(&cold));
               I_CM0_ = (mccM(&CM0_) != 1 || mccN(&CM0_) != 1);
               p_CM0_ = mccPR(&CM0_);
               q_CM0_ = mccPI(&CM0_);
               J_cold = ((mccM(&cold) != 1 || mccN(&cold) != 1) ? mccM(&cold) : 0);
               p_cold = mccPR(&cold) + mccM(&cold) * 0;
               q_cold = mccPI(&cold) + mccM(&cold) * 0;
               I_IM0_ = (mccM(&IM0_) != 1 || mccN(&IM0_) != 1);
               if (m_ != 0)
               {
                  for (j_=0; j_<n_; ++j_, p_cold += J_cold, q_cold += J_cold)
                  {
                     p_IM0_ = mccIPR(&IM0_);
                     for (i_=0; i_<m_; ++i_, p_CM0_+=I_CM0_, q_CM0_+=I_CM0_, p_IM0_+=I_IM0_)
                     {
                        *p_CM0_ = p_cold[((int)(*p_IM0_ - .5))];
                        *q_CM0_ = q_cold[((int)(*p_IM0_ - .5))];
                     }
                  }
               }
            }
            mccSTRING(&CM0_) = mccSTRING(&cold);
            mccReshape(&cnew, &CM0_, M, M);
         }
         else
         {
            /* else */
            /* mnew = mold(index,:); */
            mccFindIndex(&IM0_, &index);
            {
               int i_, j_;
               int m_=1, n_=1, cx_ = 0;
               double *p_mnew;
               int I_mnew=1;
               double *q_mnew;
               double *p_mold;
               int I_mold=1, J_mold;
               double *q_mold;
               int *p_IM0_;
               int I_IM0_=1;
               m_ = mcmCalcResultSize(m_, &n_, (mccM(&IM0_) * mccN(&IM0_)), mccN(&mold));
               mccAllocateMatrix(&mnew, m_, n_);
               mccCheckMatrixSize(&mold, mccGetMaxIndex(&IM0_ ,mccM(&mold)), mccN(&mold));
               I_mnew = (mccM(&mnew) != 1 || mccN(&mnew) != 1);
               p_mnew = mccPR(&mnew);
               q_mnew = mccPI(&mnew);
               J_mold = ((mccM(&mold) != 1 || mccN(&mold) != 1) ? mccM(&mold) : 0);
               p_mold = mccPR(&mold) + mccM(&mold) * 0;
               q_mold = mccPI(&mold) + mccM(&mold) * 0;
               I_IM0_ = (mccM(&IM0_) != 1 || mccN(&IM0_) != 1);
               if (m_ != 0)
               {
                  for (j_=0; j_<n_; ++j_, p_mold += J_mold, q_mold += J_mold)
                  {
                     p_IM0_ = mccIPR(&IM0_);
                     for (i_=0; i_<m_; ++i_, p_mnew+=I_mnew, q_mnew+=I_mnew, p_IM0_+=I_IM0_)
                     {
                        *p_mnew = p_mold[((int)(*p_IM0_ - .5))];
                        *q_mnew = q_mold[((int)(*p_IM0_ - .5))];
                     }
                  }
               }
            }
            mccLOG(&mnew) = mccLOG(&mold);
            mccSTRING(&mnew) = mccSTRING(&mold);
            /* cnew = cold(index,:); */
            mccFindIndex(&IM0_, &index);
            {
               int i_, j_;
               int m_=1, n_=1, cx_ = 0;
               double *p_cnew;
               int I_cnew=1;
               double *q_cnew;
               double *p_cold;
               int I_cold=1, J_cold;
               double *q_cold;
               int *p_IM0_;
               int I_IM0_=1;
               m_ = mcmCalcResultSize(m_, &n_, (mccM(&IM0_) * mccN(&IM0_)), mccN(&cold));
               mccAllocateMatrix(&cnew, m_, n_);
               mccCheckMatrixSize(&cold, mccGetMaxIndex(&IM0_ ,mccM(&cold)), mccN(&cold));
               I_cnew = (mccM(&cnew) != 1 || mccN(&cnew) != 1);
               p_cnew = mccPR(&cnew);
               q_cnew = mccPI(&cnew);
               J_cold = ((mccM(&cold) != 1 || mccN(&cold) != 1) ? mccM(&cold) : 0);
               p_cold = mccPR(&cold) + mccM(&cold) * 0;
               q_cold = mccPI(&cold) + mccM(&cold) * 0;
               I_IM0_ = (mccM(&IM0_) != 1 || mccN(&IM0_) != 1);
               if (m_ != 0)
               {
                  for (j_=0; j_<n_; ++j_, p_cold += J_cold, q_cold += J_cold)
                  {
                     p_IM0_ = mccIPR(&IM0_);
                     for (i_=0; i_<m_; ++i_, p_cnew+=I_cnew, q_cnew+=I_cnew, p_IM0_+=I_IM0_)
                     {
                        *p_cnew = p_cold[((int)(*p_IM0_ - .5))];
                        *q_cnew = q_cold[((int)(*p_IM0_ - .5))];
                     }
                  }
               }
            }
            mccLOG(&cnew) = mccLOG(&cold);
            mccSTRING(&cnew) = mccSTRING(&cold);
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
 *       I0_         	integer scalar temporary
 *       I1_         	integer scalar temporary
 *       IM0_        	integer vector/matrix temporary
 *       K           	integer scalar
 *       M           	integer scalar
 *       RM0_        	real vector/matrix temporary
 *       class_extract	<function being defined>
 *       cnew        	real vector/matrix
 *       cold        	real vector/matrix
 *       fprintf     	<function>
 *       help        	<function>
 *       index       	real vector/matrix
 *       length      	<function>
 *       mnew        	real vector/matrix
 *       mold        	real vector/matrix
 *       nargin      	<function>
 *       nargout     	<function>
 *       reshape     	<function>
 *       size        	<function>
 *******************************************************/
      mxArray mnew;
      mxArray cnew;
      mxArray mold;
      mxArray cold;
      mxArray index;
      int K = 0;
      int M = 0;
      int I0_ = 0;
      int I1_ = 0;
      unsigned short B0_ = 0;
      mxArray BM0_;
      mxArray BM1_;
      mxArray IM0_;
      mxArray RM0_;
      
      mccRealInit(mold);
      mccImport(&mold, ((nrhs_>0) ? prhs_[0] : 0), 0, 0);
      mccRealInit(cold);
      mccImport(&cold, ((nrhs_>1) ? prhs_[1] : 0), 0, 0);
      mccRealInit(index);
      mccImport(&index, ((nrhs_>2) ? prhs_[2] : 0), 0, 0);
      mccRealInit(mnew);
      mccRealInit(cnew);
      mccBoolInit(BM0_);
      mccBoolInit(BM1_);
      mccIntInit(IM0_);
      mccRealInit(RM0_);
      
      /* % CLASS_EXTRACT	Extract class statistics from multi-class lists of statistics */
      /* %  */
      /* % Usage:		[M_NEW,C_NEW] = CLASS_EXTRACT( M_OLD, C_OLD, INDEX ) */
      /* %  */
      /* % This function extracts a class defined by INDEX from an  */
      /* % existing list (M_OLD,C_OLD). */
      /* %  */
      /* % If INDEX is a array, multi-class lists are returned, otherwise */
      /* % single-class statistics are returned */
      /*  */
      /* % (c) Copyright 1993-1995 by Dave Caughey.  All rights reserved. */
      /* if nargin ~= 3 | nargout ~= 2, */
      I0_ = mccNargin();
      B0_ = (I0_ != 3);
      if (!(double)B0_)
      {
         I1_ = mccNargout();
         B0_ = (I1_ != 2);
      }
      if ((double)B0_)
      {
         /* help class_extract */
         Mprhs_[0] = &S2_;
         Mplhs_[0] = 0;
         mccCallMATLAB(0, Mplhs_, 1, Mprhs_, "help", 14);
         /* return */
         goto MretR;
         /* end */
      }
      /*  */
      /* [K,M] = size(mold); */
      if(mccNOTSET(&mold))
      {
         mexErrMsgTxt( "variable mold undefined, line 18" );
      }
      mccGetMatrixSize(&K,&M, &mold);
      /* if index < 1 | index > K */
      if(mccNOTSET(&index))
      {
         mexErrMsgTxt( "variable index undefined, line 19" );
      }
      {
         int i_, j_;
         int m_=1, n_=1, cx_ = 0;
         unsigned short *p_BM0_;
         int I_BM0_=1;
         double *p_index;
         int I_index=1;
         m_ = mcmCalcResultSize(m_, &n_, mccM(&index), mccN(&index));
         mccAllocateMatrix(&BM0_, m_, n_);
         I_BM0_ = (mccM(&BM0_) != 1 || mccN(&BM0_) != 1);
         p_BM0_ = mccSPR(&BM0_);
         I_index = (mccM(&index) != 1 || mccN(&index) != 1);
         p_index = mccPR(&index);
         if (m_ != 0)
         {
            for (j_=0; j_<n_; ++j_)
            {
               for (i_=0; i_<m_; ++i_, p_BM0_+=I_BM0_, p_index+=I_index)
               {
                  *p_BM0_ = ( (*p_index < 1) && !mccREL_NAN(*p_index) );
               }
            }
         }
      }
      B0_ = mccIfCondition(&BM0_);
      if (!(double)B0_)
      {
         if(mccNOTSET(&index))
         {
            mexErrMsgTxt( "variable index undefined, line 19" );
         }
         {
            int i_, j_;
            int m_=1, n_=1, cx_ = 0;
            unsigned short *p_BM1_;
            int I_BM1_=1;
            double *p_index;
            int I_index=1;
            m_ = mcmCalcResultSize(m_, &n_, mccM(&index), mccN(&index));
            mccAllocateMatrix(&BM1_, m_, n_);
            I_BM1_ = (mccM(&BM1_) != 1 || mccN(&BM1_) != 1);
            p_BM1_ = mccSPR(&BM1_);
            I_index = (mccM(&index) != 1 || mccN(&index) != 1);
            p_index = mccPR(&index);
            if (m_ != 0)
            {
               for (j_=0; j_<n_; ++j_)
               {
                  for (i_=0; i_<m_; ++i_, p_BM1_+=I_BM1_, p_index+=I_index)
                  {
                     *p_BM1_ = ( (*p_index > K) && !mccREL_NAN(*p_index) );
                  }
               }
            }
         }
         B0_ = mccIfCondition(&BM1_);
      }
      if ((double)B0_)
      {
         /* fprintf( 'class_extract: index out-of-range (%d of %d)\n', index, K ); */
         Mprhs_[0] = &S3_;
         Mprhs_[1] = &index;
         Mprhs_[2] = mccTempMatrix(K, 0., mccINT, 0 );
         Mplhs_[0] = 0;
         mccCallMATLAB(0, Mplhs_, 3, Mprhs_, "fprintf", 20);
         /* mnew = []; */
         mccCreateEmpty(&mnew);
         /* cnew = []; */
         mccCreateEmpty(&cnew);
      }
      else
      {
         /* elseif length( index ) == 1, */
         I1_ = mccGetLength(&index);
         B0_ = (I1_ == 1);
         if ((double)B0_)
         {
            /* mnew = mold(index,:)'; */
            mccFindIndex(&IM0_, &index);
            {
               int i_, j_;
               int m_=1, n_=1, cx_ = 0;
               double *p_RM0_;
               int I_RM0_=1;
               double *p_mold;
               int I_mold=1, J_mold;
               int *p_IM0_;
               int I_IM0_=1;
               m_ = mcmCalcResultSize(m_, &n_, (mccM(&IM0_) * mccN(&IM0_)), mccN(&mold));
               mccAllocateMatrix(&RM0_, m_, n_);
               mccCheckMatrixSize(&mold, mccGetMaxIndex(&IM0_ ,mccM(&mold)), mccN(&mold));
               I_RM0_ = (mccM(&RM0_) != 1 || mccN(&RM0_) != 1);
               p_RM0_ = mccPR(&RM0_);
               J_mold = ((mccM(&mold) != 1 || mccN(&mold) != 1) ? mccM(&mold) : 0);
               p_mold = mccPR(&mold) + mccM(&mold) * 0;
               I_IM0_ = (mccM(&IM0_) != 1 || mccN(&IM0_) != 1);
               if (m_ != 0)
               {
                  for (j_=0; j_<n_; ++j_, p_mold += J_mold)
                  {
                     p_IM0_ = mccIPR(&IM0_);
                     for (i_=0; i_<m_; ++i_, p_RM0_+=I_RM0_, p_IM0_+=I_IM0_)
                     {
                        *p_RM0_ = p_mold[((int)(*p_IM0_ - .5))];
                     }
                  }
               }
            }
            mccLOG(&RM0_) = mccLOG(&mold);
            mccSTRING(&RM0_) = mccSTRING(&mold);
            mccConjTrans(&mnew, &RM0_);
            /* cnew = reshape(cold(index,:),M,M); */
            mccFindIndex(&IM0_, &index);
            {
               int i_, j_;
               int m_=1, n_=1, cx_ = 0;
               double *p_RM0_;
               int I_RM0_=1;
               double *p_cold;
               int I_cold=1, J_cold;
               int *p_IM0_;
               int I_IM0_=1;
               m_ = mcmCalcResultSize(m_, &n_, (mccM(&IM0_) * mccN(&IM0_)), mccN(&cold));
               mccAllocateMatrix(&RM0_, m_, n_);
               mccCheckMatrixSize(&cold, mccGetMaxIndex(&IM0_ ,mccM(&cold)), mccN(&cold));
               I_RM0_ = (mccM(&RM0_) != 1 || mccN(&RM0_) != 1);
               p_RM0_ = mccPR(&RM0_);
               J_cold = ((mccM(&cold) != 1 || mccN(&cold) != 1) ? mccM(&cold) : 0);
               p_cold = mccPR(&cold) + mccM(&cold) * 0;
               I_IM0_ = (mccM(&IM0_) != 1 || mccN(&IM0_) != 1);
               if (m_ != 0)
               {
                  for (j_=0; j_<n_; ++j_, p_cold += J_cold)
                  {
                     p_IM0_ = mccIPR(&IM0_);
                     for (i_=0; i_<m_; ++i_, p_RM0_+=I_RM0_, p_IM0_+=I_IM0_)
                     {
                        *p_RM0_ = p_cold[((int)(*p_IM0_ - .5))];
                     }
                  }
               }
            }
            mccSTRING(&RM0_) = mccSTRING(&cold);
            mccReshape(&cnew, &RM0_, M, M);
         }
         else
         {
            /* else */
            /* mnew = mold(index,:); */
            mccFindIndex(&IM0_, &index);
            {
               int i_, j_;
               int m_=1, n_=1, cx_ = 0;
               double *p_mnew;
               int I_mnew=1;
               double *p_mold;
               int I_mold=1, J_mold;
               int *p_IM0_;
               int I_IM0_=1;
               m_ = mcmCalcResultSize(m_, &n_, (mccM(&IM0_) * mccN(&IM0_)), mccN(&mold));
               mccAllocateMatrix(&mnew, m_, n_);
               mccCheckMatrixSize(&mold, mccGetMaxIndex(&IM0_ ,mccM(&mold)), mccN(&mold));
               I_mnew = (mccM(&mnew) != 1 || mccN(&mnew) != 1);
               p_mnew = mccPR(&mnew);
               J_mold = ((mccM(&mold) != 1 || mccN(&mold) != 1) ? mccM(&mold) : 0);
               p_mold = mccPR(&mold) + mccM(&mold) * 0;
               I_IM0_ = (mccM(&IM0_) != 1 || mccN(&IM0_) != 1);
               if (m_ != 0)
               {
                  for (j_=0; j_<n_; ++j_, p_mold += J_mold)
                  {
                     p_IM0_ = mccIPR(&IM0_);
                     for (i_=0; i_<m_; ++i_, p_mnew+=I_mnew, p_IM0_+=I_IM0_)
                     {
                        *p_mnew = p_mold[((int)(*p_IM0_ - .5))];
                     }
                  }
               }
            }
            mccLOG(&mnew) = mccLOG(&mold);
            mccSTRING(&mnew) = mccSTRING(&mold);
            /* cnew = cold(index,:); */
            mccFindIndex(&IM0_, &index);
            {
               int i_, j_;
               int m_=1, n_=1, cx_ = 0;
               double *p_cnew;
               int I_cnew=1;
               double *p_cold;
               int I_cold=1, J_cold;
               int *p_IM0_;
               int I_IM0_=1;
               m_ = mcmCalcResultSize(m_, &n_, (mccM(&IM0_) * mccN(&IM0_)), mccN(&cold));
               mccAllocateMatrix(&cnew, m_, n_);
               mccCheckMatrixSize(&cold, mccGetMaxIndex(&IM0_ ,mccM(&cold)), mccN(&cold));
               I_cnew = (mccM(&cnew) != 1 || mccN(&cnew) != 1);
               p_cnew = mccPR(&cnew);
               J_cold = ((mccM(&cold) != 1 || mccN(&cold) != 1) ? mccM(&cold) : 0);
               p_cold = mccPR(&cold) + mccM(&cold) * 0;
               I_IM0_ = (mccM(&IM0_) != 1 || mccN(&IM0_) != 1);
               if (m_ != 0)
               {
                  for (j_=0; j_<n_; ++j_, p_cold += J_cold)
                  {
                     p_IM0_ = mccIPR(&IM0_);
                     for (i_=0; i_<m_; ++i_, p_cnew+=I_cnew, p_IM0_+=I_IM0_)
                     {
                        *p_cnew = p_cold[((int)(*p_IM0_ - .5))];
                     }
                  }
               }
            }
            mccLOG(&cnew) = mccLOG(&cold);
            mccSTRING(&cnew) = mccSTRING(&cold);
            /* end; */
         }
      }
      MretR: ;
      mccReturnFirstValue(&plhs_[0], &mnew);
      mccReturnValue(&plhs_[1], &cnew);
   }
   return;
}
