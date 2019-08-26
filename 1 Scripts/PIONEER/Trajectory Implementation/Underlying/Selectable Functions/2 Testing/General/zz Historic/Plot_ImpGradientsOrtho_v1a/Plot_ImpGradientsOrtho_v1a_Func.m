%==================================================
% 
%==================================================

function [OUTPUT,err] = Plot_ImpGradientsOrtho_v1a_Func(PLOT,INPUT)

Status2('busy','Plot Gradients (Ortho)',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';
OUTPUT = struct();

%-----------------------------------------------------
% Get Input
%-----------------------------------------------------
N = PLOT.trajnum;
IMP = INPUT.IMP;
clear INPUT

%-----------------------------------------------------
% Get Implementation Info
%-----------------------------------------------------
clr = 'k';

if not(isfield(IMP,'G'))    
    T = IMP.samp;
    Kmat = IMP.Kmat;
    r = sqrt(Kmat(:,:,1).^2 + Kmat(:,:,2).^2 + Kmat(:,:,3).^2);
    r = mean(r,1);
    r = r/max(r);
    gamma = 42.577;
    G = SolveGradQuant_v1b(T,Kmat,gamma);
else
    if isfield(IMP,'qTscnr')
        T = IMP.qTscnr;
    else
        %test = IMP.GQNT
        if isfield(IMP.GQNT,'scnrarr')
            T = IMP.GQNT.scnrarr;
        end
    end
    G = IMP.G;
end
%G = cat(1,squeeze(G(N,:,:)),[0 0 0]);
G = squeeze(G(N,:,:));

%figure(350); hold on; plot(T,G(:,1),clr,'linewidth',1); plot([0 T(length(T))],[0 0],'k:'); xlabel('Real Time (ms)'); ylabel('x-Gradient (mT/m)');
%ylim([-300 300]);
%xlim([0 T(length(T))]);
%figure(351); hold on; plot(T,G(:,2),clr,'linewidth',1); plot([0 T(length(T))],[0 0],'k:'); xlabel('Real Time (ms)'); ylabel('y-Gradient (mT/m)');
%ylim([-300 300]);
%xlim([0 T(length(T))]);
%figure(352); hold on; plot(T,G(:,3),clr,'linewidth',1); plot([0 T(length(T))],[0 0],'k:'); xlabel('Real Time (ms)'); ylabel('z-Gradient (mT/m)');
%ylim([-300 300]);
%xlim([0 T(length(T))]);

figure(350); hold on; 
plot([0 T(length(T))],[0 0],'k:');
plot(T,G(:,3),'g');
plot(T,G(:,2),'r');
plot(T,G(:,1),'b');
ylim([-40 40]);
%xlim([0 T(length(T))]);
xlim([0 10]);
xlabel('Readout (ms)'); ylabel('Gradient (mT/m)');
OutStyle(1);

%figure(360); hold on; plot(r,G(:,1),clr,'linewidth',1); plot([0 1],[0 0],'k:'); xlabel('rel rad dim'); ylabel('x-Gradient (mT/m)');
%figure(361); hold on; plot(r,G(:,2),clr,'linewidth',1); plot([0 1],[0 0],'k:'); xlabel('rel rad dim'); ylabel('y-Gradient (mT/m)');
%figure(362); hold on; plot(r,G(:,3),clr,'linewidth',1); plot([0 1],[0 0],'k:'); xlabel('rel rad dim'); ylabel('z-Gradient (mT/m)');

Gmag = sqrt(G(:,1).^2 + G(:,2).^2 + G(:,3).^2);

figure(353); hold on; 
plot([0 T(length(T))],[0 0],'k:'); 
plot(T,Gmag,'k','linewidth',1); 
ylim([0 50]);
%xlim([0 T(length(T))]);
xlim([0 10]);
xlabel('Readout (ms)'); ylabel('Gradient Magnitude (mT/m)');
OutStyle(1);
