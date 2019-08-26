%=========================================================
%
%=========================================================

function [SYSWRT,err] = WrtSys_VarianTpi_v1a_Func(SYSWRT,INPUT)

Status2('busy','Write Trajectories for Varian',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%-------------------------------------------------
% Get input
%-------------------------------------------------
IMP = INPUT.IMP;
G = INPUT.G; 
recononly = INPUT.recononly;
GRDWRT = SYSWRT.GRDWRT;
PRMWRT = SYSWRT.PRMWRT;
REFOCWRT = SYSWRT.REFOCWRT;
clear INPUT

SYSWRT.dummies = 0;
SYSWRT.name = ['TPI',IMP.name(4:end)];
WRT = struct();
GradLabel = [];
RefocusLabel = [];
ParamLabel = [];

if strcmp(recononly,'No')
    
    %---------------------------------------------
    % Write Gradients
    %---------------------------------------------
    func = str2func([GRDWRT.method,'_Func']);
    INPUT.G = G;
    INPUT.rdur = [IMP.GQNT.idivno IMP.GQNT.twdivno*(ones(1,IMP.GQNT.twwords+1))];
    INPUT.sym = IMP.SYS.sym;
    [GRDWRT,err] = func(GRDWRT,INPUT);
    if err.flag
        return
    end
    GradLabel = TruncFileNameForDisp_v1(GRDWRT.GradLoc);
    WRT.GradLoc = GRDWRT.GradLoc;
    WRT.sysgmax = GRDWRT.sysgmax;
    clear INPUT    
    
    %---------------------------------------------
    % Write Refocus
    %---------------------------------------------
    func = str2func([REFOCWRT.method,'_Func']);
    INPUT.WRT = WRT;
    INPUT.IMP = IMP;
    [REFOCWRT,err] = func(REFOCWRT,INPUT);
    if err.flag == 1
        return
    end
    clear INPUT
    RefocusLabel = TruncFileNameForDisp_v1(REFOCWRT.RefocusLoc);
    WRT.RefocusLoc = REFOCWRT.RefocusLoc;
    
    %---------------------------------------------
    % Write Params
    %---------------------------------------------
    func = str2func([PRMWRT.method,'_Func']);
    INPUT.WRT = WRT;
    INPUT.IMP = IMP;
    [PRMWRT,err] = func(PRMWRT,INPUT);
    if err.flag
        return
    end
    clear INPUT
    ParamLabel = TruncFileNameForDisp_v1(PRMWRT.ParamLoc);
    WRT.ParamLoc = PRMWRT.ParamLoc;

end

%----------------------------------------------------
% Panel Output
%----------------------------------------------------
Panel(1,:) = {'','','Output'};
Panel(2,:) = {'GradLoc',GradLabel,'Output'};
Panel(3,:) = {'RefocusLoc',RefocusLabel,'Output'};
Panel(4,:) = {'ParamLoc',ParamLabel,'Output'};
PanelOutput = cell2struct(Panel,{'label','value','type'},2);
SYSWRT.PanelOutput = PanelOutput;

%--------------------------------------------
% Return
%--------------------------------------------
SYSWRT.WRT = WRT;

Status2('done','',2);
Status2('done','',3);

