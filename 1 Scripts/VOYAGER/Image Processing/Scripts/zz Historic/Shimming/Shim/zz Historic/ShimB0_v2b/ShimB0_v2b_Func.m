%===========================================
% 
%===========================================

function [SHIM,err] = ShimB0_v2b_Func(SHIM,INPUT)

Status2('busy','B0 Shimming',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Test
%---------------------------------------------
Im = INPUT.Im;
ReconPars = INPUT.ReconPars;
Shims = INPUT.Shims;
B0SHIM = INPUT.B0SHIM;
WRT = INPUT.WRT;
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
func = str2func([SHIM.shimfunc,'_Func']);  
INPUT.Im1 = Im1;
INPUT.Im2 = Im2;
INPUT.ReconPars = ReconPars;
INPUT.TEdif = TEdif;
[B0SHIM,err] = func(B0SHIM,INPUT);
if err.flag
    return
end
clear INPUT;
CalData = B0SHIM.CalData;
V0 = round(B0SHIM.V);

%---------------------------------------------
% Add to Previous Shims
%---------------------------------------------
for n = 1:length(V0)
    V(n) = Shims.(CalData(n).Shim) + V0(n);
end
    
%---------------------------------------------
% Write
%---------------------------------------------
func = str2func([SHIM.writefunc,'_Func']);  
INPUT.CalData = CalData;
INPUT.Wgts = V;
[WRT,err] = func(WRT,INPUT);
if err.flag
    return
end
clear INPUT;

%--------------------------------------------
% Panel
%--------------------------------------------
for n = 1:length(V)
    Panel(n,:) = {['Update_',CalData(n).Shim],V0(n),'Output'};
end
n = n+1;
Panel(n,:) = {'','','Output'};
N = n;
for n = 1:length(V)
    Panel(n+N,:) = {['New_',CalData(n).Shim],V(n),'Output'};
end
PanelOutput = cell2struct(Panel,{'label','value','type'},2);
SHIM.PanelOutput = PanelOutput;

%---------------------------------------------
% Return
%---------------------------------------------
SHIM.CalData = CalData;
SHIM.V = V;

Status2('done','',2);
Status2('done','',3);

