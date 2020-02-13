function InverseFourierTransformWithShift

GpuNum = uint64(0);
ImageMatrixMemDims = uint64([512,512,512]);
Kspace = complex(rand(ImageMatrixMemDims,'single'),rand(ImageMatrixMemDims,'single'));

tic
[HKspaceMatrix,Error] = AllocateLoadComplexSingleGpuMem61(GpuNum,Kspace);
[Error] = CudaDeviceWait(GpuNum);
disp('Load Kspace')
toc
%tic
[HTempMatrix,Error] = AllocateComplexMatrixSingleGpuMem61(GpuNum,ImageMatrixMemDims);
[Error] = CudaDeviceWait(GpuNum);
disp('Allocate Temp')
toc
%tic
[HImageMatrix,Error] = AllocateComplexMatrixSingleGpuMem61(GpuNum,ImageMatrixMemDims);
[Error] = CudaDeviceWait(GpuNum);
disp('Allocate Image')
toc
%tic
[HFourierTransformPlan,Error] = CreateFourierTransformPlanSingleGpu61(GpuNum,ImageMatrixMemDims);
[Error] = CudaDeviceWait(GpuNum);
disp('Create FFT Plan')
toc
%tic
[Error] = FourierTransformShiftSingleGpu61(GpuNum,HKspaceMatrix,HTempMatrix,ImageMatrixMemDims);
[Error] = CudaDeviceWait(GpuNum);
disp('FFT Shift')
toc
%tic
[Error] = ExecuteInverseFourierTransformSingleGpu61(GpuNum,HImageMatrix,HKspaceMatrix,HFourierTransformPlan);
[Error] = CudaDeviceWait(GpuNum);
disp('FFT')
toc
%tic
[Image,Error] = ReturnComplexMatrixSingleGpu61(GpuNum,HImageMatrix,ImageMatrixMemDims);
[Error] = CudaDeviceWait(GpuNum);
disp('Return Image')
toc
%tic
[Error] = TeardownFourierTransformPlanSglGpu61(GpuNum,HFourierTransformPlan);
[Error] = CudaDeviceWait(GpuNum);
disp('Teardown FFT Plan')
toc
%tic
[Error] = FreeSingleGpuMem61(GpuNum,HKspaceMatrix);
[Error] = FreeSingleGpuMem61(GpuNum,HTempMatrix);
[Error] = FreeSingleGpuMem61(GpuNum,HImageMatrix);
[Error] = CudaDeviceWait(GpuNum);
disp('Free Gpu Mem')
toc
Error

Test = sum(Image(:))/(512^3)

tic
Image0 = ifftn(fftshift(Kspace));
toc
Test = sum(Image0(:))

tic
gKspace = gpuArray(Kspace);
toc
Image1 = ifftn(fftshift(gKspace));
toc
Test = sum(Image1(:))
toc

