//======================================================
// Find Nghbrs
//======================================================

#include <algorithm>
using namespace std;


extern "C" void FindNgh(float* Kx, float* Ky, float* Kz, int* Radinds, int* NGH, int* NGHlens,
                        int npro, int nproj, float W, int MaxXNghbrs, int MaxYNghbrs, int MaxZNghbrs, int* Dpts, int Dptlen0,
                        char* ErrString, int* TstIn, int* TstOut, float xslmult, float yslmult, float zslmult);

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
// ** Find Neighbour Setup **
//====================================================== 
void FindNgh(float* Kx, float* Ky, float* Kz, int* Radinds, int* NGH, int* NGHlens,
             int npro, int nproj, float W, int MaxXNghbrs, int MaxYNghbrs, int MaxZNghbrs, int* Dpts, int Dptlen0,
             char* ErrString, int* TstIn, int* TstOut, float xslmult, float yslmult, float zslmult){

//-------------------------------------------
// 'global' variables
//-------------------------------------------   
const char* ErrString0;
size_t free,total;

//-------------------------------------------
// Copy Data (unfortunately need to do for each call...)
//-------------------------------------------  
float *dKx,*dKy,*dKz;
int *dRadinds;
size_t KSz = npro*nproj*sizeof(float);
size_t RadindsSz = npro*2*sizeof(int);
cudaMalloc((void**)&dKx,KSz);
cudaMalloc((void**)&dKy,KSz);
cudaMalloc((void**)&dKz,KSz);
cudaMalloc((void**)&dRadinds,RadindsSz);
cudaMemcpy(dKx,Kx,KSz,cudaMemcpyHostToDevice);
cudaMemcpy(dKy,Ky,KSz,cudaMemcpyHostToDevice);
cudaMemcpy(dKz,Kz,KSz,cudaMemcpyHostToDevice);
cudaMemcpy(dRadinds,Radinds,RadindsSz,cudaMemcpyHostToDevice);

//-------------------------------------------
// Data Points to Search Through
//-------------------------------------------
int *dDpts;
size_t DptsSz = Dptlen0*sizeof(int);
cudaMalloc((void**)&dDpts,DptsSz);
cudaMemcpy(dDpts,Dpts,DptsSz,cudaMemcpyHostToDevice);

int tpb = 256;                                               // experimental paramater (range 64 - 1024, multiple 32)...                              
int bpg = int(ceil(float(Dptlen0)/float(tpb)));
if (bpg > 1024){
    ErrString0 = "Block Size Too Large";
    strcpy(ErrString,ErrString0);
    return;
}

//-------------------------------------------
// Search 'X'
//-------------------------------------------
int *dKxinds,*dKxindlens;
size_t KxindsSz = Dptlen0*MaxXNghbrs*sizeof(int);
cudaMalloc((void**)&dKxinds,KxindsSz);
cudaMalloc((void**)&dKxindlens,DptsSz);
cudaMemset(dKxinds,0,KxindsSz);
cudaMemset(dKxindlens,0,DptsSz);

cudaMemGetInfo(&free,&total);
TstOut[0] = total;
TstOut[1] = free;
ErrString0 = cudaGetErrorString(cudaGetLastError());
if (strcmp(ErrString0,"no error")!=0){
    strcpy(ErrString,ErrString0);
    return;
}

KernFindXngh<<<bpg,tpb>>>(dKx,dRadinds,dKxinds,dKxindlens,nproj,MaxXNghbrs,W,dDpts,Dptlen0);
ErrString0 = cudaGetErrorString(cudaGetLastError());
if (strcmp(ErrString0,"no error")!=0){
    strcpy(ErrString,ErrString0);
    return;
}

int maxkxindlen = 0;
cudaMemcpy(NGHlens,dKxindlens,DptsSz,cudaMemcpyDeviceToHost);
maxkxindlen  = *max_element(NGHlens,NGHlens+Dptlen0);
if (TstIn[0]==1){
    maxkxindlen  = (int)ceil(float(maxkxindlen)*xslmult);
}
TstOut[2] = maxkxindlen;

//-------------------------------------------
// Search 'Y'
//-------------------------------------------
if (TstIn[0]==1){
    MaxYNghbrs = maxkxindlen;
}
int *dKyinds,*dKyindlens;
size_t KyindsSz = Dptlen0*MaxYNghbrs*sizeof(int);
cudaMalloc((void**)&dKyinds,KyindsSz);
cudaMalloc((void**)&dKyindlens,DptsSz);
cudaMemset(dKyinds,0,KyindsSz);
cudaMemset(dKyindlens,0,DptsSz);

cudaMemGetInfo(&free,&total);
TstOut[3] = total;
TstOut[4] = free;
ErrString0 = cudaGetErrorString(cudaGetLastError());
if (strcmp(ErrString0,"no error")!=0){
    strcpy(ErrString,ErrString0);
    return;
}

KernFindYngh<<<bpg,tpb>>>(dKy,dKxinds,dKyinds,dKxindlens,dKyindlens,MaxXNghbrs,MaxYNghbrs,W,dDpts,Dptlen0);
ErrString0 = cudaGetErrorString(cudaGetLastError());
if (strcmp(ErrString0,"no error")!=0){
    strcpy(ErrString,ErrString0);
    return;
}

int maxkyindlen = 0;
cudaMemcpy(NGHlens,dKyindlens,DptsSz,cudaMemcpyDeviceToHost);
maxkyindlen = *max_element(NGHlens,NGHlens+Dptlen0);
if (TstIn[0]==1){
    maxkyindlen = (int)ceil(float(maxkyindlen)*yslmult);
}
TstOut[5] = maxkyindlen;

cudaFree(dKxinds);
cudaFree(dKxindlens);

//-------------------------------------------
// Search 'Z'
//-------------------------------------------
if (TstIn[0]==1){
    MaxZNghbrs = maxkyindlen;
}
int *dKzinds,*dKzindlens;
size_t KzindsSz = Dptlen0*MaxZNghbrs*sizeof(int);
cudaMalloc((void**)&dKzinds,KzindsSz);
cudaMalloc((void**)&dKzindlens,DptsSz);
cudaMemset(dKzinds,0,KzindsSz);
cudaMemset(dKzindlens,0,DptsSz);

cudaMemGetInfo(&free,&total);
TstOut[6] = total;
TstOut[7] = free;
ErrString0 = cudaGetErrorString(cudaGetLastError());
if (strcmp(ErrString0,"no error")!=0){
    strcpy(ErrString,ErrString0);
    return;
}

KernFindYngh<<<bpg,tpb>>>(dKz,dKyinds,dKzinds,dKyindlens,dKzindlens,MaxYNghbrs,MaxZNghbrs,W,dDpts,Dptlen0);
ErrString0 = cudaGetErrorString(cudaGetLastError());
if (strcmp(ErrString0,"no error")!=0){
    strcpy(ErrString,ErrString0);
    return;
}

int maxkzindlen = 0;
cudaMemcpy(NGHlens,dKzindlens,DptsSz,cudaMemcpyDeviceToHost);
maxkzindlen = *max_element(NGHlens,NGHlens+Dptlen0);
if (TstIn[0]==1){
    maxkzindlen = (int)ceil(float(maxkzindlen)*zslmult);
}
TstOut[8] = maxkzindlen;

//----------------------------------------------
// Output
//----------------------------------------------
if (TstIn[0]==0){
    cudaMemcpy(NGH,dKzinds,KzindsSz,cudaMemcpyDeviceToHost);
}

//----------------------------------------------
// Free Memory
//----------------------------------------------
cudaFree(dKyinds);
cudaFree(dKyindlens);
cudaFree(dDpts);
cudaFree(dKzinds);                         
cudaFree(dKzindlens);
cudaFree(dKx);
cudaFree(dKy);
cudaFree(dKz);
cudaFree(dRadinds);
}


