///==========================================================
/// (v1a)
///		
///==========================================================

extern "C" void MultiDevMatAddCS(int Dst, int Src, size_t *HGrdDat, size_t *HGrdDatTemp, int MatSize, char* Error);
						

///=====================================================
/// MatAdd (kernel)					
///=====================================================
__global__ void MatAdd(float* dGdatDst, float* dGdatDstTemp, int MatLen)
{
int j;
j = blockDim.x*blockIdx.x + threadIdx.x;

if (j < MatLen) {
    dGdatDstTemp[j] = dGdatDstTemp[j] + dGdatDst[j];
	}
}

///=====================================================
/// Code Entry
///=====================================================
void MultiDevMatAddCS(int Dst, int Src, size_t *HGrdDat, size_t *HGrdDatTemp, int MatSize, char* Error){
    
    float *dGdatDst,*dGdatSrc,*dGdatDstTemp;
    dGdatDst = (float*)HGrdDat[Dst];
    dGdatSrc = (float*)HGrdDat[Src];
    dGdatDstTemp = (float*)HGrdDatTemp[Dst];
    int MatLen = MatSize*MatSize*MatSize*2;
    size_t MatSizeBytes = sizeof(float)*MatLen;

    cudaMemcpyPeer(dGdatDstTemp,Dst,dGdatSrc,Src,MatSizeBytes);
	cudaDeviceSynchronize();												// make sure finished	

    int tpb = 128;                                                          // Equal to number of cores in multiprocessor (6.1)
	int bpg = int(ceil(float(MatLen)/float(tpb)));  
    cudaSetDevice(Dst);
    MatAdd<<<bpg,tpb>>>(dGdatDst,dGdatDstTemp,MatLen);
	cudaDeviceSynchronize();												// make sure finished	

	const char* Error0 = cudaGetErrorString(cudaGetLastError());
	strcpy(Error,Error0);
}
							

