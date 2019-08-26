///==========================================================
/// (v1b)
///		
///==========================================================

extern "C" void ConvSamp2GridSplitCSM(int Count, mwSize *HSampDatC, mwSize *HGrdDat, mwSize *HKx, mwSize *HKy, mwSize *HKz, mwSize *HKern, 
									int GrdDatSz, int DatLen, int KernSz, int iKern, int chW, int SampDatAdr, int SampDatAdrC, char* Error);