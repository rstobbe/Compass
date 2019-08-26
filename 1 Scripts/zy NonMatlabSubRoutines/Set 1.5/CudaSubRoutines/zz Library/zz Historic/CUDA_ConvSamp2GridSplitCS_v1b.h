///==========================================================
/// (v1b)
///		- exactly same as (v1a) - name catch up with G2S
///==========================================================

extern "C" void ConvSamp2GridSplitCS(mwSize *HSampDatR, mwSize *HSampDatI, mwSize *HGrdDat, mwSize *HKx, mwSize *HKy, mwSize *HKz, mwSize *HKern, 
									int GrdDatSz, int DatLen, int KernSz, int iKern, int chW, int SampDatAdr, char* Error);