///==========================================================
/// (v4f)
///			Start S2GCUDADoubleC2D_v4f
///==========================================================

#include "mex.h"
#include "matrix.h"
#include "math.h"
#include "string.h"
#include "CUDA_2DGeneralD_v1a.h"
#include "CUDA_2DmsGeneralD_v1a.h"
#include "CUDA_ConvSamp2GridCD2Dms_v1c.h"
#include "CUDA_DeviceManage_v1a.h"

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, mxArray *prhs[])
{

//-------------------------------------
// Input                        
//-------------------------------------
double *SampDatR,*SampDatI,*Kx,*Ky,*Kern;
int iKern,chW,CrtDatSz,devicenum;
int *temp;

if (nrhs != 9) mexErrMsgTxt("Should have 9 inputs");
SampDatR = mxGetPr(prhs[0]);
SampDatI = mxGetPi(prhs[0]);
Kx = (double*)mxGetData(prhs[1]);     
Ky = (double*)mxGetData(prhs[2]);         
Kern = (double*)mxGetData(prhs[3]);     
temp = (int*)mxGetData(prhs[4]); iKern = temp[0];
temp = (int*)mxGetData(prhs[5]); chW = temp[0];
temp = (int*)mxGetData(prhs[6]); CrtDatSz = temp[0];
temp = (int*)mxGetData(prhs[7]); devicenum = temp[0];
// status = prhs[8];

const mwSize *temp2;
int DatLen,nVols,KernSz;
temp2 = mxGetDimensions(prhs[0]);
DatLen = (int)temp2[0];
nVols = (int)temp2[1];
temp2 = mxGetDimensions(prhs[3]);
KernSz = (int)temp2[0];

//-------------------------------------
// Output                       
//-------------------------------------
double *CrtDatR,*CrtDatI;
mwSize *Tst;
char *Error;
mwSize errorlen = 200;
mwSize Dat_Dim[3];
mwSize Tst_Dim[2];

if (nlhs != 3) mexErrMsgTxt("Should have 3 outputs");
Dat_Dim[0] = CrtDatSz; 
Dat_Dim[1] = CrtDatSz;
Dat_Dim[2] = nVols;
plhs[0] = mxCreateNumericArray(3,Dat_Dim,mxDOUBLE_CLASS,mxCOMPLEX);
CrtDatR = mxGetPr(plhs[0]); 
CrtDatI = mxGetPi(plhs[0]); 
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
mxSetProperty(prhs[8],0,"String",mxCreateString(Status));
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
// Allocate Space on Host                 
//-------------------------------------
double *CrtDatC = (double*)mxMalloc(sizeof(double)*2*CrtDatSz*CrtDatSz*nVols);
mwSize *HSampDatR,*HSampDatI,*HCrtDatC,*HKx,*HKy,*HKern;
mwSize addreslen = 1;
HSampDatR = (mwSize*)mxCalloc(addreslen,sizeof(mwSize));
HSampDatI = (mwSize*)mxCalloc(addreslen,sizeof(mwSize));
HCrtDatC = (mwSize*)mxCalloc(addreslen,sizeof(mwSize));
HKx = (mwSize*)mxCalloc(addreslen,sizeof(mwSize));
HKy = (mwSize*)mxCalloc(addreslen,sizeof(mwSize));
HKern = (mwSize*)mxCalloc(addreslen,sizeof(mwSize));

//-------------------------------------
// Display                  
//-------------------------------------	
sprintf(Status,"CUDA Memory Allocate");
mxSetProperty(prhs[8],0,"String",mxCreateString(Status));
mexEvalString("drawnow");

//-------------------------------------
// Allocate Space on Device                
//-------------------------------------
ArrMSAllocDbl(HSampDatR,DatLen,nVols,Tst,Error);
if (strcmp(Error,"no error") != 0) {
	plhs[2] = mxCreateString(Error); return;
	}
ArrMSAllocDbl(HSampDatI,DatLen,nVols,Tst,Error);
if (strcmp(Error,"no error") != 0) {
	plhs[2] = mxCreateString(Error); return;
	}	
Mat2DMSAllocDblC(HCrtDatC,CrtDatSz,nVols,Tst,Error);
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
mxSetProperty(prhs[8],0,"String",mxCreateString(Status));
mexEvalString("drawnow");
	
//-------------------------------------
// Load / Initialize                    
//-------------------------------------
Mat2DMSInitDblC(HCrtDatC,CrtDatSz,nVols,Error);
if (strcmp(Error,"no error") != 0) {
	plhs[2] = mxCreateString(Error); return;
	}
ArrMSLoadDbl(SampDatR,HSampDatR,DatLen,nVols,Error);
if (strcmp(Error,"no error") != 0) {
	plhs[2] = mxCreateString(Error); return;
	}	
ArrMSLoadDbl(SampDatI,HSampDatI,DatLen,nVols,Error);
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
for (int n=0; n<nVols; n++){	
	sprintf(Status,"Volume Number: %i",n);
	mxSetProperty(prhs[8],0,"String",mxCreateString(Status));
	mexEvalString("drawnow");
	ConvSamp2GridCD2Dms(HSampDatR,HSampDatI,HCrtDatC,HKx,HKy,HKern,CrtDatSz,DatLen,KernSz,iKern,chW,n,Error);
	if (strcmp(Error,"no error") != 0) {
		plhs[2] = mxCreateString(Error); return;
		}
	}
	
//-------------------------------------
// Return Data                    
//-------------------------------------
Mat2DMSReturnDblC(CrtDatC,HCrtDatC,CrtDatSz,nVols,Error);
if (strcmp(Error,"no error") != 0) {
	plhs[2] = mxCreateString(Error); return;
	}
for (int i=0; i<CrtDatSz*CrtDatSz*nVols; i++) {
    CrtDatR[i] = CrtDatC[2*i];
    CrtDatI[i] = CrtDatC[2*i+1];
    }
	
//-------------------------------------
// Free Device Memory                 
//------------------------------------- 	
ArrMSFreeDbl(HSampDatR,Error);
if (strcmp(Error,"no error") != 0) {
	plhs[2] = mxCreateString(Error); return;
	}
ArrMSFreeDbl(HSampDatI,Error);
if (strcmp(Error,"no error") != 0) {
	plhs[2] = mxCreateString(Error); return;
	}	
Mat2DMSFreeDblC(HCrtDatC,Error);
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
mxFree(CrtDatC);
mxFree(HSampDatR);
mxFree(HSampDatI);
mxFree(HCrtDatC);
mxFree(HKx);
mxFree(HKy);
mxFree(HKern);

}

