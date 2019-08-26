//========================================================
//
//========================================================

#include "mex.h"
#include "string.h"

struct cudastruct {
    const char *Name;
    int Gblmem;
};

extern "C" void FindXngh(float* Kx, int* Radinds, int* Kxinds, int* Kxindlens,
                         int npro, int nproj, int maxkxindlen, float W, int* Dpts, int Dptlen, 
                         int* Tst, char* Error, cudastruct* CUDA, int memtst);


//========================================================
//
//========================================================

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[]){

// In
float *Kx,W;
int *Radinds,npro,nproj,maxkxindlen,*Dpts,Dptlen,memtst;
// Out
char Error[100] = {0};
int *Tst,*Kxinds,*Kxindlens;
cudastruct CUDA;
// Internal
float *tempFloat;
int *tempInt,dim[2];
const int *tempCInt;
const char *fnames[] = {"Name", "Gblmem"};
int nfields = 2;
mxArray *cudadataptr;
int *cudadataval;

/*------------------------------*/
/* Input                        */
/*------------------------------*/
if (nrhs != 8) mexErrMsgTxt("Should have 8 inputs");
Kx = (float*)mxGetData(prhs[0]);    
Radinds = (int*)mxGetData(prhs[1]);       
tempInt = (int*)mxGetData(prhs[2]); npro = tempInt[0];
tempInt = (int*)mxGetData(prhs[3]); nproj = tempInt[0];
tempInt = (int*)mxGetData(prhs[4]); maxkxindlen = tempInt[0];
tempFloat = (float*)mxGetData(prhs[5]); W = tempFloat[0];
Dpts = (int*)mxGetData(prhs[6]);
tempInt = (int*)mxGetData(prhs[7]); memtst = tempInt[0];

tempCInt = mxGetDimensions(prhs[6]);
Dptlen = tempCInt[1];

/*------------------------------*/
/* Output                       */
/*------------------------------*/
if (nlhs != 5) mexErrMsgTxt("Should have 5 output");
dim[0] = maxkxindlen; 
dim[1] = Dptlen;
plhs[0] = mxCreateNumericArray(2,dim,mxINT32_CLASS,mxREAL);
Kxinds = (int*)mxGetData(plhs[0]); 

dim[0] = 1; 
dim[1] = Dptlen;
plhs[1] = mxCreateNumericArray(2,dim,mxINT32_CLASS,mxREAL);
Kxindlens = (int*)mxGetData(plhs[1]); 

dim[0] = 1; 
dim[1] = 16; 
plhs[2] = mxCreateNumericArray(2,dim,mxINT32_CLASS,mxREAL);
Tst = (int*)mxGetData(plhs[2]);

plhs[3] = mxCreateStructMatrix(1, 1, nfields, fnames);
CUDA.Name = "";
CUDA.Gblmem = 0;

//Tst[0] = npro;
//Tst[1] = nproj;
//Tst[2] = maxkxindlen;
//Tst[3] = (int)W;
//Tst[4] = Dptlen;

/*------------------------------*/
/* Workings                     */
/*------------------------------*/
FindXngh(Kx,Radinds,Kxinds,Kxindlens,npro,nproj,maxkxindlen,W,Dpts,Dptlen,Tst,Error,&CUDA,memtst);

/*------------------------------*/
/* Update                       */
/*------------------------------*/
dim[0] = 1; 
dim[1] = 1; 
mxSetField(plhs[3],0,"Name",mxCreateString(CUDA.Name));
cudadataptr = mxCreateNumericArray(2,dim,mxINT32_CLASS,mxREAL);
cudadataval = (int*)mxGetData(cudadataptr);
*cudadataval = CUDA.Gblmem;
mxSetField(plhs[3],0,"Gblmem",cudadataptr);

plhs[4] = mxCreateString(Error);

}

