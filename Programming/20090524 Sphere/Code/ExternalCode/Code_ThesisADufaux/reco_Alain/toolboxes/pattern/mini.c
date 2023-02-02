static char mc_version[] = "MATLAB Compiler 1.2 Jan 17 1998 infun";
/*
 *  MATLAB Compiler: 1.2
 *  Date: Jan 17 1998
 *  Arguments: mini 
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
 *       dummy       	complex vector/matrix
 *       index       	integer vector/matrix
 *       min         	<function>
 *       mini        	<function being defined>
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
   mxArray *Mprhs_[1];
   

   if (nrhs_ > 1 )
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
      mxArray index;
      mxArray x;
      mxArray dummy;
      
      mccComplexInit(x);
      mccImport(&x, ((nrhs_>0) ? prhs_[0] : 0), 0, 0);
      mccIntInit(index);
      mccComplexInit(dummy);
      
      /* % MINI		Index of smallest component */
      /* %  */
      /* % Usage:		INDEX = MINI(X) */
      /* % This function returns the index of the minimum element of X, */
      /* % as defined by the built-in MIN command. */
      /* %  */
      /* % See also MIN */
      /*  */
      /* % Copyright (c) 1993-1995 by Ahlea Systems Corp.  All rights reserved. */
      /*  */
      /* [dummy index] = min(x); */
      if(mccNOTSET(&x))
      {
         mexErrMsgTxt( "variable x undefined, line 12" );
      }
      Mprhs_[0] = &x;
      Mplhs_[0] = &dummy;
      Mplhs_[1] = &index;
      mccCallMATLAB(2, Mplhs_, 1, Mprhs_, "min", 12);
      mccReturnFirstValue(&plhs_[0], &index);
   }
   else
   {
/***************** Compiler Assumptions ****************
 *
 *       dummy       	real vector/matrix
 *       index       	integer vector/matrix
 *       min         	<function>
 *       mini        	<function being defined>
 *       x           	real vector/matrix
 *******************************************************/
      mxArray index;
      mxArray x;
      mxArray dummy;
      
      mccRealInit(x);
      mccImport(&x, ((nrhs_>0) ? prhs_[0] : 0), 0, 0);
      mccIntInit(index);
      mccRealInit(dummy);
      
      /* % MINI		Index of smallest component */
      /* %  */
      /* % Usage:		INDEX = MINI(X) */
      /* % This function returns the index of the minimum element of X, */
      /* % as defined by the built-in MIN command. */
      /* %  */
      /* % See also MIN */
      /*  */
      /* % Copyright (c) 1993-1995 by Ahlea Systems Corp.  All rights reserved. */
      /*  */
      /* [dummy index] = min(x); */
      if(mccNOTSET(&x))
      {
         mexErrMsgTxt( "variable x undefined, line 12" );
      }
      Mprhs_[0] = &x;
      Mplhs_[0] = &dummy;
      Mplhs_[1] = &index;
      mccCallMATLAB(2, Mplhs_, 1, Mprhs_, "min", 12);
      mccReturnFirstValue(&plhs_[0], &index);
   }
   return;
}
