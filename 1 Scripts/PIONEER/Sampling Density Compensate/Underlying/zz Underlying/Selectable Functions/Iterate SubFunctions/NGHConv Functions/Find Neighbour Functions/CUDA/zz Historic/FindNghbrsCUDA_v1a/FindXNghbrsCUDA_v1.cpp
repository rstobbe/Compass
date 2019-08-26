//=========================================================
//
//========================================================

#include "mex.h"
//#include "math.h"
#include "string.h"

extern "C" void FindXngh(float* Kx, float* Radinds, float* Kxinds, float* Kxindlens,
                         int npro, int nproj, int maxkxindlen, float W, int dpts, int* Tst, char* Error);


void mexFunction(int nlhs, mxArray *plhs[], 
    int nrhs, const mxArray *prhs[])
{

// In
float *In0,*In1,*In2,*In3,*In4,*In5,*In6;
float *Kx,*Radinds;
int npro,nproj,maxkxindlen,dpts;
float W;
// Out
float *Kxinds,*Kxindlens;
char Error[100] = {0};
int *Tst;
// Internal
int dim[2];
int tdim[2];

/*------------------------------*/
/* Input                        */
/*------------------------------*/
if (nrhs != 7) mexErrMsgTxt("Should have 7 inputs");
In0 = (float*)mxGetData(prhs[0]);    
Kx = In0;
In1 = (float*)mxGetData(prhs[1]);       
Radinds = In1;
In2 = (float*)mxGetData(prhs[2]);     
npro = int(In2[0]);
In3 = (float*)mxGetData(prhs[3]);     
nproj = int(In3[0]);
In4 = (float*)mxGetData(prhs[4]);     
maxkxindlen = int(In4[0]);
In5 = (float*)mxGetData(prhs[5]);     
W = In5[0];
In6 = (float*)mxGetData(prhs[6]);     
dpts = int(In6[0]);

/*------------------------------*/
/* Output                       */
/*------------------------------*/
if (nlhs != 4) mexErrMsgTxt("Should have 4 output");
dim[0] = maxkxindlen; 
dim[1] = dpts;
plhs[0] = mxCreateNumericArray(2,dim,mxSINGLE_CLASS,mxREAL);
Kxinds = (float*)mxGetData(plhs[0]); 

dim[0] = 1; 
dim[1] = dpts;
plhs[1] = mxCreateNumericArray(2,dim,mxSINGLE_CLASS,mxREAL);
Kxindlens = (float*)mxGetData(plhs[1]); 

tdim[0] = 1; 
tdim[1] = 16; 
plhs[2] = mxCreateNumericArray(2,tdim,mxINT32_CLASS,mxREAL);
Tst = (int*)mxGetData(plhs[2]);

/*------------------------------*/
/* Workings                     */
/*------------------------------*/
FindXngh(Kx,Radinds,Kxinds,Kxindlens,npro,nproj,maxkxindlen,W,dpts,Tst,Error);

plhs[3] = mxCreateString(Error);

}

