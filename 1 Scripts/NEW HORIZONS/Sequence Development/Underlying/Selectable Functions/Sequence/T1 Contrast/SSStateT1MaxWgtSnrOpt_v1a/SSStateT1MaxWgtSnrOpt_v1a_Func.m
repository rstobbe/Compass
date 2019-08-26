%=========================================================
% 
%=========================================================

function [TST,err] = SSStateT1MaxWgtSnrOpt_v1a_Func(TST,INPUT)

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
% maxTR = 10;
% maxFlip = 2;
% TR = 2:0.01:maxTR;
% flip = 0.1:0.0025:maxFlip;
minTR = 1.5;
maxTR = 4;
minFlip = 0.5;
maxFlip = 2.5;
TR = minTR:0.0025:maxTR;
flip = minFlip:0.004:maxFlip;


%---------------------------------------------
% Markers
%---------------------------------------------
ind10 = find(TR*10 == TST.trmark*10);
ind20 = find(round(flip*1000) == round(TST.flipmark*1000));
trmark2 = 1.5;
flipmark2 = 1.5;
ind11 = find(TR*10 == trmark2*10);
ind21 = find(round(flip*1000) == round(flipmark2*1000));

%---------------------------------------------
% Solve
%---------------------------------------------
top = (1-exp(-TR/T1));
top = repmat(top,length(flip),1);
%top = sin((pi*flip/180).')*(1-exp(-TR/T1));
bot = 1 - cos((pi*flip/180).')*exp(-TR/T1);
Mz = top./bot;

%---------------------------------------------
% Plot (weighting)
%---------------------------------------------
fh = figure(102);
fh.Position = [150 50 1600 500];
ax = subplot(1,3,1); hold on;
ax.Position = [0.033 0.15 0.29 0.7];
imshow(Mz,[0.70 1],'Colormap',jet);
plot(ind10,ind20,'k*','MarkerSize',10,'LineWidth',2);
plot(ind11,ind21,'k+','MarkerSize',10,'LineWidth',2);
ax.Visible = 'On';
ax.XTick = interp1(TR,1:length(TR),(minTR:0.5:maxTR));
ax.XTickLabel = (minTR:0.5:maxTR);
ax.XLim = [1 length(TR)];
xlabel('TR (ms)');
ax.YTick = interp1(flip,1:length(flip),(minFlip:0.5:maxFlip));
ax.YTickLabel = (minFlip:0.5:maxFlip);
ax.YLim = [1 length(flip)];
colorbar;
ylabel('Flip (degrees)');
title('Relative Steady-State Mz Value');

%---------------------------------------------
% Plot (signal)
%---------------------------------------------
flipMat = repmat(flip,length(TR),1).';
Sig = sin(pi*flipMat/180).*Mz;

ax = subplot(1,3,2); hold on;
ax.Position = [0.366 0.15 0.29 0.7];
imshow(Sig,[0 0.04],'Colormap',jet);
plot(ind10,ind20,'k*','MarkerSize',10,'LineWidth',2);
plot(ind11,ind21,'k+','MarkerSize',10,'LineWidth',2);
ax.Visible = 'On';
ax.XTick = interp1(TR,1:length(TR),(minTR:0.5:maxTR));
ax.XTickLabel = (minTR:0.5:maxTR);
ax.XLim = [1 length(TR)];
xlabel('TR (ms)');
ax.YTick = interp1(flip,1:length(flip),(0.5:0.5:maxFlip));
ax.YTickLabel = (0.5:0.5:maxFlip);
ax.YLim = [1 length(flip)];
colorbar;
ylabel('Flip (degrees)');
title('Relative Signal');

%---------------------------------------------
% Plot Relative SNR
%---------------------------------------------
%NonAcqTime = 1.5;
NonAcqTime = 1.2;
PropListenTime = (TR-NonAcqTime)./TR;
rNoise = repmat(sqrt(1./PropListenTime),length(flip),1);
SNR = Sig./rNoise;

ax = subplot(1,3,3); hold on;
ax.Position = [0.7 0.15 0.29 0.7];
imshow(SNR/max(SNR(:)),[0 1],'Colormap',jet);
plot(ind10,ind20,'k*','MarkerSize',10,'LineWidth',2);
plot(ind11,ind21,'k+','MarkerSize',10,'LineWidth',2);
ax.Visible = 'On';
ax.XTick = interp1(TR,1:length(TR),(minTR:0.5:maxTR));
ax.XTickLabel = (minTR:0.5:maxTR);
ax.XLim = [1 length(TR)];
xlabel('TR (ms)');
ax.YTick = interp1(flip,1:length(flip),(0.5:0.5:maxFlip));
ax.YTickLabel = (0.5:0.5:maxFlip);
ax.YLim = [1 length(flip)];
colorbar;
ylabel('Flip (degrees)');
title('Relative SNR');







Status2('done','',2);
Status2('done','',3);


