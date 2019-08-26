%===========================================
% 
%===========================================

function [COMB,err] = Combine2Images_v1a_Func(COMB,INPUT)

Status('busy','Combine Images');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Test
%---------------------------------------------
IMG1 = INPUT.IMG1;
IMG2 = INPUT.IMG2;
clear INPUT;

%---------------------------------------------
% Return
%---------------------------------------------
sz = size(IMG1.Im);
Im = cat(length(sz)+1,IMG1.Im,IMG2.Im);

COMB = IMG1;
COMB.Im = Im;

Status2('done','',1);
Status2('done','',2);
Status2('done','',3);

