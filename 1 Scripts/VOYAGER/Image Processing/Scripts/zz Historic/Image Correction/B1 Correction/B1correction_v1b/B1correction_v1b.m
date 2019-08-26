%=========================================================
% (v1a) 
%   
%=========================================================

function [SCRPTipt,SCRPTGBL,err] = B1correction_v1b(SCRPTipt,SCRPTGBL)

Status('busy','B1 Correction');
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
% Load Panel Input
%---------------------------------------------
B1CORR.method = SCRPTGBL.CurrentTree.Func;
B1CORR.loadfunc = SCRPTGBL.CurrentTree.('ImLoadfunc').Func;
B1CORR.resizefunc = SCRPTGBL.CurrentTree.('ReSizefunc').Func;
B1CORR.corrfunc = SCRPTGBL.CurrentTree.('B1Corrfunc').Func;
B1CORR.dispfunc = SCRPTGBL.CurrentTree.('Dispfunc').Func;

%---------------------------------------------
% Get Working Structures from Sub Functions
%---------------------------------------------
LOADipt = SCRPTGBL.CurrentTree.('ImLoadfunc');
if isfield(SCRPTGBL,('ImLoadfunc_Data'))
    LOADipt.ImLoadfunc_Data = SCRPTGBL.ImLoadfunc_Data;
end
RESZipt = SCRPTGBL.CurrentTree.('ReSizefunc');
if isfield(SCRPTGBL,('ReSizefunc_Data'))
    RESZipt.ReSizefunc_Data = SCRPTGBL.ReSizefunc_Data;
end
CORFipt = SCRPTGBL.CurrentTree.('B1Corrfunc');
if isfield(SCRPTGBL,('B1Corrfunc_Data'))
    CORFipt.B1Corrfunc_Data = SCRPTGBL.B1Corrfunc_Data;
end
DISPipt = SCRPTGBL.CurrentTree.('Dispfunc');
if isfield(SCRPTGBL,('Dispfunc_Data'))
    DISPipt.Dispfunc_Data = SCRPTGBL.Dispfunc_Data;
end

%------------------------------------------
% Get Function Info
%------------------------------------------
func = str2func(B1CORR.loadfunc);           
[SCRPTipt,SCRPTGBL,LOAD,err] = func(SCRPTipt,SCRPTGBL,LOADipt);
if err.flag
    return
end
IMG = LOAD.IMG;
clear LOAD;
func = str2func(B1CORR.resizefunc);           
[SCRPTipt,RESZ,err] = func(SCRPTipt,RESZipt);
if err.flag
    return
end
func = str2func(B1CORR.corrfunc);           
[SCRPTipt,CORF,err] = func(SCRPTipt,CORFipt);
if err.flag
    return
end
func = str2func(B1CORR.dispfunc);           
[SCRPTipt,DISP,err] = func(SCRPTipt,DISPipt);
if err.flag
    return
end

%---------------------------------------------
% Correct Images
%---------------------------------------------
func = str2func([B1CORR.method,'_Func']);
INPUT.IMG = IMG;
INPUT.RESZ = RESZ;
INPUT.CORF = CORF;
INPUT.DISP = DISP;
[B1CORR,err] = func(B1CORR,INPUT);
if err.flag
    return
end

%--------------------------------------------
% Output to TextBox
%--------------------------------------------
B1CORR.ExpDisp = PanelStruct2Text(B1CORR.PanelOutput);
set(findobj('tag','TestBox'),'string',B1CORR.ExpDisp);

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
            name = ['B1CORR_',Gbl.SaveName];
        end
    end
end

%--------------------------------------------
% Name
%--------------------------------------------
if auto == 0;
    name = inputdlg('Name Map:','Name Map',1,{'B1CORR_'});
    name = cell2mat(name);
    if isempty(name)
        SCRPTGBL.RWSUI.KeepEdit = 'yes';
        return
    end
end
B1CORR.name = name;
if iscell(IMG)
    B1CORR.path = IMG{1}.path;
else
    B1CORR.path = IMG.path;
end

%--------------------------------------------
% Return
%--------------------------------------------
SCRPTipt(indnum).entrystr = name;
SCRPTGBL.RWSUI.SaveVariables = {B1CORR};
SCRPTGBL.RWSUI.SaveVariableNames = 'B1CORR';
SCRPTGBL.RWSUI.SaveGlobal = 'yes';
SCRPTGBL.RWSUI.SaveGlobalNames = name;
SCRPTGBL.RWSUI.SaveScriptOption = 'yes';
SCRPTGBL.RWSUI.SaveScriptPath = B1CORR.path;
SCRPTGBL.RWSUI.SaveScriptName = name;

Status('done','');
Status2('done','',2);
Status2('done','',3);
