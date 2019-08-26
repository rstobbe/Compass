%=========================================================
% 
%=========================================================

function [B0,err] = B0osc47Add_v1a_Func(B0,INPUT)

Status2('busy','Add B0 Oscillation',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
IMP = INPUT.IMP;
Kmat = IMP.Kmat;
samp = IMP.samp;
PROJimp = IMP.PROJimp;
B0COMP = IMP.B0COMP;
SampDat = INPUT.KSMP.SampDat;
clear INPUT;

%---------------------------------------------
% Common Variables
%---------------------------------------------
nproj = PROJimp.nproj;
npro = PROJimp.npro;

%---------------------------------------------
% Add Phase Evolution
%---------------------------------------------
SampDatMat = DatArr2Mat(SampDat,nproj,npro);
PhaseEv = exp(1i*B0COMP.PhaseB0);
SampDatMat = SampDatMat.*PhaseEv;
SampDat = DatMat2Arr(SampDatMat,nproj,npro);

%---------------------------------------------
% Plot
%---------------------------------------------
figure(100); hold on;
plot(samp,real(PhaseEv(1,:)),'b','linewidth',2);
plot(samp,imag(PhaseEv(1,:)),'r','linewidth',2);
xlabel('Readout (ms)'); ylabel('Signal Evolution (real - imag)');
ylim([-1 1]);
figure(101); hold on;
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



