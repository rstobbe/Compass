%===========================================================================================
% (v1a)
%     
%===========================================================================================

function [SCRPTipt,SCRPTGBL,err] = FindPointsVicinity_v1a(SCRPTipt,SCRPTGBL)

Status('busy','Find Sampling Points in Cartesian Vicinity');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Clear Naming
%---------------------------------------------
inds = strcmp('RecDat_Name',{SCRPTipt.labelstr});
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
if not(isfield(SCRPTGBL,'Imp_File_Data'))
    if isfield(SCRPTGBL.CurrentTree.('Imp_File').Struct,'selectedfile')
    file = SCRPTGBL.CurrentTree.('Imp_File').Struct.selectedfile;
        if not(exist(file,'file'))
            err.flag = 1;
            err.msg = '(Re) Load Imp_File';
            ErrDisp(err);
            return
        else
            Status('busy','Load Convolution Kernel');
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
if not(isfield(SCRPTGBL,'Kern_File_Data'))
    if isfield(SCRPTGBL.CurrentTree.('Kern_File').Struct,'selectedfile')
    file = SCRPTGBL.CurrentTree.('Kern_File').Struct.selectedfile;
        if not(exist(file,'file'))
            err.flag = 1;
            err.msg = '(Re) Load Kern_File';
            ErrDisp(err);
            return
        else
            Status('busy','Load Convolution Kernel');
            load(file);
            saveData.path = file;
            SCRPTGBL.('Kern_File_Data') = saveData;
        end
    else
        err.flag = 1;
        err.msg = '(Re) Load Kern_File';
        ErrDisp(err);
        return
    end
end

%---------------------------------------------
% Load Input
%---------------------------------------------
RDAT.method = SCRPTGBL.CurrentTree.Func;

%---------------------------------------------
% Load Implementation and Kernel
%---------------------------------------------
IMP = SCRPTGBL.Imp_File_Data.IMP;
KRNprms = SCRPTGBL.Kern_File_Data.KRNprms;

%------------------------------------------
% Run Recon Setup
%------------------------------------------
func = str2func([RDAT.method,'_Func']);
INPUT.IMP = IMP;
INPUT.KRNprms = KRNprms;
[RDAT,err] = func(INPUT,RDAT);
if err.flag
    return
end

%--------------------------------------------
% Output to TextBox
%--------------------------------------------
RDAT.ExpDisp = PanelStruct2Text(RDAT.PanelOutput);
set(findobj('tag','TestBox'),'string',RDAT.ExpDisp);

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
    name = inputdlg('Name Image:');
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
SCRPTGBL.RWSUI.SaveVariables = {RDAT};
SCRPTGBL.RWSUI.SaveVariableNames = {'RDAT'};
SCRPTGBL.RWSUI.SaveGlobal = 'yes';
SCRPTGBL.RWSUI.SaveGlobalNames = name;
SCRPTGBL.RWSUI.SaveScriptOption = 'yes';
SCRPTGBL.RWSUI.SaveScriptPath = 'outloc';
SCRPTGBL.RWSUI.SaveScriptName = name;

Status('done','');
Status2('done','',2);
Status2('done','',3);
