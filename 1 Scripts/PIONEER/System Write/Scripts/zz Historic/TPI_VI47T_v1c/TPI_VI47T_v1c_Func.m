%=========================================================
% 
%=========================================================

function [OUTPUT,err] = TPI_VI47T_v1c_Func(INPUT)

Status('busy','Write TPI Projection Set to 4.7T System');
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
WRTRFCS = INPUT.WRTRFCS;
IMP = INPUT.IMP;
clear INPUT;

%---------------------------------------------
% Build WRT struct
%---------------------------------------------
WRT.Kend = IMP.Kend;
WRT.gcoil = IMP.KSMP.gcoil;
WRT.graddel = IMP.KSMP.graddel;
WRT.gamma = IMP.PROJimp.gamma;
WRT.sym = IMP.SYS.sym;
WRT.dwell = IMP.PROJimp.dwell;
WRT.npro = IMP.PROJimp.npro;
WRT.tro = IMP.PROJimp.tro;
WRT.sampstart = IMP.PROJimp.sampstart;
WRT.tgwfm = IMP.GWFM.tgwfm;
WRT.split = IMP.SYS.split;
WRT.projmult = IMP.SYS.projmult;
WRT.filBW = IMP.TSMP.filtBW;
WRT.vox = IMP.PROJdgn.vox;
WRT.fov = IMP.PROJdgn.fov;
WRT.elip = IMP.PROJdgn.elip;
WRT.nproj = IMP.PROJimp.nproj;

%---------------------------------------------
% Write Gradients
%---------------------------------------------
func = str2func([WRT.wrtgradfunc,'_Func']);
INPUT.G = IMP.G;
INPUT.rdur = [IMP.GQNT.idivno IMP.GQNT.twdivno*(ones(1,IMP.GQNT.twwords+1))];
INPUT.sym = WRT.sym;
[WRTGRD,err] = func(WRTGRD,INPUT);
if err.flag
    return
end
clear INPUT
[GradLabel] = TruncFileNameForDisp_v1(WRTGRD.GradLoc);
WRT.GradLoc = WRTGRD.GradLoc;
WRT.sysgmax = WRTGRD.sysgmax;

%---------------------------------------------
% Write Refocus
%---------------------------------------------
func = str2func([WRT.wrtrefocusfunc,'_Func']);
INPUT.WRT = WRT;
[WRTRFCS,err] = func(WRTRFCS,INPUT);
if err.flag == 1
    return
end
clear INPUT
[RefocusLabel] = TruncFileNameForDisp_v1(WRTRFCS.RefocusLoc);
WRT.RefocusLoc = WRTRFCS.RefocusLoc;

%---------------------------------------------
% Write Params
%---------------------------------------------
func = str2func([WRT.wrtparamfunc,'_Func']);
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
Panel(2,:) = {'RefocusLoc',RefocusLabel,'Output'};
Panel(3,:) = {'ParamLoc',ParamLabel,'Output'};
PanelOutput = cell2struct(Panel,{'label','value','type'},2);
WRT.PanelOutput = PanelOutput;

%--------------------------------------------
% Return
%--------------------------------------------
OUTPUT.WRT = WRT;


