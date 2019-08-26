%==================================================
% 
%==================================================

function [SCRPTipt,SCRPTGBL,err] = Plot_ImpkSpace3D_v1a(SCRPTipt,SCRPTGBL)

errnum = 1;
err.flag = 0;
err.msg = '';

trajnum = SCRPTipt(strcmp('TrajNum',{SCRPTipt.labelstr})).entrystr;
relrad = str2double(SCRPTipt(strcmp('RelRad',{SCRPTipt.labelstr})).entrystr);

Kmat = SCRPTGBL.Kmat;
kmax = SCRPTGBL.PROJdgn.kmax;
kstep = SCRPTGBL.PROJdgn.kstep;

rrad = ((Kmat(1,:,1).^2 + Kmat(1,:,2).^2 + Kmat(1,:,3).^2).^(0.5))/kmax;
test = max(rrad)
if relrad == 1
    ind = length(rrad);
else
    ind = find(rrad > relrad,1,'first');
end

if strcmp(trajnum,'Multi')
    start = 1;
    stop = SCRPTGBL.PROJdgn.nproj;
else
    start = str2double(trajnum);
    stop = str2double(trajnum);
end

pltmax = ceil(relrad*kmax*0.5)*2;

%clr1 = ['r' 'r' 'r' 'r' 'r' 'r' 'r' 'r'];
%clr2 = ['b' 'b' 'b' 'b' 'b' 'b' 'b' 'b'];
%clr3 = ['g' 'g' 'g' 'g' 'g' 'g' 'g' 'g'];
%clr4 = ['c' 'c' 'c' 'c' 'c' 'c' 'c' 'c'];
%clr = [clr1 clr2 clr3 clr4];
%clr = ['r' 'b' 'g' 'c'];
%clr = ['r' 'b' 'g' 'm' 'c'];
%clr = [clr clr clr clr clr clr clr]; 
%clr = [clr clr clr clr];
clr = 'r-*';
for n = start:stop
    %figure(500); plot3(squeeze(Kmat(n,1:ind,1)),squeeze(Kmat(n,1:ind,2)),squeeze(Kmat(n,1:ind,3)),clr(n),'linewidth',1);
    figure(500); plot3(squeeze(Kmat(n,1:ind,1)),squeeze(Kmat(n,1:ind,2)),squeeze(Kmat(n,1:ind,3)),clr,'linewidth',2);
    hold on; axis equal; grid on; box on;
    set(gca,'cameraposition',[-1000 -2000 300]); 
    %set(gca,'xtick',[-pltmax -pltmax/2 0 pltmax/2 pltmax]); 
    %set(gca,'ytick',[-pltmax -pltmax/2 0 pltmax/2 pltmax]); 
    %set(gca,'ztick',[-pltmax -pltmax/2 0 pltmax/2 pltmax]);
    set(gca,'xtick',[-kstep*4 -kstep*3 -kstep*2 -kstep 0 kstep kstep*2 kstep*3 kstep*4]); 
    set(gca,'ytick',[-kstep*4 -kstep*3 -kstep*2 -kstep 0 kstep kstep*2 kstep*3 kstep*4]); 
    set(gca,'ztick',[-kstep*4 -kstep*3 -kstep*2 -kstep 0 kstep kstep*2 kstep*3 kstep*4]);
   axis([-kstep*5 kstep*5 -kstep*5 kstep*5 -kstep*5 kstep*5]);
end
    
%set(gca,'xtick',[-1 -0.5 0 0.5 1]); set(gca,'ytick',[-1 -0.5 0 0.5 1]); set(gca,'ztick',[-1 -0.5 0 0.5 1]);

outstyle = 0;
if outstyle == 1
    set(gcf,'units','inches');
    set(gcf,'position',[4 4 4 4]);
    set(gcf,'paperpositionmode','auto');
    set(gca,'units','inches');
    set(gca,'position',[0.75 0.5 2.5 2.5]);
    set(gca,'fontsize',10,'fontweight','bold');
end