%==================================================
% 
%==================================================

function TestRwsImageRecon_LoadKernel

%--------------------------------------
% Load Test Data
%--------------------------------------
load('TestData01','Kern','chW','iKern');

%--------------------------------------
% Reset Gpus
%--------------------------------------
GpuNum = gpuDeviceCount;
for n = 1:GpuNum
    gpuDevice(n);               
end
                        
%--------------------------------------
% RwsImageRecon Start
%--------------------------------------         
RECON = RwsImageRecon(GpuNum);

%--------------------------------------
% Load Kernel
%-------------------------------------- 
tic
RECON.LoadKernelGpuMem(Kern,iKern,chW);
toc

TestGpuNum = 1;
tic
Kern2 = RECON.TestKernelInGpuMem(TestGpuNum);
toc

test = isequal(Kern,Kern2)