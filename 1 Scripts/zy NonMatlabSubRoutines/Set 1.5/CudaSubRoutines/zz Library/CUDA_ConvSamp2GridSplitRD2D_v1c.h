///==========================================================
/// (v1c)
///		- CUDA_ConvSamp2GridSplitRD_v1c start
///==========================================================

extern "C" void ConvSamp2GridSplitRD2D(mwSize *HSampDat, mwSize *HGrdDat, mwSize *HKx, mwSize *HKy, mwSize *HKern, 
									int GrdDatSz, int DatLen, int KernSz, int iKern, int chW, int SampDatAdr, char* Error);