///==========================================================
/// (v11f)
///     - v11 now means for Cuda 11
///		- Drop SampDat
///     - Simplify 'ArrLoadSglOne'
///==========================================================

extern "C" void CudaDeviceWait(size_t *GpuNum, char *Error);
extern "C" void ArrAllocSglAll(size_t *GpuTot, size_t *HMat, size_t *ArrSz, char *Error);
extern "C" void ArrAllocSglAllC(size_t *GpuTot, size_t *HMat, size_t *ArrSz, char *Error);
extern "C" void ArrInitSglAll(size_t *GpuTot, size_t *HMat, size_t *ArrSz, char *Error);
extern "C" void ArrInitSglAllC(size_t *GpuTot, size_t *HMat, size_t *ArrSz, char *Error);
extern "C" void ArrFreeSglAll(size_t *GpuTot, size_t *HMat, char *Error);
extern "C" void ArrFreeSglAllC(size_t *GpuTot, size_t *HMat, char *Error);
extern "C" void ArrLoadSglAll(size_t *GpuTot, float *Mat, size_t *HMat, size_t *ArrSz, char *Error);
extern "C" void ArrLoadSglAllAsync(size_t *GpuTot, float *Mat, size_t *HMat, size_t *ArrSz, char *Error);
extern "C" void ArrLoadSglAllC(size_t *GpuTot, float *Mat, size_t *HMat, size_t *ArrSz, char *Error);
extern "C" void ArrLoadSglOne(size_t *GpuNum, float *Mat, size_t *HMat, size_t *ArrSz, char *Error);
extern "C" void ArrLoadSglOneC(size_t *GpuNum, float *Mat, size_t *HMat, size_t *ArrSz, char *Error);
extern "C" void ArrLoadSglOneAsyncC(size_t *GpuNum, float *Mat, size_t *HMat, size_t *ArrSz, char *Error);
extern "C" void ArrReturnSglOne(size_t *GpuNum, float *Mat, size_t *HMat, size_t *ArrSz, char *Error);
extern "C" void ArrReturnSglOneC(size_t *GpuNum, float *Mat, size_t *HMat, size_t *ArrSz, char *Error);
extern "C" void ArrReturnSglOneAsyncC(size_t *GpuNum, float *Mat, size_t *HMat, size_t *ArrSz, char *Error);
extern "C" void ArrReturnSglAll(size_t *GpuTot, float *Mat, size_t *HMat, size_t *ArrSz, char *Error);
extern "C" void ArrReturnSglAllC(size_t *GpuTot, float *Mat, size_t *HMat, size_t *ArrSz, char *Error);


///==========================================================
/// CudaDeviceWait
///==========================================================
void CudaDeviceWait(size_t *GpuNum, char *Error){
    const char* Error0; 
    cudaSetDevice(GpuNum[0]);
	cudaDeviceSynchronize();
	Error0 = cudaGetErrorString(cudaGetLastError());
	strcpy(Error,Error0);
}

///==========================================================
/// ArrAllocSglAll
///==========================================================
void ArrAllocSglAll(size_t *GpuTot, size_t *HMat, size_t *ArrSz, char *Error){
    const char* Error0; 
	float *dMat;
	size_t MatMem = sizeof(float)*ArrSz[0];
    for(int n=0;n<GpuTot[0];n++){
		cudaSetDevice(n);
		cudaMalloc(&dMat,MatMem);                           // implicitly synchronous
		HMat[n] = (size_t)dMat;
	}
	Error0 = cudaGetErrorString(cudaGetLastError());
	strcpy(Error,Error0);
	cudaDeviceSynchronize();
}

///==========================================================
/// ArrAllocSglAllC
///==========================================================
void ArrAllocSglAllC(size_t *GpuTot, size_t *HMat, size_t *ArrSz, char *Error){
	const char* Error0; 
	float *dMat;
	size_t MatMem = sizeof(float)*ArrSz[0]*2;
	for(int n=0;n<GpuTot[0];n++){
		cudaSetDevice(n);
		cudaMalloc(&dMat,MatMem);
		HMat[n] = (size_t)dMat;
	}
	Error0 = cudaGetErrorString(cudaGetLastError());
	strcpy(Error,Error0);
	cudaDeviceSynchronize();		
}

///==========================================================
/// ArrInitSglAll
///==========================================================
void ArrInitSglAll(size_t *GpuTot, size_t *HMat, size_t *ArrSz, char *Error){
	const char* Error0; 
	float *dMat;
	size_t MatMem = sizeof(float)*ArrSz[0];
	for(int n=0;n<GpuTot[0];n++){
		cudaSetDevice(n);
		dMat = (float*)HMat[n];
		cudaMemsetAsync(dMat,0,MatMem);
	}
	Error0 = cudaGetErrorString(cudaGetLastError());
	strcpy(Error,Error0);
	cudaDeviceSynchronize();		
}

///==========================================================
/// ArrInitSglAllC
///==========================================================
void ArrInitSglAllC(size_t *GpuTot, size_t *HMat, size_t *ArrSz, char *Error){
	const char* Error0; 
	float *dMat;
	size_t MatMem = sizeof(float)*ArrSz[0]*2;
	for(int n=0;n<GpuTot[0];n++){
		cudaSetDevice(n);
		dMat = (float*)HMat[n];
		cudaMemsetAsync(dMat,0,MatMem);
	}
	Error0 = cudaGetErrorString(cudaGetLastError());
	strcpy(Error,Error0);
	cudaDeviceSynchronize();		
}

///==========================================================
/// ArrFreeSglAll
///==========================================================
void ArrFreeSglAll(size_t *GpuTot, size_t *HMat, char *Error){
	const char* Error0; 
	float *dMat;
	for(int n=0;n<GpuTot[0];n++){
		cudaSetDevice(n);
		dMat = (float*)HMat[n];
		cudaFree(dMat);
	}
	Error0 = cudaGetErrorString(cudaGetLastError());
	strcpy(Error,Error0);
	cudaDeviceSynchronize();	
}

///==========================================================
/// ArrFreeSglAllC
///==========================================================
void ArrFreeSglAllC(size_t *GpuTot, size_t *HMat, char *Error){
	const char* Error0; 
	float *dMat;
	for(int n=0;n<GpuTot[0];n++){
		cudaSetDevice(n);
		dMat = (float*)HMat[n];
		cudaFree(dMat);
	}
	Error0 = cudaGetErrorString(cudaGetLastError());
	strcpy(Error,Error0);
	cudaDeviceSynchronize();	
}

///==========================================================
/// ArrLoadSglAll
///==========================================================
void ArrLoadSglAll(size_t *GpuTot, float *Mat, size_t *HMat, size_t *ArrSz, char *Error){
	const char* Error0; 
	float *dMat;
	size_t MatMem = sizeof(float)*ArrSz[0];
	for(int n=0;n<GpuTot[0];n++){
		cudaSetDevice(n);
		dMat = (float*)HMat[n];
		cudaMemcpyAsync(dMat,Mat,MatMem,cudaMemcpyHostToDevice);
	}
	Error0 = cudaGetErrorString(cudaGetLastError());
	strcpy(Error,Error0);
	cudaDeviceSynchronize();	
}

///==========================================================
/// ArrLoadSglAllAsync
///==========================================================
void ArrLoadSglAllAsync(size_t *GpuTot, float *Mat, size_t *HMat, size_t *ArrSz, char *Error){
	const char* Error0; 
	float *dMat;
	size_t MatMem = sizeof(float)*ArrSz[0];
	for(int n=0;n<GpuTot[0];n++){
		cudaSetDevice(n);
		dMat = (float*)HMat[n];
		cudaMemcpyAsync(dMat,Mat,MatMem,cudaMemcpyHostToDevice);
	}
	Error0 = cudaGetErrorString(cudaGetLastError());
	strcpy(Error,Error0);
}

///==========================================================
/// ArrLoadSglAllC
///==========================================================
void ArrLoadSglAllC(size_t *GpuTot, float *Mat, size_t *HMat, size_t *ArrSz, char *Error){
	const char* Error0; 
	float *dMat;
	size_t MatMem = sizeof(float)*ArrSz[0]*2;
	for(int n=0;n<GpuTot[0];n++){
		cudaSetDevice(n);
		dMat = (float*)HMat[n];
		cudaMemcpyAsync(dMat,Mat,MatMem,cudaMemcpyHostToDevice);
	}
	Error0 = cudaGetErrorString(cudaGetLastError());
	strcpy(Error,Error0);
	cudaDeviceSynchronize();		
}

///==========================================================
/// ArrLoadSglOne
///==========================================================
void ArrLoadSglOne(size_t *GpuNum, float *Mat, size_t *HMat, size_t *ArrSz, char *Error){
	const char* Error0; 
	float *dMat;
	size_t MatMem = sizeof(float)*ArrSz[0];
    
    cudaSetDevice(GpuNum[0]);
	dMat = (float*)HMat[GpuNum[0]];
	cudaMemcpyAsync(dMat,Mat,MatMem,cudaMemcpyHostToDevice);

	Error0 = cudaGetErrorString(cudaGetLastError());
	strcpy(Error,Error0);
	cudaDeviceSynchronize();	
}

///==========================================================
/// ArrLoadSglOneC
///==========================================================
void ArrLoadSglOneC(size_t *GpuNum, float *Mat, size_t *HMat, size_t *ArrSz, char *Error){
	const char* Error0; 
	float *dMat;
	size_t MatMem = sizeof(float)*ArrSz[0]*2;
    
    cudaSetDevice(GpuNum[0]);
	dMat = (float*)HMat[GpuNum[0]];
	cudaMemcpyAsync(dMat,Mat,MatMem,cudaMemcpyHostToDevice);

	Error0 = cudaGetErrorString(cudaGetLastError());
	strcpy(Error,Error0);
	cudaDeviceSynchronize();		
}

///==========================================================
/// ArrLoadSglOneAsyncC
///==========================================================
void ArrLoadSglOneAsyncC(size_t *GpuNum, float *Mat, size_t *HMat, size_t *ArrSz, char *Error){
	const char* Error0; 
	float *dMat;
	size_t MatMem = sizeof(float)*ArrSz[0]*2;
    
    cudaSetDevice(GpuNum[0]);
	dMat = (float*)HMat[GpuNum[0]];
	cudaMemcpyAsync(dMat,Mat,MatMem,cudaMemcpyHostToDevice);

	Error0 = cudaGetErrorString(cudaGetLastError());
	strcpy(Error,Error0);	
}

///==========================================================
/// ArrReturnSglOne
///==========================================================
void ArrReturnSglOne(size_t *GpuNum, float *Mat, size_t *HMat, size_t *ArrSz, char *Error){
	const char* Error0; 
	float *dMat;
	size_t MatMem = sizeof(float)*ArrSz[0];
	
    cudaSetDevice(GpuNum[0]);
    dMat = (float*)HMat[GpuNum[0]];
    cudaMemcpyAsync(Mat,dMat,MatMem,cudaMemcpyDeviceToHost);
	
	Error0 = cudaGetErrorString(cudaGetLastError());
	strcpy(Error,Error0);
	cudaDeviceSynchronize();				
	}

///==========================================================
/// ArrReturnSglOneC
///==========================================================
void ArrReturnSglOneC(size_t *GpuNum, float *Mat, size_t *HMat, size_t *ArrSz, char *Error){
	const char* Error0; 
	float *dMat;
	size_t MatMem = sizeof(float)*ArrSz[0]*2;
	
    cudaSetDevice(GpuNum[0]);
    dMat = (float*)HMat[GpuNum[0]];
    cudaMemcpyAsync(Mat,dMat,MatMem,cudaMemcpyDeviceToHost);
	
	Error0 = cudaGetErrorString(cudaGetLastError());
	strcpy(Error,Error0);
	cudaDeviceSynchronize();		
}

///==========================================================
/// ArrReturnSglOneAsyncC
///==========================================================
void ArrReturnSglOneAsyncC(size_t *GpuNum, float *Mat, size_t *HMat, size_t *ArrSz, char *Error){
	const char* Error0; 
	float *dMat;
	size_t MatMem = sizeof(float)*ArrSz[0]*2;
	
    cudaSetDevice(GpuNum[0]);
    dMat = (float*)HMat[GpuNum[0]];
    cudaMemcpyAsync(Mat,dMat,MatMem,cudaMemcpyDeviceToHost);
	
	Error0 = cudaGetErrorString(cudaGetLastError());
	strcpy(Error,Error0);	
}

///==========================================================
/// ArrReturnSglAll
///==========================================================
void ArrReturnSglAll(size_t *GpuTot, float *Mat, size_t *HMat, size_t *ArrSz, char *Error){
	const char* Error0; 
	float *dMat;
	size_t MatMem = sizeof(float)*ArrSz[0];
	
	for(int n=0;n<GpuTot[0];n++){
		cudaSetDevice(n);
		dMat = (float*)HMat[n];
		cudaMemcpyAsync(Mat,dMat,MatMem,cudaMemcpyDeviceToHost);
	}
    	
	Error0 = cudaGetErrorString(cudaGetLastError());
	strcpy(Error,Error0);
	cudaDeviceSynchronize();				
	}

///==========================================================
/// ArrReturnSglAllC
///==========================================================
void ArrReturnSglAllC(size_t *GpuTot, float *Mat, size_t *HMat, size_t *ArrSz, char *Error){
	const char* Error0; 
	float *dMat;
	size_t MatMem = sizeof(float)*ArrSz[0]*2;
	
	for(int n=0;n<GpuTot[0];n++){
		cudaSetDevice(n);
		dMat = (float*)HMat[n];
		cudaMemcpyAsync(Mat,dMat,MatMem,cudaMemcpyDeviceToHost);
	}
    	
	Error0 = cudaGetErrorString(cudaGetLastError());
	strcpy(Error,Error0);
	cudaDeviceSynchronize();				
	}



