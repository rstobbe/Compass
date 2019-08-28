%==================================================
% 
%==================================================

function TestRwsImageRecon_Total

global ClientData
global Ksz
global Kern
global chW
global iKern

%addpath('D:\CompassRelated\4 OtherFiles\CudaDLL');

%--------------------------------------
% Reset Gpus
%--------------------------------------
reset = 1;
if reset == 1
    GpuTot = gpuDeviceCount;
    for n = 1:GpuTot
        GpuParams = gpuDevice(n);               
    end
end

%--------------------------------------
% Simulated Data 
%--------------------------------------   
sz = size(ClientData);                 
ClientDataTot.Np = sz(1);
ClientDataTot.Nacq = sz(2);                                
ClientDataTot.Nchan = sz(3) - 4;
%ClientDataTot.Chunk = 6272;
ClientDataTot.Chunk = 1568;
ClientDataTot.Ksz = Ksz;
ClientDataTot.ClientData = ClientData;

%--------------------------------------
% Initialize
%   - things that can be done when server started (before data arrives from client)   
%--------------------------------------    
GpuTot = gpuDeviceCount;
RECON = RwsImageRecon(GpuTot,GpuParams);
disp('Load Kernel All GPUs');
tic
RECON.LoadKernelGpuMem(Kern,iKern,chW);
toc

%--------------------------------------
% Simulated Server
%   - client will do Nacq writes to server
%--------------------------------------  
Counter = 0;
ChunkNumber = 1;
for n = 1:ClientDataTot.Nacq
            
    Counter = Counter + 1;
    [Data,Info] = SimulatedData(ClientDataTot,n);      % what comes from server will be data and some info 
    
    %--------------------------------------
    % If first data - allocated memory (GPU and Host)
    %--------------------------------------  
    if n == 1
        ReconInfoSize = [Info.Np Info.Chunk 4];
        ReconInfo = single(zeros(ReconInfoSize)); 
        ReconInfoSizeGpu = ReconInfoSize;
        disp('Allocate Recon Info GPU Memory');
        tic
        RECON.AllocateReconInfoGpuMem(ReconInfoSizeGpu);                        % allocate on all GPUs     
        toc
        SampDatSize = [Info.Np Info.Chunk Info.Nchan];
        SampDat = single(complex(zeros(SampDatSize),zeros(SampDatSize))); 
        SampDatSizeGpu = SampDatSize(1:2);
        disp('Allocate SampDat GPU Memory');
        tic
        RECON.AllocateSampDatGpuMem(SampDatSizeGpu);  
        toc
        ImageMatrixSize = [Info.Ksz Info.Ksz Info.Ksz Info.Nchan];  
        ImageMatrixSizeGpu = ImageMatrixSize(1:3);
        disp('Allocate Image Matrix GPU Memory');
        tic
        RECON.AllocateImageMatrixGpuMem(ImageMatrixSizeGpu);
        toc
    end
    
    %--------------------------------------
    % Build Matrices
    %--------------------------------------      
    ReconInfo(:,Counter,:) = Data(:,1:4);       % First 4 = [Kx,Ky,Kz,SDC]
    SampDat(:,Counter,:) = Data(:,5:end);       % 5:end = Data from different channels
    
    %--------------------------------------
    % If received 'Chunk' 
    %   - write to GPU and run gridding
    %--------------------------------------  
    if Counter == Info.Chunk
        
        disp(['Load ReconInfo Chunk ',num2str(ChunkNumber)]);
        tic
        RECON.LoadReconInfoGpuMemAsync(ReconInfo);   % will write to all GPUs
        toc
        
        for m = 1:2
            GpuNum = m-1;
            SampDat0 = SampDat(:,:,m);                          % this operation is a bit slow...
            disp(['Load Sampdat GPU ',num2str(m)]);
            tic
            RECON.LoadSampDatGpuMemAsync(GpuNum,SampDat0);      % write different channels to different GPUs
            toc
            disp(['Grid GPU ',num2str(m)]);
            tic
            RECON.GridSampDat(GpuNum);
            toc
        end
        Counter = 0;
        ChunkNumber = ChunkNumber+1;
    end 
    %pause(0.001);
end

disp('CudaWait');
tic
RECON.CudaDeviceWait(GpuNum);
toc


%--------------------------------------
% Finish
%-------------------------------------- 
ImageMatrix = single(complex(zeros(ImageMatrixSize),zeros(ImageMatrixSize)));    
for m = 1:Info.Nchan
    GpuNum = m-1;
    ImageMatrix(:,:,:,m) = RECON.ReturnImageMatrixGpuMem(GpuNum);
    ImageMatrix(:,:,:,m) = ifftshift(ifftn(ifftshift(ImageMatrix(:,:,:,m))));             % Fourier Transform
end

%--------------------------------------
% Test
%-------------------------------------- 
TestImage = 1;
ImageMatrix = ImageMatrix(:,:,:,TestImage);
figure(12341235);
test = max(abs(ImageMatrix(:)))
imshow(squeeze(abs(ImageMatrix(:,:,Ksz/2)))/test);




%===========================================================
function [Data,Info] = SimulatedData(ClientDataTot,n)
    %Data = squeeze(ClientDataTot.ClientData(:,n,:));          
    Data = squeeze(ClientDataTot.ClientData(:,n,1:6));  
    Info.Np = ClientDataTot.Np;
    Info.Nacq = ClientDataTot.Nacq;                              
    %Info.Nchan = ClientDataTot.Nchan;
    Info.Nchan = 2;
    Info.Chunk = ClientDataTot.Chunk;
    Info.Ksz = ClientDataTot.Ksz;
    
