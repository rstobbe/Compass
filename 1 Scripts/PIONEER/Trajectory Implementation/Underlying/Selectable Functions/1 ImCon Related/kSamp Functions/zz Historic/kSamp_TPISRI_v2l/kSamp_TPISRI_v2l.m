%=====================================================
% (v2l) 
%       - Fix Testing for Elip
%=====================================================

function [SCRPTipt,KSMPout,err] = kSamp_TPISRI_v2l(SCRPTipt,KSMP)

Status('busy','Sample k-Space');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Load Panel Input
%---------------------------------------------
KSMPout = struct();
KSMPout.GSRIfunc = KSMP.('GSRIfunc').Func;

%---------------------------------------------
% Get Working Structures / Variables
%---------------------------------------------
GSRI = KSMP.('GSRIfunc');
CallingPanel = KSMP.Struct.labelstr;
if isfield(KSMPout,([CallingPanel,'_Data']))
    if isfield(KSMP.kSampfunc_Data,('GSRIfunc_Data'))
        GSRI.GSRIfunc_Data = KSMP.kSampfunc_Data.GSRIfunc_Data;
    end
end
GQNT = KSMP.GQNT;
GWFM = KSMP.GWFM;
PSMP = KSMP.PSMP;
PROJdgn = KSMP.PROJdgn;
PROJimp = KSMP.PROJimp;
G = KSMP.G;
KSA = KSMP.KSA;

%---------------------------------------------
% Testing
%---------------------------------------------
KSMPout.maxfreq = GWFM.Gmax*PROJimp.gamma*PROJdgn.fov/2;
test = 0;

%----------------------------------------------------
% Add Step Response
%----------------------------------------------------
func = str2func(KSMPout.GSRIfunc);
GSRI.PROJimp = PROJimp;
GSRI.G = G;
GSRI.GQNT = GQNT;
GSRI.GWFM = GWFM;
[SCRPTipt,GSRI,err] = func(SCRPTipt,GSRI);
if err.flag
    return
end
TGSR = GSRI.TGSR;
GSR = GSRI.GSR;
%test = max(abs(GSR(:)))

GSRI = rmfield(GSRI,{'TGSR','GSR'});
KSMPout.GSRI = GSRI;

%----------------------------------------------------
% Visualize Step Response
%----------------------------------------------------
gVis = 'On';
nproj = length(GSR(:,1,1));
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
        Gvis = [Gvis [GSR(5,n,:) GSR(5,n,:)]];
    end
    Gvis = squeeze(Gvis);
    figure(1001); hold on; plot(L,Gvis(:,1),'b-'); plot(L,Gvis(:,2),'g-'); plot(L,Gvis(:,3),'r-');
    drawnow;
    Gvis = []; L = [];
    for n = 1:length(TGSR)-1
        L = [L [TGSR(n) TGSR(n+1)]];
        Gvis = [Gvis [GSR(nproj-1,n,:) GSR(nproj-1,n,:)]];
    end
    Gvis = squeeze(Gvis);
    figure(1002); hold on; plot(L,Gvis(:,1),'b-'); plot(L,Gvis(:,2),'g-'); plot(L,Gvis(:,3),'r-');
    drawnow;
end

%----------------------------------------------------
% Resample k-Space
%----------------------------------------------------
Status('busy','Resample k-Space');
zerotime = GWFM.qTscnr(length(GWFM.qTscnr));
[samp,Kmat,Kend] = ReSampleKSpace_v6c(PROJimp,GSR,TGSR,zerotime);      

%---------------------------------------
% Visuals
%---------------------------------------
kVis = 'On';
if strcmp(kVis,'On') 
    figure(2000); hold on; 
    plot(samp,Kmat(1,:,1),'b*'); plot(samp,Kmat(1,:,2),'g*'); plot(samp,Kmat(1,:,3),'r*');
    figure(2001); hold on; 
    plot(samp,Kmat(5,:,1),'b*'); plot(samp,Kmat(5,:,2),'g*'); plot(samp,Kmat(5,:,3),'r*');
    figure(2002); hold on; 
    [L,~,~] = size(Kmat);
    L = L-1;
    plot(samp,Kmat(L,:,1),'b*'); plot(samp,Kmat(L,:,2),'g*'); plot(samp,Kmat(L,:,3),'r*'); 
end

%---------------------------------------
% Test Max Relative Radial Sampling Step
%---------------------------------------
Rad = sqrt(Kmat(:,:,1).^2 + Kmat(:,:,2).^2 + Kmat(:,:,3).^2);
rRad = Rad/PROJdgn.kstep;
KSMPout.rRadFirstStepMean = mean(rRad(:,1));
KSMPout.rRadFirstStepMax = max(rRad(:,1));
for n = 2:PROJimp.npro
    rRadStep(:,n) = rRad(:,n) - rRad(:,n-1);
end
KSMPout.rRadStepMax = max(rRadStep(:));

%----------------------------------------------------
% Test Relative Sampling Maximums and Elip
%----------------------------------------------------
if strcmp(KSMP.testing,'Yes')
    phi = PSMP.PCD.testconephi;
    deslen = length(KSA(1,:,1));
    for n = 1:nproj/2
        dKmax(n) = sqrt(((PROJdgn.elip*PROJdgn.kmax*cos(phi(n)))^2) + (PROJdgn.kmax*sin(phi(n)))^2);
        dKmax2(n) = PROJdgn.kmax*(KSA(n,deslen,1).^2 + KSA(n,deslen,2).^2 + KSA(n,deslen,3).^2).^(1/2);
        Kmax(n) = (Kmat(n,PROJimp.npro,1).^2 + Kmat(n,PROJimp.npro,2).^2 + Kmat(n,PROJimp.npro,3).^2).^(1/2);
        if abs((1 - dKmax(n)/dKmax2(n))) > 0.001 
            error();
        end
    end
else
    phi = PSMP.PCD.conephi;
    projindx = PSMP.PCD.projindx;
    deslen = length(KSA(1,:,1));
    for n = 1:length(phi)/2
        dKmax(n) = sqrt(((PROJdgn.elip*PROJdgn.kmax*cos(phi(n)))^2) + (PROJdgn.kmax*sin(phi(n)))^2);
        dKmax2(n) = PROJdgn.kmax*(KSA(projindx{n}(1),deslen,1).^2 + KSA(projindx{n}(1),deslen,2).^2 + KSA(projindx{n}(1),deslen,3).^2).^(1/2);
        Kmax(n) = (Kmat(projindx{n}(1),PROJimp.npro,1).^2 + Kmat(projindx{n}(1),PROJimp.npro,2).^2 + Kmat(projindx{n}(1),PROJimp.npro,3).^2).^(1/2);
    end
    if abs((1 - dKmax(n)/dKmax2(n))) > 0.001 
        error();
    end
end   
rKmax = Kmax./dKmax;
KSMPout.meanrelkmax = mean(rKmax);
KSMPout.maxrelkmax = max(rKmax);
KSMPout.rSNR = PROJdgn.rSNR/(KSMPout.meanrelkmax^3);

%---------------------------------------
% Return Sampling Timing for Testing
%---------------------------------------
if strcmp(KSMP.testing,'Yes')
    for n = 1:nproj/2   
        rKmag(n,:) = ((Kmat(n,:,1).^2 + Kmat(n,:,2).^2 + Kmat(n,:,3).^2).^(1/2))/Kmax(n);
    end
    KSMPout.rKmag = mean(rKmag,1);
    KSMPout.tatr = (PROJimp.sampstart:PROJimp.dwell:PROJimp.tro);    
end
%for n = 1:length(phi)/2
%    rKmag(n,:) = ((Kmat(projindx{n}(1),:,1).^2 + Kmat(projindx{n}(1),:,2).^2 + Kmat(projindx{n}(1),:,3).^2).^(1/2))/Kmax(n);
%end

%----------------------------------------------------
% Return
%----------------------------------------------------
KSMPout.samp = samp;
KSMPout.Kmat = Kmat;
KSMPout.Kend = Kend;

%----------------------------------------------------
% Panel
%----------------------------------------------------
if KSMPout.rRadFirstStepMean > 0.35 || KSMPout.rRadFirstStepMean < 0.15
    Panel(1,:) = {'rRadFirstStepMean',KSMPout.rRadFirstStepMean,'OutputWarn'};
else
    Panel(1,:) = {'rRadFirstStepMean',KSMPout.rRadFirstStepMean,'Output'};
end
if KSMPout.rRadFirstStepMax > 0.4
    Panel(2,:) = {'rRadFirstStepMax',KSMPout.rRadFirstStepMax,'OutputWarn'};
else
    Panel(2,:) = {'rRadFirstStepMax',KSMPout.rRadFirstStepMax,'Output'};
end
if KSMPout.rRadStepMax > 0.8
    Panel(3,:) = {'rRadStepMax',KSMPout.rRadStepMax,'OutputWarn'};
else
    Panel(3,:) = {'rRadStepMax',KSMPout.rRadStepMax,'Output'};
end
Panel(4,:) = {'meanrelkmax',KSMPout.meanrelkmax,'Output'};
Panel(5,:) = {'rSNR',KSMPout.rSNR,'Output'};
PanelOutput = cell2struct(Panel,{'label','value','type'},2);
KSMPout.PanelOutput = PanelOutput;

Status('done','');
Status2('done','',2);
Status2('done','',3);


    
    