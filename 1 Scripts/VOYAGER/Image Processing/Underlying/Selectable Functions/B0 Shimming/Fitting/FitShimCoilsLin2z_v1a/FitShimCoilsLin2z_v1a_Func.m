%=====================================================
%
%=====================================================

function [FIT,err] = FitShimCoilsLin2z_v1a_Func(FIT,INPUT)

Status2('busy','Fit ShimCoils',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Input
%---------------------------------------------
Im = INPUT.Im;
CalData = INPUT.CalData;
clear INPUT;

%---------------------------------------------
% Create Spherical Harmonics
%---------------------------------------------
matsz = size(Im);
[SPHs] = GenAllDeg3SphHarms4z_v1a(matsz);

%---------------------------------------------
% Regression Setup
%---------------------------------------------
regfunc = str2func('FitShimCoilsLin2z_v1a_Reg');
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
INPUT.CalData = CalData;
func = @(V)regfunc(V,INPUT);
V0 = 10*ones(1,5);
[V,resnorm,residual,exitflag,output,~,jacobian] = lsqnonlin(func,V0,lb,ub,options);

%--------------------------------------------
% CalData
%--------------------------------------------
SphWgts0 = zeros(17,length(V));
m = 1;
for n = 1:length(CalData)
    if strcmp(CalData(n).Shim,'tof') || ...
        strcmp(CalData(n).Shim,'z1c') || ...
       strcmp(CalData(n).Shim,'x1') || ...
       strcmp(CalData(n).Shim,'y1') || ...
       strcmp(CalData(n).Shim,'z2c')
            SphWgts0(:,m) = (V(m)/CalData(n).CalVal)*CalData(n).SphWgts;
            m = m+1;
    end
end
SphWgts = sum(SphWgts0,2);

%--------------------------------------------
% Profile
%--------------------------------------------
for n = 1:17
    SPHs(:,:,:,n) = SPHs(:,:,:,n)*SphWgts(n);
end
Prof = sum(SPHs,4);

%---------------------------------------------
% Return
%---------------------------------------------
FIT.V = V;
FIT.Prof = Prof;
%FIT.Shims = 

Status2('done','',2);
Status2('done','',3);

