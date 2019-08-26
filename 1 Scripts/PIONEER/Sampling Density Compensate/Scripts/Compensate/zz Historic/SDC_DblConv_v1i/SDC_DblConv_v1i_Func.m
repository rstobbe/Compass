%====================================================
%
%====================================================

function [SDCS,err] = SDC_DblConv_v1i_Func(INPUT,SDCS)

Status('busy','Compensate Sampling Density');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Load Input
%---------------------------------------------
IMP = INPUT.IMP;
KRNprms = INPUT.KRNprms;
TFO = INPUT.TFO;
CTFV = INPUT.CTFV;
IE = INPUT.IE;
IT = INPUT.IT;
clear INPUT

%--------------------------------------
% Load Desired Output Transfer Function
%--------------------------------------
func = str2func([SDCS.TFfunc,'_Func']);
INPUT.IMP = IMP;
[TFO,err] = func(TFO,INPUT);
if err.flag
    return
end
clear INPUT

%--------------------------------------
% Initial Estimate
%--------------------------------------
func = str2func([SDCS.InitialEstfunc,'_Func']);
INPUT.IMP = IMP;
INPUT.TFO = TFO;
INPUT.CTFV = CTFV;                     
[IE,err] = func(IE,INPUT);
if err.flag
    return
end
clear INPUT

%--------------------------------------
% Determine Convolved Transfer Function Values at Sampling Points
%--------------------------------------
func = str2func([SDCS.CTFVfunc,'_Func']);
INPUT.IMP = IMP;
INPUT.TFO = TFO;
INPUT.KRNprms = KRNprms;
INPUT.SDCS = SDCS;
[CTFV,err] = func(CTFV,INPUT);
if err.flag
    return
end
clear INPUT

%--------------------------------------
% Sampling Density Compensate
%--------------------------------------
func = str2func([SDCS.Iteratefunc,'_Func']);
INPUT.IMP = IMP;
INPUT.CTFV = CTFV;
INPUT.IE = IE;
INPUT.KRNprms = KRNprms;
INPUT.SDCS = SDCS;
[IT,err] = func(IT,INPUT);
if err.flag
    return
end
clear INPUT

%----------------------------------------------------
% Panel Items
%----------------------------------------------------
Panel(1,:) = {'','','Output'};
Panel(2,:) = {'Imp_File',SDCS.ImpFile,'Output'};
Panel(3,:) = {'Kern_File',SDCS.KernFile,'Output'};
Panel(4,:) = {'SubSamp',SDCS.SubSamp,'Output'};
PanelOutput = cell2struct(Panel,{'label','value','type'},2);
SDCS.PanelOutput = PanelOutput;

%--------------------------------------------
% Output
%--------------------------------------------
SDCS.SDC = IT.SDC;
SDCS.W = IT.W;
SDCS.DOV = CTFV.DOV;
IT = rmfield(IT,{'SDC','W'});
SDCS.IT = IT;
SDCS.TFO = TFO;
CTFV = rmfield(CTFV,'DOV');
SDCS.CTFV = CTFV;
IE = rmfield(IE,'iSDC');
SDCS.IE = IE;




