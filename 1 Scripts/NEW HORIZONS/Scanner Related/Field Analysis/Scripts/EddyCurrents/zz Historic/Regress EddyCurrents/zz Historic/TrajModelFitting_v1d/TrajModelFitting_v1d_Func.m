%==================================
% 
%==================================

function [RGRS,err] = TrajModelFitting_v1d_Func(RGRS,INPUT)

Status('busy','Regress Eddy Currents');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
EDDY = INPUT.EDDY;
IMP = INPUT.IMP;
ECM = RGRS.ECM;
clear INPUT;

%-----------------------------------------------------
% Get Gradient Info
%-----------------------------------------------------
trajno = RGRS.trajnum;
dir = RGRS.trajortho;
Tdes = IMP.qTscnr;
Gdes = IMP.G(trajno,:,dir);

%-----------------------------------------------------
% Zero Fill Trajectory
%-----------------------------------------------------
Tadd = (Tdes(2):Tdes(2):2) + Tdes(length(Tdes));
Tdes = [Tdes Tadd];
Gdes = [Gdes zeros(1,length(Tadd))];

%-----------------------------------------------------
% Traj Vis
%-----------------------------------------------------
Gvis = 0; L = 0;
for n = 1:length(Tdes)-1
    L = [L [Tdes(n) Tdes(n+1)]];
    Gvis = [Gvis [Gdes(n) Gdes(n)]];
end

%-----------------------------------------------------
% Get Values
%-----------------------------------------------------
Time = EDDY.Time;
Gmeas = EDDY.Geddy;
gstepdur = Tdes(2);
Tdes = Tdes(1:length(Tdes)-1);

%-----------------------------------------------------
% Gradient Time Shift
%-----------------------------------------------------
Time = Time + RGRS.gstartshift/1000;

%-----------------------------------------------------
% Plot Gradient Design
%-----------------------------------------------------
doplot = 1;
if doplot == 1
    figure(5000); hold on;
    plot([0 max(L)],[0 0],'k:');     
    plot(L,Gvis,'k-');
    plot(Time,Gmeas,'r-');
    xlabel('(ms)'); ylabel('Gradient Evolution (mT/m)'); title('Transient Field (Gradient)');
    xlim([0 Time(length(Time))]);
end

%-----------------------------------------------------
% Save
%-----------------------------------------------------
RGRS.Time = Time;
RGRS.Gmeas = Gmeas;
RGRS.Tdes = Tdes;
RGRS.Gdes = permute(Gdes,[2 1]);

%-----------------------------------------------------
% Regression Function Input
%-----------------------------------------------------
Status2('busy','Perform Regression',2);
func = str2func([RGRS.modelfunc,'_Func']);
INPUT.Time = RGRS.Time;
INPUT.Gmeas = RGRS.Gmeas;
INPUT.Tdes = RGRS.Tdes;
INPUT.Gdes = RGRS.Gdes;
INPUT.gstepdur = gstepdur;
INPUT.L = L;
INPUT.Gvis = Gvis;
[ECM,err] = func(ECM,INPUT);
if err.flag
    return
end

RGRS.PanelOutput = ECM.PanelOutput;

Status2('done','',2);
Status2('done','',3);
