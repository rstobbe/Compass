///==========================================================
/// (v4f)
///			R2014b fix-up (mexSet no longer useful)
///==========================================================

#include "mex.h"
#include "matrix.h"
#include "math.h"
#include "string.h"
#include "CUDA_2DGeneralD_v1a.h"
#include "CUDA_FFTDoubles2D_v1a.h"
#include "CUDA_FFTShiftD2D_v1c.h"
#include "CUDA_PhaseAddOffResD_v2a.h"
#include "CUDA_ConvGrid2SampSplitCD2D_v1c.h"

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, mxArray *prhs[])
{

//-------------------------------------
// Input                        
//-------------------------------------
double *ImR,*ImI,*OffRes,*T,*Kx,*Ky,*Kern;
int *tempipt;
int iKern,chW;

if (nrhs != 9) mexErrMsgTxt("Should have 9 inputs");
ImR = mxGetPr(prhs[0]);  
ImI = mxGetPi(prhs[0]);  
OffRes = (double*)mxGetData(prhs[1]);  
T = (double*)mxGetData(prhs[2]);
Kx = (double*)mxGetData(prhs[3]);     
Ky = (double*)mxGetData(prhs[4]);      
Kern = (double*)mxGetData(prhs[5]);     
tempipt = (int*)mxGetData(prhs[6]); iKern = tempipt[0];
tempipt = (int*)mxGetData(prhs[7]); chW = tempipt[0];
//Status = prhs[8]

const mwSize *temp;
int nproj,npro,DatLen,KernSz,ImSz;
temp = mxGetDimensions(prhs[0]);
ImSz = (int)temp[0];
temp = mxGetDimensions(prhs[3]);
nproj = (int)temp[0];
npro = (int)temp[1];
DatLen = npro*nproj;
temp = mxGetDimensions(prhs[5]);
KernSz = (int)temp[0];

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
int Imlen = 2*ImSz*ImSz;
double *ImC = (double*)mxMalloc(sizeof(double)*Imlen);
double *OffC = (double*)mxMalloc(sizeof(double)*Imlen);

//-------------------------------------
// Allocate Space on Device                   
//-------------------------------------
char Status[150];
sprintf(Status,"CUDA Memory Allocate");
mxSetProperty(prhs[8],0,"String",mxCreateString(Status));
mexEvalString("drawnow");

mwSize *HImC0, *HImC1, *HOffC, *HkDatC, *HkDatCshft, *HKx, *HKy, *HKern, *HSampDatR, *HSampDatI;
mwSize addreslen = 1;
HImC0 = (mwSize*)mxCalloc(addreslen,sizeof(mwSize));
HImC1 = (mwSize*)mxCalloc(addreslen,sizeof(mwSize));
HOffC = (mwSize*)mxCalloc(addreslen,sizeof(mwSize));
HkDatC = (mwSize*)mxCalloc(addreslen,sizeof(mwSize));
HkDatCshft = (mwSize*)mxCalloc(addreslen,sizeof(mwSize));
HKx = (mwSize*)mxCalloc(addreslen,sizeof(mwSize));
HKy = (mwSize*)mxCalloc(addreslen,sizeof(mwSize));
HKern = (mwSize*)mxCalloc(addreslen,sizeof(mwSize));
HSampDatR = (mwSize*)mxCalloc(addreslen,sizeof(mwSize));
HSampDatI = (mwSize*)mxCalloc(addreslen,sizeof(mwSize));
Mat2DAllocDblC(HImC0,ImSz,Tst,Error);
if (strcmp(Error,"no error") != 0) {
	plhs[2] = mxCreateString(Error); return;
	}
Mat2DAllocDblC(HImC1,ImSz,Tst,Error);
if (strcmp(Error,"no error") != 0) {
	plhs[2] = mxCreateString(Error); return;
	}
Mat2DAllocDblC(HOffC,ImSz,Tst,Error);
if (strcmp(Error,"no error") != 0) {
	plhs[2] = mxCreateString(Error); return;
	}		
Mat2DAllocDblC(HkDatC,ImSz,Tst,Error);
if (strcmp(Error,"no error") != 0) {
	plhs[2] = mxCreateString(Error); return;
	}
Mat2DAllocDblC(HkDatCshft,ImSz,Tst,Error);
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
mxSetProperty(prhs[8],0,"String",mxCreateString(Status));
mexEvalString("drawnow");

for (int i=0; i<ImSz*ImSz; i++) {				// complex data interleaved on Cuda
    ImC[2*i] = ImR[i];
    ImC[2*i+1] = ImI[i];
	OffC[2*i] = OffRes[i];
	OffC[2*i+1] = OffRes[i];	
    }
Mat2DLoadDblC(ImC,HImC0,ImSz,Error);
if (strcmp(Error,"no error") != 0) {
	plhs[2] = mxCreateString(Error); return;
	}	
Mat2DInitDblC(HImC1,ImSz,Error);
if (strcmp(Error,"no error") != 0) {
	plhs[2] = mxCreateString(Error); return;
	}
Mat2DLoadDblC(OffC,HOffC,ImSz,Error);
if (strcmp(Error,"no error") != 0) {
	plhs[2] = mxCreateString(Error); return;
	}	
Mat2DInitDblC(HkDatC,ImSz,Error);
if (strcmp(Error,"no error") != 0) {
	plhs[2] = mxCreateString(Error); return;
	}
Mat2DInitDblC(HkDatCshft,ImSz,Error);
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
ArrInitDbl(HSampDatR,DatLen,Error);
if (strcmp(Error,"no error") != 0) {
	plhs[2] = mxCreateString(Error); return;
	}
ArrInitDbl(HSampDatI,DatLen,Error);
if (strcmp(Error,"no error") != 0) {
	plhs[2] = mxCreateString(Error); return;
	}

//-------------------------------------
// Setup FFT3D                
//------------------------------------- 
unsigned int *FFTplan;
FFTplan = (unsigned int*)mxCalloc(addreslen,sizeof(unsigned int));
FFT2Dsetup(FFTplan,ImSz,Error);
if (strcmp(Error,"no error") != 0) {
	plhs[2] = mxCreateString(Error); return;
	}
Tst[8] = (mwSize)*FFTplan;	

///==============================================
/// Perform Sampling               
///==============================================
int SampDatAdr = 0;
for (int n=0; n<npro; n++){	
    
    sprintf(Status,"Data Point: %i",SampDatAdr);
    mxSetProperty(prhs[8],0,"String",mxCreateString(Status));
    mexEvalString("drawnow");

	//-------------------------------------
	// Add Image Phase             
	PhaseAddOffRes(HImC0,HOffC,HImC1,T[n],Imlen,Error);
	if (strcmp(Error,"no error") != 0) {
		plhs[2] = mxCreateString(Error); return;
		}	
	//-------------------------------------
	// Perform FFT3D               
	FFT2D(HImC1,HkDatC,FFTplan,Error);
	if (strcmp(Error,"no error") != 0) {
		plhs[2] = mxCreateString(Error); return;
		}	
	//-------------------------------------
	// Perform FFTshift               
	FFTShift2D(HkDatC,HkDatCshft,ImSz,Error);
	if (strcmp(Error,"no error") != 0) {
		plhs[2] = mxCreateString(Error); return;
		}
	//-------------------------------------
	// Perform Convolution        	
	ConvGrid2SampSplitCD2D(HSampDatR,HSampDatI,HkDatCshft,HKx,HKy,HKern,ImSz,nproj,KernSz,iKern,chW,SampDatAdr,Error);
	if (strcmp(Error,"no error") != 0) {
		plhs[2] = mxCreateString(Error); return;
		}
	SampDatAdr += nproj;
	}

//-------------------------------------
// Teardown FFT3D               
//------------------------------------- 
FFT2Dteardown(FFTplan);

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
Mat2DFreeDbl(HImC0,Error);
if (strcmp(Error,"no error") != 0) {
	plhs[2] = mxCreateString(Error); return;
	}
Mat2DFreeDbl(HImC1,Error);
if (strcmp(Error,"no error") != 0) {
	plhs[2] = mxCreateString(Error); return;
	}
Mat2DFreeDbl(HOffC,Error);
if (strcmp(Error,"no error") != 0) {
	plhs[2] = mxCreateString(Error); return;
	}	
Mat2DFreeDbl(HkDatC,Error);
if (strcmp(Error,"no error") != 0) {
	plhs[2] = mxCreateString(Error); return;
	}
Mat2DFreeDbl(HkDatCshft,Error);
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
mxFree(ImC);
mxFree(OffC);
mxFree(HImC0);
mxFree(HImC1);
mxFree(HOffC);
mxFree(HkDatC);
mxFree(HkDatCshft);
mxFree(HKx);
mxFree(HKy);
mxFree(HKern);
mxFree(HSampDatR);
mxFree(HSampDatI);

}
