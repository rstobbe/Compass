%=========================================================
% (v1e) 
%       
%=========================================================

function [SCRPTipt,SCRPTGBL,err] = PlotMontage_v1f(SCRPTipt,SCRPTGBL)

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
PLOT.figcharsfunc = SCRPTGBL.CurrentTree.('FigCharsfunc').Func;
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
FCHRSipt = SCRPTGBL.CurrentTree.('FigCharsfunc');
if isfield(SCRPTGBL,('FigCharsfunc_Data'))
    FCHRSipt.FigCharsfunc_Data = SCRPTGBL.FigCharsfunc_Data;
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
func = str2func(PLOT.figcharsfunc);           
[SCRPTipt,FCHRS,err] = func(SCRPTipt,FCHRSipt);
if err.flag
    return
end
func = str2func(PLOT.createfunc);           
[SCRPTipt,CREATE,err] = func(SCRPTipt,CREATEipt);
if err.flag
    return
end

%---------------------------------------------
% Plot Image
%---------------------------------------------
func = str2func([PLOT.method,'_Func']);
INPUT.IMG = IMG;
INPUT.IMCHRS = IMCHRS;
INPUT.FCHRS = FCHRS;
INPUT.CREATE = CREATE;
[PLOT,err] = func(PLOT,INPUT);
if err.flag
    return
end

%--------------------------------------------
% Output to TextBox
%--------------------------------------------
PLOT.ExpDisp = PanelStruct2Text(PLOT.PanelOutput);
set(findobj('tag','TestBox'),'string',PLOT.ExpDisp);

if strcmp(PLOT.saveoption,'No') && not(isfield(PLOT,'IMDISP'))
    return
end

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
            name = ['PLOT_',Gbl.SaveName];
        end
    end
end

%--------------------------------------------
% Name
%--------------------------------------------
if auto == 0;
    name = inputdlg('Name Plot:','Name Plot',1,{['PLOT_',PLOT.name]});
    name = cell2mat(name);
    if isempty(name)
        SCRPTGBL.RWSUI.KeepEdit = 'yes';
        return
    end
end
PLOT.name = name;
if iscell(IMG)
    PLOT.path = IMG{1}.path;
else
    PLOT.path = IMG.path;
end
PLOT.type = 'Plot';   

if strcmp(PLOT.saveoption,'No')
    SCRPTGBL.RWSUI.SaveScriptOption = 'no';
else
    SCRPTGBL.RWSUI.SaveScriptOption = 'yes';    
end

%--------------------------------------------
% Return
%--------------------------------------------
SCRPTipt(indnum).entrystr = name;
SCRPTGBL.RWSUI.SaveVariables = {PLOT};
SCRPTGBL.RWSUI.SaveVariableNames = {'PLOT'};
SCRPTGBL.RWSUI.SaveGlobal = 'yes';
SCRPTGBL.RWSUI.SaveGlobalNames = name;
SCRPTGBL.RWSUI.SaveScriptPath = PLOT.path;
SCRPTGBL.RWSUI.SaveScriptName = name;

Status('done','');
Status2('done','',2);
Status2('done','',3);
