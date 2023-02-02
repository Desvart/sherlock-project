//########################################################################
//  
// A C++ class library for automatic speech recognition and 
// speaker recognition (identification and verification). 
//
// This class library is provided "as is" without any express 
// or implied warranty of any kind with respect to this software. 
// In particular the author shall not be liable for any direct, 
// indirect, special, incidental or consequential damages arising 
// in any way from use of the software.
//
//
// Author   : Jialong He,  Copyright (C), all rights reserved. 
// Date     : May, 1999. 
//
// Contact  : Jialong_He@bigfoot.com, Jialong_He@homemail.com
// Web Page : www.bigfoot.com/~Jialong_He
//########################################################################

//==========================================================================
//  This is a MATLAB mex file which generates Gaussian Mixture Model (GMM)
//  by the EM algorithm. Training parameters are given as a structure.
//
//  The main purpose is to demonstrate how to access SV_Lib from MATLAB.
//  
//  Author  :  Jialong He
//  Date    :  June 21, 1999
//==========================================================================
#include <stdlib.h>
#include <math.h>
#include "SV_Lib.h"

//==============================================================
// Interface to MATLAB must be in C, other parts can be in C++
//==============================================================
extern "C" {
#include "mex.h"

void mexFunction(int OutNum, mxArray *OutPnt[], int InNum, const mxArray *InPnt[]) {

	int PatNum, PatCnt;
	SV_Data *Data;

	double *pr, *pr1, **Mat, **Var, *Vec;
	const char *OName[] = {"MeanMat", "VariMat", "WgtVec"};
	int Cnt, M, N, Row, Col;
	int VecNum, Dim, Index;
	mxArray *pField, *pField1;

	//--------------------------------------
	// Check input
	//--------------------------------------
	if (InNum != 2 || OutNum != 1) {
		mexErrMsgTxt("Usages : Model = Gen_GMM(Data, M_Par)\n"); 
	}

	if (!mxIsClass(InPnt[0], "struct") || !mxIsClass(InPnt[1], "struct")) {
		mexErrMsgTxt("Both inputs must be a structure!\n"); 
	};

	PatNum = mxGetM(InPnt[0]) * mxGetN(InPnt[0]);  // total training patterns
	//-------------------------------------------
	// Check all patterns to make sure that they 
	// have same dimension.
	//-------------------------------------------
	pField	= mxGetField(InPnt[0], 0, "Mat");
    Dim		= mxGetN(pField);
	VecNum	= 0;
	for (PatCnt=0; PatCnt<PatNum; PatCnt++) {
		pField	= mxGetField(InPnt[0], PatCnt, "Mat");
		M		= mxGetM(pField);  
	    N		= mxGetN(pField);
		VecNum  += M;
		if (N != Dim) {
			mexErrMsgTxt("Inconsistent dimension in training patterns!\n"); 
		}
	}

	//----------------------------------------------
	// Convert training data: InPnt[0]
	// from MATLAB structure to SV_Data linked list.
	//----------------------------------------------
	Data = new SV_Data(VecNum, Dim);
	Data->Next = NULL;
	Index = 0;
	for (PatCnt=0; PatCnt<PatNum; PatCnt++) {
		pField	= mxGetField(InPnt[0], PatCnt, "Mat");
		M		= mxGetM(pField);  
	    N		= mxGetN(pField);
		pr		= mxGetPr(pField);

		for (Row=0; Row<M; Row++) {
			for (Col=0; Col<N; Col++) {
				Data->Mat[Index][Col] = float(pr[Row + Col*M]);		
			}
			Index++;
		}	
	}

	//----------------------------------------------
	// Create GMM object and set training parameters 
	//----------------------------------------------
	SV_Model_GMM GMM;
	GMM.Verbose    = 0;
	GMM.WithOrth   = 0;   // no orthogonal transform

	pField = mxGetField(InPnt[1], 0, "Size");  // Mixture Number
	if (pField) {
		GMM.Mixtures = int (mxGetScalar(pField));
	} else {GMM.Mixtures = 8;}

	pField = mxGetField(InPnt[1], 0, "MaxIter");  // Maximum Iteration
	if (pField) {
		GMM.MaxIter = int (mxGetScalar(pField));
	} else {GMM.MaxIter = 20;}

	pField = mxGetField(InPnt[1], 0, "RandSeed");  // Random Seed
	if (pField) {
		GMM.RandSeed = int (mxGetScalar(pField));
	} else {GMM.RandSeed = 1999;}

	mexPrintf("Generating Gaussian Mixture Model, please wait...\n"); 
	GMM.TrainModel(Data); // generate model

	//---------------------------------------------------
	// Create output structure
	//---------------------------------------------------
	OutPnt[0] = mxCreateStructMatrix(1, 1, 3, OName);

	M   = GMM.GetMixNum();
	N   = GMM.GetVecDim();

	pField  = mxCreateDoubleMatrix(M, N, mxREAL);
	pr      = mxGetPr(pField);
	
	pField1 = mxCreateDoubleMatrix(M, N, mxREAL);
	pr1     = mxGetPr(pField1);

	//------------------------------------------
	// Copy Mean and Vari to output structure
	//------------------------------------------
	Mat = GMM.GetMeanMat();
	Var = GMM.GetVariMat();
	for (Col=0; Col<N; Col++) {
		for (Row=0; Row<M; Row++) {
			pr[Row + Col*M]  = Mat[Row][Col];		
			pr1[Row + Col*M] = Var[Row][Col];		
		}
	}	
	mxSetField(OutPnt[0], 0, "MeanMat", pField);
	mxSetField(OutPnt[0], 0, "VariMat", pField1);

	//------------------------------------------
	// Copy Mixture Weight to output structure
	//------------------------------------------
	Vec = GMM.GetWgtVec();
	pField = mxCreateDoubleMatrix(M, 1, mxREAL);
	pr     = mxGetPr(pField);
	for (Row=0; Row<M; Row++) {
		pr[Row] = Vec[Row];		
	}	
	mxSetField(OutPnt[0], 0, "WgtVec", pField);

	delete Data;
	return;   
}

}    // extern "C" {
