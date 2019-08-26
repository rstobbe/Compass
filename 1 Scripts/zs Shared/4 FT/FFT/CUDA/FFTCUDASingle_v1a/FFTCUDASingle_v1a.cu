///==========================================================
/// (v1a)
///		
///==========================================================

#include "cufft.h"

extern "C" void FFT3D(float* Im, float* kDat, int MatSz, int* Tst, char* Error);

///=====================================================
/// Code Entry
///=====================================================
void FFT3D(float* Im, float* kDat, int MatSz, int* Tst, char* Error)
{

//----------------------------------------------
// General Setup
//----------------------------------------------
const char* Error0; 

//----------------------------------------------
// FFT Setup
//----------------------------------------------
cufftHandle plan;
cufftComplex *dIm, *dkDat;

//----------------------------------------------
// Allocate Memory
//----------------------------------------------
size_t MatMem = sizeof(cufftComplex)*MatSz*MatSz*MatSz;
cudaMalloc((void**)&dIm, MatMem);
cudaMalloc((void**)&dkDat, MatMem);
if (cudaGetLastError() != cudaSuccess){
	Error0 = cudaGetErrorString(cudaGetLastError());
	strcpy(Error,Error0);
	return;
}

//----------------------------------------------
// Copy/Set Memory
//----------------------------------------------
cudaMemcpy(dIm,Im,MatMem,cudaMemcpyHostToDevice);
cudaMemset(dkDat,0,MatMem);

//----------------------------------------------
// Create a 3D FFT plan
//----------------------------------------------
cufftPlan3d(&plan,MatSz,MatSz,MatSz,CUFFT_C2C);
if (cudaGetLastError() != cudaSuccess){
	Error0 = cudaGetErrorString(cudaGetLastError());
	strcpy(Error,Error0);
	return;
}

//----------------------------------------------
// Transform
//----------------------------------------------
cufftExecC2C(plan,dIm,dkDat,CUFFT_FORWARD);
if (cudaGetLastError() != cudaSuccess){
	Error0 = cudaGetErrorString(cudaGetLastError());
	strcpy(Error,Error0);
	return;
}

//----------------------------------------------
// Wait for device to finish
//----------------------------------------------
cudaThreadSynchronize();
if (cudaGetLastError() != cudaSuccess){
	Error0 = cudaGetErrorString(cudaGetLastError());
	strcpy(Error,Error0);
	return;
}

//-----------------------------------------------------
// Copy Back to Host
//-----------------------------------------------------
cudaMemcpy(kDat,dkDat,MatMem,cudaMemcpyDeviceToHost);

//----------------------------------------------
// Release
//----------------------------------------------
cufftDestroy(plan);
cudaFree(dIm);
cudaFree(dkDat);

}

