%==================================================
% 
%==================================================

function [PLOT,err] = Plot_DeskSpaceOrtho_v1a_Func(PLOT,INPUT)

Status('busy','Plot kSpace (Ortho)');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
DES = INPUT.DES;
clear INPUT;

%---------------------------------------------
% Plot
%---------------------------------------------
KSA = DES.KSA;
T = DES.T;
PROJdgn = DES.PROJdgn;
KSA = squeeze(KSA);
kmax = PROJdgn.kmax;

figure(450); hold on; plot(T,squeeze(KSA(:,1))*kmax,'k','linewidth',1); plot(T,zeros(size(T)),'k:'); xlabel('Real Time (ms)'); ylabel('(1/m)'); title('x k-space');
figure(451); hold on; plot(T,squeeze(KSA(:,2))*kmax,'k','linewidth',1); plot(T,zeros(size(T)),'k:'); xlabel('Real Time (ms)'); ylabel('(1/m)'); title('y k-space');
figure(452); hold on; plot(T,squeeze(KSA(:,3))*kmax,'k','linewidth',1); plot(T,zeros(size(T)),'k:'); xlabel('Real Time (ms)'); ylabel('(1/m)'); title('z k-space');