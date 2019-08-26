%===========================================
% 
%===========================================

function [B0SHIM,err] = FitB0ShimCoils_v1b_Func(B0SHIM,INPUT)

Status2('busy','B0 Shim',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%--------------------------------------------- 
FIT = B0SHIM.FIT;
fMap = INPUT.fMap;
Mask = INPUT.Mask;
CalData = INPUT.CalData;
clear INPUT;

%---------------------------------------------
% Fit Spherical Harmonics
%---------------------------------------------
func = str2func([B0SHIM.fitfunc,'_Func']);
INPUT.Im = fMap;
INPUT.CalData = B0SHIM.CalData;
[FIT,err] = func(FIT,INPUT);
if err.flag
    return
end
clear INPUT    

%---------------------------------------------
% Prof
%--------------------------------------------- 
V = FIT.V;
Prof = FIT.Prof;
Prof = Prof.*mask;

%---------------------------------------------
% Test Possible Correction
%---------------------------------------------
fMapC = fMap - Prof;

%---------------------------------------------
% Return
%---------------------------------------------
B0SHIM.V = -V;
B0SHIM.fMapC = fMapC;
B0SHIM.fMap0 = fMap;

Status2('done','',2);
Status2('done','',3);

