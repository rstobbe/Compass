%==================================================
% 
%==================================================

function [SCRPTipt,SCRPTGBL,err] = Plot_IdealGradientSegments_v1a(SCRPTipt,SCRPTGBL)

errnum = 1;
err.flag = 0;
err.msg = '';

N = str2double(SCRPTipt(strcmp('TrajNum',{SCRPTipt.labelstr})).entrystr);
gamma = str2double(SCRPTipt(strcmp('Gamma',{SCRPTipt.labelstr})).entrystr);

KSA = SCRPTGBL.KSA;
T = SCRPTGBL.T;
kmax = SCRPTGBL.PROJdgn.kmax;
KSA = KSA*kmax;

Dur1 = 35;
Dur2 = 58.333;
ind1 = find(T(N,:) > Dur1,1,'first');
ind2 = find(T(N,:) > Dur2,1,'first');
T = T(N,ind1:ind2);
KSA = KSA(N,ind1:ind2,:);

G = SolveGradQuant_v1b(T,KSA,gamma);
G = squeeze(G);

figure(350); hold on; plot(T(1:length(T)-1),G(:,1),'k','linewidth',1); plot([0 T(length(T))],[0 0],'k:'); xlabel('Real Time (ms)'); ylabel('x-Gradient (mT)');
figure(351); hold on; plot(T(1:length(T)-1),G(:,2),'k','linewidth',1); plot([0 T(length(T))],[0 0],'k:'); xlabel('Real Time (ms)'); ylabel('y-Gradient (mT)');
figure(352); hold on; plot(T(1:length(T)-1),G(:,3),'k','linewidth',1); plot([0 T(length(T))],[0 0],'k:'); xlabel('Real Time (ms)'); ylabel('z-Gradient (mT)');

outstyle = 1;
if outstyle == 1
    figure(350);
    ylim([-30 30]);
    xlim([Dur1 Dur2]);
    %xlim([-10 10]);
    set(gcf,'units','inches');
    set(gcf,'position',[4 4 4 3]);
    set(gcf,'paperpositionmode','auto');
    set(gca,'units','inches');
    set(gca,'ytick',[-30 0 30]);
    set(gca,'position',[0.75 0.5 2.5 2.5]);
    set(gca,'fontsize',10,'fontweight','bold');
    set(gca,'PlotBoxAspectRatio',[1.5 1 1]);     
    %set(gca,'box','on');
    figure(351);
    ylim([-30 30]);
    xlim([Dur1 Dur2]);
    %xlim([-10 10]);
    set(gcf,'units','inches');
    set(gcf,'position',[4 4 4 3]);
    set(gcf,'paperpositionmode','auto');
    set(gca,'units','inches');
    set(gca,'position',[0.75 0.5 2.5 2.5]);
    set(gca,'fontsize',10,'fontweight','bold');
    set(gca,'PlotBoxAspectRatio',[1.5 1 1]);     
    %set(gca,'box','on');
    figure(352);
    ylim([-30 30]);
    xlim([Dur1 Dur2]);
    %xlim([-10 10]);
    set(gcf,'units','inches');
    set(gcf,'position',[4 4 4 3]);
    set(gcf,'paperpositionmode','auto');
    set(gca,'units','inches');
    set(gca,'position',[0.75 0.5 2.5 2.5]);
    set(gca,'fontsize',10,'fontweight','bold');
    set(gca,'PlotBoxAspectRatio',[1.5 1 1]);     
    %set(gca,'box','on');
end

slrcalc = 0;
if slrcalc == 1
    m = (2:length(T));
    Tsteps = T(m)-T(m-1);
    Tsteps = [Tsteps;Tsteps;Tsteps]';
    m = (2:length(T)-1);
    Gsteps = G(m,:)-G(m-1,:);
    Gsteps = [G(1,:);Gsteps];

    SLR = Gsteps./Tsteps;

    figure(360); hold on; plot(T,[SLR(:,1);0],'b','linewidth',2); xlabel('Real Time (ms)'); ylabel('(mT/m/ms)'); title('x k-space');
    figure(361); hold on; plot(T,[SLR(:,2);0],'b','linewidth',2); xlabel('Real Time (ms)'); ylabel('(mT/m/ms)'); title('y k-space');
    figure(362); hold on; plot(T,[SLR(:,3);0],'b','linewidth',2); xlabel('Real Time (ms)'); ylabel('(mT/m/ms)'); title('z k-space');

    magSLR = sqrt(SLR(:,1).^2 + SLR(:,2).^2 + SLR(:,3).^2);
    figure(370); hold on; plot(T,[magSLR;0],'b','linewidth',2); xlabel('Real Time (ms)'); ylabel('(mT/m/ms)'); title('x k-space');
end