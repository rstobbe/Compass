///==========================================================
/// (v1a)
///		'D' is doubles
///==========================================================

extern "C" void FFTShift(size_t *HkDatC, int ImSz, char *Error);

#define pi 3.141592

///==========================================================
/// FFTS1 (kernel)
///==========================================================
__global__ void FFTS1(double *dkDatC, int ImSz, int ImLen, double T)
{	
int n = blockDim.x*blockIdx.x + threadIdx.x;
int k = n+ImLen/2;
if (k>ImLen){
	k = k-ImLen;
	}
dkDatC[k] = dkDatC[n];
__syncthreads();
}

///==========================================================
/// FFTS2 (kernel)
///==========================================================
__global__ void FFTS2(double *dkDatC, int ImSz, int ImLen, double T)
{	
int n = blockDim.x*blockIdx.x + threadIdx.x;
int k = n+ImLen/2;
if (k>ImLen){
	k = k-ImLen;
	}
dkDatC[k] = dkDatC[n];
__syncthreads();
}

///==========================================================
/// PhaseAddOffRes
///==========================================================
void FFTShift(size_t *HkDatC, int ImSz, char *Error){ 
	double *dkDatC;
	dkDatC = (double*)*HIm0;
	int ImLen = ImSz*ImSz*Imsz;
	int tpb = 512;                                                          // possible to go up to 1024. Should be multiple of warp_size=32.
	int bpg = int(ceil(double(ImLen)/double(tpb)));                            
	FFTS1<<<bpg,tpb>>>(dkDatC,ImSz,ImLen);

	const char* Error0 = cudaGetErrorString(cudaGetLastError());
	strcpy(Error,Error0);
}