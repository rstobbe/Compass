%=========================================================
% 
%=========================================================

function [STUDY,err] = SeqDev_v1a_Func(STUDY,INPUT)

Status('busy','Sequence Development');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
TST = INPUT.TST;
NMR = INPUT.NMR;
clear INPUT;

%---------------------------------------------
% NMR
%---------------------------------------------
func = str2func([NMR.method,'_Func']);
INPUT = [];
[NMR,err] = func(NMR,INPUT);
if err.flag
    return
end
clear INPUT

%---------------------------------------------
% Run
%---------------------------------------------
func = str2func([TST.method,'_Func']);
INPUT.NMR = NMR;
[TST,err] = func(TST,INPUT);
if err.flag
    return
end
clear INPUT
if isfield(TST,'Figure')
    STUDY.Figure = TST.Figure;
end

%---------------------------------------------
% Add to Panel Output
%---------------------------------------------
Panel(1,:) = {'','','Output'};
Panel(2,:) = {'',STUDY.method,'Output'};

STUDY.Panel = [Panel;TST.Panel];
STUDY.PanelOutput = cell2struct(STUDY.Panel,{'label','value','type'},2);
STUDY.ExpDisp = PanelStruct2Text(STUDY.PanelOutput);

Status2('done','',2);
Status2('done','',3);


