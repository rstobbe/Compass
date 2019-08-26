///==========================================================
/// (v1b)
///		- Remove Matrix loading/unloading from 'Setup' and 'Teardown'
///==========================================================

#include "cufft.h"

extern "C" void FFT3Dsetup(cufftHandle *plan, int MatSz, char *Error);
extern "C" void FFT3D(size_t *HdIm, size_t *HdkDat, cufftHandle *plan, char *Error);
extern "C" void FFT3Dteardown(cufftHandle *plan);

///==========================================================
/// FFT3Dsetup
///==========================================================
void FFT3Dsetup(cufftHandle *plan, int MatSz, char *Error){
	const char* Error0; 
	cufftPlan3d(plan,MatSz,MatSz,MatSz,CUFFT_C2C);
	Error0 = cudaGetErrorString(cudaGetLastError());
	strcpy(Error,Error0);
}

///==========================================================
/// FFT3D
///==========================================================
void FFT3D(size_t *HdIm, size_t *HdkDat, cufftHandle *plan, char *Error){
	const char* Error0; 
	cufftComplex *dIm, *dkDat;
	dIm = (cufftComplex*)*HdIm;
	dkDat = (cufftComplex*)*HdkDat;
	cufftExecC2C(*plan,dIm,dkDat,CUFFT_FORWARD);
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
/// FFT3Dteardown
///==========================================================
void FFT3Dteardown(cufftHandle *plan){
	cufftDestroy(*plan);
}

