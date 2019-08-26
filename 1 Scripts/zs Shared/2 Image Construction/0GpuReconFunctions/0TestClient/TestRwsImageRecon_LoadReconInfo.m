%==================================================
% 
%==================================================

function TestRwsImageRecon_LoadReconInfo

%--------------------------------------
% Load Test Data
%--------------------------------------
ClientData = [];
load('TestData01','ClientData');

%--------------------------------------
% Reset Gpus
%--------------------------------------
GpuNum = gpuDeviceCount;
% for n = 1:GpuNum
%     gpuDevice(n);               
% end
                        
%--------------------------------------
% RwsImageRecon Start
%--------------------------------------         
RECON = RwsImageRecon(GpuNum);

%--------------------------------------
% RwsImageRecon Start
%--------------------------------------  
ReconInfo = ClientData(:,:,1:4);                % (Np x Nacq x 4)  [Kx,Ky,Kz,SDC]
tic
RECON.AllocateReconInfoGpuMem(size(ReconInfo));
toc

tic
RECON.LoadReconInfoGpuMem(ReconInfo);
toc

TestGpuNum = 0;
ReconInfo2 = RECON.TestReconInfoInGpuMem(TestGpuNum);

test = isequal(ReconInfo,ReconInfo2)

