%=====================================================
%
%=====================================================

function [FIT,err] = Fit3DegShimCoilsMRS_v1a_Func(FIT,INPUT)

Status2('busy','Fit ShimCoils',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Input
%---------------------------------------------
Im = INPUT.Im;
CalData = INPUT.CalData;
PrevShims = INPUT.PrevShims;
%ShimsUsed = INPUT.ShimsUsed;
clear INPUT;

%---------------------------------------------
% Get Freq Shift Value
%---------------------------------------------
PrevShims(1) = PrevShims(1) - FIT.h1freq;

%---------------------------------------------
% Create Spherical Harmonics
%---------------------------------------------
matsz = size(Im);
[SPHs] = GenAllDeg3SphHarms_v1a(matsz);

%---------------------------------------------
% Regression Setup
%---------------------------------------------
regfunc = str2func('Fit3DegShimCoilsMRS_v1a_Reg');
options = optimoptions(@lsqnonlin,...
                    'Algorithm','trust-region-reflective',...
                    'Display','iter','Diagnostics','on',...
                    'FinDiffType','forward',...                  % forward    
                    'DiffMinChange',0.001,...                    % 0.01 (0.025)
                    'TolFun',1e-12,...
                    'TolX',1e-12);
lb = -32000*ones(1,length(CalData)) + PrevShims;
ub = 32000*ones(1,length(CalData)) + PrevShims;

%---------------------------------------------
% Create Low-Res Images
%---------------------------------------------
INPUT.Im = Im;
INPUT.SPHs = SPHs;
INPUT.CalData = CalData;
func = @(V)regfunc(V,INPUT);
V0 = 10*ones(1,length(CalData));
[V,resnorm,residual,exitflag,output,~,jacobian] = lsqnonlin(func,V0,lb,ub,options);

%--------------------------------------------
% CalData
%--------------------------------------------
for n = 1:length(CalData)
    SphWgts0(:,n) = (V(n)/CalData(n).CalVal)*CalData(n).SphWgts;
end
SphWgts = sum(SphWgts0,2);

%--------------------------------------------
% Profile
%--------------------------------------------
for n = 1:16
    SPHs(:,:,:,n) = SPHs(:,:,:,n)*SphWgts(n);
end
Prof = sum(SPHs,4);

%---------------------------------------------
% Return
%---------------------------------------------
FIT.V = V;
FIT.Prof = Prof;

Status2('done','',2);
Status2('done','',3);

