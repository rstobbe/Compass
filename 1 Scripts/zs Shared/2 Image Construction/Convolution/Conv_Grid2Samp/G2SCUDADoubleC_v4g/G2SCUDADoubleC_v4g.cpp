///==========================================================
/// (v4g)
///			Update for Windows10
///==========================================================

#include "mex.h"
#include "matrix.h"
#include "math.h"
#include "string.h"
#include "CUDA_GeneralD_v1a.h"
#include "CUDA_ConvGrid2SampSplitCD_v1c.h"
#include "CUDA_DeviceManage_v1a.h"

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, mxArray *prhs[])
{

//-------------------------------------
// Input                        
//-------------------------------------
double *CrtDatR,*CrtDatI,*Kx,*Ky,*Kz,*Kern;
int iKern,chW,chunklen,devicenum;
int *temp;

if (nrhs != 10) mexErrMsgTxt("Should have 10 inputs");
CrtDatR = mxGetPr(prhs[0]);  
CrtDatI = mxGetPi(prhs[0]);
Kx = (double*)mxGetData(prhs[1]);     
Ky = (double*)mxGetData(prhs[2]);     
Kz = (double*)mxGetData(prhs[3]);     
Kern = (double*)mxGetData(prhs[4]);     
temp = (int*)mxGetData(prhs[5]); iKern = temp[0];
temp = (int*)mxGetData(prhs[6]); chW = temp[0];
temp = (int*)mxGetData(prhs[7]); chunklen = temp[0];
temp = (int*)mxGetData(prhs[8]); devicenum = temp[0];
//Status = prhs[9]

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
double *SampDatR,*SampDatI;
mwSize *Tst;
char *Error;
mwSize errorlen = 200;
mwSize Dat_Dim[2];
mwSize Tst_Dim[2];

if (nlhs != 3) mexErrMsgTxt("Should have 3 outputs");
Dat_Dim[0] = DatLen; 
Dat_Dim[1] = 1; 
plhs[0] = mxCreateNumericArray(2,Dat_Dim,mxDOUBLE_CLASS,mxCOMPLEX);
SampDatR = mxGetPr(plhs[0]); 
SampDatI = mxGetPi(plhs[0]); 
Tst_Dim[0] = 1; 
Tst_Dim[1] = 20; 
plhs[1] = mxCreateNumericArray(2,Tst_Dim,mxINT64_CLASS,mxREAL);
Tst = (mwSize*)mxGetData(plhs[1]);
Error = (char*)mxCalloc(errorlen,sizeof(char));
strcpy(Error,"no error");

//-------------------------------------
// Allocate Space on Host               
//-------------------------------------
int CrtDatlen = 2*CrtDatSz*CrtDatSz*CrtDatSz;
double *CrtDatC = (double*)mxMalloc(sizeof(double)*CrtDatlen);

//-------------------------------------
// Allocate Space on Device                   
//-------------------------------------
char Status[150];
sprintf(Status,"CUDA Memory Allocate");
mxSetProperty(prhs[9],0,"String",mxCreateString(Status));;
mexEvalString("drawnow");

mwSize *HCrtDatC, *HKx, *HKy, *HKz, *HKern, *HSampDatR, *HSampDatI;
mwSize addreslen = 1;
HCrtDatC = (mwSize*)mxCalloc(addreslen,sizeof(mwSize));
HKx = (mwSize*)mxCalloc(addreslen,sizeof(mwSize));
HKy = (mwSize*)mxCalloc(addreslen,sizeof(mwSize));
HKz = (mwSize*)mxCalloc(addreslen,sizeof(mwSize));
HKern = (mwSize*)mxCalloc(addreslen,sizeof(mwSize));
HSampDatR = (mwSize*)mxCalloc(addreslen,sizeof(mwSize));
HSampDatI = (mwSize*)mxCalloc(addreslen,sizeof(mwSize));

Mat3DAllocDblC(HCrtDatC,CrtDatSz,Tst,Error);
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
ArrAllocDbl(HKz,DatLen,Tst,Error);
if (strcmp(Error,"no error") != 0) {
	plhs[2] = mxCreateString(Error); return;
	}
Mat3DAllocDbl(HKern,KernSz,Tst,Error);
if (strcmp(Error,"no error") != 0) {
	plhs[2] = mxCreateString(Error); return;
	}
ArrAllocDbl(HSampDatR,DatLen,Tst,Error);
if (strcmp(Error,"no error") != 0) {
	plhs[2] = mxCreateString(Error); return;
	}
ArrAllocDbl(HSampDatI,DatLen,Tst,Error);
if (strcmp(Error,"no error") != 0) {
	plhs[2] = mxCreateString(Error); return;
	}
	
//-------------------------------------
// Load / Initialize                    
//-------------------------------------
sprintf(Status,"CUDA Memory Load");
mxSetProperty(prhs[9],0,"String",mxCreateString(Status));;
mexEvalString("drawnow");

for (int i=0; i<CrtDatSz*CrtDatSz*CrtDatSz; i++) {				// complex data interleaved on Cuda
    CrtDatC[2*i] = CrtDatR[i];
    CrtDatC[2*i+1] = CrtDatI[i];
    }
Mat3DLoadDblC(CrtDatC,HCrtDatC,CrtDatSz,Error);
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
ArrLoadDbl(Kz,HKz,DatLen,Error);
if (strcmp(Error,"no error") != 0) {
	plhs[2] = mxCreateString(Error); return;
	}	
Mat3DLoadDbl(Kern,HKern,KernSz,Error);
if (strcmp(Error,"no error") != 0) {
	plhs[2] = mxCreateString(Error); return;
	}
ArrInitDbl(HSampDatR,DatLen,Error);
if (strcmp(Error,"no error") != 0) {
	plhs[2] = mxCreateString(Error); return;
	}
ArrInitDbl(HSampDatI,DatLen,Error);
if (strcmp(Error,"no error") != 0) {
	plhs[2] = mxCreateString(Error); return;
	}

///===========================================================
// Perform Convolution                 
///===========================================================
int nchunks = int(ceil(double(DatLen)/double(chunklen)));
int SampDatAdr = 0;
for (int n=0; n<(nchunks-1); n++){	
	sprintf(Status,"Data Point: %i",SampDatAdr);
	mxSetProperty(prhs[9],0,"String",mxCreateString(Status));;
	mexEvalString("drawnow");
    ConvGrid2SampSplitCD(HSampDatR,HSampDatI,HCrtDatC,HKx,HKy,HKz,HKern,CrtDatSz,chunklen,KernSz,iKern,chW,SampDatAdr,Error);
    if (strcmp(Error,"no error") != 0) {
        sprintf(Status,"Error: Conv");
        mxSetProperty(prhs[9],0,"String",mxCreateString(Status));
        mexEvalString("drawnow");
        plhs[2] = mxCreateString(Error); return;
		}
	SampDatAdr += chunklen;
	}
int chunkrem = DatLen - ((nchunks-1)*chunklen);
Tst[10] = chunkrem;
sprintf(Status,"Data Point: %i",SampDatAdr);
mxSetProperty(prhs[9],0,"String",mxCreateString(Status));;
mexEvalString("drawnow");
ConvGrid2SampSplitCD(HSampDatR,HSampDatI,HCrtDatC,HKx,HKy,HKz,HKern,CrtDatSz,chunkrem,KernSz,iKern,chW,SampDatAdr,Error);
if (strcmp(Error,"no error") != 0) {
    sprintf(Status,"Error: Conv");
    mxSetProperty(prhs[9],0,"String",mxCreateString(Status));
    mexEvalString("drawnow");
    plhs[2] = mxCreateString(Error); return;
    }

//-------------------------------------
// Return Data                    
//-------------------------------------
ArrReturnDbl(SampDatR,HSampDatR,DatLen,Error);
if (strcmp(Error,"no error") != 0) {
	plhs[2] = mxCreateString(Error); return;
	}
ArrReturnDbl(SampDatI,HSampDatI,DatLen,Error);
if (strcmp(Error,"no error") != 0) {
	plhs[2] = mxCreateString(Error); return;
	}

//-------------------------------------
// Free Device Memory                 
//------------------------------------- 	
Mat3DFreeDbl(HCrtDatC,Error);
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
ArrFreeDbl(HKz,Error);
if (strcmp(Error,"no error") != 0) {
	plhs[2] = mxCreateString(Error); return;
	}	
Mat3DFreeDbl(HKern,Error);
if (strcmp(Error,"no error") != 0) {
	plhs[2] = mxCreateString(Error); return;
	}	
ArrFreeDbl(HSampDatR,Error);
if (strcmp(Error,"no error") != 0) {
	plhs[2] = mxCreateString(Error); return;
	}
ArrFreeDbl(HSampDatI,Error);
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
mxFree(HCrtDatC);
mxFree(HKx);
mxFree(HKy);
mxFree(HKz);
mxFree(HKern);
mxFree(HSampDatR);
mxFree(HSampDatI);

}

