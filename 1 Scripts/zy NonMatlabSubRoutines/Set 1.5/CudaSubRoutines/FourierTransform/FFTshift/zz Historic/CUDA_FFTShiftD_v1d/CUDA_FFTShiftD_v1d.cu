///==========================================================
/// (v1d)
///		- Recompile with CUDA 7.5
///==========================================================

extern "C" void FFTShift(size_t *HDatC0, size_t *HDatC1, int MatSz, char *Error);

#define BLKDIM 8
#define pi 3.141592

///==========================================================
/// FFTSh (kernel)
///==========================================================
__global__ void FFTSh(double *dDatC0, double *dDatC1, int MatSz)
{	
int nx = blockDim.x*blockIdx.x + threadIdx.x;
int ny = blockDim.y*blockIdx.y + threadIdx.y;
int nz = blockDim.z*blockIdx.z + threadIdx.z;

if ((nx<MatSz*2) && (ny<MatSz) && (nz<MatSz)) {
	int kx = nx+MatSz;
	if (kx>=(MatSz*2)){
		kx = kx-(MatSz*2);
		}
	int ky = ny+MatSz/2;
	if (ky>=MatSz){
		ky = ky-MatSz;
		}
	int kz = nz+MatSz/2;
	if (kz>=MatSz){
		kz = kz-MatSz;
		}		
	dDatC1[(kx)+(ky*MatSz*2)+(kz*MatSz*MatSz*2)] = dDatC0[(nx)+(ny*MatSz*2)+(nz*MatSz*MatSz*2)];
	}
__syncthreads();
}

///==========================================================
/// FFTShift
///==========================================================
void FFTShift(size_t *HDatC0, size_t *HDatC1, int MatSz, char *Error){ 
	double *dDatC0,*dDatC1;
	dDatC0 = (double*)*HDatC0;
	dDatC1 = (double*)*HDatC1;
	
	dim3 tpbmat(BLKDIM*2,BLKDIM,BLKDIM);  									// possible to go up to 1024 (16x8x8=1024). Should be multiple of warp_size=32.
	int bpg = int(ceil(double(MatSz)/double(BLKDIM)));  
	dim3 bpgmat(bpg,bpg,bpg);
	                         
	FFTSh<<<bpgmat,tpbmat>>>(dDatC0,dDatC1,MatSz);

	const char* Error0 = cudaGetErrorString(cudaGetLastError());
	strcpy(Error,Error0);
}