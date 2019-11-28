%====================================================
% 
%====================================================

function [PPT,err] = ProbeProfileTest_v1a_Func(PPT,INPUT)

Status2('busy','Probe Profile Test',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Load Input
%---------------------------------------------
FEVOL = INPUT.FEVOL;
IMP = FEVOL.SysTest.IMP;
GWFM = IMP.GWFM;
clear INPUT

%---------------------------------------------
% Load Input
%---------------------------------------------
Fid0 = mean(FEVOL.PC_Fid,1);
Params = FEVOL.PC_Params;

%-------------------------------------
% Plot FID Magnitude
%-------------------------------------
dwell = Params.dwell;
drop1 = (GWFM.pregdur+GWFM.rewinddur)/dwell;
drop2 = (GWFM.pregdur+GWFM.rewinddur+GWFM.readdur)/dwell;

FidAnlz = Fid0(drop1+1:drop2);
ind = find(abs(FidAnlz)==max(abs(FidAnlz)));
drop2 = drop2 + (ind-length(FidAnlz)/2);
FidAnlz = Fid0(drop1+1:drop2);

%-------------------------------------
% Plot FID Magnitude
%-------------------------------------
np = Params.np;
t = (0:dwell:(np-1)*dwell);
FidAnlzPlot = NaN*ones(size(t));
FidAnlzPlot(drop1+1:drop2) = FidAnlz;
figure(1234562314); hold on;
plot(t,abs(Fid0),'c');
plot(t,abs(FidAnlzPlot),'r');
xlabel('ms')
ylabel('arb');
title('AbsFidEvolution');

%-------------------------------------
% FT Fid
%-------------------------------------
ZfFidAnlz = zeros(1,200*np);
Cen = 100*np+1;
Pts = length(FidAnlz);
ZfFidAnlz(Cen:Cen+Pts-1) = FidAnlz;

FtFid = fftshift(fft(ifftshift(ZfFidAnlz)));

Fov = 1/(dwell*Params.gval*42.577);
Step = Fov/(200*np-1);
Dim = (-Fov/2:Step:Fov/2);

ind1 = find(Dim >= -0.1,1,'first');
ind2 = find(Dim >= 0.1,1,'first');

figure(1234562315); hold on;
plot(1000*Dim(ind1:ind2),abs(FtFid(ind1:ind2)));
xlabel('mm')
ylabel('arb');
title('Profile');

error;

%---------------------------------------------
% Returned
%---------------------------------------------
PPT.BG_expT = BG_expT;
PPT.BG_smthBloc1 = BG_smthBloc1;
PPT.BG_Params = FEVOL.BG_Params;
PPT.Data.BG_expT = BG_expT;
PPT.Data.BG_Fid1 = BG_Fid1;
PPT.Data.BG_PH1 = BG_PH1;
PPT.Data.BG_Bloc1 = BG_Bloc1;

%---------------------------------------------
% Panel Output
%--------------------------------------------- 
PPT.ExpDisp = '';

Status2('done','',2);
Status2('done','',3);


