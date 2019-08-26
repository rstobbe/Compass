%==================================================
% (v1a)
%       
%==================================================

function [SCRPTipt,SCRPTGBL,err] = Plot_EddyCurrents_v1a(SCRPTipt,SCRPTGBL)

Status('busy','Plot Eddy Currents');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Clear Naming
%---------------------------------------------
inds = strcmp('Plot_Name',{SCRPTipt.labelstr});
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
            Status('busy','Load Trajectory Implementation');
            load(file);
            saveData.path = file;
            SCRPTGBL.('EddyCurrent_File_Data').path = file;
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
PLOT.method = SCRPTGBL.CurrentTree.Func;
PLOT.fieldplotfunc = SCRPTGBL.CurrentTree.('EddyPlotfunc').Func;
PLOT.saveoption = SCRPTGBL.CurrentTree.('SaveOption');

%---------------------------------------------
% Get Trajectory Design
%---------------------------------------------
test = SCRPTGBL.EddyCurrent_File_Data;
if isfield(test,'MFEVO');
    MFEVO = SCRPTGBL.EddyCurrent_File_Data.MFEVO;
elseif isfield(test,'RWS');
    MFEVO = SCRPTGBL.EddyCurrent_File_Data.RWS;    
elseif isfield(test,'EDDY');
    MFEVO = SCRPTGBL.EddyCurrent_File_Data.EDDY;
elseif isfield(test,'ANLZ');
    MFEVO = SCRPTGBL.EddyCurrent_File_Data.ANLZ;
end

%---------------------------------------------
% Get Working Structures from Sub Functions
%---------------------------------------------
FPLTipt = SCRPTGBL.CurrentTree.('EddyPlotfunc');
if isfield(SCRPTGBL,('EddyPlotfunc_Data'))
    FPLTipt.EddyPlotfunc_Data = SCRPTGBL.EddyPlotfunc_Data;
end

%------------------------------------------
% Get Field Plot Info
%------------------------------------------
func = str2func(PLOT.fieldplotfunc);           
[SCRPTipt,FPLT,err] = func(SCRPTipt,FPLTipt);
if err.flag
    return
end

%---------------------------------------------
% Plot 
%---------------------------------------------
func = str2func([PLOT.method,'_Func']);
INPUT.MFEVO = MFEVO;
INPUT.FPLT = FPLT;
[PLOT,err] = func(PLOT,INPUT);
if err.flag
    return
end

%--------------------------------------------
% Return
%--------------------------------------------
if strcmp(PLOT.saveoption,'No')
    SCRPTGBL.RWSUI.SaveScriptOption = 'no';
    SCRPTGBL.RWSUI.SaveGlobal = 'no';
    return
else
    SCRPTGBL.RWSUI.SaveScriptOption = 'yes';    
end

name = '';
name = inputdlg('Name Plot:','Name',1,{name});
if isempty(name)
    SCRPTGBL.RWSUI.SaveGlobal = 'no';
    SCRPTGBL.RWSUI.SaveScriptOption = 'no';   
    return
end
PLOT.name = name{1};

SCRPTipt(indnum).entrystr = name;
SCRPTGBL.RWSUI.SaveVariables = {PLOT};
SCRPTGBL.RWSUI.SaveVariableNames = {'PLOT'};
SCRPTGBL.RWSUI.SaveGlobal = 'yes';
SCRPTGBL.RWSUI.SaveGlobalNames = name;
SCRPTGBL.RWSUI.SaveScriptPath = 'outloc';
SCRPTGBL.RWSUI.SaveScriptName = name;

Status('done','');
Status2('done','',2);
Status2('done','',3);
