%==================================================
% (v5b)
%   - Parallel GPUs (single CPU thread)
%==================================================

function [CDat,err] = mS2GCUDASingleR_v5b(Ksz,Kx,Ky,Kz,KERN,SampDat,CONV,StatLev,CUDA)

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
% CUDA Specifics
%------------------------------------
NumberGpus = CUDA.Index;
ComputeCapability = str2double(CUDA.ComputeCapability);
if ComputeCapability == 6.1 || ComputeCapability == 6.2
    CoresPerMultiProcessor = 128;
end
MultiprocessorCount = CUDA.MultiprocessorCount;
TotalCoresInPlay = CoresPerMultiProcessor*MultiprocessorCount*NumberGpus;
%GpuThreadsAtATime = MultiprocessorCount*2048;

%------------------------------------
% Test for context
%------------------------------------
mKx = round(mean(Kx(1:50)));
mKy = round(mean(Ky(1:50)));
mKz = round(mean(Kz(1:50)));
if mKx == mKy && mKx == mKz
    context = 'RadSamp';
else
    context = 'Other';
end

%------------------------------------
% CUDA optimization (emperical testing)
%------------------------------------
if strcmp(context,'Other')
    if CONV.chW >= 29
        chunklen = TotalCoresInPlay;                
    elseif CONV.chW >= 14
        chunklen = TotalCoresInPlay*4;                
    elseif CONV.chW >= 11
        chunklen = TotalCoresInPlay*6;              % guess
    elseif CONV.chW >= 7
        chunklen = TotalCoresInPlay*6;  
    elseif CONV.chW >= 5
        chunklen = TotalCoresInPlay*10;  
    elseif CONV.chW >= 3
        chunklen = TotalCoresInPlay*16;             % guess  
    elseif CONV.chW == 2
        chunklen = TotalCoresInPlay*20;    
    else
        error;  % finish                        
    end
elseif strcmp(context,'RadSamp')
    if CONV.chW == 7
        chunklen = TotalCoresInPlay*2;                 
    else
        chunklen = TotalCoresInPlay*2;      
        %error;  % finish
    end
elseif strcmp(context,'Other') 
    error;  % finish
end

%------------------------------------
% Input
%------------------------------------
SampDat0 = single(real(SampDat));
Kx0 = single(Kx);
Ky0 = single(Ky);
Kz0 = single(Kz);
Kern = single(KERN.Kern);
iKern = int32(KERN.iKern);
chW = int32(CONV.chW);
Ksz = int32(Ksz);
chunklen = int32(chunklen);

%------------------------------------
% Zerofill to chunklen multiple
%------------------------------------
Len0 = length(SampDat0);
Len = chunklen*ceil(Len0/double(chunklen));
SampDat = zeros(1,Len,'single');
Kx = Kx0(1)*ones(Len,1,'single');
Ky = Ky0(1)*ones(Len,1,'single');
Kz = Kz0(1)*ones(Len,1,'single');
SampDat(1:Len0) = SampDat0;
Kx(1:Len0) = Kx0;
Ky(1:Len0) = Ky0;
Kz(1:Len0) = Kz0;

%--------------------------------------
% Reset Gpus
%--------------------------------------
% ResetGpus = 'Yes';
% if strcmp(ResetGpus,'Yes')
%     Status2('busy','Reset GPUs',3);
%     NoGPUs = gpuDeviceCount;
%     for n = 1:NoGPUs
%         gpuDevice(n);               
%     end
% end

%------------------------------------
% Convolve
%------------------------------------
%tic
[CDat,Test,Error] = S2GCUDASingleR_v5b(SampDat,Kx,Ky,Kz,Kern,iKern,chW,Ksz,chunklen,Stathands);
%toc
%Test
%DataSumTest = sum(CDat(:))
%error
if not(strcmp(Error,'no error'))
    CUDAerror = Error
    error();
end
%error

Status2('done','',StatLev);
