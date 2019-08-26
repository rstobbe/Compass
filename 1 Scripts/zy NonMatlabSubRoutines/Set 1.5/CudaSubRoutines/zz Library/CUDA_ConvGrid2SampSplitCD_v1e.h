///==========================================================
/// (v1e)
///		- Recompile with CUDA 9.0
///==========================================================

extern "C" void ConvGrid2SampSplitCD(mwSize *HSampDatR, mwSize *HSampDatI, mwSize *HGrdDat, mwSize *HKx, mwSize *HKy, mwSize *HKz, mwSize *HKern, 
									int GrdDatSz, int DatLen, int KernSz, int iKern, int chW, int SampDatAdr, char* Error);