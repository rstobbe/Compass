//======================================================
// Find X Nghbrs
//======================================================

struct cudastruct {
    const char *Name;
    int Gblmem;
};

extern "C" void FindXngh(float* Kx, int* Radinds, int* Kxinds, int* Kxindlens,
                         int npro, int nproj, int maxkxindlen, float W, int* Dpts, int Dptlen,
                         int* Tst, char* ErrString, cudastruct* CUDA, int memtst);


//======================================================
// ** Kernel Routine **
//      Kx:          Kx values of all data points (nproj x npro)
//      Radinds:     Kx values within radius for readout location (top and bottom) (2 x npro) 
//      Kxinds:      Kx values within W for each data point (maxkxinlen x Dptlen)
//======================================================
 __global__ void KernFindXngh(float* Kx, int* Radinds, int* Kxinds, int* Kxindlens,
                              int npro, int nproj, int maxkxindlen, float W, int* Dpts, int Dptlen){

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
// ** Find X Neighbours **
//
//====================================================== 
void FindXngh(float* Kx, int* Radinds, int* Kxinds, int* Kxindlens,
              int npro, int nproj, int maxkxindlen, float W, int* Dpts, int Dptlen,
              int* Tst, char* ErrString, cudastruct* CUDA, int memtst){

//-------------------------------------------
// 'global' variables
//-------------------------------------------   
cudaError_t Err; 
const char* ErrString0;
size_t free,total;

//-------------------------------------------
// Device Info
//-------------------------------------------
int device,deviceNum;
struct cudaDeviceProp deviceProp; 

cudastruct CUDA0;
cudaGetDeviceCount(&deviceNum);
Tst[0] = deviceNum;
if (deviceNum < 1) {
    ErrString0 = "No Cuda Device";
    strcpy(ErrString,ErrString0);
    return;
}
cudaGetDevice(&device);
Tst[1] = device;
cudaGetDeviceProperties(&deviceProp,device);
CUDA0.Name = deviceProp.name;
CUDA0.Gblmem = deviceProp.totalGlobalMem;    
*CUDA = CUDA0;    


//-------------------------------------------
// Allocate/Copy/Set Device Memory (Global)
//-------------------------------------------
size_t KxSz = npro*nproj*sizeof(float);
size_t RadindsSz = npro*2*sizeof(int);
size_t KxindsSz = Dptlen*maxkxindlen*sizeof(int);
size_t KxindlensSz = Dptlen*sizeof(int);
size_t DptsSz = Dptlen*sizeof(int);

float *dKx;
int *dRadinds,*dKxinds,*dKxindlens,*dDpts;
cudaMalloc((void**)&dKx,KxSz);
cudaMalloc((void**)&dRadinds,RadindsSz);
cudaMalloc((void**)&dKxinds,KxindsSz);
cudaMalloc((void**)&dKxindlens,KxindlensSz);
cudaMalloc((void**)&dDpts,DptsSz);

ErrString0 = cudaGetErrorString(cudaGetLastError());
strcpy(ErrString,ErrString0);

cudaMemGetInfo(&free,&total);
Tst[0] = total;
Tst[1] = free;
if ((free == 0) || (memtst == 1)) {
    cudaFree(dKx);
    cudaFree(dRadinds);
    cudaFree(dKxinds);
    cudaFree(dKxindlens);
    cudaFree(dDpts);
    return;
}

cudaMemcpy(dKx,Kx,KxSz,cudaMemcpyHostToDevice);
cudaMemcpy(dRadinds,Radinds,RadindsSz,cudaMemcpyHostToDevice);
cudaMemcpy(dDpts,Dpts,DptsSz,cudaMemcpyHostToDevice);
cudaMemset(dKxinds,0,KxindsSz);
cudaMemset(dKxindlens,0,KxindlensSz);

ErrString0 = cudaGetErrorString(cudaGetLastError());
strcpy(ErrString,ErrString0);

//-------------------------------------------
// Set Up Kernel
//-------------------------------------------
int tpb = 256;                                               // experimental paramater (range 64 - 1024, multiple 32)...                              
int bpg = int(ceil(float(Dptlen)/float(tpb)));

Tst[2] = tpb;
Tst[3] = bpg;
Tst[4] = npro;
Tst[5] = nproj;
Tst[6] = maxkxindlen;
Tst[7] = Dptlen;

if (bpg > 1024){
    ErrString0 = "Block Size Too Large";
    strcpy(ErrString,ErrString0);
    return;
}

//-------------------------------------------
// Invoke kernel
//-------------------------------------------
KernFindXngh<<<bpg,tpb>>>(dKx,dRadinds,dKxinds,dKxindlens,npro,nproj,maxkxindlen,W,dDpts,Dptlen);
ErrString0 = cudaGetErrorString(cudaGetLastError());
strcpy(ErrString,ErrString0);

//-----------------------------------------------------
// Copy Back to Host
//-----------------------------------------------------
cudaMemcpy(Kxinds,dKxinds,KxindsSz,cudaMemcpyDeviceToHost);
cudaMemcpy(Kxindlens,dKxindlens,KxindlensSz,cudaMemcpyDeviceToHost);

//-----------------------------------------------------
// Free device memory
//-----------------------------------------------------
cudaFree(dKx);
cudaFree(dRadinds);
cudaFree(dKxinds);
cudaFree(dKxindlens);
cudaFree(dDpts);

}


