///==========================================================
/// (v1c)
///		- function accuracy fixes
///==========================================================

extern "C" void ConvGrid2SampSplitRS(size_t *HSampDat, size_t *HGrdDat, size_t *HKx, size_t *HKy, size_t *HKz, size_t *HKern, 
							int GrdDatSz, int DatLen, int KernSz, int iKern, int chW, int SampDatAdr, char* Error);


///=====================================================
/// Conv3D (kernel)					
///=====================================================
__global__ void Conv3D(float* dSDat, float* dGDat, float* dKx, float* dKy, float* dKz, float* dKern, 
						int GrdDatSz, int DatLen, int KernSz, int iKern, int chW)
{
//float xrmd,yrmd,zrmd;
//float fxflr,fyflr,fzflr;
int xflr,yflr,zflr;
int xF,yF,zF;
float DatVal,KernVal,CrtVal;
int j,a,b,c;
j = blockDim.x*blockIdx.x + threadIdx.x;

if (j < DatLen) {
    DatVal = 0;
	KernVal = 0;
	CrtVal = 0;
    //--------------------------------
	//fxflr = floorf(dKx[j]);			// original - not accurate enough
    //fyflr = floorf(dKy[j]);
    //fzflr = floorf(dKz[j]);
	xflr = __float2int_rd(dKx[j]);
    yflr = __float2int_rd(dKy[j]);
    zflr = __float2int_rd(dKz[j]);   
	//--------------------------------
	
	//--------------------------------
	//xrmd = dKx[j]-fxflr;
    //yrmd = dKy[j]-fyflr;
    //zrmd = dKz[j]-fzflr;
	//xF = lrintf(iKern*xrmd);      		// original  (change = no impact)               
    //yF = lrintf(iKern*yrmd); 
    //zF = lrintf(iKern*zrmd);
	//xF = lrintf(iKern*(dKx[j]-xflr));                  
    //yF = lrintf(iKern*(dKy[j]-yflr)); 
    //zF = lrintf(iKern*(dKz[j]-zflr));
	xF = lroundf(iKern*(dKx[j]-xflr));       // - round up (still has error - probably precision?)             
    yF = lroundf(iKern*(dKy[j]-yflr)); 
    zF = lroundf(iKern*(dKz[j]-zflr));	
	//---------------------------------

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

	//-------------------------------
	//xflr = __float2int_rd(fxflr);			// original		
	//yflr = __float2int_rd(fyflr);
	//zflr = __float2int_rd(fzflr);
	//xflr = lrintf(fxflr);					// this change has no effect	
	//yflr = lrintf(fyflr);
	//zflr = lrintf(fzflr);	
	//xflr = __float2int_ru(fxflr);			// this change has no effect  (becuase already rounded)	
	//yflr = __float2int_ru(fyflr);
	//zflr = __float2int_ru(fzflr);
	//-------------------------------
 

	for(c=-chW; c<=chW+1; c++) {
		for(b=-chW; b<=chW+1; b++) {
			for(a=-chW; a<=chW+1; a++) {
				KernVal = dKern[lrintf(fabsf(xF-(a*iKern))+(fabsf(yF-(b*iKern))*KernSz)+(fabsf(zF-(c*iKern))*KernSz*KernSz))];
				//KernVal = dKern[__float2int_rd(fabsf(xF-(a*iKern))+(fabsf(yF-(b*iKern))*KernSz)+(fabsf(zF-(c*iKern))*KernSz*KernSz))];   % no effect
				//KernVal = dKern[lroundf(fabsf(xF-(a*iKern))+(fabsf(yF-(b*iKern))*KernSz)+(fabsf(zF-(c*iKern))*KernSz*KernSz))];
				CrtVal = dGDat[(xflr+a-1)+((yflr+b-1)*GrdDatSz)+((zflr+c-1)*GrdDatSz*GrdDatSz)];
				DatVal += KernVal*CrtVal;
				//DatVal += CrtVal;
				//DatVal += KernVal;
			}
		}
	} 
	dSDat[j] = DatVal;
	//dSDat[j] = xF;
	//dSDat[j] = xflr;	
	//dSDat[j] = dKern[lrintf(fabsf(xF-((2)*iKern))+(fabsf(yF-((2)*iKern))*KernSz)+(fabsf(zF-((2)*iKern))*KernSz*KernSz))];
	//dSDat[j] = dKern[17056480];
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
							

