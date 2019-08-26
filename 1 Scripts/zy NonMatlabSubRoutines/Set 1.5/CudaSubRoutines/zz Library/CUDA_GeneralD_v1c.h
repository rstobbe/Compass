///==========================================================
/// (v1c)
///		- Recompile with CUDA 9.0
///==========================================================

extern "C" void ArrAllocDbl(mwSize *HMat, int ArrSz, mwSize *Tst, char *Error);
extern "C" void ArrAllocDblC(mwSize *HMat, int ArrSz, mwSize *Tst, char *Error);
extern "C" void ArrInitDbl(mwSize *HMat, int ArrSz, char *Error);
extern "C" void ArrInitDblC(mwSize *HMat, int ArrSz, char *Error);
extern "C" void ArrFreeDbl(mwSize *HMat, char *Error);
extern "C" void ArrFreeDblC(mwSize *HMat, char *Error);
extern "C" void ArrLoadDbl(double *Mat, mwSize *HMat, int ArrSz, char *Error);
extern "C" void ArrLoadDblC(double *Mat, mwSize *HMat, int ArrSz, char *Error);
extern "C" void ArrReturnDbl(double *Mat, mwSize *HMat, int ArrSz, char *Error);
extern "C" void ArrReturnDblC(double *Mat, mwSize *HMat, int ArrSz, char *Error);

extern "C" void Mat3DAllocDbl(mwSize *HMat, int MatSz, mwSize *Tst, char *Error);
extern "C" void Mat3DAllocDblC(mwSize *HMat, int MatSz, mwSize *Tst, char *Error);
extern "C" void Mat3DInitDbl(mwSize *HMat, int MatSz, char *Error);
extern "C" void Mat3DInitDblC(mwSize *HMat, int MatSz, char *Error);
extern "C" void Mat3DFreeDbl(mwSize *HMat, char *Error);
extern "C" void Mat3DFreeDblC(mwSize *HMat, char *Error);
extern "C" void Mat3DLoadDbl(double *Mat, mwSize *HMat, int MatSz, char *Error);
extern "C" void Mat3DLoadDblC(double *Mat, mwSize *HMat, int MatSz, char *Error);
extern "C" void Mat3DReturnDbl(double *Mat, mwSize *HMat, int MatSz, char *Error);
extern "C" void Mat3DReturnDblC(double *Mat, mwSize *HMat, int MatSz, char *Error);