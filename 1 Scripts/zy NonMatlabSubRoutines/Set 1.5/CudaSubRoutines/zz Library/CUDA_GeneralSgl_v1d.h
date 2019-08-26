///==========================================================
/// 
///==========================================================

extern "C" void CUDAcount(int *Count, char *Error);

extern "C" void ArrAllocSgl(mwSize *Count, size_t *HMat, mwSize *ArrSz, char *Error);
extern "C" void ArrAllocSglC(mwSize *Count, mwSize *HMat, mwSize *ArrSz, char *Error);
extern "C" void ArrInitSgl(mwSize *Count, mwSize *HMat, mwSize *ArrSz, char *Error);
extern "C" void ArrInitSglC(mwSize *Count, mwSize *HMat, mwSize *ArrSz, char *Error);
extern "C" void ArrFreeSgl(mwSize *Count, mwSize *HMat, char *Error);
extern "C" void ArrFreeSglC(mwSize *Count, mwSize *HMat, char *Error);
extern "C" void ArrLoadSglSync(mwSize *Count, float *Mat, mwSize *HMat, mwSize *ArrSz, char *Error);
extern "C" void ArrLoadSglSyncC(mwSize *Count, float *Mat, mwSize *HMat, mwSize *ArrSz, char *Error);
extern "C" void ArrLoadSgl(mwSize *Count, float *Mat, mwSize *HMat, mwSize *ArrSz, mwSize *ProjInc, char *Error);
extern "C" void ArrLoadSglC(mwSize *Count, float *Mat, mwSize *HMat, mwSize *ArrSz, mwSize *ProjInc, char *Error);
extern "C" void ArrReturnSgl(mwSize *Count, float *Mat, mwSize *HMat, mwSize *ArrSz, char *Error);
extern "C" void ArrReturnSglC(mwSize *Count, float *Mat, mwSize *HMat, mwSize *ArrSz, char *Error);
extern "C" void ArrReturnSglSyncC(mwSize *Count, float *Mat, mwSize *HMat, mwSize *ArrSz, char *Error);

extern "C" void Mat3DAllocSgl(mwSize *Count, mwSize *HMat, int MatSz, char *Error);
extern "C" void Mat3DAllocSglC(mwSize *Count, mwSize *HMat, int MatSz, char *Error);
extern "C" void Mat3DInitSgl(mwSize *Count, mwSize *HMat, int MatSz, char *Error);
extern "C" void Mat3DInitSglC(mwSize *Count, mwSize *HMat, int MatSz, char *Error);
extern "C" void Mat3DFreeSgl(mwSize *Count, mwSize *HMat, char *Error);
extern "C" void Mat3DFreeSglC(mwSize *Count, mwSize *HMat, char *Error);
extern "C" void Mat3DLoadSgl(mwSize *Count, float *Mat, mwSize *HMat, int MatSz, char *Error);
extern "C" void Mat3DLoadSglC(mwSize *Count, float *Mat, mwSize *HMat, int MatSz, char *Error);
extern "C" void Mat3DReturnSgl(mwSize *Count, float *Mat, mwSize *HMat, int MatSz, char *Error);
extern "C" void Mat3DReturnSglC(mwSize *Count, float *Mat, mwSize *HMat, int MatSz, char *Error);