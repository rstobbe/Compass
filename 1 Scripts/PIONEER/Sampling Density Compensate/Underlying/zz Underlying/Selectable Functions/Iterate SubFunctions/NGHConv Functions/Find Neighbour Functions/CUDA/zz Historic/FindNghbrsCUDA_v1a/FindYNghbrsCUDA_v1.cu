//======================================================
// Find Y Nghbrs
//======================================================

extern "C" void FindYngh(float* Ky, float* Kxinds, float* Kyinds, float* Kxindlens, float* Kyindlens,
                         int npro, int nproj, int maxkxindlen, int maykyindlen, float W, int dpts, int* Tst, char* Error);


//======================================================
// Ky:          matrix of Ky values of all data points (nproj x npro)
// Kxinds:      matrix of Kx values within W for each data point (maxkxinlen x dpts)
// Kyinds:      matrix of Ky values within W for each data point (maxkyinlen x dpts)
//======================================================
 __global__ void KernFindYngh(float* Ky, float* Kxinds, float* Kyinds, float* Kxindlens, float* Kyindlens,
                              int npro, int nproj, int maxkxindlen, int maxkyindlen, float W, int dpts){

float dist;
int i,k,p,temp;
i = blockDim.x*blockIdx.x + threadIdx.x;             

p = 0;
if (i < dpts){
    for(k=0;k<int(Kxindlens[i]);k++){                                                         
        temp = int(Kxinds[k+i*maxkxindlen]);
        dist = fabsf(Ky[temp] - Ky[i]);        
        if (dist < W){
            if (p < maxkyindlen){
                Kyinds[p+i*maxkyindlen] = float(temp);    
                 p++;
                }
            }
        }
    Kyindlens[i] = float(p);
    }
}

void FindYngh(float* Ky, float* Kxinds, float* Kyinds, float* Kxindlens, float* Kyindlens,
              int npro, int nproj, int maxkxindlen, int maxkyindlen, float W, int dpts, int* Tst, char* Error){
        
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
size_t KySz = npro*nproj*sizeof(float);
size_t KxindsSz = dpts*maxkxindlen*sizeof(float);
size_t KyindsSz = dpts*maxkyindlen*sizeof(float);
size_t KxindlensSz = dpts*sizeof(float);
size_t KyindlensSz = dpts*sizeof(float);

float *dKy,*dKxinds,*dKyinds,*dKxindlens,*dKyindlens;
cudaMalloc((void**)&dKy,KySz);
cudaMalloc((void**)&dKxinds,KxindsSz);
cudaMalloc((void**)&dKyinds,KyindsSz);
cudaMalloc((void**)&dKxindlens,KxindlensSz);
cudaMalloc((void**)&dKyindlens,KyindlensSz);

cudaMemGetInfo(&free,&total);
Tst[0] = sizeof(float);
Tst[1] = sizeof(int);
Tst[2] = total;
Tst[3] = free;

cudaMemcpy(dKy,Ky,KySz,cudaMemcpyHostToDevice);
cudaMemcpy(dKxinds,Kxinds,KxindsSz,cudaMemcpyHostToDevice);
cudaMemcpy(dKxindlens,Kxindlens,KxindlensSz,cudaMemcpyHostToDevice);
cudaMemset(dKyinds,0,KyindsSz);
cudaMemset(dKyindlens,0,KyindlensSz);

const char* Error0 = cudaGetErrorString(cudaGetLastError());
strcpy(Error,Error0);

//-----------------------------------------------------
// Invoke kernel
//-----------------------------------------------------
int tpb = 512;                                                                          // possible to go up to 512 - compute capability 1.1
int bpg = int(ceil(float(npro)*float(nproj)/float(tpb)));                               // 14 multiprocessors with 8 cores each on 9800 GT 
KernFindYngh<<<bpg,tpb>>>(dKy,dKxinds,dKyinds,dKxindlens,dKyindlens,npro,nproj,maxkxindlen,maxkyindlen,W,dpts);

Tst[4] = tpb;
Tst[5] = bpg;
Tst[6] = npro;
Tst[7] = nproj;
Tst[8] = maxkyindlen;
Error0 = cudaGetErrorString(cudaGetLastError());
strcpy(Error,Error0);

//-----------------------------------------------------
// Copy Back to Host
//-----------------------------------------------------
cudaMemcpy(Kyinds,dKyinds,KyindsSz,cudaMemcpyDeviceToHost);
cudaMemcpy(Kyindlens,dKyindlens,KyindlensSz,cudaMemcpyDeviceToHost);

//-----------------------------------------------------
// Free device memory
//-----------------------------------------------------
cudaFree(dKy);
cudaFree(dKxinds);
cudaFree(dKyinds);
cudaFree(dKyindlens);
cudaFree(dKxindlens);

}

