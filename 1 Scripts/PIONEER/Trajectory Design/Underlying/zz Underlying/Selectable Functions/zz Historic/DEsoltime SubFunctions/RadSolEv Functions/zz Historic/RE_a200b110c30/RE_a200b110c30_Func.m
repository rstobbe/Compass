%====================================================
%
%====================================================

function [RADEV,err] = RE_a200b110c30_Func(RADEV,INPUT)

Status2('busy','Get Radial Evolution Function for DE Solving',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Define
%---------------------------------------------
RADEV.deradsolfunc = '(1/p^2)*(1 +  200*exp(-20*abs(r)/p) + 110*exp(-5*abs(r)/p) + 30*exp(-1.3*abs(r)/p))';     

%---------------------------------------------
% Panel Output
%--------------------------------------------- 
RADEV.PanelOutput = struct();
Status2('done','',3);
