///==========================================================
/// 
///==========================================================

extern "C" void CudaDeviceWait(mwSize *GpuNum, char *Error);
extern "C" void ArrAllocSglAll(mwSize *GpuTot, size_t *HMat, mwSize *ArrSz, char *Error);
extern "C" void ArrAllocSglAllC(mwSize *GpuTot, mwSize *HMat, mwSize *ArrSz, char *Error);
extern "C" void ArrInitSglAll(mwSize *GpuTot, mwSize *HMat, mwSize *ArrSz, char *Error);
extern "C" void ArrInitSglAllC(mwSize *GpuTot, mwSize *HMat, mwSize *ArrSz, char *Error);
extern "C" void ArrFreeSglAll(mwSize *GpuTot, mwSize *HMat, char *Error);
extern "C" void ArrFreeSglAllC(mwSize *GpuTot, mwSize *HMat, char *Error);
extern "C" void ArrLoadSglAll(mwSize *GpuTot, float *Mat, mwSize *HMat, mwSize *ArrSz, char *Error);
extern "C" void ArrLoadSglAllAsync(mwSize *GpuTot, float *Mat, mwSize *HMat, mwSize *ArrSz, char *Error);
extern "C" void ArrLoadSglAllC(mwSize *GpuTot, float *Mat, mwSize *HMat, mwSize *ArrSz, char *Error);
extern "C" void ArrLoadSglOne(mwSize *GpuNum, float *Mat, mwSize *HMat, mwSize *ArrSz, char *Error);
extern "C" void ArrLoadSglOneC(mwSize *GpuNum, float *Mat, mwSize *HMat, mwSize *ArrSz, char *Error);
extern "C" void ArrLoadSglOneAsyncC(mwSize *GpuNum, float *Mat, mwSize *HMat, mwSize *ArrSz, char *Error);
extern "C" void ArrReturnSglOne(mwSize *GpuNum, float *Mat, mwSize *HMat, mwSize *ArrSz, char *Error);
extern "C" void ArrReturnSglOneC(mwSize *GpuNum, float *Mat, mwSize *HMat, mwSize *ArrSz, char *Error);
extern "C" void ArrReturnSglOneAsyncC(mwSize *GpuNum, float *Mat, mwSize *HMat, mwSize *ArrSz, char *Error);
extern "C" void ArrReturnSglAll(mwSize *GpuTot, float *Mat, mwSize *HMat, mwSize *ArrSz, char *Error);
extern "C" void ArrReturnSglAllC(mwSize *GpuTot, float *Mat, mwSize *HMat, mwSize *ArrSz, char *Error);