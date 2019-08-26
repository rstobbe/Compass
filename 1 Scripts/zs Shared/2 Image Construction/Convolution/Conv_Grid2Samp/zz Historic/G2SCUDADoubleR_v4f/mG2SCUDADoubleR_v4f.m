%==================================================
% (v4f)
%   - 
%==================================================

function [Dat,err] = mG2SCUDADoubleR_v4f(Ksz,Kx,Ky,Kz,KERN,CDat,CONV,StatLev,CUDAdevice)

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

if CONV.chW >= 50
    error();                % CUDA will timeout...
elseif CONV.chW >= 40
    chunklen = 2000;
elseif CONV.chW >= 30
    chunklen = 4000;
elseif CONV.chW >= 20
    chunklen = 8000;
    %chunklen = 16000;
elseif CONV.chW >= 10
    chunklen = 16000;
    %chunklen = 32000;
else 
    chunklen = 256000;
end

%----------------------
CDat = double(real(CDat));
Kx = double(Kx);
Ky = double(Ky);
Kz = double(Kz);
Kern = double(KERN.Kern);
iKern = int32(KERN.iKern);
chW = int32(CONV.chW);
chunklen = int32(chunklen);
device = int32(CUDAdevice);
%-----------------------

[Dat,Test,Error] = G2SCUDADoubleR_v4f(CDat,Kx,Ky,Kz,Kern,iKern,chW,chunklen,device,Stathands);

if not(strcmp(Error,'no error'))
    CUDAerror = Error
    error();
end

Status2('done','',StatLev);
