%==================================
% 
%==================================

function [SCRPTipt,SCRPTGBL,err] = MonoExp_v1c(SCRPTipt,SCRPTGBL)

Status('busy','Regress Eddy Currents');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Clear Naming
%---------------------------------------------
inds = strcmp('Rgrs_Name',{SCRPTipt.labelstr});
indnum = find(inds==1);
if length(indnum) > 1
    indnum = indnum(SCRPTGBL.RWSUI.scrptnum);
end
SCRPTipt(indnum).entrystr = '';

%---------------------------------------------
% Tests
%---------------------------------------------
if not(isfield(SCRPTGBL,'Data_File_Data'))
    if isfield(SCRPTGBL.CurrentTree.('Data_File').Struct,'selectedfile')
        file = SCRPTGBL.CurrentTree.('Data_File').Struct.selectedfile;
        if not(exist(file,'file'))
            err.flag = 1;
            err.msg = '(Re) Load Data_File';
            ErrDisp(err);
            return
        else
            SCRPTGBL.('Data_File_Data').path = file;
        end
    else
        err.flag = 1;
        err.msg = '(Re) Load Data_File';
        ErrDisp(err);
        return
    end
end

%-----------------------------------------------------
% Get Input
%-----------------------------------------------------
RGRS.method = SCRPTGBL.CurrentTree.Func;
RGRS.datastart = str2double(SCRPTGBL.CurrentTree.('DataStart'));
RGRS.datastop = str2double(SCRPTGBL.CurrentTree.('DataStop'));
RGRS.timepastg = SCRPTGBL.CurrentTree.('TimePastG');
RGRS.tcest = str2double(SCRPTGBL.CurrentTree.('Tc_Estimate'));
RGRS.seleddy = SCRPTGBL.CurrentTree.('SelectEddy');
RGRS.figno = str2double(SCRPTGBL.CurrentTree.('Figure_Number'));
EDDY = SCRPTGBL.('Data_File_Data').EDDY;

%-----------------------------------------------------
% Perform Regression
%-----------------------------------------------------
func = str2func([RGRS.method,'_Func']);
INPUT.EDDY = EDDY;
[RGRS,err] = func(RGRS,INPUT);
if err.flag
    return
end

%--------------------------------------------
% Output to TextBox
%--------------------------------------------
RGRS.ExpDisp = PanelStruct2Text(RGRS.PanelOutput);
set(findobj('tag','TestBox'),'string',RGRS.ExpDisp);

%--------------------------------------------
% Determine if AutoSave
%--------------------------------------------
global TOTALGBL
val = get(findobj('tag','totalgbl'),'value');
auto = 0;
if not(isempty(val)) && val ~= 0
    Gbl = TOTALGBL{2,val};
    if isfield(Gbl,'AutoRecon')
        if strcmp(Gbl.AutoSave,'yes')
            auto = 1;
            SCRPTGBL.RWSUI.SaveScript = 'yes';
            name = Gbl.SaveName;
        end
    end
end

%--------------------------------------------
% Name
%--------------------------------------------
if auto == 0;
    name = inputdlg('Name Regression:');
    name = cell2mat(name);
    if isempty(name)
        SCRPTGBL.RWSUI.KeepEdit = 'yes';
        return
    end
end

%---------------------------------------------
% Return
%---------------------------------------------
SCRPTipt(indnum).entrystr = name;
SCRPTGBL.RWSUI.SaveVariables = {RGRS};
SCRPTGBL.RWSUI.SaveVariableNames = {'RGRS'};
SCRPTGBL.RWSUI.SaveGlobal = 'yes';
SCRPTGBL.RWSUI.SaveGlobalNames = name;
SCRPTGBL.RWSUI.SaveScriptOption = 'yes';
SCRPTGBL.RWSUI.SaveScriptPath = 'outloc';
SCRPTGBL.RWSUI.SaveScriptName = name;

Status('done','');
Status2('done','',2);
Status2('done','',3);