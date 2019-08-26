///==========================================================
/// (v4f)
///			R2014b fix-up (mexSet no longer useful)
///==========================================================

#include "mex.h"
#include "matrix.h"
#include "math.h"
#include "string.h"
#include "CUDA_2DGeneralD_v1a.h"
#include "CUDA_ConvGrid2SampSplitRD2D_v1c.h"
#include "CUDA_DeviceManage_v1a.h"

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, mxArray *prhs[])
{

//-------------------------------------
// Input                        
//-------------------------------------
double *CrtDat,*Kx,*Ky,*Kern;
int iKern,chW,chunklen,devicenum;
int *temp;

if (nrhs != 9) mexErrMsgTxt("Should have 9 inputs");
CrtDat = (double*)mxGetData(prhs[0]);  
Kx = (double*)mxGetData(prhs[1]);     
Ky = (double*)mxGetData(prhs[2]);        
Kern = (double*)mxGetData(prhs[3]);     
temp = (int*)mxGetData(prhs[4]); iKern = temp[0];
temp = (int*)mxGetData(prhs[5]); chW = temp[0];
temp = (int*)mxGetData(prhs[6]); chunklen = temp[0];
temp = (int*)mxGetData(prhs[7]); devicenum = temp[0];
//Status = prhs[8]

const mwSize *temp2;
int DatLen,KernSz,CrtDatSz;
temp2 = mxGetDimensions(prhs[0]);
CrtDatSz = (int)temp2[0];
temp2 = mxGetDimensions(prhs[1]);
DatLen = (int)temp2[0];
temp2 = mxGetDimensions(prhs[3]);
KernSz = (int)temp2[0];

//-------------------------------------
// Output                       
//-------------------------------------
double *SampDat;
mwSize *Tst;
char *Error;
mwSize errorlen = 200;
mwSize Dat_Dim[2];
mwSize Tst_Dim[2];

if (nlhs != 3) mexErrMsgTxt("Should have 3 outputs");
Dat_Dim[0] = DatLen; 
Dat_Dim[1] = 1; 
plhs[0] = mxCreateNumericArray(2,Dat_Dim,mxDOUBLE_CLASS,mxREAL);
SampDat = (double*)mxGetData(plhs[0]); 
Tst_Dim[0] = 1; 
Tst_Dim[1] = 20; 
plhs[1] = mxCreateNumericArray(2,Tst_Dim,mxINT64_CLASS,mxREAL);
Tst = (mwSize*)mxGetData(plhs[1]);
Error = (char*)mxCalloc(errorlen,sizeof(char));
strcpy(Error,"no error");

//-------------------------------------
// Display                  
//-------------------------------------	
char Status[150];
sprintf(Status,"Reset CUDA Device");
mxSetProperty(prhs[8],0,"String",mxCreateString(Status));;
mexEvalString("drawnow");

//-------------------------------------
// Select / Reset Device                  
//-------------------------------------
CUDAselect(devicenum,Error);
if (strcmp(Error,"no error") != 0) {
	plhs[2] = mxCreateString(Error); return;
	}
CUDAreset(Error);
if (strcmp(Error,"no error") != 0) {
	plhs[2] = mxCreateString(Error); return;
	}
	
//-------------------------------------
// Display                  
//-------------------------------------	
sprintf(Status,"CUDA Memory Allocate");
mxSetProperty(prhs[8],0,"String",mxCreateString(Status));;
mexEvalString("drawnow");

//-------------------------------------
// Allocate Space on Host & Device                   
//-------------------------------------
mwSize *HSampDat,*HCrtDat,*HKx,*HKy,*HKern;
mwSize addreslen = 1;
HSampDat = (mwSize*)mxCalloc(addreslen,sizeof(mwSize));
HCrtDat = (mwSize*)mxCalloc(addreslen,sizeof(mwSize));
HKx = (mwSize*)mxCalloc(addreslen,sizeof(mwSize));
HKy = (mwSize*)mxCalloc(addreslen,sizeof(mwSize));
HKern = (mwSize*)mxCalloc(addreslen,sizeof(mwSize));
ArrAllocDbl(HSampDat,DatLen,Tst,Error);
if (strcmp(Error,"no error") != 0) {
	plhs[2] = mxCreateString(Error); return;
	}
Mat2DAllocDbl(HCrtDat,CrtDatSz,Tst,Error);
if (strcmp(Error,"no error") != 0) {
	plhs[2] = mxCreateString(Error); return;
	}
ArrAllocDbl(HKx,DatLen,Tst,Error);
if (strcmp(Error,"no error") != 0) {
	plhs[2] = mxCreateString(Error); return;
	}
ArrAllocDbl(HKy,DatLen,Tst,Error);
if (strcmp(Error,"no error") != 0) {
	plhs[2] = mxCreateString(Error); return;
	}
Mat2DAllocDbl(HKern,KernSz,Tst,Error);
if (strcmp(Error,"no error") != 0) {
	plhs[2] = mxCreateString(Error); return;
	}

//-------------------------------------
// Display                  
//-------------------------------------	
sprintf(Status,"CUDA Memory Load");
mxSetProperty(prhs[8],0,"String",mxCreateString(Status));;
mexEvalString("drawnow");
	
//-------------------------------------
// Load / Initialize                    
//-------------------------------------
Mat2DLoadDbl(CrtDat,HCrtDat,CrtDatSz,Error);
if (strcmp(Error,"no error") != 0) {
	plhs[2] = mxCreateString(Error); return;
	}
ArrLoadDbl(Kx,HKx,DatLen,Error);
if (strcmp(Error,"no error") != 0) {
	plhs[2] = mxCreateString(Error); return;
	}	
ArrLoadDbl(Ky,HKy,DatLen,Error);
if (strcmp(Error,"no error") != 0) {
	plhs[2] = mxCreateString(Error); return;
	}
Mat2DLoadDbl(Kern,HKern,KernSz,Error);
if (strcmp(Error,"no error") != 0) {
	plhs[2] = mxCreateString(Error); return;
	}

//-------------------------------------
// Perform Convolution                 
//------------------------------------- 
int nchunks = int(ceil(double(DatLen)/double(chunklen)));
int SampDatAdr = 0;
for (int n=0; n<(nchunks-1); n++){	
	sprintf(Status,"Data Point: %i",SampDatAdr);
	mxSetProperty(prhs[8],0,"String",mxCreateString(Status));;
	mexEvalString("drawnow");
	ConvGrid2SampSplitRD2D(HSampDat,HCrtDat,HKx,HKy,HKern,CrtDatSz,chunklen,KernSz,iKern,chW,SampDatAdr,Error);
	if (strcmp(Error,"no error") != 0) {
		plhs[2] = mxCreateString(Error); return;
		}
	SampDatAdr += chunklen;
	}
int chunkrem = DatLen - ((nchunks-1)*chunklen);
Tst[10] = chunkrem;
sprintf(Status,"Data Point: %i",SampDatAdr);
mxSetProperty(prhs[8],0,"String",mxCreateString(Status));;
mexEvalString("drawnow");
ConvGrid2SampSplitRD2D(HSampDat,HCrtDat,HKx,HKy,HKern,CrtDatSz,chunkrem,KernSz,iKern,chW,SampDatAdr,Error);
if (strcmp(Error,"no error") != 0) {
	plhs[2] = mxCreateString(Error); return;
	}

//-------------------------------------
// Return Data                    
//-------------------------------------
ArrReturnDbl(SampDat,HSampDat,DatLen,Error);
if (strcmp(Error,"no error") != 0) {
	plhs[2] = mxCreateString(Error); return;
	}

//-------------------------------------
// Free Device Memory                 
//------------------------------------- 	
ArrFreeDbl(HSampDat,Error);
if (strcmp(Error,"no error") != 0) {
	plhs[2] = mxCreateString(Error); return;
	}
Mat2DFreeDbl(HCrtDat,Error);
if (strcmp(Error,"no error") != 0) {
	plhs[2] = mxCreateString(Error); return;
	}	
ArrFreeDbl(HKx,Error);
if (strcmp(Error,"no error") != 0) {
	plhs[2] = mxCreateString(Error); return;
	}	
ArrFreeDbl(HKy,Error);
if (strcmp(Error,"no error") != 0) {
	plhs[2] = mxCreateString(Error); return;
	}
Mat2DFreeDbl(HKern,Error);
if (strcmp(Error,"no error") != 0) {
	plhs[2] = mxCreateString(Error); return;
	}	
	
//-------------------------------------
// Return Error                    
//------------------------------------- 
plhs[2] = mxCreateString(Error);

//-------------------------------------
// Free Memory                   
//------------------------------------- 
mxFree(Error);
mxFree(HSampDat);
mxFree(HCrtDat);
mxFree(HKx);
mxFree(HKy);
mxFree(HKern);

}

