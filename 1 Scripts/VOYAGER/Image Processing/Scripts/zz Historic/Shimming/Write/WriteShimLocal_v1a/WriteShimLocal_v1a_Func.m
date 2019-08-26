%===========================================
% 
%===========================================

function [WRT,err] = WriteShimLocal_v1a_Func(WRT,INPUT)

Status2('busy','Write Shims',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Test
%---------------------------------------------
SHIM = INPUT.SHIM;
WRTF = INPUT.WRTF;
clear INPUT;

%---------------------------------------------
% Write
%---------------------------------------------
func = str2func([WRT.writefunc,'_Func']);  
INPUT.CalData = SHIM.CalData;
INPUT.Wgts = SHIM.V;
INPUT.NewShims = SHIM.NewShims;
%INPUT.ShimName = SHIM.ShimName;
[WRTF,err] = func(WRTF,INPUT);
if err.flag
    return
end
clear INPUT;

%--------------------------------------------
% Panel
%--------------------------------------------
for n = 1:length(SHIM.V)
    Panel(n,:) = {['Written_',SHIM.CalData(n).Shim],SHIM.V(n),'Output'};
end
PanelOutput = cell2struct(Panel,{'label','value','type'},2);
WRT.PanelOutput = PanelOutput;

%---------------------------------------------
% Return
%---------------------------------------------
WRT.CalData = SHIM.CalData;
WRT.V = SHIM.V;

Status2('done','',2);
Status2('done','',3);

