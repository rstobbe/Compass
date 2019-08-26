%==================================================
% (v5c)
%   
%==================================================

function [SampDat,err] = mG2SCUDADoubleC_v5c(Kx,Ky,Kz,KERN,CDat,CONV,StatLev,CUDA)

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
% CUDA optimization (emperical testing)
%------------------------------------
if CONV.chW == 1
    chunklen = TotalCoresInPlay*100;                 
else
    error;  % finish                    
end

%------------------------------------
% Input
%------------------------------------
CDat = double(CDat);
if isreal(CDat)
    CDat = complex(CDat,zeros(size(CDat)));
end
Kx0 = double(Kx);
Ky0 = double(Ky);
Kz0 = double(Kz);
Kern = double(KERN.Kern);
iKern = int32(KERN.iKern);
chW = int32(CONV.chW);
chunklen = int32(chunklen);

%------------------------------------
% Zerofill to chunklen multiple
%------------------------------------
Len0 = length(Kx0);
Len = chunklen*ceil(Len0/double(chunklen));
Kx = Kx0(1)*ones(Len,1,'double');
Ky = Ky0(1)*ones(Len,1,'double');
Kz = Kz0(1)*ones(Len,1,'double');
Kx(1:Len0) = Kx0;
Ky(1:Len0) = Ky0;
Kz(1:Len0) = Kz0;

%------------------------------------
% Convolve
%------------------------------------
%[Dat,Test,Error] = G2SCUDADoubleC_v4g(CDat,Kx0,Ky0,Kz0,Kern,iKern,chW,chunklen,000,Stathands);
%
tic
[SampDat,Test,Error] = G2SCUDADoubleC_v5c(CDat,Kx,Ky,Kz,Kern,iKern,chW,chunklen,Stathands);
SampDat = SampDat(1:Len0);
toc
%
%test = SampDat - Dat;
%TestSum = sum(test)
%------------------------------------
% Check Error - Return
%------------------------------------
if not(strcmp(Error,'no error'))
    CUDAtest = Test
    CUDAerror = Error
    error();
end

Status2('done','',StatLev);
