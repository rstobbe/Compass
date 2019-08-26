%==================================================
% 
%==================================================

function [PLOT,err] = Plot_StdTPIGradientsOrtho_v1a_Func(PLOT,INPUT)

Status2('busy','Plot Standard TPI Gradients (Ortho)',2);
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
G0 = IMP.G;
qTscnr0 = IMP.qTscnr;
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

qTscnr = (0:0.01:PROJdgn.tro);
qTraj0 = interp1(samp,Traj,qTscnr);
qTraj = zeros(1,length(qTraj0),3);
qTraj(1,:,:) = qTraj0;
G = SolveGradQuant_v1b(qTscnr,qTraj,11.26);
%--
G(:,1:3,1) = [0.9 2.7 4.5];
%--
%---------------------------------------------
% Build Gradients
%---------------------------------------------
G = squeeze(G);
[A,B] = size(G);
Gvis = zeros(A*2,B); L = zeros(A*2,1);
for n = 1:length(qTscnr)-1
    L((n-1)*2+1) = qTscnr(n);
    L(n*2) = qTscnr(n+1);
    Gvis((n-1)*2+1,:) = G(n,:);
    Gvis(n*2,:) = G(n,:);
end

%-----------------------------------------------------
% Plot
%-----------------------------------------------------
fh = figure(1000); hold on; box on;
plot(L,Gvis(:,1),'b-'); plot(L,Gvis(:,2),'g-'); plot(L,Gvis(:,3),'r-');
title(['Traj',num2str(N)]);
xlabel('(ms)','fontsize',10,'fontweight','bold');
ylabel('Gradients (mT/m)','fontsize',10,'fontweight','bold');
ylim([-15 15]);
%xlim([0 5]);
fh.Units = 'inches';
fh.Position = [5 5 3 2.4];

Gmag = (Gvis(:,1).^2 + Gvis(:,2).^2 + Gvis(:,3).^2).^0.5;

fh = figure(1001); hold on; box on;
plot(L,Gmag(:,1),'k-');
title(['Traj',num2str(N)]);
xlabel('(ms)','fontsize',10,'fontweight','bold');
ylabel('Gradients (mT/m)','fontsize',10,'fontweight','bold');
ylim([-15 15]);
%xlim([0 5]);
fh.Units = 'inches';
fh.Position = [5 5 3 2.4];
