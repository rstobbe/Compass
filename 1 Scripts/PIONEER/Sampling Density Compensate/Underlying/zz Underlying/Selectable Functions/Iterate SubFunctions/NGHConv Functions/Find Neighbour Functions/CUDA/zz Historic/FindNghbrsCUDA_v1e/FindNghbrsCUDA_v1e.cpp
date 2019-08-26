//========================================================
// 
//========================================================

#include "mex.h"
#include "math.h"
#include "string.h"

extern "C" void FindNgh(float* Kx, float* Ky, float* Kz, int* Radinds, int* NGH, int* NGHlens,
                        int npro, int nproj, float W, int MaxXNghbrs, int MaxYNghbrs, int MaxZNghbrs, int* Dpts, int Dptlen0,
                        char* ErrString, int* TstIn, int* TstOut);


//========================================================
//
//========================================================

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[]){

// Internal
float *tempFloat;
int *tempInt,dim[2];

//-------------------------------------
// Input                        
//-------------------------------------
float *Kx,*Ky,*Kz,W;
int *Radinds,npro,nproj,MaxXNghbrs,MaxYNghbrs,MaxZNghbrs,*Dpts,Dptlen0,*TstIn;

if (nrhs != 13) mexErrMsgTxt("Should have 13 inputs");
Kx = (float*)mxGetData(prhs[0]);    
Ky = (float*)mxGetData(prhs[1]); 
Kz = (float*)mxGetData(prhs[2]);   
Radinds = (int*)mxGetData(prhs[3]);  
tempInt = (int*)mxGetData(prhs[4]); npro = tempInt[0];
tempInt = (int*)mxGetData(prhs[5]); nproj = tempInt[0];
tempFloat = (float*)mxGetData(prhs[6]); W = tempFloat[0];   
tempInt = (int*)mxGetData(prhs[7]); MaxXNghbrs = tempInt[0];
tempInt = (int*)mxGetData(prhs[8]); MaxYNghbrs = tempInt[0];
tempInt = (int*)mxGetData(prhs[9]); MaxZNghbrs = tempInt[0];
Dpts = (int*)mxGetData(prhs[10]);
tempInt = (int*)mxGetData(prhs[11]); Dptlen0 = tempInt[0];
TstIn = (int*)mxGetData(prhs[12]);

//-------------------------------------
// Output Variables                      
//-------------------------------------
if (nlhs != 4) mexErrMsgTxt("Should have 4 outputs");
int *NGH;
dim[0] = MaxZNghbrs; 
dim[1] = Dptlen0; 
plhs[0] = mxCreateNumericArray(2,dim,mxINT32_CLASS,mxREAL);
NGH = (int*)mxGetData(plhs[0]);

int *NGHlens;
dim[0] = 1; 
dim[1] = Dptlen0; 
plhs[1] = mxCreateNumericArray(2,dim,mxINT32_CLASS,mxREAL);
NGHlens = (int*)mxGetData(plhs[1]);

int *TstOut;
dim[0] = 1; 
dim[1] = 16; 
plhs[2] = mxCreateNumericArray(2,dim,mxINT32_CLASS,mxREAL);
TstOut = (int*)mxGetData(plhs[2]);

char ErrString[150];
strcpy(ErrString,"");

//-------------------------------------------
// Find Neighbours
//-------------------------------------------
FindNgh(Kx,Ky,Kz,Radinds,NGH,NGHlens,npro,nproj,W,MaxXNghbrs,MaxYNghbrs,MaxZNghbrs,Dpts,Dptlen0,ErrString,TstIn,TstOut);

//-------------------------------------------
// Output
//-------------------------------------------
plhs[3] = mxCreateString(ErrString);

}

