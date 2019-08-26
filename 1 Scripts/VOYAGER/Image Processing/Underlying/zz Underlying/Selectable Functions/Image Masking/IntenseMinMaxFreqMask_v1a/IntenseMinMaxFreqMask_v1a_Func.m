%===========================================
% 
%===========================================

function [MASK,err] = IntenseMinMaxFreqMask_v1a_Func(MASK,INPUT)

Status2('busy','Mask',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%--------------------------------------------- 
Im = INPUT.Im;
fMap = INPUT.fMap;
clear INPUT;

%---------------------------------------------
% Intensity Mask
%---------------------------------------------
Mask = abs(Im)/max(abs(Im(:)));
Mask(Mask < MASK.absthresh) = NaN;
Mask(Mask >= MASK.absthresh) = 1;

%---------------------------------------------
% Frequency Mask
%---------------------------------------------
Mask(fMap > -MASK.minfreq) = NaN; 
Mask(fMap < -MASK.maxfreq) = NaN; 

%---------------------------------------------
% Return
%---------------------------------------------
MASK.Mask = Mask;

Status2('done','',2);
Status2('done','',3);

