%=====================================================
% 
%=====================================================

function [GCOMP,err] = GComp_noComp_v1a_Func(GCOMP,INPUT)

Status2('busy','No Transient Compensation',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
G = INPUT.G0;
T = INPUT.T;
clear INPUT

%---------------------------------------------
% Return
%---------------------------------------------
GCOMP.G = G;
GCOMP.T = T;

Status2('done','',3);
