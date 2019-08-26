%=========================================================
% 
%=========================================================

function [TST,err] = SSStateT1CnrAnlz_v1a_Func(TST,INPUT)

Status2('busy','Contrast to Noise Analysis',2);
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
Tro = TST.Tro;
TR = TST.TR;
flip = TST.Flip;

%---------------------------------------------
% Solve
%---------------------------------------------
for n = 1:2
    top = sin((pi*flip/180).')*(1-exp(-TR/T1(n)));
    bot = 1 - cos((pi*flip/180).')*exp(-TR/T1(n));
    Sig(:,:,n) = top./bot;
end
%---
%Sig(:,:,1) = Sig(:,:,1)*1.1;                   % 1H density test
%---
SigDif = (Sig(:,:,2)-Sig(:,:,1));

%---------------------------------------------
% Solve
%---------------------------------------------
SampDutyCycle = Tro./TR;
rNoise = sqrt(1./SampDutyCycle);
CNR = SigDif./rNoise;

%----------------------------------------------------
% CNR
%----------------------------------------------------
fig = 0;
hFig = figure(103); hold on;
%CNR0 = 0.00905;
CNR0 = 0.01634;
plot(TR,CNR/CNR0,'*');
xlim([10 25]);
ylim([0.9 2]);
xlabel('TR')
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

%---------------------------------------------
% Add to Panel Output
%---------------------------------------------
Panel(1,:) = {'','','Output'};
Panel(2,:) = {'',TST.method,'Output'};
TST.Panel = Panel;

Status2('done','',2);
Status2('done','',3);


