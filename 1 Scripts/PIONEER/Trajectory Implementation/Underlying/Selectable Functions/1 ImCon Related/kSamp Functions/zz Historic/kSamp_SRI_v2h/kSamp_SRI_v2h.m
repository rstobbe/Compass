%=====================================================
% ReSample kSpace with StepResponse
% (2h)  - remove visualization selection
%       - accomodate projsampling move to implementation
%=====================================================

function [PROJimp,samp,Kmat,Kend,IMP,IMPipt,err] = kSamp_SRI_v2h(PROJdgn,PROJimp,G,IMP,IMPipt,err)

samp = [];
Kmat = [];
Kend = [];

PROJimp.SRIfunc = IMPipt(strcmp('SRI_Func',{IMPipt.labelstr})).entrystr;

%----------------------------------------------------
% Add Step Response
%----------------------------------------------------
Status('busy','Add Step Response');
qT = PROJimp.GQNT.arr;
func = str2func(PROJimp.SRIfunc);
[PROJimp,TGSR,GSR,IMPipt,err] = func(PROJimp,qT,G,IMPipt,err);
for n = 1:length(err)
    if err(n).flag == 1
        return
    end
end

%----------------------------------------------------
% Visualize Step Response
%----------------------------------------------------
gVis = 'Off';
if strcmp(gVis,'On')
    Status('busy','Plot Gradient Step Response');
    Gvis = []; L = [];
    for n = 1:length(TGSR)-1
        L = [L [TGSR(n) TGSR(n+1)]];
        Gvis = [Gvis [GSR(1,n,:) GSR(1,n,:)]];
    end
    Gvis = squeeze(Gvis);
    figure(1000); hold on; plot(L,Gvis(:,1),'b-'); plot(L,Gvis(:,2),'g-'); plot(L,Gvis(:,3),'r-');
    drawnow;
    Gvis = []; L = [];
    for n = 1:length(TGSR)-1
        L = [L [TGSR(n) TGSR(n+1)]];
        Gvis = [Gvis [GSR(PROJimp.nproj-1,n,:) GSR(PROJimp.nproj-1,n,:)]];
    end
    Gvis = squeeze(Gvis);
    figure(1001); hold on; plot(L,Gvis(:,1),'b-'); plot(L,Gvis(:,2),'g-'); plot(L,Gvis(:,3),'r-');
    drawnow;
end

%----------------------------------------------------
% Resample k-Space
%----------------------------------------------------
Status('busy','Resample k-Space');
zerotime = qT(length(qT));
[samp,Kmat,Kend] = ReSampleKSpace_v6b(PROJimp,GSR,TGSR,zerotime);      

%----------------------------------------------------
% Testing Relative Sampling Steps
%----------------------------------------------------
Rad = sqrt(Kmat(:,:,1).^2 + Kmat(:,:,2).^2 + Kmat(:,:,3).^2);
rRad = Rad/PROJdgn.kstep;
for n = 2:PROJimp.npro
    rRadStep(:,n) = rRad(:,n) - rRad(:,n-1);
end
PROJimp.rRadStep = max(rRadStep(:));
if PROJimp.rRadStep > 0.85
    [IMPipt] = AddToPanelOutput(IMPipt,'maxRelRadStep','0output',PROJimp.rRadStep,'0warn');
    warnflag = 3;
    warning = 'increase OverSamp_Des';
else
    [IMPipt] = AddToPanelOutput(IMPipt,'maxRelRadStep','0output',PROJimp.rRadStep,'0numout');
end

%----------------------------------------------------
% Testing Relative Sampling Maximum
%----------------------------------------------------
if IMP.testing == 1
    phi = PROJimp.projdist.conephi;
    for n = 1:PROJimp.nproj/2
        elipphi(n) = atan(sin(phi(n))/(PROJdgn.elip*cos(phi(n)))); 
        dKmax(n) = sqrt(((PROJdgn.elip*PROJdgn.kmax)^2)/(PROJdgn.elip^2*(sin(elipphi(n)))^2 + (cos(elipphi(n)))^2));
        Kmax(n) = (Kmat(n,PROJimp.npro,1).^2 + Kmat(n,PROJimp.npro,2).^2 + Kmat(n,PROJimp.npro,3).^2).^(1/2);
    end
else
    phi = PROJdgn.InitProjVec.conephi;
    projindx = PROJdgn.InitProjVec.projindx;
    for n = 1:length(phi)/2
        elipphi(n) = atan(sin(phi(n))/(PROJdgn.elip*cos(phi(n)))); 
        dKmax(n) = sqrt(((PROJdgn.elip*PROJdgn.kmax)^2)/(PROJdgn.elip^2*(sin(elipphi(n)))^2 + (cos(elipphi(n)))^2));
        Kmax(n) = (Kmat(projindx{n}(1),PROJimp.npro,1).^2 + Kmat(projindx{n}(1),PROJimp.npro,2).^2 + Kmat(projindx{n}(1),PROJimp.npro,3).^2).^(1/2);
    end
end
    
rKmax = Kmax./dKmax;
PROJimp.meanrelkmax = mean(rKmax);
[IMPipt] = AddToPanelOutput(IMPipt,'meanRelKmax','0output',PROJimp.meanrelkmax,'0numout');
PROJimp.rSNR = PROJdgn.rSNR/(PROJimp.meanrelkmax^3);
[IMPipt] = AddToPanelOutput(IMPipt,'RelSNR','0output',PROJimp.rSNR,'0numout');


    
    