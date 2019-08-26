%===========================================
% 
%===========================================

function [IMG,err] = Combine2ImagesB0_v1a_Func(IMG,INPUT)

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

IMG = IMG1;
ExpPars = IMG1.ExpPars;
ExpPars.te1 = IMG1.ExpPars.te;
ExpPars.te2 = IMG2.ExpPars.te;
IMG.ExpPars = ExpPars;

ReconPars = IMG1.ReconPars;
ReconPars.te1 = IMG1.ExpPars.te;
ReconPars.te2 = IMG2.ExpPars.te;
IMG.ReconPars = ReconPars;

IMG.Im = Im;

Status2('done','',1);
Status2('done','',2);
Status2('done','',3);

