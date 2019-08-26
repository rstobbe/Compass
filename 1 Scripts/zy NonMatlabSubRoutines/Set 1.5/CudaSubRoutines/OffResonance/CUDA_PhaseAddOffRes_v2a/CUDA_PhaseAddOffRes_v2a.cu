///==========================================================
/// (v2a)
///		- input: real - imag (interleaved)
///==========================================================

extern "C" void PhaseAddOffRes(size_t *HIm0, size_t *HOff, size_t *HIm1, float T, int ImLen, char *Error);

#define pi 3.141592

///==========================================================
/// PAOR (kernel)
///==========================================================
__global__ void PAOR(float *dIm0, float *dOff, float *dIm1, float T)
{	
int n = blockDim.x*blockIdx.x + threadIdx.x;
float val1 = dIm0[n];
float val2 = dIm0[n+1];
float val3 = dIm0[n-1];
float phaseaddreal = cosf(2*pi*T*dOff[n]);
float phaseaddimag = sinf(2*pi*T*dOff[n]);

if (n == 0) {
	dIm1[n] = val1*phaseaddreal - val2*phaseaddimag;	
	}	
else if (n % 2) {
	dIm1[n] = val3*phaseaddimag + val1*phaseaddreal;
	}		
else {
	dIm1[n] = val1*phaseaddreal - val2*phaseaddimag;	
	}
__syncthreads();
}

///==========================================================
/// PhaseAddOffRes
///==========================================================
void PhaseAddOffRes(size_t *HIm0, size_t *HOff, size_t *HIm1, float T, int ImLen, char *Error){ 
	float *dIm0, *dOff, *dIm1;
	dIm0 = (float*)*HIm0;
	dOff = (float*)*HOff;
	dIm1 = (float*)*HIm1;	

	int tpb = 512;                                                          // possible to go up to 1024. Should be multiple of warp_size=32.
	int bpg = int(ceil(float(ImLen)/float(tpb)));                            
	PAOR<<<bpg,tpb>>>(dIm0,dOff,dIm1,T);

	const char* Error0 = cudaGetErrorString(cudaGetLastError());
	strcpy(Error,Error0);
}