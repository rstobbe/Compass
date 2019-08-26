///==========================================================
/// (v1a)
///		
///==========================================================

#include "mex.h"
#include "matrix.h"
#include "math.h"
#include "string.h"

extern "C" void FFT3D(float* ImC, float* kDatC, int MatSz, int* Tst, char* Error);

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{

//-------------------------------------
// Input                        
//-------------------------------------
float *ImR,*ImI;

if (nrhs != 1) mexErrMsgTxt("Should have 1 inputs");
ImR = (float*)mxGetData(prhs[0]);  
ImI = (float*)mxGetImagData(prhs[0]);  

const mwSize *temp;
int MatSz;
temp = mxGetDimensions(prhs[0]);
MatSz = temp[0];

//-------------------------------------
// Output                       
//-------------------------------------
float *kDatR,*kDatI;
int *Tst;
char *Error;
int errorlen = 200;
int Dat_Dim[3];
int Tst_Dim[2];

if (nlhs != 3) mexErrMsgTxt("Should have 3 outputs");
Dat_Dim[0] = MatSz; 
Dat_Dim[1] = MatSz;
Dat_Dim[2] = MatSz;  
plhs[0] = mxCreateNumericArray(3,Dat_Dim,mxSINGLE_CLASS,mxCOMPLEX);
kDatR = (float*)mxGetData(plhs[0]);
kDatI = (float*)mxGetImagData(plhs[0]);
Tst_Dim[0] = 1; 
Tst_Dim[1] = 20; 
plhs[1] = mxCreateNumericArray(2,Tst_Dim,mxINT32_CLASS,mxREAL);
Tst = (int*)mxGetData(plhs[1]);
Error = (char*)mxCalloc(errorlen,sizeof(char));
strcpy(Error,"no error");

//-------------------------------------
// Create Interleaved Arrays                     
//-------------------------------------
float *ImC = (float*)mxMalloc(sizeof(float)*2*MatSz*MatSz*MatSz);
float *kDatC = (float*)mxMalloc(sizeof(float)*2*MatSz*MatSz*MatSz);
for (int i=0; i<MatSz*MatSz*MatSz; i++) {
    ImC[2*i] = ImR[i];
    ImC[2*i+1] = ImI[i];
    }

//-------------------------------------
// Workings                      
//------------------------------------- 
FFT3D(ImC,kDatC,MatSz,Tst,Error);

//-------------------------------------
// Return Interleaved Array                     
//-------------------------------------
for (int i=0; i<MatSz*MatSz*MatSz; i++) {
    kDatR[i] = kDatC[2*i];
    kDatI[i] = kDatC[2*i+1];
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
mxFree(kDatC);

}

