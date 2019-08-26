%=========================================================
% 
%=========================================================

function [CALCTOP,err] = CreateTrajPSD_v1b_Func(CALCTOP,INPUT)

Status('busy','Calculate PSD');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
IMP = INPUT.IMP;
CALC = INPUT.CALC;
clear INPUT

%---------------------------------------------
% Calculate PSD
%---------------------------------------------
func = str2func([CALCTOP.calcpsdfunc,'_Func']);  
INPUT.IMP = IMP;
INPUT.tfdiam = [];
INPUT.tforient = '';
[CALC,err] = func(CALC,INPUT);
if err.flag
    return
end
clear INPUT;
CALCTOP = CALC;
CALCTOP.PROJdgn = IMP.impPROJdgn;

%----------------------------------------------------
% Panel Items
%----------------------------------------------------
Panel(1,:) = {'','','Output'};
Panel(2,:) = {'Method',CALCTOP.method,'Output'};
Panel(3,:) = {'Imp_File',IMP.name,'Output'};
Panel = [Panel;CALC.Panel];
PanelOutput = cell2struct(Panel,{'label','value','type'},2);
CALCTOP.Panel = Panel;
CALCTOP.PanelOutput = PanelOutput;

Status2('done','',1);
Status2('done','',2);
Status2('done','',3);