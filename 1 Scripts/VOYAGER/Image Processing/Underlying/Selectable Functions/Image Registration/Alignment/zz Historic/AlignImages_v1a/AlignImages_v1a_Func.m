%=========================================================
% 
%=========================================================

function [ALGN,err] = AlignImages_v1a_Func(ALGN,INPUT)

Status2('busy','Align Images',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
JiggleIm = INPUT.IMG{2}.Im;
%clear INPUT;

%---------------------------------------------
% Regression Setup
%---------------------------------------------
regfunc = str2func([ALGN.method,'_Reg']);
options = optimset( 'Algorithm','trust-region-reflective',...
                    'Display','iter','Diagnostics','on',...
                    'FinDiffType','forward',...                  % forward    
                    'DiffMinChange',0.001,...                    % 0.01 (0.025)
                    'TolFun',1e-2,...
                    'TolX',1e-2);
lb = [];
ub = [];

%---------------------------------------------
% Regression Setup
%---------------------------------------------
V0 = [0 0 0 0 0 0 1];
func = @(V)regfunc(V,ALGN,INPUT);
[V,resnorm,residual,exitflag,output,~,jacobian] = lsqnonlin(func,V0,lb,ub,options);
%ci = nlparci(V,residual,jacobian);
%CI(n,:,:) = ci;

%---------------------------------------------
% Transform Image
%---------------------------------------------
RgstrIm = Transform3DMatrix_v1b(JiggleIm,V(1),V(2),V(3),V(4),V(5),V(6));

%---------------------------------------------
% Return
%---------------------------------------------
ALGN.Im = RgstrIm;

Status2('done','',2);
Status2('done','',3);

