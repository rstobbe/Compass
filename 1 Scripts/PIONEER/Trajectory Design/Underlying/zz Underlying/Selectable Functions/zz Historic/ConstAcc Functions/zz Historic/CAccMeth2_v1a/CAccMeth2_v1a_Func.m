%==================================================
% 
%==================================================

function [CACCM,err] = CAccMeth2_v1a_Func(CACCM,INPUT)

Status2('busy','Calculate Constraint',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
T = INPUT.TArr0;
Tacc0 = INPUT.Tacc;
ScaleAccProf = INPUT.ScaleAccProf;
magacc = INPUT.MagAcc;
Tsegs0 = INPUT.Taccseg;

ScaleAccProf = permute(ScaleAccProf,[2 1]);
%---------------------------------------------
% Constrain
%---------------------------------------------
Tsegs = sqrt(magacc./ScaleAccProf).*Tsegs0;
Tsegs(length(Tsegs)) = Tsegs(length(Tsegs)-1);
CACCM.Tsegs = Tsegs;
Tsegs0(length(Tsegs0)) = Tsegs0(length(Tsegs0)-1);

%---------------------------------------------
% Compare
%---------------------------------------------
figure(500); hold on;
plot(Tsegs0,'k');
plot(Tsegs,'b');

rel = sum(Tsegs)/sum(Tsegs0)

%---------------------------------------------
% Smooth
%---------------------------------------------
%Tsegs = smooth(Tsegs,7);
%Tsegs = permute(Tsegs,[2 1]);
%figure(500); hold on;
%plot(Tsegs,'b');

%---------------------------------------------
% ReGenerate Sampling Timing Vector
%---------------------------------------------
Tacc(1) = Tsegs(1)/2;
for n = 2:length(Tsegs)
    Tacc(n) = Tacc(n-1) + Tsegs(n-1)/2 + Tsegs(n)/2;
end

Tvel(1) = 0;
Tvel(2) = Tacc(1)*2;
for n = 3:length(Tsegs)
    Tvel(n) = Tvel(n-1) + (Tacc(n-1) - Tvel(n-1))*2;
end

Tsamp(1) = 0;
Tsamp(2) = Tvel(2)*2;
for n = 3:length(Tsegs)
    Tsamp(n) = Tsamp(n-1) + (Tvel(n) - Tsamp(n-1))*2;
end

Tsamp = smooth(Tsamp,7);
Tsamp = permute(Tsamp,[2 1]);

figure(501); hold on;
plot(Tsamp);

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
plot(T);

figure(502)
plot(Tsamp-T);

%---------------------------------------------
% Return
%---------------------------------------------
CACCM.TArr = T;
%CACCM.TArr = Tsamp;
CACCM.Tvel = Tvel;
CACCM.Tacc = Tacc;

Status2('done','',3);