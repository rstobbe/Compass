%===========================================
% 
%===========================================

function [B0MAP,err] = B0MapStandard_v1a_Func(B0MAP,INPUT)

Status2('busy','B0 Mapping',2);
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
if isempty(B0MAP.tediff)
    if length(ExpPars) > 1
        B0MAP.tediff = abs(ExpPars{2}.Sequence.te - ExpPars{1}.Sequence.te);
        %error;          % finish (get TeDiff)
    else
        %sequence = ExpPars.Sequence;        
        error;              % finish (get TeDiff)
    end
else
    B0MAP.tediff = str2double(B0MAP.tediff);
end
    
%---------------------------------------------
% Mask
%---------------------------------------------
mask = BaseIm;
mask(mask < B0MAP.maskval*max(BaseIm(:))) = NaN;
mask(mask >= B0MAP.maskval*max(BaseIm(:))) = 1;

%---------------------------------------------
% Frequency Map
%---------------------------------------------
phIm1 = angle(Im(:,:,:,:,:,1));
phIm2 = angle(Im(:,:,:,:,:,2));
dphIm = phIm2 - phIm1;
dphIm(dphIm > pi) = dphIm(dphIm > pi) - 2*pi;
dphIm(dphIm < -pi) = dphIm(dphIm < -pi) + 2*pi;
fMap = 1000*(dphIm/(2*pi))/B0MAP.tediff;    
fMap = -fMap.*mask; 

%---------------------------------------------
% Polarity
%---------------------------------------------
% if strcmp(B0MAP.shimcalpol,'AbsFreq')
%     fMap = fMap;
% elseif strcmp(B0MAP.shimcalpol,'B0')
%     fMap = -fMap;
% end

%---------------------------------------------
% Add to Panel Output
%---------------------------------------------
Panel(1,:) = {'','','Output'};
Panel(2,:) = {'',B0MAP.method,'Output'};
Panel(3,:) = {'TE Difference (ms)',B0MAP.tediff,'Output'};
B0MAP.PanelOutput = cell2struct(Panel,{'label','value','type'},2);

%---------------------------------------------
% Return
%---------------------------------------------
B0MAP.Map = fMap;
B0MAP.Heading = 'B0MAP';

Status2('done','',2);
Status2('done','',3);