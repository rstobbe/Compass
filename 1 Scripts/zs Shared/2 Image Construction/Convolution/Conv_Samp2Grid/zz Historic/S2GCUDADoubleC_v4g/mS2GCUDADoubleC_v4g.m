%==================================================
% (v4g)
%   - Update for COMPASS 
%==================================================

function [CDat,err] = mS2GCUDADoubleC_v4g(Ksz,Kx,Ky,Kz,KERN,SampDat,CONV,StatLev,CUDAdevice)

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

if CONV.chW >= 14
    chunklen = 16000;
elseif CONV.chW >= 10
    chunklen = 32000;
else 
    %chunklen = 128000;
    chunklen = 64000;
end

%----------------------
SampDat = double(SampDat);
if isreal(SampDat)
    SampDat = complex(SampDat,zeros(size(SampDat)));        % make sure complex
end
Kx = double(Kx);
Ky = double(Ky);
Kz = double(Kz);
Kern = double(KERN.Kern);
iKern = int32(KERN.iKern);
chW = int32(CONV.chW);
Ksz = int32(Ksz);
chunklen = int32(chunklen);
device = 0000;                          % not used
%-----------------------

[CDat,Test,Error] = S2GCUDADoubleC_v4g(SampDat,Kx,Ky,Kz,Kern,iKern,chW,Ksz,chunklen,device,Stathands);

if not(strcmp(Error,'no error'))
    CUDAerror = Error
    error();
end

Status2('done','',StatLev);
