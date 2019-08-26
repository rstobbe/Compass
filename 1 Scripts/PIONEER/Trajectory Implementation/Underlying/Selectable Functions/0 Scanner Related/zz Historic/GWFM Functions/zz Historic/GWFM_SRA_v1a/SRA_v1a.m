%=====================================================
% Calculate Gradient WaveForm
% - gradient Step Response Accomodate (SRA)
%=====================================================

function [PROJimp,G,GQKSA,WFM,IMPipt,err] = SRA_v1a(PROJdgn,PROJimp,T,KSA,WFM,IMPipt,err)

G = [];
GQKSA = [];

GVis = IMPipt(strcmp('Gwfm Vis',{IMPipt.labelstr})).entrystr;
if iscell(GVis)
    GVis = IMPipt(strcmp('Gwfm Vis',{IMPipt.labelstr})).entrystr{IMPipt(strcmp('Gwfm Vis',{IMPipt.labelstr})).entryvalue};
end
PROJimp.SRAfunc = IMPipt(strcmp('SRA_Func',{IMPipt.labelstr})).entrystr;

%----------------------------------------------------
% Quantize Trajectories
%----------------------------------------------------
Status('busy','Quantize Trajectories');
qT = PROJimp.GQNT.arr0;
[GQKSA] = Quantize_Projections_v1a(PROJdgn,T,qT,KSA);
GQKSA = PROJdgn.kmax*GQKSA;

%----------------------------------------------------
% Solve Gradient Quantization
%----------------------------------------------------
Status('busy','Solve Gradient Quantization');
[G0] = SolveGradQuant_v1a(PROJdgn,qT,GQKSA,PROJimp.gamma);

%----------------------------------------------------
% Visuals
%----------------------------------------------------
if strcmp(GVis,'On') 
    Gvis = []; L = [];
    for n = 1:length(qT)-1
        L = [L [qT(n) qT(n+1)]];
        Gvis = [Gvis [G0(:,n,:) G0(:,n,:)]];
    end
    figure(1000); hold on; plot(L,Gvis(1,:,1),'b:'); plot(L,Gvis(1,:,2),'g:'); plot(L,Gvis(1,:,3),'r:'); xlim([0 max(L)]); title('Grads Traj1');
    figure(1001); hold on; plot(L,Gvis(PROJimp.nproj-1,:,1),'b:'); plot(L,Gvis(PROJimp.nproj-1,:,2),'g:'); plot(L,Gvis(PROJimp.nproj-1,:,3),'r:'); xlim([0 max(L)]); title(['Grads Traj',num2str(PROJimp.nproj-1)]);
end

%----------------------------------------------------
% Compensate for Step Response
%----------------------------------------------------
Status('busy','Compensate for Step Response');
func = str2func(PROJimp.SRAfunc);
qT = PROJimp.GQNT.arr;
[PROJimp,qT,G0,WFM,IMPipt,err] = func(PROJdgn,PROJimp,qT,G0,WFM,IMPipt,err);
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
qT = [qT qT(length(qT))+qT(length(qT))-qT(length(qT)-1)];
PROJimp.GQNT.arr = qT;

%----------------------------------------------------
% Return Projection Quantization
%----------------------------------------------------
PROJimp.gro = qT(length(qT));
PROJimp.wpproj = length(qT)-1;
PROJimp.tw = (length(qT)-1)*PROJdgn.nproj;
if strcmp(PROJimp.sym,'PosNeg');
    PROJimp.tw = PROJimp.tw/2;
end
[IMPipt] = AddToPanelOutput(IMPipt,'Gwpproj','0output',PROJimp.wpproj,'0numout');
[IMPipt] = AddToPanelOutput(IMPipt,'Gtw','0output',PROJimp.tw,'0numout');

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
if strcmp(GVis,'On') 
    Gvis = []; L = [];
    for n = 1:length(qT)-1
        L = [L [qT(n) qT(n+1)]];
        Gvis = [Gvis [G(:,n,:) G(:,n,:)]];
    end
    figure(1000); hold on; plot(L,Gvis(1,:,1),'b-'); plot(L,Gvis(1,:,2),'g-'); plot(L,Gvis(1,:,3),'r-'); xlim([0 max(L)]); title('Grads Traj1');
    figure(1001); hold on; plot(L,Gvis(PROJimp.nproj-1,:,1),'b-'); plot(L,Gvis(PROJimp.nproj-1,:,2),'g-'); plot(L,Gvis(PROJimp.nproj-1,:,3),'r-'); xlim([0 max(L)]); title(['Grads Traj',num2str(PROJimp.nproj-1)]);
end
 

