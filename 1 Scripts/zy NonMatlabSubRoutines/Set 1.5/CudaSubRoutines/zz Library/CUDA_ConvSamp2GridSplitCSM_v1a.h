///==========================================================
/// (v1a)
///		
///==========================================================

extern "C" void ConvSamp2GridSplitCSM(int Count, mwSize *HSampDatR, mwSize *HSampDatI, mwSize *HGrdDat, mwSize *HKx, mwSize *HKy, mwSize *HKz, mwSize *HKern, 
									int GrdDatSz, int DatLen, int KernSz, int iKern, int chW, int SampDatAdr, char* Error);