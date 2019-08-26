///==========================================================
/// (v1c)
///		- Recompile with CUDA 9.0 (compute 6.1)
///==========================================================

extern "C" void CUDAcount(int *Count, char *Error);

extern "C" void ArrAllocSgl(int Count, size_t *HMat, int ArrSz, size_t *Tst, char *Error);
extern "C" void ArrAllocSglC(int Count, mwSize *HMat, int ArrSz, mwSize *Tst, char *Error);
extern "C" void ArrInitSgl(int Count, mwSize *HMat, int ArrSz, char *Error);
extern "C" void ArrInitSglC(int Count, mwSize *HMat, int ArrSz, char *Error);
extern "C" void ArrFreeSgl(int Count, mwSize *HMat, char *Error);
extern "C" void ArrFreeSglC(int Count, mwSize *HMat, char *Error);
extern "C" void ArrLoadSgl(int Count, float *Mat, mwSize *HMat, int ArrSz, char *Error);
extern "C" void ArrLoadSglC(int Count, float *Mat, mwSize *HMat, int ArrSz, char *Error);
extern "C" void ArrReturnSgl(int Count, float *Mat, mwSize *HMat, int ArrSz, char *Error);
extern "C" void ArrReturnSglC(int Count, float *Mat, mwSize *HMat, int ArrSz, char *Error);

extern "C" void Mat3DAllocSgl(int Count, mwSize *HMat, int MatSz, mwSize *Tst, char *Error);
extern "C" void Mat3DAllocSglC(int Count, mwSize *HMat, int MatSz, mwSize *Tst, char *Error);
extern "C" void Mat3DInitSgl(int Count, mwSize *HMat, int MatSz, char *Error);
extern "C" void Mat3DInitSglC(int Count, mwSize *HMat, int MatSz, char *Error);
extern "C" void Mat3DFreeSgl(int Count, mwSize *HMat, char *Error);
extern "C" void Mat3DFreeSglC(int Count, mwSize *HMat, char *Error);
extern "C" void Mat3DLoadSgl(int Count, float *Mat, mwSize *HMat, int MatSz, char *Error);
extern "C" void Mat3DLoadSglC(int Count, float *Mat, mwSize *HMat, int MatSz, char *Error);
extern "C" void Mat3DReturnSgl(int Count, float *Mat, mwSize *HMat, int MatSz, char *Error);
extern "C" void Mat3DReturnSglC(int Count, float *Mat, mwSize *HMat, int MatSz, char *Error);