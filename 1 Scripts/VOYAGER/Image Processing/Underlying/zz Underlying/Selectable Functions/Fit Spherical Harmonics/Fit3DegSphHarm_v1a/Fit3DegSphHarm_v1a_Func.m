%=====================================================
%
%=====================================================

function [FIT,err] = Fit3DegSphHarm_v1a_Func(FIT,INPUT)

Status2('busy','Fit Sperical Harmonics',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Input
%---------------------------------------------
Im = INPUT.Im;
if isfield(INPUT,'TolFun')
    TolFun = INPUT.TolFun;
else
    TolFun = 1e-12;
end
if isfield(INPUT,'TolX')
    TolX = INPUT.TolX;
else
    TolX = 1e-12;
end

%---------------------------------------------
% Create Spherical Harmonics
%---------------------------------------------
matsz = size(Im);
[SPHs] = GenAllDeg3SphHarms_v1a(matsz);

%---------------------------------------------
% Regression Setup
%---------------------------------------------
regfunc = str2func('Fit3DegSphHarm_v1a_Reg');
options = optimset( 'Algorithm','trust-region-reflective',...
                    'Display','iter','Diagnostics','on',...
                    'FinDiffType','forward',...                  % forward    
                    'DiffMinChange',0.001,...                    % 0.01 (0.025)
                    'TolFun',TolFun,...
                    'TolX',TolX);
lb = [];
ub = [];

%---------------------------------------------
% Create Low-Res Images
%---------------------------------------------
INPUT.Im = Im;
INPUT.SPHs = SPHs;
func = @(V)regfunc(V,INPUT);
V0 = ones(1,16);
[V,resnorm,residual,exitflag,output,~,jacobian] = lsqnonlin(func,V0,lb,ub,options);

%--------------------------------------------
% Profile
%--------------------------------------------
for n = 1:16
    SPHs(:,:,:,n) = SPHs(:,:,:,n)*V(n);
end
Prof = sum(SPHs,4);

%---------------------------------------------
% Return
%---------------------------------------------
FIT.V = V;
FIT.Prof = Prof;
FIT.resnorm = resnorm;

Status2('done','',2);
Status2('done','',3);

