///==========================================================
/// (v1c)
///		- large kern referencing fix (float related)
///==========================================================

extern "C" void ConvGrid2SampSplitRS(size_t *HSampDat, size_t *HGrdDat, size_t *HKx, size_t *HKy, size_t *HKz, size_t *HKern, 
							int GrdDatSz, int DatLen, int KernSz, int iKern, int chW, int SampDatAdr, char* Error);


///=====================================================
/// Conv3D (kernel)					
///=====================================================
__global__ void Conv3D(float* dSDat, float* dGDat, float* dKx, float* dKy, float* dKz, float* dKern, 
						int GrdDatSz, int DatLen, int KernSz, int iKern, int chW)
{
int xF,yF,zF;
//float xF,yF,zF;
int xflr,yflr,zflr;
float DatVal,KernVal,CrtVal;
int j,a,b,c;
j = blockDim.x*blockIdx.x + threadIdx.x;

if (j < DatLen) {
    DatVal = 0;
	xflr = __float2int_rd(dKx[j]);
    yflr = __float2int_rd(dKy[j]);
    zflr = __float2int_rd(dKz[j]);   
	xF = lroundf(iKern*(dKx[j]-xflr));     	// lroundf necessary to match 'mex' and 'matlab'         
    yF = lroundf(iKern*(dKy[j]-yflr)); 
    zF = lroundf(iKern*(dKz[j]-zflr));	
	//xF = roundf(iKern*(dKx[j]-xflr));      // same result if xF is 'int' or 'float'
    //yF = roundf(iKern*(dKy[j]-yflr)); 
    //zF = roundf(iKern*(dKz[j]-zflr));	
	if (xF == iKern){
        xflr = xflr + 1;
        xF = 0;
		}
    if (yF == iKern){
        yflr = yflr + 1;
        yF = 0;
		}
    if (zF == iKern){
        zflr = zflr + 1;
        zF = 0;
		}
	for(c=-chW; c<=chW+1; c++) {
		for(b=-chW; b<=chW+1; b++) {
			for(a=-chW; a<=chW+1; a++) {
				KernVal = dKern[lrintf(fabsf(xF-(a*iKern))) + lrintf(fabsf(yF-(b*iKern)))*KernSz + lrintf(fabsf(zF-(c*iKern)))*KernSz*KernSz];		// individual conversion necessary (i.e. for 'z') because number will be too big for float to handle 
				CrtVal = dGDat[(xflr+a-1)+((yflr+b-1)*GrdDatSz)+((zflr+c-1)*GrdDatSz*GrdDatSz)];
				DatVal += KernVal*CrtVal;							// looks like some small precision error in this command when compared to 'mex' and 'matlab'
				}
			}
		} 
	dSDat[j] = DatVal;
	}

}

///=====================================================
/// Code Entry
///=====================================================
void ConvGrid2SampSplitRS(size_t *HSampDat, size_t *HGrdDat, size_t *HKx, size_t *HKy, size_t *HKz, size_t *HKern, 
							int GrdDatSz, int DatLen, int KernSz, int iKern, int chW, int SampDatAdr, char* Error){

	float *dSDat,*dGDat,*dKx,*dKy,*dKz,*dKern;
	dSDat = (float*)(*HSampDat+SampDatAdr*sizeof(float));
	dGDat = (float*)*HGrdDat;
	dKx = (float*)(*HKx+SampDatAdr*sizeof(float));
	dKy = (float*)(*HKy+SampDatAdr*sizeof(float));	
	dKz = (float*)(*HKz+SampDatAdr*sizeof(float));
	dKern = (float*)*HKern;	
	
	int tpb = 512;                                                          // possible to go up to 1024. Should be multiple of warp_size=32.
	int bpg = int(ceil(float(DatLen)/float(tpb)));                           
	Conv3D<<<bpg,tpb>>>(dSDat,dGDat,dKx,dKy,dKz,dKern,GrdDatSz,DatLen,KernSz,iKern,chW);

	const char* Error0 = cudaGetErrorString(cudaGetLastError());
	strcpy(Error,Error0);
	
	cudaDeviceSynchronize();												// make sure finished		
}
							

