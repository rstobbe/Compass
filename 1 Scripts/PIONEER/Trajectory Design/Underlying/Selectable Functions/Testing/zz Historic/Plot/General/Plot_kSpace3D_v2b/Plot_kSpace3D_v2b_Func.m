%==================================================
% 
%==================================================

function [PLOT,err] = Plot_kSpace3D_v2b_Func(PLOT,INPUT)

Status('busy','Plot kSpace (Ortho)');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
DES = INPUT.DES;
relrad = PLOT.relrad;
clear INPUT;

%---------------------------------------------
% Plot Data
%---------------------------------------------
KSA = DES.KSA;
kmax = DES.PROJdgn.kmax;
kstep = DES.PROJdgn.kstep;

%---------------------------------------------
% Plot Lenth
%---------------------------------------------
rrad = ((KSA(:,1).^2 + KSA(:,2).^2 + KSA(:,3).^2).^(0.5));
ind1 = 1;
ind2 = find(rrad >= relrad,1,'first');
if relrad == 1
    ind2 = length(rrad);
end

%---------------------------------------------
% Plot 
%---------------------------------------------
if strcmp(PLOT.type,'AbsMax')
    pltmax = 100*ceil((relrad*kmax)/100);
    figure(500); plot3(kmax*squeeze(KSA(ind1:ind2,1)),squeeze(kmax*KSA(ind1:ind2,2)),squeeze(kmax*KSA(ind1:ind2,3)),'k');
elseif strcmp(PLOT.type,'RelMax')
    pltmax = relrad;
    figure(500); plot3(squeeze(KSA(ind1:ind2,1)),squeeze(KSA(ind1:ind2,2)),squeeze(KSA(ind1:ind2,3)),'k');
elseif strcmp(PLOT.type,'MatSteps')
    pltmax = ceil(relrad*kmax/kstep*0.5)*2;
    figure(500); plot3(squeeze(KSA(ind1:ind2,1))*kmax/kstep,squeeze(KSA(ind1:ind2,2))*kmax/kstep,squeeze(KSA(ind1:ind2,3))*kmax/kstep,'k');
end

hold on; axis equal; grid on; 
set(gca,'cameraposition',[-1000 -2000 300]); 
set(gca,'xtick',[-pltmax -pltmax/2 0 pltmax/2 pltmax]); 
set(gca,'ytick',[-pltmax -pltmax/2 0 pltmax/2 pltmax]); 
set(gca,'ztick',[-pltmax -pltmax/2 0 pltmax/2 pltmax]);
axis([-pltmax pltmax -pltmax pltmax -pltmax pltmax]);
box off;

outstyle = 1;
if outstyle == 1
    set(gcf,'units','inches');
    set(gcf,'position',[4 4 4 4]);
    set(gcf,'paperpositionmode','auto');
    set(gca,'units','inches');
    set(gca,'position',[0.75 0.5 2.5 2.5]);
    set(gca,'fontsize',10,'fontweight','bold');
end

