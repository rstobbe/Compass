%=========================================================
% 
%=========================================================

function [TST,err] = T1_CNRoptLine_v1a_Func(TST,INPUT)

Status2('busy','Contrast to Noise Optimization',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
T1 = INPUT.NMR.T1;
clear INPUT;

%---------------------------------------------
% Arrays
%---------------------------------------------
maxTR = TST.maxtr;
minTR = TST.nonacqtime + 1;
maxFlip = 90;
%TR = 1.1:0.025:maxTR;
TR = minTR:0.025:maxTR;
flip = 0.1:0.05:maxFlip;

%---------------------------------------------
% Solve
%---------------------------------------------
sig = [];
for n = 1:2
    top = sin((pi*flip/180).')*(1-exp(-TR/T1(n)));
    bot = 1 - cos((pi*flip/180).')*exp(-TR/T1(n));
    sig(:,:,n) = top./bot;
end
PropListenTime = (TR-TST.nonacqtime)./TR;
%PropListenTime = 1./TR;
rNoise = repmat(sqrt(1./PropListenTime),length(flip),1);

%---------------------------------------------
% Plot
%---------------------------------------------
Sig1 = sig(:,:,1);
Sig2 = sig(:,:,2);
GM = Sig1;                  % presumably
WM = Sig2;                  % presumably
WMSNR = WM./rNoise;
Dif = (Sig2-Sig1);
CNR = Dif./rNoise;
Rel = GM./WM;

%---------------------------------------------
% Find Max CNR at TR
%---------------------------------------------
for n = 1:length(TR)
    BestCNRatTR(n) = max(CNR(:,n));
    BestWMSNRatTR(n) = max(WMSNR(:,n));
    FlipAtBestCNR(n) = flip(CNR(:,n)==max(CNR(:,n)));
    WMAtBestCNR(n) = WM(CNR(:,n)==max(CNR(:,n)),n);
    DifAtBestCNR(n) = Dif(CNR(:,n)==max(CNR(:,n)),n);
    NoiseAtTR(n) = rNoise(1,n);
end

figure(99); hold on;
plot(TR,DifAtBestCNR);
xlim([minTR maxTR]);
%ylim([0.5 2]);
% h = gca;
% h.YScale = 'log';
% h.YTick = [0.25 0.35 0.5 0.71 1 1.41 2];
box on

figure(100); hold on;
%sclBestCNRatTR = BestCNRatTR/0.045;
%sclBestCNRatTR = BestCNRatTR/min(BestCNRatTR);
sclBestCNRatTR = BestCNRatTR/BestCNRatTR(TR==7);
plot(TR,sclBestCNRatTR);
xlim([minTR maxTR]);
ylim([0.5 2]);
h = gca;
h.YScale = 'log';
h.YTick = [0.25 0.35 0.5 0.71 1 1.41 2];
box on


figure(101); hold on;
plot(TR,FlipAtBestCNR);
xlim([minTR maxTR]);
box on

%---------------------------------------------
% Add to Panel Output
%---------------------------------------------
Panel(1,:) = {'','','Output'};
Panel(2,:) = {'',TST.method,'Output'};
Panel(3,:) = {'NonAcqTime (ms)',TST.nonacqtime,'Output'};
Panel(4,:) = {'MaxTR (ms)',TST.maxtr,'Output'};
TST.PanelOutput = cell2struct(Panel,{'label','value','type'},2);
TST.ExpDisp = PanelStruct2Text(TST.PanelOutput);

Status2('done','',2);
Status2('done','',3);


