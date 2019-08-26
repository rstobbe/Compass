%=====================================================
% 
%=====================================================

function [KSMP,err] = kSamp_TPISRI_v2p_Func(KSMP,INPUT)

Status2('busy','Sample k-Space',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
GQNT = INPUT.GQNT;
GWFM = INPUT.GWFM;
PSMP = INPUT.PSMP;
PROJdgn = INPUT.PROJdgn;
PROJimp = INPUT.PROJimp;
G = INPUT.G;
KSA = INPUT.KSA;
GSRI = KSMP.GSRI;
testing = INPUT.testing;
clear INPUT;

%---------------------------------------------
% Testing
%---------------------------------------------
KSMP.maxfreq = GWFM.Gmax*PROJimp.gamma*PROJdgn.fov/2;

%---------------------------------------------
% Common
%---------------------------------------------
nproj = length(G(:,1,1));

%----------------------------------------------------
% Add Step Response
%----------------------------------------------------
func = str2func([KSMP.GSRIfunc,'_Func']);
INPUT.PROJimp = PROJimp;
INPUT.G = G;
INPUT.GQNT = GQNT;
INPUT.GWFM = GWFM;
[GSRI,err] = func(GSRI,INPUT);
if err.flag
    return
end
clear INPUT;
TGSR = GSRI.TGSR;
segTGSR = GSRI.segTGSR;
GSR = GSRI.GSR;
mGSR = GSRI.mGSR;
GSRI = rmfield(GSRI,{'TGSR','segTGSR','GSR'});
if isfield(GSRI,'SR')
    GSRI = rmfield(GSRI,'SR');
end
if isfield(GSRI,'SRiseg')
    GSRI = rmfield(GSRI,'SRiseg');
end
if isfield(GSRI,'SRtwseg')
    GSRI = rmfield(GSRI,'SRtwseg');
end
KSMP.GSRI = GSRI;
KSMP.gcoil = GSRI.gcoil;
KSMP.graddel = GSRI.graddel;

%----------------------------------------------------
% Save Step Response
%----------------------------------------------------
if strcmp(KSMP.saveGSRI,'Yes');
    button = questdlg('save GSRI waveforms (lots of data...)');
    if strcmp(button,'Yes')
        KSMP.TGSR = TGSR;
        KSMP.GSR = GSR;
        KSMP.segTGSR = segTGSR;
        KSMP.mGSR = mGSR;
    end
end

%----------------------------------------------------
% Resample k-Space
%----------------------------------------------------
Status('busy','Resample k-Space');
zerotime = GWFM.qTscnr(length(GWFM.qTscnr));
[samp,Kmat,Kend] = ReSampleKSpace_v6c(PROJimp,mGSR,TGSR,zerotime);      

%---------------------------------------
% Visuals
%---------------------------------------
kVis = 'On';
if strcmp(kVis,'On') 
    figure(2000); hold on; 
    plot(samp,Kmat(1,:,1),'b*'); plot(samp,Kmat(1,:,2),'g*'); plot(samp,Kmat(1,:,3),'r*');
    figure(2001); hold on; 
    plot(samp,Kmat(round(nproj/4),:,1),'b*'); plot(samp,Kmat(round(nproj/4),:,2),'g*'); plot(samp,Kmat(round(nproj/4),:,3),'r*');
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
KSMP.rRadFirstStepMean = mean(rRad(:,1));
KSMP.rRadSecondStepMean = mean(rRad(:,2)-rRad(:,1));
KSMP.rRadFirstStepMax = max(rRad(:,1));
for n = 2:PROJimp.npro
    rRadStep(:,n) = rRad(:,n) - rRad(:,n-1);
end
KSMP.rRadStepMax = max(rRadStep(:));

%----------------------------------------------------
% Test Relative Sampling Maximums and Elip
%----------------------------------------------------
if strcmp(testing,'Yes')
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
KSMP.meanrelkmax = mean(rKmax);
KSMP.maxrelkmax = max(rKmax);
KSMP.rSNR = PROJdgn.rSNR/(KSMP.meanrelkmax^3);

%---------------------------------------
% Return Sampling Timing for Testing
%---------------------------------------
if strcmp(testing,'Yes')
    for n = 1:nproj/2   
        rKmag(n,:) = ((Kmat(n,:,1).^2 + Kmat(n,:,2).^2 + Kmat(n,:,3).^2).^(1/2))/Kmax(n);
    end
else
    for n = 1:length(phi)/2
        rKmag(n,:) = ((Kmat(projindx{n}(1),:,1).^2 + Kmat(projindx{n}(1),:,2).^2 + Kmat(projindx{n}(1),:,3).^2).^(1/2))/Kmax(n);
    end
end
KSMP.rKmag = mean(rKmag,1);
KSMP.tatr = (PROJimp.sampstart:PROJimp.dwell:PROJimp.tro);    

%----------------------------------------------------
% Return
%----------------------------------------------------
KSMP.samp = samp;
KSMP.Kmat = Kmat;
KSMP.Kend = Kend;

%----------------------------------------------------
% Panel
%----------------------------------------------------
if KSMP.rRadFirstStepMean > 0.35 || KSMP.rRadFirstStepMean < 0.15
    Panel(1,:) = {'rRadFirstStepMean',KSMP.rRadFirstStepMean,'OutputWarn'};
else
    Panel(1,:) = {'rRadFirstStepMean',KSMP.rRadFirstStepMean,'Output'};
end
if KSMP.rRadFirstStepMax > 0.4
    Panel(2,:) = {'rRadFirstStepMax',KSMP.rRadFirstStepMax,'OutputWarn'};
else
    Panel(2,:) = {'rRadFirstStepMax',KSMP.rRadFirstStepMax,'Output'};
end
Panel(3,:) = {'rRadSecondStepMean',KSMP.rRadSecondStepMean,'Output'};
if KSMP.rRadStepMax > 0.8
    Panel(4,:) = {'rRadStepMax',KSMP.rRadStepMax,'OutputWarn'};
else
    Panel(4,:) = {'rRadStepMax',KSMP.rRadStepMax,'Output'};
end
Panel(5,:) = {'meanrelkmax',KSMP.meanrelkmax,'Output'};
Panel(6,:) = {'rSNR',KSMP.rSNR,'Output'};
PanelOutput = cell2struct(Panel,{'label','value','type'},2);
KSMP.PanelOutput = PanelOutput;

Status2('done','',2);
Status2('done','',3);


    
    