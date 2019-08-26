%==================================================
% (v5a)
%   - Update for Parallel GPUs
%==================================================

function [CDat,err] = mS2GCUDADoubleR_v5a(Ksz,Kx,Ky,Kz,KERN,SampDat,CONV,StatLev)

err.flag = 0;
err.msg = '';

global FIGOBJS
global RWSUIGBL
arr = (1:10);
tab = strcmp(FIGOBJS.TABGP.SelectedTab.Title,RWSUIGBL.AllTabs);
tab = arr(tab);

if StatLev == 0
    Stathands = 0;
elseif StatLev == 2
    Stathands = FIGOBJS.Status(tab,2);
elseif StatLev == 3
    Stathands = FIGOBJS.Status(tab,3);
end
Status2('busy','CUDA',StatLev);

%------------------------------------
% CUDA timeout related (chunk size)
%------------------------------------
if CONV.chW >= 50
    error();                
elseif CONV.chW >= 40
    chunklen = 2000;
elseif CONV.chW >= 30
    chunklen = 4000;
elseif CONV.chW >= 20
    chunklen = 8000;
else 
    chunklen = 16000;
end

%------------------------------------
% Input
%------------------------------------
SampDat = double(real(SampDat));
Kx = double(Kx);
Ky = double(Ky);
Kz = double(Kz);
Kern = double(KERN.Kern);
iKern = int32(KERN.iKern);
chW = int32(CONV.chW);
Ksz = int32(Ksz);
chunklen = int32(chunklen);

%------------------------------------
% Test (one GPU)
%------------------------------------
if gpuDeviceCount < 2
    gpuDevice(1) 
    tic
    device = 0000; 
    [CDatTest,Test1,Error1] = S2GCUDADoubleR_v4g(SampDat,Kx,Ky,Kz,Kern,iKern,chW,Ksz,chunklen,device,Stathands);
    %[CDatTest,Test1,Error1] = S2GCUDADoubleR_v5a(SampDat,Kx,Ky,Kz,Kern,iKern,chW,Ksz,chunklen,Stathands);
    toc
    if not(strcmp(Error1,'no error'))
        CUDAerror = Error1
        error();
    end
else    
    %gpuDevice(1)           % reset
    tic
    device = 0000;                              % not used
    [CDatTest,Test1,Error1] = S2GCUDADoubleR_v4g(SampDat,Kx,Ky,Kz,Kern,iKern,chW,Ksz,chunklen,device,Stathands);
    %[CDatTest,Test1,Error1] = S2GCUDADoubleR_v5a(SampDat,Kx,Ky,Kz,Kern,iKern,chW,Ksz,chunklen,Stathands);
    toc
    if not(strcmp(Error1,'no error'))
        CUDAerror = Error1
        error();
    end    
    
    SampDatSplt{1} = SampDat(1:length(SampDat)/2);
    SampDatSplt{2} = SampDat(length(SampDat)/2+1:end);
    KxSplt{1} = Kx(1:length(Kx)/2); 
    KxSplt{2} = Kx(length(Kx)/2+1:end);
    KySplt{1} = Ky(1:length(Ky)/2); 
    KySplt{2} = Ky(length(Ky)/2+1:end); 
    KzSplt{1} = Kz(1:length(Kz)/2); 
    KzSplt{2} = Kz(length(Kz)/2+1:end); 

    tic
    parfor n = 1:2
        parallel.gpu.GPUDevice.select(n);
        [CDatArr{n},Test,Error{n}] = S2GCUDADoubleR_v4g(SampDatSplt{n},KxSplt{n},KySplt{n},KzSplt{n},Kern,iKern,chW,Ksz,chunklen,device,Stathands);
        %[CDatArr{n},Test,Error{n}] = S2GCUDADoubleR_v5a(SampDatSplt{n},KxSplt{n},KySplt{n},KzSplt{n},Kern,iKern,chW,Ksz,chunklen,Stathands);
    end
    CDat = CDatArr{1} + CDatArr{2};
    toc
  
    test = sum(abs(CDat(:)-CDatTest(:)))
    test2 = sum(abs(CDat(:)))
    for n = 1:2
        if not(strcmp(Error{n},'no error'))
            CUDAerror = Error{n}
            error();
        end
    end
end

Status2('done','',StatLev);
