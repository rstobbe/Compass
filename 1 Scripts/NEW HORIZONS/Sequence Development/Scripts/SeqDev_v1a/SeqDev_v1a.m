%=========================================================
% (v1a) 
%       
%=========================================================

function [SCRPTipt,SCRPTGBL,err] = SeqDev_v1a(SCRPTipt,SCRPTGBL)

Status('busy','Sequence Development');
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
% Load Input
%---------------------------------------------
STUDY.method = SCRPTGBL.CurrentTree.Func;
STUDY.nmrfunc = SCRPTGBL.CurrentTree.('Nmrfunc').Func;
STUDY.seqfunc = SCRPTGBL.CurrentTree.('Seqfunc').Func;

%---------------------------------------------
% Get Working Structures from Sub Functions
%---------------------------------------------
TSTipt = SCRPTGBL.CurrentTree.('Seqfunc');
if isfield(SCRPTGBL,('Seqfunc_Data'))
    TSTipt.Seqfunc_Data = SCRPTGBL.Seqfunc_Data;
end
NMRipt = SCRPTGBL.CurrentTree.('Nmrfunc');
if isfield(SCRPTGBL,('Nmrfunc_Data'))
    NMRipt.Nmrfunc_Data = SCRPTGBL.Nmrfunc_Data;
end

%---------------------------------------------
% Get Data from Sub Functions
%---------------------------------------------
func = str2func(STUDY.nmrfunc);           
[SCRPTipt,NMR,err] = func(SCRPTipt,NMRipt);
if err.flag
    return
end
func = str2func(STUDY.seqfunc);           
[SCRPTipt,TST,err] = func(SCRPTipt,TSTipt);
if err.flag
    return
end

%---------------------------------------------
% Ren
%---------------------------------------------
func = str2func([STUDY.method,'_Func']);
INPUT.NMR = NMR;
INPUT.TST = TST;
[STUDY,err] = func(STUDY,INPUT);
if err.flag
    return
end

%--------------------------------------------
% Output to TextBox
%--------------------------------------------
global FIGOBJS
FIGOBJS.(SCRPTGBL.RWSUI.tab).Info.String = STUDY.ExpDisp;

%--------------------------------------------
% Return
%--------------------------------------------
STUDY.name = '';
name = inputdlg('Name Study:','Name',1,{STUDY.name});
if isempty(name)
    SCRPTGBL.RWSUI.SaveVariables = {STUDY};
    SCRPTGBL.RWSUI.SaveGlobal = 'no';
    return
end
STUDY.name = name{1};

SCRPTipt(indnum).entrystr = STUDY.name;
SCRPTGBL.RWSUI.SaveVariables = STUDY;
SCRPTGBL.RWSUI.SaveVariableNames = 'STUDY';
SCRPTGBL.RWSUI.SaveGlobal = 'yes';
SCRPTGBL.RWSUI.SaveGlobalNames = STUDY.name;
SCRPTGBL.RWSUI.SaveScriptOption = 'yes';
SCRPTGBL.RWSUI.SaveScriptPath = 'outloc';
SCRPTGBL.RWSUI.SaveScriptName = STUDY.name;

Status('done','');
Status2('done','',2);
Status2('done','',3);

