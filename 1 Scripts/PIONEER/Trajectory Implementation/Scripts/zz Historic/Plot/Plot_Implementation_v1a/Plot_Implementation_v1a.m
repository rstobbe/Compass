%=========================================================
% (v1a) 
%      
%=========================================================

function [SCRPTipt,SCRPTGBL,err] = Plot_Implementation_v1a(SCRPTipt,SCRPTGBL)

Status('busy','Plot Implementation');
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
            load(file);
            SCRPTGBL.('Imp_File_Data') = saveData;
        end
    else
        err.flag = 1;
        err.msg = '(Re) Load Imp_File';
        ErrDisp(err);
        return
    end
end

%---------------------------------------------
% Get Input
%---------------------------------------------
PLOTTOP.method = SCRPTGBL.CurrentScript.Func;
PLOTTOP.plotfunc = SCRPTGBL.CurrentTree.('Plotfunc').Func;
IMP = SCRPTGBL.('Imp_File_Data').IMP;

%---------------------------------------------
% Get Working Structures from Sub Functions
%---------------------------------------------
PLOTipt = SCRPTGBL.CurrentTree.('Plotfunc');
if isfield(SCRPTGBL,('Plotfunc_Data'))
    PLOTipt.Plotfunc_Data = SCRPTGBL.Plotfunc_Data;
end

%------------------------------------------
% Get PLOT Function Info
%------------------------------------------
func = str2func(PLOTTOP.plotfunc);           
[SCRPTipt,PLOT,err] = func(SCRPTipt,PLOTipt);
if err.flag
    return
end

%---------------------------------------------
% PLOTulate
%---------------------------------------------
func = str2func([PLOTTOP.method,'_Func']);
INPUT.IMP = IMP;
INPUT.PLOT = PLOT;
[PLOTTOP,err] = func(PLOTTOP,INPUT);
if err.flag
    return
end

PLOT = PLOTTOP;

%---------------------------------------------
% Panel Output
%--------------------------------------------- 
%IMG.ExpDisp = PanelStruct2Text(IMG.PanelOutput);
%global FIGOBJS
%FIGOBJS.(SCRPTGBL.RWSUI.tab).Info.String = IMG.ExpDisp;

%--------------------------------------------
% Name
%--------------------------------------------
name0 = '';
if isfield(IMP,'name')
    name0 = IMP.name(5:end);
end
name = inputdlg('Name Plot:','Name Plot',1,{['Plot_',name0]});
name = cell2mat(name);
if isempty(name)
    SCRPTGBL.RWSUI.SaveVariables = {PLOT};
    SCRPTGBL.RWSUI.KeepEdit = 'yes';
    return
end
PLOT.name = name;
PLOT.path = IMP.path;
PLOT.type = 'Data';   
PLOT.structname = 'PLOT';

%---------------------------------------------
% Return
%---------------------------------------------
SCRPTipt(indnum).entrystr = name;
SCRPTGBL.RWSUI.SaveVariables = {PLOT};
SCRPTGBL.RWSUI.SaveVariableNames = {'PLOT'};
SCRPTGBL.RWSUI.SaveGlobal = 'yes';
SCRPTGBL.RWSUI.SaveGlobalNames = name;
SCRPTGBL.RWSUI.SaveScriptOption = 'yes';
SCRPTGBL.RWSUI.SaveScriptPath = PLOT.path;
SCRPTGBL.RWSUI.SaveScriptName = name;

Status('done','');
Status2('done','',2);
Status2('done','',3);


