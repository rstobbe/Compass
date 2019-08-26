//======================================================
// Find Nghbrs
//======================================================

//#include "string.h"
#include <algorithm>
using namespace std;


extern "C" void FindNgh(float* Kx, float* Ky, float* Kz, int* Radinds, int* NGH, int* NGHlens, int* indlens,
                        int npro, int nproj, float W, int MaxNghbrs, int* Dpts, int Dptlen0,
                        cudastruct* CUDA, char* ErrString, int* TstIn, int* TstOut);

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
/*
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
*/
Kxindlens[i] = Radinds[1];
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
// ** Find Neighbour Setup **
//====================================================== 
void FindNgh(float* Kx, float* Ky, float* Kz, int* Radinds, int* NGH, int* NGHlens, int* indlens,
            int npro, int nproj, float W, int MaxNghbrs, int* Dpts, int Dptlen0,
            cudastruct* CUDA, char* ErrString, int* TstIn, int* TstOut){

//-------------------------------------------
// 'global' variables
//-------------------------------------------   
const char* ErrString0;
size_t free,total;

//-------------------------------------------
// Copy Data (unfortunately need to do for each call...)
//-------------------------------------------  
size_t KSz = npro*nproj*sizeof(float);
size_t RadindsSz = npro*2*sizeof(int);
cudaMalloc((void**)&dKx,KSz);
cudaMalloc((void**)&dKy,KSz);
cudaMalloc((void**)&dKz,KSz);
cudaMalloc((void**)&dRadinds,RadindsSz);
ErrString0 = cudaGetErrorString(cudaGetLastError());
if (strcmp(ErrString0,"no error")!=0){
    strcpy(ErrString,ErrString0);
    strcat(ErrString," - cudaMalloc");
    return;
}

cudaMemcpy(dKx,Kx,KSz,cudaMemcpyHostToDevice);
cudaMemcpy(dKy,Ky,KSz,cudaMemcpyHostToDevice);
cudaMemcpy(dKz,Kz,KSz,cudaMemcpyHostToDevice);
cudaMemcpy(dRadinds,Radinds,RadindsSz,cudaMemcpyHostToDevice);
ErrString0 = cudaGetErrorString(cudaGetLastError());
if (strcmp(ErrString0,"no error")!=0){
    strcpy(ErrString,ErrString0);
    strcat(ErrString," - cudaMemcpy");
    return;
}

size_t free,total;
cudaMemGetInfo(&free,&total);
TstOut[0] = total;
TstOut[1] = free;





//-------------------------------------------
// Search 'X'
//-------------------------------------------
int *dKxinds,*dKxindlens,*dDpts;
size_t KxindsSz = Dptlen0*MaxNghbrs*sizeof(int);
size_t DptsSz = Dptlen0*sizeof(int);
cudaMalloc((void**)&dKxinds,KxindsSz);
cudaMalloc((void**)&dKxindlens,DptsSz);
cudaMalloc((void**)&dDpts,DptsSz);
cudaMemset(dKxinds,0,KxindsSz);
cudaMemset(dKxindlens,0,DptsSz);
cudaMemcpy(dDpts,Dpts,DptsSz,cudaMemcpyHostToDevice);
int maxkxindlen = MaxNghbrs;

cudaMemGetInfo(&free,&total);
TstOut[0] = total;
TstOut[1] = free;
ErrString0 = cudaGetErrorString(cudaGetLastError());
if (strcmp(ErrString0,"no error")!=0){
    strcpy(ErrString,ErrString0);
    return;
}

int tpb = 256;                                               // experimental paramater (range 64 - 1024, multiple 32)...                              
int bpg = int(ceil(float(Dptlen0)/float(tpb)));

if (bpg > 1024){
    ErrString0 = "Block Size Too Large";
    strcpy(ErrString,ErrString0);
    return;
}

KernFindXngh<<<bpg,tpb>>>(dKx,dRadinds,dKxinds,dKxindlens,nproj,maxkxindlen,W,dDpts,Dptlen0);
ErrString0 = cudaGetErrorString(cudaGetLastError());
if (strcmp(ErrString0,"no error")!=0){
    strcpy(ErrString,ErrString0);
    return;
}
cudaMemcpy(indlens,dKxindlens,DptsSz,cudaMemcpyDeviceToHost);
//cudaMemcpy(Dpts,dDpts,DptsSz,cudaMemcpyDeviceToHost);
TstOut[0] = indlens[50];
strcpy(ErrString,ErrString0);
return;












//maxkxindlen = *max_element(dKxindlens,dKxindlens+Dptlen0);
//maxkxindlen = (int)ceil(float(maxkxindlen)*1.05);

//-------------------------------------------
// Search 'Y'
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
// Search 'Z'
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

//----------------------------------------------
// Output
//----------------------------------------------
//NGH = dKzinds;                         // possible keep in memory - for doing convolution.
//NGHlens = dKzindlens;
cudaMemGetInfo(&free,&total);
TstOut[0] = total;
TstOut[1] = free;
TstOut[2] = maxkxindlen;
TstOut[3] = maxkyindlen;
TstOut[4] = maxkzindlen;
if (TstIn[0]==0){
    cudaMemcpy(NGH,dKzinds,KzindsSz,cudaMemcpyDeviceToHost);
}

//----------------------------------------------
// Free Memory
//----------------------------------------------
cudaFree(dKxinds);
cudaFree(dKyinds);
cudaFree(dKxindlens);
cudaFree(dKyindlens);
cudaFree(dDpts);

cudaFree(dKzinds);                         // possibly keep in memory - for doing convolution.  
cudaFree(dKzindlens);
}


