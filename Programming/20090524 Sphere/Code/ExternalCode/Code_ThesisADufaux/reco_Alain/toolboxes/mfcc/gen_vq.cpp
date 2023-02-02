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
//  This is a MATLAB mex file which generates vector quantization (VQ)
//  codebook by the k-mean algorithm. 
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

	double *pr;
	float **Mat;	
	const char *OName[] = {"Mat"};
	int M, N, Row, Col;
	int VecNum, Dim, Index, PatNum, PatCnt;
	SV_Data *Data;
	mxArray *pField;

	//--------------------------------------
	// Check input
	//--------------------------------------
	if (InNum != 2 || OutNum != 1) {
		mexErrMsgTxt("Usages : CBook = Gen_VQ(Data, Par)\n"); 
	}

	if (!mxIsClass(InPnt[0], "struct") || !mxIsClass(InPnt[1], "struct")) {
		mexErrMsgTxt("Both input should be structure!\n"); 
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

	//-----------------------------------------------------
	// Convert training data: InPnt[0]
	// from MATLAB structure to SV_Data linked list.
	// Copy training data from structure to Data object
	//----- -----------------------------------------------
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
	// Creat VQ object and set training parameters  
	//----------------------------------------------
	SV_Model_VQ VQ;

	VQ.Verbose    = 0;

	pField = mxGetField(InPnt[1], 0, "Size");  // CodeBook Size
	if (pField) {
		VQ.CBSize = int (mxGetScalar(pField));
	} else {VQ.CBSize = 8;}

	pField = mxGetField(InPnt[1], 0, "MaxIter");  // Maximum Iteration
	if (pField) {
		VQ.MaxIter = int (mxGetScalar(pField));
	} else {VQ.MaxIter = 20;}

	pField = mxGetField(InPnt[1], 0, "RandSeed");  // Random Seed
	if (pField) {
		VQ.RandSeed = int (mxGetScalar(pField));
	} else {VQ.RandSeed = 1999;}

	//----------------------------------------------
	// Start training the VQ codebook 
	//----------------------------------------------
	mexPrintf("Generating VQ codebook, please wait...\n"); 
	VQ.TrainModel(Data); 

	//---------------------------------------------------
	// create output structure
	//---------------------------------------------------
	OutPnt[0] = mxCreateStructMatrix(1, 1, 1, OName);
	M      = VQ.GetCNum();
	N	   = VQ.GetCDim();
	pField = mxCreateDoubleMatrix(M, N, mxREAL);
	pr     = mxGetPr(pField);

	//------------------------------------
	// Copy codebook to output structure
	//------------------------------------
	Mat = VQ.GetCBook();
	for (Row=0; Row<M; Row++) {
		for (Col=0; Col<N; Col++) {
			pr[Row + Col*M] = Mat[Row][Col];		
		}
	}	
	mxSetField(OutPnt[0], 0, "Mat", pField);

	delete Data;
	return;   
}

}    // extern "C" {
