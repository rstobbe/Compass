%=========================================================
% 
%=========================================================

function [TST,err] = SSStateTransient_v1a_Func(TST,INPUT)

Status2('busy','Spoiled Steady State Transient Analysis',2);
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
TR = TST.TR;
flip = TST.Flip;

%---------------------------------------------
% Solve
%---------------------------------------------
Mz0 = 1;
Mz = 1;
for n = 2:1000
    Mz(n) = cos(pi*flip/180)*Mz0(n-1);
    Mz0(n) = 1 - (1-Mz(n))*exp(-TR/T1);
end
    
%----------------------------------------------------
% CNR
%----------------------------------------------------
hFig = figure(103); hold on;
plot(Mz0)

hFig = figure(104); hold on;
plot(Mz0*sin(pi*flip/180),'b');
title('Mxy')


error

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
fig = 1;
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


