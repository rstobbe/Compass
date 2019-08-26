%===========================================
% 
%===========================================

function [B0MAP,err] = B0MapSingleRcvr_v1a_Func(B0MAP,INPUT)

Status2('busy','B0 Mapping',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%--------------------------------------------- 
Im10 = INPUT.Im1;
Im20 = INPUT.Im2;
TEdif = INPUT.TEdif;
clear INPUT;

%---------------------------------------------
% receiver check
%--------------------------------------------- 
[~,~,~,nrcvrs] = size(Im10); 
if nrcvrs > 1
    err.flag = 1;
    err.msg = 'Use Multi-Receiver B0 Mapping Function';
    return
end

%---------------------------------------------
% Create Offset Map
%---------------------------------------------
phIm1 = angle(Im10);
phIm2 = angle(Im20);
dphIm = phIm2 - phIm1;
dphIm(dphIm > pi) = dphIm(dphIm > pi) - 2*pi;           % wrap around...
dphIm(dphIm < -pi) = dphIm(dphIm < -pi) + 2*pi;
fMap = 1000*(dphIm/(2*pi))/TEdif;

%---------------------------------------------
% Return
%--------------------------------------------- 
B0MAP.fMap = fMap;

Status2('done','',2);
Status2('done','',3);

