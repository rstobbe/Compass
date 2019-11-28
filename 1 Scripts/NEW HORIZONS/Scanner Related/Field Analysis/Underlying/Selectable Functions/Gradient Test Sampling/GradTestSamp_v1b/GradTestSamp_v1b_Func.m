%=====================================================
%
%=====================================================

function [GTSAMP,err] = GradTestSamp_v1b_Func(GTSAMP,INPUT)

Status2('busy','Grad Test Sampling',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
IMP = INPUT.IMP;
clear INPUT;

IMP.PROJimp.dwell = GTSAMP.dwell/1000;
IMP.PROJimp.tro = GTSAMP.tro;
IMP.PROJimp.npro = IMP.PROJimp.tro/IMP.PROJimp.dwell;
IMP.PROJimp.os = 1;

GTSAMP.IMP = IMP;

Panel(1,:) = {'Method',GTSAMP.method,'Output'};
Panel(2,:) = {'Dwell',GTSAMP.dwell,'Output'};
Panel(3,:) = {'Tro',GTSAMP.tro,'Output'};
PanelOutput = cell2struct(Panel,{'label','value','type'},2);
GTSAMP.PanelOutput = PanelOutput;

Status2('done','',3);