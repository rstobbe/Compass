///==========================================================
/// (v1a)
///		
///==========================================================

extern "C" void MultiDevSampArrComb(int Dst, int Src, size_t *HSampDat, size_t *HSampDatTemp, int DatLen, char* Error);
						

///=====================================================
/// SampArrComb (kernel)					
///=====================================================
__global__ void SampArrComb(double* dSampDatDst, double* dSampDatDstTemp, int DatLen)
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
void MultiDevSampArrComb(int Dst, int Src, size_t *HSampDat, size_t *HSampDatTemp, int DatLen, char* Error){
    
    double *dSampDatDst,*dSampDatSrc,*dSampDatDstTemp;
    dSampDatDst = (double*)HSampDat[Dst];
    dSampDatSrc = (double*)HSampDat[Src];
    dSampDatDstTemp = (double*)HSampDatTemp[Dst];
    size_t DatLenBytes = sizeof(double)*DatLen;

    cudaMemcpyPeer(dSampDatDstTemp,Dst,dSampDatSrc,Src,DatLenBytes);
	cudaDeviceSynchronize();												// make sure finished	

    int tpb = 128;                                                          // Equal to number of cores in multiprocessor (6.1)
	int bpg = int(ceil(double(DatLen)/double(tpb)));  
    cudaSetDevice(Dst);
    SampArrComb<<<bpg,tpb>>>(dSampDatDst,dSampDatDstTemp,DatLen);
	cudaDeviceSynchronize();												// make sure finished	

	const char* Error0 = cudaGetErrorString(cudaGetLastError());
	strcpy(Error,Error0);
}
							

