%====================================================
% 
%====================================================

function [CACCP,err] = CAccProf_Uniform_v1c_Func(CACCP,INPUT)

Status2('busy','Get Desired Acceleration Profile',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Define
%---------------------------------------------

CACCP.Accprof = '@(Acc0,AccMax,t) Acc0+(AccMax-Acc0)*(1 - exp(-t.^1.2/0.03))';

Status2('done','',3);
