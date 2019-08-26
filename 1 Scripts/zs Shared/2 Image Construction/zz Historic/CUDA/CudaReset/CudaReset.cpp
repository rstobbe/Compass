///==========================================================
/// Run from Command-Line
///			
///==========================================================

#include "mex.h"
#include "matrix.h"
#include "math.h"
#include "string.h"
#include "CUDA_DeviceManage_v1a.h"

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, mxArray *prhs[])
{

//-------------------------------------
// Input                        
//-------------------------------------
int devicenum;
int *temp;
if (nrhs != 1) mexErrMsgTxt("Should have 1 input");
temp = (int*)mxGetData(prhs[0]); devicenum = temp[0];

//-------------------------------------
// Output                       
//-------------------------------------
char *Error;
mwSize errorlen = 200;
Error = (char*)mxCalloc(errorlen,sizeof(char));
strcpy(Error,"no error");

//-------------------------------------
// Select / Reset Device                  
//-------------------------------------
CUDAselect(devicenum,Error);
if (strcmp(Error,"no error") != 0) {
	plhs[0] = mxCreateString(Error); return;
	}
CUDAreset(Error);
if (strcmp(Error,"no error") != 0) {
	plhs[0] = mxCreateString(Error); return;
	}

plhs[0] = mxCreateString(Error);
//-------------------------------------
// Free Memory                   
//------------------------------------- 
mxFree(Error);

}

