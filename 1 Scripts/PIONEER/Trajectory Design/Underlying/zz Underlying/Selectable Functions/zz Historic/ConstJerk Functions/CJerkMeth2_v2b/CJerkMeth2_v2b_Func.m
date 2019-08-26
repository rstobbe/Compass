%==================================================
% 
%==================================================

function [CACCJ,err] = CJerkMeth2_v2b_Func(CACCJ,INPUT)

Status2('busy','Calculate Constraint',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
T = INPUT.TArr0;
Tsegs0 = T(2)*ones(size(T));

%---------------------------------------------
% Mod
%---------------------------------------------
V1 = CACCJ.expval1;
tc1 = CACCJ.exptc1;
V2 = CACCJ.expval2;
tc2 = CACCJ.exptc2;
Tsegs = Tsegs0 + V1*Tsegs0(1)*exp(-T/tc1) + V2*Tsegs0(1)*exp(-T/tc2);

%---------------------------------------------
% Rebuild
%---------------------------------------------
for n = 2:length(T)
    T(n) = T(n-1) + Tsegs(n-1);
end

%---------------------------------------------
% Return
%---------------------------------------------
CACCJ.TArr = T;
CACCJ.Tsegs = Tsegs;

Status2('done','',3);