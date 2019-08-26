%==================================================
% (v4f)
%   - Update for R2014b
%==================================================

function [CDat,err] = mS2GCUDADoubleC2D_v4f(Ksz,Kx,Ky,KERN,SampDat,CONV,StatLev,CUDAdevice)

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

% if CONV.chW >= 14
%     chunklen = 16000;
% elseif CONV.chW >= 10
%     chunklen = 32000;
% else 
%     chunklen = 128000;
% end
chunklen = 10000;
if length(SampDat) < chunklen
    error;      % still need test CUDA code for this
end

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
chunklen = int32(chunklen);
device = int32(CUDAdevice);
%-----------------------

[CDat,Test,Error] = S2GCUDADoubleC2D_v4f(SampDat,Kx,Ky,Kern,iKern,chW,Ksz,chunklen,device,Stathands);

if not(strcmp(Error,'no error'))
    CUDAerror = Error
    error();
end

Status2('done','',StatLev);
