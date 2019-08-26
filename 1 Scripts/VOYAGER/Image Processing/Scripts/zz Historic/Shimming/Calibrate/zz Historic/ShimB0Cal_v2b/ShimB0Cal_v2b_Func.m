%===========================================
% 
%===========================================

function [CAL,err] = ShimB0Cal_v2b_Func(CAL,INPUT)

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
% Regress Difference Image
%---------------------------------------------
TEdif = ReconParsB.te2 - ReconParsB.te1;
func = str2func([CAL.shimfunc,'_Func']);  
INPUT.ImB1 = ImB(:,:,:,1,:);
INPUT.ImB2 = ImB(:,:,:,2,:);
INPUT.ImV1 = ImV(:,:,:,1,:);
INPUT.ImV2 = ImV(:,:,:,2,:);
INPUT.ReconPars = ReconParsB;
INPUT.TEdif = TEdif;
[B0SHIM,err] = func(B0SHIM,INPUT);
if err.flag
    return
end
clear INPUT;
V = B0SHIM.V;

%---------------------------------------------
% Return
%---------------------------------------------
CAL.CalData.Shim = 'z3c';
CAL.CalData.CalVal = 2000;
CAL.CalData.SphWgts = V;

Status2('done','',2);
Status2('done','',3);

