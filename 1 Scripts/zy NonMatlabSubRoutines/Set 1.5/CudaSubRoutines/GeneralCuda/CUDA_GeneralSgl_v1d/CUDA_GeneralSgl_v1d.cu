///==========================================================
/// (v1d)
///		- Multi GPUs Supported Within
///     - Update for New Object-Based recon
///==========================================================

extern "C" void CUDAcount(int *Count, char *Error);
//extern "C" void CUDAselect(int device, char *Error);
//extern "C" void CUDAreset(char *Error);

extern "C" void ArrAllocSgl(size_t *Count, size_t *HMat, size_t *ArrSz, char *Error);
extern "C" void ArrAllocSglC(size_t *Count, size_t *HMat, size_t *ArrSz, char *Error);
extern "C" void ArrInitSgl(size_t *Count, size_t *HMat, size_t *ArrSz, char *Error);
extern "C" void ArrInitSglC(size_t *Count, size_t *HMat, size_t *ArrSz, char *Error);
extern "C" void ArrFreeSgl(size_t *Count, size_t *HMat, char *Error);
extern "C" void ArrFreeSglC(size_t *Count, size_t *HMat, char *Error);
extern "C" void ArrLoadSglSync(size_t *Count, float *Mat, size_t *HMat, size_t *ArrSz, char *Error);
extern "C" void ArrLoadSglSyncC(size_t *Count, float *Mat, size_t *HMat, size_t *ArrSz, char *Error);
extern "C" void ArrLoadSgl(size_t *Count, float *Mat, size_t *HMat, size_t *ArrSz, size_t *ProjInc, char *Error);
extern "C" void ArrLoadSglC(size_t *Count, float *Mat, size_t *HMat, size_t *ArrSz, size_t *ProjInc, char *Error);
extern "C" void ArrReturnSgl(size_t *Count, float *Mat, size_t *HMat, size_t *ArrSz, char *Error);
extern "C" void ArrReturnSglC(size_t *Count, float *Mat, size_t *HMat, size_t *ArrSz, char *Error);
extern "C" void ArrReturnSglSyncC(size_t *Count, float *Mat, size_t *HMat, size_t *ArrSz, char *Error);

extern "C" void Mat3DAllocSgl(size_t *Count, size_t *HMat, int MatSz, char *Error);
extern "C" void Mat3DAllocSglC(size_t *Count, size_t *HMat, int MatSz, char *Error);
extern "C" void Mat3DInitSgl(size_t *Count, size_t *HMat, int MatSz, char *Error);
extern "C" void Mat3DInitSglC(size_t *Count, size_t *HMat, int MatSz, char *Error);
extern "C" void Mat3DFreeSgl(size_t *Count,size_t *HMat, char *Error);
extern "C" void Mat3DFreeSglC(size_t *Count, size_t *HMat, char *Error);
extern "C" void Mat3DLoadSgl(size_t *Count, float *Mat, size_t *HMat, int MatSz, char *Error);
extern "C" void Mat3DLoadSglC(size_t *Count, float *Mat, size_t *HMat, int MatSz, char *Error);
extern "C" void Mat3DReturnSgl(size_t *Count, float *Mat, size_t *HMat, int MatSz, char *Error);
extern "C" void Mat3DReturnSglC(size_t *Count, float *Mat, size_t *HMat, int MatSz, char *Error);

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
void ArrAllocSgl(size_t *Count, size_t *HMat, size_t *ArrSz, char *Error){
    const char* Error0; 
	float *dMat;
	size_t MatMem = sizeof(float)*ArrSz[0];
    for(int n=0;n<Count[0];n++){
		cudaSetDevice(n);
		cudaMalloc(&dMat,MatMem);
		HMat[n] = (size_t)dMat;
	}
	Error0 = cudaGetErrorString(cudaGetLastError());
	strcpy(Error,Error0);
	cudaDeviceSynchronize();
}

///==========================================================
/// ArrAllocSglC
///==========================================================
void ArrAllocSglC(size_t *Count, size_t *HMat, size_t *ArrSz, char *Error){
	const char* Error0; 
	float *dMat;
	size_t MatMem = sizeof(float)*ArrSz[0]*2;
	for(int n=0;n<Count[0];n++){
		cudaSetDevice(n);
		cudaMalloc(&dMat,MatMem);
		HMat[n] = (size_t)dMat;
	}
	Error0 = cudaGetErrorString(cudaGetLastError());
	strcpy(Error,Error0);
	cudaDeviceSynchronize();		
}

///==========================================================
/// ArrInitSgl
///==========================================================
void ArrInitSgl(size_t *Count, size_t *HMat, size_t *ArrSz, char *Error){
	const char* Error0; 
	float *dMat;
	size_t MatMem = sizeof(float)*ArrSz[0];
	for(int n=0;n<Count[0];n++){
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
void ArrInitSglC(size_t *Count, size_t *HMat, size_t *ArrSz, char *Error){
	const char* Error0; 
	float *dMat;
	size_t MatMem = sizeof(float)*ArrSz[0]*2;
	for(int n=0;n<Count[0];n++){
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
void ArrFreeSgl(size_t *Count, size_t *HMat, char *Error){
	const char* Error0; 
	float *dMat;
	for(int n=0;n<Count[0];n++){
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
void ArrFreeSglC(size_t *Count, size_t *HMat, char *Error){
	const char* Error0; 
	float *dMat;
	for(int n=0;n<Count[0];n++){
		cudaSetDevice(n);
		dMat = (float*)HMat[n];
		cudaFree(dMat);
	}
	Error0 = cudaGetErrorString(cudaGetLastError());
	strcpy(Error,Error0);
	cudaDeviceSynchronize();	
}

///==========================================================
/// ArrLoadSglSync
///==========================================================
void ArrLoadSglSync(size_t *Count, float *Mat, size_t *HMat, size_t *ArrSz, char *Error){
	const char* Error0; 
	float *dMat;
	size_t MatMem = sizeof(float)*ArrSz[0];
	for(int n=0;n<Count[0];n++){
		cudaSetDevice(n);
		dMat = (float*)HMat[n];
		cudaMemcpyAsync(dMat,Mat,MatMem,cudaMemcpyHostToDevice);
	}
	Error0 = cudaGetErrorString(cudaGetLastError());
	strcpy(Error,Error0);
	cudaDeviceSynchronize();	
}

///==========================================================
/// ArrLoadSglSyncC
///==========================================================
void ArrLoadSglSyncC(size_t *Count, float *Mat, size_t *HMat, size_t *ArrSz, char *Error){
	const char* Error0; 
	float *dMat;
	size_t MatMem = sizeof(float)*ArrSz[0]*2;
	for(int n=0;n<Count[0];n++){
		cudaSetDevice(n);
		dMat = (float*)HMat[n];
		cudaMemcpyAsync(dMat,Mat,MatMem,cudaMemcpyHostToDevice);
	}
	Error0 = cudaGetErrorString(cudaGetLastError());
	strcpy(Error,Error0);
	cudaDeviceSynchronize();		
}

///==========================================================
/// ArrLoadSgl
///==========================================================
void ArrLoadSgl(size_t *Count, float *Mat, size_t *HMat, size_t *ArrSz, size_t *ProjInc, char *Error){
	const char* Error0; 
	float *dMat;
	size_t MatMem = sizeof(float)*ArrSz[0];
    
    cudaSetDevice(Count[0]);
	dMat = (float*)HMat[Count[0]];
    dMat = dMat + ProjInc[0]*ArrSz[0];
	cudaMemcpyAsync(dMat,Mat,MatMem,cudaMemcpyHostToDevice);

	Error0 = cudaGetErrorString(cudaGetLastError());
	strcpy(Error,Error0);
	cudaDeviceSynchronize();	
}

///==========================================================
/// ArrLoadSglC
///==========================================================
void ArrLoadSglC(size_t *Count, float *Mat, size_t *HMat, size_t *ArrSz, size_t *ProjInc, char *Error){
	const char* Error0; 
	float *dMat;
	size_t MatMem = sizeof(float)*ArrSz[0]*2;
    
    cudaSetDevice(Count[0]);
	dMat = (float*)HMat[Count[0]];
    dMat = dMat + ProjInc[0]*ArrSz[0]*2;
	cudaMemcpyAsync(dMat,Mat,MatMem,cudaMemcpyHostToDevice);

	Error0 = cudaGetErrorString(cudaGetLastError());
	strcpy(Error,Error0);
	cudaDeviceSynchronize();		
}

///==========================================================
/// ArrReturnSgl
///==========================================================
void ArrReturnSgl(size_t *Count, float *Mat, size_t *HMat, size_t *ArrSz, char *Error){
	const char* Error0; 
	float *dMat;
	size_t MatMem = sizeof(float)*ArrSz[0];
	
    cudaSetDevice(Count[0]);
    dMat = (float*)HMat[Count[0]];
    cudaMemcpyAsync(Mat,dMat,MatMem,cudaMemcpyDeviceToHost);
	
	Error0 = cudaGetErrorString(cudaGetLastError());
	strcpy(Error,Error0);
	cudaDeviceSynchronize();				
	}

///==========================================================
/// ArrReturnSglC
///==========================================================
void ArrReturnSglC(size_t *Count, float *Mat, size_t *HMat, size_t *ArrSz, char *Error){
	const char* Error0; 
	float *dMat;
	size_t MatMem = sizeof(float)*ArrSz[0]*2;
	
    cudaSetDevice(Count[0]);
    dMat = (float*)HMat[Count[0]];
    cudaMemcpyAsync(Mat,dMat,MatMem,cudaMemcpyDeviceToHost);
	
	Error0 = cudaGetErrorString(cudaGetLastError());
	strcpy(Error,Error0);
	cudaDeviceSynchronize();		
}

///==========================================================
/// ArrReturnSglSyncC
///==========================================================
void ArrReturnSglSyncC(size_t *Count, float *Mat, size_t *HMat, size_t *ArrSz, char *Error){
	const char* Error0; 
	float *dMat;
	size_t MatMem = sizeof(float)*ArrSz[0]*2;
	
	for(int n=0;n<Count[0];n++){
        cudaSetDevice(n);
        dMat = (float*)HMat[n];
        cudaMemcpyAsync(Mat,dMat,MatMem,cudaMemcpyDeviceToHost);
    }
	
	Error0 = cudaGetErrorString(cudaGetLastError());
	strcpy(Error,Error0);
	cudaDeviceSynchronize();		
}






///==========================================================
/// Mat3DAllocSgl
///==========================================================
void Mat3DAllocSgl(size_t *Count, size_t *HMat, int MatSz, size_t *Tst, char *Error){
	const char* Error0; 
	float *dMat;
	size_t MatMem = sizeof(float)*MatSz*MatSz*MatSz;
	for(int n=0;n<Count[0];n++){
		cudaSetDevice(n);
		cudaMalloc(&dMat,MatMem);
		HMat[n] = (size_t)dMat;
	}
	Error0 = cudaGetErrorString(cudaGetLastError());
	strcpy(Error,Error0);
	cudaDeviceSynchronize();		
}

///==========================================================
/// Mat3DAllocSglC
///==========================================================
void Mat3DAllocSglC(size_t *Count, size_t *HMat, int MatSz, size_t *Tst, char *Error){
	const char* Error0; 
	float *dMat;
	size_t MatMem = sizeof(float)*MatSz*MatSz*MatSz*2;
	for(int n=0;n<Count[0];n++){
		cudaSetDevice(n);
		cudaMalloc(&dMat,MatMem);
		HMat[n] = (size_t)dMat;
	}
	Error0 = cudaGetErrorString(cudaGetLastError());
	strcpy(Error,Error0);
	cudaDeviceSynchronize();		
}

///==========================================================
/// Mat3DInitSgl
///==========================================================
void Mat3DInitSgl(size_t *Count, size_t *HMat, int MatSz, char *Error){
	const char* Error0; 
	float *dMat;
	size_t MatMem = sizeof(float)*MatSz*MatSz*MatSz;
	for(int n=0;n<Count[0];n++){
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
void Mat3DInitSglC(size_t *Count, size_t *HMat, int MatSz, char *Error){
	const char* Error0; 
	float *dMat;
	size_t MatMem = sizeof(float)*MatSz*MatSz*MatSz*2;
	for(int n=0;n<Count[0];n++){
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
void Mat3DFreeSgl(size_t *Count, size_t *HMat, char *Error){
	const char* Error0; 
	float *dMat;
	for(int n=0;n<Count[0];n++){
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
void Mat3DFreeSglC(size_t *Count, size_t *HMat, char *Error){
	const char* Error0; 
	float *dMat;
	for(int n=0;n<Count[0];n++){
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
void Mat3DLoadSgl(size_t *Count, float *Mat, size_t *HMat, int MatSz, char *Error){
	const char* Error0; 
	float *dMat;
	size_t MatMem = sizeof(float)*MatSz*MatSz*MatSz;
	for(int n=0;n<Count[0];n++){
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
void Mat3DLoadSglC(size_t *Count, float *Mat, size_t *HMat, int MatSz, char *Error){
	const char* Error0; 
	float *dMat;
	size_t MatMem = sizeof(float)*MatSz*MatSz*MatSz*2;
	for(int n=0;n<Count[0];n++){
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
void Mat3DReturnSgl(size_t *Count, float *Mat, size_t *HMat, int MatSz, char *Error){
	const char* Error0; 
	float *dMat;
	size_t MatMem = sizeof(float)*MatSz*MatSz*MatSz;

    cudaSetDevice(Count[0]);
    dMat = (float*)HMat[Count[0]];
    cudaMemcpyAsync(Mat,dMat,MatMem,cudaMemcpyDeviceToHost);

	Error0 = cudaGetErrorString(cudaGetLastError());
	strcpy(Error,Error0);
	cudaDeviceSynchronize();		
}

///==========================================================
/// Mat3DReturnSglC
///==========================================================
void Mat3DReturnSglC(size_t *Count, float *Mat, size_t *HMat, int MatSz, char *Error){
	const char* Error0; 
	float *dMat;
	size_t MatMem = sizeof(float)*MatSz*MatSz*MatSz*2;

    cudaSetDevice(Count[0]);
    dMat = (float*)HMat[Count[0]];
    cudaMemcpyAsync(Mat,dMat,MatMem,cudaMemcpyDeviceToHost);

	Error0 = cudaGetErrorString(cudaGetLastError());
	strcpy(Error,Error0);
	cudaDeviceSynchronize();		
}
