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
#include "CUDA_GeneralDM_v1c.h"
#include "CUDA_ConvGrid2SampSplitRDM_v1a.h"
#include "CUDA_MultiDevSampArrComb_v1a.h"

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, mxArray *prhs[])
{

//-------------------------------------
// Input                        
//-------------------------------------
double *CrtDat,*Kx,*Ky,*Kz,*Kern;
int iKern,chW,chunklen;
int *temp;

if (nrhs != 9) mexErrMsgTxt("Should have 9 inputs");
CrtDat = (double*)mxGetData(prhs[0]);  
Kx = (double*)mxGetData(prhs[1]);     
Ky = (double*)mxGetData(prhs[2]);     
Kz = (double*)mxGetData(prhs[3]);     
Kern = (double*)mxGetData(prhs[4]);     
temp = (int*)mxGetData(prhs[5]); iKern = temp[0];
temp = (int*)mxGetData(prhs[6]); chW = temp[0];
temp = (int*)mxGetData(prhs[7]); chunklen = temp[0];
//Status = prhs[8]

const mwSize *temp2;
int DatLen,KernSz,CrtDatSz;
temp2 = mxGetDimensions(prhs[0]);
CrtDatSz = (int)temp2[0];
temp2 = mxGetDimensions(prhs[1]);
DatLen = (int)temp2[0];
temp2 = mxGetDimensions(prhs[4]);
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
mxSetProperty(prhs[8],0,"String",mxCreateString(Status));
mexEvalString("drawnow");


//-------------------------------------
// Allocate Space on Host & Device                   
//-------------------------------------
int BaseGpu = 0;
int SecondGpu = 1;
mwSize *HSampDat,*HSampDatTemp,*HCrtDat,*HKx,*HKy,*HKz,*HKern;
mwSize GpuNum = *DevCnt;
HSampDat = (mwSize*)mxCalloc(GpuNum,sizeof(mwSize));
HSampDatTemp = (mwSize*)mxCalloc(GpuNum,sizeof(mwSize));
HCrtDat = (mwSize*)mxCalloc(GpuNum,sizeof(mwSize));
HKx = (mwSize*)mxCalloc(GpuNum,sizeof(mwSize));
HKy = (mwSize*)mxCalloc(GpuNum,sizeof(mwSize));
HKz = (mwSize*)mxCalloc(GpuNum,sizeof(mwSize));
HKern = (mwSize*)mxCalloc(GpuNum,sizeof(mwSize));
ArrAllocDbl((int)GpuNum,HSampDat,DatLen,Tst,Error);
if (strcmp(Error,"no error") != 0) {
	plhs[2] = mxCreateString(Error); return;
	}
ArrAllocDbl((int)GpuNum,HSampDatTemp,DatLen,Tst,Error);
if (strcmp(Error,"no error") != 0) {
	plhs[2] = mxCreateString(Error); return;
	}	
Mat3DAllocDbl((int)GpuNum,HCrtDat,CrtDatSz,Tst,Error);
if (strcmp(Error,"no error") != 0) {
	plhs[2] = mxCreateString(Error); return;
	}
ArrAllocDbl((int)GpuNum,HKx,DatLen,Tst,Error);
if (strcmp(Error,"no error") != 0) {
	plhs[2] = mxCreateString(Error); return;
	}
ArrAllocDbl((int)GpuNum,HKy,DatLen,Tst,Error);
if (strcmp(Error,"no error") != 0) {
	plhs[2] = mxCreateString(Error); return;
	}
ArrAllocDbl((int)GpuNum,HKz,DatLen,Tst,Error);
if (strcmp(Error,"no error") != 0) {
	plhs[2] = mxCreateString(Error); return;
	}
Mat3DAllocDbl((int)GpuNum,HKern,KernSz,Tst,Error);
if (strcmp(Error,"no error") != 0) {
	plhs[2] = mxCreateString(Error); return;
	}

//-------------------------------------
// Display                  
//-------------------------------------	
sprintf(Status,"CUDA Memory Load: %i GPUs",*DevCnt);
mxSetProperty(prhs[8],0,"String",mxCreateString(Status));
mexEvalString("drawnow");
	
//-------------------------------------
// Load / Initialize                    
//-------------------------------------
Mat3DLoadDbl((int)GpuNum,CrtDat,HCrtDat,CrtDatSz,Error);
if (strcmp(Error,"no error") != 0) {
	plhs[2] = mxCreateString(Error); return;
	}
ArrLoadDbl((int)GpuNum,Kx,HKx,DatLen,Error);
if (strcmp(Error,"no error") != 0) {
	plhs[2] = mxCreateString(Error); return;
	}	
ArrLoadDbl((int)GpuNum,Ky,HKy,DatLen,Error);
if (strcmp(Error,"no error") != 0) {
	plhs[2] = mxCreateString(Error); return;
	}
ArrLoadDbl((int)GpuNum,Kz,HKz,DatLen,Error);
if (strcmp(Error,"no error") != 0) {
	plhs[2] = mxCreateString(Error); return;
	}	
Mat3DLoadDbl((int)GpuNum,Kern,HKern,KernSz,Error);
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
	mxSetProperty(prhs[8],0,"String",mxCreateString(Status));
	mexEvalString("drawnow");
	ConvGrid2SampSplitRDM((int)GpuNum,HSampDat,HCrtDat,HKx,HKy,HKz,HKern,CrtDatSz,chunklen,KernSz,iKern,chW,SampDatAdr,Error);
	if (strcmp(Error,"no error") != 0) {
		plhs[2] = mxCreateString(Error); return;
		}
	SampDatAdr += chunklen;
	}
int chunkrem = DatLen - ((nchunks-1)*chunklen);
sprintf(Status,"Data Point: %i",SampDatAdr);
mxSetProperty(prhs[8],0,"String",mxCreateString(Status));
mexEvalString("drawnow");
ConvGrid2SampSplitRDM((int)GpuNum,HSampDat,HCrtDat,HKx,HKy,HKz,HKern,CrtDatSz,chunkrem,KernSz,iKern,chW,SampDatAdr,Error);
if (strcmp(Error,"no error") != 0) {
	plhs[2] = mxCreateString(Error); return;
	}

//-------------------------------------
// Combine Data                   
//-------------------------------------
MultiDevSampArrComb(BaseGpu,SecondGpu,HSampDat,HSampDatTemp,DatLen,Error);
	
//-------------------------------------
// Return Data                    
//-------------------------------------
ArrReturnDbl(BaseGpu,SampDat,HSampDatTemp,DatLen,Error);
if (strcmp(Error,"no error") != 0) {
	plhs[2] = mxCreateString(Error); return;
	}

//-------------------------------------
// Free Device Memory                 
//------------------------------------- 	
ArrFreeDbl((int)GpuNum,HSampDat,Error);
if (strcmp(Error,"no error") != 0) {
	plhs[2] = mxCreateString(Error); return;
	}
ArrFreeDbl((int)GpuNum,HSampDatTemp,Error);
if (strcmp(Error,"no error") != 0) {
	plhs[2] = mxCreateString(Error); return;
	}	
Mat3DFreeDbl((int)GpuNum,HCrtDat,Error);
if (strcmp(Error,"no error") != 0) {
	plhs[2] = mxCreateString(Error); return;
	}	
ArrFreeDbl((int)GpuNum,HKx,Error);
if (strcmp(Error,"no error") != 0) {
	plhs[2] = mxCreateString(Error); return;
	}	
ArrFreeDbl((int)GpuNum,HKy,Error);
if (strcmp(Error,"no error") != 0) {
	plhs[2] = mxCreateString(Error); return;
	}
ArrFreeDbl((int)GpuNum,HKz,Error);
if (strcmp(Error,"no error") != 0) {
	plhs[2] = mxCreateString(Error); return;
	}	
Mat3DFreeDbl((int)GpuNum,HKern,Error);
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
mxFree(HSampDatTemp);
mxFree(HCrtDat);
mxFree(HKx);
mxFree(HKy);
mxFree(HKz);
mxFree(HKern);

}

