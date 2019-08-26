///==========================================================
/// (v1a)
///		
///==========================================================

extern "C" void MultiDevSampArrCombS(int Dst, int Src, size_t *HSampDat, size_t *HSampDatTemp, int DatLen, char* Error);
						

///=====================================================
/// SampArrCombS (kernel)					
///=====================================================
__global__ void SampArrCombS(float* dSampDatDst, float* dSampDatDstTemp, int DatLen)
{
int j;
j = blockDim.x*blockIdx.x + threadIdx.x;

if (j < DatLen) {
    dSampDatDstTemp[j] = dSampDatDstTemp[j] + dSampDatDst[j];
	}
}

///=====================================================
/// Code Entry
///=====================================================
void MultiDevSampArrCombS(int Dst, int Src, size_t *HSampDat, size_t *HSampDatTemp, int DatLen, char* Error){
    
    float *dSampDatDst,*dSampDatSrc,*dSampDatDstTemp;
    dSampDatDst = (float*)HSampDat[Dst];
    dSampDatSrc = (float*)HSampDat[Src];
    dSampDatDstTemp = (float*)HSampDatTemp[Dst];
    size_t DatLenBytes = sizeof(float)*DatLen;

    cudaMemcpyPeer(dSampDatDstTemp,Dst,dSampDatSrc,Src,DatLenBytes);
	cudaDeviceSynchronize();												// make sure finished	

    int tpb = 128;                                                          // Equal to number of cores in multiprocessor (6.1)
	int bpg = int(ceil(float(DatLen)/float(tpb)));  
    cudaSetDevice(Dst);
    SampArrCombS<<<bpg,tpb>>>(dSampDatDst,dSampDatDstTemp,DatLen);
	cudaDeviceSynchronize();												// make sure finished	

	const char* Error0 = cudaGetErrorString(cudaGetLastError());
	strcpy(Error,Error0);
}
							

