%=========================================================
% 
%=========================================================

function [SUBT,err] = ImageAbsSubtraction_v1a_Func(SUBT,INPUT)

Status2('busy','Subtract Images',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
IMG = INPUT.IMG{1};
IMG1 = INPUT.IMG{1};
IMG2 = INPUT.IMG{2};
clear INPUT;

%---------------------------------------------
% Return
%---------------------------------------------
IMG.Im = abs(IMG1.Im) - abs(IMG2.Im);
SUBT.IMG = IMG;

Status2('done','',2);
Status2('done','',3);
