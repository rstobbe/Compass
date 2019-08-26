//========================================================
// 
//========================================================

#include "mex.h"
#include "string.h"

struct cudastruct {
    const char *Name;
    int Gblmem;
};

extern "C" void QueryReset(cudastruct* CUDA, char* ErrString);


//========================================================
//
//========================================================

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[]){

int dim[2];    
//-------------------------------------
// Input                        
//-------------------------------------
if (nrhs != 0) mexErrMsgTxt("Should have 0 inputs");

//-------------------------------------
// Output Variables                      
//-------------------------------------
if (nlhs != 2) mexErrMsgTxt("Should have 2 outputs");

cudastruct CUDA;
CUDA.Name = "";
CUDA.Gblmem = 0;
const char *fnames[] = {"Name", "Gblmem"};
int nfields = 2;
plhs[0] = mxCreateStructMatrix(1, 1, nfields, fnames);
dim[0] = 1; 
dim[1] = 1; 
mxArray *cudaGblMemptr = mxCreateNumericArray(2,dim,mxINT32_CLASS,mxREAL);
int *cudaGblMemval = (int*)mxGetData(cudaGblMemptr);

char Error[150];
strcpy(Error,"");

//-------------------------------------
// Reset and Query Device                 
//-------------------------------------
QueryReset(&CUDA,Error);
mxSetField(plhs[0],0,"Name",mxCreateString(CUDA.Name));             // for some reason this line needs to come before the one below or CUDA.Name gets messed up...
*cudaGblMemval = CUDA.Gblmem;
mxSetField(plhs[0],0,"Gblmem",cudaGblMemptr);
//mexSet(Stathands[0],"String",mxCreateString(CUDA.Name));
//sprintf(Status,"Total Memory: %i  Free Memory: %i",TstOut[0],TstOut[1]);
//mexSet(Stathands[1],"String",mxCreateString(Status));

//-------------------------------------
// Output                       
//-------------------------------------
plhs[1] = mxCreateString(Error);

}

