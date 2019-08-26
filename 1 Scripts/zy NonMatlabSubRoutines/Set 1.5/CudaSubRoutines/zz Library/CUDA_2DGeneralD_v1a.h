///==========================================================
/// (v1a)
///		- 
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

extern "C" void Mat2DAllocDbl(mwSize *HMat, int MatSz, mwSize *Tst, char *Error);
extern "C" void Mat2DAllocDblC(mwSize *HMat, int MatSz, mwSize *Tst, char *Error);
extern "C" void Mat2DInitDbl(mwSize *HMat, int MatSz, char *Error);
extern "C" void Mat2DInitDblC(mwSize *HMat, int MatSz, char *Error);
extern "C" void Mat2DFreeDbl(mwSize *HMat, char *Error);
extern "C" void Mat2DFreeDblC(mwSize *HMat, char *Error);
extern "C" void Mat2DLoadDbl(double *Mat, mwSize *HMat, int MatSz, char *Error);
extern "C" void Mat2DLoadDblC(double *Mat, mwSize *HMat, int MatSz, char *Error);
extern "C" void Mat2DReturnDbl(double *Mat, mwSize *HMat, int MatSz, char *Error);
extern "C" void Mat2DReturnDblC(double *Mat, mwSize *HMat, int MatSz, char *Error);