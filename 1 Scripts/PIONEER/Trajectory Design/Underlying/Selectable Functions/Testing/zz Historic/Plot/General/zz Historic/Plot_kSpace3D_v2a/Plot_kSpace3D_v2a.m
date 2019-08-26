%==================================================
% 
%==================================================

function [SCRPTipt,SCRPTGBL,err] = Plot_kSpace3D_v2a(SCRPTipt,SCRPTGBL)

errnum = 1;
err.flag = 0;
err.msg = '';

relrad = str2double(SCRPTipt(strcmp('RelRad',{SCRPTipt.labelstr})).entrystr);

KSA = squeeze(SCRPTGBL.KSA);
kmax = SCRPTGBL.PROJdgn.kmax;
kstep = SCRPTGBL.PROJdgn.kstep;

rrad = ((KSA(:,1).^2 + KSA(:,2).^2 + KSA(:,3).^2).^(0.5));
test = max(rrad)
if relrad == 1
    ind = length(rrad);
else
    ind = find(rrad > relrad,1,'first');
end

kstep = 1;
pltmax = ceil(relrad*kmax/kstep*0.5)*2;

figure(500); plot3(squeeze(KSA(1:ind,1))*kmax/kstep,squeeze(KSA(1:ind,2))*kmax/kstep,squeeze(KSA(1:ind,3))*kmax/kstep,'k');
%figure(500); plot3(squeeze(KSA(1:ind,1))*kmax/kstep,squeeze(KSA(1:ind,2))*kmax/kstep,squeeze(KSA(1:ind,3))*kmax/kstep,'k','linewidth',1);
hold on; axis equal; grid on; box on;
set(gca,'cameraposition',[-1000 -2000 300]); 
set(gca,'xtick',[-pltmax -pltmax/2 0 pltmax/2 pltmax]); 
set(gca,'ytick',[-pltmax -pltmax/2 0 pltmax/2 pltmax]); 
set(gca,'ztick',[-pltmax -pltmax/2 0 pltmax/2 pltmax]);
axis([-pltmax pltmax -pltmax pltmax -pltmax pltmax]);

outstyle = 1;
if outstyle == 1
    set(gcf,'units','inches');
    set(gcf,'position',[4 4 4 4]);
    set(gcf,'paperpositionmode','auto');
    set(gca,'units','inches');
    set(gca,'position',[0.75 0.5 2.5 2.5]);
    set(gca,'fontsize',10,'fontweight','bold');
end