//=========================================================
//
//========================================================

#include "mex.h"
//#include "math.h"
#include "string.h"

extern "C" void FindYngh(float* Ky, int* Kxinds, int* Kyinds, int* Kxindlens, int* Kyindlens,
                         int npro, int nproj, int maxkxindlen, int maxkyindlen, float W, int* Dpts, int Dptlen, int* Tst, char* Error, int memtst);


void mexFunction(int nlhs, mxArray *plhs[], 
    int nrhs, const mxArray *prhs[])
{

// In
float *Ky,W;
int *Kxinds,*Kxindlens,npro,nproj,maxkxindlen,maxkyindlen,*Dpts,Dptlen,memtst;
// Out
char Error[100] = {0};
int *Tst,*Kyinds,*Kyindlens;
// Internal
float *tempFloat;
int *tempInt,dim[2],tdim[2];
const int *tempCInt;

/*------------------------------*/
/* Input                        */
/*------------------------------*/
if (nrhs != 10) mexErrMsgTxt("Should have 10 inputs");
Ky = (float*)mxGetData(prhs[0]);    
Kxinds = (int*)mxGetData(prhs[1]);       
Kxindlens = (int*)mxGetData(prhs[2]); 
tempInt = (int*)mxGetData(prhs[3]); maxkxindlen = tempInt[0];
tempInt = (int*)mxGetData(prhs[4]); npro = tempInt[0];
tempInt = (int*)mxGetData(prhs[5]); nproj = tempInt[0];
tempInt = (int*)mxGetData(prhs[6]); maxkyindlen = tempInt[0];
tempFloat = (float*)mxGetData(prhs[7]); W = tempFloat[0];
Dpts = (int*)mxGetData(prhs[8]);     
tempInt = (int*)mxGetData(prhs[9]); memtst = tempInt[0];

tempCInt = mxGetDimensions(prhs[8]);
Dptlen = tempCInt[1];

/*------------------------------*/
/* Output                       */
/*------------------------------*/
if (nlhs != 4) mexErrMsgTxt("Should have 4 output");
dim[0] = maxkyindlen; 
dim[1] = Dptlen;
plhs[0] = mxCreateNumericArray(2,dim,mxINT32_CLASS,mxREAL);
Kyinds = (int*)mxGetData(plhs[0]); 

dim[0] = 1; 
dim[1] = Dptlen;
plhs[1] = mxCreateNumericArray(2,dim,mxINT32_CLASS,mxREAL);
Kyindlens = (int*)mxGetData(plhs[1]); 

tdim[0] = 1; 
tdim[1] = 16; 
plhs[2] = mxCreateNumericArray(2,tdim,mxINT32_CLASS,mxREAL);
Tst = (int*)mxGetData(plhs[2]);

//Tst[0] = npro;
//Tst[1] = nproj;
//Tst[2] = maxkxindlen;
//Tst[3] = maxkyindlen;
//Tst[4] = (int)W;
//Tst[5] = Dptlen;

/*------------------------------*/
/* Workings                     */
/*------------------------------*/
FindYngh(Ky,Kxinds,Kyinds,Kxindlens,Kyindlens,npro,nproj,maxkxindlen,maxkyindlen,W,Dpts,Dptlen,Tst,Error,memtst);

plhs[3] = mxCreateString(Error);

}

