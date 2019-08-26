%=====================================================
% 
%=====================================================

function [GWFM,err] = GWFM_GSRA_v1e_Func(GWFM,INPUT)

Status2('busy','Create Gradient Waveforms',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
SYS = INPUT.SYS;
GQNT = INPUT.GQNT;
PROJdgn = INPUT.PROJdgn;
PROJimp = INPUT.PROJimp;
T = INPUT.T;
KSA = INPUT.KSA;
GSRA = GWFM.GSRA;

%---------------------------------------------
% Test
%---------------------------------------------
qTsamp = GQNT.samparr;
if round(qTsamp(length(qTsamp))*10000) ~= round(PROJdgn.tro*10000)
    round(qTsamp(length(qTsamp))*10000)
    round(PROJdgn.tro*10000)
    error();
end

%----------------------------------------------------
% Quantize Trajectories
%----------------------------------------------------
Status('busy','Quantize Trajectories');
[GQKSA] = Quantize_Projections_v1b(PROJdgn.tro,T,qTsamp,KSA);
GQKSA = PROJdgn.kmax*GQKSA;
GWFM.GQKSA = GQKSA;

%----------------------------------------------------
% Solve Gradient Quantization
%----------------------------------------------------
Status('busy','Solve Gradient Quantization');
qTscnr = GQNT.scnrarr;
[G0] = SolveGradQuant_v1b(qTscnr,GQKSA,PROJimp.gamma);

%----------------------------------------------------
% Visuals
%----------------------------------------------------
GVis = 'On';
if strcmp(GVis,'On') 
    nproj = length(G0(:,1,1));
    Gvis = []; L = [];
    for n = 1:length(qTscnr)-1
        L = [L [qTscnr(n) qTscnr(n+1)]];
        Gvis = [Gvis [G0(:,n,:) G0(:,n,:)]];
    end
    figure(1000); hold on; plot(L,Gvis(1,:,1),'b:'); plot(L,Gvis(1,:,2),'g:'); plot(L,Gvis(1,:,3),'r:'); xlim([0 max(L)]);
    title('Traj1'); 
    xlabel('Time (ms)','fontsize',10,'fontweight','bold');
    ylabel('Gradients (mT/m)','fontsize',10,'fontweight','bold');
    figure(1001); hold on; plot(L,Gvis(round(nproj/4),:,1),'b:'); plot(L,Gvis(round(nproj/4),:,2),'g:'); plot(L,Gvis(round(nproj/4),:,3),'r:'); xlim([0 max(L)]);
    title(['Traj',num2str(round(nproj/4))]);
    xlabel('Time (ms)','fontsize',10,'fontweight','bold');
    ylabel('Gradients (mT/m)','fontsize',10,'fontweight','bold');
    figure(1002); hold on; plot(L,Gvis(nproj-1,:,1),'b:'); plot(L,Gvis(nproj-1,:,2),'g:'); plot(L,Gvis(nproj-1,:,3),'r:'); xlim([0 max(L)]); 
    title(['Traj',num2str(nproj-1)]);
    xlabel('Time (ms)','fontsize',10,'fontweight','bold');
    ylabel('Gradients (mT/m)','fontsize',10,'fontweight','bold');
    %figure(999); hold on; plot(L,Gvis(196,:,1),'b:'); plot(L,Gvis(196,:,2),'g:'); plot(L,Gvis(196,:,3),'r:'); xlim([0 max(L)]);
    %title('Traj196'); 
    %xlabel('Time (ms)','fontsize',10,'fontweight','bold');
    %ylabel('Gradients (mT/m)','fontsize',10,'fontweight','bold');
end

%----------------------------------------------------
% Compensate for Step Response
%----------------------------------------------------
Status2('busy','Compensate for Step Response',2);
func = str2func([GWFM.SRAfunc,'_Func']);
INPUT.PROJimp = PROJimp;
INPUT.GQNT = GQNT;
INPUT.G = G0;
[GSRA,err] = func(GSRA,INPUT);
if err.flag
    return
end
Gaccom = GSRA.Gaccom;
GSRA = rmfield(GSRA,{'Gaccom'});
if isfield(GSRA,'SR')
    GSRA = rmfield(GSRA,{'SR'});
end
if isfield(GSRA,'SRiseg')
    GSRA = rmfield(GSRA,{'SRiseg'});
end
GWFM.GSRA = GSRA;

%----------------------------------------------------
% Zero Gradients
%----------------------------------------------------
Status('busy','Zero Gradients');
[i,j,k] = size(Gaccom);
zGaccom = zeros([i,j+1,k]);
zGaccom(:,1:j,:) = Gaccom;
qTscnr = [qTscnr qTscnr(length(qTscnr))+GQNT.twseg];
GWFM.qTscnr = qTscnr;
GWFM.G = zGaccom;
GWFM.tgwfm = qTscnr(length(qTscnr));

%----------------------------------------------------
% Visuals
%----------------------------------------------------
GVis = 'On';
if strcmp(GVis,'On') 
    GvisA = []; LA = [];
    for n = 1:length(qTscnr)-1
        LA = [LA [qTscnr(n) qTscnr(n+1)]];
        GvisA = [GvisA [GWFM.G(:,n,:) GWFM.G(:,n,:)]];
    end
    figure(1000); hold on; plot(LA,GvisA(1,:,1),'b-','linewidth',2); plot(LA,GvisA(1,:,2),'g-','linewidth',2); plot(LA,GvisA(1,:,3),'r-','linewidth',2);
    figure(1001); hold on; plot(LA,GvisA(round(nproj/4),:,1),'b-','linewidth',2); plot(LA,GvisA(round(nproj/4),:,2),'g-','linewidth',2); plot(LA,GvisA(round(nproj/4),:,3),'r-','linewidth',2); 
    figure(1002); hold on; plot(LA,GvisA(nproj-1,:,1),'b-','linewidth',2); plot(LA,GvisA(nproj-1,:,2),'g-','linewidth',2); plot(LA,GvisA(nproj-1,:,3),'r-','linewidth',2);
end

%----------------------------------------------------
% Gradient Words
%----------------------------------------------------
GWFM.gwpproj = length(qTscnr)-1;
GWFM.totgw = (GWFM.gwpproj+SYS.extrawords)*PROJimp.nproj;              % (Seems like 8 words per proj for system overhead)
if strcmp(SYS.sym,'PosNeg');
    GWFM.totgw = GWFM.totgw/2;
end

%---------------------------------------
% Relative SRA
%---------------------------------------
nproj = length(G0(:,1,1));
zG0 = cat(2,G0,zeros(nproj,1,3));
magG0 = (zG0(:,:,1).^2 + zG0(:,:,2).^2 + zG0(:,:,3).^2).^(0.5);
magG = (GWFM.G(:,:,1).^2 + GWFM.G(:,:,2).^2 + GWFM.G(:,:,3).^2).^(0.5);
GWFM.absGSRA_maxI = max(magG(:,1) - magG0(:,1));
GWFM.rGSRA_maxI = max(magG(:,1)./magG0(:,1));
GWFM.rGSRA_maxTot = max(magG(:)./magG0(:));

%---------------------------------------
% Test Overshoot of Initial Segment
%---------------------------------------
kiseg = (GQKSA(1,2,1).^2 + GQKSA(1,2,2).^2 + GQKSA(1,2,3).^2).^(0.5);
kovrshoot = PROJimp.gamma*(GQNT.twseg*GWFM.absGSRA_maxI)/4;
GWFM.rIovershoot = (kiseg + kovrshoot)/kiseg;

%---------------------------------------
% Max Gradient Steps
%---------------------------------------
GWFM.Gmax = max(GWFM.G(:));
initsteps = GWFM.G(:,1,:);
GWFM.Gmaxinit = max(initsteps(:));
m = (2:length(qTscnr)-2);
twsteps = GWFM.G(:,m,:)-GWFM.G(:,m-1,:);
GWFM.Gmaxtwstep = max(twsteps(:)); 
%test = squeeze(max(twsteps,[],1));
%figure(110); hold on;
%plot(test(:,1));
%plot(test(:,2));
%plot(test(:,3));
if not(isempty(twsteps))
    for n = 1:nproj
        MaxN(n) = max(max(twsteps(n,:,:)));
    end
    bigstepcone = find(MaxN == max(MaxN));
else
    bigstepcone = 2;
end
figure(1003); hold on; plot(L,Gvis(bigstepcone,:,1),'b:'); plot(L,Gvis(bigstepcone,:,2),'g:'); plot(L,Gvis(bigstepcone,:,3),'r:'); xlim([0 max(L)]);
title(['Traj',num2str(bigstepcone),' (bigstepcone)']); 
xlabel('Time (ms)','fontsize',10,'fontweight','bold');
ylabel('Gradients (mT/m)','fontsize',10,'fontweight','bold');
figure(1003); hold on; plot(LA,GvisA(bigstepcone,:,1),'b-','linewidth',2); plot(LA,GvisA(bigstepcone,:,2),'g-','linewidth',2); plot(LA,GvisA(bigstepcone,:,3),'r-','linewidth',2);
GWFM.bigstepcone = bigstepcone;

%----------------------------------------------------
% Panel Output
%----------------------------------------------------
Panel(1,:) = {'gwpproj',GWFM.gwpproj,'Output'};
Panel(2,:) = {'totgw',GWFM.totgw,'Output'};
Panel(3,:) = {'Gmax',GWFM.Gmax,'Output'};
Panel(4,:) = {'Gmaxinit',GWFM.Gmaxinit,'Output'};
Panel(5,:) = {'Gmaxtwstep',GWFM.Gmaxtwstep,'Output'};
Panel(6,:) = {'tgwfm',GWFM.tgwfm,'Output'};
PanelOutput = cell2struct(Panel,{'label','value','type'},2);
GWFM.PanelOutput = PanelOutput;

Status('done','');
Status2('done','',2);
Status2('done','',3);
