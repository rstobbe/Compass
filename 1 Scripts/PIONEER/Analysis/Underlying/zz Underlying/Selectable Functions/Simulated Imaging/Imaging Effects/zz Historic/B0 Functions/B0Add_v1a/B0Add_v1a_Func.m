%=========================================================
% 
%=========================================================

function [B0,err] = B0Add_v1a_Func(B0,INPUT)

Status2('busy','Add B0 Decay',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
IMP = INPUT.IMP;
Kmat = IMP.Kmat;
PROJimp = IMP.PROJimp;
PROJdgn = IMP.impPROJdgn;
SampDat = INPUT.KSMP.SampDat;
%B0offset = B0.B0offset;
offres = B0.offres;
clear INPUT;

%---------------------------------------------
% Common Variables
%---------------------------------------------
dwell = PROJimp.dwell;
sampstart = PROJimp.sampstart;
tro = PROJdgn.tro;
nproj = PROJimp.nproj;
npro = PROJimp.npro;

%---------------------------------------------
% off resonance frequence
%---------------------------------------------
%MagField = 4.7;
%offres = B0offset*MagField*42.577;

%---------------------------------------------
% Add Phase Evolution
%---------------------------------------------
SampDatMat = DatArr2Mat(SampDat,nproj,npro);
t = meshgrid((sampstart:dwell:tro),(1:nproj));
%PhaseEv = exp(1i*2*pi*t/1000*offres);
t1 = meshgrid((sampstart:dwell:5),(1:nproj));
t2 = meshgrid((-5:dwell:tro-10),(1:nproj));
%PhaseEv = [exp(1i*2*pi*t1/1000*offres) exp(1i*2*pi*t2/1000*offres)];
PhaseEv = [exp(1i*2*pi*(t1+5)/1000*offres) exp(1i*2*pi*(t2-5)/1000*offres)];

SampDatMat = SampDatMat.*PhaseEv;
SampDat = DatMat2Arr(SampDatMat,nproj,npro);

%---------------------------------------------
% Plot
%---------------------------------------------
figure(100); hold on;
plot(t(1,:),real(PhaseEv(1,:)),'b','linewidth',2);
plot(t(1,:),imag(PhaseEv(1,:)),'r','linewidth',2);
xlabel('Readout (ms)'); ylabel('Signal Evolution (real - imag)');
ylim([-1 1]);
figure(101); hold on;
plot(t(1,:),angle(PhaseEv(1,:)),'b','linewidth',2);
xlabel('Readout (ms)'); ylabel('Signal Evolution (phase)');
ylim([-pi pi]);
figure(102); hold on;
r = squeeze(sqrt(Kmat(1,:,1).^2 + Kmat(1,:,2).^2 + Kmat(1,:,3).^2));
r = r/max(r(:));
plot(r,real(PhaseEv(1,:)),'b','linewidth',2);
plot(r,imag(PhaseEv(1,:)),'r','linewidth',2);
xlabel('Relative Radial Dimension'); ylabel('Signal Evolution (real - imag)');
ylim([-1 1]);

%---------------------------------------------
% Return
%---------------------------------------------
B0.SampDat = SampDat;

Status2('done','',2);
Status2('done','',3);



