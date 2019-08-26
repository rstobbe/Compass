%=====================================================
% (v1b)
%   - added 'WFM' as input to compensation func
%=====================================================

function [PROJimp,G,GQKSA,WFM,IMPipt,err] = GWFM_GSRA_v1b(PROJdgn,PROJimp,T,KSA,WFM,IMPipt,err)

G = [];
GQKSA = [];

GVis = 'On';
PROJimp.SRAfunc = IMPipt(strcmp('GSRAfunc',{IMPipt.labelstr})).entrystr;

%----------------------------------------------------
% Quantize Trajectories
%----------------------------------------------------
Status('busy','Quantize Trajectories');
qTsamp = PROJimp.GQNT.samparr;
[GQKSA] = Quantize_Projections_v1a(PROJdgn,T,qTsamp,KSA);
GQKSA = PROJdgn.kmax*GQKSA;

%----------------------------------------------------
% Solve Gradient Quantization
%----------------------------------------------------
Status('busy','Solve Gradient Quantization');
qTscnr = PROJimp.GQNT.scnrarr;
[G0] = SolveGradQuant_v1a(PROJdgn,qTscnr,GQKSA,PROJimp.gamma);

%----------------------------------------------------
% Visuals
%----------------------------------------------------
if strcmp(GVis,'On') 
    Gvis = []; L = [];
    for n = 1:length(qTscnr)-1
        L = [L [qTscnr(n) qTscnr(n+1)]];
        Gvis = [Gvis [G0(:,n,:) G0(:,n,:)]];
    end
    figure(1000); hold on; plot(L,Gvis(1,:,1),'b:'); plot(L,Gvis(1,:,2),'g:'); plot(L,Gvis(1,:,3),'r:'); xlim([0 max(L)]); title('Grads Traj1');
    figure(1001); hold on; plot(L,Gvis(PROJimp.nproj-1,:,1),'b:'); plot(L,Gvis(PROJimp.nproj-1,:,2),'g:'); plot(L,Gvis(PROJimp.nproj-1,:,3),'r:'); xlim([0 max(L)]); title(['Grads Traj',num2str(PROJimp.nproj-1)]);
    figure(1002); hold on; plot(L,Gvis(5,:,1),'b:'); plot(L,Gvis(5,:,2),'g:'); plot(L,Gvis(5,:,3),'r:'); xlim([0 max(L)]); title('Grads Traj5');
end

%----------------------------------------------------
% Compensate for Step Response
%----------------------------------------------------
Status('busy','Compensate for Step Response');
func = str2func(PROJimp.SRAfunc);
[PROJimp,G0,WFM,IMPipt,err] = func(PROJimp,qTscnr,G0,WFM,IMPipt,err);
for n = 1:length(err)
    if err(n).flag == 1
        return
    end
end
    
%----------------------------------------------------
% Zero Gradients
%----------------------------------------------------
Status('busy','Zero Gradients');
[i,j,k] = size(G0);
G = zeros([i,j+1,k]);
G(:,1:j,:) = G0;
qTscnr = [qTscnr qTscnr(length(qTscnr))+qTscnr(length(qTscnr))-qTscnr(length(qTscnr)-1)];
PROJimp.GQNT.arr = qTscnr;

%----------------------------------------------------
% Return Projection Quantization
%----------------------------------------------------
PROJimp.tgwfm = qTscnr(length(qTscnr));
PROJimp.gwpproj = length(qTscnr)-1;
PROJimp.totgw = (PROJimp.gwpproj+8)*PROJdgn.nproj;              % (Seems like 8 words per proj for system overhead)
if strcmp(PROJimp.sym,'PosNeg');
    PROJimp.totgw = PROJimp.totgw/2;
end
%[IMPipt] = AddToPanelOutput(IMPipt,'tGwfm (ms)','0output',PROJimp.tgwfm,'0numout');
%[IMPipt] = AddToPanelOutput(IMPipt,'Gwpproj','0output',PROJimp.gwpproj,'0numout');
%[IMPipt] = AddToPanelOutput(IMPipt,'Gtotwords','0output',PROJimp.totgw,'0numout');

%----------------------------------------------------
% Test
%----------------------------------------------------
initsteps = G(:,1,:);
PROJimp.Gmaxinit = max(initsteps(:));
[IMPipt] = AddToPanelOutput(IMPipt,'Gmaxinit (mT/m)','0output',PROJimp.Gmaxinit,'0numout');
m = (2:length(qTscnr)-2);
twsteps = G(:,m,:)-G(:,m-1,:);
PROJimp.Gmaxtwstep = max(twsteps(:));
[IMPipt] = AddToPanelOutput(IMPipt,'Gmaxtwstep (mT/m)','0output',PROJimp.Gmaxtwstep,'0numout');

%----------------------------------------------------
% Visuals
%----------------------------------------------------
GVis = 'On';
if strcmp(GVis,'On') 
    Gvis = []; L = [];
    for n = 1:length(qTscnr)-1
        L = [L [qTscnr(n) qTscnr(n+1)]];
        Gvis = [Gvis [G(:,n,:) G(:,n,:)]];
    end
    figure(1000); hold on; plot(L,Gvis(1,:,1),'b-'); plot(L,Gvis(1,:,2),'g-'); plot(L,Gvis(1,:,3),'r-'); xlim([0 max(L)]); title('Grads Traj1');
    figure(1001); hold on; plot(L,Gvis(PROJimp.nproj-1,:,1),'b-'); plot(L,Gvis(PROJimp.nproj-1,:,2),'g-'); plot(L,Gvis(PROJimp.nproj-1,:,3),'r-'); xlim([0 max(L)]); title(['Grads Traj',num2str(PROJimp.nproj-1)]);
    figure(1002); hold on; plot(L,Gvis(5,:,1),'b-'); plot(L,Gvis(5,:,2),'g-'); plot(L,Gvis(5,:,3),'r-'); xlim([0 max(L)]); title('Grads Traj5');
end

 
