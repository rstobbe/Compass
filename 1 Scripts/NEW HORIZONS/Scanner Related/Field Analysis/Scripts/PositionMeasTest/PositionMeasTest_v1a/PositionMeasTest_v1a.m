%====================================================
% (v1a)
%       - 
%====================================================

function [SCRPTipt,SCRPTGBL,err] = PositionMeasTest_v1a(SCRPTipt,SCRPTGBL)

Status('busy','Determine Probe Position');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Clear Naming
%---------------------------------------------
inds = strcmp('Eddy_Name',{SCRPTipt.labelstr});
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
EDDY.method = SCRPTGBL.CurrentTree.Func;
EDDY.fevolfunc = SCRPTGBL.CurrentTree.('FieldEvoLoadfunc').Func;
EDDY.psbgfunc = SCRPTGBL.CurrentTree.('PosBgrndfunc').Func;

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

%------------------------------------------
% Position and BackGround Function Info
%------------------------------------------
func = str2func(EDDY.fevolfunc);           
[SCRPTipt,FEVOL,err] = func(SCRPTipt,FEVOLipt);
if err.flag
    return
end
func = str2func(EDDY.psbgfunc);           
[SCRPTipt,POSBG,err] = func(SCRPTipt,POSBGipt);
if err.flag
    return
end

%---------------------------------------------
% Determine Eddy Currents
%---------------------------------------------
func = str2func([EDDY.method,'_Func']);
INPUT.FEVOL = FEVOL;
INPUT.POSBG = POSBG;
[EDDY,err] = func(EDDY,INPUT);
if err.flag
    return
end

%--------------------------------------------
% Output to TextBox
%--------------------------------------------
global FIGOBJS
FIGOBJS.(SCRPTGBL.RWSUI.tab).Info.String = EDDY.ExpDisp;

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
        SCRPTGBL.RWSUI.SaveVariables = {EDDY};
        SCRPTGBL.RWSUI.KeepEdit = 'yes';
        return
    end
end
EDDY.name = name;
EDDY.type = 'Analysis';   

%---------------------------------------------
% Return
%---------------------------------------------
SCRPTipt(indnum).entrystr = name;
SCRPTGBL.RWSUI.SaveVariables = {EDDY};
SCRPTGBL.RWSUI.SaveVariableNames = {'EDDY'};
SCRPTGBL.RWSUI.SaveGlobal = 'yes';
SCRPTGBL.RWSUI.SaveGlobalNames = name;
SCRPTGBL.RWSUI.SaveScriptOption = 'yes';
SCRPTGBL.RWSUI.SaveScriptPath = 'outloc';
SCRPTGBL.RWSUI.SaveScriptName = name;

Status('done','');
Status2('done','',2);
Status2('done','',3);
