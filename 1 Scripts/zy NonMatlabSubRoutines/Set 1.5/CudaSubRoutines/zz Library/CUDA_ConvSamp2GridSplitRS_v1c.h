///==========================================================
/// (v1c)
///		- function accuracy fixes
///==========================================================

extern "C" void ConvSamp2GridSplitRS(mwSize *HSampDat, mwSize *HGrdDat, mwSize *HKx, mwSize *HKy, mwSize *HKz, mwSize *HKern, 
									int GrdDatSz, int DatLen, int KernSz, int iKern, int chW, int SampDatAdr, char* Error);