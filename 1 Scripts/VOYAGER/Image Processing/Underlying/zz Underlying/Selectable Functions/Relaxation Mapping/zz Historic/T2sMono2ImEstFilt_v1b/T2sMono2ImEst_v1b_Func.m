%====================================================
%  
%====================================================

function [MAP,err] = T2sMono2ImEst_v1a_Func(MAP,INPUT)

Status2('busy','Generate T2-map MonoExponential 2 Image Estimate',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
Im = INPUT.Im;
ReconPars = INPUT.ReconPars;
Te = INPUT.Te;
LPASS = MAP.LPASS;
clear INPUT;

%---------------------------------------------
% Test
%---------------------------------------------
sz = size(Im);
if sz(4) ~= 2
    err.flag = 1;
    err.msg = 'This is a 2 image function';
    return
end

%---------------------------------------------
% Low Pass Filter
%---------------------------------------------
IMG.ReconPars = ReconPars;
func = str2func([MAP.lpassfunc,'_Func']);  
for n = 1:2
    IMG.Im = squeeze(Im(:,:,:,n));
    INPUT.IMG = IMG;
    [LPASS,err] = func(LPASS,INPUT);
    if err.flag
        return
    end
    clear INPUT;
    Im(:,:,:,n) = LPASS.Im;
end

%---------------------------------------------
% Image Absolute Value
%---------------------------------------------
BaseIm = abs(mean(Im,4));

%---------------------------------------------
% Mask
%---------------------------------------------
mask = BaseIm;
mask(mask < MAP.maskval*max(BaseIm(:))) = NaN;
mask(mask >= MAP.maskval*max(BaseIm(:))) = 1;

%---------------------------------------------
% Mono Estimation
%---------------------------------------------
TeDif = Te(2)-Te(1);
T2Arr = (0.1:0.001:70);
ValArr = exp(-TeDif./T2Arr);
ImRel = abs(Im(:,:,:,2))./abs(Im(:,:,:,1));
%ImRel(ImRel > 1) = NaN;
ImRel = ImRel.*mask;

%---------------------------------------------
% T2 Fit
%---------------------------------------------
T2 = interp1(ValArr,T2Arr,ImRel);
%T2(T2 > 10) = NaN;

%---------------------------------------------
% Add to Panel Output
%---------------------------------------------
Panel(1,:) = {'','','Output'};
Panel(2,:) = {'',MAP.method,'Output'};
MAP.PanelOutput = cell2struct(Panel,{'label','value','type'},2);

%---------------------------------------------
% Return
%---------------------------------------------
MAP.T2Map = T2;

Status2('done','',2);
Status2('done','',3);

