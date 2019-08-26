%===========================================
% 
%===========================================

function [IMG,err] = ShimB0Load_v2a_Func(IMG,INPUT)

Status2('busy','Filter Image',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Test
%---------------------------------------------
Im = INPUT.Im;
ReconPars = INPUT.ReconPars;
B0SHIM = INPUT.B0SHIM;
clear INPUT;

%---------------------------------------------
% Separate
%---------------------------------------------
Im1 = Im(:,:,:,1,:);
Im2 = Im(:,:,:,2,:);
TEdif = ReconPars.te2 - ReconPars.te1;

%---------------------------------------------
% Shim
%---------------------------------------------
func = str2func([IMG.shimfunc,'_Func']);  
INPUT.Im1 = Im1;
INPUT.Im2 = Im2;
INPUT.ReconPars = ReconPars;
INPUT.TEdif = TEdif;
[B0SHIM,err] = func(B0SHIM,INPUT);
if err.flag
    return
end
clear INPUT;

%---------------------------------------------
% Return
%---------------------------------------------


Status2('done','',2);
Status2('done','',3);

