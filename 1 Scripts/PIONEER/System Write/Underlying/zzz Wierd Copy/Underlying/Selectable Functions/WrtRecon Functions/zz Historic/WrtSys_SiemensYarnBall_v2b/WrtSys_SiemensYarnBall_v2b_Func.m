%=========================================================
%
%=========================================================

function [SYSWRT,err] = WrtSys_SiemensYarnBall_v2b_Func(SYSWRT,INPUT)

Status2('busy','Write Trajectories for Siemens',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%-------------------------------------------------
% Get input
%-------------------------------------------------
IMP = INPUT.IMP;
G = INPUT.G; 
GRDWRT = SYSWRT.GRDWRT;
PRMWRT = SYSWRT.PRMWRT;
clear INPUT

%---------------------------------------------
% Add Dummies
%---------------------------------------------
if SYSWRT.dummies > 0
    Gtraj1 = G(1,:,:);
    GDum = repmat(Gtraj1,[SYSWRT.dummies,1,1]);
    G = cat(1,GDum,G);
end

%---------------------------------------------
% Write Params
%---------------------------------------------
func = str2func([PRMWRT.method,'_Func']);
INPUT.IMP = IMP;
INPUT.G = G;
INPUT.recononly = SYSWRT.recononly;
[PRMWRT,err] = func(PRMWRT,INPUT);
if err.flag
    return
end
clear INPUT
SYSWRT.name = PRMWRT.name;

if not(strcmp(SYSWRT.recononly,'Yes'))
    %---------------------------------------------
    % Write Gradients
    %---------------------------------------------
    path = PRMWRT.path;
    file = PRMWRT.file;
    func = str2func([GRDWRT.method,'_Func']);
    INPUT.G = G;
    INPUT.file = [path,file];
    [GRDWRT,err] = func(GRDWRT,INPUT);
    if err.flag
        return
    end
    clear INPUT
end

%--------------------------------------------
% Panel
%--------------------------------------------
Panel(1,:) = {'','','Output'};
Panel(2,:) = {'',SYSWRT.method,'Output'};
Panel(3,:) = {'Dummies',SYSWRT.dummies,'Output'};
SYSWRT.PanelOutput = cell2struct(Panel,{'label','value','type'},2);

Status2('done','',2);
Status2('done','',3);

