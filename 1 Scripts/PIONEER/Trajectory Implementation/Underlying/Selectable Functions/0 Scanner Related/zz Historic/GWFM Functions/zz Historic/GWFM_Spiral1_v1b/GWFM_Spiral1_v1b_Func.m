%=====================================================
% 
%=====================================================

function [GWFM,err] = GWFM_Spiral1_v1b_Func(GWFM,INPUT)

Status2('busy','Create Gradient Waveforms',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
PSMP = INPUT.PSMP;
GQNT = INPUT.GQNT;
PROJdgn = INPUT.PROJdgn;
PROJimp = INPUT.PROJimp;
T = INPUT.T;
KSA = INPUT.KSA;
TEND = GWFM.TEND;
GCOMP = GWFM.GCOMP;
GBLD = GWFM.GBLD;
GF = GWFM.GF;
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
% Calculate Derivatives
%---------------------------------------------
if strcmp(GWFM.TestTrajOnly,'Yes') 
    Status2('busy','Calculate Gradient Derivatives',3);
    m = (2:length(G0(1,:,1))-2);
    cartgsteps = [G0(:,1,:) G0(:,m,:)-G0(:,m-1,:)];
    cartg2drv =  [cartgsteps(:,1,:) cartgsteps(:,m,:)-cartgsteps(:,m-1,:)];
    vecgsteps = sqrt(cartgsteps(:,:,1).^2 + cartgsteps(:,:,2).^2);
    vecg2drv = sqrt(cartg2drv(:,:,1).^2 + cartg2drv(:,:,2).^2);
end

%---------------------------------------------
% Plot Gradient Speed
%---------------------------------------------
if strcmp(GWFM.TestTrajOnly,'Yes') 
    t = qTtraj(2:length(qTtraj)-2);
    figure(1000); hold on; plot(t,zeros(size(t)),'k:');
    plot(t,vecgsteps(1,:)/GQNT.gseg,'b-');
    if length(vecgsteps(:,1)) > 1
        plot(t,vecgsteps(2,:)/GQNT.gseg,'r-');
    end
    ylim([0 200]);
    title('Gradient Speed Test (PreComp)');
    ylabel('Gradient Speed (mT/m/ms)','fontsize',10,'fontweight','bold');
    xlabel('(ms)','fontsize',10,'fontweight','bold');
end

%---------------------------------------------
% Plot Gradient Acceleration
%---------------------------------------------
if strcmp(GWFM.TestTrajOnly,'Yes') 
    t = qTtraj(2:length(qTtraj)-2);
    figure(1001); hold on; plot(t,zeros(size(t)),'k:');
    plot(t,vecg2drv(1,:)/GQNT.gseg^2,'b-');
    if length(vecg2drv(:,1)) > 1
        plot(t,vecg2drv(2,:)/GQNT.gseg^2,'r-');
    end
    ylim([0 10000]);
    title('Gradient Acceleration Test (PreComp)');
    ylabel('Gradient Acceleration (mT/m/ms2)','fontsize',10,'fontweight','bold');
    xlabel('(ms)','fontsize',10,'fontweight','bold');
end

%----------------------------------------------------
% Visuals
%----------------------------------------------------
TstTrj = 1;
if strcmp(GWFM.Vis,'Yes') && strcmp(GWFM.TestTrajOnly,'Yes') 
    [A,B,C] = size(G0);
    Gvis = zeros(A,B*2,C); L = zeros(1,B*2);
    for n = 1:length(qTtraj)-1
        L((n-1)*2+1) = qTtraj(n);
        L(n*2) = qTtraj(n+1);
        Gvis(:,(n-1)*2+1,:) = G0(:,n,:);
        Gvis(:,n*2,:) = G0(:,n,:);
    end
    figure(1100); hold on; plot(L,zeros(size(L)),'k:');
    plot(L,Gvis(TstTrj,:,1),'b:'); plot(L,Gvis(TstTrj,:,2),'g:');
    title(['Traj ',num2str(TstTrj),' (preComp)']);
    xlabel('(ms)','fontsize',10,'fontweight','bold');
    ylabel('Gradients (mT/m)','fontsize',10,'fontweight','bold');
end

%----------------------------------------------------
% Initial Gradient Fix
%----------------------------------------------------
Status2('busy','Initial Gradient Fix',3);
func = str2func([GWFM.GFfunc,'_Func']);
INPUT.G0 = G0;
INPUT.GQNT = GQNT;
[GF,err] = func(GF,INPUT);
if err.flag
    return
end
G0fix = GF.G0fix;
GWFM.G0max = max(G0fix(:));

%----------------------------------------------------
% Visuals
%----------------------------------------------------
if strcmp(GWFM.Vis,'Yes') && strcmp(GWFM.TestTrajOnly,'Yes') 
    [A,B,C] = size(G0fix);
    Gvis = zeros(A,B*2,C); L = zeros(1,B*2);
    for n = 1:length(qTtraj)-1
        L((n-1)*2+1) = qTtraj(n);
        L(n*2) = qTtraj(n+1);
        Gvis(:,(n-1)*2+1,:) = G0fix(:,n,:);
        Gvis(:,n*2,:) = G0fix(:,n,:);
    end
    figure(1100); hold on; 
    plot(L,Gvis(TstTrj,:,1),'b-'); plot(L,Gvis(TstTrj,:,2),'g-');
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
if strcmp(GWFM.Vis,'Yes') 
    [A,B,C] = size(G0wend);
    Gvis = zeros(A,B*2,C); L = zeros(1,B*2);
    for n = 1:length(qTwend)-1
        L((n-1)*2+1) = qTwend(n);
        L(n*2) = qTwend(n+1);
        Gvis(:,(n-1)*2+1,:) = G0wend(:,n,:);
        Gvis(:,n*2,:) = G0wend(:,n,:);
    end
    figure(1101); hold on; plot(L,zeros(size(L)),'k:');
    plot(L,Gvis(TstTrj,:,1),'b:'); plot(L,Gvis(TstTrj,:,2),'g:');
    title(['Traj',num2str(TstTrj),' (preComp)']);
    xlabel('(ms)','fontsize',10,'fontweight','bold');
    ylabel('Gradients (mT/m)','fontsize',10,'fontweight','bold');
end

%----------------------------------------------------
% Calculate Relevant Gradient Parameters in Magnet
%----------------------------------------------------
Status2('busy','Calculate Relevant Gradient Parameters in Magnet',3);
m = (2:length(qTwend)-2);
cartgsteps = [G0wend(:,1,:) G0wend(:,m,:)-G0wend(:,m-1,:)];
vecgsteps = sqrt(cartgsteps(:,:,1).^2 + cartgsteps(:,:,2).^2);
GWFM.G0wendmax = max(G0wend(:));
GWFM.G0wendmaxslew = max(vecgsteps(:))/GQNT.gseg; 
if strcmp(GWFM.Vis,'Yes') 
    figure(1000); hold on;
    for p = 1:length(vecgsteps(1,:));
        maxvecgsteps(p) = max(vecgsteps(:,p));
    end
    plot(qTwend(1:length(qTwend)-2),maxvecgsteps/GQNT.gseg,'k:');
    title('Maximum Gradient Speed');
    ylabel('Gradient Speed (mT/m/ms)','fontsize',10,'fontweight','bold');
    xlabel('(ms)','fontsize',10,'fontweight','bold');
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
if strcmp(GWFM.Vis,'Yes') 
    [A,B,C] = size(Gcomp);
    Gvis = zeros(A,B*2,C); L = zeros(1,B*2);
    for n = 1:length(qTcomp)-1
        L((n-1)*2+1) = qTcomp(n);
        L(n*2) = qTcomp(n+1);
        Gvis(:,(n-1)*2+1,:) = Gcomp(:,n,:);
        Gvis(:,n*2,:) = Gcomp(:,n,:);
    end
    figure(1101); hold on; 
    plot(L,Gvis(TstTrj,:,1),'b-'); plot(L,Gvis(TstTrj,:,2),'g-'); plot(L,Gvis(TstTrj,:,3),'r-');
    title(['Traj',num2str(TstTrj),' (postComp)']);
    xlabel('(ms)','fontsize',10,'fontweight','bold');
    ylabel('Gradients (mT/m)','fontsize',10,'fontweight','bold');
end

%----------------------------------------------------
% Calculate Relevant Gradient Amplifier Parameters
%----------------------------------------------------
Status2('busy','Calculate Relevant Gradient Amplifier Parameters',3);
m = (2:length(qTcomp)-2);
cartgsteps = [Gcomp(:,1,:) Gcomp(:,m,:)-Gcomp(:,m-1,:)];
cartg2drv =  [cartgsteps(:,1,:) cartgsteps(:,m,:)-cartgsteps(:,m-1,:)];
GWFM.Gcompmax = max(Gcomp(:));
GWFM.Gcompmaxcartslew = max(abs(cartgsteps(:)))/GQNT.gseg; 
GWFM.Gcompmaxcart2drv = (max(max(max(abs(cartg2drv(:,1:length(qTtraj)-10,:))))))/GQNT.gseg^2;
if strcmp(GWFM.Vis,'Yes') 
    t = qTcomp(2:length(qTcomp)-2);
    figure(1000); hold on; plot(t,zeros(size(t)),'k:');    
    for p = 1:length(cartgsteps(1,:,1));
        maxcartgsteps(p) = max(max(abs(cartgsteps(:,p,:))));
    end
    title('Max Gradient Speed');
    ylabel('Gradient Speed (mT/m/ms)','fontsize',10,'fontweight','bold');
    xlabel('(ms)','fontsize',10,'fontweight','bold');    
    plot(qTcomp(1:length(qTcomp)-2),maxcartgsteps/GQNT.gseg,'k-');
    figure(1001); hold on; plot(t,zeros(size(t)),'k:');
    for p = 1:length(cartg2drv(1,:,1));
        maxcartg2drvT(p) = max(max(abs(cartg2drv(:,p,:))));
    end
    plot(qTcomp(1:length(qTtraj)-10),maxcartg2drvT(1:length(qTtraj)-10)/GQNT.gseg^2,'k-');
    title('Max Gradient Acceleration');
    ylabel('Gradient Acceleration (mT/m/ms2)','fontsize',10,'fontweight','bold');
    xlabel('(ms)','fontsize',10,'fontweight','bold');    
end

%----------------------------------------------------
% Build Trajectory
%----------------------------------------------------
if not(strcmp(GWFM.TestTrajOnly,'Yes')) 
    Status2('busy','Build Full Gradient Set',3);
    func = str2func([GWFM.GBLDfunc,'_Func']);
    INPUT.PSMP = PSMP;
    INPUT.G0 = G0wend;
    [GBLD,err] = func(GBLD,INPUT);
    if err.flag
        return
    end
    Grecon = GBLD.Gout;
    GBLD = rmfield(GBLD,{'Gout'});
    GWFM.GBLD = GBLD;
else
    Grecon = G0wend;
end

%----------------------------------------------------
% Gradient Return
%----------------------------------------------------
GWFM.totqTwend = qTwend(length(qTwend));
GWFM.Gscnr = Gcomp;
GWFM.qTscnr = qTcomp;
GWFM.Grecon = Grecon;
GWFM.qTrecon = qTwend;
GWFM.tgwfm = qTcomp(length(qTcomp));
GWFM.TstTrj = TstTrj;

%----------------------------------------------------
% Panel Output
%----------------------------------------------------
Panel(1,:) = {'Gmax (amp)',GWFM.Gcompmax,'Output'};
Panel(2,:) = {'GmaxChanSlew (amp)',GWFM.Gcompmaxcartslew,'Output'};
Panel(3,:) = {'GmaxChan2drv (amp)',GWFM.Gcompmaxcart2drv,'Output'};
Panel(4,:) = {'Gmax (mag)',GWFM.G0wendmax,'Output'};
Panel(5,:) = {'GmaxVecSlew (mag)',GWFM.G0wendmaxslew,'Output'};
Panel(6,:) = {'tgwfm',GWFM.tgwfm,'Output'};
PanelOutput = cell2struct(Panel,{'label','value','type'},2);
GWFM.PanelOutput = PanelOutput;

Status2('done','',2);
Status2('done','',3);
