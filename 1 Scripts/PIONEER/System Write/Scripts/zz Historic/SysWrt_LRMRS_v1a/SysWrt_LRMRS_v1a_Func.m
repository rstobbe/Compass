%=========================================================
% 
%=========================================================

function [OUTPUT,err] = LR_MRS3T_v1a_Func(INPUT)

Status('busy','Write LR Projection Set to MRS 3T');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';
OUTPUT = struct();

%---------------------------------------------
% Get Input
%---------------------------------------------
WRT = INPUT.WRT;
WRTGRD = INPUT.WRTGRD;
WRTPRM = INPUT.WRTPRM;
IMP = INPUT.IMP;
clear INPUT;
  
%---------------------------------------------
% Write Gradients
%---------------------------------------------
func = str2func([WRT.wrtgradfunc,'_Func']);
INPUT.IMP = IMP;
[WRTGRD,err] = func(WRTGRD,INPUT);
if err.flag
    return
end
clear INPUT
[GradLabel] = TruncFileNameForDisp_v1(WRTGRD.GradLoc);
WRT.GradLoc = WRTGRD.GradLoc;
WRT.sysgmax = WRTGRD.sysgmax;

%---------------------------------------------
% Write Params
%---------------------------------------------
func = str2func([WRT.wrtparamfunc,'_Func']);
INPUT.IMP = IMP;
INPUT.WRT = WRT;
[WRTPRM,err] = func(WRTPRM,INPUT);
if err.flag == 1
    return
end
clear INPUT
[ParamLabel] = TruncFileNameForDisp_v1(WRTPRM.ParamLoc);
WRT.ParamLoc = WRTPRM.ParamLoc;

%----------------------------------------------------
% Panel Output
%----------------------------------------------------
Panel(1,:) = {'GradLoc',GradLabel,'Output'};
Panel(2,:) = {'ParamLoc',ParamLabel,'Output'};
PanelOutput = cell2struct(Panel,{'label','value','type'},2);
WRT.PanelOutput = PanelOutput;

%--------------------------------------------
% Return
%--------------------------------------------
OUTPUT.WRT = WRT;


