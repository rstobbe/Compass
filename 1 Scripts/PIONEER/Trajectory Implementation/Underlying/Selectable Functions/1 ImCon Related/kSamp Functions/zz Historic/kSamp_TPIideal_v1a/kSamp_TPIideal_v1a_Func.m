%=====================================================
%   
%=====================================================

function [KSMP,err] = kSamp_Ideal_v1a_Func(KSMP,INPUT)

Status2('busy','Sample k-Space',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
PROJdgn = INPUT.PROJdgn;
TSMP = INPUT.TSMP;
KSA = INPUT.KSA;
T = INPUT.T;

%---------------------------------------------
% Common Variables
%---------------------------------------------
nproj = PROJdgn.nproj;
sampstart = TSMP.sampstart;
dwell = TSMP.dwell;
tro = TSMP.tro;
kmax = PROJdgn.kmax;
kstep = PROJdgn.kstep;

%---------------------------------------
% Resample k-Space
%---------------------------------------
samp = (sampstart:dwell:tro);
[L,~,~] = size(KSA);
Kmat = zeros(L,length(samp),3);
for n = 1:L
    Kmat(n,:,1) = interp1(T(n,:),KSA(n,:,1)*kmax,samp,'cubic','extrap');
    Kmat(n,:,2) = interp1(T(n,:),KSA(n,:,2)*kmax,samp,'cubic','extrap');
    Kmat(n,:,3) = interp1(T(n,:),KSA(n,:,3)*kmax,samp,'cubic','extrap');
end
if isnan(Kmat)
    error('NaN Problem');
end
  
%---------------------------------------
% Visuals
%---------------------------------------
Vis = 'On';
if strcmp(Vis,'On') 
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


    
    