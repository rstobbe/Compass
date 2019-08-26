%==================================================
% (v1h)
%   - CUDA 7.5 Recompile
%==================================================

function [Dat,err] =  mSampOffResCUDADoubles_v1h(Im,Off,T,Kx,Ky,Kz,KERN,CONV,StatLev)

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
% Test - Image size even...
%------------------------------------
sz = size(Im);
if rem(sz(1),2)
    error();
end

%------------------------------------
% Input
%------------------------------------
Im = double(Im);
if isreal(Im)
    Im = complex(Im,zeros(size(Im)));
end
Off = double(Off);
T = double(T);
Kx = double(Kx);
Ky = double(Ky);
Kz = double(Kz);
Kern = double(KERN.Kern);
iKern = int32(KERN.iKern);
chW = int32(CONV.chW);

%------------------------------------
% Sample
%------------------------------------
[Dat,Test,Error] = SampOffResCUDADoubles_v1h(Im,Off,T,Kx,Ky,Kz,Kern,iKern,chW,Stathands);

%------------------------------------
% Check Error - Return
%------------------------------------
if not(strcmp(Error,'no error'))
    CUDAerror = Error
    error();
end

Status2('done','',StatLev);
