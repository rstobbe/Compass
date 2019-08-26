%======================================================
% 
%======================================================

function [SIM,err] = Simulate_2CompMxy_v1a_Func(SIM,INPUT)

Status2('busy','2 Compartment Simulation',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
APP = INPUT.APP;
clear INPUT

%---------------------------------------------
% Simulate
%---------------------------------------------
Simulate(APP,[]);

%---------------------------------------------
% Get Data (use first 2 models)
%---------------------------------------------
Model = 1;
[Time,Val(:,1)] = ReturnSpinEvolution(APP,Model,'T11');
Model = 2;
[Time,Val(:,2)] = ReturnSpinEvolution(APP,Model,'T11');  

%---------------------------------------------
% Combined
%---------------------------------------------
Val(:,3) = SIM.fcomp1*Val(:,1) + (1-SIM.fcomp1)*Val(:,2);
Val = Val*100;

%---------------------------------------------
% Weighting
%---------------------------------------------
AcqElm = APP.SIM.AcqElm;
ARR = APP.SIM.ARR;
if not(strcmp(APP.SIM.SEQ(1).Type,'Pulse'))
    err.flag = 1;
    err.msg = 'Excitation in first segment assumed';
    return
end
Flip = APP.SIM.SEQ(1).Flip;
FullMxy = sin(pi*Flip/180);
AcqStart = ARR.SegBounds(AcqElm);
ind = find(round(Time*1e6)==round(AcqStart*1e6));
SIM.Weight = (round(100*Val(ind,:)/FullMxy))/100;

%----------------------------------------------------
% Panel Items
%----------------------------------------------------
Panel(1,:) = {'','','Output'};
Panel(2,:) = {'Simulation',SIM.method,'Output'};
Panel(3,:) = {'%Comp1',SIM.fcomp1,'Output'};
Panel(4,:) = {'Mxy Weight',SIM.Weight,'Output'};
SIM.Panel = Panel;
SIM.PanelOutput = cell2struct(SIM.Panel,{'label','value','type'},2);

%----------------------------------------------------
% Return
%----------------------------------------------------
SIM.Time = Time;
SIM.Val = Val;
SIM.YLabel = 'Mxy';

Status2('done','',2);
Status2('done','',3);