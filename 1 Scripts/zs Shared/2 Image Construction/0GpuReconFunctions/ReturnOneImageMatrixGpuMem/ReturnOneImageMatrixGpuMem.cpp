///==========================================================
/// (v1a)
///		
///==========================================================

#include "mex.h"
#include "matrix.h"
#include "math.h"
#include "string.h"
#include "CUDA_GeneralSgl_v11f.h"

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, mxArray *prhs[])
{

//-------------------------------------
// Input                        
//-------------------------------------
if (nrhs != 3) mexErrMsgTxt("Should have 3 inputs");
mwSize *GpuNum,*HImageMatrix,*ImageMatrixMemDims;

GpuNum = mxGetUint64s(prhs[0]);
HImageMatrix = mxGetUint64s(prhs[1]);
ImageMatrixMemDims = mxGetUint64s(prhs[2]);

//-------------------------------------
// Output                       
//-------------------------------------
if (nlhs != 2) mexErrMsgTxt("Should have 2 outputs");

mwSize ArrDim[3];
ArrDim[0] = ImageMatrixMemDims[0]; 
ArrDim[1] = ImageMatrixMemDims[1]; 
ArrDim[2] = ImageMatrixMemDims[2]; 
plhs[0] = mxCreateNumericArray(3,ArrDim,mxSINGLE_CLASS,mxCOMPLEX);
float *ImageMatrix;
ImageMatrix = (float*)mxGetComplexSingles(plhs[0]);

char *Error;
mwSize errorlen = 200;
Error = (char*)mxCalloc(errorlen,sizeof(char));
strcpy(Error,"no error");

//-------------------------------------
// Return Memory                
//-------------------------------------
mwSize *ArrLen;
ArrLen = (mwSize*)mxCalloc(1,sizeof(mwSize));
ArrLen[0] = ImageMatrixMemDims[0]*ImageMatrixMemDims[1]*ImageMatrixMemDims[2];
ArrLen[1] = 0;
ArrReturnSglOneC(GpuNum,ImageMatrix,HImageMatrix,ArrLen,Error);

//-------------------------------------
// Return Error                    
//------------------------------------- 
plhs[1] = mxCreateString(Error);
mxFree(Error);
mxFree(ArrLen);

}
