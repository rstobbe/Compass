%=========================================================
% 
%=========================================================

function [TST,err] = SSStateT1CnrOpt_v1a_Func(TST,INPUT)

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
minTR = TST.mintr;
maxFlip = 90;
%TR = 1.1:0.025:maxTR;
TR = minTR:0.025:maxTR;
flip = 0.1:0.01:maxFlip;

%---------------------------------------------
% Solve
%---------------------------------------------
Mz = [];
for n = 1:2
    top1 = (1-exp(-TR/T1(n)));
    top2 = sin((pi*flip/180).')*(1-exp(-TR/T1(n)));
    bot = 1 - cos((pi*flip/180).')*exp(-TR/T1(n));
    Mz(:,:,n) = top1./bot;
    Sig(:,:,n) = top2./bot;
end
%---
%Sig(:,:,1) = Sig(:,:,1)*1.1;                   % 1H density test
%---
MzDif = (Mz(:,:,2)-Mz(:,:,1));
SigDif = (Sig(:,:,2)-Sig(:,:,1));

%---------------------------------------------
% Solve
%---------------------------------------------
SampDutyCycle = (TR-TST.nonacqtime)./TR;
rNoise = repmat(sqrt(1./SampDutyCycle),length(flip),1);
CNR = SigDif./rNoise;

% figure(12346)
% plot(flip,CNR);

%---------------------------------------------
% Find Max CNR at TR
%---------------------------------------------
for n = 1:length(TR)
    BestCNRatTR(n) = max(CNR(:,n));
    FlipAtBestCNR(n) = flip(CNR(:,n)==max(CNR(:,n)));
    MzDifAtBestCNR(n) = MzDif(CNR(:,n)==max(CNR(:,n)),n);
    SigDifAtBestCNR(n) = SigDif(CNR(:,n)==max(CNR(:,n)),n);
    NoiseAtTR(n) = rNoise(1,n);
end

%----------------------------------------------------
% SigDiff
%----------------------------------------------------
hFig = figure(100); hold on;
plot(TR,SigDifAtBestCNR);
xlim([minTR maxTR]);
% ylim([0 0.04]);
% ylim([0.015 0.025]);
xlabel('TR')
ylabel('SigDif');
box on
hFig.Units = 'Inches';
%hFig.Position = [8 6 2.9 2.2];
hFig.Position = [8 6 3.8 3.0];
fig = 1;
TST.Figure(fig).Name = 'SigDiff';
TST.Figure(fig).Type = 'Graph';
TST.Figure(fig).hFig = hFig;
TST.Figure(fig).hAx = gca;

%----------------------------------------------------
% Flip
%----------------------------------------------------
hFig = figure(102); hold on;
plot(TR,FlipAtBestCNR);
xlim([minTR maxTR]);
% ylim([]);
xlabel('TR')
ylabel('Flip');
box on
hFig.Units = 'Inches';
%hFig.Position = [8 6 2.9 2.2];
hFig.Position = [8 6 3.8 3.0];
fig = fig+1;
TST.Figure(fig).Name = 'Flip';
TST.Figure(fig).Type = 'Graph';
TST.Figure(fig).hFig = hFig;
TST.Figure(fig).hAx = gca;

%----------------------------------------------------
% CNR
%----------------------------------------------------
hFig = figure(103); hold on;
%CNR0 = 0.00905;
%CNR0 = 0.016346;
%CNR0 = BestCNRatTR(1);
CNR0 = BestCNRatTR(41);
%plot(TR,BestCNRatTR/CNR0);
plot(TR-TST.nonacqtime,BestCNRatTR/CNR0);
xlim([minTR maxTR]-TST.nonacqtime);
ylim([0.85 2]);
xlabel('Tro')
ylabel('CNR');
box on
hFig.Units = 'Inches';
%hFig.Position = [8 6 2.9 2.2];
hFig.Position = [8 6 3.8 3.0];
hAx = gca;
hAx.YScale = 'log';
%hAx.YTick = [1 1.41 2 2.83];
fig = fig+1;
TST.Figure(fig).Name = 'CNR';
TST.Figure(fig).Type = 'Graph';
TST.Figure(fig).hFig = hFig;
TST.Figure(fig).hAx = gca;

%----------------------------------------------------
% Mz
%----------------------------------------------------
hFig = figure(104); hold on;
plot(TR,MzDifAtBestCNR);
xlim([minTR maxTR]);
% ylim([]);
xlabel('TR')
ylabel('MzDif');
box on
hFig.Units = 'Inches';
%hFig.Position = [8 6 2.9 2.2];
hFig.Position = [8 6 3.8 3.0];
fig = fig+1;
TST.Figure(fig).Name = 'Mz';
TST.Figure(fig).Type = 'Graph';
TST.Figure(fig).hFig = hFig;
TST.Figure(fig).hAx = gca;

%---------------------------------------------
% Add to Panel Output
%---------------------------------------------
Panel(1,:) = {'','','Output'};
Panel(2,:) = {'',TST.method,'Output'};
TST.Panel = Panel;

Status2('done','',2);
Status2('done','',3);


