///==========================================================
/// (v1d)
///		- Recompile with CUDA 7.5
///==========================================================

extern "C" void ConvGrid2SampSplitCD(size_t *HSampDatR, size_t *HSampDatI, size_t *HGrdDat, size_t *HKx, size_t *HKy, size_t *HKz, size_t *HKern, 
							int GrdDatSz, int DatLen, int KernSz, int iKern, int chW, int SampDatAdr, char* Error);

													
///=====================================================
/// Conv3D (kernel)					
///=====================================================
__global__ void Conv3D(double* dSDatR, double* dSDatI, double* dGDat, double* dKx, double* dKy, double* dKz, double* dKern, 
						int GrdDatSz, int DatLen, int KernSz, int iKern, int chW)
{
int xF,yF,zF;
//double xF,yF,zF;
int xflr,yflr,zflr;
double DatValR,DatValI,KernVal,CrtValR,CrtValI;
int j,a,b,c;
j = blockDim.x*blockIdx.x + threadIdx.x;

if (j < DatLen) {
    DatValR = 0;
    DatValI = 0;	
	xflr = __double2int_rd(dKx[j]);
    yflr = __double2int_rd(dKy[j]);
    zflr = __double2int_rd(dKz[j]);   
	xF = lround(iKern*(dKx[j]-xflr));     	// lround necessary to match 'mex' and 'matlab'         
    yF = lround(iKern*(dKy[j]-yflr)); 
    zF = lround(iKern*(dKz[j]-zflr));	
	//xF = round(iKern*(dKx[j]-xflr));      
    //yF = round(iKern*(dKy[j]-yflr)); 
    //zF = round(iKern*(dKz[j]-zflr));	
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
				KernVal = dKern[lrintf(fabsf(xF-(a*iKern))) + lrintf(fabsf(yF-(b*iKern)))*KernSz + lrintf(fabsf(zF-(c*iKern)))*KernSz*KernSz];
				CrtValR = dGDat[((xflr+a-1)*2)+((yflr+b-1)*GrdDatSz*2)+((zflr+c-1)*GrdDatSz*GrdDatSz*2)];
				CrtValI = dGDat[((xflr+a-1)*2+1)+((yflr+b-1)*GrdDatSz*2)+((zflr+c-1)*GrdDatSz*GrdDatSz*2)];
				DatValR += KernVal*CrtValR;
				DatValI += KernVal*CrtValI;				
				}
			}
		} 
	dSDatR[j] = DatValR;
	dSDatI[j] = DatValI;
	}

}

///=====================================================
/// Code Entry
///=====================================================
void ConvGrid2SampSplitCD(size_t *HSampDatR, size_t *HSampDatI, size_t *HGrdDat, size_t *HKx, size_t *HKy, size_t *HKz, size_t *HKern, 
							int GrdDatSz, int DatLen, int KernSz, int iKern, int chW, int SampDatAdr, char* Error){

	double *dSDatR,*dSDatI,*dGDat,*dKx,*dKy,*dKz,*dKern;
	dSDatR = (double*)(*HSampDatR+SampDatAdr*sizeof(double));
	dSDatI = (double*)(*HSampDatI+SampDatAdr*sizeof(double));
	dGDat = (double*)*HGrdDat;
	dKx = (double*)(*HKx+SampDatAdr*sizeof(double));
	dKy = (double*)(*HKy+SampDatAdr*sizeof(double));	
	dKz = (double*)(*HKz+SampDatAdr*sizeof(double));
	dKern = (double*)*HKern;	
	
	int tpb = 512;                                                          // possible to go up to 1024. Should be multiple of warp_size=32.
	int bpg = int(ceil(double(DatLen)/double(tpb)));                           
	Conv3D<<<bpg,tpb>>>(dSDatR,dSDatI,dGDat,dKx,dKy,dKz,dKern,GrdDatSz,DatLen,KernSz,iKern,chW);

	const char* Error0 = cudaGetErrorString(cudaGetLastError());
	strcpy(Error,Error0);
	
	cudaDeviceSynchronize();												// make sure finished		
}
							
