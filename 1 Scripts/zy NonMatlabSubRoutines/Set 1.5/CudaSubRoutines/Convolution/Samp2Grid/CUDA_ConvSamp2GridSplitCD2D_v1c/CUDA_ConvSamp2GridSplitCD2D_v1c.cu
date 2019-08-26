///==========================================================
/// (v1c)
///		- RS_v1c start
///==========================================================

extern "C" void ConvSamp2GridSplitCD2D(size_t *HSampDatR, size_t *HSampDatI, size_t *HGrdDat, size_t *HKx, size_t *HKy, size_t *HKern, 
							int GrdDatSz, int DatLen, int KernSz, int iKern, int chW, int SampDatAdr, char* Error);


__device__ double atomicAddD(double* address, double val)
{
	unsigned long long int* address_as_ull = (unsigned long long int*)address;
	unsigned long long int old = *address_as_ull, assumed;
	do {
		assumed = old;
		old = atomicCAS(address_as_ull, assumed, __double_as_longlong(val + __longlong_as_double(assumed)));
		} while (assumed != old);
	return __longlong_as_double(old);
}							

///=====================================================
/// Conv2D (kernel)					
///=====================================================
__global__ void Conv2D(double* dSDatR, double* dSDatI, double* dGDat, double* dKx, double* dKy, double* dKern, 
						int GrdDatSz, int DatLen, int KernSz, int iKern, int chW)
{
int xF,yF;
//double xF,yF;
int xflr,yflr;
double DatValR,DatValI,KernVal;
int j,a,b;
j = blockDim.x*blockIdx.x + threadIdx.x;

if (j < DatLen) {
    DatValR = dSDatR[j];
    DatValI = dSDatI[j];	
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
			KernVal = dKern[lrint(fabsf(xF-(a*iKern))) + lrint(fabsf(yF-(b*iKern)))*KernSz];		
			atomicAddD((dGDat+((xflr+a-1)*2)+((yflr+b-1)*GrdDatSz*2)),(KernVal*DatValR));
			atomicAddD((dGDat+((xflr+a-1)*2+1)+((yflr+b-1)*GrdDatSz*2)),(KernVal*DatValI));
			}
		}
	}  
}

///=====================================================
/// Code Entry
///=====================================================
void ConvSamp2GridSplitCD2D(size_t *HSampDatR, size_t *HSampDatI, size_t *HGrdDat, size_t *HKx, size_t *HKy, size_t *HKern, 
							int GrdDatSz, int DatLen, int KernSz, int iKern, int chW, int SampDatAdr, char* Error){

	double *dSDatR,*dSDatI,*dGDat,*dKx,*dKy,*dKern;
	dSDatR = (double*)(*HSampDatR+SampDatAdr*sizeof(double));
	dSDatI = (double*)(*HSampDatI+SampDatAdr*sizeof(double));
	dGDat = (double*)*HGrdDat;
	dKx = (double*)(*HKx+SampDatAdr*sizeof(double));
	dKy = (double*)(*HKy+SampDatAdr*sizeof(double));	
	dKern = (double*)*HKern;	
	
	int tpb = 512;                                                          // possible to go up to 1024. Should be multiple of warp_size=32.
	int bpg = int(ceil(double(DatLen)/double(tpb)));                           
	Conv2D<<<bpg,tpb>>>(dSDatR,dSDatI,dGDat,dKx,dKy,dKern,GrdDatSz,DatLen,KernSz,iKern,chW);

	const char* Error0 = cudaGetErrorString(cudaGetLastError());
	strcpy(Error,Error0);
	
	cudaDeviceSynchronize();												// make sure finished	
}
							
