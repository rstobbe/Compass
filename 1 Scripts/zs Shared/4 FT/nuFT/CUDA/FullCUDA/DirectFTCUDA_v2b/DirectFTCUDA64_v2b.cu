///==========================================================
/// (v2b)
///		- Split into 2 kernels 
///			(works for image matrix x64)
///			- to do bigger need to increase GRDDIM 
///			- however, would need to split FTfin
///==========================================================

extern "C" void DirectFT(float* Im, float* kLoc, float* kValR, float* kValI, int X, int Y, int Z, int kLen, int* Tst, char* Error);


#define BLKDIM 8
#define GRDDIM 8
#define GRDTOT GRDDIM*GRDDIM*GRDDIM

///=====================================================
/// FT (kernel)
///=====================================================
__global__ void FT(float* Im, float* kLocX, float* kLocY, float* kLocZ, float* kValR, float* kValI, int X, int Y, int Z, int kLen, int tilenum)
{	

float pi = 3.141592;
__shared__ float tIm[BLKDIM][BLKDIM][BLKDIM];

int tx = threadIdx.x;
int ty = threadIdx.y;
int tz = threadIdx.z;
int bx = blockIdx.x;
int by = blockIdx.y;
int bz = blockIdx.z;
int tbx = blockIdx.x * BLKDIM;
int tby = blockIdx.y * BLKDIM;
int tbz = blockIdx.z * BLKDIM;
int ix = tbx + tx;
int iy = tby + ty;
int iz = tbz + tz;
int bnum = bx + by*gridDim.x + bz*gridDim.x*gridDim.y;
tIm[tx][ty][tz] = Im[(ix)+(iy*X)+(iz*X*Y)];	

int n = (tx)+(ty*BLKDIM)+(tz*BLKDIM*BLKDIM);	
int k = BLKDIM*BLKDIM*BLKDIM*tilenum + n;				
float tkLocX = kLocX[k];
float tkLocY = kLocY[k];
float tkLocZ = kLocZ[k];
float tkValR = 0;
float tkValI = 0;
__syncthreads();
	
for(int z=0; z<BLKDIM; z++) {     
	for(int y=0; y<BLKDIM; y++) {
		for(int x=0; x<BLKDIM; x++) {
			tkValR += tIm[x][y][z]*cosf(2*pi*((tkLocX*(tbx+x)/X)+(tkLocY*(tby+y)/Y)+(tkLocZ*(tbz+z)/Z)));			
			tkValI -= tIm[x][y][z]*sinf(2*pi*((tkLocX*(tbx+x)/X)+(tkLocY*(tby+y)/Y)+(tkLocZ*(tbz+z)/Z)));
			__syncthreads();
			}
		}
	}

if (k < kLen) {		
	kValR[k*GRDTOT + bnum] = tkValR;
	kValI[k*GRDTOT + bnum] = tkValI;
	}	
}

///=====================================================
/// FTfin (kernel)
///=====================================================
__global__ void FTfin(float* kValR, float* kValI, float* kValR0, float* kValI0)
{	
__shared__ float tkValR[GRDTOT];
__shared__ float tkValI[GRDTOT];
float accR = 0;
float accI = 0;
int k = blockIdx.x;
int n = threadIdx.x;
int a = k*GRDTOT+n;
tkValR[n] = kValR0[a];
tkValI[n] = kValI0[a];

for(int i=0; i<GRDTOT; i++) { 
	accR += tkValR[i];
	accI += tkValI[i];
	}
	
kValR[k] = accR;
kValI[k] = accI;
}
	
///=====================================================
/// Code Entry
///=====================================================
void DirectFT(float* Im, float* kLoc, float* kValR, float* kValI, int X, int Y, int Z, int kLen, int* Tst, char* Error) 
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
size_t ImSize = X*Y*Z*sizeof(float);
float *dIm,*dkLocX,*dkLocY,*dkLocZ,*dkValR0,*dkValI0,*dkValR,*dkValI;

cudaMalloc((void**)&dIm,ImSize);
cudaMalloc((void**)&dkLocX,kSize);
cudaMalloc((void**)&dkLocY,kSize);
cudaMalloc((void**)&dkLocZ,kSize);
cudaMalloc((void**)&dkValR0,kSize*GRDTOT);
cudaMalloc((void**)&dkValI0,kSize*GRDTOT);
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
Tst[10] = X*Y*Z;
Tst[11] = kLen;

//----------------------------------------------
// Copy/Set Memory
//----------------------------------------------
cudaMemcpy(dIm,Im,ImSize,cudaMemcpyHostToDevice);
cudaMemcpy(dkLocX,kLoc,kSize,cudaMemcpyHostToDevice);
cudaMemcpy(dkLocY,kLoc+kLen,kSize,cudaMemcpyHostToDevice);
cudaMemcpy(dkLocZ,kLoc+2*kLen,kSize,cudaMemcpyHostToDevice);
cudaMemset(dkValR0,0,kSize*GRDTOT);
cudaMemset(dkValI0,0,kSize*GRDTOT);
cudaMemset(dkValR,0,kSize);
cudaMemset(dkValI,0,kSize);

//----------------------------------------------
// Kernel Props
//----------------------------------------------											                        
Tst[4] = BLKDIM;
Tst[5] = GRDDIM;
dim3 tpbmat(BLKDIM,BLKDIM,BLKDIM);  									// possible to go up to 1024. Should be multiple of warp_size=32.
dim3 bpgmat(GRDDIM,GRDDIM,GRDDIM);

//----------------------------------------------
// Invoke kernel
//----------------------------------------------
//int tilenum = 0;
//FT<<<bpgmat,tpbmat>>>(dIm,dkLocX,dkLocY,dkLocZ,dkValR0,dkValI0,X,Y,Z,kLen,tilenum);

int ntiles = int(ceil(float(kLen)/float(BLKDIM*BLKDIM*BLKDIM))); 
Tst[6] = ntiles;
for (int tilenum=0; tilenum<ntiles; tilenum++){
	FT<<<bpgmat,tpbmat>>>(dIm,dkLocX,dkLocY,dkLocZ,dkValR0,dkValI0,X,Y,Z,kLen,tilenum);
	}

//----------------------------------------------
// Invoke kernel2
//----------------------------------------------
int tpb = GRDTOT;
int bpg = kLen;
FTfin<<<bpg,tpb>>>(dkValR,dkValI,dkValR0,dkValI0);
	
//----------------------------------------------
// Pick Up Error
//----------------------------------------------
const char* Error0 = cudaGetErrorString(cudaGetLastError());
strcpy(Error,Error0);

//----------------------------------------------
// Copy Back to Host
//----------------------------------------------
cudaMemcpy(kValR,dkValR,kSize,cudaMemcpyDeviceToHost);
cudaMemcpy(kValI,dkValI,kSize,cudaMemcpyDeviceToHost);

//----------------------------------------------
// Free device memory
//----------------------------------------------
cudaFree(dIm);
cudaFree(dkLocX);
cudaFree(dkLocY);
cudaFree(dkLocZ);
cudaFree(dkValR);
cudaFree(dkValI);
cudaFree(dkValR0);
cudaFree(dkValI0);

}

