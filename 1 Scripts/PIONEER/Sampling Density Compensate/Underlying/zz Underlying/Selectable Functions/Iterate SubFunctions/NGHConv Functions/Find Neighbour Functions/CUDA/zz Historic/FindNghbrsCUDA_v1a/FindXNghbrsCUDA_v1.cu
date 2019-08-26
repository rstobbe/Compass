//======================================================
// Find X Nghbrs
//======================================================

extern "C" void FindXngh(float* Kx, float* Radinds, float* Kxinds, float* Kxindlens,
                         int npro, int nproj, int maxkxindlen, float W, int dpts, int* Tst, char* Error);


//======================================================
// Kx:          matrix of Kx values of all data points (nproj x npro)
// Radinds:     matrix of Kx values within radius for readout location (top and bottom) (2 x npro) 
// Kxinds:      matrix of Kx values within W for each data point (maxkxinlen x dpts)
//======================================================
 __global__ void KernFindXngh(float* Kx, float* Radinds, float* Kxinds, float* Kxindlens,
                              int npro, int nproj, int maxkxindlen, float W, int dpts){

float dist;
int i,j,k,p;
int roloc,rob,rot;
i = blockDim.x*blockIdx.x + threadIdx.x;             

p = 0;
roloc = int(floorf(float(i)/float(nproj)));
rob = Radinds[roloc*2];
rot = Radinds[roloc*2+1];
if (i < dpts){
    for (j=rob;j<=rot;j++){ 
        for(k=0;k<nproj;k++){                                                         
            dist = fabsf(Kx[k+j*nproj] - Kx[i]);        
            if (dist < W){
            	if (p < maxkxindlen){
                    Kxinds[p+i*maxkxindlen] = float(k+j*nproj);    
                     p++;
                    }
                }
            }
        }
    Kxindlens[i] = float(p);
    }
}

void FindXngh(float* Kx, float* Radinds, float* Kxinds, float* Kxindlens,
              int npro, int nproj, int maxkxindlen, float W, int dpts, int* Tst, char* Error){
        
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
size_t RadindsSz = npro*2*sizeof(float);
size_t KxindsSz = dpts*maxkxindlen*sizeof(float);
size_t KxindlensSz = dpts*sizeof(float);

float *dKx,*dRadinds,*dKxinds,*dKxindlens;
cudaMalloc((void**)&dKx,KxSz);
cudaMalloc((void**)&dRadinds,RadindsSz);
cudaMalloc((void**)&dKxinds,KxindsSz);
cudaMalloc((void**)&dKxindlens,KxindlensSz);

cudaMemGetInfo(&free,&total);
Tst[0] = sizeof(float);
Tst[1] = sizeof(int);
Tst[2] = total;
Tst[3] = free;

cudaMemcpy(dKx,Kx,KxSz,cudaMemcpyHostToDevice);
cudaMemcpy(dRadinds,Radinds,RadindsSz,cudaMemcpyHostToDevice);
cudaMemset(dKxinds,0,KxindsSz);
cudaMemset(dKxindlens,0,KxindlensSz);

const char* Error0 = cudaGetErrorString(cudaGetLastError());
strcpy(Error,Error0);

//-----------------------------------------------------
// Invoke kernel
//-----------------------------------------------------
int tpb = 512;                                                                          // possible to go up to 512 - compute capability 1.1
int bpg = int(ceil(float(npro)*float(nproj)/float(tpb)));                               // 14 multiprocessors with 8 cores each on 9800 GT 
KernFindXngh<<<bpg,tpb>>>(dKx,dRadinds,dKxinds,dKxindlens,npro,nproj,maxkxindlen,W,dpts);

Tst[4] = tpb;
Tst[5] = bpg;
Tst[6] = npro;
Tst[7] = nproj;
Tst[8] = maxkxindlen;
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

}

