%====================================================
% 
%====================================================

function [CACCP,err] = CAccProf_Exp2Uniform_v1a_Func(CACCP,INPUT)

Status2('busy','Get Desired Acceleration Profile',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Define
%---------------------------------------------

CACCP.Accprof = ['@(Acc0,AccMax,t) Acc0+(AccMax-Acc0)*(1 - exp((-t.^',num2str(CACCP.power),')/',num2str(CACCP.tau),'))'];

Status2('done','',3);
