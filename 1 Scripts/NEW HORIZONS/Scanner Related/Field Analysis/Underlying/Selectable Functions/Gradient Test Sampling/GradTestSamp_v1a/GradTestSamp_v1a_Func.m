%=====================================================
%
%=====================================================

function [GTSAMP,err] = GradTestSamp_v1a_Func(GTSAMP,INPUT)

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
IMP.PROJimp.os = GTSAMP.os;

GTSAMP.IMP = IMP;

Status2('done','',3);