///==========================================================
/// (v1b)
///		- Remove Matrix loading/unloading from 'Setup' and 'Teardown'
///==========================================================

#include "cufft.h"

extern "C" void FFT2Dsetup(cufftHandle *plan, int MatSz, char *Error);
extern "C" void FFT2D(size_t *HdIm, size_t *HdkDat, cufftHandle *plan, char *Error);
extern "C" void FFT2Dteardown(cufftHandle *plan);

///==========================================================
/// FFT2Dsetup
///==========================================================
void FFT2Dsetup(cufftHandle *plan, int MatSz, char *Error){
	const char* Error0; 
	cufftPlan2d(plan,MatSz,MatSz,CUFFT_Z2Z);
	Error0 = cudaGetErrorString(cudaGetLastError());
	strcpy(Error,Error0);
}

///==========================================================
/// FFT2D
///==========================================================
void FFT2D(size_t *HdIm, size_t *HdkDat, cufftHandle *plan, char *Error){
	const char* Error0; 
	cufftDoubleComplex *dIm, *dkDat;
	dIm = (cufftDoubleComplex*)*HdIm;
	dkDat = (cufftDoubleComplex*)*HdkDat;
	cufftExecZ2Z(*plan,dIm,dkDat,CUFFT_FORWARD);
	if (cudaGetLastError() != cudaSuccess){
		Error0 = cudaGetErrorString(cudaGetLastError());
		strcpy(Error,Error0); return;
	}
	cudaThreadSynchronize();									// test if needed...
	if (cudaGetLastError() != cudaSuccess){
		Error0 = cudaGetErrorString(cudaGetLastError());
		strcpy(Error,Error0); return;
	}
}

///==========================================================
/// FFT2Dteardown
///==========================================================
void FFT2Dteardown(cufftHandle *plan){
	cufftDestroy(*plan);
}


