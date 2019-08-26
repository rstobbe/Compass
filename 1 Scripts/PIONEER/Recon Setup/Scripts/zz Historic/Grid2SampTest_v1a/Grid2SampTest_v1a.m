%==================================================
% (v1a)
%     
%==================================================
function [SCRPTipt,SCRPTGBL,err] = Grid2SampTest_v1a(SCRPTipt,SCRPTGBL)

Status('busy','Convolution Test');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Clear Naming
%---------------------------------------------
inds = strcmp('Conv_Name',{SCRPTipt.labelstr});
indnum = find(inds==1);
if length(indnum) > 1
    indnum = indnum(SCRPTGBL.RWSUI.scrptnum);
end
SCRPTipt(indnum).entrystr = '';
setfunc = 1;
DispScriptParam_B9(SCRPTipt,setfunc,SCRPTGBL.RWSUI.panel);

%---------------------------------------------
% Tests
%---------------------------------------------
if not(isfield(SCRPTGBL,'RecDat_File_Data'))
    if isfield(SCRPTGBL.CurrentTree.('RecDat_File').Struct,'selectedfile')
    file = SCRPTGBL.CurrentTree.('RecDat_File').Struct.selectedfile;
        if not(exist(file,'file'))
            err.flag = 1;
            err.msg = '(Re) Load RecDat_File';
            ErrDisp(err);
            return
        else
            Status('busy','Load Convolution Kernel');
            load(file);
            saveData.path = file;
            SCRPTGBL.('RecDat_File_Data') = saveData;
        end
    else
        err.flag = 1;
        err.msg = '(Re) Load RecDat_File';
        ErrDisp(err);
        return
    end
end

%---------------------------------------------
% Load Input
%---------------------------------------------
CONV.method = SCRPTGBL.CurrentTree.Func;
CONV.RecDatFile = SCRPTGBL.CurrentTree.('RecDat_File').EntryStr;

%---------------------------------------------
% Load Implementation and Kernel
%---------------------------------------------
RDAT = SCRPTGBL.RecDat_File_Data.RDAT;

%------------------------------------------
% Run Recon Setup
%------------------------------------------
func = str2func([CONV.method,'_Func']);
INPUT.RDAT = RDAT;
[CONV,err] = func(INPUT,CONV);
if err.flag
    return
end

%--------------------------------------------
% Output to TextBox
%--------------------------------------------
CONV.ExpDisp = PanelStruct2Text(CONV.PanelOutput);
set(findobj('tag','TestBox'),'string',CONV.ExpDisp);

%--------------------------------------------
% Determine if AutoSave
%--------------------------------------------
global TOTALGBL
val = get(findobj('tag','totalgbl'),'value');
auto = 0;
if not(isempty(val)) && val ~= 0 && not(isempty(TOTALGBL))
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
    name = inputdlg('Name RecDat:');
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
SCRPTGBL.RWSUI.SaveVariables = {CONV};
SCRPTGBL.RWSUI.SaveVariableNames = {'CONV'};
SCRPTGBL.RWSUI.SaveGlobal = 'yes';
SCRPTGBL.RWSUI.SaveGlobalNames = name;
SCRPTGBL.RWSUI.SaveScriptOption = 'yes';
SCRPTGBL.RWSUI.SaveScriptPath = 'outloc';
SCRPTGBL.RWSUI.SaveScriptName = name;

Status('done','');
Status2('done','',2);
Status2('done','',3);
