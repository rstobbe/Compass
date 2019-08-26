///==========================================================
/// (v1c)
///		- Recompile with CUDA 9.0 (compute 6.1)
///==========================================================

extern "C" void CUDAselect(int device, char *Error);
extern "C" void CUDAreset(char *Error);

///==========================================================
/// CUDA select
///==========================================================
void CUDAselect(int device, char *Error){ 
	const char* Error0; 
	cudaSetDevice(device);
    cudaDeviceSynchronize();
	Error0 = cudaGetErrorString(cudaGetLastError());
	strcpy(Error,Error0);
}

///==========================================================
/// CUDA reset
///==========================================================
void CUDAreset(char *Error){ 
	const char* Error0; 
	cudaDeviceReset();
    cudaDeviceSynchronize();
	Error0 = cudaGetErrorString(cudaGetLastError());
	strcpy(Error,Error0);
}
