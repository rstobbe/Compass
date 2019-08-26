%==================================================
% (v4f)
%   - Start mS2GCUDADoubleC2D_v4f
%==================================================

function [CDat,err] = mS2GCUDADoubleC2Dms_v4f(Ksz,Kx,Ky,KERN,SampDat,CONV,StatLev,CUDAdevice)

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

%----------------------
SampDat = double(SampDat);
if isreal(SampDat)
    SampDat = complex(SampDat,zeros(size(SampDat)));        % make sure complex
end
Kx = double(Kx);
Ky = double(Ky);
Kern = double(KERN.Kern);
iKern = int32(KERN.iKern);
chW = int32(CONV.chW);
Ksz = int32(Ksz);
device = int32(CUDAdevice);
%-----------------------

[CDat,Test,Error] = S2GCUDADoubleC2Dms_v4f(SampDat,Kx,Ky,Kern,iKern,chW,Ksz,device,Stathands);

if not(strcmp(Error,'no error'))
    CUDAerror = Error
    error();
end

Status2('done','',StatLev);
