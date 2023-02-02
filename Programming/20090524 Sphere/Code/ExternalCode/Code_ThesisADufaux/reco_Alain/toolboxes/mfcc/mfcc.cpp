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
//  This is a MATLAB mex file which calculates the MFCC vector sequence
//  for a given signal. The analysis parameters are given as a structure.
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


	SV_Data *pData, *pDData, *pTotalData;

	double *pr;
	short *S_Sig;
	mxArray *pField;
	const char *OName[] = {"Mat"};
	int Len, M, N, Row, Col, Delta;
	

	if (InNum != 2 || OutNum != 1) {
		mexErrMsgTxt("Usages : F = MFCC(Sig, Par)\n"); 
	}

	if (!mxIsClass(InPnt[0], "double") || !mxIsClass(InPnt[1], "struct")) {
		mexErrMsgTxt("1st Arg should be array, 2nd be structure!\n"); 
	};

	//-----------------------------------------------
	// Copy signal from "double" to "short int"
	//-----------------------------------------------
    M     = mxGetM(InPnt[0]);  
    N     = mxGetN(InPnt[0]);
	Len   = int(M*N);
    pr    = mxGetPr(InPnt[0]);

	MArray_1D(S_Sig, Len, short, "MFCC");
	for (Row=0; Row<Len; Row++) {
		S_Sig[Row] = short(pr[Row]);
	}

	//--------------------------------------------------
	// Create MFCC object and set analysis parameters
	//--------------------------------------------------
	SV_Feature_MFCC MFCC;

	MFCC.Para.NFilter    = 60;	    // number of filters
	MFCC.Para.FFTSz      = 1024;    // FFT size
	MFCC.Para.DEnergy    = 1;	    // use delta energy as c[0]  
	MFCC.Para.Alpha      = 0.97;	// factor for preemphasis	
	MFCC.Para.HammingWin = 1;       // applying Hamming window

	pField = mxGetField(InPnt[1], 0, "Order");    // MFCC Order
	if (pField) {
		MFCC.Para.MFCC_Order = int (mxGetScalar(pField));
	} else {MFCC.Para.MFCC_Order = 12;}

	pField = mxGetField(InPnt[1], 0, "WinSz");  // analysis window size
	if (pField) {
		MFCC.Para.WinSz = int (mxGetScalar(pField));
	} else {MFCC.Para.WinSz = 256;}

	pField = mxGetField(InPnt[1], 0, "StpSz");  // moving step size
	if (pField) {
		MFCC.Para.StpSz = int (mxGetScalar(pField));
	} else {MFCC.Para.StpSz = 128;}

	pField = mxGetField(InPnt[1], 0, "SRate");  // sampling rate
	if (pField) {
		MFCC.Para.SRate = int (mxGetScalar(pField));
	} else {MFCC.Para.SRate = 8000;}

	pField = mxGetField(InPnt[1], 0, "RmvSilence");  // remove silence 
	if (pField) {
		MFCC.Para.RmvSilence = int (mxGetScalar(pField));
	} else {MFCC.Para.RmvSilence = 0;}

	pField = mxGetField(InPnt[1], 0, "Delta");  // 1: with D-MFCC, 0 : NO
	if (pField) {
		Delta = int (mxGetScalar(pField));
	} else {Delta = 0;}

	//-----------------------------------------------
	// Copy signal into the MFCC object, and extract 
	//-----------------------------------------------
	//mexPrintf("Calculating MFCC, please wait...\n"); 
	MFCC.CopySignal(S_Sig, Len);
	pData = MFCC.ExtractFeature();
	pTotalData = pData;
  
	if (pTotalData == NULL) {
		mexErrMsgTxt("Extract feature failed!\n"); 
	};

	//---------------------------------
	// if need dynamic (delta) MFCC
	//---------------------------------
	if (Delta) {
		pDData = MFCC.Dynamic(*pData);
		pTotalData = MFCC.Concat(*pData, *pDData);
		delete pData;
		delete pDData;
	}

	//-----------------------------------------
	// Create output structure with Mat field
	//-----------------------------------------
	M = pTotalData->Row;
	N = pTotalData->Col;
	OutPnt[0] = mxCreateStructMatrix(1, 1, 1, OName);
	pField = mxCreateDoubleMatrix(M, N, mxREAL);
	pr     = mxGetPr(pField);

	//------------------------------------------
	// copy MFCC to output structure
	//------------------------------------------
	for (Col=0; Col<N; Col++) {
		for (Row=0; Row<M; Row++) {
			//--------------------------------------
			// fill pr in column first mode, that is
			// 1st col, 2nd col, 3rd col, etc.
			//--------------------------------------
			pr[Row + Col*M] = pTotalData->Mat[Row][Col];		
		}
	}	
	mxSetField(OutPnt[0], 0, "Mat", pField);
	
	MFree_1D(S_Sig);
	delete pTotalData;
	return;   
}

}    // extern "C" {
