%=====================================================
% (v2i) 
%       - pass KSMP to 'add step response' function
%=====================================================

function [PROJimp,samp,Kmat,Kend,KSMP,IMPipt,err] = kSamp_TPISRI_v2i(PROJdgn,PROJimp,G,KSMPin,IMPipt,err)

samp = [];
Kmat = [];
Kend = [];

PROJimp.SRIfunc = IMPipt(strcmp('SRIfunc',{IMPipt.labelstr})).entrystr;

%----------------------------------------------------
% Add Step Response
%----------------------------------------------------
Status('busy','Add Step Response');
qT = PROJimp.GQNT.arr;
func = str2func(PROJimp.SRIfunc);
[PROJimp,TGSR,GSR,KSMP,IMPipt,err] = func(PROJimp,qT,G,KSMPin,IMPipt,err);
for n = 1:length(err)
    if err(n).flag == 1
        return
    end
end

%----------------------------------------------------
% Visualize Step Response
%----------------------------------------------------
gVis = 'On';
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
PROJimp.rRadStepFirst = mean(rRad(:,1));
for n = 2:PROJimp.npro
    rRadStep(:,n) = rRad(:,n) - rRad(:,n-1);
end
PROJimp.rRadStep = max(rRadStep(:));
if PROJimp.rRadStep > 0.85
    [IMPipt] = AddToPanelOutput(IMPipt,'maxRelRadStep','0output',PROJimp.rRadStep,'0warn');
    err.flag = 3;
    err.msg = 'increase OverSamp_Des';
else
    [IMPipt] = AddToPanelOutput(IMPipt,'FirstRelRadStep','0output',PROJimp.rRadStepFirst,'0numout');
    [IMPipt] = AddToPanelOutput(IMPipt,'maxRelRadStep','0output',PROJimp.rRadStep,'0numout');
end

%----------------------------------------------------
% Testing Relative Sampling Maximum
%----------------------------------------------------
if KSMPin.testing == 1
    phi = PROJimp.projdist.conephi;
    for n = 1:PROJimp.nproj/2
        elipphi(n) = atan(sin(phi(n))/(PROJdgn.elip*cos(phi(n)))); 
        dKmax(n) = sqrt(((PROJdgn.elip*PROJdgn.kmax)^2)/(PROJdgn.elip^2*(sin(elipphi(n)))^2 + (cos(elipphi(n)))^2));
        Kmax(n) = (Kmat(n,PROJimp.npro,1).^2 + Kmat(n,PROJimp.npro,2).^2 + Kmat(n,PROJimp.npro,3).^2).^(1/2);
    end
else
    phi = PROJimp.projdist.conephi;
    projindx = PROJimp.projdist.projindx;
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


    
    