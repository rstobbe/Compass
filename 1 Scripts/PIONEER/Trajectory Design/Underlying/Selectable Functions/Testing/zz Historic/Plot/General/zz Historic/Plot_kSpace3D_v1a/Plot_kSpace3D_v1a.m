%==================================================
% 
%==================================================

function [SCRPTipt,SCRPTGBL,err] = Plot_kSpace3D_v1a(SCRPTipt,SCRPTGBL)

errnum = 1;
err.flag = 0;
err.msg = '';

N = str2double(SCRPTipt(strcmp('TrajNum',{SCRPTipt.labelstr})).entrystr);

KSA = SCRPTGBL.KSA;
kmax = SCRPTGBL.PROJdgn.kmax;

figure(500); plot3(squeeze(KSA(N,:,1))*kmax,squeeze(KSA(N,:,2))*kmax,squeeze(KSA(N,:,3))*kmax,'k');
hold on; axis equal; grid on; box on;
set(gca,'cameraposition',[-1000 -2000 300]); 
%set(gca,'xtick',[-20 0 20]); set(gca,'ytick',[-20 0 20]); set(gca,'ztick',[-20 0 20]);
set(gca,'xtick',[-ceil(kmax) -ceil(kmax)/2 0 ceil(kmax)/2 ceil(kmax)]); 
set(gca,'ytick',[-ceil(kmax) -ceil(kmax)/2 0 ceil(kmax)/2 ceil(kmax)]); 
set(gca,'ztick',[-ceil(kmax) -ceil(kmax)/2 0 ceil(kmax)/2 ceil(kmax)]);
axis([-ceil(kmax) ceil(kmax) -ceil(kmax) ceil(kmax) -ceil(kmax) ceil(kmax)]);

outstyle = 1;
if outstyle == 1
    set(gcf,'units','inches');
    set(gcf,'position',[4 4 4 4]);
    set(gcf,'paperpositionmode','auto');
    set(gca,'units','inches');
    set(gca,'position',[0.75 0.5 2.5 2.5]);
    set(gca,'fontsize',10,'fontweight','bold');
end