///==========================================================
/// (v1a)
///		- 
///==========================================================

extern "C" void PhaseAddOffRes(size_t *HIm0M, size_t *HIm0P, size_t *HOff, size_t *HIm, float T, int ImLen, char *Error);

#define pi 3.141592

///==========================================================
/// PAOR (kernel)
///==========================================================
__global__ void PAOR(float *dIm0M, float *dIm0P, float *dOff, float *dIm, float T)
{	
int n;
n = blockDim.x*blockIdx.x + threadIdx.x;
if (n == 0) {
	dIm[n] = dIm0M[n]*cosf(2*pi*T*dOff[n] + dIm0P[n]);	
	}	
else if (n % 2) {
	dIm[n] = dIm0M[n]*sinf(2*pi*T*dOff[n] + dIm0P[n]);
	}		
else {
	dIm[n] = dIm0M[n]*cosf(2*pi*T*dOff[n] + dIm0P[n]);	
	}
__syncthreads();
}

///==========================================================
/// PhaseAddOffRes
///==========================================================
void PhaseAddOffRes(size_t *HIm0M, size_t *HIm0P, size_t *HOff, size_t *HIm, float T, int ImLen, char *Error){ 
	float *dIm0M, *dIm0P, *dOff, *dIm;
	dIm0M = (float*)*HIm0M;
	dIm0P = (float*)*HIm0P;
	dOff = (float*)*HOff;
	dIm = (float*)*HIm;	

	int tpb = 512;                                                          // possible to go up to 1024. Should be multiple of warp_size=32.
	int bpg = int(ceil(float(ImLen)/float(tpb)));                            
	PAOR<<<bpg,tpb>>>(dIm0M,dIm0P,dOff,dIm,T);

	const char* Error0 = cudaGetErrorString(cudaGetLastError());
	strcpy(Error,Error0);
}