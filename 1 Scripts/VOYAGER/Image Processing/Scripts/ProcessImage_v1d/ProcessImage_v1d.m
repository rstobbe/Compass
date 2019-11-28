%====================================================
% (v1d)
%    - Include Save Option
%====================================================

function [SCRPTipt,SCRPTGBL,err] = ProcessImage_v1d(SCRPTipt,SCRPTGBL)

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
PROCIMG.saveoption = SCRPTGBL.CurrentTree.('SaveOption');

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

%---------------------------------------------
% Determine if 'ExternalRun'
%---------------------------------------------
RWSUI = SCRPTGBL.RWSUI;
if isfield(RWSUI,'ExtRunInfo')
    ExtRun = 'Yes';
else
    ExtRun = 'No';
end
    
%---------------------------------------------
% Process
%---------------------------------------------
func = str2func([PROCIMG.method,'_Func']);
INPUT.IMG = IMG;
INPUT.PROC = PROC;
INPUT.SCRPTipt = SCRPTipt;
INPUT.SCRPTGBL = SCRPTGBL;
INPUT.ExtRun = ExtRun;
[PROCIMG,err] = func(PROCIMG,INPUT);
if isfield(PROCIMG,'SCRPTipt')
    SCRPTipt = PROCIMG.SCRPTipt;
end
if err.flag
    return
end
IMG = PROCIMG.IMG;
if isempty(IMG)
    return
end

%--------------------------------------------
% Output to TextBox
%--------------------------------------------
IMG.ExpDisp = PanelStruct2Text(IMG.PanelOutput);
global FIGOBJS
if strcmp(SCRPTGBL.RWSUI.tab(1:2),'IM')
    FIGOBJS.(SCRPTGBL.RWSUI.tab).InfoL.String = IMG.ExpDisp;
else
    FIGOBJS.(SCRPTGBL.RWSUI.tab).Info.String = IMG.ExpDisp;
end

if strcmp(PROCIMG.saveoption,'No')
    return
end

%--------------------------------------------
% Determine if AutoSave
%--------------------------------------------
auto = 0;
RWSUI = SCRPTGBL.RWSUI;
if isfield(RWSUI,'ExtRunInfo')
    auto = 1;
    if strcmp(RWSUI.ExtRunInfo.save,'no')
        SCRPTGBL.RWSUI.SaveScript = 'no';
        SCRPTGBL.RWSUI.SaveGlobal = 'no';
    elseif strcmp(RWSUI.ExtRunInfo.save,'all')
        SCRPTGBL.RWSUI.SaveScript = 'yes';
        SCRPTGBL.RWSUI.SaveGlobal = 'yes';
    elseif strcmp(RWSUI.ExtRunInfo.save,'global')
        SCRPTGBL.RWSUI.SaveScript = 'no';
        SCRPTGBL.RWSUI.SaveGlobal = 'yes';
    end
    name = IMG.name;
else
    SCRPTGBL.RWSUI.SaveScriptOption = 'yes';
    SCRPTGBL.RWSUI.SaveGlobal = 'yes';
end

%--------------------------------------------
% Name
%--------------------------------------------
ind = strfind(IMG.name,'.mat');
if not(isempty(ind))
    IMG.name = IMG.name(1:ind-1);
end 
if auto == 0
    name = inputdlg('Name Image:','Name Image',1,{IMG.name});
    name = cell2mat(name);
    if isempty(name)
        SCRPTGBL.RWSUI.KeepEdit = 'yes';
        return
    end
end

%--------------------------------------------
% Update
%--------------------------------------------
IMG.name = name;
if iscell(IMG)
    IMG.path = IMG{1}.path;
else
    IMG.path = IMG.path;
end
IMG.type = 'Image'; 
if isfield(PROCIMG,'CompassDisplay')
    if strcmp(PROCIMG.CompassDisplay,'Yes')
        SCRPTGBL.RWSUI.CompassDisplay.do = 'Yes';
        SCRPTGBL.RWSUI.CompassDisplay.tab = 'IM';
        SCRPTGBL.RWSUI.CompassDisplay.axnum = 1;
    end
end

%--------------------------------------------
% Return
%--------------------------------------------
SCRPTipt(indnum).entrystr = name;
SCRPTGBL.RWSUI.SaveVariables = IMG;
SCRPTGBL.RWSUI.SaveVariableNames = 'IMG';
SCRPTGBL.RWSUI.SaveGlobalNames = name;
SCRPTGBL.RWSUI.SaveScriptPath = IMG.path;
SCRPTGBL.RWSUI.SaveScriptName = name;

Status('done','');
Status2('done','',2);
Status2('done','',3);