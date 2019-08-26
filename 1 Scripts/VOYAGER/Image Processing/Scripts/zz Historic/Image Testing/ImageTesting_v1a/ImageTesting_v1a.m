%===========================================
% (v1b)
%    
%===========================================

function [SCRPTipt,SCRPTGBL,err] = ImageTesting_v1a(SCRPTipt,SCRPTGBL)

Status('busy','Testing Image');
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
% Get Panel Input
%---------------------------------------------
TEST.method = SCRPTGBL.CurrentTree.Func;
TEST.loadfunc = SCRPTGBL.CurrentTree.('ImLoadfunc').Func;
TEST.testfunc = SCRPTGBL.CurrentTree.('Testfunc').Func;
TEST.dispfunc = SCRPTGBL.CurrentTree.('Dispfunc').Func;
TEST.baseimfunc = SCRPTGBL.CurrentTree.('BaseImfunc').Func;
TEST.maskfunc = SCRPTGBL.CurrentTree.('Maskfunc').Func;

%---------------------------------------------
% Get Working Structures from Sub Functions
%---------------------------------------------
LOADipt = SCRPTGBL.CurrentTree.('ImLoadfunc');
if isfield(SCRPTGBL,('ImLoadfunc_Data'))
    LOADipt.ImLoadfunc_Data = SCRPTGBL.ImLoadfunc_Data;
end
TSTipt = SCRPTGBL.CurrentTree.('Testfunc');
if isfield(SCRPTGBL,('Testfunc_Data'))
    TSTipt.Testfunc_Data = SCRPTGBL.Testfunc_Data;
end
DISPipt = SCRPTGBL.CurrentTree.('Dispfunc');
if isfield(SCRPTGBL,('Dispfunc_Data'))
    DISPipt.Dispfunc_Data = SCRPTGBL.Dispfunc_Data;
end
BASEipt = SCRPTGBL.CurrentTree.('BaseImfunc');
if isfield(SCRPTGBL,('BaseImfunc_Data'))
    BASEipt.BaseImfunc_Data = SCRPTGBL.BaseImfunc_Data;
end
MASKipt = SCRPTGBL.CurrentTree.('Maskfunc');
if isfield(SCRPTGBL,('Maskfunc_Data'))
    MASKipt.Maskfunc_Data = SCRPTGBL.Maskfunc_Data;
end

%------------------------------------------
% Get  Function Info
%------------------------------------------
func = str2func(TEST.loadfunc);           
[SCRPTipt,SCRPTGBL,LOAD,err] = func(SCRPTipt,SCRPTGBL,LOADipt);
if err.flag
    return
end
IMG = LOAD.IMG;
clear LOAD;
func = str2func(TEST.testfunc);           
[SCRPTipt,TST,err] = func(SCRPTipt,TSTipt);
if err.flag
    return
end
func = str2func(TEST.dispfunc);           
[SCRPTipt,DISP,err] = func(SCRPTipt,DISPipt);
if err.flag
    return
end
func = str2func(TEST.baseimfunc);           
[SCRPTipt,BASE,err] = func(SCRPTipt,BASEipt);
if err.flag
    return
end
func = str2func(TEST.maskfunc);           
[SCRPTipt,MASK,err] = func(SCRPTipt,MASKipt);
if err.flag
    return
end

%---------------------------------------------
% Test
%---------------------------------------------
func = str2func([TEST.method,'_Func']);
INPUT.IMG = IMG;
INPUT.TST = TST;
INPUT.DISP = DISP;
INPUT.BASE = BASE;
INPUT.MASK = MASK;
INPUT.SCRPTipt = SCRPTipt;
INPUT.SCRPTGBL = SCRPTGBL;
[TEST,err] = func(TEST,INPUT);
if err.flag
    return
end

%--------------------------------------------
% Output to TextBox
%--------------------------------------------
TEST.ExpDisp = PanelStruct2Text(TEST.PanelOutput);
set(findobj('tag','TestBox'),'string',TEST.ExpDisp);

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
            name = 'IMG_Test';
        end
    end
end

%--------------------------------------------
% Name
%--------------------------------------------
if auto == 0;
    name = inputdlg('Name Map:','Name Map',1,{'IMG_'});
    name = cell2mat(name);
    if isempty(name)
        SCRPTGBL.RWSUI.KeepEdit = 'yes';
        return
    end
end
TEST.name = name;
if iscell(IMG)
    TEST.path = IMG{1}.path;
else
    TEST.path = IMG.path;
end

%--------------------------------------------
% Return
%--------------------------------------------
SCRPTipt(indnum).entrystr = name;
SCRPTGBL.RWSUI.SaveVariables = {TEST};
SCRPTGBL.RWSUI.SaveVariableNames = {'TEST'};
SCRPTGBL.RWSUI.SaveGlobal = 'yes';
SCRPTGBL.RWSUI.SaveGlobalNames = name;
SCRPTGBL.RWSUI.SaveScriptOption = 'yes';
SCRPTGBL.RWSUI.SaveScriptPath = TEST.path;
SCRPTGBL.RWSUI.SaveScriptName = name;

Status('done','');
Status2('done','',2);
Status2('done','',3);