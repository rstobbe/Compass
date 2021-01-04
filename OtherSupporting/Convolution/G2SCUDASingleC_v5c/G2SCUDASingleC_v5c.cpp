///==========================================================
/// (v5c)
///		- Includes Matlab's new complex API (2018)
///         * was necessary to go here to do singles
///==========================================================

#include "mex.h"
#include "matrix.h"
#include "math.h"
#include "string.h"
#include "CUDA_DeviceManage_v1c.h"
#include "CUDA_GeneralSM_v1c.h"
#include "CUDA_ConvGrid2SampSplitCSM_v1b.h"
#include "CUDA_MultiDevSampArrCombS_v1a.h"

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, mxArray *prhs[])
{

//-------------------------------------
// Input                        
//-------------------------------------
float *CrtDatC;
float *Kx,*Ky,*Kz,*Kern;
int iKern,chW,chunklen;
int *temp;

if (nrhs != 9) mexErrMsgTxt("Should have 9 inputs");
CrtDatC = (float*)mxGetComplexSingles(prhs[0]);  
Kx = (float*)mxGetData(prhs[1]);     
Ky = (float*)mxGetData(prhs[2]);     
Kz = (float*)mxGetData(prhs[3]);     
Kern = (float*)mxGetData(prhs[4]);     
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
mxComplexSingle *SampDatC;
mwSize *Tst;
char *Error;
mwSize errorlen = 200;
mwSize Dat_Dim[2];
mwSize Tst_Dim[2];

if (nlhs != 3) mexErrMsgTxt("Should have 3 outputs");
Dat_Dim[0] = DatLen; 
Dat_Dim[1] = 1; 
plhs[0] = mxCreateNumericArray(2,Dat_Dim,mxSINGLE_CLASS,mxCOMPLEX);
SampDatC = mxGetComplexSingles(plhs[0]);
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
// Allocate Space on Device                   
//-------------------------------------
int BaseGpu = 0;
int SecondGpu = 1;
mwSize *HSampDatC, *HSampDatCTemp, *HCrtDatC, *HKx, *HKy, *HKz, *HKern;

mwSize GpuNum = *DevCnt;
HSampDatC = (mwSize*)mxCalloc(GpuNum,sizeof(mwSize));
HSampDatCTemp = (mwSize*)mxCalloc(GpuNum,sizeof(mwSize));
HCrtDatC = (mwSize*)mxCalloc(GpuNum,sizeof(mwSize));
HKx = (mwSize*)mxCalloc(GpuNum,sizeof(mwSize));
HKy = (mwSize*)mxCalloc(GpuNum,sizeof(mwSize));
HKz = (mwSize*)mxCalloc(GpuNum,sizeof(mwSize));
HKern = (mwSize*)mxCalloc(GpuNum,sizeof(mwSize));

ArrAllocSglC((int)GpuNum,HSampDatC,DatLen,Tst,Error);
if (strcmp(Error,"no error") != 0) {
	plhs[2] = mxCreateString(Error); return;
	}
ArrAllocSglC((int)GpuNum,HSampDatCTemp,DatLen,Tst,Error);
if (strcmp(Error,"no error") != 0) {
	plhs[2] = mxCreateString(Error); return;
	}
Mat3DAllocSglC((int)GpuNum,HCrtDatC,CrtDatSz,Tst,Error);
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
mxSetProperty(prhs[8],0,"String",mxCreateString(Status));
mexEvalString("drawnow");

//-------------------------------------
// Load / Initialize                    
//-------------------------------------
Mat3DLoadSglC((int)GpuNum,CrtDatC,HCrtDatC,CrtDatSz,Error);
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
ArrInitSglC((int)GpuNum,HSampDatC,DatLen,Error);
if (strcmp(Error,"no error") != 0) {
	plhs[2] = mxCreateString(Error); return;
	}	
ArrInitSglC((int)GpuNum,HSampDatCTemp,DatLen,Error);
if (strcmp(Error,"no error") != 0) {
	plhs[2] = mxCreateString(Error); return;
	}

///==================================================================
// Perform Convolution                 
///==================================================================
int nchunks = int(ceil(float(DatLen)/float(chunklen)));
int SampDatAdr = 0;
int SampDatAdrC = 0;
for (int n=0; n<(nchunks-1); n++){	
	sprintf(Status,"Data Point: %i",SampDatAdr);
	mxSetProperty(prhs[8],0,"String",mxCreateString(Status));
	mexEvalString("drawnow");
    ConvGrid2SampSplitCSM((int)GpuNum,HSampDatC,HCrtDatC,HKx,HKy,HKz,HKern,CrtDatSz,chunklen,KernSz,iKern,chW,SampDatAdr,SampDatAdrC,Error);
	if (strcmp(Error,"no error") != 0) {
		plhs[2] = mxCreateString(Error); return;
		}
	SampDatAdr += chunklen;
	SampDatAdrC += 2*chunklen;
	}
int chunkrem = DatLen - ((nchunks-1)*chunklen);
sprintf(Status,"Data Point: %i",SampDatAdr);
mxSetProperty(prhs[8],0,"String",mxCreateString(Status));
mexEvalString("drawnow");
ConvGrid2SampSplitCSM((int)GpuNum,HSampDatC,HCrtDatC,HKx,HKy,HKz,HKern,CrtDatSz,chunkrem,KernSz,iKern,chW,SampDatAdr,SampDatAdrC,Error);
if (strcmp(Error,"no error") != 0) {
	plhs[2] = mxCreateString(Error); return;
	}

//-------------------------------------
// Combine Data                   
//-------------------------------------
MultiDevSampArrCombS(BaseGpu,SecondGpu,HSampDatC,HSampDatCTemp,DatLen*2,Error);

//-------------------------------------
// Return Data                    
//-------------------------------------
ArrReturnSglC(BaseGpu,(float*)SampDatC,HSampDatCTemp,DatLen,Error);
//ArrReturnSglC(BaseGpu,(float*)SampDatC,HSampDatC,DatLen,Error);
//ArrReturnSglC(SecondGpu,(float*)SampDatC,HSampDatC,DatLen,Error);
if (strcmp(Error,"no error") != 0) {
	plhs[2] = mxCreateString(Error); return;
	}

//-------------------------------------
// Free Device Memory                 
//------------------------------------- 	
ArrFreeSglC((int)GpuNum,HSampDatC,Error);
if (strcmp(Error,"no error") != 0) {
	plhs[2] = mxCreateString(Error); return;
	}
ArrFreeSglC((int)GpuNum,HSampDatCTemp,Error);
if (strcmp(Error,"no error") != 0) {
	plhs[2] = mxCreateString(Error); return;
	}
Mat3DFreeSglC((int)GpuNum,HCrtDatC,Error);
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
mxFree(HSampDatC);
mxFree(HSampDatCTemp);
mxFree(HCrtDatC);
mxFree(HKx);
mxFree(HKy);
mxFree(HKz);
mxFree(HKern);

}

