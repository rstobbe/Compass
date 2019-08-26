%=====================================================
% (v1a) 
%        
%=====================================================

function [SCRPTipt,SCRPTGBL,err] = PLOT_OB_IRS_atVOI_relationship_v1a(SCRPTipt,SCRPTGBL)

Status('busy','Plot OB - IRS @ VOI relationship');
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
if not(isfield(SCRPTGBL,'OBarr_File_Data'))
    if isfield(SCRPTGBL.CurrentTree.('OBarr_File').Struct,'selectedfile')
    file = SCRPTGBL.CurrentTree.('OBarr_File').Struct.selectedfile;
        if not(exist(file,'file'))
            err.flag = 1;
            err.msg = '(Re) Load OBarr_File - path no longer valid';
            ErrDisp(err);
            return
        else
            Status('busy','Load OBarr_File');
            load(file);
            saveData.path = file;
            SCRPTGBL.('OBarr_File_Data') = saveData;
        end
    else
        err.flag = 1;
        err.msg = '(Re) Load OBarr_File';
        ErrDisp(err);
        return
    end
end

%---------------------------------------------
% Get Input
%---------------------------------------------
PLOT.method = SCRPTGBL.CurrentTree.Func;

%---------------------------------------------
% Load Implementation
%---------------------------------------------
ANLZ = SCRPTGBL.OBarr_File_Data.ANLZ;

%---------------------------------------------
% Perform Analysis
%---------------------------------------------
func = str2func([PLOT.method,'_Func']);
INPUT.ANLZ = ANLZ;
[PLOT,err] = func(PLOT,INPUT);
if err.flag
    return
end
clear INPUT;

%--------------------------------------------
% Output to TextBox
%--------------------------------------------
global FIGOBJS
FIGOBJS.(SCRPTGBL.RWSUI.tab).Info.String = PLOT.ExpDisp;

%--------------------------------------------
% Name
%--------------------------------------------
name = 'PlotOBarr_';

%--------------------------------------------
% Return
%--------------------------------------------
name = inputdlg('Name Plot:','Name',1,{name});
if isempty(name)
    SCRPTGBL.RWSUI.SaveGlobal = 'no';
    return
end
PLOT.name = name{1};

SCRPTipt(indnum).entrystr = name;
SCRPTGBL.RWSUI.SaveVariables = {PLOT};
SCRPTGBL.RWSUI.SaveVariableNames = {'PLOT'};
SCRPTGBL.RWSUI.SaveGlobal = 'yes';
SCRPTGBL.RWSUI.SaveGlobalNames = name;
SCRPTGBL.RWSUI.SaveScriptOption = 'yes';
SCRPTGBL.RWSUI.SaveScriptPath = 'outloc';
SCRPTGBL.RWSUI.SaveScriptName = name;

Status('done','');
Status2('done','',2);
Status2('done','',3);
