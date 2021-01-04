///==========================================================
/// (v5b)
///		- This code essentially same as (v4g)
///             - devcnt added
///				- parallel GPU supported CUDA calls
///             - compiled with 9.0
///==========================================================

#include "mex.h"
#include "matrix.h"
#include "math.h"
#include "string.h"
#include "CUDA_DeviceManage_v1c.h"
#include "CUDA_GeneralSM_v1c.h"
#include "CUDA_ConvSamp2GridSplitRSM_v1a.h"
#include "CUDA_MultiDevMatAddS_v1a.h"

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, mxArray *prhs[])
{

//-------------------------------------
// Input                        
//-------------------------------------
float *SampDat,*Kx,*Ky,*Kz,*Kern;
int iKern,chW,CrtDatSz,chunklen;
int *temp;

if (nrhs != 10) mexErrMsgTxt("Should have 10 inputs");
SampDat = mxGetSingles(prhs[0]);
Kx = mxGetSingles(prhs[1]);     
Ky = mxGetSingles(prhs[2]);     
Kz = mxGetSingles(prhs[3]);     
Kern = mxGetSingles(prhs[4]);     
temp = (int*)mxGetData(prhs[5]); iKern = temp[0];
temp = (int*)mxGetData(prhs[6]); chW = temp[0];
temp = (int*)mxGetData(prhs[7]); CrtDatSz = temp[0];
temp = (int*)mxGetData(prhs[8]); chunklen = temp[0];
// status = prhs[9];

const mwSize *temp2;
int DatLen,KernSz;
temp2 = mxGetDimensions(prhs[1]);
DatLen = (int)temp2[0];
temp2 = mxGetDimensions(prhs[4]);
KernSz = (int)temp2[0];

//-------------------------------------
// Output                       
//-------------------------------------
float *CrtDat;
mwSize *Tst;
char *Error;
mwSize errorlen = 200;
mwSize Dat_Dim[3];
mwSize Tst_Dim[2];

if (nlhs != 3) mexErrMsgTxt("Should have 3 outputs");
Dat_Dim[0] = CrtDatSz; 
Dat_Dim[1] = CrtDatSz;
Dat_Dim[2] = CrtDatSz;
plhs[0] = mxCreateNumericArray(3,Dat_Dim,mxSINGLE_CLASS,mxREAL);
CrtDat = mxGetSingles(plhs[0]); 
Tst_Dim[0] = 1; 
Tst_Dim[1] = 20; 
plhs[1] = mxCreateNumericArray(2,Tst_Dim,mxINT64_CLASS,mxREAL);
Tst = (mwSize*)mxGetData(plhs[1]);
Error = (char*)mxCalloc(errorlen,sizeof(char));
strcpy(Error,"no error");

//-------------------------------------
// Determine #GPUs           
//-------------------------------------	
int *DevCnt;
DevCnt = (int*)mxCalloc(1,sizeof(int));
CUDAcount(DevCnt,Error);
if (strcmp(Error,"no error") != 0) {
	plhs[2] = mxCreateString(Error); return;
	}

//-------------------------------------
// Display                  
//-------------------------------------	
char Status[150];
sprintf(Status,"CUDA Memory Allocate: %i GPUs",*DevCnt);
mxSetProperty(prhs[9],0,"String",mxCreateString(Status));
mexEvalString("drawnow");

//-------------------------------------
// Allocate Space on Host & Device                   
//-------------------------------------
int BaseGpu = 0;
int SecondGpu = 1;
mwSize *HSampDat,*HCrtDat,*HCrtDatTemp,*HKx,*HKy,*HKz,*HKern;
mwSize GpuNum = *DevCnt;
HSampDat = (mwSize*)mxCalloc(GpuNum,sizeof(mwSize));
HCrtDat = (mwSize*)mxCalloc(GpuNum,sizeof(mwSize));
HCrtDatTemp = (mwSize*)mxCalloc(GpuNum,sizeof(mwSize));
HKx = (mwSize*)mxCalloc(GpuNum,sizeof(mwSize));
HKy = (mwSize*)mxCalloc(GpuNum,sizeof(mwSize));
HKz = (mwSize*)mxCalloc(GpuNum,sizeof(mwSize));
HKern = (mwSize*)mxCalloc(GpuNum,sizeof(mwSize));
ArrAllocSgl((int)GpuNum,HSampDat,DatLen,Tst,Error);
if (strcmp(Error,"no error") != 0) {
	plhs[2] = mxCreateString(Error); return;
	}
Mat3DAllocSgl((int)GpuNum,HCrtDat,CrtDatSz,Tst,Error);
if (strcmp(Error,"no error") != 0) {
	plhs[2] = mxCreateString(Error); return;
	}
Mat3DAllocSgl((int)GpuNum,HCrtDatTemp,CrtDatSz,Tst,Error);
if (strcmp(Error,"no error") != 0) {
	plhs[2] = mxCreateString(Error); return;
	}
ArrAllocSgl((int)GpuNum,HKx,DatLen,Tst,Error);
if (strcmp(Error,"no error") != 0) {
	plhs[2] = mxCreateString(Error); return;
	}
ArrAllocSgl((int)GpuNum,HKy,DatLen,Tst,Error);
if (strcmp(Error,"no error") != 0) {
	plhs[2] = mxCreateString(Error); return;
	}
ArrAllocSgl((int)GpuNum,HKz,DatLen,Tst,Error);
if (strcmp(Error,"no error") != 0) {
	plhs[2] = mxCreateString(Error); return;
	}
Mat3DAllocSgl((int)GpuNum,HKern,KernSz,Tst,Error);
if (strcmp(Error,"no error") != 0) {
	plhs[2] = mxCreateString(Error); return;
	}

//-------------------------------------
// Display                  
//-------------------------------------	
sprintf(Status,"CUDA Memory Load: %i GPUs",*DevCnt);
mxSetProperty(prhs[9],0,"String",mxCreateString(Status));
mexEvalString("drawnow");
	
//-------------------------------------
// Load / Initialize                    
//-------------------------------------
Mat3DInitSgl((int)GpuNum,HCrtDat,CrtDatSz,Error);
if (strcmp(Error,"no error") != 0) {
	plhs[2] = mxCreateString(Error); return;
	}	
Mat3DInitSgl((int)GpuNum,HCrtDatTemp,CrtDatSz,Error);
if (strcmp(Error,"no error") != 0) {
	plhs[2] = mxCreateString(Error); return;
	}
ArrLoadSgl((int)GpuNum,SampDat,HSampDat,DatLen,Error);
if (strcmp(Error,"no error") != 0) {
	plhs[2] = mxCreateString(Error); return;
	}	
ArrLoadSgl((int)GpuNum,Kx,HKx,DatLen,Error);
if (strcmp(Error,"no error") != 0) {
	plhs[2] = mxCreateString(Error); return;
	}	
ArrLoadSgl((int)GpuNum,Ky,HKy,DatLen,Error);
if (strcmp(Error,"no error") != 0) {
	plhs[2] = mxCreateString(Error); return;
	}
ArrLoadSgl((int)GpuNum,Kz,HKz,DatLen,Error);
if (strcmp(Error,"no error") != 0) {
	plhs[2] = mxCreateString(Error); return;
	}	
Mat3DLoadSgl((int)GpuNum,Kern,HKern,KernSz,Error);
if (strcmp(Error,"no error") != 0) {
	plhs[2] = mxCreateString(Error); return;
	}
	
//-------------------------------------
// Perform Convolution                 
//------------------------------------- 
int nchunks = int(ceil(float(DatLen)/float(chunklen)));
int SampDatAdr = 0;
for (int n=0; n<(nchunks-1); n++){	
	sprintf(Status,"Data Point: %i",SampDatAdr);
	mxSetProperty(prhs[9],0,"String",mxCreateString(Status));
	mexEvalString("drawnow");
	ConvSamp2GridSplitRSM((int)GpuNum,HSampDat,HCrtDat,HKx,HKy,HKz,HKern,CrtDatSz,chunklen,KernSz,iKern,chW,SampDatAdr,Error);
	if (strcmp(Error,"no error") != 0) {
		plhs[2] = mxCreateString(Error); return;
		}
	SampDatAdr += chunklen;
	}
int chunkrem = DatLen - ((nchunks-1)*chunklen);
sprintf(Status,"Data Point: %i",SampDatAdr);
mxSetProperty(prhs[9],0,"String",mxCreateString(Status));
mexEvalString("drawnow");
ConvSamp2GridSplitRSM((int)GpuNum,HSampDat,HCrtDat,HKx,HKy,HKz,HKern,CrtDatSz,chunkrem,KernSz,iKern,chW,SampDatAdr,Error);
if (strcmp(Error,"no error") != 0) {
	plhs[2] = mxCreateString(Error); return;
	}

//-------------------------------------
// Combine Data                   
//-------------------------------------
MultiDevMatAddS(BaseGpu,SecondGpu,HCrtDat,HCrtDatTemp,CrtDatSz,Error);

//-------------------------------------
// Return Data                    
//-------------------------------------
Mat3DReturnSgl(BaseGpu,CrtDat,HCrtDatTemp,CrtDatSz,Error);
if (strcmp(Error,"no error") != 0) {
	plhs[2] = mxCreateString(Error); return;
	}

//-------------------------------------
// Free Device Memory                 
//------------------------------------- 	
ArrFreeSgl((int)GpuNum,HSampDat,Error);
if (strcmp(Error,"no error") != 0) {
	plhs[2] = mxCreateString(Error); return;
	}
Mat3DFreeSgl((int)GpuNum,HCrtDat,Error);
if (strcmp(Error,"no error") != 0) {
	plhs[2] = mxCreateString(Error); return;
	}	
Mat3DFreeSgl((int)GpuNum,HCrtDatTemp,Error);
if (strcmp(Error,"no error") != 0) {
	plhs[2] = mxCreateString(Error); return;
	}	
ArrFreeSgl((int)GpuNum,HKx,Error);
if (strcmp(Error,"no error") != 0) {
	plhs[2] = mxCreateString(Error); return;
	}	
ArrFreeSgl((int)GpuNum,HKy,Error);
if (strcmp(Error,"no error") != 0) {
	plhs[2] = mxCreateString(Error); return;
	}
ArrFreeSgl((int)GpuNum,HKz,Error);
if (strcmp(Error,"no error") != 0) {
	plhs[2] = mxCreateString(Error); return;
	}	
Mat3DFreeSgl((int)GpuNum,HKern,Error);
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
mxFree(HCrtDatTemp);
mxFree(HKx);
mxFree(HKy);
mxFree(HKz);
mxFree(HKern);

}

