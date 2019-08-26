%======================================================
% 
%======================================================

function [REG,err] = Regression_MultiExp_v1a_Reg(REG,INPUT)

Status2('busy','Multi-Experiment Regression',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
EXP = INPUT.EXP;
MODTST = REG.MODTST;
clear INPUT

%---------------------------------------------
% Setup Model for Testing
%---------------------------------------------
func = str2func([MODTST.method,'_Func']);  
INPUT.EXP = EXP;
INPUT.Op = 'Setup';
[MODTST,err] = func(MODTST,INPUT);
if err.flag
    return
end

%---------------------------------------------
% Simulate Sequence
%---------------------------------------------
tEXP = EXP{1,1};
tEXP.BuildSequence;
tic
tEXP.Simulate;
toc
Vals = tEXP.TeT11s
error
tEXP.TeVal;


%----------------------------------------------------
% Panel Items
%----------------------------------------------------
Panel(1,:) = {'','','Output'};
Panel(2,:) = {'Method',REG.method,'Output'};
Panel(3,:) = {'Data',Data.file,'Output'};
Panel(4,:) = {'T1 (ms)',beta(3),'Output'};
Panel(5,:) = {'Inversion',beta(2),'Output'};
PanelOutput = cell2struct(Panel,{'label','value','type'},2);
REG.PanelOutput = PanelOutput;

Status2('done','',2);
Status2('done','',3);




