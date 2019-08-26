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
magacc = INPUT.MagAcc;
tro = T(length(T));

%------------------------------------------
% Scale Acceleration
%------------------------------------------ 
slvno = length(magacc);
ScaleAccProf = magacc(slvno)*ones(1,slvno);

%---------------------------------------------
% Constrain
%---------------------------------------------
Tsegs = zeros(1,length(T));
for n = 2:length(T)
    Tsegs(n) = sqrt(magacc(n)/ScaleAccProf(n-1))*(T(n)-T(n-1));
end

for n = 2:length(T)
    T(n) = T(n-1) + Tsegs(n);
end

%---------------------------------------------
% Relative Trajectory Increase
%---------------------------------------------
relprojleninc = T(length(T))/tro;
  
%---------------------------------------------
% Return
%---------------------------------------------
CACCM.TArr = T;
CACCM.Tsegs = Tsegs;
CACCM.relprojleninc = relprojleninc;

Status2('done','',3);

