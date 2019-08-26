///==========================================================
/// (v1a)
///		- 
///==========================================================

extern "C" void ArrAllocSgl(size_t *HMat, int ArrSz, size_t *Tst, char *Error);
extern "C" void ArrAllocSglC(size_t *HMat, int ArrSz, size_t *Tst, char *Error);
extern "C" void ArrInitSgl(size_t *HMat, int ArrSz, char *Error);
extern "C" void ArrInitSglC(size_t *HMat, int ArrSz, char *Error);
extern "C" void ArrFreeSgl(size_t *HMat, char *Error);
extern "C" void ArrFreeSglC(size_t *HMat, char *Error);
extern "C" void ArrLoadSgl(float *Mat, size_t *HMat, int ArrSz, char *Error);
extern "C" void ArrLoadSglC(float *Mat, size_t *HMat, int ArrSz, char *Error);
extern "C" void ArrReturnSgl(float *Mat, size_t *HMat, int ArrSz, char *Error);
extern "C" void ArrReturnSglC(float *Mat, size_t *HMat, int ArrSz, char *Error);

extern "C" void Mat3DAllocSgl(size_t *HMat, int MatSz, size_t *Tst, char *Error);
extern "C" void Mat3DAllocSglC(size_t *HMat, int MatSz, size_t *Tst, char *Error);
extern "C" void Mat3DInitSgl(size_t *HMat, int MatSz, char *Error);
extern "C" void Mat3DInitSglC(size_t *HMat, int MatSz, char *Error);
extern "C" void Mat3DFreeSgl(size_t *HMat, char *Error);
extern "C" void Mat3DFreeSglC(size_t *HMat, char *Error);
extern "C" void Mat3DLoadSgl(float *Mat, size_t *HMat, int MatSz, char *Error);
extern "C" void Mat3DLoadSglC(float *Mat, size_t *HMat, int MatSz, char *Error);
extern "C" void Mat3DReturnSgl(float *Mat, size_t *HMat, int MatSz, char *Error);
extern "C" void Mat3DReturnSglC(float *Mat, size_t *HMat, int MatSz, char *Error);

///==========================================================
/// ArrAllocSgl
///==========================================================
void ArrAllocSgl(size_t *HMat, int ArrSz, size_t *Tst, char *Error){
	const char* Error0; 
	float *dMat;
	size_t free,total;
	size_t MatMem = sizeof(float)*ArrSz;
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
/// ArrAllocSglC
///==========================================================
void ArrAllocSglC(size_t *HMat, int ArrSz, size_t *Tst, char *Error){
	const char* Error0; 
	float *dMat;
	size_t free,total;
	size_t MatMem = sizeof(float)*ArrSz*2;
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
/// ArrInitSgl
///==========================================================
void ArrInitSgl(size_t *HMat, int ArrSz, char *Error){
	const char* Error0; 
	float *dMat;
	size_t MatMem = sizeof(float)*ArrSz;
	dMat = (float*)*HMat;
	cudaMemset(dMat,0,MatMem);
	Error0 = cudaGetErrorString(cudaGetLastError());
	strcpy(Error,Error0);
	cudaDeviceSynchronize();		
}

///==========================================================
/// ArrInitSglC
///==========================================================
void ArrInitSglC(size_t *HMat, int ArrSz, char *Error){
	const char* Error0; 
	float *dMat;
	size_t MatMem = sizeof(float)*ArrSz*2;
	dMat = (float*)*HMat;
	cudaMemset(dMat,0,MatMem);
	Error0 = cudaGetErrorString(cudaGetLastError());
	strcpy(Error,Error0);
	cudaDeviceSynchronize();		
}

///==========================================================
/// ArrFreeSgl
///==========================================================
void ArrFreeSgl(size_t *HMat, char *Error){
	const char* Error0; 
	float *dMat;
	dMat = (float*)*HMat;
	cudaFree(dMat);
	Error0 = cudaGetErrorString(cudaGetLastError());
	strcpy(Error,Error0);
	cudaDeviceSynchronize();	
}

///==========================================================
/// ArrFreeSglC
///==========================================================
void ArrFreeSglC(size_t *HMat, char *Error){
	const char* Error0; 
	float *dMat;
	dMat = (float*)*HMat;
	cudaFree(dMat);
	Error0 = cudaGetErrorString(cudaGetLastError());
	strcpy(Error,Error0);
	cudaDeviceSynchronize();	
}

///==========================================================
/// ArrLoadSgl
///==========================================================
void ArrLoadSgl(float *Mat, size_t *HMat, int ArrSz, char *Error){
	const char* Error0; 
	float *dMat;
	size_t MatMem = sizeof(float)*ArrSz;
	dMat = (float*)*HMat;
	cudaMemcpy(dMat,Mat,MatMem,cudaMemcpyHostToDevice);
	Error0 = cudaGetErrorString(cudaGetLastError());
	strcpy(Error,Error0);
	cudaDeviceSynchronize();	
}

///==========================================================
/// ArrLoadSglC
///==========================================================
void ArrLoadSglC(float *Mat, size_t *HMat, int ArrSz, char *Error){
	const char* Error0; 
	float *dMat;
	size_t MatMem = sizeof(float)*ArrSz*2;
	dMat = (float*)*HMat;
	cudaMemcpy(dMat,Mat,MatMem,cudaMemcpyHostToDevice);
	Error0 = cudaGetErrorString(cudaGetLastError());
	strcpy(Error,Error0);
	cudaDeviceSynchronize();		
}

///==========================================================
/// ArrReturnSgl
///==========================================================
void ArrReturnSgl(float *Mat, size_t *HMat, int ArrSz, char *Error){
	const char* Error0; 
	float *dMat;
	size_t MatMem = sizeof(float)*ArrSz;
	dMat = (float*)*HMat;
	cudaMemcpy(Mat,dMat,MatMem,cudaMemcpyDeviceToHost);
	Error0 = cudaGetErrorString(cudaGetLastError());
	strcpy(Error,Error0);
	cudaDeviceSynchronize();		
}

///==========================================================
/// ArrReturnSglC
///==========================================================
void ArrReturnSglC(float *Mat, size_t *HMat, int ArrSz, char *Error){
	const char* Error0; 
	float *dMat;
	size_t MatMem = sizeof(float)*ArrSz*2;
	dMat = (float*)*HMat;
	cudaMemcpy(Mat,dMat,MatMem,cudaMemcpyDeviceToHost);
	Error0 = cudaGetErrorString(cudaGetLastError());
	strcpy(Error,Error0);
	cudaDeviceSynchronize();		
}


///==========================================================
/// Mat3DAllocSgl
///==========================================================
void Mat3DAllocSgl(size_t *HMat, int MatSz, size_t *Tst, char *Error){
	const char* Error0; 
	float *dMat;
	size_t free,total;
	size_t MatMem = sizeof(float)*MatSz*MatSz*MatSz;
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
/// Mat3DAllocSglC
///==========================================================
void Mat3DAllocSglC(size_t *HMat, int MatSz, size_t *Tst, char *Error){
	const char* Error0; 
	float *dMat;
	size_t free,total;
	size_t MatMem = sizeof(float)*MatSz*MatSz*MatSz*2;
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
/// Mat3DInitSgl
///==========================================================
void Mat3DInitSgl(size_t *HMat, int MatSz, char *Error){
	const char* Error0; 
	float *dMat;
	size_t MatMem = sizeof(float)*MatSz*MatSz*MatSz;
	dMat = (float*)*HMat;
	cudaMemset(dMat,0,MatMem);
	Error0 = cudaGetErrorString(cudaGetLastError());
	strcpy(Error,Error0);
	cudaDeviceSynchronize();		
}

///==========================================================
/// Mat3DInitSglC
///==========================================================
void Mat3DInitSglC(size_t *HMat, int MatSz, char *Error){
	const char* Error0; 
	float *dMat;
	size_t MatMem = sizeof(float)*MatSz*MatSz*MatSz*2;
	dMat = (float*)*HMat;
	cudaMemset(dMat,0,MatMem);
	Error0 = cudaGetErrorString(cudaGetLastError());
	strcpy(Error,Error0);
	cudaDeviceSynchronize();		
}

///==========================================================
/// Mat3DFreeSgl
///==========================================================
void Mat3DFreeSgl(size_t *HMat, char *Error){
	const char* Error0; 
	float *dMat;
	dMat = (float*)*HMat;
	cudaFree(dMat);
	Error0 = cudaGetErrorString(cudaGetLastError());
	strcpy(Error,Error0);
	cudaDeviceSynchronize();		
}

///==========================================================
/// Mat3DFreeSglC
///==========================================================
void Mat3DFreeSglC(size_t *HMat, char *Error){
	const char* Error0; 
	float *dMat;
	dMat = (float*)*HMat;
	cudaFree(dMat);
	Error0 = cudaGetErrorString(cudaGetLastError());
	strcpy(Error,Error0);
	cudaDeviceSynchronize();		
}

///==========================================================
/// Mat3DLoadSgl
///==========================================================
void Mat3DLoadSgl(float *Mat, size_t *HMat, int MatSz, char *Error){
	const char* Error0; 
	float *dMat;
	size_t MatMem = sizeof(float)*MatSz*MatSz*MatSz;
	dMat = (float*)*HMat;
	cudaMemcpy(dMat,Mat,MatMem,cudaMemcpyHostToDevice);
	Error0 = cudaGetErrorString(cudaGetLastError());
	strcpy(Error,Error0);
	cudaDeviceSynchronize();		
}

///==========================================================
/// Mat3DLoadSglC
///==========================================================
void Mat3DLoadSglC(float *Mat, size_t *HMat, int MatSz, char *Error){
	const char* Error0; 
	float *dMat;
	size_t MatMem = sizeof(float)*MatSz*MatSz*MatSz*2;
	dMat = (float*)*HMat;
	cudaMemcpy(dMat,Mat,MatMem,cudaMemcpyHostToDevice);
	Error0 = cudaGetErrorString(cudaGetLastError());
	strcpy(Error,Error0);
	cudaDeviceSynchronize();		
}

///==========================================================
/// Mat3DReturnSgl
///==========================================================
void Mat3DReturnSgl(float *Mat, size_t *HMat, int MatSz, char *Error){
	const char* Error0; 
	float *dMat;
	size_t MatMem = sizeof(float)*MatSz*MatSz*MatSz;
	dMat = (float*)*HMat;
	cudaMemcpy(Mat,dMat,MatMem,cudaMemcpyDeviceToHost);
	Error0 = cudaGetErrorString(cudaGetLastError());
	strcpy(Error,Error0);
	cudaDeviceSynchronize();		
}

///==========================================================
/// Mat3DReturnSglC
///==========================================================
void Mat3DReturnSglC(float *Mat, size_t *HMat, int MatSz, char *Error){
	const char* Error0; 
	float *dMat;
	size_t MatMem = sizeof(float)*MatSz*MatSz*MatSz*2;
	dMat = (float*)*HMat;
	cudaMemcpy(Mat,dMat,MatMem,cudaMemcpyDeviceToHost);
	Error0 = cudaGetErrorString(cudaGetLastError());
	strcpy(Error,Error0);
	cudaDeviceSynchronize();		
}
