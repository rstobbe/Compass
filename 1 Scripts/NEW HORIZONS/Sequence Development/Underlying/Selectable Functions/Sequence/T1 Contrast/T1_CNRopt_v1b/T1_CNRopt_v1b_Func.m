%=========================================================
% 
%=========================================================

function [TST,err] = T1_CNRopt_v1b_Func(TST,INPUT)

Status2('busy','Contrast to Noise Optimization',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
T1 = INPUT.T1;
clear INPUT;

%---------------------------------------------
% Arrays
%---------------------------------------------
maxTR = 25;
maxFlip = 35;
TR = 4:0.025:maxTR;
flip = 0.1:0.05:maxFlip;

%---------------------------------------------
% Markers
%---------------------------------------------
ind1 = find(TR*10 == TST.trmark*10);
ind2 = find(round(flip*10) == round(TST.flipmark*10));
ernst1 = (180/pi)*acos(exp(-TST.trmark/T1(1)))
ernst2 = (180/pi)*acos(exp(-TST.trmark/T1(2)))

%---------------------------------------------
% Solve
%---------------------------------------------
sig = [];
for n = 1:2
    top = sin((pi*flip/180).')*(1-exp(-TR/T1(n)));
    bot = 1 - cos((pi*flip/180).')*exp(-TR/T1(n));
    sig(:,:,n) = top./bot;
end
NonAcqTime = 3.5;
PropListenTime = (TR-NonAcqTime)./TR;
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
Rel = WM./GM;

fh = figure(102);
fh.Position = [150 50 1600 900];
ax = subplot(2,3,1); hold on;
ax.Position = [0.033 0.55 0.29 0.4];
imshow(WM,[0 max(WM(:))]);
colormap(ax,'jet');
plot(ind1,ind2,'w*');
ax.Visible = 'On';
ax.XTick = interp1(TR,1:length(TR),(4:2:maxTR));
ax.XTickLabel = (4:2:maxTR);
ax.XLim = [1 length(TR)];
xlabel('TR (ms)');
ax.YTick = interp1(flip,1:length(flip),(5:5:maxFlip));
ax.YTickLabel = (5:5:maxFlip);
ax.YLim = [1 length(flip)];
colorbar;
ylabel('Flip (degrees)');
title('Signal (Tissue2 - presumably WM)');

ax = subplot(2,3,2); hold on;
ax.Position = [0.366 0.55 0.29 0.4];
imshow(WMSNR/max(WMSNR(:)));
colormap(ax,'jet');
plot(ind1,ind2,'w*');
ax = gca;
ax.Visible = 'On';
ax.XTick = interp1(TR,1:length(TR),(4:2:maxTR));
ax.XTickLabel = (4:2:maxTR);
ax.XLim = [1 length(TR)];
xlabel('TR (ms)');
ax.YTick = interp1(flip,1:length(flip),(5:5:maxFlip));
ax.YTickLabel = (5:5:maxFlip);
ax.YLim = [1 length(flip)];
colorbar;
ylabel('Flip (degrees)');
title('Relative SNR (Tissue2 - presumably WM)');

ax = subplot(2,3,3); hold on;
ax.Position = [0.7 0.55 0.29 0.4];
imshow(Dif,[0 max(Dif(:))]);
colormap(ax,'jet');
plot(ind1,ind2,'w*');
ax = gca;
ax.Visible = 'On';
ax.XTick = interp1(TR,1:length(TR),(4:2:maxTR));
ax.XTickLabel = (4:2:maxTR);
ax.XLim = [1 length(TR)];
xlabel('TR (ms)');
ax.YTick = interp1(flip,1:length(flip),(5:5:maxFlip));
ax.YTickLabel = (5:5:maxFlip);
ax.YLim = [1 length(flip)];
colorbar;
ylabel('Flip (degrees)');
title('Signal Difference');

ax = subplot(2,3,4); hold on;
ax.Position = [0.033 0.05 0.29 0.4];
imshow(CNR/max(CNR(:)));
colormap(ax,'jet');
plot(ind1,ind2,'w*');
ax = gca;
ax.Visible = 'On';
ax.XTick = interp1(TR,1:length(TR),(4:2:maxTR));
ax.XTickLabel = (4:2:maxTR);
ax.XLim = [1 length(TR)];
xlabel('TR (ms)');
ax.YTick = interp1(flip,1:length(flip),(5:5:maxFlip));
ax.YTickLabel = (5:5:maxFlip);
ax.YLim = [1 length(flip)];
colorbar;
ylabel('Flip (degrees)');
title('Relative CNR');

ax = subplot(2,3,5); hold on;
ax.Position = [0.366 0.05 0.29 0.4];
imshow(Rel,[min(Rel(:)) max(Rel(:))]);
colormap(ax,'jet');
plot(ind1,ind2,'w*');
ax = gca;
ax.Visible = 'On';
ax.XTick = interp1(TR,1:length(TR),(4:2:maxTR));
ax.XTickLabel = (4:2:maxTR);
ax.XLim = [1 length(TR)];
xlabel('TR (ms)');
ax.YTick = interp1(flip,1:length(flip),(5:5:maxFlip));
ax.YTickLabel = (5:5:maxFlip);
ax.YLim = [1 length(flip)];
colorbar;
ylabel('Flip (degrees)');
title('WM relative to GM');


Status2('done','',2);
Status2('done','',3);


