%=====================================================
%
%=====================================================

function [FIT,err] = Fit1DegSphHarm_v1a_Func(FIT,INPUT)

Status2('busy','Fit Sperical Harmonics',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Input
%---------------------------------------------
Im = INPUT.Im;

%---------------------------------------------
% Create Spherical Harmonics
%---------------------------------------------
matsz = size(Im);
[SPHs] = GenAllDeg1SphHarms_v1a(matsz);

%---------------------------------------------
% Regression Setup
%---------------------------------------------
regfunc = str2func('Fit1DegSphHarm_v1a_Reg');
options = optimset( 'Algorithm','trust-region-reflective',...
                    'Display','iter','Diagnostics','on',...
                    'FinDiffType','forward',...                  % forward    
                    'DiffMinChange',0.001,...                    % 0.01 (0.025)
                    'TolFun',1e-12,...
                    'TolX',1e-12);
lb = [];
ub = [];

%---------------------------------------------
% Create Low-Res Images
%---------------------------------------------
INPUT.Im = Im;
INPUT.SPHs = SPHs;
func = @(V)regfunc(V,INPUT);
V0 = ones(1,4);
[V,resnorm,residual,exitflag,output,~,jacobian] = lsqnonlin(func,V0,lb,ub,options);

%--------------------------------------------
% Profile
%--------------------------------------------
for n = 1:4
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

