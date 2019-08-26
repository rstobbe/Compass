///==========================================================
/// (v1a)
///		- 
///==========================================================

extern "C" void ArrAllocSgl(mwSize *HMat, int ArrSz, mwSize *Tst, char *Error);
extern "C" void ArrAllocSglC(mwSize *HMat, int ArrSz, mwSize *Tst, char *Error);
extern "C" void ArrInitSgl(mwSize *HMat, int ArrSz, char *Error);
extern "C" void ArrInitSglC(mwSize *HMat, int ArrSz, char *Error);
extern "C" void ArrFreeSgl(mwSize *HMat, char *Error);
extern "C" void ArrFreeSglC(mwSize *HMat, char *Error);
extern "C" void ArrLoadSgl(float *Mat, mwSize *HMat, int ArrSz, char *Error);
extern "C" void ArrLoadSglC(float *Mat, mwSize *HMat, int ArrSz, char *Error);
extern "C" void ArrReturnSgl(float *Mat, mwSize *HMat, int ArrSz, char *Error);
extern "C" void ArrReturnSglC(float *Mat, mwSize *HMat, int ArrSz, char *Error);

extern "C" void Mat3DAllocSgl(mwSize *HMat, int MatSz, mwSize *Tst, char *Error);
extern "C" void Mat3DAllocSglC(mwSize *HMat, int MatSz, mwSize *Tst, char *Error);
extern "C" void Mat3DInitSgl(mwSize *HMat, int MatSz, char *Error);
extern "C" void Mat3DInitSglC(mwSize *HMat, int MatSz, char *Error);
extern "C" void Mat3DFreeSgl(mwSize *HMat, char *Error);
extern "C" void Mat3DFreeSglC(mwSize *HMat, char *Error);
extern "C" void Mat3DLoadSgl(float *Mat, mwSize *HMat, int MatSz, char *Error);
extern "C" void Mat3DLoadSglC(float *Mat, mwSize *HMat, int MatSz, char *Error);
extern "C" void Mat3DReturnSgl(float *Mat, mwSize *HMat, int MatSz, char *Error);
extern "C" void Mat3DReturnSglC(float *Mat, mwSize *HMat, int MatSz, char *Error);