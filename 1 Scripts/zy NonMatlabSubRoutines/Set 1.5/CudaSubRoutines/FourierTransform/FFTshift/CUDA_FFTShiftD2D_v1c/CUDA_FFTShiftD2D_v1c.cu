///==========================================================
/// (v1c)
///		use CUDAs 3D addressing
///==========================================================

extern "C" void FFTShift2D(size_t *HDatC0, size_t *HDatC1, int MatSz, char *Error);

#define BLKDIM 16
#define pi 3.141592

///==========================================================
/// FFTSh (kernel)
///==========================================================
__global__ void FFTSh(double *dDatC0, double *dDatC1, int MatSz)
{	
int nx = blockDim.x*blockIdx.x + threadIdx.x;
int ny = blockDim.y*blockIdx.y + threadIdx.y;

if ((nx<MatSz*2) && (ny<MatSz)) {
	int kx = nx+MatSz;
	if (kx>=(MatSz*2)){
		kx = kx-(MatSz*2);
		}
	int ky = ny+MatSz/2;
	if (ky>=MatSz){
		ky = ky-MatSz;
		}	
	dDatC1[(kx)+(ky*MatSz*2)] = dDatC0[(nx)+(ny*MatSz*2)];
	}
__syncthreads();
}

///==========================================================
/// FFTShift
///==========================================================
void FFTShift2D(size_t *HDatC0, size_t *HDatC1, int MatSz, char *Error){ 
	double *dDatC0,*dDatC1;
	dDatC0 = (double*)*HDatC0;
	dDatC1 = (double*)*HDatC1;
	
	dim3 tpbmat(BLKDIM*2,BLKDIM);  									// possible to go up to 1024 (32x16=512). Should be multiple of warp_size=32.
	int bpg = int(ceil(double(MatSz)/double(BLKDIM)));  
	dim3 bpgmat(bpg,bpg);
	                         
	FFTSh<<<bpgmat,tpbmat>>>(dDatC0,dDatC1,MatSz);

	const char* Error0 = cudaGetErrorString(cudaGetLastError());
	strcpy(Error,Error0);
}