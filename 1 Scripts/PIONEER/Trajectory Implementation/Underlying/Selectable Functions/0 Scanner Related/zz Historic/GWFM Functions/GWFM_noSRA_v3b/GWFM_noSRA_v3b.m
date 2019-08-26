%=====================================================
% Calculate Gradient WaveForm
% - NO gradient Step Response Accomodate (SRA)
% (v3b) - remove visualization selection
%=====================================================

function [PROJimp,G,GQKSA,WFM,IMPipt,err] = GWFM_noSRA_v3b(PROJdgn,PROJimp,T,KSA,WFM,IMPipt,err)

G = [];
GQKSA = [];

%----------------------------------------------------
% Quantize Trajectories
%----------------------------------------------------
Status('busy','Quantize Trajectories');
qT = PROJimp.GQNT.arr;
[GQKSA] = Quantize_Projections_v1a(PROJdgn,T,qT,KSA);
GQKSA = PROJdgn.kmax*GQKSA;

%----------------------------------------------------
% Solve Gradient Quantization
%----------------------------------------------------
Status('busy','Solve Gradient Quantization');
[G0] = SolveGradQuant_v1a(PROJdgn,qT,GQKSA,PROJimp.gamma);

%----------------------------------------------------
% Zero Gradients
%----------------------------------------------------
Status('busy','Zero Gradients');
[i,j,k] = size(G0);
G = zeros([i,j+1,k]);
G(:,1:j,:) = G0;
qT = [qT qT(length(qT))+qT(length(qT))-qT(length(qT)-1)];
PROJimp.GQNT.arr = qT;

%----------------------------------------------------
% Return Projection Quantization
%----------------------------------------------------
PROJimp.tgwfm = qT(length(qT));
PROJimp.gwpproj = length(qT)-1;
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
m = (2:length(qT)-2);
twsteps = G(:,m,:)-G(:,m-1,:);
PROJimp.Gmaxtwstep = max(twsteps(:));
[IMPipt] = AddToPanelOutput(IMPipt,'Gmaxtwstep (mT/m)','0output',PROJimp.Gmaxtwstep,'0numout');

%----------------------------------------------------
% Visuals
%----------------------------------------------------
GVis = 'On';
if strcmp(GVis,'On') 
    Gvis = []; L = [];
    for n = 1:length(qT)-1
        L = [L [qT(n) qT(n+1)]];
        Gvis = [Gvis [G(:,n,:) G(:,n,:)]];
    end
    figure(1000); hold on; plot(L,Gvis(1,:,1),'b-'); plot(L,Gvis(1,:,2),'g-'); plot(L,Gvis(1,:,3),'r-'); xlim([0 max(L)]); title('Grads Traj1');
    figure(1001); hold on; plot(L,Gvis(PROJimp.nproj-1,:,1),'b-'); plot(L,Gvis(PROJimp.nproj-1,:,2),'g-'); plot(L,Gvis(PROJimp.nproj-1,:,3),'r-'); xlim([0 max(L)]); title(['Grads Traj',num2str(PROJimp.nproj-1)]);
    figure(1002); hold on; plot(L,Gvis(5,:,1),'b-'); plot(L,Gvis(5,:,2),'g-'); plot(L,Gvis(5,:,3),'r-'); xlim([0 max(L)]); title('Grads Traj5');
end


       