///==========================================================
/// (v1b)
///		- Recompile with CUDA 7.5
///==========================================================

extern "C" void FFT3Dsetup(unsigned int *plan, int MatSz, char *Error);
extern "C" void FFT3D(mwSize *HdIm, mwSize *HdkDat, unsigned int *plan, char *Error);
extern "C" void FFT3Dteardown(unsigned int *plan);
