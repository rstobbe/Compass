///==========================================================
/// (v1a)
///		
///==========================================================

#include "mex.h"
#include "matrix.h"
#include "math.h"
#include "string.h"
#include "CUDA_GeneralSgl_v1d.h"

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, mxArray *prhs[])
{

//-------------------------------------
// Input                        
//-------------------------------------
if (nrhs != 2) mexErrMsgTxt("Should have 2 inputs");
mwSize *GpuNum;
float *InvFilt;
GpuNum = mxGetUint64s(prhs[0]);
InvFilt = (float*)mxGetSingles(prhs[1]);

//-------------------------------------
// Output                       
//-------------------------------------
if (nlhs != 2) mexErrMsgTxt("Should have 2 outputs");
mwSize ArrDim[2];

mwSize *HInvFilt;
ArrDim[0] = 1; 
ArrDim[1] = GpuNum[0]; 
plhs[0] = mxCreateNumericArray(2,ArrDim,mxUINT64_CLASS,mxREAL);
HInvFilt = mxGetUint64s(plhs[0]);

char *Error;
mwSize errorlen = 200;
Error = (char*)mxCalloc(errorlen,sizeof(char));
strcpy(Error,"no error");

//-------------------------------------
// Get Dimensions           
//-------------------------------------
const mwSize *temp;
temp = mxGetDimensions(prhs[1]);
mwSize *ArrLen;
ArrLen = (mwSize*)mxCalloc(1,sizeof(mwSize));
ArrLen[0] = temp[0]*temp[1]*temp[2];

//-------------------------------------
// Allocate Memory                
//-------------------------------------
ArrAllocSgl(GpuNum,HInvFilt,ArrLen,Error);
if (strcmp(Error,"no error") != 0) {
	plhs[1] = mxCreateString(Error); return;
	}

//-------------------------------------
// Load InvFilt            
//-------------------------------------
ArrLoadSglSync(GpuNum,InvFilt,HInvFilt,ArrLen,Error);
if (strcmp(Error,"no error") != 0) {
	plhs[1] = mxCreateString(Error); return;
	}

//-------------------------------------
// Return Error                    
//------------------------------------- 
plhs[1] = mxCreateString(Error);

}
