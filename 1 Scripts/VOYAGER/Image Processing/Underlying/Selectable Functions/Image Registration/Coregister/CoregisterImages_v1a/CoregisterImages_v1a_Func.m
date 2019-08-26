%=========================================================
% 
%=========================================================

function [REGFNC,err] = CoregisterImages_v1a_Func(REGFNC,INPUT)

Status2('busy','Coregister Images',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
StatIm = double(abs(INPUT.IMG{1}.Im));
JiggleIm = double(abs(INPUT.IMG{2}.Im));
clear INPUT;

%---------------------------------------------
% Regression Setup
%---------------------------------------------
regfunc = str2func([REGFNC.method,'_Reg']);
% options = optimset( 'Algorithm','trust-region-reflective',...
%                     'Display','iter','Diagnostics','on',...
%                     'FinDiffType','forward',...                  % forward    
%                     'DiffMinChange',0.01,...                    % 0.01 (0.025)
%                     'TolFun',1e-2,...
%                     'TolX',1e-2);

%---------------------------------------------
% Regression
%---------------------------------------------
INPUT.StatIm = StatIm;
INPUT.JiggleIm = JiggleIm;
V0 = [0 0 0 0 0 0 1];
func = @(V)regfunc(V,REGFNC,INPUT);
%[V,fval,exitflag,output] = fminunc(func,V0,options);
[V,fval,exitflag,output] = fminunc(func,V0);

%---------------------------------------------
% Scale 'V's
%---------------------------------------------
V(1:3) = V(1:3)/10;
V(4:6) = V(4:6)*10;
V

%---------------------------------------------
% Transform Image
%---------------------------------------------
RgstrIm = Transform3DMatrix_v1b(JiggleIm,V(1),V(2),V(3),V(4),V(5),V(6));

%---------------------------------------------
% Return
%---------------------------------------------
REGFNC.Im = RgstrIm;
REGFNC.V = V;
REGFNC.resid = residual;

Status2('done','',2);
Status2('done','',3);

