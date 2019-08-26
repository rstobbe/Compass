%====================================================
%
%====================================================

function [RADEV,err] = RSE_const_v1a_Func(RADEV,INPUT)

Status2('busy','Get Radial Evolution Function for DE Solving',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Define
%---------------------------------------------
base = '(1/p^2)*(';  
RADEV.deradsolfunc = [base,RADEV.cval,')'];

%---------------------------------------------
% Panel Output
%--------------------------------------------- 
RADEV.PanelOutput = struct();
Status2('done','',3);
