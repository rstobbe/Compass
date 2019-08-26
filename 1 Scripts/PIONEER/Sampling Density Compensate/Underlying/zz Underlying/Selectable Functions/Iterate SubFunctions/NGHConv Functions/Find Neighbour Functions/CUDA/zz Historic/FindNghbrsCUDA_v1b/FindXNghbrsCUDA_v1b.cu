//======================================================
// Find X Nghbrs
//======================================================

extern "C" void FindXngh(float* Kx, int* Radinds, int* Kxinds, int* Kxindlens,
                         int npro, int nproj, int maxkxindlen, float W, int* Dpts, int Dptlen, int* Tst, char* Error, int memtst);


//======================================================
// Kx:          matrix of Kx values of all data points (nproj x npro)
// Radinds:     matrix of Kx values within radius for readout location (top and bottom) (2 x npro) 
// Kxinds:      matrix of Kx values within W for each data point (maxkxinlen x Dptlen)
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

void FindXngh(float* Kx, int* Radinds, int* Kxinds, int* Kxindlens,
              int npro, int nproj, int maxkxindlen, float W, int* Dpts, int Dptlen, int* Tst, char* Error, int memtst){
        
//-----------------------------------------------------
// testing...
//-----------------------------------------------------
//int deviceCount;
//cudaGetDeviceCount(&deviceCount);
//int device = 0;
//cudaDeviceProp deviceProp;
//cudaGetDeviceProperties(&deviceProp, device);             
size_t free;
size_t total;

//-----------------------------------------------------
// Allocate/Copy/Set Device Memory (Global)
//-----------------------------------------------------
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

const char* Error0 = cudaGetErrorString(cudaGetLastError());
strcpy(Error,Error0);

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

Error0 = cudaGetErrorString(cudaGetLastError());
strcpy(Error,Error0);

//-----------------------------------------------------
// Invoke kernel
//-----------------------------------------------------
int tpb = 512;                                                                          // possible to go up to 512 - compute capability 1.1 - note only (112 cores) 14 multiprocessors with 8 cores each on 9800 GT 
int bpg = int(ceil(float(npro)*float(nproj)/float(tpb)));                               

Tst[2] = tpb;
Tst[3] = bpg;
Tst[4] = npro;
Tst[5] = nproj;
Tst[6] = maxkxindlen;
Tst[7] = Dptlen;

KernFindXngh<<<bpg,tpb>>>(dKx,dRadinds,dKxinds,dKxindlens,npro,nproj,maxkxindlen,W,dDpts,Dptlen);
Error0 = cudaGetErrorString(cudaGetLastError());
strcpy(Error,Error0);

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

