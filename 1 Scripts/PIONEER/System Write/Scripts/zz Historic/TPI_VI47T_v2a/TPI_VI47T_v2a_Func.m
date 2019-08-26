%=========================================================
% 
%=========================================================

function [WRT,err] = TPI_VI47T_v2a_Func(INPUT,WRT)

Status('busy','Write TPI Projection Set to 4.7T System');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
WRTGRD = INPUT.WRTGRD;
WRTPRM = INPUT.WRTPRM;
WRTRFCS = INPUT.WRTRFCS;
IMP = INPUT.IMP;
clear INPUT;
  
%---------------------------------------------
% Write Gradients
%---------------------------------------------
func = str2func([WRT.wrtgradfunc,'_Func']);
INPUT.G = IMP.G;
INPUT.rdur = [IMP.GQNT.idivno IMP.GQNT.twdivno*(ones(1,IMP.GQNT.twwords+1))];
INPUT.sym = IMP.SYS.sym;
[WRTGRD,err] = func(WRTGRD,INPUT);
if err.flag
    return
end
clear INPUT
DropExt = 'Yes';
[GradLabel] = TruncFileNameForDisp_v1(WRTGRD.GradLoc,DropExt);
WRT.GradLoc = WRTGRD.GradLoc;
WRT.sysgmax = WRTGRD.sysgmax;

%---------------------------------------------
% Write Refocus
%---------------------------------------------
func = str2func([WRT.wrtrefocusfunc,'_Func']);
INPUT.IMP = IMP;
INPUT.WRT = WRT;
[WRTRFCS,err] = func(WRTRFCS,INPUT);
if err.flag == 1
    return
end
clear INPUT
[RefocusLabel] = TruncFileNameForDisp_v1(WRTRFCS.RefocusLoc,DropExt);
WRT.RefocusLoc = WRTRFCS.RefocusLoc;

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
[ParamLabel] = TruncFileNameForDisp_v1(WRTPRM.ParamLoc,DropExt);
WRT.ParamLoc = WRTPRM.ParamLoc;

%----------------------------------------------------
% Panel Output
%----------------------------------------------------
Panel(1,:) = {'GradLoc',GradLabel,'Output'};
Panel(2,:) = {'RefocusLoc',RefocusLabel,'Output'};
Panel(3,:) = {'ParamLoc',ParamLabel,'Output'};
PanelOutput = cell2struct(Panel,{'label','value','type'},2);
WRT.PanelOutput = PanelOutput;

%--------------------------------------------
% Return
%--------------------------------------------
WRT.WRTGRD = WRTGRD;
WRT.WRTRFCS = WRTRFCS;
WRT.WRTPRM = WRTPRM;

Status2('done','',1);
Status2('done','',2);
Status2('done','',3);


