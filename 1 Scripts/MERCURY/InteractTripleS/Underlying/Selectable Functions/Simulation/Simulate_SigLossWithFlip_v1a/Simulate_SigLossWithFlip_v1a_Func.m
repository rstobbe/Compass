%======================================================
% 
%======================================================

function [SIM,err] = Simulate_SigLossWithFlip_v1a_Func(SIM,INPUT)

Status2('busy','Model Simulation',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
APP = INPUT.APP;
clear INPUT

%---------------------------------------------
% Simulate Setup
%---------------------------------------------
ElmNum = 1;
[Type,Dur,RfShape,Flip,Phase,Grad,PhaseCyc,Step] = APP.SIM.GetSequenceElement(ElmNum);
w1 = (1/Dur)*(Flip/360);

%---------------------------------------------
% Simulate Array
%---------------------------------------------
Flip = [1 5:5:90];
for n = 1:length(Flip)
    Dur = round(1000*(1/w1)*(Flip(n)/360))/1000;
    APP.SIM.SetSequenceElement(ElmNum,Type,Dur,RfShape,Flip(n),Phase,Grad,PhaseCyc,Step);
    APP.SIM.BuildSequence;
    Simulate(APP,[]);
    Val = APP.SIM.TeT11s;
    ValArr(n) = Val(SIM.modnum);
end
Weight = ValArr./sin(pi*Flip/180);    
Weight = Weight/100;

%---------------------------------------------
% Plot
%---------------------------------------------
hFig = figure(134560892); hold on; box on;
plot(Flip,Weight);
hAx = gca;

hFig.Units = 'Inches';
figloc = [8 6];
figsize = [3.5 3];
figarr = [figloc figsize];
hFig.Position = figarr;
hAx.Position = [0.175 0.175 0.7 0.7];
ylim([0.7 1]);
xlim([0 90]);
hAx.XTick = [0 30 60 90];

Figure.hFig = hFig;
Figure.hAx = hAx;
SaveGraphEps(Figure,'Figure');

%----------------------------------------------------
% Panel Items
%----------------------------------------------------
Panel(1,:) = {'','','Output'};
Panel(2,:) = {'Simulation',SIM.method,'Output'};
Panel(3,:) = {'Model',SIM.modnum,'Output'};
SIM.Panel = Panel;
SIM.PanelOutput = cell2struct(SIM.Panel,{'label','value','type'},2);

%----------------------------------------------------
% Return
%----------------------------------------------------
SIM.Time = Time;
SIM.Val = Val;
SIM.YLabel = 'M_x_y';

Status2('done','',2);
Status2('done','',3);