%===========================================
% 
%===========================================

function [IMG,err] = ShimB0Load_v1a_Func(IMG,INPUT)

Status2('busy','Filter Image',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Test
%---------------------------------------------
Im1 = INPUT.Im1;
Im2 = INPUT.Im2;
ReconPars = INPUT.ReconPars;
B0SHIM = INPUT.B0SHIM;
clear INPUT;

%---------------------------------------------
% Shim
%---------------------------------------------
func = str2func([IMG.shimfunc,'_Func']);  
INPUT.Im1 = Im1;
INPUT.Im2 = Im2;
INPUT.ReconPars = ReconPars;
INPUT.TEdif = IMG.TEdif;
[B0SHIM,err] = func(B0SHIM,INPUT);
if err.flag
    return
end
clear INPUT;

%---------------------------------------------
% Return
%---------------------------------------------
IMG.Im = B0SHIM.Im;


Status2('done','',2);
Status2('done','',3);

