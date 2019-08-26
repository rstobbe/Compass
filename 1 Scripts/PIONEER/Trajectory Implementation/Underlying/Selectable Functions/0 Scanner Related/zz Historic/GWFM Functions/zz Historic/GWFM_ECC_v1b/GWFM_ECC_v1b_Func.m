%=====================================================
% 
%=====================================================

function [GWFM,err] = GWFM_ECC_v1b_Func(GWFM,INPUT)

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
GECC = GWFM.GECC;
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
Status2('busy','Quantize Trajectories',2);
[GQKSA] = Quantize_Projections_VT_v1b(PROJdgn.tro,T,qTsamp,KSA);
GQKSA = PROJdgn.kmax*GQKSA;
GWFM.GQKSA = GQKSA;

%----------------------------------------------------
% Solve Gradient Quantization
%----------------------------------------------------
Status2('busy','Solve Gradient Quantization',2);
qTtraj = GQNT.scnrarr;
[G0] = SolveGradQuant_v1b(qTtraj,GQKSA,PROJimp.gamma);

%----------------------------------------------------
% Visuals
%----------------------------------------------------
if strcmp(GWFM.Vis,'Yes') 
    nproj = length(G0(:,1,1));
    Gvis = []; L = [];
    for n = 1:length(qTtraj)-1
        L = [L [qTtraj(n) qTtraj(n+1)]];
        Gvis = [Gvis [G0(:,n,:) G0(:,n,:)]];
    end
    figure(1000); hold on; plot(L,Gvis(1,:,1),'b:'); plot(L,Gvis(1,:,2),'g:'); plot(L,Gvis(1,:,3),'r:');
    title('Traj1'); 
    xlabel('Time (ms)','fontsize',10,'fontweight','bold');
    ylabel('Gradients (mT/m)','fontsize',10,'fontweight','bold');
    if nproj > 1
        figure(1001); hold on; plot(L,Gvis(ceil(nproj/4),:,1),'b:'); plot(L,Gvis(ceil(nproj/4),:,2),'g:'); plot(L,Gvis(ceil(nproj/4),:,3),'r:');
        title(['Traj',num2str(ceil(nproj/4))]);
        xlabel('Time (ms)','fontsize',10,'fontweight','bold');
        ylabel('Gradients (mT/m)','fontsize',10,'fontweight','bold');
        figure(1002); hold on; plot(L,Gvis(nproj-1,:,1),'b:'); plot(L,Gvis(nproj-1,:,2),'g:'); plot(L,Gvis(nproj-1,:,3),'r:');
        title(['Traj',num2str(nproj-1)]);
        xlabel('Time (ms)','fontsize',10,'fontweight','bold');
        ylabel('Gradients (mT/m)','fontsize',10,'fontweight','bold');
    end
end

%----------------------------------------------------
% End Trajectory
%----------------------------------------------------
Status2('busy','End Trajectory',2);
func = str2func([GWFM.TENDfunc,'_Func']);
INPUT.PROJimp = PROJimp;
INPUT.GQNT = GQNT;
INPUT.G0 = G0;
INPUT.GQKSA = GQKSA;
[TEND,err] = func(TEND,INPUT);
if err.flag
    return
end
Gend = TEND.Gend;
G0wend = cat(2,G0,Gend);
qTend = PROJdgn.tro +(GQNT.gseg:GQNT.gseg:length(Gend(1,:,1))*GQNT.gseg);
qTwend = [qTtraj qTend];

%----------------------------------------------------
% Visuals
%----------------------------------------------------
if strcmp(GWFM.Vis,'Yes') 
    Gvis = []; L = [];
    for n = 1:length(qTwend)-1
        L = [L [qTwend(n) qTwend(n+1)]];
        Gvis = [Gvis [G0wend(:,n,:) G0wend(:,n,:)]];
    end
    figure(1000); hold on; plot(L,Gvis(1,:,1),'b-'); plot(L,Gvis(1,:,2),'g-'); plot(L,Gvis(1,:,3),'r-');
    if nproj > 1
        figure(1001); hold on; plot(L,Gvis(ceil(nproj/4),:,1),'b-'); plot(L,Gvis(ceil(nproj/4),:,2),'g-'); plot(L,Gvis(ceil(nproj/4),:,3),'r-'); 
        figure(1002); hold on; plot(L,Gvis(nproj-1,:,1),'b-'); plot(L,Gvis(nproj-1,:,2),'g-'); plot(L,Gvis(nproj-1,:,3),'r-');
    end
end

%----------------------------------------------------
% ECC Trajectory
%----------------------------------------------------
Status2('busy','ECC Trajectory',2);
func = str2func([GWFM.GECCfunc,'_Func']);
INPUT.PROJimp = PROJimp;
INPUT.G0 = G0wend;
INPUT.qT = qTwend;
[GECC,err] = func(GECC,INPUT);
if err.flag
    return
end
Gcomp = GECC.Gcomp;
qTcomp = GECC.Tecc;

%----------------------------------------------------
% Visuals
%----------------------------------------------------
if strcmp(GWFM.Vis,'Yes') 
    Gvis = []; L = [];
    for n = 1:length(qTcomp)-1
        L = [L [qTcomp(n) qTcomp(n+1)]];
        Gvis = [Gvis [Gcomp(:,n,:) Gcomp(:,n,:)]];
    end
    figure(1000); hold on; plot(L,Gvis(1,:,1),'k-'); plot(L,Gvis(1,:,2),'k-'); plot(L,Gvis(1,:,3),'k-'); xlim([0 max(L)]); 
    if nproj > 1
        figure(1001); hold on; plot(L,Gvis(ceil(nproj/4),:,1),'k-'); plot(L,Gvis(ceil(nproj/4),:,2),'k-'); plot(L,Gvis(ceil(nproj/4),:,3),'k-'); xlim([0 max(L)]); 
        figure(1002); hold on; plot(L,Gvis(nproj-1,:,1),'k-'); plot(L,Gvis(nproj-1,:,2),'k-'); plot(L,Gvis(nproj-1,:,3),'k-'); xlim([0 max(L)]); 
    end
end

%---------------------------------------
% G0wend Chars
%---------------------------------------
GWFM.G0wendmax = max(G0wend(:));
initsteps = G0wend(:,1,:);
vecinitstep = sqrt(initsteps(:,:,1).^2 + initsteps(:,:,2).^2 + initsteps(:,:,3).^2);
GWFM.G0wendmaxvecinit = max(vecinitstep(:));
m = (2:length(qTwend)-2);
cartgsteps = G0wend(:,m,:)-G0wend(:,m-1,:);
GWFM.Gmaxcartstep = max(cartgsteps(:)); 
vecgsteps = sqrt(cartgsteps(:,:,1).^2 + cartgsteps(:,:,2).^2 + cartgsteps(:,:,3).^2);
vecgsteps = [vecinitstep vecgsteps];
if strcmp(GWFM.Vis,'Yes') 
    figure(1101); plot(vecgsteps(1,:));
    xlabel('Trajectory Step Number','fontsize',10,'fontweight','bold');
    ylabel('Gradient Step (mT/m)','fontsize',10,'fontweight','bold');
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
    figure(1101); plot(vecgsteps(1,:));
    xlabel('Trajectory Step Number','fontsize',10,'fontweight','bold');
    ylabel('Gradient Step (mT/m)','fontsize',10,'fontweight','bold');
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

%----------------------------------------------------
% Panel Output
%----------------------------------------------------
Panel(1,:) = {'G0wendmax',GWFM.G0wendmax,'Output'};
Panel(2,:) = {'Gcompmax',GWFM.Gcompmax,'Output'};
Panel(3,:) = {'G0wendmaxvecinit',GWFM.G0wendmaxvecinit,'Output'};
Panel(4,:) = {'Gcompmaxvecinit',GWFM.Gcompmaxvecinit,'Output'};
Panel(5,:) = {'G0wendmaxvecstep',GWFM.G0wendmaxvecstep,'Output'};
Panel(6,:) = {'Gcompmaxvecstep',GWFM.Gcompmaxvecstep,'Output'};
Panel(7,:) = {'G0wendmaxslew',GWFM.G0wendmaxslew,'Output'};
Panel(8,:) = {'Gcompmaxslew',GWFM.Gcompmaxslew,'Output'};
Panel(9,:) = {'tgwfm',GWFM.tgwfm,'Output'};
PanelOutput = cell2struct(Panel,{'label','value','type'},2);
GWFM.PanelOutput = PanelOutput;

Status('done','');
Status2('done','',2);
Status2('done','',3);
