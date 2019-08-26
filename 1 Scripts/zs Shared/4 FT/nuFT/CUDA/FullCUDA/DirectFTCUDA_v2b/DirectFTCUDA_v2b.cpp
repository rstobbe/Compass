///==========================================================
/// (v2b)
///		- no change from (v1c)
///==========================================================

#include "mex.h"
#include "matrix.h"
#include "math.h"
#include "string.h"

extern "C" void DirectFT(float* Im, float* kLoc, float* kValR, float* kValI, int X, int Y, int Z, int kLen, int* Tst, char* Error);

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{

//-------------------------------------
// Input                        
//-------------------------------------
float *Im,*kLoc;
if (nrhs != 2) mexErrMsgTxt("Should have 2 inputs");
Im = (float*)mxGetData(prhs[0]);     
kLoc = (float*)mxGetData(prhs[1]);     

const mwSize *kArr_Dim0;
const mwSize *Im_Dim;
int kArr_Dim[2];
Im_Dim = mxGetDimensions(prhs[0]);
kArr_Dim0 = mxGetDimensions(prhs[1]);
kArr_Dim[0] = kArr_Dim0[0];
kArr_Dim[1] = 1;

//-------------------------------------
// Output                      
//-------------------------------------
float *kValR,*kValI;
int *Tst;
char *Error;
int errorlen = 200;
int Tst_Dim[2];

if (nlhs != 3) mexErrMsgTxt("Should have 3 outputs");
plhs[0] = mxCreateNumericArray(2,kArr_Dim,mxSINGLE_CLASS,mxCOMPLEX);
kValR = (float*)mxGetPr(plhs[0]); 
kValI = (float*)mxGetPi(plhs[0]); 
Tst_Dim[0] = 1; 
Tst_Dim[1] = 20; 
plhs[1] = mxCreateNumericArray(2,Tst_Dim,mxINT32_CLASS,mxREAL);
Tst = (int*)mxGetData(plhs[1]);
Error = (char*)mxCalloc(errorlen,sizeof(char));
plhs[2] = mxCreateString(Error);
 
//-------------------------------------
//  Workings                      
//------------------------------------- 
int X,Y,Z,kLen;

X = Im_Dim[0];
Y = Im_Dim[1];
Z = Im_Dim[2];
kLen = kArr_Dim[0];
DirectFT(Im,kLoc,kValR,kValI,X,Y,Z,kLen,Tst,Error);

//-------------------------------------
//  Free Memory                   
//------------------------------------- 
mxFree(Error);

}

