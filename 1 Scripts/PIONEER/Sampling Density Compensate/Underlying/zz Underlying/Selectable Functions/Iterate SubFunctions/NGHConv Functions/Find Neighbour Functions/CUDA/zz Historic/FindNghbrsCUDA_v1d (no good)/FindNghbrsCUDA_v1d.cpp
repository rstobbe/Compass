//========================================================
// *** CAN'T HAVE MULTIPLE CUDA FILES ACCESS THE SAME DEVICE MEMORY ***
//========================================================

#include "mex.h"
#include "string.h"

struct cudastruct {
    const char *Name;
    int Gblmem;
};

extern "C" void QueryReset(cudastruct* CUDA, char* ErrString);

extern "C" void AllocatePermMem(float* Kx, float* Ky, float* Kz, int* Radinds,
                                int npro, int nproj, char* ErrString, int* TstOut);

extern "C" void FindNgh(int* NGH, int* NGHlens, int* indlens,
                        int npro, int nproj, float W, int MaxNghbrs, int* Dpts, int Dptlen0,
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
int *Radinds,npro,nproj,MaxNghbrs,*TstIn;
double *Stathands;

if (nrhs != 10) mexErrMsgTxt("Should have 10 inputs");
Kx = (float*)mxGetData(prhs[0]);    
Ky = (float*)mxGetData(prhs[1]); 
Kz = (float*)mxGetData(prhs[2]);   
Radinds = (int*)mxGetData(prhs[3]);  
tempInt = (int*)mxGetData(prhs[4]); npro = tempInt[0];
tempInt = (int*)mxGetData(prhs[5]); nproj = tempInt[0];
tempFloat = (float*)mxGetData(prhs[6]); W = tempFloat[0];   
tempInt = (int*)mxGetData(prhs[7]); MaxNghbrs = tempInt[0];
TstIn = (int*)mxGetData(prhs[8]);
Stathands = (double*)mxGetData(prhs[9]);

//-------------------------------------
// Output Variables                      
//-------------------------------------
if (nlhs != 5) mexErrMsgTxt("Should have 5 outputs");
const int Dptlen0 = 256;    // initial search length
int *NGH;
dim[0] = Dptlen0; 
dim[1] = npro*nproj; 
plhs[0] = mxCreateNumericArray(2,dim,mxINT32_CLASS,mxREAL);
NGH = (int*)mxGetData(plhs[0]);

int *NGHlens;
dim[0] = 1; 
dim[1] = npro*nproj; 
plhs[1] = mxCreateNumericArray(2,dim,mxINT32_CLASS,mxREAL);
NGH = (int*)mxGetData(plhs[1]);

int *TstOut;
dim[0] = 1; 
dim[1] = 16; 
plhs[2] = mxCreateNumericArray(2,dim,mxINT32_CLASS,mxREAL);
TstOut = (int*)mxGetData(plhs[2]);

cudastruct CUDA;
CUDA.Name = "";
CUDA.Gblmem = 0;
const char *fnames[] = {"Name", "Gblmem"};
int nfields = 2;
plhs[3] = mxCreateStructMatrix(1, 1, nfields, fnames);
dim[0] = 1; 
dim[1] = 1; 
mxArray *cudaGblMemptr = mxCreateNumericArray(2,dim,mxINT32_CLASS,mxREAL);
int *cudaGblMemval = (int*)mxGetData(cudaGblMemptr);

char Error[150];
strcpy(Error,"");

//-------------------------------------
// Status Variable                   
//-------------------------------------
char Status[150];

//-------------------------------------
// Reset and Query Device                 
//-------------------------------------
QueryReset(&CUDA,Error);
mxSetField(plhs[3],0,"Name",mxCreateString(CUDA.Name));             // for some reason this line needs to come before the one below or CUDA.Name gets messed up...
*cudaGblMemval = CUDA.Gblmem;
mxSetField(plhs[3],0,"Gblmem",cudaGblMemptr);
mexSet(Stathands[0],"String",mxCreateString(CUDA.Name));

//-------------------------------------
// Allocate 'Permanent' Memory                   
//-------------------------------------
AllocatePermMem(Kx,Ky,Kz,Radinds,npro,nproj,Error,TstOut);
sprintf(Status,"Total Memory: %i  Free Memory: %i",TstOut[0],TstOut[1]);
mexSet(Stathands[1],"String",mxCreateString(Status));

//-------------------------------------------
// Find Neighbor Setup
//-------------------------------------------
int start = 0;
int skip = 100;
int Dpts[Dptlen0];
for (int n=start;n<Dptlen0;n++){
    Dpts[n] = n*skip;
}   

int *indlens = (int*)mxCalloc(Dptlen0,sizeof(int));       // create space for this host array in "FindNgh"
FindNgh(NGH,NGHlens,indlens,npro,nproj,W,MaxNghbrs,Dpts,Dptlen0,Error,TstIn,TstOut);
TstOut[3] = Radinds[1];

//float Mem = 150e6;
//int Dptlen = (int)ceil((Mem)/(float(maxkxindlen)+float(maxkyindlen)));

//-------------------------------------
// Output                       
//-------------------------------------
plhs[4] = mxCreateString(Error);

}

