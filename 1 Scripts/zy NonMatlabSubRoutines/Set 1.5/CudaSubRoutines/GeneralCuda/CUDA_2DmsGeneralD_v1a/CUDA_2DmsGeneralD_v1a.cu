///==========================================================
/// (v1a)
///		- 
///==========================================================

extern "C" void ArrMSAllocDbl(size_t *HMat, int ArrSz, int nVols, size_t *Tst, char *Error);
extern "C" void ArrMSAllocDblC(size_t *HMat, int ArrSz, int nVols, size_t *Tst, char *Error);
extern "C" void ArrMSInitDbl(size_t *HMat, int ArrSz, int nVols, char *Error);
extern "C" void ArrMSInitDblC(size_t *HMat, int ArrSz, int nVols, char *Error);
extern "C" void ArrMSFreeDbl(size_t *HMat, char *Error);
extern "C" void ArrMSFreeDblC(size_t *HMat, char *Error);
extern "C" void ArrMSLoadDbl(double *Mat, size_t *HMat, int ArrSz, int nVols, char *Error);
extern "C" void ArrMSLoadDblC(double *Mat, size_t *HMat, int ArrSz, int nVols, char *Error);
extern "C" void ArrMSReturnDbl(double *Mat, size_t *HMat, int ArrSz, int nVols, char *Error);
extern "C" void ArrMSReturnDblC(double *Mat, size_t *HMat, int ArrSz, int nVols, char *Error);

extern "C" void Mat2DMSAllocDbl(size_t *HMat, int MatSz, int nVols, size_t *Tst, char *Error);
extern "C" void Mat2DMSAllocDblC(size_t *HMat, int MatSz, int nVols, size_t *Tst, char *Error);
extern "C" void Mat2DMSInitDbl(size_t *HMat, int MatSz, int nVols, char *Error);
extern "C" void Mat2DMSInitDblC(size_t *HMat, int MatSz, int nVols, char *Error);
extern "C" void Mat2DMSFreeDbl(size_t *HMat, char *Error);
extern "C" void Mat2DMSFreeDblC(size_t *HMat, char *Error);
extern "C" void Mat2DMSLoadDbl(double *Mat, size_t *HMat, int MatSz, int nVols, char *Error);
extern "C" void Mat2DMSLoadDblC(double *Mat, size_t *HMat, int MatSz, int nVols, char *Error);
extern "C" void Mat2DMSReturnDbl(double *Mat, size_t *HMat, int MatSz, int nVols, char *Error);
extern "C" void Mat2DMSReturnDblC(double *Mat, size_t *HMat, int MatSz, int nVols, char *Error);

///==========================================================
/// ArrAllocDbl
///==========================================================
void ArrMSAllocDbl(size_t *HMat, int ArrSz, int nVols, size_t *Tst, char *Error){
	const char* Error0; 
	double *dMat;
	size_t free,total;
	size_t MatMem = sizeof(double)*ArrSz*nVols;
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
void ArrMSAllocDblC(size_t *HMat, int ArrSz, int nVols, size_t *Tst, char *Error){
	const char* Error0; 
	double *dMat;
	size_t free,total;
	size_t MatMem = sizeof(double)*ArrSz*nVols*2;
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
void ArrMSInitDbl(size_t *HMat, int ArrSz, int nVols, char *Error){
	const char* Error0; 
	double *dMat;
	size_t MatMem = sizeof(double)*ArrSz*nVols;
	dMat = (double*)*HMat;
	cudaMemset(dMat,0,MatMem);
	Error0 = cudaGetErrorString(cudaGetLastError());
	strcpy(Error,Error0);
	cudaDeviceSynchronize();		
}

///==========================================================
/// ArrInitDblC
///==========================================================
void ArrMSInitDblC(size_t *HMat, int ArrSz, int nVols, char *Error){
	const char* Error0; 
	double *dMat;
	size_t MatMem = sizeof(double)*ArrSz*nVols*2;
	dMat = (double*)*HMat;
	cudaMemset(dMat,0,MatMem);
	Error0 = cudaGetErrorString(cudaGetLastError());
	strcpy(Error,Error0);
	cudaDeviceSynchronize();		
}

///==========================================================
/// ArrFreeDbl
///==========================================================
void ArrMSFreeDbl(size_t *HMat, char *Error){
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
void ArrMSFreeDblC(size_t *HMat, char *Error){
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
void ArrMSLoadDbl(double *Mat, size_t *HMat, int ArrSz, int nVols, char *Error){
	const char* Error0; 
	double *dMat;
	size_t MatMem = sizeof(double)*ArrSz*nVols;
	dMat = (double*)*HMat;
	cudaMemcpy(dMat,Mat,MatMem,cudaMemcpyHostToDevice);
	Error0 = cudaGetErrorString(cudaGetLastError());
	strcpy(Error,Error0);
	cudaDeviceSynchronize();	
}

///==========================================================
/// ArrLoadDblC
///==========================================================
void ArrMSLoadDblC(double *Mat, size_t *HMat, int ArrSz, int nVols, char *Error){
	const char* Error0; 
	double *dMat;
	size_t MatMem = sizeof(double)*ArrSz*nVols*2;
	dMat = (double*)*HMat;
	cudaMemcpy(dMat,Mat,MatMem,cudaMemcpyHostToDevice);
	Error0 = cudaGetErrorString(cudaGetLastError());
	strcpy(Error,Error0);
	cudaDeviceSynchronize();		
}

///==========================================================
/// ArrReturnDbl
///==========================================================
void ArrMSReturnDbl(double *Mat, size_t *HMat, int ArrSz, int nVols, char *Error){
	const char* Error0; 
	double *dMat;
	size_t MatMem = sizeof(double)*ArrSz*nVols;
	dMat = (double*)*HMat;
	cudaMemcpy(Mat,dMat,MatMem,cudaMemcpyDeviceToHost);
	Error0 = cudaGetErrorString(cudaGetLastError());
	strcpy(Error,Error0);
	cudaDeviceSynchronize();		
}

///==========================================================
/// ArrReturnDblC
///==========================================================
void ArrMSReturnDblC(double *Mat, size_t *HMat, int ArrSz, int nVols, char *Error){
	const char* Error0; 
	double *dMat;
	size_t MatMem = sizeof(double)*ArrSz*nVols*2;
	dMat = (double*)*HMat;
	cudaMemcpy(Mat,dMat,MatMem,cudaMemcpyDeviceToHost);
	Error0 = cudaGetErrorString(cudaGetLastError());
	strcpy(Error,Error0);
	cudaDeviceSynchronize();		
}


///==========================================================
/// Mat2DAllocDbl
///==========================================================
void Mat2DMSAllocDbl(size_t *HMat, int MatSz, int nVols, size_t *Tst, char *Error){
	const char* Error0; 
	double *dMat;
	size_t free,total;
	size_t MatMem = sizeof(double)*MatSz*MatSz*nVols;
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
/// Mat2DAllocDblC
///==========================================================
void Mat2DMSAllocDblC(size_t *HMat, int MatSz, int nVols, size_t *Tst, char *Error){
	const char* Error0; 
	double *dMat;
	size_t free,total;
	size_t MatMem = sizeof(double)*MatSz*MatSz*nVols*2;
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
/// Mat2DInitDbl
///==========================================================
void Mat2DMSInitDbl(size_t *HMat, int MatSz, int nVols, char *Error){
	const char* Error0; 
	double *dMat;
	size_t MatMem = sizeof(double)*MatSz*MatSz*nVols;
	dMat = (double*)*HMat;
	cudaMemset(dMat,0,MatMem);
	Error0 = cudaGetErrorString(cudaGetLastError());
	strcpy(Error,Error0);
	cudaDeviceSynchronize();		
}

///==========================================================
/// Mat2DInitDblC
///==========================================================
void Mat2DMSInitDblC(size_t *HMat, int MatSz, int nVols, char *Error){
	const char* Error0; 
	double *dMat;
	size_t MatMem = sizeof(double)*MatSz*MatSz*nVols*2;
	dMat = (double*)*HMat;
	cudaMemset(dMat,0,MatMem);
	Error0 = cudaGetErrorString(cudaGetLastError());
	strcpy(Error,Error0);
	cudaDeviceSynchronize();		
}

///==========================================================
/// Mat2DFreeDbl
///==========================================================
void Mat2DMSFreeDbl(size_t *HMat, char *Error){
	const char* Error0; 
	double *dMat;
	dMat = (double*)*HMat;
	cudaFree(dMat);
	Error0 = cudaGetErrorString(cudaGetLastError());
	strcpy(Error,Error0);
	cudaDeviceSynchronize();		
}

///==========================================================
/// Mat2DFreeDblC
///==========================================================
void Mat2DMSFreeDblC(size_t *HMat, char *Error){
	const char* Error0; 
	double *dMat;
	dMat = (double*)*HMat;
	cudaFree(dMat);
	Error0 = cudaGetErrorString(cudaGetLastError());
	strcpy(Error,Error0);
	cudaDeviceSynchronize();		
}

///==========================================================
/// Mat2DLoadDbl
///==========================================================
void Mat2DMSLoadDbl(double *Mat, size_t *HMat, int MatSz, int nVols, char *Error){
	const char* Error0; 
	double *dMat;
	size_t MatMem = sizeof(double)*MatSz*MatSz*nVols;
	dMat = (double*)*HMat;
	cudaMemcpy(dMat,Mat,MatMem,cudaMemcpyHostToDevice);
	Error0 = cudaGetErrorString(cudaGetLastError());
	strcpy(Error,Error0);
	cudaDeviceSynchronize();		
}

///==========================================================
/// Mat2DLoadDblC
///==========================================================
void Mat2DMSLoadDblC(double *Mat, size_t *HMat, int MatSz, int nVols, char *Error){
	const char* Error0; 
	double *dMat;
	size_t MatMem = sizeof(double)*MatSz*MatSz*nVols*2;
	dMat = (double*)*HMat;
	cudaMemcpy(dMat,Mat,MatMem,cudaMemcpyHostToDevice);
	Error0 = cudaGetErrorString(cudaGetLastError());
	strcpy(Error,Error0);
	cudaDeviceSynchronize();		
}

///==========================================================
/// Mat2DReturnDbl
///==========================================================
void Mat2DMSReturnDbl(double *Mat, size_t *HMat, int MatSz, int nVols, char *Error){
	const char* Error0; 
	double *dMat;
	size_t MatMem = sizeof(double)*MatSz*MatSz*nVols;
	dMat = (double*)*HMat;
	cudaMemcpy(Mat,dMat,MatMem,cudaMemcpyDeviceToHost);
	Error0 = cudaGetErrorString(cudaGetLastError());
	strcpy(Error,Error0);
	cudaDeviceSynchronize();		
}

///==========================================================
/// Mat2DReturnDblC
///==========================================================
void Mat2DMSReturnDblC(double *Mat, size_t *HMat, int MatSz, int nVols, char *Error){
	const char* Error0; 
	double *dMat;
	size_t MatMem = sizeof(double)*MatSz*MatSz*nVols*2;
	dMat = (double*)*HMat;
	cudaMemcpy(Mat,dMat,MatMem,cudaMemcpyDeviceToHost);
	Error0 = cudaGetErrorString(cudaGetLastError());
	strcpy(Error,Error0);
	cudaDeviceSynchronize();		
}
