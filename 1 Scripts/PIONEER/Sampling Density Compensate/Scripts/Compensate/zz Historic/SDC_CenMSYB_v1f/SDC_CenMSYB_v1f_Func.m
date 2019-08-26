%====================================================
%
%====================================================

function [SDCS,err] = SDC_CenMSYB_v1f_Func(INPUT)

Status('busy','Compensate Sampling Density');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Load Input
%---------------------------------------------
SDCS = INPUT.SDCS;
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
% Determine Convolved Transfer Function Values at Sampling Points
%--------------------------------------
func = str2func([SDCS.CTFVfunc,'_Func']);
INPUT.IMP = IMP;
INPUT.TFO = TFO;
INPUT.KRNprms = KRNprms;
[CTFV,err] = func(CTFV,INPUT);
if err.flag
    return
end

%--------------------------------------
% Initial Estimate
%--------------------------------------
Status('busy','Initial Estimate');
Status2('busy','',2);
Status2('busy','',3);
IE.Kmat = Kmat;
IE.PROJimp = PROJimp;
IE.PROJdgn = PROJdgn;
func = str2func(SDCS.InitialEstfunc);
[SCRPTipt,IE,err] = func(SCRPTipt,IE);
if err.flag
    return
end

%--------------------------------------
% Sampling Density Compensate
%--------------------------------------
Status('busy','Perform SDC Iterations');
Status2('busy','',2);
Status2('busy','',3);
IT.Kmat = Kmat;
IT.PROJimp = PROJimp;
IT.PROJdgn = PROJdgn;
IT.CTF = CTF;
IT.IE = IE;
IT.KRNprms = KRNprms;
IT.SDCS = SDCS;
func = str2func(SDCS.Iteratefunc); 
[SCRPTipt,IT,err] = func(SCRPTipt,IT,err);
if err.flag
    return
end

%--------------------------------------------
% Panel
%--------------------------------------------

%--------------------------------------------
% Output
%--------------------------------------------
SDCS.SDC = IT.SDC;
SDCS.TFO = TFO;
SDCS.CTF = CTF;
SDCS.IT = IT;

%--------------------------------------------
% Return
%--------------------------------------------
name = inputdlg('Name SDC:');
if isempty(name)
    SCRPTGBL.RWSUI.SaveGlobal = 'no';
    return
end
SCRPTipt(strcmp('SDC_Name',{SCRPTipt.labelstr})).entrystr = cell2mat(name);

SCRPTGBL.RWSUI.SaveVariables = {SDCS};
SCRPTGBL.RWSUI.SaveVariableNames = 'SDCS';

SCRPTGBL.RWSUI.SaveGlobal = 'yes';
SCRPTGBL.RWSUI.SaveGlobalNames = name;
SCRPTGBL.RWSUI.SaveScriptOption = 'yes';
SCRPTGBL.RWSUI.SaveScriptPath = 'outloc';
SCRPTGBL.RWSUI.SaveScriptName = 'SDC';

Status('done','');
Status2('done','',2);
Status2('done','',3);


