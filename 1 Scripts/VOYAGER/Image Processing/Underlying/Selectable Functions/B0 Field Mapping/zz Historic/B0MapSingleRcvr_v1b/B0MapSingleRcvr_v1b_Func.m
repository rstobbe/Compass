%===========================================
% 
%===========================================

function [B0MAP,err] = B0MapSingleRcvr_v1b_Func(B0MAP,INPUT)

Status2('busy','B0 Mapping',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%--------------------------------------------- 
Im1 = INPUT.Im1;
Im2 = INPUT.Im2;
TEdif = INPUT.TEdif;
clear INPUT;

%---------------------------------------------
% Receiver check
%--------------------------------------------- 
[~,~,~,nrcvrs] = size(Im1); 
if nrcvrs > 1
    err.flag = 1;
    err.msg = 'Use Multi-Receiver B0 Mapping Function';
    return
end

%---------------------------------------------
% Abs Mask 
%--------------------------------------------- 
AbsIm = abs((Im1+Im2)/2);
Mask = ones(size(AbsIm));
Mask(AbsIm < B0MAP.absthresh*max(AbsIm(:))) = NaN;

%---------------------------------------------
% Create Offset Map
%---------------------------------------------
phIm1 = angle(Im1);
phIm2 = angle(Im2);
dphIm = phIm2 - phIm1;
dphIm(dphIm > pi) = dphIm(dphIm > pi) - 2*pi;           % wrap around...
dphIm(dphIm < -pi) = dphIm(dphIm < -pi) + 2*pi;
fMap = 1000*(dphIm/(2*pi))/TEdif;

%---------------------------------------------
% Return
%--------------------------------------------- 
B0MAP.fMap = fMap.*Mask;

Status2('done','',2);
Status2('done','',3);

