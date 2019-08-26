///==========================================================
/// 
///==========================================================

extern "C" void CUDAcount(int *Count, char *Error);

extern "C" void ArrAllocSglAll(mwSize *Count, size_t *HMat, mwSize *ArrSz, char *Error);
extern "C" void ArrAllocSglAllC(mwSize *Count, mwSize *HMat, mwSize *ArrSz, char *Error);
extern "C" void ArrInitSglAll(mwSize *Count, mwSize *HMat, mwSize *ArrSz, char *Error);
extern "C" void ArrInitSglAllC(mwSize *Count, mwSize *HMat, mwSize *ArrSz, char *Error);
extern "C" void ArrFreeSglAll(mwSize *Count, mwSize *HMat, char *Error);
extern "C" void ArrFreeSglAllC(mwSize *Count, mwSize *HMat, char *Error);
extern "C" void ArrLoadSglAll(mwSize *Count, float *Mat, mwSize *HMat, mwSize *ArrSz, char *Error);
extern "C" void ArrLoadSglAllC(mwSize *Count, float *Mat, mwSize *HMat, mwSize *ArrSz, char *Error);
extern "C" void ArrLoadSglOne(mwSize *Count, float *Mat, mwSize *HMat, mwSize *ArrSz, char *Error);
extern "C" void ArrLoadSglOneC(mwSize *Count, float *Mat, mwSize *HMat, mwSize *ArrSz, char *Error);
extern "C" void ArrReturnSglOne(mwSize *Count, float *Mat, mwSize *HMat, mwSize *ArrSz, char *Error);
extern "C" void ArrReturnSglOneC(mwSize *Count, float *Mat, mwSize *HMat, mwSize *ArrSz, char *Error);
extern "C" void ArrReturnSglSyncC(mwSize *Count, float *Mat, mwSize *HMat, mwSize *ArrSz, char *Error);
