///==========================================================
/// (v1e)
///		- Recompile with CUDA 9.0 (compute 6.1)
///==========================================================

extern "C" void ConvSamp2GridSplitRD(mwSize *HSampDat, mwSize *HGrdDat, mwSize *HKx, mwSize *HKy, mwSize *HKz, mwSize *HKern, 
									int GrdDatSz, int DatLen, int KernSz, int iKern, int chW, int SampDatAdr, char* Error);