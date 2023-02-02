/*
 * MATLAB Compiler: 2.0
 * Date: Fri Dec 10 17:53:28 1999
 * Arguments: "-x" "hmm_mint.m" 
 */

#ifndef MLF_V2
#define MLF_V2 1
#endif

#include "matlab.h"
#include "hmm_mint.h"

static mlfFunctionTableEntry function_table[1]
  = { { "hmm_mint", mlxHmm_mint, 5, 2 } };

/*
 * The function "mexFunction" is a Compiler-generated mex wrapper, suitable for
 * building a MEX-function. It initializes any persistent variables as well as
 * a function table for use by the feval function. It then calls the function
 * "mlxHmm_mint". Finally, it clears the feval table and exits.
 */
void mexFunction(int nlhs, mxArray * * plhs, int nrhs, mxArray * * prhs) {
    mlfTry {
        mlfFunctionTableSetup(1, function_table);
        mclImportGlobal(0, NULL);
        mlxHmm_mint(nlhs, plhs, nrhs, prhs);
        mlfFunctionTableTakedown(1, function_table);
    } mlfCatch {
        mlfFunctionTableTakedown(1, function_table);
        mclMexError();
    } mlfEndCatch
}
