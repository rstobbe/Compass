%===========================================================================================
% (v1f)
%     - Start of update for separated function / input
%===========================================================================================

function [SCRPTipt,SCRPTGBL,err] = SDC_DblConv_v1f(SCRPTipt,SCRPTGBL)

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
SDCS.CTFfunc = SCRPTGBL.CurrentTree.('CTFVatSPfunc').Func;
SDCS.InitialEstfunc = SCRPTGBL.CurrentTree.('InitialEstfunc').Func;
SDCS.Iteratefunc = SCRPTGBL.CurrentTree.('Iteratefunc').Func;

%---------------------------------------------
% Load Implementation and Kernel
%---------------------------------------------
PROJdgn = SCRPTGBL.Imp_File_Data.IMP.impPROJdgn;
PROJimp = SCRPTGBL.Imp_File_Data.IMP.PROJimp;
Kmat = SCRPTGBL.Imp_File_Data.IMP.Kmat;
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
CTF = SCRPTGBL.CurrentTree.('CTFVatSPfunc');
if isfield(SCRPTGBL,('CTFVatSPfunc_Data'))
    CTF.CTFVatSPfunc_Data = SCRPTGBL.CTFVatSPfunc_Data;
end
IE = SCRPTGBL.CurrentTree.('InitialEstfunc');
if isfield(SCRPTGBL,('InitialEstfunc_Data'))
    IE.InitialEstfunc_Data = SCRPTGBL.InitialEstfunc_Data;
end
IT = SCRPTGBL.CurrentTree.('Iteratefunc');
if isfield(SCRPTGBL,('Iteratefunc_Data'))
    IT.Iteratefunc_Data = SCRPTGBL.Iteratefunc_Data;
end

%------------------------------------------
% Get Output Transfer Function Info
%------------------------------------------
func = str2func(SDCS.TFfunc);           
[SCRPTipt,TFO,err] = func(SCRPTipt,TFOipt);
if err.flag
    return
end

%--------------------------------------
% Load Desired Output Transfer Function
%--------------------------------------
func = str2func([SDCS.TFfunc,'_Func']);
INPUT.PROJdgn = PROJdgn;
[TFO,err] = func(TFO,INPUT);
if err.flag
    return
end

%--------------------------------------
% Determine Convolved Transfer Function Values at Sampling Points
%--------------------------------------
Status('busy','Determine Convolved Transfer Function Values at Samp');
Status2('busy','',2);
Status2('busy','',3);
CTF.Kmat = Kmat;
CTF.PROJimp = PROJimp;
CTF.PROJdgn = PROJdgn;
CTF.TFO = TFO;
CTF.KRNprms = KRNprms;
func = str2func(SDCS.CTFfunc);
[SCRPTipt,CTF,err] = func(SCRPTipt,CTF);
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


