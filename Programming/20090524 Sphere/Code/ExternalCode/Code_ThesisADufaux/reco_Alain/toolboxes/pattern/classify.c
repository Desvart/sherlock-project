static char mc_version[] = "MATLAB Compiler 1.2 Jan 17 1998 infun";
/*
 *  MATLAB Compiler: 1.2
 *  Date: Jan 17 1998
 *  Arguments: classify 
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

/* static array S0_ (1 x 8) text, line 17: 'classify' */
static unsigned short S0__r_[] =
{
         99,  108,   97,  115,  115,  105,  102,  121,
};
static mxArray S0_ = mccCINIT( mccTEXT,  1, 8, S0__r_, 0);
/* static array S1_ (1 x 8) text, line 17: 'classify' */
static unsigned short S1__r_[] =
{
         99,  108,   97,  115,  115,  105,  102,  121,
};
static mxArray S1_ = mccCINIT( mccTEXT,  1, 8, S1__r_, 0);
/***************** Compiler Assumptions ****************
 *
 *       B0_         	boolean scalar temporary
 *       CM0_        	complex vector/matrix temporary
 *       I0_         	integer scalar temporary
 *       IM0_        	integer vector/matrix temporary
 *       Inf         	<function>
 *       R0_         	real scalar temporary
 *       RM0_        	real vector/matrix temporary
 *       c           	complex vector/matrix
 *       classify    	<function being defined>
 *       dbayes      	<function>
 *       dg          	complex vector/matrix
 *       help        	<function>
 *       m           	complex vector/matrix
 *       member      	integer vector/matrix
 *       mini        	<function>
 *       nargin      	<function>
 *       ones        	<function>
 *       pwi         	complex vector/matrix
 *       size        	<function>
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
   mxArray *Mplhs_[1];
   mxArray *Mprhs_[4];
   

   if (nrhs_ > 4 )
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
      mxArray member;
      mxArray dg;
      mxArray x;
      mxArray m;
      mxArray c;
      mxArray pwi;
      int I0_ = 0;
      unsigned short B0_ = 0;
      double R0_ = 0.0;
      mxArray IM0_;
      mxArray RM0_;
      mxArray CM0_;
      
      mccComplexInit(x);
      mccImport(&x, ((nrhs_>0) ? prhs_[0] : 0), 0, 0);
      mccComplexInit(m);
      mccImport(&m, ((nrhs_>1) ? prhs_[1] : 0), 0, 0);
      mccComplexInit(c);
      mccImport(&c, ((nrhs_>2) ? prhs_[2] : 0), 0, 0);
      mccComplexInit(pwi);
      mccImport(&pwi, ((nrhs_>3) ? prhs_[3] : 0), 0, 0);
      mccIntInit(member);
      mccComplexInit(dg);
      mccIntInit(IM0_);
      mccRealInit(RM0_);
      mccComplexInit(CM0_);
      
      /* % CLASSIFY	Associate feature vectors with Gaussian-distributed classes */
      /* %  */
      /* % Usage: 	MEMBER = CLASSIFY( X, M, C [,PWI] ) */
      /* %  */
      /* % This function performs Gaussian classification on the data X */
      /* % described by their means M and covariance matrices C.  Results */
      /* % are returned as a vector of memberships. One can pass in an */
      /* % option array of the class probabilities. */
      /*  */
      /* % (c) Copyright 1993-1995 by Dave Caughey.  All rights reserved. */
      /* if nargin == 3 */
      I0_ = mccNargin();
      B0_ = (I0_ == 3);
      if ((double)B0_)
      {
         /* dg = dbayes( x, m, c ); */
         if(mccNOTSET(&x))
         {
            mexErrMsgTxt( "variable x undefined, line 13" );
         }
         if(mccNOTSET(&m))
         {
            mexErrMsgTxt( "variable m undefined, line 13" );
         }
         if(mccNOTSET(&c))
         {
            mexErrMsgTxt( "variable c undefined, line 13" );
         }
         Mprhs_[0] = &x;
         Mprhs_[1] = &m;
         Mprhs_[2] = &c;
         Mplhs_[0] = &dg;
         mccCallMATLAB(1, Mplhs_, 3, Mprhs_, "dbayes", 13);
      }
      else
      {
         /* elseif nargin == 4 */
         I0_ = mccNargin();
         B0_ = (I0_ == 4);
         if ((double)B0_)
         {
            /* dg = dbayes( x, m, c, pwi ); */
            if(mccNOTSET(&x))
            {
               mexErrMsgTxt( "variable x undefined, line 15" );
            }
            if(mccNOTSET(&m))
            {
               mexErrMsgTxt( "variable m undefined, line 15" );
            }
            if(mccNOTSET(&c))
            {
               mexErrMsgTxt( "variable c undefined, line 15" );
            }
            Mprhs_[0] = &x;
            Mprhs_[1] = &m;
            Mprhs_[2] = &c;
            Mprhs_[3] = &pwi;
            Mplhs_[0] = &dg;
            mccCallMATLAB(1, Mplhs_, 4, Mprhs_, "dbayes", 15);
         }
         else
         {
            /* else */
            /* help classify */
            Mprhs_[0] = &S0_;
            Mplhs_[0] = 0;
            mccCallMATLAB(0, Mplhs_, 1, Mprhs_, "help", 17);
            /* return */
            goto MretC;
            /* end; */
         }
      }
      /* member = mini([dg;Inf*ones(1,size(dg,2))]); */
      R0_ = mxGetInf();
      I0_ = mccGetDimensionSize(&dg, 2);
      mccOnesMN(&IM0_, 1, I0_);
      {
         int i_, j_;
         int m_=1, n_=1, cx_ = 0;
         double *p_RM0_;
         int I_RM0_=1;
         int *p_IM0_;
         int I_IM0_=1;
         m_ = mcmCalcResultSize(m_, &n_, mccM(&IM0_), mccN(&IM0_));
         mccAllocateMatrix(&RM0_, m_, n_);
         I_RM0_ = (mccM(&RM0_) != 1 || mccN(&RM0_) != 1);
         p_RM0_ = mccPR(&RM0_);
         I_IM0_ = (mccM(&IM0_) != 1 || mccN(&IM0_) != 1);
         p_IM0_ = mccIPR(&IM0_);
         if (m_ != 0)
         {
            for (j_=0; j_<n_; ++j_)
            {
               for (i_=0; i_<m_; ++i_, p_RM0_+=I_RM0_, p_IM0_+=I_IM0_)
               {
                  *p_RM0_ = (R0_ * (double) ((int)*p_IM0_));
               }
            }
         }
      }
      mccCatenateRows(&CM0_, &dg, &RM0_);
      Mprhs_[0] = &CM0_;
      Mplhs_[0] = &member;
      mccCallMATLAB(1, Mplhs_, 1, Mprhs_, "mini", 20);
      MretC: ;
      mccReturnFirstValue(&plhs_[0], &member);
      mccReturnValue(&plhs_[1], &dg);
   }
   else
   {
/***************** Compiler Assumptions ****************
 *
 *       B0_         	boolean scalar temporary
 *       CM0_        	complex vector/matrix temporary
 *       I0_         	integer scalar temporary
 *       IM0_        	integer vector/matrix temporary
 *       Inf         	<function>
 *       R0_         	real scalar temporary
 *       RM0_        	real vector/matrix temporary
 *       c           	real vector/matrix
 *       classify    	<function being defined>
 *       dbayes      	<function>
 *       dg          	complex vector/matrix
 *       help        	<function>
 *       m           	real vector/matrix
 *       member      	integer vector/matrix
 *       mini        	<function>
 *       nargin      	<function>
 *       ones        	<function>
 *       pwi         	real vector/matrix
 *       size        	<function>
 *       x           	real vector/matrix
 *******************************************************/
      mxArray member;
      mxArray dg;
      mxArray x;
      mxArray m;
      mxArray c;
      mxArray pwi;
      int I0_ = 0;
      unsigned short B0_ = 0;
      double R0_ = 0.0;
      mxArray IM0_;
      mxArray RM0_;
      mxArray CM0_;
      
      mccRealInit(x);
      mccImport(&x, ((nrhs_>0) ? prhs_[0] : 0), 0, 0);
      mccRealInit(m);
      mccImport(&m, ((nrhs_>1) ? prhs_[1] : 0), 0, 0);
      mccRealInit(c);
      mccImport(&c, ((nrhs_>2) ? prhs_[2] : 0), 0, 0);
      mccRealInit(pwi);
      mccImport(&pwi, ((nrhs_>3) ? prhs_[3] : 0), 0, 0);
      mccIntInit(member);
      mccComplexInit(dg);
      mccIntInit(IM0_);
      mccRealInit(RM0_);
      mccComplexInit(CM0_);
      
      /* % CLASSIFY	Associate feature vectors with Gaussian-distributed classes */
      /* %  */
      /* % Usage: 	MEMBER = CLASSIFY( X, M, C [,PWI] ) */
      /* %  */
      /* % This function performs Gaussian classification on the data X */
      /* % described by their means M and covariance matrices C.  Results */
      /* % are returned as a vector of memberships. One can pass in an */
      /* % option array of the class probabilities. */
      /*  */
      /* % (c) Copyright 1993-1995 by Dave Caughey.  All rights reserved. */
      /* if nargin == 3 */
      I0_ = mccNargin();
      B0_ = (I0_ == 3);
      if ((double)B0_)
      {
         /* dg = dbayes( x, m, c ); */
         if(mccNOTSET(&x))
         {
            mexErrMsgTxt( "variable x undefined, line 13" );
         }
         if(mccNOTSET(&m))
         {
            mexErrMsgTxt( "variable m undefined, line 13" );
         }
         if(mccNOTSET(&c))
         {
            mexErrMsgTxt( "variable c undefined, line 13" );
         }
         Mprhs_[0] = &x;
         Mprhs_[1] = &m;
         Mprhs_[2] = &c;
         Mplhs_[0] = &dg;
         mccCallMATLAB(1, Mplhs_, 3, Mprhs_, "dbayes", 13);
      }
      else
      {
         /* elseif nargin == 4 */
         I0_ = mccNargin();
         B0_ = (I0_ == 4);
         if ((double)B0_)
         {
            /* dg = dbayes( x, m, c, pwi ); */
            if(mccNOTSET(&x))
            {
               mexErrMsgTxt( "variable x undefined, line 15" );
            }
            if(mccNOTSET(&m))
            {
               mexErrMsgTxt( "variable m undefined, line 15" );
            }
            if(mccNOTSET(&c))
            {
               mexErrMsgTxt( "variable c undefined, line 15" );
            }
            Mprhs_[0] = &x;
            Mprhs_[1] = &m;
            Mprhs_[2] = &c;
            Mprhs_[3] = &pwi;
            Mplhs_[0] = &dg;
            mccCallMATLAB(1, Mplhs_, 4, Mprhs_, "dbayes", 15);
         }
         else
         {
            /* else */
            /* help classify */
            Mprhs_[0] = &S1_;
            Mplhs_[0] = 0;
            mccCallMATLAB(0, Mplhs_, 1, Mprhs_, "help", 17);
            /* return */
            goto MretR;
            /* end; */
         }
      }
      /* member = mini([dg;Inf*ones(1,size(dg,2))]); */
      R0_ = mxGetInf();
      I0_ = mccGetDimensionSize(&dg, 2);
      mccOnesMN(&IM0_, 1, I0_);
      {
         int i_, j_;
         int m_=1, n_=1, cx_ = 0;
         double *p_RM0_;
         int I_RM0_=1;
         int *p_IM0_;
         int I_IM0_=1;
         m_ = mcmCalcResultSize(m_, &n_, mccM(&IM0_), mccN(&IM0_));
         mccAllocateMatrix(&RM0_, m_, n_);
         I_RM0_ = (mccM(&RM0_) != 1 || mccN(&RM0_) != 1);
         p_RM0_ = mccPR(&RM0_);
         I_IM0_ = (mccM(&IM0_) != 1 || mccN(&IM0_) != 1);
         p_IM0_ = mccIPR(&IM0_);
         if (m_ != 0)
         {
            for (j_=0; j_<n_; ++j_)
            {
               for (i_=0; i_<m_; ++i_, p_RM0_+=I_RM0_, p_IM0_+=I_IM0_)
               {
                  *p_RM0_ = (R0_ * (double) ((int)*p_IM0_));
               }
            }
         }
      }
      mccCatenateRows(&CM0_, &dg, &RM0_);
      Mprhs_[0] = &CM0_;
      Mplhs_[0] = &member;
      mccCallMATLAB(1, Mplhs_, 1, Mprhs_, "mini", 20);
      MretR: ;
      mccReturnFirstValue(&plhs_[0], &member);
      mccReturnValue(&plhs_[1], &dg);
   }
   return;
}
