///==========================================================
/// (v1a)
///		
///==========================================================

extern "C" void MultiDevMatAdd(int Dst, int Src, size_t *HGrdDat, size_t *HGrdDatTemp, int MatSize, char* Error);
						

///=====================================================
/// MatAdd (kernel)					
///=====================================================
__global__ void MatAdd(double* dGdatDst, double* dGdatDstTemp, int MatLen)
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
void MultiDevMatAdd(int Dst, int Src, size_t *HGrdDat, size_t *HGrdDatTemp, int MatSize, char* Error){
    
    double *dGdatDst,*dGdatSrc,*dGdatDstTemp;
    dGdatDst = (double*)HGrdDat[Dst];
    dGdatSrc = (double*)HGrdDat[Src];
    dGdatDstTemp = (double*)HGrdDatTemp[Dst];
    int MatLen = MatSize*MatSize*MatSize;
    size_t MatSizeBytes = sizeof(double)*MatLen;

    cudaMemcpyPeer(dGdatDstTemp,Dst,dGdatSrc,Src,MatSizeBytes);
	cudaDeviceSynchronize();												// make sure finished	

    int tpb = 128;                                                          // Equal to number of cores in multiprocessor (6.1)
	int bpg = int(ceil(double(MatLen)/double(tpb)));  
    cudaSetDevice(Dst);
    MatAdd<<<bpg,tpb>>>(dGdatDst,dGdatDstTemp,MatLen);
	cudaDeviceSynchronize();												// make sure finished	

	const char* Error0 = cudaGetErrorString(cudaGetLastError());
	strcpy(Error,Error0);
}
							

