%==================================================
% 
%==================================================

function [PLOT,err] = Plot_ImpTrajMovie_v1a_Func(PLOT,INPUT)

Status('busy','Plot Trajectory Movie');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
IMP = INPUT.IMP;
relrad = PLOT.relrad;
clear INPUT;

%---------------------------------------------
% Relative Radius and Type
%---------------------------------------------
Kmat = IMP.Kmat;
kmax = IMP.PROJdgn.kmax;
kstep = IMP.PROJdgn.kstep;
nproj = IMP.PROJimp.nproj;

rrad = ((Kmat(1,:,1).^2 + Kmat(1,:,2).^2 + Kmat(1,:,3).^2).^(0.5))/kmax;
ind1 = 1;
ind2 = find(rrad >= relrad,1,'first');
if relrad == 1
    ind2 = length(rrad);
end

if strcmp(PLOT.type,'AbsMax')
    pltmax = 100*ceil((relrad*kmax)/100);
elseif strcmp(PLOT.type,'RelMax')
    pltmax = relrad;
    Kmat = Kmat/kmax;
elseif strcmp(PLOT.type,'MatSteps')
    pltmax = ceil(relrad*kmax/kstep*0.5)*2;
    Kmat = Kmat/kstep;
end

%---------------------------------------------
% Plot
%---------------------------------------------
m = 1;
for n = 1:3:nproj
    h1 = figure(500);
    hold on; axis equal; grid on; 
    plot3(squeeze(Kmat(n,ind1:ind2,1)),squeeze(Kmat(n,ind1:ind2,2)),squeeze(Kmat(n,ind1:ind2,3)),'k');

    set(gca,'cameraposition',[-1000 -2000 300]); 
    set(gca,'xtick',[-pltmax -pltmax/2 0 pltmax/2 pltmax]); 
    set(gca,'ytick',[-pltmax -pltmax/2 0 pltmax/2 pltmax]); 
    set(gca,'ztick',[-pltmax -pltmax/2 0 pltmax/2 pltmax]);
    axis([-pltmax pltmax -pltmax pltmax -pltmax pltmax]);
    box off;

    outstyle = 1;
    if outstyle == 1
        set(gcf,'units','inches');
        set(gcf,'position',[4 4 4 3.5]);
        %set(gcf,'Color','w');                              % background color
        set(gcf,'paperpositionmode','auto');
        set(gca,'units','inches');
        set(gca,'position',[0.75 0.5 2.5 2.5]);
        set(gca,'fontsize',10,'fontweight','bold');
    end 

    F = getframe(h1);
    [Xt,~] = frame2im(F);
    X(:,:,:,m) = rgb2ind(Xt,[gray(128);jet(128)]);
    m = m+1;
    clf(h1);
end

size(X)
imwrite(X,[gray(128);jet(128)],'ImpTrajMovie.gif','gif','LoopCount',inf,'DelayTime',0);    



