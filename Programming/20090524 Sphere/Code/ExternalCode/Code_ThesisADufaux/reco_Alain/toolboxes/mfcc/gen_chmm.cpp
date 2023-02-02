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
//  This is a MATLAB mex file which generates continous density 
//  (Gaussian mixture )hidden Markov model (CHMM).
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

	double *pr, *pr1, **Mat, *Vec;
	const char *OName[] = {"TranMat", "MeanMat", "VariMat", "WgtVec"};
	int Length, Cnt, M, N, Row, Col, Dim;
	mxArray *pField, *pField1;
	int PatNum, PatCnt;
	SV_Data *TrainData = NULL, *Data;
	

	//--------------------------------------
	// Check input
	//--------------------------------------
	if (InNum != 2|| OutNum != 1) {
		mexErrMsgTxt("Usages : Model = Gen_CHMM(Data, Par)\n"); 
	}

	if (!mxIsClass(InPnt[0], "struct") || !mxIsClass(InPnt[1], "struct")) {
		mexErrMsgTxt("Both input should be structure!\n"); 
	};


	//----------------------------------------------
	// Convert training data: InPnt[0]
	// from MATLAB structure to SV_Data linked list.
	//----------------------------------------------
	pField	= mxGetField(InPnt[0], 0, "Mat");
    Dim		= mxGetN(pField);

	PatNum = mxGetM(InPnt[0]) * mxGetN(InPnt[0]);  // total training patterns
	for (PatCnt=0; PatCnt<PatNum; PatCnt++) {
		pField	= mxGetField(InPnt[0], PatCnt, "Mat");
		M		= mxGetM(pField);  
	    N		= mxGetN(pField);
	    pr		= mxGetPr(pField);
		if (N != Dim) {
			mexErrMsgTxt("Inconsistent dimension in training patterns!\n"); 
		}

		//----------------------------------
		// Allocate new data pattern
		//----- -----------------------------
		Data    = new SV_Data(M, N);
		
		//----------------------------------
		// Copy this pattern to Data object
		//----------------------------------
		for (Col=0; Col<N; Col++) {
			for (Row=0; Row<M; Row++) {
				Data->Mat[Row][Col] = float(pr[Row + Col*M]);		
			}
		}	

		//-------------------------------------------------
		// Put Data object at the head of the linked list 
		//--------------------------------------------------
		Data->Next = TrainData;
		TrainData  = Data;
	}

	//----------------------------------------------
	// Create CHMM object, set traing parameters 
	//----------------------------------------------
	SV_Model_CHMM CHMM;
	CHMM.Verbose    = 0;
	CHMM.WithOrth   = 0;   // no orthogonal transform

	pField = mxGetField(InPnt[1], 0, "Size");  // Mixtures in each state
	if (pField) {
		CHMM.Mixtures = int (mxGetScalar(pField));
	} else {CHMM.Mixtures = 8;}

	pField = mxGetField(InPnt[1], 0, "MaxIter");  // Maximum Iteration
	if (pField) {
		CHMM.MaxIter = int (mxGetScalar(pField));
	} else {CHMM.MaxIter = 20;}

	pField = mxGetField(InPnt[1], 0, "RandSeed");  // Random Seed
	if (pField) {
		CHMM.RandSeed = int (mxGetScalar(pField));
	} else {CHMM.RandSeed = 1999;}

	pField = mxGetField(InPnt[1], 0, "NState");  // Number of State
	if (pField) {
		CHMM.NState = int (mxGetScalar(pField));
	} else {CHMM.NState = 3;}

	pField = mxGetField(InPnt[1], 0, "Conf");      // structure of HMM
	if (pField) {
	    pr	 = mxGetPr(pField);
	} 
	else {
		mexErrMsgTxt("HMM structure not defined!\n"); 
	}

	//---------------------------
	// Model Structure 
	//---------------------------
	MArray_2D(CHMM.ConfMat, CHMM.NState, CHMM.NState, int, "ConfMat");
	for (Col=0; Col<CHMM.NState; Col++) {
		for (Row=0; Row<CHMM.NState; Row++) {
			CHMM.ConfMat[Row][Col] = int (pr[Row + Col*CHMM.NState]);	
		}
	}	

	//---------------------------
	// Training CHMM model 
	//---------------------------
	mexPrintf("Training HMM, please wait...\n"); 
	CHMM.TrainModel(TrainData); // generate model
	MFree_2D(CHMM.ConfMat);

	//--------------------------------------
	// Create output structure
	//--------------------------------------
	OutPnt[0] = mxCreateStructMatrix(1, 1, 4, OName);
	
	//------------------------------------------
	// copy transition matrix to output struct
	//------------------------------------------
	M   = CHMM.GetStaNum();
	N   = M;
	Mat = CHMM.GetTran();

	pField = mxCreateDoubleMatrix(M, N, mxREAL);
	pr     = mxGetPr(pField);
	for (Col=0; Col<N; Col++) {
		for (Row=0; Row<M; Row++) {
			pr[Row + Col*M] = Mat[Row][Col];		
		}
	}	
	mxSetField(OutPnt[0], 0, "TranMat", pField);
	
	//------------------------------------------
	// Copy mixture Mean and Variance to output
	//------------------------------------------
	int StaNum, MixNum, DimNum, StaCnt, MixCnt, DimCnt, Index;
	MixType **EmitMat;

	StaNum = CHMM.GetStaNum();
	MixNum = CHMM.GetMixNum();
	DimNum = CHMM.GetVecDim();
	EmitMat= CHMM.GetEmit();

	pField = mxCreateDoubleMatrix(StaNum*MixNum, DimNum, mxREAL);
	pr     = mxGetPr(pField);

	pField1 = mxCreateDoubleMatrix(StaNum*MixNum, DimNum, mxREAL);
	pr1    = mxGetPr(pField1);
	
	Index  = 0;	
	for (DimCnt=0; DimCnt<DimNum; DimCnt++) {
		for (StaCnt=0; StaCnt<StaNum; StaCnt++) {
			for (MixCnt=0; MixCnt<MixNum; MixCnt++)  {
				pr[Index] = EmitMat[StaCnt][MixCnt].mean[DimCnt];
				pr1[Index] = EmitMat[StaCnt][MixCnt].vari[DimCnt];
				Index++;
			}
		}
	}
	mxSetField(OutPnt[0], 0, "MeanMat", pField);
	mxSetField(OutPnt[0], 0, "VariMat", pField1);

	//------------------------------------------
	// copy mixture weigth to output structure
	//------------------------------------------
	pField = mxCreateDoubleMatrix(StaNum*MixNum, 1, mxREAL);
	pr     = mxGetPr(pField);

	Index  = 0;	
	for (StaCnt=0; StaCnt<StaNum; StaCnt++) {
		for (MixCnt=0; MixCnt<MixNum; MixCnt++)  {
			pr[Index] = EmitMat[StaCnt][MixCnt].wgt;
			Index++;
		}
	}
	mxSetField(OutPnt[0], 0, "WgtVec", pField);
	
	//-----------------------------------
	// Release all training patterns
	//-----------------------------------
	for (PatCnt=0; PatCnt<PatNum; PatCnt++) {

		Data = TrainData->Next;
		delete TrainData;
		TrainData = Data;
	}

	return;   
}

}    // extern "C" {
