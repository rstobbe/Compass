%==================================================
% (v4f)
%   - Update for R2014b
%==================================================

function [CDat,err] = mS2GCUDADoubleR2D_v4f(Ksz,Kx,Ky,KERN,SampDat,CONV,StatLev,CUDAdevice)

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

% if CONV.chW >= 50
%     error();                % CUDA will timeout...
% elseif CONV.chW >= 40
%     chunklen = 2000;
% elseif CONV.chW >= 30
%     chunklen = 4000;
% elseif CONV.chW >= 20
%     chunklen = 8000;
%     %chunklen = 16000;
% elseif CONV.chW >= 10
%     chunklen = 16000;
%     %chunklen = 32000;
% else 
%     chunklen = 256000;
% end
chunklen = 10000;
if length(SampDat) < chunklen
    error;      % still need test CUDA code for this
end

%----------------------
SampDat = double(real(SampDat));
Kx = double(Kx);
Ky = double(Ky);
Kern = double(KERN.Kern);
iKern = int32(KERN.iKern);
chW = int32(CONV.chW);
Ksz = int32(Ksz);
chunklen = int32(chunklen);
device = int32(CUDAdevice);
%-----------------------

[CDat,Test,Error] = S2GCUDADoubleR2D_v4f(SampDat,Kx,Ky,Kern,iKern,chW,Ksz,chunklen,device,Stathands);

if not(strcmp(Error,'no error'))
    CUDAerror = Error
    error();
end

Status2('done','',StatLev);
