%=====================================================
% 
%=====================================================

function [KSMP,err] = kSamp_noECI_v2p_Func(KSMP,INPUT)

Status2('busy','Sample k-Space',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
GWFM = INPUT.GWFM;
PROJdgn = INPUT.PROJdgn;
PROJimp = INPUT.PROJimp;
clear INPUT;

%---------------------------------------------
% Testing
%---------------------------------------------
KSMP.maxfreq = GWFM.G0wendmax*PROJimp.gamma*PROJdgn.fov/2;

%---------------------------------------------
% Resample k-Space
%---------------------------------------------
samp0 = [(PROJimp.sampstart:PROJimp.dwell:GWFM.totqTwend) GWFM.totqTwend];    
%[Kmat0,Kend] = ReSampleKSpace_v7a(GWFM.G0wend,GWFM.qTwend,samp0,PROJimp.gamma);
[Kmat0,Kend] = ReSampleKSpace_v7a(GWFM.Grecon,GWFM.qTrecon,samp0,PROJimp.gamma);
ind = find(round(samp0*1e9) == round(PROJimp.tro*1e9));
if isempty(ind)
    error('sampling problem');
end
samp = samp0(1:ind);
Kmat = Kmat0(:,1:ind,:);

%---------------------------------------------
% Test
%---------------------------------------------
maxKend = max(abs(Kend(:)));

%---------------------------------------------
% Visuals
%---------------------------------------------
if strcmp(KSMP.Vis,'Yes') 
    figure(2000); hold on; 
    plot(samp0,Kmat0(GWFM.TstTrj,:,1),'k*'); plot(samp0,Kmat0(GWFM.TstTrj,:,2),'k*'); plot(samp0,Kmat0(GWFM.TstTrj,:,3),'k*');
    plot(samp,Kmat(GWFM.TstTrj,:,1),'b*'); plot(samp,Kmat(GWFM.TstTrj,:,2),'g*'); plot(samp,Kmat(GWFM.TstTrj,:,3),'r*');
end

%---------------------------------------------
% Test Max Relative Radial Sampling Step
%---------------------------------------------
Rad = sqrt(Kmat(:,:,1).^2 + Kmat(:,:,2).^2 + Kmat(:,:,3).^2);
rRad = Rad/PROJdgn.kstep;
KSMP.rRadFirstStepMean = mean(rRad(:,1));
KSMP.rRadSecondStepMean = mean(rRad(:,2)-rRad(:,1));
KSMP.rRadFirstStepMax = max(rRad(:,1));
for n = 2:PROJimp.npro
    rRadStep(:,n) = rRad(:,n) - rRad(:,n-1);
end
KSMP.rRadStepMax = max(rRadStep(:));
KSMP.meanrelkmax = mean(Rad(:,length(Rad(1,:))))/PROJdgn.kmax;
KSMP.maxrelkmax = max(Rad(:,length(Rad(1,:))))/PROJdgn.kmax;
KSMP.rSNR = 1;

%---------------------------------------------
% Return Sampling Timing for Testing
%---------------------------------------------
rKmag(1,:) = ((Kmat(1,:,1).^2 + Kmat(1,:,2).^2 + Kmat(1,:,3).^2).^(1/2))/PROJdgn.kmax;
KSMP.rKmag = mean(rKmag,1);
KSMP.tatr = (PROJimp.sampstart:PROJimp.dwell:PROJimp.tro);    

%----------------------------------------------------
% Return
%----------------------------------------------------
KSMP.samp = samp;
KSMP.Kmat = Kmat;
KSMP.Kend = Kend;
KSMP.maxKend = maxKend;

%----------------------------------------------------
% Panel
%----------------------------------------------------
Panel(1,:) = {'rRadFirstStepMean',KSMP.rRadFirstStepMean,'Output'};
Panel(2,:) = {'rRadFirstStepMax',KSMP.rRadFirstStepMax,'Output'};
Panel(3,:) = {'rRadSecondStepMean',KSMP.rRadSecondStepMean,'Output'};
Panel(4,:) = {'rRadStepMax',KSMP.rRadStepMax,'Output'};
Panel(5,:) = {'meanrelkmax',KSMP.meanrelkmax,'Output'};
Panel(6,:) = {'rSNR',KSMP.rSNR,'Output'};
Panel(7,:) = {'maxkend',KSMP.maxKend,'Output'};
PanelOutput = cell2struct(Panel,{'label','value','type'},2);
KSMP.PanelOutput = PanelOutput;

Status2('done','',2);
Status2('done','',3);


    
    