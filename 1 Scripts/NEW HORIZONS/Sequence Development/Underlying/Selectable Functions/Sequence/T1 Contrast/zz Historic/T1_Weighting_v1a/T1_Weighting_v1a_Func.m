%=========================================================
% 
%=========================================================

function [DES,err] = T1_Contrast_v1a_Func(DES,INPUT)

Status('busy','T1 Sequence Contrast Development');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
TST = INPUT.TST;
clear INPUT;

%---------------------------------------------
% Reun
%---------------------------------------------
func = str2func([DES.testfunc,'_Func']);
INPUT.T1 = DES.T1;
[TST,err] = func(TST,INPUT);
if err.flag
    return
end
clear INPUT

%---------------------------------------------
% Add to Panel Output
%---------------------------------------------
Panel(1,:) = {'','','Output'};
Panel(2,:) = {'',DES.method,'Output'};
Panel(3,:) = {'T1 (Tissue1)',DES.T1(1),'Output'};
Panel(4,:) = {'T1 (Tissue2)',DES.T1(2),'Output'};
PanelOutput = cell2struct(Panel,{'label','value','type'},2);

DES.ExpDisp = [PanelStruct2Text(PanelOutput) TST.ExpDisp];

Status2('done','',2);
Status2('done','',3);


