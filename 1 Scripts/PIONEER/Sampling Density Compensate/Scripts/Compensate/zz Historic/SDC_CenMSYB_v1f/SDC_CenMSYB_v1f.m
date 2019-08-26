%===========================================================================================
% (v1f)
%     - Start of update for separated function / input
%===========================================================================================

function [SCRPTipt,SCRPTGBL,err] = SDC_CenMSYB_v1f(SCRPTipt,SCRPTGBL)

Status('busy','Compensate Sampling Density');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Tests
%---------------------------------------------
if not(isfield(SCRPTGBL,'Imp_File_Data'))
    err.flag = 1;
    err.msg = '(Re) Load Imp_File';
    ErrDisp(err);
    return
end
if not(isfield(SCRPTGBL,'Kern_File_Data'))
    file = SCRPTGBL.CurrentTree.('Kern_File').Struct.selectedfile;
    if not(exist(file,'file'))
        err.flag = 1;
        err.msg = '(Re) Load Kern_File';
        ErrDisp(err);
        return
    else
        Status('busy','Load Convolution Kernel');
        load(file);
        saveData.path = file;
        SCRPTGBL.('Kern_File_Data') = saveData;
    end
end

%---------------------------------------------
% Clear Naming
%---------------------------------------------
SCRPTipt(strcmp('SDC_Name',{SCRPTipt.labelstr})).entrystr = '';

%---------------------------------------------
% Load Input
%---------------------------------------------
SDCS.method = SCRPTGBL.CurrentTree.Func;
SDCS.Name = SCRPTGBL.CurrentTree.('SDC_Name');
SDCS.ImpFile = SCRPTGBL.CurrentTree.('Imp_File').Struct.selectedfile;
SDCS.SubSamp = str2double(SCRPTGBL.CurrentTree.('SubSamp'));
SDCS.KernFile = SCRPTGBL.CurrentTree.('Kern_File').Struct.selectedfile;
SDCS.TFfunc = SCRPTGBL.CurrentTree.('TFfunc').Func;
SDCS.CTFVfunc = SCRPTGBL.CurrentTree.('CTFVatSPfunc').Func;
SDCS.InitialEstfunc = SCRPTGBL.CurrentTree.('InitialEstfunc').Func;
SDCS.Iteratefunc = SCRPTGBL.CurrentTree.('Iteratefunc').Func;

%---------------------------------------------
% Load Implementation and Kernel
%---------------------------------------------
IMP = SCRPTGBL.Imp_File_Data.IMP;
KRNprms = SCRPTGBL.Kern_File_Data.KRNprms;

%--------------------------------------
% Tests
%--------------------------------------
if rem(round(1e9*(1/(KRNprms.DblKern.res*SDCS.SubSamp)))/1e9,1)
    err.flag = 1;
    err.msg = '1/(KernRes*SS) not an integer';
    return
end

%---------------------------------------------
% Get Working Structures from Sub Functions
%---------------------------------------------
TFOipt = SCRPTGBL.CurrentTree.('TFfunc');
if isfield(SCRPTGBL,('TFfunc_Data'))
    TFOipt.TFfunc_Data = SCRPTGBL.TFfunc_Data;
end
CTFVipt = SCRPTGBL.CurrentTree.('CTFVatSPfunc');
if isfield(SCRPTGBL,('CTFVatSPfunc_Data'))
    CTFVipt.CTFVatSPfunc_Data = SCRPTGBL.CTFVatSPfunc_Data;
end
IEipt = SCRPTGBL.CurrentTree.('InitialEstfunc');
if isfield(SCRPTGBL,('InitialEstfunc_Data'))
    IEipt.InitialEstfunc_Data = SCRPTGBL.InitialEstfunc_Data;
end
ITipt = SCRPTGBL.CurrentTree.('Iteratefunc');
if isfield(SCRPTGBL,('Iteratefunc_Data'))
    ITipt.Iteratefunc_Data = SCRPTGBL.Iteratefunc_Data;
end

%------------------------------------------
% Get Output Transfer Function Info
%------------------------------------------
func = str2func(SDCS.TFfunc);           
[SCRPTipt,TFO,err] = func(SCRPTipt,TFOipt);
if err.flag
    return
end

%------------------------------------------
% Get CTFV Function Info
%------------------------------------------
func = str2func(SDCS.CTFVfunc);           
[SCRPTipt,CTFV,err] = func(SCRPTipt,CTFVipt);
if err.flag
    return
end

%------------------------------------------
% Get IE Function Info
%------------------------------------------
func = str2func(SDCS.InitialEstfunc);           
[SCRPTipt,IE,err] = func(SCRPTipt,IEipt);
if err.flag
    return
end

%------------------------------------------
% Get IT Function Info
%------------------------------------------
func = str2func(SDCS.Iteratefunc);           
[SCRPTipt,IT,err] = func(SCRPTipt,ITipt);
if err.flag
    return
end

%------------------------------------------
% Run SDC
%------------------------------------------
func = str2func([SDCS.method,'_Func']);
INPUT.SDCS = SDCS;
INPUT.IMP = IMP;
INPUT.KRNprms = KRNprms;
INPUT.TFO = TFO;
INPUT.CTFV = CTFV;
INPUT.IE = IE;
INPUT.IT = IT;
[SDCS,err] = func(INPUT);
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
SDCS.CTFV = CTFV;
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


