%=========================================================
% (v1a) 
%       - 
%=========================================================

function [SCRPTipt,SCRPTGBL,err] = CreateGriddedPSF_v1a(SCRPTipt,SCRPTGBL)

Status('busy','Create Gridded PSF');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Clear Naming
%---------------------------------------------
inds = strcmp('PSF_Name',{SCRPTipt.labelstr});
indnum = find(inds==1);
if length(indnum) > 1
    indnum = indnum(SCRPTGBL.RWSUI.scrptnum);
end
SCRPTipt(indnum).entrystr = '';
setfunc = 1;
DispScriptParam(SCRPTipt,setfunc,SCRPTGBL.RWSUI.tab,SCRPTGBL.RWSUI.panelnum);

%---------------------------------------------
% Tests
%---------------------------------------------
if not(isfield(SCRPTGBL,'Imp_File_Data'))
    if isfield(SCRPTGBL.CurrentTree.('Imp_File').Struct,'selectedfile')
        file = SCRPTGBL.CurrentTree.('Imp_File').Struct.selectedfile;
        if not(exist(file,'file'))
            err.flag = 1;
            err.msg = '(Re) Load Imp_File';
            ErrDisp(err);
            return
        else
            Status2('busy','Load Imp_File',2);
            load(file);
            saveData.path = file;
            SCRPTGBL.('Imp_File_Data') = saveData;
        end
    else
        err.flag = 1;
        err.msg = '(Re) Load Imp_File';
        ErrDisp(err);
        return
    end
end
if not(isfield(SCRPTGBL,'SDC_File_Data'))
    if isfield(SCRPTGBL.CurrentTree.('SDC_File').Struct,'selectedfile')
        file = SCRPTGBL.CurrentTree.('SDC_File').Struct.selectedfile;
        if not(exist(file,'file'))
            err.flag = 1;
            err.msg = '(Re) Load SDC_File';
            ErrDisp(err);
            return
        else
            load(file);
            saveData.path = file;
            SCRPTGBL.('SDC_File_Data') = saveData;
        end
    else
        err.flag = 1;
        err.msg = '(Re) Load SDC_File';
        ErrDisp(err);
        return
    end
end
if not(isfield(SCRPTGBL,'InvFilt_File_Data'))
    if isfield(SCRPTGBL.CurrentTree.('InvFilt_File').Struct,'selectedfile')
        file = SCRPTGBL.CurrentTree.('InvFilt_File').Struct.selectedfile;
        if not(exist(file,'file'))
            err.flag = 1;
            err.msg = '(Re) Load InvFilt_File';
            ErrDisp(err);
            return
        else
            load(file);
            saveData.path = file;
            SCRPTGBL.('InvFilt_File_Data') = saveData;
        end
    else
        err.flag = 1;
        err.msg = '(Re) Load InvFilt_File';
        ErrDisp(err);
        return
    end
end

%---------------------------------------------
% Load Input
%---------------------------------------------
CREATE.script = SCRPTGBL.CurrentTree.Func;
CREATE.gridfunc = SCRPTGBL.CurrentTree.('Gridfunc').Func;
CREATE.effectaddfunc = SCRPTGBL.CurrentTree.('EffectAddfunc').Func;
IMP = SCRPTGBL.Imp_File_Data.IMP;
SDCS = SCRPTGBL.SDC_File_Data.SDCS;
INVF = SCRPTGBL.InvFilt_File_Data.IFprms;

%---------------------------------------------
% Get Working Structures from Sub Functions
%---------------------------------------------
EFCTipt = SCRPTGBL.CurrentTree.('EffectAddfunc');
if isfield(SCRPTGBL,('EffectAddfunc_Data'))
    EFCTipt.EffectAddfunc_Data = SCRPTGBL.EffectAddfunc_Data;
end
GRDUipt = SCRPTGBL.CurrentTree.('Gridfunc');
if isfield(SCRPTGBL,('Gridfunc_Data'))
    GRDUipt.Gridfunc_Data = SCRPTGBL.Gridfunc_Data;
end

%------------------------------------------
% Get Gridding Function Info
%------------------------------------------
func = str2func(CREATE.gridfunc);           
[SCRPTipt,GRDU,GRDU_Data,err] = func(SCRPTipt,GRDUipt);
if err.flag
    return
end
SCRPTGBL.Gridfunc_Data = GRDU_Data;

%------------------------------------------
% Get Effect Function Info
%------------------------------------------
func = str2func(CREATE.effectaddfunc);           
[SCRPTipt,EFCT,err] = func(SCRPTipt,EFCTipt);
if err.flag
    return
end

%---------------------------------------------
% Grid
%---------------------------------------------
func = str2func([CREATE.script,'_Func']);
INPUT.IMP = IMP;
INPUT.SDCS = SDCS;
INPUT.GRDU = GRDU;
INPUT.EFCT = EFCT;
INPUT.INVF = INVF;
[CREATE,err] = func(INPUT,CREATE);
if err.flag
    return
end
clear INPUT;
TF = CREATE;

%--------------------------------------------
% Output to TextBox
%--------------------------------------------
%TF.ExpDisp = PanelStruct2Text(TF.PanelOutput);
TF.ExpDisp = '';
global FIGOBJS
FIGOBJS.(SCRPTGBL.RWSUI.tab).Info.String = TF.ExpDisp;

%--------------------------------------------
% Name
%--------------------------------------------
name0 = '';
if isfield(IMP,'name')
    name0 = IMP.name(5:end);
end
name = inputdlg('Name TF:','Name TF',1,{['TF_',name0]});
name = cell2mat(name);
if isempty(name)
    SCRPTGBL.RWSUI.SaveVariables = {TF};
    SCRPTGBL.RWSUI.KeepEdit = 'yes';
    return
end
TF.name = name;
TF.path = IMP.path;
TF.type = 'Data';   
TF.structname = 'TF';

%---------------------------------------------
% Return
%---------------------------------------------
SCRPTipt(indnum).entrystr = name;
SCRPTGBL.RWSUI.SaveVariables = TF;
SCRPTGBL.RWSUI.SaveVariableNames = 'TF';
SCRPTGBL.RWSUI.SaveGlobal = 'yes';
SCRPTGBL.RWSUI.SaveGlobalNames = name;
SCRPTGBL.RWSUI.SaveScriptOption = 'yes';
SCRPTGBL.RWSUI.SaveScriptPath = TF.path;
SCRPTGBL.RWSUI.SaveScriptName = name;

Status('done','');
Status2('done','',2);
Status2('done','',3);
