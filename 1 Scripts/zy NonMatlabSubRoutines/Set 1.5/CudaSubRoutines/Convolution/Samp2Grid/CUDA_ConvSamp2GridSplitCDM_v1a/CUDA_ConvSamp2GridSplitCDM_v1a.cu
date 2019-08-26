///==========================================================
/// (v1a)
///		- Use CUDA's atomicAdd (only available on compute 6.x and later)
///  	- switch to lrint
///		(still to-do: remove (j<DatLen) check)
///==========================================================

extern "C" void ConvSamp2GridSplitCDM(int Count, size_t *HSampDatR, size_t *HSampDatI, size_t *HGrdDat, size_t *HKx, size_t *HKy, size_t *HKz, size_t *HKern, 
							int GrdDatSz, int DatLen, int KernSz, int iKern, int chW, int SampDatAdr, char* Error);
						

///=====================================================
/// Conv3D (kernel)					
///=====================================================
__global__ void Conv3D(double* dSDatR, double* dSDatI, double* dGDat, double* dKx, double* dKy, double* dKz, double* dKern, 
						int GrdDatSz, int DatLen, int KernSz, int iKern, int chW)
{
int xF,yF,zF;
int xflr,yflr,zflr;
double DatValR,DatValI,KernVal;
int j,a,b,c;
j = blockDim.x*blockIdx.x + threadIdx.x;

if (j < DatLen) {
    DatValR = dSDatR[j];
    DatValI = dSDatI[j];	
	xflr = __double2int_rd(dKx[j]);
    yflr = __double2int_rd(dKy[j]);
    zflr = __double2int_rd(dKz[j]);   
	//xF = lround(iKern*(dKx[j]-xflr));     		// halfway rounded away from zero      
    //yF = lround(iKern*(dKy[j]-yflr)); 
    //zF = lround(iKern*(dKz[j]-zflr));	
	xF = lrint(iKern*(dKx[j]-xflr)); 				// halfway rounded to nearest even integer (supposedly faster)     
    yF = lrint(iKern*(dKy[j]-yflr)); 
    zF = lrint(iKern*(dKz[j]-zflr));	
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
				atomicAdd((dGDat+((xflr+a-1)*2)+((yflr+b-1)*GrdDatSz*2)+((zflr+c-1)*GrdDatSz*GrdDatSz*2)),(KernVal*DatValR));
				atomicAdd((dGDat+((xflr+a-1)*2+1)+((yflr+b-1)*GrdDatSz*2)+((zflr+c-1)*GrdDatSz*GrdDatSz*2)),(KernVal*DatValI));
				}
			}
		}  
	}
}

///=====================================================
/// Code Entry
///=====================================================
void ConvSamp2GridSplitCDM(int Count, size_t *HSampDatR, size_t *HSampDatI, size_t *HGrdDat, size_t *HKx, size_t *HKy, size_t *HKz, size_t *HKern, 
							int GrdDatSz, int DatLen, int KernSz, int iKern, int chW, int SampDatAdr, char* Error){

	double *dSDatR,*dSDatI,*dGDat,*dKx,*dKy,*dKz,*dKern;
	int tpb = 128;                                                          // Equal to number of cores in multiprocessor (6.1). Should be multiple of warp_size=32.
    int PtsPerDevice = int(ceil(double(DatLen)/double(Count)));
	int bpg = int(ceil(double(PtsPerDevice)/double(tpb)));  
    for (int n=0; n<Count; n++){	
        cudaSetDevice(n);
        dSDatR = (double*)(HSampDatR[n]+(SampDatAdr+n*PtsPerDevice)*sizeof(double));
        dSDatI = (double*)(HSampDatI[n]+(SampDatAdr+n*PtsPerDevice)*sizeof(double));
        dGDat = (double*)HGrdDat[n];
        dKx = (double*)(HKx[n]+(SampDatAdr+n*PtsPerDevice)*sizeof(double));
        dKy = (double*)(HKy[n]+(SampDatAdr+n*PtsPerDevice)*sizeof(double));	
        dKz = (double*)(HKz[n]+(SampDatAdr+n*PtsPerDevice)*sizeof(double));
        dKern = (double*)HKern[n];	                
        Conv3D<<<bpg,tpb>>>(dSDatR,dSDatI,dGDat,dKx,dKy,dKz,dKern,GrdDatSz,PtsPerDevice,KernSz,iKern,chW);
    }
	cudaDeviceSynchronize();												// make sure finished	
	const char* Error0 = cudaGetErrorString(cudaGetLastError());
	strcpy(Error,Error0);
}	
							
						
							