///==========================================================
/// (v1a)
///		
///==========================================================

extern "C" void ConvGrid2SampCS(size_t *HSampDatR, size_t *HSampDatI, size_t *HGrdDat, size_t *HKx, size_t *HKy, size_t *HKz, size_t *HKern, 
							int GrdDatSz, int DatLen, int KernSz, int iKern, int chW, char* Error);


///=====================================================
/// Conv3D (kernel)					
///=====================================================
__global__ void Conv3D(float* dSDatR, float* dSDatI, float* dGDat, float* dKx, float* dKy, float* dKz, float* dKern, 
						int GrdDatSz, int DatLen, int KernSz, int iKern, int chW)
{
float xrmd,yrmd,zrmd;
float fxflr,fyflr,fzflr;
int xflr,yflr,zflr;
int xF,yF,zF;
float DatValR,DatValI,KernVal;
int j,a,b,c;
j = blockDim.x*blockIdx.x + threadIdx.x;

if (j < DatLen) {
    DatValR = 0;
	DatValI = 0;
    fxflr = floorf(dKx[j]);
    fyflr = floorf(dKy[j]);
    fzflr = floorf(dKz[j]);
    xrmd = dKx[j]-fxflr;
    yrmd = dKy[j]-fyflr;
    zrmd = dKz[j]-fzflr;
    xF = lrintf(iKern*xrmd);                       
    yF = lrintf(iKern*yrmd); 
    zF = lrintf(iKern*zrmd);   
    if (xF == iKern){
        fxflr = fxflr + 1;
        xF = 0;
		}
    if (yF == iKern){
        fyflr = fyflr + 1;
        yF = 0;
		}
    if (zF == iKern){
        fzflr = fzflr + 1;
        zF = 0;
		}
	xflr = __float2int_rd(fxflr);
	yflr = __float2int_rd(fyflr);
	zflr = __float2int_rd(fzflr);	
    for(c=-chW; c<=chW+1; c++) {
        for(b=-chW; b<=chW+1; b++) {
            for(a=-chW; a<=chW+1; a++) {
                KernVal = dKern[lrintf(fabsf(xF-(a*iKern))+(fabsf(yF-(b*iKern))*KernSz)+(fabsf(zF-(c*iKern))*KernSz*KernSz))];
                DatValR += KernVal*dGDat[((xflr+a-1)*2)+((yflr+b-1)*GrdDatSz*2)+((zflr+c-1)*GrdDatSz*GrdDatSz*2)];
                DatValI += KernVal*dGDat[((xflr+a-1)*2+1)+((yflr+b-1)*GrdDatSz*2)+((zflr+c-1)*GrdDatSz*GrdDatSz*2)];
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
void ConvGrid2SampCS(size_t *HSampDatR, size_t *HSampDatI, size_t *HGrdDat, size_t *HKx, size_t *HKy, size_t *HKz, size_t *HKern, 
							int GrdDatSz, int DatLen, int KernSz, int iKern, int chW, char* Error){

	float *dSDatR,*dSDatI,*dGDat,*dKx,*dKy,*dKz,*dKern;
	dSDatR = (float*)*HSampDatR;
	dSDatI = (float*)*HSampDatI;
	dGDat = (float*)*HGrdDat;
	dKx = (float*)*HKx;
	dKy = (float*)*HKy;	
	dKz = (float*)*HKz;
	dKern = (float*)*HKern;	
	
	int tpb = 512;                                                          // possible to go up to 1024. Should be multiple of warp_size=32.
	int bpg = int(ceil(float(DatLen)/float(tpb)));                           
	Conv3D<<<bpg,tpb>>>(dSDatR,dSDatI,dGDat,dKx,dKy,dKz,dKern,GrdDatSz,DatLen,KernSz,iKern,chW);

	const char* Error0 = cudaGetErrorString(cudaGetLastError());
	strcpy(Error,Error0);
}
							

