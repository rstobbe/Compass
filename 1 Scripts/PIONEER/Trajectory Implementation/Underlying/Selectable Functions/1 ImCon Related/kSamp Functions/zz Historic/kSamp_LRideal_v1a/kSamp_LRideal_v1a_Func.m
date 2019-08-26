%=====================================================
%   
%=====================================================

function [KSMP,err] = kSamp_LRideal_v1a_Func(KSMP,INPUT)

Status2('busy','Sample k-Space',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
PROJdgn = INPUT.PROJdgn;
TSMP = INPUT.TSMP;
KSA = INPUT.KSA;
T = INPUT.T;

%---------------------------------------------
% Common Variables
%---------------------------------------------
sampstart = TSMP.sampstart;
dwell = TSMP.dwell;
npro = TSMP.npro;
tro = TSMP.tro;
kmax = PROJdgn.kmax;
kstep = PROJdgn.kstep;
[L,~,~] = size(KSA);

%---------------------------------------
% Average T
%---------------------------------------
aveT = mean(T,1);
if strcmp(KSMP.Vis,'Yes')
    for n = 1:L
        figure(3031); hold on;
        plot(T(n,:),'k:');
    end
    plot(aveT,'k-','linewidth',2);
    ylabel('Solution Time (ms)'); xlabel('Array Number');
end

%---------------------------------------
% Resample k-Space
%---------------------------------------
samp = (sampstart:dwell:tro);
Kmat = zeros(L,length(samp),3);
for n = 1:L
    Kmat(n,:,1) = interp1(aveT,squeeze(KSA(n,:,1))*kmax,samp,'cubic','extrap');
    Kmat(n,:,2) = interp1(aveT,squeeze(KSA(n,:,2))*kmax,samp,'cubic','extrap');
    Kmat(n,:,3) = interp1(aveT,squeeze(KSA(n,:,3))*kmax,samp,'cubic','extrap');
end
if isnan(Kmat)
    error('NaN Problem');
end
  
%---------------------------------------
% Visuals
%---------------------------------------
if strcmp(KSMP.Vis,'Yes') 
    figure(3030); hold on; 
    plot(T(1,:),KSA(1,:,1)*kmax,'b-'); plot(T(1,:),KSA(1,:,2)*kmax,'g-'); plot(T(1,:),KSA(1,:,3)*kmax,'r-');
    plot(samp,Kmat(1,:,1),'b*'); plot(samp,Kmat(1,:,2),'g*'); plot(samp,Kmat(1,:,3),'r*');
    ylabel('k-Space Value (1/m)'); xlabel('Readout (ms)');

    gamma = 42.577;
    G = SolveGradQuant_v1b(T,KSA*kmax,gamma);
    G = squeeze(G);
    figure(3041); hold on; plot(T,[G(:,1);0],'k','linewidth',1); plot([0 T(length(T))],[0 0],'k:'); xlabel('Real Time (ms)'); ylabel('x-Gradient (mT/m)');
    figure(3042); hold on; plot(T,[G(:,2);0],'k','linewidth',1); plot([0 T(length(T))],[0 0],'k:'); xlabel('Real Time (ms)'); ylabel('y-Gradient (mT/m)');
    figure(3043); hold on; plot(T,[G(:,3);0],'k','linewidth',1); plot([0 T(length(T))],[0 0],'k:'); xlabel('Real Time (ms)'); ylabel('z-Gradient (mT/m)');

    rkmag = sqrt(KSA(1,:,1).^2 + KSA(1,:,2).^2 + KSA(1,:,3).^2);
    figure(3051); hold on; plot(rkmag,[G(:,1);0],'k','linewidth',1); plot([0 1],[0 0],'k:'); xlabel('rel k'); ylabel('x-Gradient (mT/m)');
    figure(3052); hold on; plot(rkmag,[G(:,2);0],'k','linewidth',1); plot([0 1],[0 0],'k:'); xlabel('rel k'); ylabel('y-Gradient (mT/m)');
    figure(3053); hold on; plot(rkmag,[G(:,3);0],'k','linewidth',1); plot([0 1],[0 0],'k:'); xlabel('rel k'); ylabel('z-Gradient (mT/m)');
end

%---------------------------------------
% Test Max Relative Radial Sampling Step
%---------------------------------------
Rad = sqrt(Kmat(:,:,1).^2 + Kmat(:,:,2).^2 + Kmat(:,:,3).^2);
rRad = Rad/kstep;
KSMP.rRadFirstStepMean = mean(rRad(:,1));
KSMP.rRadFirstStepMax = max(rRad(:,1));
for n = 2:npro
    rRadStep(:,n) = rRad(:,n) - rRad(:,n-1);
end
KSMP.rRadStepMax = max([max(rRadStep(:)) KSMP.rRadFirstStepMax]);

%---------------------------------------
% Return Sampling Timing for Testing
%---------------------------------------
KSMP.rKmag = ((Kmat(1,:,1).^2 + Kmat(1,:,2).^2 + Kmat(1,:,3).^2).^(1/2))/kmax;
KSMP.tatr = samp;    

%----------------------------------------------------
% Return
%----------------------------------------------------
KSMP.samp = samp;
KSMP.Kmat = Kmat;

%----------------------------------------------------
% Panel
%----------------------------------------------------
if KSMP.rRadFirstStepMean > 0.35 || KSMP.rRadFirstStepMean < 0.15
    Panel(1,:) = {'rRadFirstStepMean',KSMP.rRadFirstStepMean,'OutputWarn'};
else
    Panel(1,:) = {'rRadFirstStepMean',KSMP.rRadFirstStepMean,'Output'};
end
if KSMP.rRadFirstStepMax > 0.4
    Panel(2,:) = {'rRadFirstStepMax',KSMP.rRadFirstStepMax,'OutputWarn'};
else
    Panel(2,:) = {'rRadFirstStepMax',KSMP.rRadFirstStepMax,'Output'};
end
if KSMP.rRadStepMax > 0.8
    Panel(3,:) = {'rRadStepMax',KSMP.rRadStepMax,'OutputWarn'};
else
    Panel(3,:) = {'rRadStepMax',KSMP.rRadStepMax,'Output'};
end
PanelOutput = cell2struct(Panel,{'label','value','type'},2);
KSMP.PanelOutput = PanelOutput;

Status2('done','',2);
Status2('done','',3);


    
    