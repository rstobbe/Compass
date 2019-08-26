%==================================================
% 
%==================================================

function [CACCM,err] = CJerkMeth1_v1a_Func(CACCM,INPUT)

Status2('busy','Calculate Constraint',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
T = INPUT.TArr0;
JerkMax = INPUT.JerkMax;
magjerk = INPUT.MagJerk;

%---------------------------------------------
% Constrain
%---------------------------------------------
Tsegs = zeros(1,length(T));
for n = 2:length(T)
    Tsegs(n) = (magjerk(n)/JerkMax)^(1/3)*(T(n)-T(n-1));
end

for n = 2:length(T)
    T(n) = T(n-1) + Tsegs(n);
end

%---------------------------------------------
% Return
%---------------------------------------------
CACCM.TArr = T;

Status2('done','',3);