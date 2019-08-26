%===========================================
% 
%===========================================

function [IMG,err] = ShimImageIntenseLoad_v1a_Func(IMG,INPUT)

Status2('busy','Filter Image',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Test
%---------------------------------------------
Im = INPUT.Im;
ReconPars = INPUT.ReconPars;
ISHIM = INPUT.ISHIM;
clear INPUT;

%---------------------------------------------
% Filter
%---------------------------------------------
func = str2func([IMG.shimfunc,'_Func']);  
INPUT.Im = Im;
INPUT.ReconPars = ReconPars;
[ISHIM,err] = func(ISHIM,INPUT);
if err.flag
    return
end
clear INPUT;

%---------------------------------------------
% Return
%---------------------------------------------
IMG.Im = ISHIM.Im;


Status2('done','',2);
Status2('done','',3);

