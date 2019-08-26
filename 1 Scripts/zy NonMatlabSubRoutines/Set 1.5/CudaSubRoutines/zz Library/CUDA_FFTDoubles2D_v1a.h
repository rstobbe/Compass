///==========================================================
/// 
///==========================================================

extern "C" void FFT2Dsetup(unsigned int *plan, int MatSz, char *Error);
extern "C" void FFT2D(mwSize *HdIm, mwSize *HdkDat, unsigned int *plan, char *Error);
extern "C" void FFT2Dteardown(unsigned int *plan);
