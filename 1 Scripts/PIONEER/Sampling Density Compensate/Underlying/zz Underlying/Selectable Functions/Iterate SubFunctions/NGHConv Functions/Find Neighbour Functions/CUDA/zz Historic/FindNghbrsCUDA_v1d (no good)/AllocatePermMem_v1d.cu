//======================================================
// Allocate 'Permanent' Memory
//======================================================

extern "C" void AllocatePermMem(float* Kx, float* Ky, float* Kz, int* Radinds,
                                int npro, int nproj, char* ErrString, int* TstOut);

extern __device__ float* dKx;
extern __device__ float* dKy;
extern __device__ float* dKz;
extern __device__ int* dRadinds;

//======================================================
// Allocate/Copy/Set Device Memory ('Permanent')
//====================================================== 
void AllocatePermMem(float* Kx, float* Ky, float* Kz, int* Radinds,
                     int npro, int nproj, char* ErrString, int* TstOut){

const char* ErrString0;    
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


}


