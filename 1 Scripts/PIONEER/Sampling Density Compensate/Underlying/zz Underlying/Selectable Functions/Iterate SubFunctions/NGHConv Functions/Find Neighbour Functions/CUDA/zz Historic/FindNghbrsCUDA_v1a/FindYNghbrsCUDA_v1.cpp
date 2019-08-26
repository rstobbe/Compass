//=========================================================
//
//========================================================

#include "mex.h"
//#include "math.h"
#include "string.h"

extern "C" void FindYngh(float* Ky, float* Kxinds, float* Kyinds, float* Kxindlens, float* Kyindlens,
                         int npro, int nproj, int maxkxindlen, int maykyindlen, float W, int dpts, int* Tst, char* Error);


void mexFunction(int nlhs, mxArray *plhs[], 
    int nrhs, const mxArray *prhs[])
{

// In
float *In0,*In1,*In2,*In3,*In4,*In5,*In6,*In7,*In8;
float *Ky,*Kxinds,*Kxindlens;
int npro,nproj,maxkxindlen,maxkyindlen,dpts;
float W;
// Out
float *Kyinds,*Kyindlens;
char Error[100] = {0};
int *Tst;
// Internal
int dim[2];
int tdim[2];

/*------------------------------*/
/* Input                        */
/*------------------------------*/
if (nrhs != 9) mexErrMsgTxt("Should have 9 inputs");
In0 = (float*)mxGetData(prhs[0]);    
Ky = In0;
In1 = (float*)mxGetData(prhs[1]);       
Kxinds = In1;
In2 = (float*)mxGetData(prhs[2]);     
npro = int(In2[0]);
In3 = (float*)mxGetData(prhs[3]);     
nproj = int(In3[0]);
In4 = (float*)mxGetData(prhs[4]);     
maxkxindlen = int(In4[0]);
In5 = (float*)mxGetData(prhs[5]);     
maxkyindlen = int(In5[0]);
In6 = (float*)mxGetData(prhs[6]);       
Kxindlens = In6;
In7 = (float*)mxGetData(prhs[7]);     
W = In7[0];
In8 = (float*)mxGetData(prhs[8]);     
dpts = int(In8[0]);

/*------------------------------*/
/* Output                       */
/*------------------------------*/
if (nlhs != 4) mexErrMsgTxt("Should have 4 output");
dim[0] = maxkyindlen; 
dim[1] = dpts;
plhs[0] = mxCreateNumericArray(2,dim,mxSINGLE_CLASS,mxREAL);
Kyinds = (float*)mxGetData(plhs[0]); 

dim[0] = 1; 
dim[1] = dpts;
plhs[1] = mxCreateNumericArray(2,dim,mxSINGLE_CLASS,mxREAL);
Kyindlens = (float*)mxGetData(plhs[1]); 

tdim[0] = 1; 
tdim[1] = 16; 
plhs[2] = mxCreateNumericArray(2,tdim,mxINT32_CLASS,mxREAL);
Tst = (int*)mxGetData(plhs[2]);

/*------------------------------*/
/* Workings                     */
/*------------------------------*/
FindYngh(Ky,Kxinds,Kyinds,Kxindlens,Kyindlens,npro,nproj,maxkxindlen,maxkyindlen,W,dpts,Tst,Error);

plhs[3] = mxCreateString(Error);

}

