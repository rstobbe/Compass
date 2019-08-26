///==========================================================
/// (v2a)
///		- input: real - imag (interleaved)
///		'D' is doubles
///==========================================================

extern "C" void PhaseAddOffRes(size_t *HIm0, size_t *HOff, size_t *HIm1, double T, int ImLen, char *Error);

#define pi 3.141592

///==========================================================
/// PAOR (kernel)
///==========================================================
__global__ void PAOR(double *dIm0, double *dOff, double *dIm1, double T)
{	
int n = blockDim.x*blockIdx.x + threadIdx.x;
double val1 = dIm0[n];
double val2 = dIm0[n+1];
double val3 = dIm0[n-1];
double phaseaddreal = cos(2*pi*T*dOff[n]);
double phaseaddimag = sin(2*pi*T*dOff[n]);

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
void PhaseAddOffRes(size_t *HIm0, size_t *HOff, size_t *HIm1, double T, int ImLen, char *Error){ 
	double *dIm0, *dOff, *dIm1;
	dIm0 = (double*)*HIm0;
	dOff = (double*)*HOff;
	dIm1 = (double*)*HIm1;	

	int tpb = 512;                                                          // possible to go up to 1024. Should be multiple of warp_size=32.
	int bpg = int(ceil(double(ImLen)/double(tpb)));                            
	PAOR<<<bpg,tpb>>>(dIm0,dOff,dIm1,T);

	const char* Error0 = cudaGetErrorString(cudaGetLastError());
	strcpy(Error,Error0);
}