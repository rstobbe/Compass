///==========================================================
/// (v1c)
///		- RS_v1c start
///==========================================================

extern "C" void ConvSamp2GridSplitCD2D(mwSize *HSampDatR, mwSize *HSampDatI, mwSize *HGrdDat, mwSize *HKx, mwSize *HKy, mwSize *HKern, 
									int GrdDatSz, int DatLen, int KernSz, int iKern, int chW, int SampDatAdr, char* Error);