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
if isfield(test,'MFEVO');
    MFEVOX = SCRPTGBL.FieldEvoX_File_Data.MFEVO;
elseif isfield(test,'RWS');
    MFEVOX = SCRPTGBL.FieldEvoX_File_Data.RWS;
else
    error
end
test = SCRPTGBL.FieldEvoY_File_Data;
if isfield(test,'MFEVO');
    MFEVOY = SCRPTGBL.FieldEvoY_File_Data.MFEVO;
elseif isfield(test,'RWS');
    MFEVOY = SCRPTGBL.FieldEvoY_File_Data.RWS;
else
    error
end
test = SCRPTGBL.FieldEvoZ_File_Data;
if isfield(test,'MFEVO');
    MFEVOZ = SCRPTGBL.FieldEvoZ_File_Data.MFEVO;
elseif isfield(test,'RWS');
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
% Return
%--------------------------------------------
name = inputdlg('Name System Model:');
if isempty(name)
    SCRPTGBL.RWSUI.SaveGlobal = 'no';
    return
end
SCRPTipt(indnum).entrystr = cell2mat(name);

SCRPTGBL.RWSUI.SaveVariables = {GSYSMOD};
SCRPTGBL.RWSUI.SaveVariableNames = {'GSYSMOD'};
SCRPTGBL.RWSUI.SaveGlobal = 'yes';
SCRPTGBL.RWSUI.SaveGlobalNames = name;
SCRPTGBL.RWSUI.SaveScriptOption = 'yes';
SCRPTGBL.RWSUI.SaveScriptPath = 'outloc';
SCRPTGBL.RWSUI.SaveScriptName = name{1};



