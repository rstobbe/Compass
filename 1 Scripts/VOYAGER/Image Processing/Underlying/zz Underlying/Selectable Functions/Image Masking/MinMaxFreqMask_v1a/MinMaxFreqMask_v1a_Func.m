%===========================================
% 
%===========================================

function [MASK,err] = MinMaxFreqMask_v1a_Func(MASK,INPUT)

Status2('busy','Mask',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%--------------------------------------------- 
fMap = INPUT.fMap;
clear INPUT;

%---------------------------------------------
% Frequency Mask
%---------------------------------------------
Mask = ones(size(fMap));
Mask(fMap > -MASK.minfreq) = NaN; 
Mask(fMap < -MASK.maxfreq) = NaN; 

%---------------------------------------------
% Return
%---------------------------------------------
MASK.Mask = Mask;

Status2('done','',2);
Status2('done','',3);

