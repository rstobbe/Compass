%==================================================
% (v1a)
%       
%==================================================

function [SCRPTipt,SCRPTGBL,err] = ModelFull_GradSysResponse_v1a(SCRPTipt,SCRPTGBL)

Status('busy','Model Gradient System Response');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Clear Naming
%---------------------------------------------
inds = strcmp('Model_Name',{SCRPTipt.labelstr});
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
if not(isfield(SCRPTGBL,'FieldEvoX_File_Data'))
    if isfield(SCRPTGBL.CurrentTree.('FieldEvoX_File').Struct,'selectedfile')
        file = SCRPTGBL.CurrentTree.('FieldEvoX_File').Struct.selectedfile;
        if not(exist(file,'file'))
            err.flag = 1;
            err.msg = '(Re) Load FieldEvoX_File';
            ErrDisp(err);
            return
        else
            Status('busy','Load FieldEvoX_File');
            load(file);
            saveData.path = file;
            SCRPTGBL.('FieldEvoX_File_Data') = saveData;
        end
    else
        err.flag = 1;
        err.msg = '(Re) Load FieldEvoX_File';
        ErrDisp(err);
        return
    end
end
if not(isfield(SCRPTGBL,'FieldEvoY_File_Data'))
    if isfield(SCRPTGBL.CurrentTree.('FieldEvoY_File').Struct,'selectedfile')
        file = SCRPTGBL.CurrentTree.('FieldEvoY_File').Struct.selectedfile;
        if not(exist(file,'file'))
            err.flag = 1;
            err.msg = '(Re) Load FieldEvoY_File';
            ErrDisp(err);
            return
        else
            Status('busy','Load FieldEvoY_File');
            load(file);
            saveData.path = file;
            SCRPTGBL.('FieldEvoY_File_Data') = saveData;
        end
    else
        err.flag = 1;
        err.msg = '(Re) Load FieldEvoY_File';
        ErrDisp(err);
        return
    end
end
if not(isfield(SCRPTGBL,'FieldEvoZ_File_Data'))
    if isfield(SCRPTGBL.CurrentTree.('FieldEvoZ_File').Struct,'selectedfile')
        file = SCRPTGBL.CurrentTree.('FieldEvoZ_File').Struct.selectedfile;
        if not(exist(file,'file'))
            err.flag = 1;
            err.msg = '(Re) Load FieldEvoZ_File';
            ErrDisp(err);
            return
        else
            Status('busy','Load FieldEvoZ_File');
            load(file);
            saveData.path = file;
            SCRPTGBL.('FieldEvoZ_File_Data') = saveData;
        end
    else
        err.flag = 1;
        err.msg = '(Re) Load FieldEvoZ_File';
        ErrDisp(err);
        return
    end
end

%---------------------------------------------
% Load Input
%---------------------------------------------
GSYSMOD.method = SCRPTGBL.CurrentTree.Func;
GSYSMOD.modelfunc = SCRPTGBL.CurrentTree.('Modelfunc').Func;

%---------------------------------------------
% Get Trajectory Design
%---------------------------------------------
test = SCRPTGBL.FieldEvoX_File_Data;
if isfield(test,'MFEVO')
    MFEVOX = SCRPTGBL.FieldEvoX_File_Data.MFEVO;
elseif isfield(test,'RWS')
    MFEVOX = SCRPTGBL.FieldEvoX_File_Data.RWS;
else
    error
end
test = SCRPTGBL.FieldEvoY_File_Data;
if isfield(test,'MFEVO')
    MFEVOY = SCRPTGBL.FieldEvoY_File_Data.MFEVO;
elseif isfield(test,'RWS')
    MFEVOY = SCRPTGBL.FieldEvoY_File_Data.RWS;
else
    error
end
test = SCRPTGBL.FieldEvoZ_File_Data;
if isfield(test,'MFEVO')
    MFEVOZ = SCRPTGBL.FieldEvoZ_File_Data.MFEVO;
elseif isfield(test,'RWS')
    MFEVOZ = SCRPTGBL.FieldEvoZ_File_Data.RWS;
else
    error
end

%---------------------------------------------
% Get Working Structures from Sub Functions
%---------------------------------------------
MODipt = SCRPTGBL.CurrentTree.('Modelfunc');
if isfield(SCRPTGBL,('Modelfunc_Data'))
    MODipt.Modelfunc_Data = SCRPTGBL.Modelfunc_Data;
end

%------------------------------------------
% Get Model Info
%------------------------------------------
func = str2func(GSYSMOD.modelfunc);           
[SCRPTipt,MOD,err] = func(SCRPTipt,MODipt);
if err.flag
    return
end

%---------------------------------------------
% Solve Model
%---------------------------------------------
func = str2func([GSYSMOD.method,'_Func']);
INPUT.MFEVOX = MFEVOX;
INPUT.MFEVOY = MFEVOY;
INPUT.MFEVOZ = MFEVOZ;
INPUT.MOD = MOD;
[GSYSMOD,err] = func(GSYSMOD,INPUT);
if err.flag
    return
end

%--------------------------------------------
% Output to TextBox
%--------------------------------------------
global FIGOBJS
FIGOBJS.(SCRPTGBL.RWSUI.tab).Info.String = GSYSMOD.ExpDisp;

%--------------------------------------------
% Determine if AutoSave
%--------------------------------------------
auto = 0;
RWSUI = SCRPTGBL.RWSUI;
if isfield(RWSUI,'ExtRunInfo')
    auto = 1;
    if strcmp(RWSUI.ExtRunInfo.save,'no')
        SCRPTGBL.RWSUI.SaveScript = 'no';
        SCRPTGBL.RWSUI.SaveGlobal = 'no';
    elseif strcmp(RWSUI.ExtRunInfo.save,'all')
        SCRPTGBL.RWSUI.SaveScript = 'yes';
        SCRPTGBL.RWSUI.SaveGlobal = 'yes';
    elseif strcmp(RWSUI.ExtRunInfo.save,'global')
        SCRPTGBL.RWSUI.SaveScript = 'no';
        SCRPTGBL.RWSUI.SaveGlobal = 'yes';
    end
    name = ['FieldEvo_',RWSUI.ExtRunInfo.name];
else
    SCRPTGBL.RWSUI.SaveScriptOption = 'yes';
    SCRPTGBL.RWSUI.SaveGlobal = 'yes';
end

%--------------------------------------------
% Name
%--------------------------------------------
if auto == 0
    name = inputdlg('Name Analysis:','Name Analysis',1,{['SysRespFIR_']});
    name = cell2mat(name);
    if isempty(name)
        SCRPTGBL.RWSUI.SaveVariables = GSYSMOD;
        SCRPTGBL.RWSUI.KeepEdit = 'yes';
        return
    end
end

GSYSMOD.path = MFEVOX.path;
GSYSMOD.name = name;
GSYSMOD.type = 'Analysis';   

%---------------------------------------------
% Return
%---------------------------------------------
SCRPTipt(indnum).entrystr = GSYSMOD.name;
SCRPTGBL.RWSUI.SaveVariables = GSYSMOD;
SCRPTGBL.RWSUI.SaveVariableNames = 'GSYSMOD';
SCRPTGBL.RWSUI.SaveGlobalNames = GSYSMOD.name;
SCRPTGBL.RWSUI.SaveScriptPath = GSYSMOD.path;
SCRPTGBL.RWSUI.SaveScriptName = GSYSMOD.name;

Status('done','');
Status2('done','',2);
Status2('done','',3);