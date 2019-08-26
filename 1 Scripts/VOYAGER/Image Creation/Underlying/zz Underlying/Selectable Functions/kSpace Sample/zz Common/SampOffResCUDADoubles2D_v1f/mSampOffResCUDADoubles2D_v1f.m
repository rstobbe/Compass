%==================================================
% 
%==================================================
function [Dat,err] =  mSampOffResCUDADoubles2D_v1e(Im,Off,T,Kx,Ky,KERN,CONV,StatLev)

err.flag = 0;
err.msg = '';

if StatLev == 0
    Stathands = 0;
elseif StatLev == 2
    Stathands = findobj('type','uicontrol','tag','ind2');
elseif StatLev == 3
    Stathands = findobj('type','uicontrol','tag','ind3');
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
Kern = double(KERN.Kern);
iKern = int32(KERN.iKern);
chW = int32(CONV.chW);

%------------------------------------
% FFT
%------------------------------------
[Dat,Test,Error] = SampOffResCUDADoubles2D_v1e(Im,Off,T,Kx,Ky,Kern,iKern,chW,Stathands);
%Error
%Test

%------------------------------------
% Check Error - Return
%------------------------------------
if not(strcmp(Error,'no error'))
    CUDAerror = Error
    error();
end

Status2('done','',StatLev);
