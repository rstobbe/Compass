%==================================================
% 
%==================================================

function [PLOT,err] = Plot_DesGradients_v1a_Func(PLOT,INPUT)

Status('busy','Plot kSpace (Ortho)');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
DES = INPUT.DES;
gamma = PLOT.gamma;
clr = 'm';
clear INPUT;

%---------------------------------------------
% Plot
%---------------------------------------------
KSA = DES.KSA;
T = DES.T;
kmax = DES.PROJdgn.kmax;

kmat = zeros([1 size(KSA)]);
kmat(1,:,:) = KSA*kmax;
G = SolveGradQuant_v1b(T,kmat,gamma);
G = squeeze(G);

%figure(350); hold on; plot(T,[G(:,1);0],clr,'linewidth',1); plot([0 T(length(T))],[0 0],'k:'); xlabel('Real Time (ms)'); ylabel('x-Gradient (mT/m)');
%figure(351); hold on; plot(T,[G(:,2);0],clr,'linewidth',1); plot([0 T(length(T))],[0 0],'k:'); xlabel('Real Time (ms)'); ylabel('y-Gradient (mT/m)');
%figure(352); hold on; plot(T,[G(:,3);0],clr,'linewidth',1); plot([0 T(length(T))],[0 0],'k:'); xlabel('Real Time (ms)'); ylabel('z-Gradient (mT/m)');

figure(350); hold on; 
plot([0 T(length(T))],[0 0],'k:'); 
plot(T,[G(:,3);0],'g','linewidth',1); 
plot(T,[G(:,2);0],'r','linewidth',1); 
plot(T,[G(:,1);0],'b','linewidth',1); 
xlabel('Readout (ms)'); 
ylabel('Gradient (mT/m)');
OutStyle(1);

Gmag = sqrt(G(:,1).^2 + G(:,2).^2 + G(:,3).^2);

figure(353); hold on; plot([0 T(length(T))],[0 0],'k:'); 
plot(T,[Gmag;0],clr,'linewidth',1); 
xlabel('Real Time (ms)'); 
ylabel('Gradient Mag');