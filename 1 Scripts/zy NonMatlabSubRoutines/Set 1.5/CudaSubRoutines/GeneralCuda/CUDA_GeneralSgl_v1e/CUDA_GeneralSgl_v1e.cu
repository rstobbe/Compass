///==========================================================
/// (v1e)
///		- Renaming to make sense
///     - Drop Mat
///     - SampDat Copy
///==========================================================

extern "C" void CUDAcount(int *Count, char *Error);
extern "C" void ArrAllocSglAll(size_t *Count, size_t *HMat, size_t *ArrSz, char *Error);
extern "C" void ArrAllocSglAllC(size_t *Count, size_t *HMat, size_t *ArrSz, char *Error);
extern "C" void ArrInitSglAll(size_t *Count, size_t *HMat, size_t *ArrSz, char *Error);
extern "C" void ArrInitSglAllC(size_t *Count, size_t *HMat, size_t *ArrSz, char *Error);
extern "C" void ArrFreeSglAll(size_t *Count, size_t *HMat, char *Error);
extern "C" void ArrFreeSglAllC(size_t *Count, size_t *HMat, char *Error);
extern "C" void ArrLoadSglAll(size_t *Count, float *Mat, size_t *HMat, size_t *ArrSz, char *Error);
extern "C" void ArrLoadSglAllC(size_t *Count, float *Mat, size_t *HMat, size_t *ArrSz, char *Error);
extern "C" void ArrLoadSglOne(size_t *Count, float *Mat, size_t *HMat, size_t *ArrSz, size_t *ProjInc, char *Error);
extern "C" void ArrLoadSglOneC(size_t *Count, float *Mat, size_t *HMat, size_t *ArrSz, size_t *ProjInc, char *Error);
extern "C" void ArrReturnSglOne(size_t *Count, float *Mat, size_t *HMat, size_t *ArrSz, char *Error);
extern "C" void ArrReturnSglOneC(size_t *Count, float *Mat, size_t *HMat, size_t *ArrSz, char *Error);
extern "C" void SampDatLoadSglAllC(size_t *Count, float *Mat, size_t *HMat, size_t *DataInfo, char *Error);

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
/// ArrAllocSglAll
///==========================================================
void ArrAllocSglAll(size_t *Count, size_t *HMat, size_t *ArrSz, char *Error){
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
/// ArrAllocSglAllC
///==========================================================
void ArrAllocSglAllC(size_t *Count, size_t *HMat, size_t *ArrSz, char *Error){
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
/// ArrInitSglAll
///==========================================================
void ArrInitSglAll(size_t *Count, size_t *HMat, size_t *ArrSz, char *Error){
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
/// ArrInitSglAllC
///==========================================================
void ArrInitSglAllC(size_t *Count, size_t *HMat, size_t *ArrSz, char *Error){
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
/// ArrFreeSglAll
///==========================================================
void ArrFreeSglAll(size_t *Count, size_t *HMat, char *Error){
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
/// ArrFreeSglAllC
///==========================================================
void ArrFreeSglAllC(size_t *Count, size_t *HMat, char *Error){
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
/// ArrLoadSglAll
///==========================================================
void ArrLoadSglAll(size_t *Count, float *Mat, size_t *HMat, size_t *ArrSz, char *Error){
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
/// ArrLoadSglAllC
///==========================================================
void ArrLoadSglAllC(size_t *Count, float *Mat, size_t *HMat, size_t *ArrSz, char *Error){
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
/// ArrLoadSglOne
///==========================================================
void ArrLoadSglOne(size_t *Count, float *Mat, size_t *HMat, size_t *ArrSz, size_t *ProjInc, char *Error){
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
/// ArrLoadSglOneC
///==========================================================
void ArrLoadSglOneC(size_t *Count, float *Mat, size_t *HMat, size_t *ArrSz, size_t *ProjInc, char *Error){
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
/// ArrReturnSglOne
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
/// ArrReturnSglOneC
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
/// SampDatLoadSglAllC
///     DatInfo
///         0) Nro
///         1) Nrcvr
///         2) Nproj    (number of projections in chunk)
///         3) Sro      (start)
///         4) Srcvr
///         5) Sproj
///==========================================================
void SampDatLoadSglAllC(size_t *Count, float *Mat, size_t *HMat, size_t *DataInfo, char *Error){
	const char* Error0; 
	float *dMat;
	size_t MatMem = sizeof(float)*DataInfo[0]*2;
    for(int m=DataInfo[5];m<DataInfo[2];m++){
        for(int n=0;n<Count[0];n++){
            cudaSetDevice(n);
            Mat = Mat + ((DataInfo[4]+n)*DataInfo[0] + m*DataInfo[0]*DataInfo[1] + DataInfo[3])*2; 
            dMat = (float*)HMat[n] + m*DataInfo[0]*2;
            cudaMemcpyAsync(dMat,Mat,MatMem,cudaMemcpyHostToDevice);
        }
    }
	Error0 = cudaGetErrorString(cudaGetLastError());
	strcpy(Error,Error0);
	cudaDeviceSynchronize();		
}


