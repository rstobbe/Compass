%==================================================
% 
%==================================================

function [PLOT,err] = Plot_ImpkSpace3D_v1c_Func(PLOT,INPUT)

Status('busy','Plot 3D Trajectories from Implementation');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%-----------------------------------------------------
% Get Input
%-----------------------------------------------------
IMP = INPUT.IMP;
clear INPUT;

%-----------------------------------------------------
% Plot Specifics
%-----------------------------------------------------
ind = strfind(PLOT.trajnum,':');
start = str2double(PLOT.trajnum(1:ind(1)-1));
step = str2double(PLOT.trajnum(ind(1)+1:ind(2)-1));
stop = str2double(PLOT.trajnum(ind(2)+1:end));
relrad = PLOT.relrad;

%-----------------------------------------------------
% Plot Data
%-----------------------------------------------------
if not(isfield(IMP,'impPROJdgn'))
    PROJdgn = IMP.PROJdgn;
else
    PROJdgn = IMP.impPROJdgn;
end
kmax = PROJdgn.kmax;
kstep = PROJdgn.kstep;
if stop > length(IMP.Kmat(:,1,1))
    err.flag = 1;
    err.msg = 'TrajNum too large';
    return
end

%---------------------------------------------
% Plot What
%---------------------------------------------
if strcmp(PLOT.output,'Mat')
    Kmat = IMP.Kmat;
elseif strcmp(PLOT.output,'KSA')
    Kmat = IMP.KSA*kmax;
elseif strcmp(PLOT.output,'GQKSA')
    Kmat = IMP.GQKSA;
end

%---------------------------------------------
% Plot Lenth
%---------------------------------------------
rrad = ((Kmat(1,:,1).^2 + Kmat(1,:,2).^2 + Kmat(1,:,3).^2).^(0.5))/kmax;
ind1 = 1;
ind2 = find(rrad >= relrad,1,'first');
if isempty(ind2)
    ind2 = length(rrad);
end

%---------------------------------------------
% Plot 
%---------------------------------------------
figure(500); hold on;
for n = start:step:stop
    if strcmp(PLOT.type,'AbsMax')
        pltmax = 10*ceil((relrad*kmax)/10);
        plot3(squeeze(Kmat(n,ind1:ind2,1)),squeeze(Kmat(n,ind1:ind2,2)),squeeze(Kmat(n,ind1:ind2,3)));
    elseif strcmp(PLOT.type,'RelMax')
        pltmax = relrad;
        plot3(squeeze(Kmat(n,ind1:ind2,1))/kmax,squeeze(Kmat(n,ind1:ind2,2))/kmax,squeeze(Kmat(n,ind1:ind2,3))/kmax);
    elseif strcmp(PLOT.type,'MatSteps')
        pltmax = ceil(relrad*kmax/kstep*0.5)*2;
        plot3(squeeze(Kmat(n,ind1:ind2,1))/kstep,squeeze(Kmat(n,ind1:ind2,2))/kstep,squeeze(Kmat(n,ind1:ind2,3))/kstep);
    end
end

hold on; axis equal; grid on; 
set(gca,'cameraposition',[-1000 -2000 300]); 
%set(gca,'xtick',[-pltmax -pltmax/2 0 pltmax/2 pltmax]); 
%set(gca,'ytick',[-pltmax -pltmax/2 0 pltmax/2 pltmax]); 
%set(gca,'ztick',[-pltmax -pltmax/2 0 pltmax/2 pltmax]);
axis([-pltmax pltmax -pltmax pltmax -pltmax pltmax]);
box off;

outstyle = 0;
if outstyle == 1
    set(gcf,'units','inches');
    set(gcf,'position',[4 4 4 4]);
    set(gcf,'paperpositionmode','auto');
    set(gca,'units','inches');
    set(gca,'position',[0.75 0.5 2.5 2.5]);
    set(gca,'fontsize',10,'fontweight','bold');
end

Status('done','');
Status2('done','',2);
Status2('done','',3);
