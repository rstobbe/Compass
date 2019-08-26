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
ImpStrct.IV = [pi/6;pi/4];
%ImpStrct.IV = [0;0];
[T,KSA,err] = func(PROJdgn,GAMFUNC,ImpStrct);
if err.flag
    return
end
T = PROJdgn.tro*T/T(end);

%---------------------------------------------
% Plot
%---------------------------------------------
kmax = PROJdgn.kmax;
kmat = KSA*kmax;
G = SolveGradQuant_v1b(T,kmat,gamma);
G = squeeze(G);

%figure(350); hold on; plot(T,[G(:,1);0],clr,'linewidth',1); plot([0 T(length(T))],[0 0],'k:'); xlabel('Real Time (ms)'); ylabel('x-Gradient (mT/m)');
%figure(351); hold on; plot(T,[G(:,2);0],clr,'linewidth',1); plot([0 T(length(T))],[0 0],'k:'); xlabel('Real Time (ms)'); ylabel('y-Gradient (mT/m)');
%figure(352); hold on; plot(T,[G(:,3);0],clr,'linewidth',1); plot([0 T(length(T))],[0 0],'k:'); xlabel('Real Time (ms)'); ylabel('z-Gradient (mT/m)');

Gvis = []; L = [];
for n = 1:length(T)-1
    L = [L [T(n) T(n+1)]];
    Gvis = [Gvis;[G(n,:);G(n,:)]];
end

figure(350); hold on; 
plot([0 T(length(T))],[0 0],'k:'); 
plot(L,Gvis(:,3),'g','linewidth',1); 
plot(L,Gvis(:,2),'r','linewidth',1); 
plot(L,Gvis(:,1),'b','linewidth',1); 
xlabel('Readout (ms)'); 
ylabel('Gradient (mT/m)');
OutStyle(1);

Gmag = sqrt(Gvis(:,1).^2 + Gvis(:,2).^2 + Gvis(:,3).^2);

figure(353); hold on; plot([0 T(length(T))],[0 0],'k:'); 
plot(L,Gmag,clr,'linewidth',1); 
xlabel('Real Time (ms)'); 
ylabel('Gradient Mag');