%=========================================================
% (v1a)
%   - 
%=========================================================

function [SCRPTipt,SCRPTGBL,err] = Plot_TPIkSpace2Dproj_v1a(SCRPTipt,SCRPTGBL)

Status('busy','Plot Trajectories');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Implementation
%---------------------------------------------
global TOTALGBL
val = get(findobj('tag','totalgbl'),'value');
if isempty(val) || val == 0
    err.flag = 1;
    err.msg = 'No Implementation in Global Memory';
    return  
end
IMP = TOTALGBL{2,val};

%---------------------------------------------
% Get Input
%---------------------------------------------
cones = str2double(SCRPTGBL.CurrentTree.Cones);
clr = SCRPTGBL.CurrentTree.Clr;

%---------------------------------------------
% Proj 2Dprojection
%---------------------------------------------
projindx = IMP.PSMP.PCD.projindx;

Kmat = IMP.Kmat(projindx{cones},:,:);
kstep = IMP.PROJdgn.kstep;
kmax = IMP.PROJdgn.kmax;
displim = 6;

figure(10000); hold on;
for n = 1:length(Kmat(:,1,1))
    plot(squeeze(Kmat(n,:,1)),squeeze(Kmat(n,:,2)),clr);
end
set(gca,'XTick',(-kstep*displim:kstep:kstep*displim));
set(gca,'YTick',(-kstep*displim:kstep:kstep*displim));
xlim([-kstep*displim,kstep*displim]);
ylim([-kstep*displim,kstep*displim]);
grid on;
drawnow;

figure(10001); hold on;
for n = 1:length(Kmat(:,1,1))
    plot(squeeze(Kmat(n,:,2)),squeeze(Kmat(n,:,3)),clr);
end
set(gca,'XTick',(-kstep*displim:kstep:kstep*displim));
set(gca,'YTick',(-kstep*displim:kstep:kstep*displim));
%xlim([-kstep*displim,kstep*displim]);
ylim([-kstep,kstep]);
grid on;
drawnow;

outstyle = 0;
if outstyle == 1
    set(gcf,'units','inches');
    set(gcf,'position',[4 4 4 4]);
    set(gcf,'paperpositionmode','auto');
    set(gca,'units','inches');
    set(gca,'position',[0.75 0.5 2.5 2.5]);
    set(gca,'fontsize',10,'fontweight','bold');
end