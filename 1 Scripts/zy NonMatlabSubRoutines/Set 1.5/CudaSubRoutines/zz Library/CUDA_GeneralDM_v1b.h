///==========================================================
/// (v1b)
///		- as CUDA_GeneralD_v1b
///==========================================================

extern "C" void CUDAcount(int *Count, char *Error);

extern "C" void ArrAllocDbl(int Count, size_t *HMat, int ArrSz, size_t *Tst, char *Error);
extern "C" void ArrAllocDblC(int Count, mwSize *HMat, int ArrSz, mwSize *Tst, char *Error);
extern "C" void ArrInitDbl(int Count, mwSize *HMat, int ArrSz, char *Error);
extern "C" void ArrInitDblC(int Count, mwSize *HMat, int ArrSz, char *Error);
extern "C" void ArrFreeDbl(int Count, mwSize *HMat, char *Error);
extern "C" void ArrFreeDblC(int Count, mwSize *HMat, char *Error);
extern "C" void ArrLoadDbl(int Count, double *Mat, mwSize *HMat, int ArrSz, char *Error);
extern "C" void ArrLoadDblC(int Count, double *Mat, mwSize *HMat, int ArrSz, char *Error);
extern "C" void ArrReturnDbl(int Count, double *Mat, mwSize *HMat, int ArrSz, char *Error);
extern "C" void ArrReturnDblC(int Count, double *Mat, mwSize *HMat, int ArrSz, char *Error);

extern "C" void Mat3DAllocDbl(int Count, mwSize *HMat, int MatSz, mwSize *Tst, char *Error);
extern "C" void Mat3DAllocDblC(int Count, mwSize *HMat, int MatSz, mwSize *Tst, char *Error);
extern "C" void Mat3DInitDbl(int Count, mwSize *HMat, int MatSz, char *Error);
extern "C" void Mat3DInitDblC(int Count, mwSize *HMat, int MatSz, char *Error);
extern "C" void Mat3DFreeDbl(int Count, mwSize *HMat, char *Error);
extern "C" void Mat3DFreeDblC(int Count, mwSize *HMat, char *Error);
extern "C" void Mat3DLoadDbl(int Count, double *Mat, mwSize *HMat, int MatSz, char *Error);
extern "C" void Mat3DLoadDblC(int Count, double *Mat, mwSize *HMat, int MatSz, char *Error);
extern "C" void Mat3DReturnDbl(int Count, double *Mat, mwSize *HMat, int MatSz, char *Error);
extern "C" void Mat3DReturnDblC(int Count, double *Mat, mwSize *HMat, int MatSz, char *Error);