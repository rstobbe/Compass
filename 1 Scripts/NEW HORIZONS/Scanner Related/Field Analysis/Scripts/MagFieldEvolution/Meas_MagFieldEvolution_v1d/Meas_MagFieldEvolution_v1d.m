%====================================================
% (v1d)
%       - Start 'EddyCurrents_v1c'
%       - All Data Loading Moved to Separate Function
%====================================================

function [SCRPTipt,SCRPTGBL,err] = Meas_MagFieldEvolution_v1d(SCRPTipt,SCRPTGBL)

Status('busy','Calculate Magnetic Field Evolution');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Clear Naming
%---------------------------------------------
inds = strcmp('FieldEvo_Name',{SCRPTipt.labelstr});
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
MFEVO.method = SCRPTGBL.CurrentTree.Func;
MFEVO.fevolfunc = SCRPTGBL.CurrentTree.('FieldEvoLoadfunc').Func;
MFEVO.psbgfunc = SCRPTGBL.CurrentTree.('PosBgrndfunc').Func;
MFEVO.tffunc = SCRPTGBL.CurrentTree.('TransFieldfunc').Func;

%---------------------------------------------
% Get Working Structures
%---------------------------------------------
FEVOLipt = SCRPTGBL.CurrentTree.('FieldEvoLoadfunc');
if isfield(SCRPTGBL,('FieldEvoLoadfunc_Data'))
    FEVOLipt.FieldEvoLoadfunc_Data = SCRPTGBL.FieldEvoLoadfunc_Data;
end
POSBGipt = SCRPTGBL.CurrentTree.('PosBgrndfunc');
if isfield(SCRPTGBL,('PosBgrndfunc_Data'))
    POSBGipt.PosBgrndfunc_Data = SCRPTGBL.PosBgrndfunc_Data;
end
TFipt = SCRPTGBL.CurrentTree.('TransFieldfunc');
if isfield(SCRPTGBL,('TransFieldfunc_Data'))
    TFipt.TransFieldfunc_Data = SCRPTGBL.TransFieldfunc_Data;
end

%------------------------------------------
% Load
%------------------------------------------
func = str2func(MFEVO.fevolfunc);           
[SCRPTipt,FEVOL,err] = func(SCRPTipt,FEVOLipt);
if err.flag
    return
end

%------------------------------------------
% Position and BackGround Function Info
%------------------------------------------
func = str2func(MFEVO.psbgfunc);           
[SCRPTipt,POSBG,err] = func(SCRPTipt,POSBGipt);
if err.flag
    return
end

%------------------------------------------
% Transient Field Function Info
%------------------------------------------
func = str2func(MFEVO.tffunc);           
[SCRPTipt,TF,err] = func(SCRPTipt,TFipt);
if err.flag
    return
end

%---------------------------------------------
% Determine Field Evolution
%---------------------------------------------
func = str2func([MFEVO.method,'_Func']);
INPUT.FEVOL = FEVOL;
INPUT.POSBG = POSBG;
INPUT.TF = TF;
[MFEVO,err] = func(INPUT,MFEVO);
if err.flag
    return
end

%--------------------------------------------
% Output to TextBox
%--------------------------------------------
global FIGOBJS
FIGOBJS.(SCRPTGBL.RWSUI.tab).Info.String = MFEVO.ExpDisp;

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
    name = ['FieldEvo_',RWSUI.ExtRunInfo.name];
else
    SCRPTGBL.RWSUI.SaveScriptOption = 'yes';
    SCRPTGBL.RWSUI.SaveGlobal = 'yes';
end

%--------------------------------------------
% Name
%--------------------------------------------
if auto == 0
    name = inputdlg('Name Analysis:','Name Analysis',1,{['FieldEvo_',MFEVO.FEVOL.GradFile]});
    name = cell2mat(name);
    if isempty(name)
        SCRPTGBL.RWSUI.SaveVariables = MFEVO;
        SCRPTGBL.RWSUI.KeepEdit = 'yes';
        return
    end
end

MFEVO.path = FEVOL.path;
MFEVO.name = name;
MFEVO.type = 'Analysis';   

%---------------------------------------------
% Return
%---------------------------------------------
SCRPTipt(indnum).entrystr = MFEVO.name;
SCRPTGBL.RWSUI.SaveVariables = MFEVO;
SCRPTGBL.RWSUI.SaveVariableNames = 'MFEVO';
SCRPTGBL.RWSUI.SaveGlobalNames = MFEVO.name;
SCRPTGBL.RWSUI.SaveScriptPath = MFEVO.path;
SCRPTGBL.RWSUI.SaveScriptName = MFEVO.name;

Status('done','');
Status2('done','',2);
Status2('done','',3);
