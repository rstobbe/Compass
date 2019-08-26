%=========================================================
% 
%=========================================================

function [SUBT,err] = ImageSubtraction_v1a_Func(SUBT,INPUT)

Status2('busy','Subtract Images',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
IMG = INPUT.IMG{1};
clear INPUT;

%---------------------------------------------
% Return
%---------------------------------------------
IMG.Im = flip(IMG.Im,3);
SUBT.IMG = IMG;

Status2('done','',2);
Status2('done','',3);
