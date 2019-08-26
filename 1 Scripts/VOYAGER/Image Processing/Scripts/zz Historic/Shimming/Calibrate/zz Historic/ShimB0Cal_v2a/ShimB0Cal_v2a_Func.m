%===========================================
% 
%===========================================

function [CAL,err] = ShimB0Cal_v2a_Func(CAL,INPUT)

Status2('busy','Filter Image',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Test
%---------------------------------------------
ImB = INPUT.ImB;
ImV = INPUT.ImV;
ReconParsB = INPUT.ReconParsB;
ReconParsV = INPUT.ReconParsV;
B0SHIM = INPUT.B0SHIM;
clear INPUT;

%---------------------------------------------
% Regress Base
%---------------------------------------------
Im1 = ImB(:,:,:,1,:);
Im2 = ImB(:,:,:,2,:);
TEdif = ReconParsB.te2 - ReconParsB.te1;
func = str2func([CAL.shimfunc,'_Func']);  
INPUT.Im1 = Im1;
INPUT.Im2 = Im2;
INPUT.ReconPars = ReconParsB;
INPUT.TEdif = TEdif;
[B0SHIM,err] = func(B0SHIM,INPUT);
if err.flag
    return
end
clear INPUT;
VB = B0SHIM.V;

%---------------------------------------------
% Regress Variation
%---------------------------------------------
Im1 = ImV(:,:,:,1,:);
Im2 = ImV(:,:,:,2,:);
TEdif = ReconParsV.te2 - ReconParsV.te1;
func = str2func([CAL.shimfunc,'_Func']);  
INPUT.Im1 = Im1;
INPUT.Im2 = Im2;
INPUT.ReconPars = ReconParsV;
INPUT.TEdif = TEdif;
[B0SHIM,err] = func(B0SHIM,INPUT);
if err.flag
    return
end
clear INPUT;
VV = B0SHIM.V;

%---------------------------------------------
% Compare
%---------------------------------------------
Vdif = VV - VB
CAL.V = Vdif


Status2('done','',2);
Status2('done','',3);

