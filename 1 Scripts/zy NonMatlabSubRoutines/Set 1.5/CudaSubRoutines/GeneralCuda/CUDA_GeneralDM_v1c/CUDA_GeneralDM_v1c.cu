///==========================================================
/// (v1c)
///		- Recompile with CUDA 9.0 (compute 6.1)
///==========================================================

extern "C" void CUDAcount(int *Count, char *Error);
//extern "C" void CUDAselect(int device, char *Error);
//extern "C" void CUDAreset(char *Error);

extern "C" void ArrAllocDbl(int Count, size_t *HMat, int ArrSz, size_t *Tst, char *Error);
extern "C" void ArrAllocDblC(int Count, size_t *HMat, int ArrSz, size_t *Tst, char *Error);
extern "C" void ArrInitDbl(int Count, size_t *HMat, int ArrSz, char *Error);
extern "C" void ArrInitDblC(int Count, size_t *HMat, int ArrSz, char *Error);
extern "C" void ArrFreeDbl(int Count, size_t *HMat, char *Error);
extern "C" void ArrFreeDblC(int Count, size_t *HMat, char *Error);
extern "C" void ArrLoadDbl(int Count, double *Mat, size_t *HMat, int ArrSz, char *Error);
extern "C" void ArrLoadDblC(int Count, double *Mat, size_t *HMat, int ArrSz, char *Error);
extern "C" void ArrReturnDbl(int Count, double *Mat, size_t *HMat, int ArrSz, char *Error);
extern "C" void ArrReturnDblC(int Count, double *Mat, size_t *HMat, int ArrSz, char *Error);

extern "C" void Mat3DAllocDbl(int Count, size_t *HMat, int MatSz, size_t *Tst, char *Error);
extern "C" void Mat3DAllocDblC(int Count, size_t *HMat, int MatSz, size_t *Tst, char *Error);
extern "C" void Mat3DInitDbl(int Count, size_t *HMat, int MatSz, char *Error);
extern "C" void Mat3DInitDblC(int Count, size_t *HMat, int MatSz, char *Error);
extern "C" void Mat3DFreeDbl(int Count,size_t *HMat, char *Error);
extern "C" void Mat3DFreeDblC(int Count, size_t *HMat, char *Error);
extern "C" void Mat3DLoadDbl(int Count, double *Mat, size_t *HMat, int MatSz, char *Error);
extern "C" void Mat3DLoadDblC(int Count, double *Mat, size_t *HMat, int MatSz, char *Error);
extern "C" void Mat3DReturnDbl(int Count, double *Mat, size_t *HMat, int MatSz, char *Error);
extern "C" void Mat3DReturnDblC(int Count, double *Mat, size_t *HMat, int MatSz, char *Error);

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
/// ArrAllocDbl
///==========================================================
void ArrAllocDbl(int Count, size_t *HMat, int ArrSz, size_t *Tst, char *Error){
	const char* Error0; 
	double *dMat;
	size_t free,total;
	size_t MatMem = sizeof(double)*ArrSz;
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
/// ArrAllocDblC
///==========================================================
void ArrAllocDblC(int Count, size_t *HMat, int ArrSz, size_t *Tst, char *Error){
	const char* Error0; 
	double *dMat;
	size_t free,total;
	size_t MatMem = sizeof(double)*ArrSz*2;
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
/// ArrInitDbl
///==========================================================
void ArrInitDbl(int Count, size_t *HMat, int ArrSz, char *Error){
	const char* Error0; 
	double *dMat;
	size_t MatMem = sizeof(double)*ArrSz;
	for(int n=0;n<Count;n++){
		cudaSetDevice(n);
		dMat = (double*)HMat[n];
		cudaMemsetAsync(dMat,0,MatMem);
	}
	Error0 = cudaGetErrorString(cudaGetLastError());
	strcpy(Error,Error0);
	cudaDeviceSynchronize();		
}

///==========================================================
/// ArrInitDblC
///==========================================================
void ArrInitDblC(int Count, size_t *HMat, int ArrSz, char *Error){
	const char* Error0; 
	double *dMat;
	size_t MatMem = sizeof(double)*ArrSz*2;
	for(int n=0;n<Count;n++){
		cudaSetDevice(n);
		dMat = (double*)HMat[n];
		cudaMemsetAsync(dMat,0,MatMem);
	}
	Error0 = cudaGetErrorString(cudaGetLastError());
	strcpy(Error,Error0);
	cudaDeviceSynchronize();		
}

///==========================================================
/// ArrFreeDbl
///==========================================================
void ArrFreeDbl(int Count, size_t *HMat, char *Error){
	const char* Error0; 
	double *dMat;
	for(int n=0;n<Count;n++){
		cudaSetDevice(n);
		dMat = (double*)HMat[n];
		cudaFree(dMat);
	}
	Error0 = cudaGetErrorString(cudaGetLastError());
	strcpy(Error,Error0);
	cudaDeviceSynchronize();	
}

///==========================================================
/// ArrFreeDblC
///==========================================================
void ArrFreeDblC(int Count, size_t *HMat, char *Error){
	const char* Error0; 
	double *dMat;
	for(int n=0;n<Count;n++){
		cudaSetDevice(n);
		dMat = (double*)HMat[n];
		cudaFree(dMat);
	}
	Error0 = cudaGetErrorString(cudaGetLastError());
	strcpy(Error,Error0);
	cudaDeviceSynchronize();	
}

///==========================================================
/// ArrLoadDbl
///==========================================================
void ArrLoadDbl(int Count, double *Mat, size_t *HMat, int ArrSz, char *Error){
	const char* Error0; 
	double *dMat;
	size_t MatMem = sizeof(double)*ArrSz;
	for(int n=0;n<Count;n++){
		cudaSetDevice(n);
		dMat = (double*)HMat[n];
		cudaMemcpyAsync(dMat,Mat,MatMem,cudaMemcpyHostToDevice);
	}
	Error0 = cudaGetErrorString(cudaGetLastError());
	strcpy(Error,Error0);
	cudaDeviceSynchronize();	
}

///==========================================================
/// ArrLoadDblC
///==========================================================
void ArrLoadDblC(int Count, double *Mat, size_t *HMat, int ArrSz, char *Error){
	const char* Error0; 
	double *dMat;
	size_t MatMem = sizeof(double)*ArrSz*2;
	for(int n=0;n<Count;n++){
		cudaSetDevice(n);
		dMat = (double*)HMat[n];
		cudaMemcpyAsync(dMat,Mat,MatMem,cudaMemcpyHostToDevice);
	}
	Error0 = cudaGetErrorString(cudaGetLastError());
	strcpy(Error,Error0);
	cudaDeviceSynchronize();		
}

///==========================================================
/// ArrReturnDbl
///==========================================================
void ArrReturnDbl(int Count, double *Mat, size_t *HMat, int ArrSz, char *Error){
	const char* Error0; 
	double *dMat;
	size_t MatMem = sizeof(double)*ArrSz;
	
    cudaSetDevice(Count);
    dMat = (double*)HMat[Count];
    cudaMemcpyAsync(Mat,dMat,MatMem,cudaMemcpyDeviceToHost);
	
	Error0 = cudaGetErrorString(cudaGetLastError());
	strcpy(Error,Error0);
	cudaDeviceSynchronize();				
	}

///==========================================================
/// ArrReturnDblC
///==========================================================
void ArrReturnDblC(int Count, double *Mat, size_t *HMat, int ArrSz, char *Error){
	const char* Error0; 
	double *dMat;
	size_t MatMem = sizeof(double)*ArrSz*2;
	
    cudaSetDevice(Count);
    dMat = (double*)HMat[Count];
    cudaMemcpyAsync(Mat,dMat,MatMem,cudaMemcpyDeviceToHost);
	
	Error0 = cudaGetErrorString(cudaGetLastError());
	strcpy(Error,Error0);
	cudaDeviceSynchronize();		
}


///==========================================================
/// Mat3DAllocDbl
///==========================================================
void Mat3DAllocDbl(int Count, size_t *HMat, int MatSz, size_t *Tst, char *Error){
	const char* Error0; 
	double *dMat;
	size_t free,total;
	size_t MatMem = sizeof(double)*MatSz*MatSz*MatSz;
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
/// Mat3DAllocDblC
///==========================================================
void Mat3DAllocDblC(int Count, size_t *HMat, int MatSz, size_t *Tst, char *Error){
	const char* Error0; 
	double *dMat;
	size_t free,total;
	size_t MatMem = sizeof(double)*MatSz*MatSz*MatSz*2;
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
/// Mat3DInitDbl
///==========================================================
void Mat3DInitDbl(int Count, size_t *HMat, int MatSz, char *Error){
	const char* Error0; 
	double *dMat;
	size_t MatMem = sizeof(double)*MatSz*MatSz*MatSz;
	for(int n=0;n<Count;n++){
		cudaSetDevice(n);
		dMat = (double*)HMat[n];
		cudaMemsetAsync(dMat,0,MatMem);
	}
	Error0 = cudaGetErrorString(cudaGetLastError());
	strcpy(Error,Error0);
	cudaDeviceSynchronize();		
}

///==========================================================
/// Mat3DInitDblC
///==========================================================
void Mat3DInitDblC(int Count, size_t *HMat, int MatSz, char *Error){
	const char* Error0; 
	double *dMat;
	size_t MatMem = sizeof(double)*MatSz*MatSz*MatSz*2;
	for(int n=0;n<Count;n++){
		cudaSetDevice(n);
		dMat = (double*)HMat[n];
		cudaMemsetAsync(dMat,0,MatMem);
	}
	Error0 = cudaGetErrorString(cudaGetLastError());
	strcpy(Error,Error0);
	cudaDeviceSynchronize();		
}

///==========================================================
/// Mat3DFreeDbl
///==========================================================
void Mat3DFreeDbl(int Count, size_t *HMat, char *Error){
	const char* Error0; 
	double *dMat;
	for(int n=0;n<Count;n++){
		cudaSetDevice(n);
		dMat = (double*)HMat[n];
		cudaFree(dMat);
	}
	Error0 = cudaGetErrorString(cudaGetLastError());
	strcpy(Error,Error0);
	cudaDeviceSynchronize();		
}

///==========================================================
/// Mat3DFreeDblC
///==========================================================
void Mat3DFreeDblC(int Count, size_t *HMat, char *Error){
	const char* Error0; 
	double *dMat;
	for(int n=0;n<Count;n++){
		cudaSetDevice(n);
		dMat = (double*)HMat[n];
		cudaFree(dMat);
	}
	Error0 = cudaGetErrorString(cudaGetLastError());
	strcpy(Error,Error0);
	cudaDeviceSynchronize();		
}

///==========================================================
/// Mat3DLoadDbl
///==========================================================
void Mat3DLoadDbl(int Count, double *Mat, size_t *HMat, int MatSz, char *Error){
	const char* Error0; 
	double *dMat;
	size_t MatMem = sizeof(double)*MatSz*MatSz*MatSz;
	for(int n=0;n<Count;n++){
		cudaSetDevice(n);
		dMat = (double*)HMat[n];
		cudaMemcpyAsync(dMat,Mat,MatMem,cudaMemcpyHostToDevice);
	}
	Error0 = cudaGetErrorString(cudaGetLastError());
	strcpy(Error,Error0);
	cudaDeviceSynchronize();		
}

///==========================================================
/// Mat3DLoadDblC
///==========================================================
void Mat3DLoadDblC(int Count, double *Mat, size_t *HMat, int MatSz, char *Error){
	const char* Error0; 
	double *dMat;
	size_t MatMem = sizeof(double)*MatSz*MatSz*MatSz*2;
	for(int n=0;n<Count;n++){
		cudaSetDevice(n);
		dMat = (double*)HMat[n];
		cudaMemcpyAsync(dMat,Mat,MatMem,cudaMemcpyHostToDevice);
	}
	Error0 = cudaGetErrorString(cudaGetLastError());
	strcpy(Error,Error0);
	cudaDeviceSynchronize();		
}

///==========================================================
/// Mat3DReturnDbl
///==========================================================
void Mat3DReturnDbl(int Count, double *Mat, size_t *HMat, int MatSz, char *Error){
	const char* Error0; 
	double *dMat;
	size_t MatMem = sizeof(double)*MatSz*MatSz*MatSz;

    cudaSetDevice(Count);
    dMat = (double*)HMat[Count];
    cudaMemcpyAsync(Mat,dMat,MatMem,cudaMemcpyDeviceToHost);

	Error0 = cudaGetErrorString(cudaGetLastError());
	strcpy(Error,Error0);
	cudaDeviceSynchronize();		
}

///==========================================================
/// Mat3DReturnDblC
///==========================================================
void Mat3DReturnDblC(int Count, double *Mat, size_t *HMat, int MatSz, char *Error){
	const char* Error0; 
	double *dMat;
	size_t MatMem = sizeof(double)*MatSz*MatSz*MatSz*2;

    cudaSetDevice(Count);
    dMat = (double*)HMat[Count];
    cudaMemcpyAsync(Mat,dMat,MatMem,cudaMemcpyDeviceToHost);

	Error0 = cudaGetErrorString(cudaGetLastError());
	strcpy(Error,Error0);
	cudaDeviceSynchronize();		
}
