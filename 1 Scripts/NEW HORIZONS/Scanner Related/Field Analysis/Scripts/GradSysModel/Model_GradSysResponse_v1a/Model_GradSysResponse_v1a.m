%==================================================
% (v1a)
%       
%==================================================

function [SCRPTipt,SCRPTGBL,err] = Model_GradSysResponse_v1a(SCRPTipt,SCRPTGBL)

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
if not(isfield(SCRPTGBL,'FieldEvo_File_Data'))
    if isfield(SCRPTGBL.CurrentTree.('FieldEvo_File').Struct,'selectedfile')
        file = SCRPTGBL.CurrentTree.('FieldEvo_File').Struct.selectedfile;
        if not(exist(file,'file'))
            err.flag = 1;
            err.msg = '(Re) Load FieldEvo_File';
            ErrDisp(err);
            return
        else
            Status('busy','Load FieldEvo_File');
            load(file);
            saveData.path = file;
            SCRPTGBL.('FieldEvo_File_Data').path = file;
        end
    else
        err.flag = 1;
        err.msg = '(Re) Load FieldEvo_File';
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
test = SCRPTGBL.FieldEvo_File_Data;
if isfield(test,'MFEVO');
    MFEVO = SCRPTGBL.FieldEvo_File_Data.MFEVO;
elseif isfield(test,'RWS');
    MFEVO = SCRPTGBL.FieldEvo_File_Data.RWS;
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
INPUT.MFEVO = MFEVO;
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



