%==================================================
% 
%==================================================

function [PLOT,err] = Plot_TPIDesGradients_v1a_Func(PLOT,INPUT)

Status('busy','Plot TPI Design Gradients(Ortho)');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
PROJdgn = INPUT.DES.PROJdgn;
GAMFUNC = INPUT.DES.GAMFUNC;
gamma = PLOT.gamma;
clr = 'm';
clear INPUT;

%---------------------------------------------
% Test for Design Routine
%---------------------------------------------
genfunc = 'TPI_GenProj_v3c';
if not(exist(genfunc,'file'))
    err.flag = 1;
    err.msg = 'Folder of Common TPI routines must be added to path';
    return
end

%----------------------------------------------------
% Generate Projections
%----------------------------------------------------
Status('busy','Generate Trajectories');
func = str2func(genfunc);
ImpStrct.slvno = 1000;
%ImpStrct.IV = [pi/6;pi/4];
ImpStrct.IV = [0;0];
[T,KSA,err] = func(PROJdgn,GAMFUNC,ImpStrct);
if err.flag
    return
end
T = PROJdgn.tro*T/T(end);

t = 0:0.5:T(end);
k = interp1(T,KSA(:,:,3),t);
k0 = interp1([0 T(end)],[0 1],t);

angle = (0:pi/8:15*pi/8);
h1 = figure(100); hold on;
for m = 1:length(angle)
    plot([0 1]*sin(angle(m)),[0 1]*cos(angle(m)),'k');
end
axis equal
i = 1;
for m = 1:length(angle)
    for n = 1:length(t)
        plot(k(1:n)*sin(angle(m)),k(1:n)*cos(angle(m)),'r','linewidth',4);
        plot(k0(1:n)*sin(angle(m)),k0(1:n)*cos(angle(m)),'b','linewidth',4);
        xlim([-1 1]); ylim([-1 1]);
        drawnow;

        set(gcf,'units','inches');
        set(gcf,'position',[4 4 4 3.5]);
        %set(gcf,'Color','w');                              % background color
        set(gcf,'paperpositionmode','auto');
        set(gca,'units','inches');
        set(gca,'position',[0.75 0.5 2.5 2.5]);
        set(gca,'fontsize',10,'fontweight','bold');
        
        F = getframe(h1);
        [Xt,~] = frame2im(F);
        X(:,:,:,i) = rgb2ind(Xt,[gray(128);jet(128)]);
        i = i+1;
    end
end

size(X)
imwrite(X,[gray(128);jet(128)],'Movie.gif','gif','LoopCount',inf,'DelayTime',0);    