%==================================================
% (v5b)
%   - For compute 6.0 and higher (CUDA atomic add)
%==================================================

function [CDat,err] = mS2GCUDADoubleCM_v5b(Ksz,Kx,Ky,Kz,KERN,SampDat,CONV,StatLev,CUDA)

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
ComputeCapability = str2double(CUDA.ComputeCapability);
if ComputeCapability == 6.1 || ComputeCapability == 6.2
    CoresPerMultiProcessor = 128;
end
MultiprocessorCount = CUDA.MultiprocessorCount;
TotalCoresInPlay = CoresPerMultiProcessor*MultiprocessorCount*2;
GpuThreadsAtATime = MultiprocessorCount*2048;

%------------------------------------
% CUDA timeout related (chunk size)
% - multiple 7168 for 2x 1080ti (3584 cores x 2)
%------------------------------------
if CONV.chW >= 20
    chunklen = 7168;                            
else
    chunklen = GpuThreadsAtATime*10;             % emperically fastest (chW = 1)  
end

%------------------------------------
% Input
%------------------------------------
SampDat0 = double(SampDat);
if isreal(SampDat0)
    SampDat0 = complex(SampDat0,zeros(size(SampDat0)));        % make sure complex
end
Kx0 = double(Kx);
Ky0 = double(Ky);
Kz0 = double(Kz);
Kern = double(KERN.Kern);
iKern = int32(KERN.iKern);
chW = int32(CONV.chW);
Ksz = int32(Ksz);
chunklen = int32(chunklen);

%------------------------------------
% Zerofill to chunklen multiple
%------------------------------------
Len0 = length(SampDat0);
Len = chunklen*ceil(Len0/double(chunklen));
SampDat = zeros(Len,1);
Kx = Kx0(1)*ones(Len,1);
Ky = Ky0(1)*ones(Len,1);
Kz = Kz0(1)*ones(Len,1);
SampDat(1:Len0) = SampDat0;
Kx(1:Len0) = Kx0;
Ky(1:Len0) = Ky0;
Kz(1:Len0) = Kz0;

%------------------------------------
% Convolve
%------------------------------------
%tic
[CDat,Test,Error] = S2GCUDADoubleCM_v5b(SampDat,Kx,Ky,Kz,Kern,iKern,chW,Ksz,chunklen,Stathands);
%toc
%Test
%DataSumTest = sum(CDat(:))
if not(strcmp(Error,'no error'))
    CUDAerror = Error
    error();
end
%error

Status2('done','',StatLev);
