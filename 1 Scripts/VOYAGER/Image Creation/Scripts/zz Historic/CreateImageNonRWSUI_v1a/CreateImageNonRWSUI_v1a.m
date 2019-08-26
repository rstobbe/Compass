%====================================================
% (v1a)
%       
%====================================================

function [SCRPTipt,SCRPTGBL,err] = CreateImageNonRWSUI_v1a(SCRPTipt,SCRPTGBL)

Status('busy','Create Image');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Clear Naming
%---------------------------------------------
inds = strcmp('Image_Name',{SCRPTipt.labelstr});
indnum = find(inds==1);
if length(indnum) > 1
    indnum = indnum(SCRPTGBL.RWSUI.scrptnum);
end
SCRPTipt(indnum).entrystr = '';
setfunc = 1;
DispScriptParam_B9(SCRPTipt,setfunc,SCRPTGBL.RWSUI.panel);

%---------------------------------------------
% Clear Text Box
%---------------------------------------------
set(findobj('tag','TestBox'),'string','');

%---------------------------------------------
% Tests
%---------------------------------------------
if not(isfield(SCRPTGBL,'Optionfunc_Data'))
    if isfield(SCRPTGBL.CurrentTree.('Optionfunc').Struct,'selectedfile')
    file = SCRPTGBL.CurrentTree.('Optionfunc').Struct.selectedfile;
        if not(exist(file,'file'))
            err.flag = 1;
            err.msg = '(Re) Load Optionfunc - path no longer valid';
            ErrDisp(err);
            return
        else
            SCRPTGBL.('Optionfunc_Data').file = file;
        end
    else
        err.flag = 1;
        err.msg = '(Re) Load Optionfunc';
        ErrDisp(err);
        return
    end
end

%---------------------------------------------
% Tests
%---------------------------------------------
if not(isfield(SCRPTGBL,'Execfunc_Data'))
    if isfield(SCRPTGBL.CurrentTree.('Execfunc').Struct,'selectedfile')
    file = SCRPTGBL.CurrentTree.('Execfunc').Struct.selectedfile;
        if not(exist(file,'file'))
            err.flag = 1;
            err.msg = '(Re) Load Execfunc - path no longer valid';
            ErrDisp(err);
            return
        else
            SCRPTGBL.('Execfunc_Data').file = file;
        end
    else
        err.flag = 1;
        err.msg = '(Re) Load Execfunc';
        ErrDisp(err);
        return
    end
end

%---------------------------------------------
% Load Input
%---------------------------------------------
IMG.method = SCRPTGBL.CurrentTree.Func;
IMG.selectdatafunc = SCRPTGBL.CurrentTree.('SelectDatafunc').Func;
IMG.optionfunc = SCRPTGBL.('Optionfunc_Data').file;
IMG.execfunc = SCRPTGBL.('Execfunc_Data').file;

%---------------------------------------------
% Get Working Structures from Sub Functions
%---------------------------------------------
DIRipt = SCRPTGBL.CurrentTree.('SelectDatafunc');
if isfield(SCRPTGBL,('SelectDatafunc_Data'))
    DIRipt.SelectDatafunc_Data = SCRPTGBL.SelectDatafunc_Data;
end

%------------------------------------------
% Get Image Create Function Info
%------------------------------------------
func = str2func(IMG.selectdatafunc);           
[SCRPTipt,DIR,err] = func(SCRPTipt,DIRipt);
if err.flag
    return
end

%---------------------------------------------
% Create Image
%---------------------------------------------
func = str2func([IMG.method,'_Func']);
INPUT.DIR = DIR;
[IMG,err] = func(INPUT,IMG);
if err.flag
    return
end

%--------------------------------------------
% Output to TextBox
%--------------------------------------------
IMG.ExpDisp = PanelStruct2Text(IMG.PanelOutput);
set(findobj('tag','TestBox'),'string',IMG.ExpDisp);

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
            name = ['IMG_',Gbl.SaveName];
        end
    end
end

%--------------------------------------------
% Name
%--------------------------------------------
if auto == 0;
    name = inputdlg('Name Image:','Name Image',1,{'IMG_'});
    name = cell2mat(name);
    if isempty(name)
        SCRPTGBL.RWSUI.KeepEdit = 'yes';
        return
    end
end
IMG.name = name;
IMG.path = DIR.DataDir;

%---------------------------------------------
% Return
%---------------------------------------------
SCRPTipt(indnum).entrystr = name;
SCRPTGBL.RWSUI.SaveVariables = {IMG};
SCRPTGBL.RWSUI.SaveVariableNames = {'IMG'};
SCRPTGBL.RWSUI.SaveGlobal = 'yes';
SCRPTGBL.RWSUI.SaveGlobalNames = name;
SCRPTGBL.RWSUI.SaveScriptOption = 'yes';
SCRPTGBL.RWSUI.SaveScriptPath = DIR.DataDir;
SCRPTGBL.RWSUI.SaveScriptName = name;

Status('done','');
Status2('done','',2);
Status2('done','',3);
