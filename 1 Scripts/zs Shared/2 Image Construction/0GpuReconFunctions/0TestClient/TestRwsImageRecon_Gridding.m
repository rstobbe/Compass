%==================================================
% 
%==================================================

function TestRwsImageRecon_Gridding
%--------------------------------------
% Load Test Data
%--------------------------------------
ClientData = [];
load('TestData_N6272','ClientData','Kern','chW','iKern','Ksz');

%--------------------------------------
% Reset Gpus
%--------------------------------------
GpuTot = gpuDeviceCount;
for n = 1:GpuTot
    gpuDevice(n);               
end
                        
%--------------------------------------
% RwsImageRecon Start
%--------------------------------------         
RECON = RwsImageRecon(GpuTot);
tic
RECON.LoadKernelGpuMem(Kern,iKern,chW);
toc

%--------------------------------------
% Separate Data
%-------------------------------------- 
ReconInfo = ClientData(:,:,1:4);                % (Np x Nacq x 4)  [Kx,Ky,Kz,SDC]
SampDat = ClientData(:,:,5);                    % (Np x Nacq)

%--------------------------------------
% Allocate Memory (on all)
%--------------------------------------  
RECON.AllocateReconInfoGpuMem(size(ReconInfo));
RECON.AllocateSampDatGpuMem(size(SampDat));
RECON.AllocateImageMatrixGpuMem([Ksz,Ksz,Ksz]);
toc

%--------------------------------------
% Load Recon Info
%--------------------------------------  
RECON.LoadReconInfoGpuMem(ReconInfo);
toc

%--------------------------------------
% Load Data
%--------------------------------------  
GpuNum = 0;
RECON.LoadSampDatGpuMemAsync(GpuNum,SampDat);
RECON.CudaDeviceWait(GpuNum);
toc

%--------------------------------------
% Grid
%--------------------------------------  
RECON.GridSampDat(GpuNum);
toc

%--------------------------------------
% Test
%-------------------------------------- 
ImageMatrix = RECON.ReturnImageMatrixGpuMem(GpuNum);

%--------------------------------------
% Fourier Transform
%-------------------------------------- 
ImageMatrix = ifftshift(ifftn(ifftshift(ImageMatrix)));
figure(12341235);
test = max(abs(ImageMatrix(:)))
imshow(squeeze(abs(ImageMatrix(:,:,Ksz/2)))/test);






