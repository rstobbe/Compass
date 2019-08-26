%==================================================
% (v1a)
%       
%==================================================

function [SCRPTipt,SCRPTGBL,err] = Test_GradSysResponse_v1a(SCRPTipt,SCRPTGBL)

Status('busy','Test Gradient System Response Model');
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

if not(isfield(SCRPTGBL,'SysRespFIR_File_Data'))
    if isfield(SCRPTGBL.CurrentTree.('SysRespFIR_File').Struct,'selectedfile')
        file = SCRPTGBL.CurrentTree.('SysRespFIR_File').Struct.selectedfile;
        if not(exist(file,'file'))
            err.flag = 1;
            err.msg = '(Re) Load SysRespFIR_File';
            ErrDisp(err);
            return
        else
            Status('busy','Load SysRespFIR_File');
            load(file);
            saveData.path = file;
            SCRPTGBL.('SysRespFIR_File_Data').path = file;
        end
    else
        err.flag = 1;
        err.msg = '(Re) Load SysRespFIR_File';
        ErrDisp(err);
        return
    end
end

%---------------------------------------------
% Load Input
%---------------------------------------------
TSTMOD.method = SCRPTGBL.CurrentTree.Func;
TSTMOD.trajnum = str2double(SCRPTGBL.CurrentTree.('TrajNum'));

%---------------------------------------------
% Get Field Evolution
%---------------------------------------------
test = SCRPTGBL.FieldEvo_File_Data;
if isfield(test,'MFEVO');
    MFEVO = SCRPTGBL.FieldEvo_File_Data.MFEVO;
elseif isfield(test,'RWS');
    MFEVO = SCRPTGBL.FieldEvo_File_Data.RWS;
else
    error
end

MOD = SCRPTGBL.SysRespFIR_File_Data.GSYSMOD;

%---------------------------------------------
% Test Model
%---------------------------------------------
func = str2func([TSTMOD.method,'_Func']);
INPUT.MFEVO = MFEVO;
INPUT.MOD = MOD;
[TSTMOD,err] = func(TSTMOD,INPUT);
if err.flag
    return
end

%--------------------------------------------
% Output to TextBox
%--------------------------------------------
global FIGOBJS
FIGOBJS.(SCRPTGBL.RWSUI.tab).Info.String = TSTMOD.ExpDisp;

%--------------------------------------------
% Return
%--------------------------------------------
name = inputdlg('Name System Model Test:');
if isempty(name)
    SCRPTGBL.RWSUI.SaveGlobal = 'no';
    return
end
SCRPTipt(indnum).entrystr = cell2mat(name);

SCRPTGBL.RWSUI.SaveVariables = {TSTMOD};
SCRPTGBL.RWSUI.SaveVariableNames = {'TSTMOD'};
SCRPTGBL.RWSUI.SaveGlobal = 'yes';
SCRPTGBL.RWSUI.SaveGlobalNames = name;
SCRPTGBL.RWSUI.SaveScriptOption = 'yes';
SCRPTGBL.RWSUI.SaveScriptPath = 'outloc';
SCRPTGBL.RWSUI.SaveScriptName = name{1};



