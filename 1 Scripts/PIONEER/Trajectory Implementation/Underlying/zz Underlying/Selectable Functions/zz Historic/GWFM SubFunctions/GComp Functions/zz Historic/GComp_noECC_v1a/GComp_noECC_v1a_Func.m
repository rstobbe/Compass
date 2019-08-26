%=====================================================
% 
%=====================================================

function [GCOMP,err] = GComp_noECC_v1a_Func(GCOMP,INPUT)

Status2('busy','No Eddy-Current Compensation',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
G = INPUT.G0;
T = INPUT.qT;
clear INPUT

%---------------------------------------------
% Return
%---------------------------------------------
GCOMP.graddel = 0;
GCOMP.gcoil = '';
GCOMP.Tcomp = T;
GCOMP.Gcomp = G;
GCOMP.xgshift = 0;
GCOMP.ygshift = 0;
GCOMP.zgshift = 0;
GCOMP.gorder = 'xyz';


Status2('done','',3);
