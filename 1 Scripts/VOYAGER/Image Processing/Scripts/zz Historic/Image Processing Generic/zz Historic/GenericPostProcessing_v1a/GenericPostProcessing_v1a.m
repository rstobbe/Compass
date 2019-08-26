%===========================================
% (v1a)
%    
%===========================================

function [SCRPTipt,SCRPTGBL,err] = GenericPostProcessing_v1a(SCRPTipt,SCRPTGBL)

Status('busy','Post-Process Image');
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
DispScriptParam(SCRPTipt,setfunc,SCRPTGBL.RWSUI.tab,SCRPTGBL.RWSUI.panelnum);

%---------------------------------------------
% Get Panel Input
%---------------------------------------------
PROCIMG.method = SCRPTGBL.CurrentTree.Func;
PROCIMG.loadfunc = SCRPTGBL.CurrentTree.('ImLoadfunc').Func;
PROCIMG.procfunc = SCRPTGBL.CurrentTree.('Procfunc').Func;
PROCIMG.dispfunc = SCRPTGBL.CurrentTree.('Dispfunc').Func;

%---------------------------------------------
% Get Working Structures from Sub Functions
%---------------------------------------------
LOADipt = SCRPTGBL.CurrentTree.('ImLoadfunc');
if isfield(SCRPTGBL,('ImLoadfunc_Data'))
    LOADipt.ImLoadfunc_Data = SCRPTGBL.ImLoadfunc_Data;
end
PROCipt = SCRPTGBL.CurrentTree.('Procfunc');
if isfield(SCRPTGBL,('Procfunc_Data'))
    PROCipt.Procfunc_Data = SCRPTGBL.Procfunc_Data;
end
DISPipt = SCRPTGBL.CurrentTree.('Dispfunc');
if isfield(SCRPTGBL,('Dispfunc_Data'))
    DISPipt.Dispfunc_Data = SCRPTGBL.Dispfunc_Data;
end

%------------------------------------------
% Get  Function Info
%------------------------------------------
func = str2func(PROCIMG.loadfunc);           
[SCRPTipt,SCRPTGBL,LOAD,err] = func(SCRPTipt,SCRPTGBL,LOADipt);
if err.flag
    return
end
IMG = LOAD.IMG;
clear LOAD;
func = str2func(PROCIMG.procfunc);           
[SCRPTipt,PROC,err] = func(SCRPTipt,PROCipt);
if err.flag
    return
end
func = str2func(PROCIMG.dispfunc);           
[SCRPTipt,DISP,err] = func(SCRPTipt,DISPipt);
if err.flag
    return
end

%---------------------------------------------
% Process
%---------------------------------------------
func = str2func([PROCIMG.method,'_Func']);
INPUT.IMG = IMG;
INPUT.DISP = DISP;
INPUT.PROC = PROC;
INPUT.SCRPTipt = SCRPTipt;
INPUT.SCRPTGBL = SCRPTGBL;
[PROCIMG,err] = func(PROCIMG,INPUT);
if err.flag
    return
end
IMG = PROCIMG.IMG;

%--------------------------------------------
% Output to TextBox
%--------------------------------------------
IMG.ExpDisp = PanelStruct2Text(IMG.PanelOutput);
global FIGOBJS
FIGOBJS.(SCRPTGBL.RWSUI.tab).Info.String = IMG.ExpDisp;

%--------------------------------------------
% Determine if AutoSave
%--------------------------------------------
global TOTALGBL
val = length(TOTALGBL(1,:));
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
        SCRPTGBL.RWSUI.SaveVariables = {IMG};
        SCRPTGBL.RWSUI.KeepEdit = 'yes';
        return
    end
end
IMG.name = name;

%---------------------------------------------
% Return
%---------------------------------------------
SCRPTipt(indnum).entrystr = name;
SCRPTGBL.RWSUI.SaveVariables = {IMG};
SCRPTGBL.RWSUI.SaveVariableNames = {'IMG'};
SCRPTGBL.RWSUI.SaveGlobal = 'yes';
SCRPTGBL.RWSUI.SaveGlobalNames = name;
SCRPTGBL.RWSUI.SaveScriptOption = 'yes';
SCRPTGBL.RWSUI.SaveScriptPath = IMG.path;
SCRPTGBL.RWSUI.SaveScriptName = name;

Status('done','');
Status2('done','',2);
Status2('done','',3);

