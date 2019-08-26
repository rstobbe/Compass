%==================================================
% (v4g)
%   - Update for COMPASS 
%==================================================

function [Dat,err] = mG2SCUDADoubleR_v4g(Ksz,Kx,Ky,Kz,KERN,CDat,CONV,StatLev,CUDAdevice)

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
    error();                % CUDA will timeout...
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
CDat = double(real(CDat));
Kx = double(Kx);
Ky = double(Ky);
Kz = double(Kz);
Kern = double(KERN.Kern);
iKern = int32(KERN.iKern);
chW = int32(CONV.chW);
chunklen = int32(chunklen);
device = 0000;                              % not used

%------------------------------------
% Convolve
%------------------------------------
[Dat,Test,Error] = G2SCUDADoubleR_v4g(CDat,Kx,Ky,Kz,Kern,iKern,chW,chunklen,device,Stathands);

%------------------------------------
% Check Error - Return
%------------------------------------
if not(strcmp(Error,'no error'))
    CUDAtest = Test
    CUDAerror = Error
    error();
end

Status2('done','',StatLev);
