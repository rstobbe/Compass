%==================================================
% 
%==================================================

function [OUTPUT,err] = Plot_ImpGradientsDrv1_v1a_Func(INPUT)

Status('busy','Plot Gradients from implementation');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';
OUTPUT = struct();

%-----------------------------------------------------
% Get Input
%-----------------------------------------------------
PLOT = INPUT.PLOT;
N = PLOT.trajnum;
clr = 'k';

calcvelfunc = 'CalcVel_v2a';
calcaccfunc = 'CalcAcc_v2a';
if not(exist(calcaccfunc,'file'))
    err.flag = 1;
    err.msg = 'Folder of Common LR routines must be added to path';
    return
end
calcvelfunc = str2func(calcvelfunc);
calcaccfunc = str2func(calcaccfunc);

%-----------------------------------------------------
% Get Implementation Info
%-----------------------------------------------------
IMP = INPUT.IMP;
if not(isfield(IMP,'G'))    
    T = IMP.T;
    kArr = squeeze(IMP.KSA)*IMP.DES.PROJdgn.kmax;
    [vel,Tvel0] = calcvelfunc(kArr,T);
    [acc,Tacc0] = calcaccfunc(vel,Tvel0);
    magacc = sqrt(acc(:,1).^2 + acc(:,2).^2 + acc(:,3).^2);
    vecg1drv = magacc/42.577;
    t = Tacc0;
else  
    T = IMP.qTscnr;
    G = IMP.G;
    G = cat(1,squeeze(G(N,:,:)),[0 0 0]);
    gseg = IMP.GQNT.gseg;   
    m = (2:length(G(:,1))-2);
    cartg1drv = cat(1,G(1,:),G(m,:)-G(m-1,:))/gseg;
    %cartg2drv =  [cartg1drv(1,:) cartg1drv(m,:)-cartg1drv(m-1,:)]/gseg;
    vecg1drv = sqrt(cartg1drv(:,1).^2 + cartg1drv(:,2).^2 + cartg1drv(:,3).^2);
    %vecg2drv = sqrt(cartg2drv(:,1).^2 + cartg2drv(:,2).^2 + cartg2drv(:,3).^2);  
    t = T(2:length(T)-1);
end

%---------------------------------------------
% Plot Gradient Derivatives
%---------------------------------------------
figure(450); hold on; 
plot(t,zeros(size(t)),'k:');
plot(t,vecg1drv,'k','linewidth',1);
ylim([0 300]);
xlim([0 10]);
xlabel('Readout (ms)'); ylabel('Gradient Rate-of-Change(mT/m/ms)');
OutStyle(1);

