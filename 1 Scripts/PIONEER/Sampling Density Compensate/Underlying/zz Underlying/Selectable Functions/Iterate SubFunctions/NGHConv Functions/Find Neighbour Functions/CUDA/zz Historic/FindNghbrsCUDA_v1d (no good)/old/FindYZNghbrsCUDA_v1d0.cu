//======================================================
// Find Y Nghbrs
//======================================================

extern "C" void FindYngh(float* Ky, int* Kxinds, int* Kyinds, int* Kxindlens, int* Kyindlens,
                         int npro, int nproj, int maxkxindlen, int maxkyindlen, float W, int* Dpts, int Dptlen,
                         int* Tst, char* ErrString, int memtst);


//======================================================
// Ky:          matrix of Ky values of all data points (nproj x npro)
// Kxinds:      matrix of Kx values within W for each data point (maxkxinlen x dpts)
// Kyinds:      matrix of Ky values within W for each data point (maxkyinlen x dpts)
//======================================================
 __global__ void KernFindYngh(float* Ky, int* Kxinds, int* Kyinds, int* Kxindlens, int* Kyindlens,
                              int npro, int nproj, int maxkxindlen, int maxkyindlen, float W, int* Dpts, int Dptlen){

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
// ** Find YZ Neighbours **
//
//====================================================== 
 void FindYngh(float* Ky, int* Kxinds, int* Kyinds, int* Kxindlens, int* Kyindlens,
              int npro, int nproj, int maxkxindlen, int maxkyindlen, float W, int* Dpts, int Dptlen,
              int* Tst, char* ErrString, int memtst){
        
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
size_t KxindsSz = Dptlen*maxkxindlen*sizeof(int);
size_t KyindsSz = Dptlen*maxkyindlen*sizeof(int);
size_t KxindlensSz = Dptlen*sizeof(int);
size_t KyindlensSz = Dptlen*sizeof(int);
size_t DptsSz = Dptlen*sizeof(int);

float *dKy;
int *dKxinds,*dKyinds,*dKxindlens,*dKyindlens,*dDpts;
cudaMalloc((void**)&dKy,KySz);
cudaMalloc((void**)&dKxinds,KxindsSz);
cudaMalloc((void**)&dKyinds,KyindsSz);
cudaMalloc((void**)&dKxindlens,KxindlensSz);
cudaMalloc((void**)&dKyindlens,KyindlensSz);
cudaMalloc((void**)&dDpts,DptsSz);

const char* ErrString0 = cudaGetErrorString(cudaGetLastError());
strcpy(ErrString,ErrString0);

cudaMemGetInfo(&free,&total);
Tst[0] = total;
Tst[1] = free;
if ((free == 0) || (memtst == 1)) {
    cudaFree(dKy);
    cudaFree(dKxinds);
    cudaFree(dKyinds);
    cudaFree(dKyindlens);
    cudaFree(dKxindlens);
    cudaFree(dDpts);
    return;
}

cudaMemcpy(dKy,Ky,KySz,cudaMemcpyHostToDevice);
cudaMemcpy(dKxinds,Kxinds,KxindsSz,cudaMemcpyHostToDevice);
cudaMemcpy(dKxindlens,Kxindlens,KxindlensSz,cudaMemcpyHostToDevice);
cudaMemcpy(dDpts,Dpts,DptsSz,cudaMemcpyHostToDevice);
cudaMemset(dKyinds,0,KyindsSz);
cudaMemset(dKyindlens,0,KyindlensSz);

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
Tst[7] = maxkyindlen;
Tst[8] = Dptlen;

if (bpg > 1024){
    ErrString0 = "Block Size Too Large";
    strcpy(ErrString,ErrString0);
    return;
}

//-------------------------------------------
// Invoke kernel
//-------------------------------------------
KernFindYngh<<<bpg,tpb>>>(dKy,dKxinds,dKyinds,dKxindlens,dKyindlens,npro,nproj,maxkxindlen,maxkyindlen,W,dDpts,Dptlen);
ErrString0 = cudaGetErrorString(cudaGetLastError());
strcpy(ErrString,ErrString0);

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
cudaFree(dDpts);

}

