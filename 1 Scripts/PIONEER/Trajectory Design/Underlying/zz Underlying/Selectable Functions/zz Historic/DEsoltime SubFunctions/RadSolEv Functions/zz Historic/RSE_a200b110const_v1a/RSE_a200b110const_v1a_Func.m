%====================================================
%
%====================================================

function [RADEV,err] = RSE_a200b110const_v1a_Func(RADEV,INPUT)

Status2('busy','Get Radial Evolution Function for DE Solving',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Define
%---------------------------------------------
%base = '(1/p^2)*(1 +  200*exp(-20*abs(r)/p) + 110*exp(-5*abs(r)/p)';     
%base = '(1/p^2)*(exp(-abs(r)/0.01)'; 
%base = '(1/p^2)*(1 +  200*exp(-abs(r)/(0.001*p))';  
%base = '(1/p^2)*(1 +  100*exp(-abs(r)/(0.3*p))'; 
%base = '(1/p^2)*(1 +  200*exp(-abs(r)/(0.08*p)) + 50*exp(-abs(r)/(0.6*p))'; 
%RADEV.deradsolfunc = [base,' + ',RADEV.cval,')'];

%RADEV.deradsolfunc = '(1/p^2)*(exp(-abs(r)/0.01))'; 
%RADEV.deradsolfunc =  '(1/p^2)*(10 +  200*exp(-abs(r)/(0.001*p)))';  
%RADEV.deradsolfunc = '(1/p^2)*(1 + 0.5./abs(r) + (0.2./(abs(r.^1.8))).*exp(-abs(r)/0.1) + (0.25./(abs(r.^2.5))).*exp(-abs(r)/0.008))'; 
RADEV.deradsolfunc = '(1.00./(abs(r.^2.25)*p^2))'; 

%RADEV.deradsolfunc = '(1./(abs(r.^2)*p^2))'; 
%RADEV.deradsolfunc = '(1/p^2)';

%---------------------------------------------
% Panel Output
%--------------------------------------------- 
RADEV.PanelOutput = struct();
Status2('done','',3);
