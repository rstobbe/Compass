///==========================================================
/// (v1b)
///		use CUDAs 3D addressing
///==========================================================

extern "C" void FFTShift(size_t *HkDatC0, size_t *HkDatC1, int ImSz, char *Error);

#define BLKDIM 8
#define pi 3.141592

///==========================================================
/// FFTSh (kernel)
///==========================================================
__global__ void FFTSh(double *dkDatC0, double *dkDatC1, int ImSz)
{	
int nx = blockDim.x*blockIdx.x + threadIdx.x;
int ny = blockDim.y*blockIdx.y + threadIdx.y;
int nz = blockDim.z*blockIdx.z + threadIdx.z;
int kx = nx+ImSz/2;
if (kx>ImSz){
	kx = kx-ImSz;
	}
int ky = ny+ImSz/2;
if (ky>ImSz){
	ky = ky-ImSz;
	}
int kz = nz+ImSz/2;
if (kz>ImSz){
	kz = kz-ImSz;
	}	
dkDatC1[(kx)+(ky*ImSz)+(kz*ImSz*ImSz)] = dkDatC0[(nx)+(ny*ImSz)+(nz*ImSz*ImSz)];
__syncthreads();
}

///==========================================================
/// FFTShift
///==========================================================
void FFTShift(size_t *HkDatC0, size_t *HkDatC1, int ImSz, char *Error){ 
	double *dkDatC0,*dkDatC1;
	dkDatC0 = (double*)*HkDatC0;
	dkDatC1 = (double*)*HkDatC1;
	
	dim3 tpbmat(BLKDIM,BLKDIM,BLKDIM);  									// possible to go up to 1024 (8x8x8=512). Should be multiple of warp_size=32.
	int bpg = int(ceil(double(ImSz)/double(BLKDIM)));  
	dim3 bpgmat(bpg,bpg,bpg);
	                         
	FFTSh<<<bpgmat,tpbmat>>>(dkDatC0,dkDatC1,ImSz);

	const char* Error0 = cudaGetErrorString(cudaGetLastError());
	strcpy(Error,Error0);
}