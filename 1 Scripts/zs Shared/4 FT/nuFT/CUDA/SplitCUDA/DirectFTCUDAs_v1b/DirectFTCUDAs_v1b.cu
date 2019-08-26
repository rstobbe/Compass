///==========================================================
/// (v1b)
///		- update for Titan Black
///==========================================================

extern "C" void DirectFT(float* Im, float* kLoc, float* kValR, float* kValI, int X, int Y, int Z, int kLen, int SegX, int SegY, int SegZ, int* Tst, char* Error);

///=====================================================
/// Kernel
///=====================================================
__global__ void FT(float* Im, float* kLoc, float* kValR, float* kValI, int X, int Y, int Z, int kLen, int SegX, int SegY, int SegZ)
{
int k,x,y,z;
float kR,kI;
float pi;
pi = 3.141592;
kR = 0;
kI = 0;
k = blockDim.x*blockIdx.x + threadIdx.x;
if (k < kLen)
    {
    for(x=0; x<8; x++) {
        for(y=0; y<8; y++) {
            for(z=0; z<8; z++) { 
                kR = kR + Im[(x)+(y*8)+(z*64)]*cosf(2*pi*((kLoc[k*3+0]*(SegX+x)/X)+(kLoc[k*3+1]*(SegY+y)/Y)+(kLoc[k*3+2]*(SegZ+z)/Z)));
                kI = kI - Im[(x)+(y*8)+(z*64)]*sinf(2*pi*((kLoc[k*3+0]*(SegX+x)/X)+(kLoc[k*3+1]*(SegY+y)/Y)+(kLoc[k*3+2]*(SegZ+z)/Z)));
                }
            }
        }  
    }
kValR[k] = kR;
kValI[k] = kI; 
}

///=====================================================
/// Code Entry
///=====================================================
void DirectFT(float* Im, float* kLoc, float* kValR, float* kValI, int X, int Y, int Z, int kLen, int SegX, int SegY, int SegZ, int* Tst, char* Error) 
{

//----------------------------------------------
// Test for Device
//----------------------------------------------
//int deviceCount;
//cudaGetDeviceCount(&deviceCount);
//int device = 0;
//cudaDeviceProp deviceProp;
//cudaGetDeviceProperties(&deviceProp, device);

//----------------------------------------------
// Allocate Device Memory 
//----------------------------------------------
size_t kSize = kLen*sizeof(float);
size_t ImSize = 512*sizeof(float);
float *dIm,*dkLoc,*dkValR,*dkValI;

cudaMalloc((void**)&dIm,ImSize);
cudaMalloc((void**)&dkLoc,3*kSize);
cudaMalloc((void**)&dkValR,kSize);
cudaMalloc((void**)&dkValI,kSize);

//----------------------------------------------
// Test Memory Availability
//----------------------------------------------
size_t free,total;
cudaMemGetInfo(&free,&total);
Tst[0] = sizeof(float);
Tst[1] = sizeof(int);
Tst[2] = total;
Tst[3] = free;

//----------------------------------------------
// Copy/Set Memory
//----------------------------------------------
cudaMemcpy(dIm,Im,ImSize,cudaMemcpyHostToDevice);
cudaMemcpy(dkLoc,kLoc,3*kSize,cudaMemcpyHostToDevice);
cudaMemset(dkValR,0,kSize);
cudaMemset(dkValI,0,kSize);

//----------------------------------------------
// Invoke kernel
//----------------------------------------------
int tpb = 960;                                                          // possible to go up to 1024 (compute capability 3.5)
int bpg = int(ceil(float(kLen)/float(tpb)));                            // 15 multiprocessors with 192 cores each on Titan Black (use 192x3)
FT<<<bpg,tpb>>>(dIm,dkLoc,dkValR,dkValI,X,Y,Z,kLen,SegX,SegY,SegZ);

const char* Error0 = cudaGetErrorString(cudaGetLastError());
strcpy(Error,Error0);
//cudaThreadSynchronize();

//----------------------------------------------
// Copy Back to Host
//----------------------------------------------
cudaMemcpy(kValR,dkValR,kSize,cudaMemcpyDeviceToHost);
cudaMemcpy(kValI,dkValI,kSize,cudaMemcpyDeviceToHost);

//----------------------------------------------
// Free device memory
//----------------------------------------------
cudaFree(dkLoc);
cudaFree(dIm);
cudaFree(dkValR);
cudaFree(dkValI);

}

