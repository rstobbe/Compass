%====================================================
% 
%====================================================

function [CACCP,err] = CAccProf_ExpDecay_v0a_Func(CACCP,INPUT)

Status2('busy','Get Desired Acceleration Profile',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Define
%---------------------------------------------

CACCP.AccProf = '0.375*(heaviside(-r+0.1) + heaviside(r-0.1).*exp(-(r-0.1)/0.2)) + 1';

accproffunc = str2func(['@(r)' CACCP.AccProf]);
r = (0:0.001:1);
figure(10056);
plot(r,accproffunc(r));

Status2('done','',3);
