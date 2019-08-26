///==========================================================
/// (v1c)
///		- RS_v1c start
///==========================================================

extern "C" void ConvGrid2SampSplitRD2D(size_t *HSampDat, size_t *HGrdDat, size_t *HKx, size_t *HKy, size_t *HKern, 
							int GrdDatSz, int DatLen, int KernSz, int iKern, int chW, int SampDatAdr, char* Error);

													
///=====================================================
/// Conv2D (kernel)					
///=====================================================
__global__ void Conv2D(double* dSDat, double* dGDat, double* dKx, double* dKy, double* dKern, 
						int GrdDatSz, int DatLen, int KernSz, int iKern, int chW)
{
int xF,yF;
//double xF,yF;
int xflr,yflr;
double DatVal,KernVal,CrtVal;
int j,a,b;
j = blockDim.x*blockIdx.x + threadIdx.x;

if (j < DatLen) {
    DatVal = 0;
	xflr = __double2int_rd(dKx[j]);
    yflr = __double2int_rd(dKy[j]); 
	xF = lround(iKern*(dKx[j]-xflr));     	// lround necessary to match 'mex' and 'matlab'         
    yF = lround(iKern*(dKy[j]-yflr)); 
	//xF = round(iKern*(dKx[j]-xflr));      
    //yF = round(iKern*(dKy[j]-yflr)); 
	if (xF == iKern){
        xflr = xflr + 1;
        xF = 0;
		}
    if (yF == iKern){
        yflr = yflr + 1;
        yF = 0;
		}
	for(b=-chW; b<=chW+1; b++) {
		for(a=-chW; a<=chW+1; a++) {
			KernVal = dKern[lrintf(fabsf(xF-(a*iKern))) + lrintf(fabsf(yF-(b*iKern)))*KernSz];
			CrtVal = dGDat[(xflr+a-1)+((yflr+b-1)*GrdDatSz)];
			DatVal += KernVal*CrtVal;							
			}
		}
	dSDat[j] = DatVal;
	}

}

///=====================================================
/// Code Entry
///=====================================================
void ConvGrid2SampSplitRD2D(size_t *HSampDat, size_t *HGrdDat, size_t *HKx, size_t *HKy, size_t *HKern, 
							int GrdDatSz, int DatLen, int KernSz, int iKern, int chW, int SampDatAdr, char* Error){

	double *dSDat,*dGDat,*dKx,*dKy,*dKern;
	dSDat = (double*)(*HSampDat+SampDatAdr*sizeof(double));
	dGDat = (double*)*HGrdDat;
	dKx = (double*)(*HKx+SampDatAdr*sizeof(double));
	dKy = (double*)(*HKy+SampDatAdr*sizeof(double));	
	dKern = (double*)*HKern;	
	
	int tpb = 512;                                                          // possible to go up to 1024. Should be multiple of warp_size=32.
	int bpg = int(ceil(double(DatLen)/double(tpb)));                           
	Conv2D<<<bpg,tpb>>>(dSDat,dGDat,dKx,dKy,dKern,GrdDatSz,DatLen,KernSz,iKern,chW);

	const char* Error0 = cudaGetErrorString(cudaGetLastError());
	strcpy(Error,Error0);
	
	cudaDeviceSynchronize();												// make sure finished		
}
							

