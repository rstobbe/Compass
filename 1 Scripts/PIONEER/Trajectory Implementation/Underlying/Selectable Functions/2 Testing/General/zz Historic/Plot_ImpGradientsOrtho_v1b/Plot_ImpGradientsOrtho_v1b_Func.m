%==================================================
% 
%==================================================

function [PLOT,err] = Plot_ImpGradientsOrtho_v1b_Func(PLOT,INPUT)

Status2('busy','Plot Gradients (Ortho)',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%-----------------------------------------------------
% Get Input
%-----------------------------------------------------
N = PLOT.trajnum;
IMP = INPUT.IMP;
clear INPUT

%qTscnr = IMP.qTscnr(5:504) - 0.04;
%G = IMP.G(:,5:503,:);
qTscnr = IMP.qTscnr;
G = IMP.G;

%-----------------------------------------------------
% Plot
%-----------------------------------------------------
[A,B,C] = size(G);
Gvis = zeros(A,B*2,C); L = zeros(1,B*2);
for n = 1:length(qTscnr)-1
    L((n-1)*2+1) = qTscnr(n);
    L(n*2) = qTscnr(n+1);
    Gvis(:,(n-1)*2+1,:) = G(:,n,:);
    Gvis(:,n*2,:) = G(:,n,:);
end
fh = figure(1000); hold on; box on;
plot(L,Gvis(N,:,1),'b-'); plot(L,Gvis(N,:,2),'g-'); plot(L,Gvis(N,:,3),'r-');
ylim([-15 15]);
title(['Traj',num2str(1)]);
xlabel('(ms)','fontsize',10,'fontweight','bold');
ylabel('Gradients (mT/m)','fontsize',10,'fontweight','bold');
fh.Units = 'inches';
fh.Position = [5 5 3 2.4];
