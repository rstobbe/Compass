///==========================================================
/// (v1c)
///		
///==========================================================

extern "C" void ConvSamp2GridCD2Dms(mwSize *HSampDatR, mwSize *HSampDatI, mwSize *HGrdDat, mwSize *HKx, mwSize *HKy, mwSize *HKern, 
									int GrdDatSz, int DatLen, int KernSz, int iKern, int chW, int VolNum, char* Error);