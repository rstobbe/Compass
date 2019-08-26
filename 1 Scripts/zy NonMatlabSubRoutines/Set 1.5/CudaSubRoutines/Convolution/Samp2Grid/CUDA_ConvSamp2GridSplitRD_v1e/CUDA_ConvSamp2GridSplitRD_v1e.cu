///==========================================================
/// (v1e)
///		- Recompile with CUDA 9.0
///==========================================================

extern "C" void ConvSamp2GridSplitRD(size_t *HSampDat, size_t *HGrdDat, size_t *HKx, size_t *HKy, size_t *HKz, size_t *HKern, 
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
/// Conv3D (kernel)					
///=====================================================
__global__ void Conv3D(double* dSDat, double* dGDat, double* dKx, double* dKy, double* dKz, double* dKern, 
						int GrdDatSz, int DatLen, int KernSz, int iKern, int chW)
{
int xF,yF,zF;
//double xF,yF,zF;
int xflr,yflr,zflr;
double DatVal,KernVal;
int j,a,b,c;
j = blockDim.x*blockIdx.x + threadIdx.x;

if (j < DatLen) {
    DatVal = dSDat[j];
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
				KernVal = dKern[lrint(fabsf(xF-(a*iKern))) + lrint(fabsf(yF-(b*iKern)))*KernSz + lrint(fabsf(zF-(c*iKern)))*KernSz*KernSz];		
				atomicAddD((dGDat+(xflr+a-1)+((yflr+b-1)*GrdDatSz)+((zflr+c-1)*GrdDatSz*GrdDatSz)),(KernVal*DatVal));
				}
			}
		}  
	}
}

///=====================================================
/// Code Entry
///=====================================================
void ConvSamp2GridSplitRD(size_t *HSampDat, size_t *HGrdDat, size_t *HKx, size_t *HKy, size_t *HKz, size_t *HKern, 
							int GrdDatSz, int DatLen, int KernSz, int iKern, int chW, int SampDatAdr, char* Error){

	double *dSDat,*dGDat,*dKx,*dKy,*dKz,*dKern;
	dSDat = (double*)(*HSampDat+SampDatAdr*sizeof(double));
	dGDat = (double*)*HGrdDat;
	dKx = (double*)(*HKx+SampDatAdr*sizeof(double));
	dKy = (double*)(*HKy+SampDatAdr*sizeof(double));	
	dKz = (double*)(*HKz+SampDatAdr*sizeof(double));
	dKern = (double*)*HKern;	
	
	int tpb = 512;                                                          // possible to go up to 1024. Should be multiple of warp_size=32.
	int bpg = int(ceil(double(DatLen)/double(tpb)));                           
	Conv3D<<<bpg,tpb>>>(dSDat,dGDat,dKx,dKy,dKz,dKern,GrdDatSz,DatLen,KernSz,iKern,chW);

	cudaDeviceSynchronize();												// make sure finished	

	const char* Error0 = cudaGetErrorString(cudaGetLastError());
	strcpy(Error,Error0);
}
							

