%==================================================
% (v1a)
%       
%==================================================

function [SCRPTipt,SCRPTGBL,err] = Regress_EddyCurrents_v1a(SCRPTipt,SCRPTGBL)

Status('busy','Regress Eddy Currents');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Clear Naming
%---------------------------------------------
inds = strcmp('EddyRegress_Name',{SCRPTipt.labelstr});
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
if not(isfield(SCRPTGBL,'EddyCurrent_File_Data'))
    if isfield(SCRPTGBL.CurrentTree.('EddyCurrent_File').Struct,'selectedfile')
        file = SCRPTGBL.CurrentTree.('EddyCurrent_File').Struct.selectedfile;
        if not(exist(file,'file'))
            err.flag = 1;
            err.msg = '(Re) Load EddyCurrent_File';
            ErrDisp(err);
            return
        else
            Status('busy','Load EddyCurrent_File');
            load(file);
            saveData.path = file;
            SCRPTGBL.('EddyCurrent_File_Data') = saveData;
        end
    else
        err.flag = 1;
        err.msg = '(Re) Load EddyCurrent_File';
        ErrDisp(err);
        return
    end
end

%---------------------------------------------
% Load Input
%---------------------------------------------
RGRS.method = SCRPTGBL.CurrentTree.Func;
RGRS.eddyregressfunc = SCRPTGBL.CurrentTree.('EddyRegressfunc').Func;

%---------------------------------------------
% Get Trajectory Design
%---------------------------------------------
test = SCRPTGBL.EddyCurrent_File_Data;
if isfield(test,'MFEVO');
    MFEVO = SCRPTGBL.EddyCurrent_File_Data.MFEVO;
elseif isfield(test,'RWS');
    MFEVO = SCRPTGBL.EddyCurrent_File_Data.RWS;    
else
    error
end

%---------------------------------------------
% Get Working Structures from Sub Functions
%---------------------------------------------
REGMETHipt = SCRPTGBL.CurrentTree.('EddyRegressfunc');
if isfield(SCRPTGBL,('EddyRegressfunc_Data'))
    REGMETHipt.EddyRegressfunc_Data = SCRPTGBL.EddyRegressfunc_Data;
end

%------------------------------------------
% Get Field Plot Info
%------------------------------------------
func = str2func(RGRS.eddyregressfunc);           
[SCRPTipt,REGMETH,err] = func(SCRPTipt,REGMETHipt);
if err.flag
    return
end

%---------------------------------------------
% Plot 
%---------------------------------------------
func = str2func([RGRS.method,'_Func']);
INPUT.MFEVO = MFEVO;
INPUT.REGMETH = REGMETH;
[RGRS,err] = func(RGRS,INPUT);
if err.flag
    return
end

%--------------------------------------------
% Output to TextBox
%--------------------------------------------
RGRS.ExpDisp = PanelStruct2Text(RGRS.PanelOutput);
global FIGOBJS
FIGOBJS.(SCRPTGBL.RWSUI.tab).Info.String = RGRS.ExpDisp;

%--------------------------------------------
% Return
%--------------------------------------------
name = '';
name = inputdlg('Name Regression:','Name',1,{name});
if isempty(name)
    SCRPTGBL.RWSUI.SaveGlobal = 'no';
    SCRPTGBL.RWSUI.SaveScriptOption = 'no';   
    return
end
RGRS.name = name{1};

SCRPTipt(indnum).entrystr = name;
SCRPTGBL.RWSUI.SaveVariables = {RGRS};
SCRPTGBL.RWSUI.SaveVariableNames = {'RGRS'};
SCRPTGBL.RWSUI.SaveGlobal = 'yes';
SCRPTGBL.RWSUI.SaveScriptOption = 'yes';  
SCRPTGBL.RWSUI.SaveGlobalNames = name;
SCRPTGBL.RWSUI.SaveScriptPath = 'outloc';
SCRPTGBL.RWSUI.SaveScriptName = name;

Status('done','');
Status2('done','',2);
Status2('done','',3);
