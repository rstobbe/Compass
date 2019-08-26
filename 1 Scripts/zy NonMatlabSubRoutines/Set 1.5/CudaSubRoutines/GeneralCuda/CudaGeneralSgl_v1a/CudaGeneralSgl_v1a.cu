///==========================================================
/// CudaDataChunkLoad
///     DatInfo
///         0) Wid          (5)             - Kx,Ky,Kz,Comp,Dat)
///         1) Len          (np*chunk*2)    - the 2 is for complex
///         2) ChanTot      (total channels)
///         3) ChanStart    (channel to start)
///         4) ChanWrite    (channels to write)
///==========================================================
void CudaDataChunkLoad(size_t *Device, float *Mat, size_t *HMat, size_t *MatLen){

	float *dMat;
	size_t MatMem = sizeof(float)*MatLen[0];
    cudaSetDevice(Device[0]);    
    dMat = (float*)HMat[n];
    cudaMemcpyAsync(dMat,Mat,MatMem,cudaMemcpyHostToDevice);
}


