//======================================================
// Find Nghbrs
//======================================================

//#include "string.h"
#include <algorithm>
using namespace std;

struct cudastruct {
    const char *Name;
    int Gblmem;
};

extern "C" void FindNgh(float* dKx, float* dKy, float* dKz, int* dRadinds,
                         int npro, int nproj, float W, int MaxNghbrs,
                         char* ErrString, int* TstIn, int* TstOut);


//======================================================
// ** X Kernel Routine **
//      Kx:          Kx values of all data points (nproj x npro)
//      Radinds:     Kx values within radius for readout location (top and bottom) (2 x npro) 
//      Kxinds:      Kx values within W for each data point (maxkxinlen x Dptlen)
//======================================================
 __global__ void KernFindXngh(float* Kx, int* Radinds, int* Kxinds, int* Kxindlens,
                              int nproj, int maxkxindlen, float W, int* Dpts, int Dptlen){

float dist;
int i,j,k,p;
int roloc,rob,rot;
i = blockDim.x*blockIdx.x + threadIdx.x;             

p = 0;
roloc = int(floorf(float(Dpts[i])/float(nproj)));
rob = Radinds[roloc*2];
rot = Radinds[roloc*2+1];
if (i < Dptlen){
    for (j=rob;j<=rot;j++){ 
        for(k=0;k<nproj;k++){                                                         
            dist = fabsf(Kx[k+j*nproj] - Kx[Dpts[i]]);        
            if (dist < W){
            	if (p < maxkxindlen){
                    Kxinds[p+i*maxkxindlen] = (k+j*nproj);    
                    p++;
                }
            }
        }
    }
    Kxindlens[i] = (p);
}
}

//======================================================
// ** Y Kernel Routine **
// Ky:          matrix of Ky values of all data points (nproj x npro)
// Kxinds:      matrix of Kx values within W for each data point (maxkxinlen x dpts)
// Kyinds:      matrix of Ky values within W for each data point (maxkyinlen x dpts)
//======================================================
 __global__ void KernFindYngh(float* Ky, int* Kxinds, int* Kyinds, int* Kxindlens, int* Kyindlens,
                              int maxkxindlen, int maxkyindlen, float W, int* Dpts, int Dptlen){

float dist;
int i,k,p,temp;
i = blockDim.x*blockIdx.x + threadIdx.x;             

p = 0;
if (i < Dptlen){
    for(k=0;k<int(Kxindlens[i]);k++){                                                         
        temp = int(Kxinds[k+i*maxkxindlen]);
        dist = fabsf(Ky[temp] - Ky[Dpts[i]]);        
        if (dist < W){
            if (p < maxkyindlen){
                Kyinds[p+i*maxkyindlen] = (temp);    
                p++;
            }
        }
    }
    Kyindlens[i] = (p);
}
} 
 
//======================================================
// ** Find Neighbours **
//====================================================== 
void FindNgh(float* dKx, float* dKy, float* dKz, int* dRadinds,
             int npro, int nproj, float W, int MaxNghbrs,
             char* ErrString, int* TstIn, int* TstOut){

//-------------------------------------------
// 'global' variables
//-------------------------------------------   
cudaError_t Err; 
const char* ErrString0;
size_t free,total;

//-------------------------------------------
// Neighbour Search Setup - X
//-------------------------------------------
int start = 0;
int skip = 100;
const int Dptlen0 = 100;
int Dpts[Dptlen0];
size_t DptsSz = Dptlen0*sizeof(int);
for (int n=start;n<Dptlen0;n++){
    Dpts[n] = n*skip;
}           

int *dKxinds,*dKxindlens,*dDpts;
size_t KxindsSz = Dptlen0*MaxNghbrs*sizeof(int);
cudaMalloc((void**)&dKxinds,KxindsSz);
cudaMalloc((void**)&dKxindlens,DptsSz);
cudaMalloc((void**)&dDpts,DptsSz);
cudaMemset(dKxinds,0,KxindsSz);
cudaMemset(dKxindlens,0,DptsSz);
cudaMemcpy(dDpts,Dpts,DptsSz,cudaMemcpyHostToDevice);
int maxkxindlen = MaxNghbrs;

int tpb = 256;                                               // experimental paramater (range 64 - 1024, multiple 32)...                              
int bpg = int(ceil(float(Dptlen0)/float(tpb)));

if (bpg > 1024){
    ErrString0 = "Block Size Too Large";
    strcpy(ErrString,ErrString0);
    return;
}

KernFindXngh<<<bpg,tpb>>>(dKx,dRadinds,dKxinds,dKxindlens,nproj,maxkxindlen,W,dDpts,Dptlen0);
maxkxindlen = *max_element(dKxindlens,dKxindlens+Dptlen0);
maxkxindlen = (int)ceil(float(maxkxindlen)*1.05);
ErrString0 = cudaGetErrorString(cudaGetLastError());

//-------------------------------------------
// Neighbour Search Setup - Y
//-------------------------------------------
int *dKyinds,*dKyindlens;
size_t KyindsSz = Dptlen0*maxkxindlen*sizeof(int);
cudaMalloc((void**)&dKyinds,KyindsSz);
cudaMalloc((void**)&dKyindlens,DptsSz);
cudaMemset(dKyinds,0,KyindsSz);
cudaMemset(dKyindlens,0,DptsSz);
int maxkyindlen = maxkxindlen;

KernFindYngh<<<bpg,tpb>>>(dKy,dKxinds,dKyinds,dKxindlens,dKyindlens,maxkxindlen,maxkyindlen,W,dDpts,Dptlen0);
maxkyindlen = *max_element(dKyindlens,dKyindlens+Dptlen0);
maxkyindlen = (int)ceil(float(maxkyindlen)*1.05);
ErrString0 = cudaGetErrorString(cudaGetLastError());

//-------------------------------------------
// Neighbour Search Setup - Z
//-------------------------------------------
int *dKzinds,*dKzindlens;
size_t KzindsSz = Dptlen0*maxkyindlen*sizeof(int);
cudaMalloc((void**)&dKzinds,KzindsSz);
cudaMalloc((void**)&dKzindlens,DptsSz);
cudaMemset(dKyinds,0,KzindsSz);
cudaMemset(dKyindlens,0,DptsSz);
int maxkzindlen = maxkyindlen;

KernFindYngh<<<bpg,tpb>>>(dKz,dKyinds,dKzinds,dKyindlens,dKzindlens,maxkyindlen,maxkzindlen,W,dDpts,Dptlen0);
maxkzindlen = *max_element(dKzindlens,dKzindlens+Dptlen0);
maxkzindlen = (int)ceil(float(maxkzindlen)*1.05);
ErrString0 = cudaGetErrorString(cudaGetLastError());

//-----------------------------------------------------
// Test Memory
//-----------------------------------------------------
cudaFree(dKxinds);
cudaFree(dKyinds);
cudaFree(dKzinds);
cudaFree(dKxindlens);
cudaFree(dKyindlens);
cudaFree(dKzindlens);
cudaFree(dDpts);

float Mem = 150e6;
int Dptlen = (int)ceil((Mem)/(float(maxkxindlen)+float(maxkyindlen)));
DptsSz = Dptlen*sizeof(int);
KxindsSz = Dptlen*maxkxindlen*sizeof(int);
KyindsSz = Dptlen*maxkyindlen*sizeof(int);
KzindsSz = Dptlen*maxkzindlen*sizeof(int);
cudaMalloc((void**)&dKxinds,KxindsSz);
cudaMalloc((void**)&dKyinds,KyindsSz);
cudaMalloc((void**)&dKzinds,KzindsSz);
cudaMalloc((void**)&dKxindlens,DptsSz);
cudaMalloc((void**)&dKyindlens,DptsSz);
cudaMalloc((void**)&dKzindlens,DptsSz);
cudaMalloc((void**)&dDpts,DptsSz);

cudaMemGetInfo(&free,&total);
TstOut[0] = total;
TstOut[1] = free;

//-----------------------------------------------------
// Free device memory
//-----------------------------------------------------
cudaFree(dKx);
cudaFree(dKy);
cudaFree(dKz);
cudaFree(dRadinds);
cudaFree(dKxinds);
cudaFree(dKyinds);
cudaFree(dKzinds);
cudaFree(dKxindlens);
cudaFree(dKyindlens);
cudaFree(dKzindlens);
cudaFree(dDpts);

}


