%====================================================
% 
%====================================================

function [CACCP,err] = CAccProf_Uniform_v1b_Func(CACCP,INPUT)

Status2('busy','Get Desired Acceleration Profile',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Define
%---------------------------------------------

CACCP.AccProf = '1';

Status2('done','',3);
