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
//  This is a MATLAB mex file which loads a signal with SPHERE header 
//  into a MATLAB array. The signal can be PCM or ULAW encoded.
//  If the signal is compressed by SHORTEN, it will be decompressed.   
//  The byte order of the signal can be properly swapped depending on
//  the current machine's byte order.
//
//  The main purpose is to demonstrate how to access SV_Lib from MATLAB.
//  
//  Author  :  Jialong He
//  Date    :  June 21, 1999
//==========================================================================
#include <stdlib.h>
#include <stdio.h>
#include <math.h>
#include <string.h>
#include "SV_Lib.h"

//==============================================================
// Interface to MATLAB must be in C, other parts can be in C++
//==============================================================
extern "C" {
#include "mex.h"

void mexFunction(int OutNum, mxArray *OutPnt[], int InNum, const mxArray *InPnt[]) {

	char *FName;
	FILE *fid;

	char Hdr[1024];
	double *pr;
	int Len, Cnt;
	short *S_Sig;

	if (InNum != 1 || OutNum != 1) {
		mexErrMsgTxt("Usages : [Sig] = LoadNIST('FName')\n"); 
	}

	//-------------------------------------------
	// Get file name
	//-------------------------------------------
    FName  = mxArrayToString(InPnt[0]);
	
	//-------------------------------------------
	// Test if file exist and can be opened
	//-------------------------------------------
	fid = fopen(FName, "rt");
	if (fid == NULL) {
		mexErrMsgTxt("Can not open file!\n"); 
	}
	fgets(Hdr, 1024, fid);
	if (strncmp(Hdr, "NIST_1A", 7) != 0) {
		mexErrMsgTxt("File has no SPHERE header!\n"); 
	}
	fclose(fid);

	//-------------------------------------------
	// Create NIST object, load signal 
	//-------------------------------------------
	SV_Signal_NIST NIST;
	NIST.LoadSignal(FName);
	Len    = NIST.GetLen();
	S_Sig  = NIST.GetBuf_L();

	//------------------------------------------------
	// Copy signal into the output structure
	//------------------------------------------------
    OutPnt[0] = mxCreateDoubleMatrix(1, Len, mxREAL);
    pr        = mxGetPr(OutPnt[0]); 
    
    for (Cnt=0; Cnt<Len; Cnt++) {
      pr[Cnt] = S_Sig[Cnt];           
	}

	return;   
}

}    // extern "C" {
