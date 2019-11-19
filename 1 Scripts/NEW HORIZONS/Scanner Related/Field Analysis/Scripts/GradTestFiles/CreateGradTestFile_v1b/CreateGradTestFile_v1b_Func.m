%=====================================================
% 
%=====================================================

function [IMP,err] = CreateGradTestFile_v1b_Func(IMP,INPUT)

Status('busy','Create Gradient Test File');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
SYSWRT = INPUT.SYSWRT;
GTSAMP = INPUT.GTSAMP;
GTDES = INPUT.GTDES;
clear INPUT

%---------------------------------------------
% Test Design
%---------------------------------------------
func = str2func([IMP.testdesfunc,'_Func']);
INPUT = [];
[GTDES,err] = func(GTDES,INPUT);
if err.flag
    return
end
clear INPUT

%---------------------------------------------
% Test Sampling
%---------------------------------------------
func = str2func([IMP.testsampfunc,'_Func']);
INPUT.IMP = [];
[GTSAMP,err] = func(GTSAMP,INPUT);
if err.flag
    return
end
mIMP = GTSAMP.IMP;
mIMP.GWFM = GTDES;
clear INPUT

%---------------------------------------------
% Update modified IMP structure
%---------------------------------------------
sz = size(GTDES.G);
mIMP.PROJimp.nproj = sz(1);
mIMP.path = 'Y:\2 Trajectories\';

%---------------------------------------------
% Write System
%---------------------------------------------
func = str2func([IMP.syswrtfunc,'_Func']);
INPUT.G = GTDES.G;
INPUT.IMP = mIMP;
INPUT.recononly = 'No';
[SYSWRT,err] = func(SYSWRT,INPUT);
if err.flag
    return
end
clear INPUT

%----------------------------------------------------
% Panel Items
%----------------------------------------------------
Panel(1,:) = {'','','Output'};
Panel(2,:) = {'Name',SYSWRT.name,'Output'};
PanelOutput = cell2struct(Panel,{'label','value','type'},2);
PanelOutput = [PanelOutput;GTDES.PanelOutput;GTSAMP.PanelOutput];

%---------------------------------------------
% Return
%---------------------------------------------
IMP = mIMP;
IMP.G = GTDES.G;
IMP.name = SYSWRT.name;
IMP.path = SYSWRT.path;
IMP.PanelOutput = PanelOutput;
IMP.Figure = GTDES.Figure;
IMP.GWFM = rmfield(IMP.GWFM,'Figure');


