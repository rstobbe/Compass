%==================================================
% 
%==================================================

function [CACCM,err] = CAccMeth1b_v1a_Func(CACCM,INPUT)

Status2('busy','Calculate Constraint',3);

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
Tsegs = zeros(1,length(T)-1);
for n = 2:length(T)-1
    Tsegs(n-1) = sqrt(magacc(n)/ScaleAccProf(n))*(T(n)-T(n-1));
end
Tsegs(length(Tsegs)) = Tsegs(length(Tsegs)-1);
figure(1234); hold on
plot(Tsegs,'k');

%---------------------------------------------
% Smooth
%---------------------------------------------
%Tsegs = polyfit(1:length(Tsegs),Tsegs,5);
%Tsegs = smooth(Tsegs,0.0025,'lowess');
%Tsegs = smooth(Tsegs,15);
%Tsegs = permute(Tsegs,[2 1]);
%plot(Tsegs,'b');

%---------------------------------------------
% Build Timing Vector
%---------------------------------------------
for n = 2:length(T)
    T(n) = T(n-1) + Tsegs(n-1);
end

%---------------------------------------------
% Smooth
%---------------------------------------------
%T = smooth(T,13);
%T = permute(T,[2 1]);

%---------------------------------------------
% Return
%---------------------------------------------
CACCM.TArr = T;
CACCM.Tsegs = Tsegs;

Status2('done','',3);