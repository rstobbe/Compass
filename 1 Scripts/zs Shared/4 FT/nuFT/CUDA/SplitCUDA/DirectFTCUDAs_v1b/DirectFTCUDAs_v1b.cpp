///==========================================================
/// (v1b)
///		- update for Titan Black
///==========================================================

#include "mex.h"
#include "matrix.h"
#include "math.h"
#include "string.h"

extern "C" void DirectFT(float* Im, float* kLoc, float* kValR, float* kValI, int X, int Y, int Z, int kLen, int SegX, int SegY, int SegZ, int* Tst, char* Error);

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{

/*------------------------------*/
// Function design                   
/*------------------------------*/
const int SegDim = 8;
const int ImSegLen = 512;
 
/*------------------------------*/
// Input                     
/*------------------------------*/
float *In0,*Im;
float *In1,*kLoc;
const int *kArr_Dim0;
const int *Im_Dim;
int kArr_dim[2];

if (nrhs != 2) mexErrMsgTxt("Should have 2 inputs");
In0 = (float*)mxGetPr(prhs[0]);     
Im = In0;
In1 = (float*)mxGetPr(prhs[1]);     
kLoc = In1;

Im_Dim = mxGetDimensions(prhs[0]);
kArr_Dim0 = mxGetDimensions(prhs[1]);
kArr_dim[0] = kArr_Dim0[1];
kArr_dim[1] = 1;

/*------------------------------*/
// Output                   
/*------------------------------*/
float *kValR,*kValI;
int *Tst;
char *Error;
int errorlen = 200;
int Tst_dim[2];

if (nlhs != 3) mexErrMsgTxt("Should have 3 outputs");
plhs[0] = mxCreateNumericArray(2,kArr_dim,mxSINGLE_CLASS,mxCOMPLEX);
kValR = (float*)mxGetPr(plhs[0]); 
kValI = (float*)mxGetPi(plhs[0]); 
Tst_dim[0] = 1; 
Tst_dim[1] = 20; 
plhs[1] = mxCreateNumericArray(2,Tst_dim,mxINT32_CLASS,mxREAL);
Tst = (int*)mxGetData(plhs[1]);
Error = (char*)mxCalloc(errorlen,sizeof(char));
plhs[2] = mxCreateString(Error);

/*------------------------------*/
// Workings            
/*------------------------------*/
float *kValR0,*kValI0;
float *ImSeg;
int Splts,Xsplts,Ysplts,Zsplts,SegX,SegY,SegZ;
int n,m,j,k,kLen;
int x,y,z,xs,ys,zs;
int X,Y,Z;
kValR0 = (float*)mxCalloc(kArr_dim[0],sizeof(float));
kValI0 = (float*)mxCalloc(kArr_dim[0],sizeof(float));
ImSeg = (float*)mxCalloc(ImSegLen,sizeof(float));

kLen = kArr_dim[0];
Z = Im_Dim[0];
Y = Im_Dim[1];
X = Im_Dim[2];

Xsplts = X/SegDim;
Ysplts = Y/SegDim;
Zsplts = Z/SegDim;
Splts = Xsplts*Ysplts*Zsplts;

//Tst[0] = SegDim;
//Tst[1] = Xsplts;
//Tst[2] = kLen;

m = 0;
for (zs=0; zs<Zsplts; zs++) {
    for (ys=0; ys<Ysplts; ys++) { 
        for (xs=0; xs<Xsplts; xs++) {
            n = 0;
            for (z=0; z<SegDim; z++) {
                for (y=0; y<SegDim; y++) { 
                    for (x=0; x<SegDim; x++) {
                        ImSeg[n] = Im[xs*SegDim+x + (ys*SegDim+y)*X + (zs*SegDim+z)*X*Y];
                        n = n+1;
                    }
                }
            }
            //for (j=0; j<SegDim*SegDim*SegDim; j++) {     // testing
            //    Tst[m] += (int)ImSeg[j];
            //    Tst[m] = m;
            //}
            m = m+1;
            SegX = (xs-Xsplts/2)*SegDim;  
            SegY = (ys-Ysplts/2)*SegDim;
            SegZ = (zs-Zsplts/2)*SegDim;
            DirectFT(ImSeg,kLoc,kValR0,kValI0,X,Y,Z,kLen,SegX,SegY,SegZ,Tst,Error);
            for (k=0; k<kLen; k++) {
                kValR[k] += kValR0[k];
                kValI[k] += kValI0[k];
            }
        }
    }
}

mxFree(kValR0);
mxFree(kValI0);
mxFree(ImSeg);
mxFree(Error);

}

