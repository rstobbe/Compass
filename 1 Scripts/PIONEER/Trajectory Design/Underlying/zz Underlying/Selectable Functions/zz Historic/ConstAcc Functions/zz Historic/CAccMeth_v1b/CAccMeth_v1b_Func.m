%==================================================
% 
%==================================================

function [CACCM,err] = CAccMeth1_v1b_Func(CACCM,INPUT)

Status2('busy','Constrain Acceleration',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
T = INPUT.TArr0;
ScaleAccProf = INPUT.ScaleAccProf;
magacc = INPUT.MagAcc;

%---------------------------------------------
% Constrain
%---------------------------------------------
Tsegs = zeros(1,length(T));
for n = 2:length(T)
    Tsegs(n) = sqrt(magacc(n)/ScaleAccProf(n))*(T(n)-T(n-1));
end

for n = 2:length(T)
    T(n) = T(n-1) + Tsegs(n);
end

%---------------------------------------------
% Return
%---------------------------------------------
CACCM.TArr = T;
CACCM.Tsegs = Tsegs;

Status2('done','',3);