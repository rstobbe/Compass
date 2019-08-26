%==================================================
% (v5b)
%   - Parallel GPUs (single CPU thread)
%==================================================

function [CDat,err] = mS2GCUDADoubleR_v5b(Ksz,Kx,Ky,Kz,KERN,SampDat,CONV,StatLev)

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
% - multiple 7168 for 2x 1080ti (3584 cores x 2)
%------------------------------------
if CONV.chW >= 20
    chunklen = 7168;                            % emperically fastest
else
    chunklen = 28672;                           % emperically fastest (chW = 14)  
end

%------------------------------------
% Input
%------------------------------------
SampDat0 = double(real(SampDat));
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
SampDat = zeros(1,Len);
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
[CDat,Test,Error] = S2GCUDADoubleR_v5b(SampDat,Kx,Ky,Kz,Kern,iKern,chW,Ksz,chunklen,Stathands);
%toc
%Test
%DataSumTest = sum(CDat(:))/1e6
if not(strcmp(Error,'no error'))
    CUDAerror = Error
    error();
end
%error

Status2('done','',StatLev);
