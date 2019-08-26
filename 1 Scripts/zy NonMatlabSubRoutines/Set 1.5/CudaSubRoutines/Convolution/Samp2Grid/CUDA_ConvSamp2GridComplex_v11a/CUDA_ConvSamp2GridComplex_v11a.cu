///==========================================================
/// (v2a)
///		- 
///==========================================================

extern "C" void ConvSamp2GridComplex(size_t *GpuNum, size_t *HSampDat, size_t *HReconInfo, size_t *HKernel, size_t *HImageMatrix,
                                        size_t *SampDatMemDims, size_t *KernelMemDims, size_t *ImageMatrixMemDims, 
                                        size_t *iKern, size_t *KernHw, char *Error);
						

///=====================================================
/// Conv3D (kernel)					
///=====================================================
__global__ void Conv3D(float* dSampDat, float* dReconInfo, float* dKernel, float* dImageMatrix, 
					   int KernelMemDims, int ImageMatrixMemDims0,  int ImageMatrixMemDims1, int iKern, int KernHw, int SampDatLength)
{
float Kx,Ky,Kz,Sdc;
int xF,yF,zF;
int xflr,yflr,zflr;
float DatValR,DatValI;
float KernVal;
int j,a,b,c;
j = blockDim.x*blockIdx.x + threadIdx.x;

if (j < SampDatLength) {

    Kx = dReconInfo[j];
    Ky = dReconInfo[SampDatLength+j];
    Kz = dReconInfo[2*SampDatLength+j];
    Sdc = dReconInfo[3*SampDatLength+j];
    
    DatValR = dSampDat[2*j]*Sdc;
    DatValI = dSampDat[2*j+1]*Sdc;	
    
	xflr = __float2int_rd(Kx);
    yflr = __float2int_rd(Ky);
    zflr = __float2int_rd(Kz);   
	xF = lrintf(iKern*(Kx-xflr)); 				// halfway rounded to nearest even integer (supposedly faster)     
    yF = lrintf(iKern*(Ky-yflr)); 
    zF = lrintf(iKern*(Kz-zflr));	
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
       
    for(c=-KernHw; c<=KernHw+1; c++) {
        for(b=-KernHw; b<=KernHw+1; b++) {
            for(a=-KernHw; a<=KernHw+1; a++) {
				KernVal = dKernel[lrintf(fabsf(xF-(a*iKern))) + lrintf(fabsf(yF-(b*iKern)))*KernelMemDims + lrintf(fabsf(zF-(c*iKern)))*KernelMemDims*KernelMemDims];
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
void ConvSamp2GridComplex(size_t *GpuNum, size_t *HSampDat, size_t *HReconInfo, size_t *HKernel, size_t *HImageMatrix,
                            size_t *SampDatMemDims, size_t *KernelMemDims, size_t *ImageMatrixMemDims, 
                            size_t *iKern, size_t *KernHw, char *Error)
{
float *dSampDat,*dReconInfo,*dKernel,*dImageMatrix;
int tpb = 128;                                                          // Equal to number of cores in multiprocessor (6.1). Should be multiple of warp_size=32.
int SampDatLength = SampDatMemDims[0]*SampDatMemDims[1];
int bpg = int(ceil(float(SampDatLength)/float(tpb)));  

cudaSetDevice(GpuNum[0]);
dSampDat = (float*)HSampDat[GpuNum[0]];
dReconInfo = (float*)HReconInfo[GpuNum[0]];
dKernel = (float*)HKernel[GpuNum[0]];
dImageMatrix = (float*)HImageMatrix[GpuNum[0]];               
Conv3D<<<bpg,tpb>>>(dSampDat,dReconInfo,dKernel,dImageMatrix,KernelMemDims[0],ImageMatrixMemDims[0],ImageMatrixMemDims[1],iKern[0],KernHw[0],SampDatLength);

cudaSetDevice(GpuNum[0]);

// cudaDeviceSynchronize();												// asynchronous exit
// const char* Error0 = cudaGetErrorString(cudaGetLastError());
// strcpy(Error,Error0);
}	
							
						
							