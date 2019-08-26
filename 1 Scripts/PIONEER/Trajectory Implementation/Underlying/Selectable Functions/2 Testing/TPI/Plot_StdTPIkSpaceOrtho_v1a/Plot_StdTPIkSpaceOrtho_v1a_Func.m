%==================================================
% 
%==================================================

function [PLOT,err] = Plot_StdTPIkSpaceOrtho_v1a_Func(PLOT,INPUT)

Status2('busy','Plot k-Space (Ortho)',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%-----------------------------------------------------
% Get Input
%-----------------------------------------------------
N = PLOT.trajnum;
IMP = INPUT.IMP;
PROJdgn = INPUT.IMP.DES.PROJdgn;
samp0 = IMP.samp;
Kmat = IMP.Kmat;
clear INPUT

%---------------------------------------------
% Build Standard TPI
%---------------------------------------------
rad = (Kmat(:,:,1).^2 + Kmat(:,:,2).^2 + Kmat(:,:,3).^2).^0.5;
rad = mean(rad,1);
rad = rad/max(rad);
ind = find(rad >= PROJdgn.p,1,'first');

Traj = cat(1,[0 0 0],squeeze(Kmat(N,ind:end,:)));

samp = samp0(ind:end)-samp0(ind);
samp = PROJdgn.TPIiseg + ((PROJdgn.tro-PROJdgn.TPIiseg)/samp(end))*samp;
samp = [0 samp];

%-----------------------------------------------------
% Plot
%-----------------------------------------------------
fh = figure(1000); hold on; box on;
plot(samp,Traj(:,1),'b-'); plot(samp,Traj(:,2),'g-'); plot(samp,Traj(:,3),'r-');
title(['Traj',num2str(1)]);
xlabel('(ms)','fontsize',10,'fontweight','bold');
ylabel('k-Space (1/m)','fontsize',10,'fontweight','bold');
%xlim([0 samp(end)]);
xlim([0 5]);
fh.Units = 'inches';
fh.Position = [5 5 3 2.4];


