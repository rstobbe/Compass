///==========================================================
/// (v1d)
///		- Recompile with CUDA 7.5
///==========================================================

extern "C" void ConvSamp2GridSplitRD(mwSize *HSampDat, mwSize *HGrdDat, mwSize *HKx, mwSize *HKy, mwSize *HKz, mwSize *HKern, 
									int GrdDatSz, int DatLen, int KernSz, int iKern, int chW, int SampDatAdr, char* Error);