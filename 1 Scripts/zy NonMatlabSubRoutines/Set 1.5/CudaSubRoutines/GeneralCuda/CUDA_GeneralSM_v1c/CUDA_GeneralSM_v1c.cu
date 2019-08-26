///==========================================================
/// (v1c)
///		- Recompile with CUDA 9.0 (compute 6.1)
///==========================================================

extern "C" void CUDAcount(int *Count, char *Error);
//extern "C" void CUDAselect(int device, char *Error);
//extern "C" void CUDAreset(char *Error);

extern "C" void ArrAllocSgl(int Count, size_t *HMat, int ArrSz, size_t *Tst, char *Error);
extern "C" void ArrAllocSglC(int Count, size_t *HMat, int ArrSz, size_t *Tst, char *Error);
extern "C" void ArrInitSgl(int Count, size_t *HMat, int ArrSz, char *Error);
extern "C" void ArrInitSglC(int Count, size_t *HMat, int ArrSz, char *Error);
extern "C" void ArrFreeSgl(int Count, size_t *HMat, char *Error);
extern "C" void ArrFreeSglC(int Count, size_t *HMat, char *Error);
extern "C" void ArrLoadSgl(int Count, float *Mat, size_t *HMat, int ArrSz, char *Error);
extern "C" void ArrLoadSglC(int Count, float *Mat, size_t *HMat, int ArrSz, char *Error);
extern "C" void ArrReturnSgl(int Count, float *Mat, size_t *HMat, int ArrSz, char *Error);
extern "C" void ArrReturnSglC(int Count, float *Mat, size_t *HMat, int ArrSz, char *Error);

extern "C" void Mat3DAllocSgl(int Count, size_t *HMat, int MatSz, size_t *Tst, char *Error);
extern "C" void Mat3DAllocSglC(int Count, size_t *HMat, int MatSz, size_t *Tst, char *Error);
extern "C" void Mat3DInitSgl(int Count, size_t *HMat, int MatSz, char *Error);
extern "C" void Mat3DInitSglC(int Count, size_t *HMat, int MatSz, char *Error);
extern "C" void Mat3DFreeSgl(int Count,size_t *HMat, char *Error);
extern "C" void Mat3DFreeSglC(int Count, size_t *HMat, char *Error);
extern "C" void Mat3DLoadSgl(int Count, float *Mat, size_t *HMat, int MatSz, char *Error);
extern "C" void Mat3DLoadSglC(int Count, float *Mat, size_t *HMat, int MatSz, char *Error);
extern "C" void Mat3DReturnSgl(int Count, float *Mat, size_t *HMat, int MatSz, char *Error);
extern "C" void Mat3DReturnSglC(int Count, float *Mat, size_t *HMat, int MatSz, char *Error);

///==========================================================
/// CUDA select
///==========================================================
void CUDAcount(int *Count, char *Error){ 
	const char* Error0; 
	cudaGetDeviceCount(Count);
    cudaDeviceSynchronize();
	Error0 = cudaGetErrorString(cudaGetLastError());
	strcpy(Error,Error0);
}

///==========================================================
/// ArrAllocSgl
///==========================================================
void ArrAllocSgl(int Count, size_t *HMat, int ArrSz, size_t *Tst, char *Error){
	const char* Error0; 
	float *dMat;
	size_t free,total;
	size_t MatMem = sizeof(float)*ArrSz;
	for(int n=0;n<Count;n++){
		cudaSetDevice(n);
		cudaMalloc(&dMat,MatMem);
		HMat[n] = (size_t)dMat;
	}
	Error0 = cudaGetErrorString(cudaGetLastError());
	strcpy(Error,Error0);
	cudaMemGetInfo(&free,&total);
	Tst[0] = total;
	Tst[1] = free;
	cudaDeviceSynchronize();		
}

///==========================================================
/// ArrAllocSglC
///==========================================================
void ArrAllocSglC(int Count, size_t *HMat, int ArrSz, size_t *Tst, char *Error){
	const char* Error0; 
	float *dMat;
	size_t free,total;
	size_t MatMem = sizeof(float)*ArrSz*2;
	for(int n=0;n<Count;n++){
		cudaSetDevice(n);
		cudaMalloc(&dMat,MatMem);
		HMat[n] = (size_t)dMat;
	}
	Error0 = cudaGetErrorString(cudaGetLastError());
	strcpy(Error,Error0);
	cudaMemGetInfo(&free,&total);
	Tst[0] = total;
	Tst[1] = free;
	cudaDeviceSynchronize();		
}

///==========================================================
/// ArrInitSgl
///==========================================================
void ArrInitSgl(int Count, size_t *HMat, int ArrSz, char *Error){
	const char* Error0; 
	float *dMat;
	size_t MatMem = sizeof(float)*ArrSz;
	for(int n=0;n<Count;n++){
		cudaSetDevice(n);
		dMat = (float*)HMat[n];
		cudaMemsetAsync(dMat,0,MatMem);
	}
	Error0 = cudaGetErrorString(cudaGetLastError());
	strcpy(Error,Error0);
	cudaDeviceSynchronize();		
}

///==========================================================
/// ArrInitSglC
///==========================================================
void ArrInitSglC(int Count, size_t *HMat, int ArrSz, char *Error){
	const char* Error0; 
	float *dMat;
	size_t MatMem = sizeof(float)*ArrSz*2;
	for(int n=0;n<Count;n++){
		cudaSetDevice(n);
		dMat = (float*)HMat[n];
		cudaMemsetAsync(dMat,0,MatMem);
	}
	Error0 = cudaGetErrorString(cudaGetLastError());
	strcpy(Error,Error0);
	cudaDeviceSynchronize();		
}

///==========================================================
/// ArrFreeSgl
///==========================================================
void ArrFreeSgl(int Count, size_t *HMat, char *Error){
	const char* Error0; 
	float *dMat;
	for(int n=0;n<Count;n++){
		cudaSetDevice(n);
		dMat = (float*)HMat[n];
		cudaFree(dMat);
	}
	Error0 = cudaGetErrorString(cudaGetLastError());
	strcpy(Error,Error0);
	cudaDeviceSynchronize();	
}

///==========================================================
/// ArrFreeSglC
///==========================================================
void ArrFreeSglC(int Count, size_t *HMat, char *Error){
	const char* Error0; 
	float *dMat;
	for(int n=0;n<Count;n++){
		cudaSetDevice(n);
		dMat = (float*)HMat[n];
		cudaFree(dMat);
	}
	Error0 = cudaGetErrorString(cudaGetLastError());
	strcpy(Error,Error0);
	cudaDeviceSynchronize();	
}

///==========================================================
/// ArrLoadSgl
///==========================================================
void ArrLoadSgl(int Count, float *Mat, size_t *HMat, int ArrSz, char *Error){
	const char* Error0; 
	float *dMat;
	size_t MatMem = sizeof(float)*ArrSz;
	for(int n=0;n<Count;n++){
		cudaSetDevice(n);
		dMat = (float*)HMat[n];
		cudaMemcpyAsync(dMat,Mat,MatMem,cudaMemcpyHostToDevice);
	}
	Error0 = cudaGetErrorString(cudaGetLastError());
	strcpy(Error,Error0);
	cudaDeviceSynchronize();	
}

///==========================================================
/// ArrLoadSglC
///==========================================================
void ArrLoadSglC(int Count, float *Mat, size_t *HMat, int ArrSz, char *Error){
	const char* Error0; 
	float *dMat;
	size_t MatMem = sizeof(float)*ArrSz*2;
	for(int n=0;n<Count;n++){
		cudaSetDevice(n);
		dMat = (float*)HMat[n];
		cudaMemcpyAsync(dMat,Mat,MatMem,cudaMemcpyHostToDevice);
	}
	Error0 = cudaGetErrorString(cudaGetLastError());
	strcpy(Error,Error0);
	cudaDeviceSynchronize();		
}

///==========================================================
/// ArrReturnSgl
///==========================================================
void ArrReturnSgl(int Count, float *Mat, size_t *HMat, int ArrSz, char *Error){
	const char* Error0; 
	float *dMat;
	size_t MatMem = sizeof(float)*ArrSz;
	
    cudaSetDevice(Count);
    dMat = (float*)HMat[Count];
    cudaMemcpyAsync(Mat,dMat,MatMem,cudaMemcpyDeviceToHost);
	
	Error0 = cudaGetErrorString(cudaGetLastError());
	strcpy(Error,Error0);
	cudaDeviceSynchronize();				
	}

///==========================================================
/// ArrReturnSglC
///==========================================================
void ArrReturnSglC(int Count, float *Mat, size_t *HMat, int ArrSz, char *Error){
	const char* Error0; 
	float *dMat;
	size_t MatMem = sizeof(float)*ArrSz*2;
	
    cudaSetDevice(Count);
    dMat = (float*)HMat[Count];
    cudaMemcpyAsync(Mat,dMat,MatMem,cudaMemcpyDeviceToHost);
	
	Error0 = cudaGetErrorString(cudaGetLastError());
	strcpy(Error,Error0);
	cudaDeviceSynchronize();		
}


///==========================================================
/// Mat3DAllocSgl
///==========================================================
void Mat3DAllocSgl(int Count, size_t *HMat, int MatSz, size_t *Tst, char *Error){
	const char* Error0; 
	float *dMat;
	size_t free,total;
	size_t MatMem = sizeof(float)*MatSz*MatSz*MatSz;
	for(int n=0;n<Count;n++){
		cudaSetDevice(n);
		cudaMalloc(&dMat,MatMem);
		HMat[n] = (size_t)dMat;
	}
	Error0 = cudaGetErrorString(cudaGetLastError());
	strcpy(Error,Error0);
	cudaMemGetInfo(&free,&total);
	Tst[0] = total;
	Tst[1] = free;
	cudaDeviceSynchronize();		
}

///==========================================================
/// Mat3DAllocSglC
///==========================================================
void Mat3DAllocSglC(int Count, size_t *HMat, int MatSz, size_t *Tst, char *Error){
	const char* Error0; 
	float *dMat;
	size_t free,total;
	size_t MatMem = sizeof(float)*MatSz*MatSz*MatSz*2;
	for(int n=0;n<Count;n++){
		cudaSetDevice(n);
		cudaMalloc(&dMat,MatMem);
		HMat[n] = (size_t)dMat;
	}
	Error0 = cudaGetErrorString(cudaGetLastError());
	strcpy(Error,Error0);
	cudaMemGetInfo(&free,&total);
	Tst[0] = total;
	Tst[1] = free;
	cudaDeviceSynchronize();		
}

///==========================================================
/// Mat3DInitSgl
///==========================================================
void Mat3DInitSgl(int Count, size_t *HMat, int MatSz, char *Error){
	const char* Error0; 
	float *dMat;
	size_t MatMem = sizeof(float)*MatSz*MatSz*MatSz;
	for(int n=0;n<Count;n++){
		cudaSetDevice(n);
		dMat = (float*)HMat[n];
		cudaMemsetAsync(dMat,0,MatMem);
	}
	Error0 = cudaGetErrorString(cudaGetLastError());
	strcpy(Error,Error0);
	cudaDeviceSynchronize();		
}

///==========================================================
/// Mat3DInitSglC
///==========================================================
void Mat3DInitSglC(int Count, size_t *HMat, int MatSz, char *Error){
	const char* Error0; 
	float *dMat;
	size_t MatMem = sizeof(float)*MatSz*MatSz*MatSz*2;
	for(int n=0;n<Count;n++){
		cudaSetDevice(n);
		dMat = (float*)HMat[n];
		cudaMemsetAsync(dMat,0,MatMem);
	}
	Error0 = cudaGetErrorString(cudaGetLastError());
	strcpy(Error,Error0);
	cudaDeviceSynchronize();		
}

///==========================================================
/// Mat3DFreeSgl
///==========================================================
void Mat3DFreeSgl(int Count, size_t *HMat, char *Error){
	const char* Error0; 
	float *dMat;
	for(int n=0;n<Count;n++){
		cudaSetDevice(n);
		dMat = (float*)HMat[n];
		cudaFree(dMat);
	}
	Error0 = cudaGetErrorString(cudaGetLastError());
	strcpy(Error,Error0);
	cudaDeviceSynchronize();		
}

///==========================================================
/// Mat3DFreeSglC
///==========================================================
void Mat3DFreeSglC(int Count, size_t *HMat, char *Error){
	const char* Error0; 
	float *dMat;
	for(int n=0;n<Count;n++){
		cudaSetDevice(n);
		dMat = (float*)HMat[n];
		cudaFree(dMat);
	}
	Error0 = cudaGetErrorString(cudaGetLastError());
	strcpy(Error,Error0);
	cudaDeviceSynchronize();		
}

///==========================================================
/// Mat3DLoadSgl
///==========================================================
void Mat3DLoadSgl(int Count, float *Mat, size_t *HMat, int MatSz, char *Error){
	const char* Error0; 
	float *dMat;
	size_t MatMem = sizeof(float)*MatSz*MatSz*MatSz;
	for(int n=0;n<Count;n++){
		cudaSetDevice(n);
		dMat = (float*)HMat[n];
		cudaMemcpyAsync(dMat,Mat,MatMem,cudaMemcpyHostToDevice);
	}
	Error0 = cudaGetErrorString(cudaGetLastError());
	strcpy(Error,Error0);
	cudaDeviceSynchronize();		
}

///==========================================================
/// Mat3DLoadSglC
///==========================================================
void Mat3DLoadSglC(int Count, float *Mat, size_t *HMat, int MatSz, char *Error){
	const char* Error0; 
	float *dMat;
	size_t MatMem = sizeof(float)*MatSz*MatSz*MatSz*2;
	for(int n=0;n<Count;n++){
		cudaSetDevice(n);
		dMat = (float*)HMat[n];
		cudaMemcpyAsync(dMat,Mat,MatMem,cudaMemcpyHostToDevice);
	}
	Error0 = cudaGetErrorString(cudaGetLastError());
	strcpy(Error,Error0);
	cudaDeviceSynchronize();		
}

///==========================================================
/// Mat3DReturnSgl
///==========================================================
void Mat3DReturnSgl(int Count, float *Mat, size_t *HMat, int MatSz, char *Error){
	const char* Error0; 
	float *dMat;
	size_t MatMem = sizeof(float)*MatSz*MatSz*MatSz;

    cudaSetDevice(Count);
    dMat = (float*)HMat[Count];
    cudaMemcpyAsync(Mat,dMat,MatMem,cudaMemcpyDeviceToHost);

	Error0 = cudaGetErrorString(cudaGetLastError());
	strcpy(Error,Error0);
	cudaDeviceSynchronize();		
}

///==========================================================
/// Mat3DReturnSglC
///==========================================================
void Mat3DReturnSglC(int Count, float *Mat, size_t *HMat, int MatSz, char *Error){
	const char* Error0; 
	float *dMat;
	size_t MatMem = sizeof(float)*MatSz*MatSz*MatSz*2;

    cudaSetDevice(Count);
    dMat = (float*)HMat[Count];
    cudaMemcpyAsync(Mat,dMat,MatMem,cudaMemcpyDeviceToHost);

	Error0 = cudaGetErrorString(cudaGetLastError());
	strcpy(Error,Error0);
	cudaDeviceSynchronize();		
}
