///==========================================================
/// (v1a)
///		- 
///==========================================================

extern "C" void ArrMSAllocDbl(mwSize *HMat, int ArrSz, int nVols, mwSize *Tst, char *Error);
extern "C" void ArrMSAllocDblC(mwSize *HMat, int ArrSz, int nVols, mwSize *Tst, char *Error);
extern "C" void ArrMSInitDbl(mwSize *HMat, int ArrSz, int nVols, char *Error);
extern "C" void ArrMSInitDblC(mwSize *HMat, int ArrSz, int nVols, char *Error);
extern "C" void ArrMSFreeDbl(mwSize *HMat, char *Error);
extern "C" void ArrMSFreeDblC(mwSize *HMat, char *Error);
extern "C" void ArrMSLoadDbl(double *Mat, mwSize *HMat, int ArrSz, int nVols, char *Error);
extern "C" void ArrMSLoadDblC(double *Mat, mwSize *HMat, int ArrSz, int nVols, char *Error);
extern "C" void ArrMSReturnDbl(double *Mat, mwSize *HMat, int ArrSz, int nVols, char *Error);
extern "C" void ArrMSReturnDblC(double *Mat, mwSize *HMat, int ArrSz, int nVols, char *Error);

extern "C" void Mat2DMSAllocDbl(mwSize *HMat, int MatSz, int nVols, mwSize *Tst, char *Error);
extern "C" void Mat2DMSAllocDblC(mwSize *HMat, int MatSz, int nVols, mwSize *Tst, char *Error);
extern "C" void Mat2DMSInitDbl(mwSize *HMat, int MatSz, int nVols, char *Error);
extern "C" void Mat2DMSInitDblC(mwSize *HMat, int MatSz, int nVols, char *Error);
extern "C" void Mat2DMSFreeDbl(mwSize *HMat, char *Error);
extern "C" void Mat2DMSFreeDblC(mwSize *HMat, char *Error);
extern "C" void Mat2DMSLoadDbl(double *Mat, mwSize *HMat, int MatSz, int nVols, char *Error);
extern "C" void Mat2DMSLoadDblC(double *Mat, mwSize *HMat, int MatSz, int nVols, char *Error);
extern "C" void Mat2DMSReturnDbl(double *Mat, mwSize *HMat, int MatSz, int nVols, char *Error);
extern "C" void Mat2DMSReturnDblC(double *Mat, mwSize *HMat, int MatSz, int nVols, char *Error);