%====================================================
%  
%====================================================

function [PREPRC,err] = PreProc_mpflash3d_v1a_Func(PREPRC,INPUT)

Status2('busy','Pre Process',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
FIDmat = INPUT.FIDmat;
IMDC = PREPRC.IMDC;
clear INPUT;

%----------------------------------------------
% DCcor Image
%----------------------------------------------
func = str2func([PREPRC.imdccorfunc,'_Func']);  
INPUT.FIDmat = FIDmat;
[IMDC,err] = func(IMDC,INPUT);
if err.flag
    return
end
FIDmat = IMDC.FIDmat;
clear INPUT;

%----------------------------------------------
% Flip
%----------------------------------------------
%FIDmat = flipdim(FIDmat,1);
%FIDmat = flipdim(FIDmat,2);
FIDmat = flipdim(FIDmat,3);

%----------------------------------------------
% Return
%----------------------------------------------
PREPRC.FIDmat = FIDmat;

Status2('done','',2);
Status2('done','',3);



