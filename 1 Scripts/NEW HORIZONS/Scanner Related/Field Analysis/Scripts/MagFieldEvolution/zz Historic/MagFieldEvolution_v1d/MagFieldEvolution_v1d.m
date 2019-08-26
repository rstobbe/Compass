%====================================================
% (v1d)
%       - Start 'EddyCurrents_v1c'
%       - All Data Loading Moved to Separate Function
%====================================================

function [SCRPTipt,SCRPTGBL,err] = MagFieldEvolution_v1d(SCRPTipt,SCRPTGBL)

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
global TOTALGBL
val = get(findobj('tag','totalgbl'),'value');
auto = 0;
if not(isempty(val)) && val ~= 0
    Gbl = TOTALGBL{2,val};
    if isfield(Gbl,'AutoRecon')
        if strcmp(Gbl.AutoSave,'yes')
            auto = 1;
            SCRPTGBL.RWSUI.SaveScript = 'yes';
            name = Gbl.SaveName;
        end
    end
end

%--------------------------------------------
% Name
%--------------------------------------------
if auto == 0;
    name = inputdlg('Name Analysis:');
    name = cell2mat(name);
    if isempty(name)
        SCRPTGBL.RWSUI.SaveVariables = {MFEVO};
        SCRPTGBL.RWSUI.KeepEdit = 'yes';
        return
    end
end
MFEVO.name = name;
MFEVO.type = 'Analysis';   

%---------------------------------------------
% Return
%---------------------------------------------
SCRPTipt(indnum).entrystr = name;
SCRPTGBL.RWSUI.SaveVariables = {MFEVO};
SCRPTGBL.RWSUI.SaveVariableNames = {'MFEVO'};
SCRPTGBL.RWSUI.SaveGlobal = 'yes';
SCRPTGBL.RWSUI.SaveGlobalNames = name;
SCRPTGBL.RWSUI.SaveScriptOption = 'yes';
SCRPTGBL.RWSUI.SaveScriptPath = 'outloc';
SCRPTGBL.RWSUI.SaveScriptName = name;

Status('done','');
Status2('done','',2);
Status2('done','',3);
