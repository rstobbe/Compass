%==================================================
% 
%==================================================

function [PLOT,err] = TrajImpComp_v1b_Func(PLOT,INPUT)

Status('busy','Compare Measured Trajectory to Implementation');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%-----------------------------------------------------
% Get Input
%-----------------------------------------------------
EDDY = INPUT.EDDY;
GRD = INPUT.GRD;
clear INPUT

%-----------------------------------------------------
% Get Gradient Info
%-----------------------------------------------------
L = GRD.L;
Gvis = GRD.Gvis;
samp = GRD.samp;
if strcmp(EDDY.graddir,'IO')
    Kmat = GRD.KmatZ;
    GSRI = GRD.GSRIZ;
elseif strcmp(EDDY.graddir,'LR')
    Kmat = GRD.KmatX;
    GSRI = GRD.GSRIX;
elseif strcmp(EDDY.graddir,'TB')
    Kmat = GRD.KmatY;
    GSRI = GRD.GSRIY;
end
gradend = GRD.graddur;
gamma = GRD.gamma;
TSRI = GRD.TSRI;

%-----------------------------------------------------
% Get Transient Field Info
%-----------------------------------------------------
Time = EDDY.Time;
Geddy = EDDY.Geddy;
dwell = Time(2) - Time(1);

%-----------------------------------------------------
% Create k-space vector
%-----------------------------------------------------
GeddyComp = Geddy;
GeddyComp(isnan(GeddyComp)) = 0;
Keddy = zeros(1,length(GeddyComp));
for n = 2:length(GeddyComp)
    Keddy(n) = Keddy(n-1) + (GeddyComp(n)+GeddyComp(n-1))/2*gamma*dwell;
end
KeddyImp = zeros(1,length(GSRI));
for n = 2:length(GSRI)
    KeddyImp(n) = KeddyImp(n-1) + (GSRI(n)+GSRI(n-1))/2*gamma*(TSRI(n)-TSRI(n-1));
end

%-----------------------------------------------------
% Plot Gradient and Design
%-----------------------------------------------------
figure(1000); hold on; 
plot([0 max(Time)],[0 0],'k:'); 
plot(L,Gvis,'k-');
plot(TSRI,GSRI,'b-');
plot(Time,Geddy,'r-');     
xlim([0 gradend]);
xlabel('(ms)'); ylabel('Gradient Evolution (mT/m)');

figure(1001); hold on; 
plot([0 max(Time)],[0 0],'k:'); 
plot(TSRI,KeddyImp,'k-');
plot(samp,Kmat,'k*');
plot(Time,Keddy,'r-');   
xlim([0 gradend]);
xlabel('(ms)'); ylabel('k Evolution (1/m)');


Status('done','');
Status2('done','',2);
Status2('done','',3);