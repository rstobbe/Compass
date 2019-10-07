%=========================================================
% (v1e) 
%       
%=========================================================

function [SCRPTipt,SCRPTGBL,err] = PlotMontage_v1g(SCRPTipt,SCRPTGBL)

Status('busy','Plot Image Montage');
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
% Get Panel Input
%---------------------------------------------
PLOT.method = SCRPTGBL.CurrentTree.Func;
PLOT.loadfunc = SCRPTGBL.CurrentTree.('ImLoadfunc').Func;
PLOT.imcharsfunc = SCRPTGBL.CurrentTree.('ImCharsfunc').Func;
PLOT.createfunc = SCRPTGBL.CurrentTree.('Createfunc').Func;
PLOT.saveoption = SCRPTGBL.CurrentTree.('SaveOption');

%---------------------------------------------
% Get Working Structures from Sub Functions
%---------------------------------------------
LOADipt = SCRPTGBL.CurrentTree.('ImLoadfunc');
if isfield(SCRPTGBL,('ImLoadfunc_Data'))
    LOADipt.ImLoadfunc_Data = SCRPTGBL.ImLoadfunc_Data;
end
IMCHRSipt = SCRPTGBL.CurrentTree.('ImCharsfunc');
if isfield(SCRPTGBL,('ImCharsfunc_Data'))
    IMCHRSipt.ImCharsfunc_Data = SCRPTGBL.ImCharsfunc_Data;
end
CREATEipt = SCRPTGBL.CurrentTree.('Createfunc');
if isfield(SCRPTGBL,('Createfunc_Data'))
    CREATEipt.Createfunc_Data = SCRPTGBL.Createfunc_Data;
end

%------------------------------------------
% Get  Function Info
%------------------------------------------
func = str2func(PLOT.loadfunc);           
[SCRPTipt,SCRPTGBL,LOAD,err] = func(SCRPTipt,SCRPTGBL,LOADipt);
if err.flag
    return
end
IMG = LOAD.IMG;
clear LOAD;
func = str2func(PLOT.imcharsfunc);           
[SCRPTipt,IMCHRS,err] = func(SCRPTipt,IMCHRSipt);
if err.flag
    return
end
func = str2func(PLOT.createfunc);           
[SCRPTipt,SCRPTGBL,CREATE,err] = func(SCRPTipt,SCRPTGBL,CREATEipt);
if err.flag
    return
end

%---------------------------------------------
% Plot Image
%---------------------------------------------
func = str2func([PLOT.method,'_Func']);
INPUT.IMG = IMG;
INPUT.IMCHRS = IMCHRS;
INPUT.CREATE = CREATE;
[PLOT,err] = func(PLOT,INPUT);
if err.flag
    return
end

%--------------------------------------------
% Determine if for Compass Display
%--------------------------------------------
Struct = 'PLOT';
if isfield(PLOT,'CompassDisplay')
    if strcmp(PLOT.CompassDisplay,'Yes')
        SCRPTGBL.RWSUI.CompassDisplay.do = 'Yes';
        SCRPTGBL.RWSUI.CompassDisplay.tab = 'IM';
        SCRPTGBL.RWSUI.CompassDisplay.axnum = 1;
    end
    Struct = 'MONT';
end

%--------------------------------------------
% Output to TextBox
%--------------------------------------------
PLOT.ExpDisp = PanelStruct2Text(PLOT.PanelOutput);
global FIGOBJS
if(isfield(FIGOBJS.(SCRPTGBL.RWSUI.tab),'InfoL'))
    FIGOBJS.(SCRPTGBL.RWSUI.tab).InfoL.String = PLOT.ExpDisp;
else    
    FIGOBJS.(SCRPTGBL.RWSUI.tab).Info.String = PLOT.ExpDisp;
end

if strcmp(PLOT.saveoption,'No') && not(isfield(PLOT,'IMDISP'))
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
    elseif strcmp(RWSUI.ExtRunInfo.save,'file')
        SCRPTGBL.RWSUI.SaveScript = 'yes';
        SCRPTGBL.RWSUI.SaveGlobal = 'no';
    end
    name = [Struct,'_',PLOT.name];
else
    SCRPTGBL.RWSUI.SaveScriptOption = 'yes';
    SCRPTGBL.RWSUI.SaveGlobal = 'yes';
end

%--------------------------------------------
% Name
%--------------------------------------------
if auto == 0
    inds = strfind(PLOT.name,'.');
    if not(isempty(inds))
        PLOT.name(inds) = 'p';
    end
    name = inputdlg('Name Plot:','Name Plot',1,{[Struct,'_',PLOT.name]});
    name = cell2mat(name);
    if isempty(name)
        SCRPTGBL.RWSUI.SaveVariables = {PLOT};
        SCRPTGBL.RWSUI.KeepEdit = 'yes';
        return
    end
end

%--------------------------------------------
% Update
%--------------------------------------------
PLOT.name = name;
if iscell(IMG)
    PLOT.path = IMG{1}.path;
else
    PLOT.path = IMG.path;
end
if isfield(PLOT,'IMDISP')
    PLOT.type = 'Plot';
end
if strcmp(PLOT.saveoption,'No')
    SCRPTGBL.RWSUI.SaveScriptOption = 'no';
else
    SCRPTGBL.RWSUI.SaveScriptOption = 'yes';    
end
        
%--------------------------------------------
% Return
%--------------------------------------------
SCRPTipt(indnum).entrystr = PLOT.name;
SCRPTGBL.RWSUI.SaveVariables = PLOT;
SCRPTGBL.RWSUI.SaveVariableNames = Struct;
SCRPTGBL.RWSUI.SaveGlobalNames = PLOT.name;
SCRPTGBL.RWSUI.SaveScriptPath = PLOT.path;
SCRPTGBL.RWSUI.SaveScriptName = PLOT.name;

Status('done','');
Status2('done','',2);
Status2('done','',3);
