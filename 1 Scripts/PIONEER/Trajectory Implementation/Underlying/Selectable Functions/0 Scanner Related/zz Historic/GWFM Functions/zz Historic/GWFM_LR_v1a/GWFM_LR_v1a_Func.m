%=====================================================
% 
%=====================================================

function [GWFM,err] = GWFM_LR_v1a_Func(GWFM,INPUT)

Status2('busy','Create Gradient Waveforms',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
GQNT = INPUT.GQNT;
PROJdgn = INPUT.PROJdgn;
PROJimp = INPUT.PROJimp;
T = INPUT.T;
KSA = INPUT.KSA;
TEND = GWFM.TEND;
GCOMP = GWFM.GCOMP;
IGF = GWFM.IGF;
clear INPUT;

%---------------------------------------------
% Test
%---------------------------------------------
qTsamp = GQNT.samparr;
if ceil(qTsamp(length(qTsamp))*1000) ~= ceil(PROJdgn.tro*1000)
    error();
end

%----------------------------------------------------
% Quantize Trajectories
%----------------------------------------------------
Status2('busy','Quantize Trajectories',3);
[GQKSA] = Quantize_Projections_v2a(PROJdgn.tro,T,qTsamp,KSA);    %'spline'
GQKSA = PROJdgn.kmax*GQKSA;
GWFM.GQKSA = GQKSA;

%----------------------------------------------------
% Solve Gradient Quantization
%----------------------------------------------------
Status2('busy','Solve Gradient Quantization',3);
qTtraj = GQNT.scnrarr;
[G0] = SolveGradQuant_v1b(qTtraj,GQKSA,PROJimp.gamma);
nproj = length(G0(:,1,1));

%---------------------------------------------
% Calculate G 2nd Deriv
%---------------------------------------------
Status2('busy','Calculate Gradient 2nd Derivative',3);
m = (2:length(G0(1,:,1))-2);
cartgsteps = [G0(:,1,:) G0(:,m,:)-G0(:,m-1,:)];
cartg2drv =  [cartgsteps(:,1,:) cartgsteps(:,m,:)-cartgsteps(:,m-1,:)];
maxcartg2drv = zeros(1,nproj);
for m = 1:nproj
    maxcartg2drv(m) = max(max(cartg2drv(m,:,:)));
end
TstTrj = find(maxcartg2drv == max(maxcartg2drv));

%---------------------------------------------
% Plot
%---------------------------------------------
Status2('busy','Plot',3);
t = qTtraj(2:length(qTtraj)-2);
figure(1100); hold on; plot(t,zeros(size(t)),'k:');
plot(t,cartg2drv(TstTrj,:,1)/GQNT.gseg^2,'b-'); plot(t,cartg2drv(TstTrj,:,2)/GQNT.gseg^2,'g-'); plot(t,cartg2drv(TstTrj,:,3)/GQNT.gseg^2,'r-');
ylim([-10000 10000]);
title(['Traj',num2str(TstTrj),' (preECC)']);
ylabel('Gradient Acceleration (mT/m/ms2)','fontsize',10,'fontweight','bold');
xlabel('(ms)','fontsize',10,'fontweight','bold');

%----------------------------------------------------
% Visuals
%----------------------------------------------------
Status2('busy','Plot',3);
if strcmp(GWFM.Vis,'Yes') 
    [A,B,C] = size(G0);
    Gvis = zeros(A,B*2,C); L = zeros(1,B*2);
    for n = 1:length(qTtraj)-1
        L((n-1)*2+1) = qTtraj(n);
        L(n*2) = qTtraj(n+1);
        Gvis(:,(n-1)*2+1,:) = G0(:,n,:);
        Gvis(:,n*2,:) = G0(:,n,:);
    end
    figure(1000); hold on; plot(L,Gvis(TstTrj,:,1),'b:'); plot(L,Gvis(TstTrj,:,2),'g:'); plot(L,Gvis(TstTrj,:,3),'r:');
    plot(L,zeros(size(L)),'k:');
    title(['Traj',num2str(TstTrj),' (preECC)']);
    xlabel('Time (ms)','fontsize',10,'fontweight','bold');
    ylabel('Gradients (mT/m)','fontsize',10,'fontweight','bold');
end

%----------------------------------------------------
% Initial Gradient Fix
%----------------------------------------------------
Status2('busy','Initial Gradient Fix',3);
func = str2func([GWFM.IGFfunc,'_Func']);
INPUT.G0 = G0;
INPUT.GQNT = GQNT;
[IGF,err] = func(IGF,INPUT);
if err.flag
    return
end
G0fix = IGF.G0fix;

%----------------------------------------------------
% Visuals
%----------------------------------------------------
Status2('busy','Plot',3);
if strcmp(GWFM.Vis,'Yes') 
    [A,B,C] = size(G0fix);
    Gvis = zeros(A,B*2,C); L = zeros(1,B*2);
    for n = 1:length(qTtraj)-1
        L((n-1)*2+1) = qTtraj(n);
        L(n*2) = qTtraj(n+1);
        Gvis(:,(n-1)*2+1,:) = G0fix(:,n,:);
        Gvis(:,n*2,:) = G0fix(:,n,:);
    end
    figure(1000); hold on; plot(L,Gvis(TstTrj,:,1),'b-'); plot(L,Gvis(TstTrj,:,2),'g-'); plot(L,Gvis(TstTrj,:,3),'r-');
    plot(L,zeros(size(L)),'k:');
    title(['Traj',num2str(TstTrj),' (preECC)']);
    xlabel('Time (ms)','fontsize',10,'fontweight','bold');
    ylabel('Gradients (mT/m)','fontsize',10,'fontweight','bold');
end
    
%----------------------------------------------------
% End Trajectory
%----------------------------------------------------
Status2('busy','End Trajectory',3);
func = str2func([GWFM.TENDfunc,'_Func']);
INPUT.PROJimp = PROJimp;
INPUT.GQNT = GQNT;
INPUT.G0 = G0fix;
INPUT.GQKSA = GQKSA;               
[TEND,err] = func(TEND,INPUT);
if err.flag
    return
end
Gend = TEND.Gend;
G0wend = cat(2,G0fix,Gend);
qTend = PROJdgn.tro +(GQNT.gseg:GQNT.gseg:length(Gend(1,:,1))*GQNT.gseg);
qTwend = [qTtraj qTend];

%----------------------------------------------------
% Visuals
%----------------------------------------------------
Status2('busy','Plot',3);
if strcmp(GWFM.Vis,'Yes') 
    [A,B,C] = size(G0wend);
    Gvis = zeros(A,B*2,C); L = zeros(1,B*2);
    for n = 1:length(qTwend)-1
        L((n-1)*2+1) = qTwend(n);
        L(n*2) = qTwend(n+1);
        Gvis(:,(n-1)*2+1,:) = G0wend(:,n,:);
        Gvis(:,n*2,:) = G0wend(:,n,:);
    end
    figure(1500); hold on; plot(L,Gvis(TstTrj,:,1),'b:'); plot(L,Gvis(TstTrj,:,2),'g:'); plot(L,Gvis(TstTrj,:,3),'r:');
    plot(L,zeros(size(L)),'k:');
    title(['Traj',num2str(TstTrj),' (postComp)']);
    xlabel('Time (ms)','fontsize',10,'fontweight','bold');
    ylabel('Gradients (mT/m)','fontsize',10,'fontweight','bold');
end

%----------------------------------------------------
% Compensate Trajectory
%----------------------------------------------------
Status2('busy','Compensate Trajectory',3);
func = str2func([GWFM.GCOMPfunc,'_Func']);
INPUT.PROJimp = PROJimp;
INPUT.G0 = G0wend;
INPUT.qT = qTwend;
[GCOMP,err] = func(GCOMP,INPUT);
if err.flag
    return
end
Gcomp = GCOMP.Gcomp;
qTcomp = GCOMP.Tcomp;
GCOMP = rmfield(GCOMP,{'Gcomp','Tcomp'});
GWFM.GCOMP = GCOMP;

%----------------------------------------------------
% Visuals
%----------------------------------------------------
Status2('busy','Plot',3);
if strcmp(GWFM.Vis,'Yes') 
    [A,B,C] = size(Gcomp);
    Gvis = zeros(A,B*2,C); L = zeros(1,B*2);
    for n = 1:length(qTcomp)-1
        L((n-1)*2+1) = qTcomp(n);
        L(n*2) = qTcomp(n+1);
        Gvis(:,(n-1)*2+1,:) = Gcomp(:,n,:);
        Gvis(:,n*2,:) = Gcomp(:,n,:);
    end
    figure(1500); hold on; plot(L,Gvis(TstTrj,:,1),'b-'); plot(L,Gvis(TstTrj,:,2),'g-'); plot(L,Gvis(TstTrj,:,3),'r-');
    plot(L,zeros(size(L)),'k:');
    title(['Traj',num2str(TstTrj),' (postComp)']);
    xlabel('Time (ms)','fontsize',10,'fontweight','bold');
    ylabel('Gradients (mT/m)','fontsize',10,'fontweight','bold');
end

%---------------------------------------------
% Calculate G 2nd Deriv
%---------------------------------------------
Status2('busy','Calculate Gradient 2nd Derivative',3);
m = (2:length(Gcomp(1,:,1))-2);
cartgsteps = [Gcomp(:,1,:) Gcomp(:,m,:)-Gcomp(:,m-1,:)];
cartg2drv =  [cartgsteps(:,1,:) cartgsteps(:,m,:)-cartgsteps(:,m-1,:)];
GWFM.maxcartg2drv = (max(max(max(abs(cartg2drv(:,1:length(qTtraj)-10,:))))))/GQNT.gseg^2;
for p = 1:length(cartg2drv(1,:,1));
    maxcartg2drvT(p) = max(max(abs(cartg2drv(:,p,:))));
end

%---------------------------------------------
% Plot
%---------------------------------------------
Status2('busy','Plot',3);
t = qTcomp(2:length(qTtraj)-2);
figure(1600); hold on; plot(t,zeros(size(t)),'k:');
plot(t,cartg2drv(TstTrj,1:length(t),1)/GQNT.gseg^2,'b-'); plot(t,cartg2drv(TstTrj,1:length(t),2)/GQNT.gseg^2,'g-'); plot(t,cartg2drv(TstTrj,1:length(t),3)/GQNT.gseg^2,'r-');
ylim([-10000 10000]);
title(['Traj',num2str(TstTrj),' (postComp)']);
ylabel('Gradient Acceleration (mT/m/ms2)','fontsize',10,'fontweight','bold');
xlabel('(ms)','fontsize',10,'fontweight','bold');
figure(1601); hold on; plot(t,zeros(size(t)),'k:');
plot(t,maxcartg2drvT(1:length(t))/GQNT.gseg^2,'k-');
ylim([0 10000]);
title('Max Over All Trajs');
ylabel('Max Abs Gradient Acceleration (mT/m/ms2)','fontsize',10,'fontweight','bold');
xlabel('(ms)','fontsize',10,'fontweight','bold');

%---------------------------------------
% G0wend Chars
%---------------------------------------
GWFM.G0wendmax = max(G0wend(:));
initsteps = G0wend(:,1,:);
vecinitstep = sqrt(initsteps(:,:,1).^2 + initsteps(:,:,2).^2 + initsteps(:,:,3).^2);
GWFM.G0wendmaxvecinit = max(vecinitstep(:));
m = (2:length(qTwend)-2);
cartgsteps = G0wend(:,m,:)-G0wend(:,m-1,:);
GWFM.G0wendmaxcartstep = max(cartgsteps(:)); 
vecgsteps = sqrt(cartgsteps(:,:,1).^2 + cartgsteps(:,:,2).^2 + cartgsteps(:,:,3).^2);
vecgsteps = [vecinitstep vecgsteps];
if strcmp(GWFM.Vis,'Yes') 
    figure(5101); plot(qTcomp(1:length(qTcomp)-2),vecgsteps(1,:)/GQNT.gseg);
    ylabel('Gradient Vector Velocity (mT/m/ms2)','fontsize',10,'fontweight','bold');
    xlabel('Trajectory Time','fontsize',10,'fontweight','bold');
end
GWFM.G0wendmaxvecstep = max(vecgsteps(:));   
GWFM.G0wendmaxslew = GWFM.G0wendmaxvecstep/GQNT.gseg;

%---------------------------------------
% Gcomp Chars
%---------------------------------------
GWFM.Gcompmax = max(Gcomp(:));
initsteps = Gcomp(:,1,:);
vecinitstep = sqrt(initsteps(:,:,1).^2 + initsteps(:,:,2).^2 + initsteps(:,:,3).^2);
GWFM.Gcompmaxvecinit = max(vecinitstep(:));
m = (2:length(qTcomp)-2);
cartgsteps = Gcomp(:,m,:)-Gcomp(:,m-1,:);
GWFM.Gmaxcartstep = max(cartgsteps(:)); 
vecgsteps = sqrt(cartgsteps(:,:,1).^2 + cartgsteps(:,:,2).^2 + cartgsteps(:,:,3).^2);
vecgsteps = [vecinitstep vecgsteps];
if strcmp(GWFM.Vis,'Yes') 
    figure(5101); plot(qTcomp(1:length(qTcomp)-2),vecgsteps(1,:)/GQNT.gseg,'k');
    ylabel('Gradient Vector Velocity (mT/m/ms2)','fontsize',10,'fontweight','bold');
    xlabel('Trajectory Time','fontsize',10,'fontweight','bold');
end
GWFM.Gcompmaxvecstep = max(vecgsteps(:));   
GWFM.Gcompmaxslew = GWFM.Gcompmaxvecstep/GQNT.gseg;

%----------------------------------------------------
% Gradient Return
%----------------------------------------------------
GWFM.G0wend = G0wend;
GWFM.qTwend = qTwend;
GWFM.totqTwend = qTwend(length(qTwend));
GWFM.Gscnr = Gcomp;
GWFM.qTscnr = qTcomp;
GWFM.tgwfm = qTcomp(length(qTcomp));
GWFM.TstTrj = TstTrj;

%----------------------------------------------------
% Panel Output
%----------------------------------------------------
Panel(1,:) = {'Gmax',GWFM.Gcompmax,'Output'};
Panel(2,:) = {'Gmaxslew',GWFM.Gcompmaxslew,'Output'};
Panel(3,:) = {'Gmax2drv',GWFM.maxcartg2drv,'Output'};
Panel(4,:) = {'tgwfm',GWFM.tgwfm,'Output'};
PanelOutput = cell2struct(Panel,{'label','value','type'},2);
GWFM.PanelOutput = PanelOutput;

Status2('done','',2);
Status2('done','',3);
