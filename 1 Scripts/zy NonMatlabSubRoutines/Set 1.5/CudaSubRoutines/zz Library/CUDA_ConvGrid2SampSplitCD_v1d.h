///==========================================================
/// (v1d)
///		- Recompile with CUDA 7.5
///==========================================================

extern "C" void ConvGrid2SampSplitCD(mwSize *HSampDatR, mwSize *HSampDatI, mwSize *HGrdDat, mwSize *HKx, mwSize *HKy, mwSize *HKz, mwSize *HKern, 
									int GrdDatSz, int DatLen, int KernSz, int iKern, int chW, int SampDatAdr, char* Error);