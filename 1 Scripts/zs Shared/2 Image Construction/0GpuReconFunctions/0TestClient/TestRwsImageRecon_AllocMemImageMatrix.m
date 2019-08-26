%==================================================
% 
%==================================================

function TestRwsImageRecon_AllocMemImageMatrix

%--------------------------------------
% Load Test Data
%--------------------------------------
load('TestData','Ksz');

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
% Allocate Memory Image Matrix
%-------------------------------------- 
RECON.AllocateImageMatrixGpuMem([Ksz,Ksz,Ksz]);

TestGpuNum = 0;
tic
ImageMatrix = RECON.ReturnImageMatrixGpuMem(TestGpuNum);
toc

test = sum(ImageMatrix(:))