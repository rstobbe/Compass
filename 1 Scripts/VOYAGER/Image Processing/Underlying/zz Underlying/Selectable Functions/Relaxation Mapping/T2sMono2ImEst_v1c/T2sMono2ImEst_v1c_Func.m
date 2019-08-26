%====================================================
%  
%====================================================

function [MAP,err] = T2sMono2ImEst_v1c_Func(MAP,INPUT)

Status2('busy','Generate T2-map MonoExponential 2 Image Estimate',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
Im = INPUT.Im;
BaseIm = INPUT.BaseIm;
ExpPars = INPUT.ExpPars;
clear INPUT;

%---------------------------------------------
% Test
%---------------------------------------------
sz = size(Im);
if sz(6) ~= 2
    err.flag = 1;
    err.msg = 'This is a 2 image function';
    return
end

%---------------------------------------------
% TeDiff
%---------------------------------------------
if isempty(MAP.tediff)
    if length(ExpPars) > 1
        error;          % finish (get TeDiff)
    else
        sequence = ExpPars.Sequence;        
        error;              % finish (get TeDiff)
    end
else
    MAP.tediff = str2double(MAP.tediff);
end
    
%---------------------------------------------
% Mask
%---------------------------------------------
mask = BaseIm;
mask(mask < MAP.maskval*max(BaseIm(:))) = NaN;
mask(mask >= MAP.maskval*max(BaseIm(:))) = 1;

%---------------------------------------------
% Mono Estimation
%---------------------------------------------
T2Arr = (0.1:0.001:70);
ValArr = exp(-MAP.tediff./T2Arr);
ImRel = abs(Im(:,:,:,:,:,2))./abs(Im(:,:,:,:,:,1));
ImRel = ImRel.*mask;

%---------------------------------------------
% T2 Fit
%---------------------------------------------
T2 = interp1(ValArr,T2Arr,ImRel);

%---------------------------------------------
% Add to Panel Output
%---------------------------------------------
Panel(1,:) = {'','','Output'};
Panel(2,:) = {'',MAP.method,'Output'};
Panel(3,:) = {'TE Difference (ms)',MAP.tediff,'Output'};
MAP.PanelOutput = cell2struct(Panel,{'label','value','type'},2);

%---------------------------------------------
% Return
%---------------------------------------------
MAP.Map = T2;
MAP.Heading = 'T2STAR';

Status2('done','',2);
Status2('done','',3);

