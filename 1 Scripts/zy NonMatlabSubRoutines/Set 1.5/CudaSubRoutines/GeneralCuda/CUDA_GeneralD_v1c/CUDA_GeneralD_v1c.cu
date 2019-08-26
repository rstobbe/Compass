///==========================================================
/// (v1c)
///		- Recompile with CUDA 9.0
///==========================================================

extern "C" void ArrAllocDbl(size_t *HMat, int ArrSz, size_t *Tst, char *Error);
extern "C" void ArrAllocDblC(size_t *HMat, int ArrSz, size_t *Tst, char *Error);
extern "C" void ArrInitDbl(size_t *HMat, int ArrSz, char *Error);
extern "C" void ArrInitDblC(size_t *HMat, int ArrSz, char *Error);
extern "C" void ArrFreeDbl(size_t *HMat, char *Error);
extern "C" void ArrFreeDblC(size_t *HMat, char *Error);
extern "C" void ArrLoadDbl(double *Mat, size_t *HMat, int ArrSz, char *Error);
extern "C" void ArrLoadDblC(double *Mat, size_t *HMat, int ArrSz, char *Error);
extern "C" void ArrReturnDbl(double *Mat, size_t *HMat, int ArrSz, char *Error);
extern "C" void ArrReturnDblC(double *Mat, size_t *HMat, int ArrSz, char *Error);

extern "C" void Mat3DAllocDbl(size_t *HMat, int MatSz, size_t *Tst, char *Error);
extern "C" void Mat3DAllocDblC(size_t *HMat, int MatSz, size_t *Tst, char *Error);
extern "C" void Mat3DInitDbl(size_t *HMat, int MatSz, char *Error);
extern "C" void Mat3DInitDblC(size_t *HMat, int MatSz, char *Error);
extern "C" void Mat3DFreeDbl(size_t *HMat, char *Error);
extern "C" void Mat3DFreeDblC(size_t *HMat, char *Error);
extern "C" void Mat3DLoadDbl(double *Mat, size_t *HMat, int MatSz, char *Error);
extern "C" void Mat3DLoadDblC(double *Mat, size_t *HMat, int MatSz, char *Error);
extern "C" void Mat3DReturnDbl(double *Mat, size_t *HMat, int MatSz, char *Error);
extern "C" void Mat3DReturnDblC(double *Mat, size_t *HMat, int MatSz, char *Error);

///==========================================================
/// ArrAllocDbl
///==========================================================
void ArrAllocDbl(size_t *HMat, int ArrSz, size_t *Tst, char *Error){
	const char* Error0; 
	double *dMat;
	size_t free,total;
	size_t MatMem = sizeof(double)*ArrSz;
	cudaMalloc(&dMat,MatMem);
	*HMat = (size_t)dMat;
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
void ArrAllocDblC(size_t *HMat, int ArrSz, size_t *Tst, char *Error){
	const char* Error0; 
	double *dMat;
	size_t free,total;
	size_t MatMem = sizeof(double)*ArrSz*2;
	cudaMalloc(&dMat,MatMem);
	*HMat = (size_t)dMat;
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
void ArrInitDbl(size_t *HMat, int ArrSz, char *Error){
	const char* Error0; 
	double *dMat;
	size_t MatMem = sizeof(double)*ArrSz;
	dMat = (double*)*HMat;
	cudaMemset(dMat,0,MatMem);
	Error0 = cudaGetErrorString(cudaGetLastError());
	strcpy(Error,Error0);
	cudaDeviceSynchronize();		
}

///==========================================================
/// ArrInitDblC
///==========================================================
void ArrInitDblC(size_t *HMat, int ArrSz, char *Error){
	const char* Error0; 
	double *dMat;
	size_t MatMem = sizeof(double)*ArrSz*2;
	dMat = (double*)*HMat;
	cudaMemset(dMat,0,MatMem);
	Error0 = cudaGetErrorString(cudaGetLastError());
	strcpy(Error,Error0);
	cudaDeviceSynchronize();		
}

///==========================================================
/// ArrFreeDbl
///==========================================================
void ArrFreeDbl(size_t *HMat, char *Error){
	const char* Error0; 
	double *dMat;
	dMat = (double*)*HMat;
	cudaFree(dMat);
	Error0 = cudaGetErrorString(cudaGetLastError());
	strcpy(Error,Error0);
	cudaDeviceSynchronize();	
}

///==========================================================
/// ArrFreeDblC
///==========================================================
void ArrFreeDblC(size_t *HMat, char *Error){
	const char* Error0; 
	double *dMat;
	dMat = (double*)*HMat;
	cudaFree(dMat);
	Error0 = cudaGetErrorString(cudaGetLastError());
	strcpy(Error,Error0);
	cudaDeviceSynchronize();	
}

///==========================================================
/// ArrLoadDbl
///==========================================================
void ArrLoadDbl(double *Mat, size_t *HMat, int ArrSz, char *Error){
	const char* Error0; 
	double *dMat;
	size_t MatMem = sizeof(double)*ArrSz;
	dMat = (double*)*HMat;
	cudaMemcpy(dMat,Mat,MatMem,cudaMemcpyHostToDevice);
	Error0 = cudaGetErrorString(cudaGetLastError());
	strcpy(Error,Error0);
	cudaDeviceSynchronize();	
}

///==========================================================
/// ArrLoadDblC
///==========================================================
void ArrLoadDblC(double *Mat, size_t *HMat, int ArrSz, char *Error){
	const char* Error0; 
	double *dMat;
	size_t MatMem = sizeof(double)*ArrSz*2;
	dMat = (double*)*HMat;
	cudaMemcpy(dMat,Mat,MatMem,cudaMemcpyHostToDevice);
	Error0 = cudaGetErrorString(cudaGetLastError());
	strcpy(Error,Error0);
	cudaDeviceSynchronize();		
}

///==========================================================
/// ArrReturnDbl
///==========================================================
void ArrReturnDbl(double *Mat, size_t *HMat, int ArrSz, char *Error){
	const char* Error0; 
	double *dMat;
	size_t MatMem = sizeof(double)*ArrSz;
	dMat = (double*)*HMat;
	cudaMemcpy(Mat,dMat,MatMem,cudaMemcpyDeviceToHost);
	Error0 = cudaGetErrorString(cudaGetLastError());
	strcpy(Error,Error0);
	cudaDeviceSynchronize();		
}

///==========================================================
/// ArrReturnDblC
///==========================================================
void ArrReturnDblC(double *Mat, size_t *HMat, int ArrSz, char *Error){
	const char* Error0; 
	double *dMat;
	size_t MatMem = sizeof(double)*ArrSz*2;
	dMat = (double*)*HMat;
	cudaMemcpy(Mat,dMat,MatMem,cudaMemcpyDeviceToHost);
	Error0 = cudaGetErrorString(cudaGetLastError());
	strcpy(Error,Error0);
	cudaDeviceSynchronize();		
}


///==========================================================
/// Mat3DAllocDbl
///==========================================================
void Mat3DAllocDbl(size_t *HMat, int MatSz, size_t *Tst, char *Error){
	const char* Error0; 
	double *dMat;
	size_t free,total;
	size_t MatMem = sizeof(double)*MatSz*MatSz*MatSz;
	cudaMalloc(&dMat,MatMem);
	*HMat = (size_t)dMat;
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
void Mat3DAllocDblC(size_t *HMat, int MatSz, size_t *Tst, char *Error){
	const char* Error0; 
	double *dMat;
	size_t free,total;
	size_t MatMem = sizeof(double)*MatSz*MatSz*MatSz*2;
	cudaMalloc(&dMat,MatMem);
	*HMat = (size_t)dMat;
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
void Mat3DInitDbl(size_t *HMat, int MatSz, char *Error){
	const char* Error0; 
	double *dMat;
	size_t MatMem = sizeof(double)*MatSz*MatSz*MatSz;
	dMat = (double*)*HMat;
	cudaMemset(dMat,0,MatMem);
	Error0 = cudaGetErrorString(cudaGetLastError());
	strcpy(Error,Error0);
	cudaDeviceSynchronize();		
}

///==========================================================
/// Mat3DInitDblC
///==========================================================
void Mat3DInitDblC(size_t *HMat, int MatSz, char *Error){
	const char* Error0; 
	double *dMat;
	size_t MatMem = sizeof(double)*MatSz*MatSz*MatSz*2;
	dMat = (double*)*HMat;
	cudaMemset(dMat,0,MatMem);
	Error0 = cudaGetErrorString(cudaGetLastError());
	strcpy(Error,Error0);
	cudaDeviceSynchronize();		
}

///==========================================================
/// Mat3DFreeDbl
///==========================================================
void Mat3DFreeDbl(size_t *HMat, char *Error){
	const char* Error0; 
	double *dMat;
	dMat = (double*)*HMat;
	cudaFree(dMat);
	Error0 = cudaGetErrorString(cudaGetLastError());
	strcpy(Error,Error0);
	cudaDeviceSynchronize();		
}

///==========================================================
/// Mat3DFreeDblC
///==========================================================
void Mat3DFreeDblC(size_t *HMat, char *Error){
	const char* Error0; 
	double *dMat;
	dMat = (double*)*HMat;
	cudaFree(dMat);
	Error0 = cudaGetErrorString(cudaGetLastError());
	strcpy(Error,Error0);
	cudaDeviceSynchronize();		
}

///==========================================================
/// Mat3DLoadDbl
///==========================================================
void Mat3DLoadDbl(double *Mat, size_t *HMat, int MatSz, char *Error){
	const char* Error0; 
	double *dMat;
	size_t MatMem = sizeof(double)*MatSz*MatSz*MatSz;
	dMat = (double*)*HMat;
	cudaMemcpy(dMat,Mat,MatMem,cudaMemcpyHostToDevice);
	Error0 = cudaGetErrorString(cudaGetLastError());
	strcpy(Error,Error0);
	cudaDeviceSynchronize();		
}

///==========================================================
/// Mat3DLoadDblC
///==========================================================
void Mat3DLoadDblC(double *Mat, size_t *HMat, int MatSz, char *Error){
	const char* Error0; 
	double *dMat;
	size_t MatMem = sizeof(double)*MatSz*MatSz*MatSz*2;
	dMat = (double*)*HMat;
	cudaMemcpy(dMat,Mat,MatMem,cudaMemcpyHostToDevice);
	Error0 = cudaGetErrorString(cudaGetLastError());
	strcpy(Error,Error0);
	cudaDeviceSynchronize();		
}

///==========================================================
/// Mat3DReturnDbl
///==========================================================
void Mat3DReturnDbl(double *Mat, size_t *HMat, int MatSz, char *Error){
	const char* Error0; 
	double *dMat;
	size_t MatMem = sizeof(double)*MatSz*MatSz*MatSz;
	dMat = (double*)*HMat;
	cudaMemcpy(Mat,dMat,MatMem,cudaMemcpyDeviceToHost);
	Error0 = cudaGetErrorString(cudaGetLastError());
	strcpy(Error,Error0);
	cudaDeviceSynchronize();		
}

///==========================================================
/// Mat3DReturnDblC
///==========================================================
void Mat3DReturnDblC(double *Mat, size_t *HMat, int MatSz, char *Error){
	const char* Error0; 
	double *dMat;
	size_t MatMem = sizeof(double)*MatSz*MatSz*MatSz*2;
	dMat = (double*)*HMat;
	cudaMemcpy(Mat,dMat,MatMem,cudaMemcpyDeviceToHost);
	Error0 = cudaGetErrorString(cudaGetLastError());
	strcpy(Error,Error0);
	cudaDeviceSynchronize();		
}
