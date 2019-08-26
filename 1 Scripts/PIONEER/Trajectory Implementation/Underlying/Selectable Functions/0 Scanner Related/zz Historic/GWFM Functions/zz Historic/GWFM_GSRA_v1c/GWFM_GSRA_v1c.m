%=====================================================
% (v1c)
%   - update for RWSUI_BA
%=====================================================

function [SCRPTipt,GWFMout,err] = GWFM_GSRA_v1c(SCRPTipt,GWFM)

Status('busy','Create Gradient Waveforms');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Load Panel Input
%---------------------------------------------
GWFMout = struct();
GWFMout.SRAfunc = GWFM.('GSRAfunc').Func;

%---------------------------------------------
% Get Working Structures / Variables
%---------------------------------------------
CallingPanelOutput = GWFM.Struct.labelstr;
GSRA = GWFM.('GSRAfunc');
if isfield(GWFMout,([CallingPanelOutput,'_Data']))
    if isfield(GWFM.GWFMfunc_Data,('GSRAfunc_Data'))
        GSRA.GSRAfunc_Data = GWFM.GWFMfunc_Data.GSRAfunc_Data;
    end
end
SYS = GWFM.SYS;
GQNT = GWFM.GQNT;
PROJdgn = GWFM.PROJdgn;
PROJimp = GWFM.PROJimp;
T = GWFM.T;
KSA = GWFM.KSA;

%----------------------------------------------------
% Quantize Trajectories
%----------------------------------------------------
Status('busy','Quantize Trajectories');
qTsamp = GQNT.samparr;
[GQKSA] = Quantize_Projections_v1b(PROJimp.tro,T,qTsamp,KSA);
GQKSA = PROJdgn.kmax*GQKSA;
GWFMout.GQKSA = GQKSA;

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
    figure(1001); hold on; plot(L,Gvis(5,:,1),'b:'); plot(L,Gvis(5,:,2),'g:'); plot(L,Gvis(5,:,3),'r:'); xlim([0 max(L)]);
    title('Traj5');
    xlabel('Time (ms)','fontsize',10,'fontweight','bold');
    ylabel('Gradients (mT/m)','fontsize',10,'fontweight','bold');
    figure(1002); hold on; plot(L,Gvis(nproj-1,:,1),'b:'); plot(L,Gvis(nproj-1,:,2),'g:'); plot(L,Gvis(nproj-1,:,3),'r:'); xlim([0 max(L)]); 
    title(['Traj',num2str(nproj-1)]);
    xlabel('Time (ms)','fontsize',10,'fontweight','bold');
    ylabel('Gradients (mT/m)','fontsize',10,'fontweight','bold');
end

%----------------------------------------------------
% Compensate for Step Response
%----------------------------------------------------
Status('busy','Compensate for Step Response');
func = str2func(GWFMout.SRAfunc);
GSRA.PROJimp = PROJimp;
GSRA.qT = qTscnr;
GSRA.G = G0;
GSRA.mingseg = GQNT.mingseg;
[SCRPTipt,GSRA,err] = func(SCRPTipt,GSRA);
if err.flag
    return
end
Gaccom = GSRA.Gaccom;
GSRA = rmfield(GSRA,'Gaccom');
GWFMout.GSRA = GSRA;

%----------------------------------------------------
% Zero Gradients
%----------------------------------------------------
Status('busy','Zero Gradients');
[i,j,k] = size(Gaccom);
zGaccom = zeros([i,j+1,k]);
zGaccom(:,1:j,:) = Gaccom;
qTscnr = [qTscnr qTscnr(length(qTscnr))+GQNT.twseg];
GWFMout.qTscnr = qTscnr;
GWFMout.G = zGaccom;
GWFMout.tgwfm = qTscnr(length(qTscnr));

%----------------------------------------------------
% Visuals
%----------------------------------------------------
GVis = 'On';
if strcmp(GVis,'On') 
    Gvis = []; L = [];
    for n = 1:length(qTscnr)-1
        L = [L [qTscnr(n) qTscnr(n+1)]];
        Gvis = [Gvis [GWFMout.G(:,n,:) GWFMout.G(:,n,:)]];
    end
    figure(1000); hold on; plot(L,Gvis(1,:,1),'b-'); plot(L,Gvis(1,:,2),'g-'); plot(L,Gvis(1,:,3),'r-');
    figure(1001); hold on; plot(L,Gvis(5,:,1),'b-'); plot(L,Gvis(5,:,2),'g-'); plot(L,Gvis(5,:,3),'r-'); 
    figure(1002); hold on; plot(L,Gvis(nproj-1,:,1),'b-'); plot(L,Gvis(nproj-1,:,2),'g-'); plot(L,Gvis(nproj-1,:,3),'r-');
end

%----------------------------------------------------
% Gradient Words
%----------------------------------------------------
GWFMout.gwpproj = length(qTscnr)-1;
GWFMout.totgw = (GWFMout.gwpproj+SYS.extrawords)*PROJimp.nproj;              % (Seems like 8 words per proj for system overhead)
if strcmp(SYS.sym,'PosNeg');
    GWFMout.totgw = GWFMout.totgw/2;
end

%---------------------------------------
% Max Gradient Steps
%---------------------------------------
GWFMout.Gmax = max(GWFMout.G(:));
initsteps = GWFMout.G(:,1,:);
GWFMout.Gmaxinit = max(initsteps(:));
m = (2:length(qTscnr)-2);
twsteps = GWFMout.G(:,m,:)-GWFMout.G(:,m-1,:);
GWFMout.Gmaxtwstep = max(twsteps(:)); 

%----------------------------------------------------
% Panel Output
%----------------------------------------------------
Panel(1,:) = {'gwpproj',GWFMout.gwpproj,'Output'};
Panel(2,:) = {'totgw',GWFMout.totgw,'Output'};
Panel(3,:) = {'Gmax',GWFMout.Gmax,'Output'};
Panel(4,:) = {'Gmaxinit',GWFMout.Gmaxinit,'Output'};
Panel(5,:) = {'Gmaxtwstep',GWFMout.Gmaxtwstep,'Output'};
Panel(6,:) = {'tgwfm',GWFMout.tgwfm,'Output'};
PanelOutput = cell2struct(Panel,{'label','value','type'},2);
GWFMout.PanelOutput = PanelOutput;

Status('done','');
Status2('done','',2);
Status2('done','',3);
