%==================================================
% 
%==================================================

function TestRwsImageRecon_LoadSampDat
%--------------------------------------
% Load Test Data
%--------------------------------------
ClientData = [];
load('TestData01','ClientData');

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
% RwsImageRecon Start
%--------------------------------------  
ReconInfo = ClientData(:,:,1:4);                % (Np x Nacq x 4)  [Kx,Ky,Kz,SDC]
tic
RECON.AllocateReconInfoGpuMem(size(ReconInfo));
toc
SampDat = ClientData(:,:,5);                    % (Np x Nacq)
tic
RECON.AllocateSampDatGpuMem(size(SampDat));
toc

tic
LoadGpuNum = 0;
RECON.LoadSampDatGpuMemAsync(LoadGpuNum,SampDat);
LoadGpuNum = 1;
RECON.LoadSampDatGpuMemAsync(LoadGpuNum,SampDat);
toc

tic
GpuNum = 0;
RECON.CudaDeviceWait(GpuNum);
toc

TestGpuNum = 1;
SampDat2 = RECON.TestSampDatInGpuMem(TestGpuNum);

test = isequal(SampDat,SampDat2)

