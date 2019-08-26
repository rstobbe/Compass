///==========================================================
/// (v2a)
///		- 
///==========================================================

extern "C" void ConvSamp2GridComplex(size_t *GpuNum, size_t *HSampDat, size_t *HReconInfo, size_t *HKernel, size_t *HImageMatrix, size_t *ProjStart, 
                                        size_t *SampDatMemDims, size_t *ReconInfoMemDims, size_t *KernelMemDims, size_t *ImageMatrixMemDims, 
                                        size_t *iKern, size_t *KernHw, char *Error);
						

///=====================================================
/// Conv3D (kernel)					
///=====================================================
__global__ void Conv3D(float* dSampDat, float* dReconInfo, float* dKernel, float* dImageMatrix, int ProjStart,
					   int ReconInfoMemDims, int KernelMemDims0, int KernelMemDims1, int ImageMatrixMemDims0,  int ImageMatrixMemDims1, int iKern, int KernHw, int PtsPerDevice)
{
int Start;
float Kx,Ky,Kz,Sdc;
int xF,yF,zF;
int xflr,yflr,zflr;
float DatValR,DatValI;
float KernVal;
int j,a,b,c;
j = blockDim.x*blockIdx.x + threadIdx.x;

if (j < PtsPerDevice) {

    Start = 4*ProjStart*ReconInfoMemDims;
    Kx = dReconInfo[Start+4*j];
    Ky = dReconInfo[Start+4*j+1];
    Kz = dReconInfo[Start+4*j+2];
    Sdc = dReconInfo[Start+4*j+3];

	xflr = __float2int_rd(Kx);
    yflr = __float2int_rd(Ky);
    zflr = __float2int_rd(Kz);   
	xF = lrint(iKern*(Kx-xflr)); 				// halfway rounded to nearest even integer (supposedly faster)     
    yF = lrint(iKern*(Ky-yflr)); 
    zF = lrint(iKern*(Kz-zflr));	
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

    DatValR = dSampDat[2*j]*Sdc;
    DatValI = dSampDat[2*j+1]*Sdc;	
    
    for(c=-KernHw; c<=KernHw+1; c++) {
        for(b=-KernHw; b<=KernHw+1; b++) {
            for(a=-KernHw; a<=KernHw+1; a++) {
				KernVal = dKernel[lrint(fabsf(xF-(a*iKern))) + lrint(fabsf(yF-(b*iKern)))*KernelMemDims0 + lrint(fabsf(zF-(c*iKern)))*KernelMemDims0*KernelMemDims1];		
				atomicAdd((dImageMatrix+((xflr+a-1)*2)+((yflr+b-1)*ImageMatrixMemDims0*2)+((zflr+c-1)*ImageMatrixMemDims0*ImageMatrixMemDims1*2)),(KernVal*DatValR));
				atomicAdd((dImageMatrix+((xflr+a-1)*2+1)+((yflr+b-1)*ImageMatrixMemDims0*2)+((zflr+c-1)*ImageMatrixMemDims0*ImageMatrixMemDims1*2)),(KernVal*DatValI));
				}
			}
		}
	}
}

///=====================================================
/// Code Entry
///=====================================================
void ConvSamp2GridComplex(size_t *GpuNum, size_t *HSampDat, size_t *HReconInfo, size_t *HKernel, size_t *HImageMatrix, size_t *ProjStart, 
                            size_t *SampDatMemDims, size_t *ReconInfoMemDims, size_t *KernelMemDims, size_t *ImageMatrixMemDims, 
                            size_t *iKern, size_t *KernHw, char *Error)
{
float *dSampDat,*dReconInfo,*dKernel,*dImageMatrix;
int tpb = 128;                                                          // Equal to number of cores in multiprocessor (6.1). Should be multiple of warp_size=32.
int PtsPerDevice = SampDatMemDims[0]*SampDatMemDims[1];
int bpg = int(ceil(float(PtsPerDevice)/float(tpb)));  
for (int n=0; n<GpuNum[0]; n++){	
    cudaSetDevice(n);
    dSampDat = (float*)HSampDat[n];
    dReconInfo = (float*)HReconInfo[n];
    dKernel = (float*)HKernel[n];
    dImageMatrix = (float*)HImageMatrix[n];               
    Conv3D<<<bpg,tpb>>>(dSampDat,dReconInfo,dKernel,dImageMatrix,ProjStart[0],ReconInfoMemDims[0],KernelMemDims[0],KernelMemDims[1],ImageMatrixMemDims[0],ImageMatrixMemDims[1],iKern[0],KernHw[0],PtsPerDevice);
    }
cudaDeviceSynchronize();												// make sure finished	
const char* Error0 = cudaGetErrorString(cudaGetLastError());
strcpy(Error,Error0);
}	
							
						
							