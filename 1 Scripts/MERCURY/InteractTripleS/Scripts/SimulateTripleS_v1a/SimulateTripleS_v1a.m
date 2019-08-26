%=====================================================
% (v1a) 
%        
%=====================================================

function [SCRPTipt,SCRPTGBL,err] = SimulateTripleS_v1a(SCRPTipt,SCRPTGBL)

Status('busy','Simulate TripleS');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Clear Naming
%---------------------------------------------
inds = strcmp('Study_Name',{SCRPTipt.labelstr});
indnum = find(inds==1);
if length(indnum) > 1
    indnum = indnum(SCRPTGBL.RWSUI.scrptnum);
end
SCRPTipt(indnum).entrystr = '';
setfunc = 1;
DispScriptParam(SCRPTipt,setfunc,SCRPTGBL.RWSUI.tab,SCRPTGBL.RWSUI.panelnum);

%---------------------------------------------
% Get Input
%---------------------------------------------
STUDY.method = SCRPTGBL.CurrentTree.Func;
STUDY.simfunc = SCRPTGBL.CurrentTree.('Simulatefunc').Func;
STUDY.plotfunc = SCRPTGBL.CurrentTree.('Plotfunc').Func;
STUDY.outputfunc = SCRPTGBL.CurrentTree.('Outputfunc').Func;

%---------------------------------------------
% Get Working Structures from Sub Functions
%---------------------------------------------
SIMipt = SCRPTGBL.CurrentTree.('Simulatefunc');
if isfield(SCRPTGBL,('Simulatefunc_Data'))
    SIMipt.Simulatefunc_Data = SCRPTGBL.Simulatefunc_Data;
end
PLOTipt = SCRPTGBL.CurrentTree.('Plotfunc');
if isfield(SCRPTGBL,('Plotfunc_Data'))
    PLOTipt.Plotfunc_Data = SCRPTGBL.Plotfunc_Data;
end
OUTipt = SCRPTGBL.CurrentTree.('Outputfunc');
if isfield(SCRPTGBL,('Outputfunc_Data'))
    OUTipt.Outputfunc_Data = SCRPTGBL.Outputfunc_Data;
end

%------------------------------------------
% Get Function Info
%------------------------------------------
func = str2func(STUDY.simfunc);           
[SCRPTipt,SIM,err] = func(SCRPTipt,SIMipt);
if err.flag
    return
end
func = str2func(STUDY.plotfunc);           
[SCRPTipt,PLOT,err] = func(SCRPTipt,PLOTipt);
if err.flag
    return
end
func = str2func(STUDY.outputfunc);           
[SCRPTipt,OUT,err] = func(SCRPTipt,OUTipt);
if err.flag
    return
end

%---------------------------------------------
% Run
%---------------------------------------------
func = str2func([STUDY.method,'_Func']);
INPUT.SIM = SIM;
INPUT.PLOT = PLOT;
INPUT.OUT = OUT;
[STUDY,err] = func(STUDY,INPUT);
if err.flag
    return
end
clear INPUT;

%--------------------------------------------
% Output to TextBox
%--------------------------------------------
STUDY.ExpDisp = PanelStruct2Text(STUDY.PanelOutput);
global FIGOBJS
FIGOBJS.(SCRPTGBL.RWSUI.tab).Info.String = STUDY.ExpDisp;

%--------------------------------------------
% Name
%--------------------------------------------
name = 'SIM_';

%--------------------------------------------
% Return
%--------------------------------------------
name = inputdlg('Name Study:','Name',1,{name});
if isempty(name)
    SCRPTGBL.RWSUI.SaveGlobal = 'no';
    return
end
name = name{1};
STUDY.name = name;
STUDY.structname = 'STUDY';

SCRPTipt(indnum).entrystr = name;
SCRPTGBL.RWSUI.SaveVariables = STUDY;
SCRPTGBL.RWSUI.SaveVariableNames = 'STUDY';
SCRPTGBL.RWSUI.SaveGlobal = 'yes';
SCRPTGBL.RWSUI.SaveGlobalNames = name;
SCRPTGBL.RWSUI.SaveScriptOption = 'yes';
SCRPTGBL.RWSUI.SaveScriptPath = 'outloc';
SCRPTGBL.RWSUI.SaveScriptName = name;

Status('done','');
Status2('done','',2);
Status2('done','',3);
