%===========================================
% 
%===========================================

function [B0MAP,err] = B0MapMultiRcvr_v1a_Func(B0MAP,INPUT)

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
% Create Offset Map
%---------------------------------------------
[~,~,~,nrcvrs] = size(Im10); 
fMapArr = zeros(size(Im10));
for n = 1:nrcvrs
    Im1 = Im10(:,:,:,n);
    Im2 = Im20(:,:,:,n);
    AbsIm = abs(Im2);
    Mask = ones(size(AbsIm));
    Mask(AbsIm < B0MAP.absthresh*max(AbsIm(:))) = NaN;
    phIm1 = angle(Im1);
    phIm2 = angle(Im2);
    dphIm = phIm2 - phIm1;
    dphIm(dphIm > pi) = dphIm(dphIm > pi) - 2*pi;
    dphIm(dphIm < -pi) = dphIm(dphIm < -pi) + 2*pi;
    fMap = 1000*(dphIm/(2*pi))/TEdif;    
    fMapArr(:,:,:,n) = fMap.*Mask; 
end
fMap = nanmean(fMapArr,4);

%---------------------------------------------
% Add to Panel Output
%---------------------------------------------
Panel(1,:) = {'','','Output'};
Panel(2,:) = {'',B0MAP.method,'Output'};
B0MAP.PanelOutput = cell2struct(Panel,{'label','value','type'},2);

%---------------------------------------------
% Return
%--------------------------------------------- 
B0MAP.fMap = fMap;

Status2('done','',2);
Status2('done','',3);
