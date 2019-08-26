%====================================================
% (v1a)
%       - 
%====================================================

function [SCRPTipt,SCRPTGBL,err] = FidAnlz_v1a(SCRPTipt,SCRPTGBL)

Status('busy','Single Fid Analysis');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Clear Naming
%---------------------------------------------
inds = strcmp('Anlz_Name',{SCRPTipt.labelstr});
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
ANLZ.method = SCRPTGBL.CurrentTree.Func;
ANLZ.fevolfunc = SCRPTGBL.CurrentTree.('FieldEvoLoadfunc').Func;
ANLZ.psbgfunc = SCRPTGBL.CurrentTree.('FidAnlzfunc').Func;

%---------------------------------------------
% Get Working Structures
%---------------------------------------------
FEVOLipt = SCRPTGBL.CurrentTree.('FieldEvoLoadfunc');
if isfield(SCRPTGBL,('FieldEvoLoadfunc_Data'))
    FEVOLipt.FieldEvoLoadfunc_Data = SCRPTGBL.FieldEvoLoadfunc_Data;
end
FIDANLZipt = SCRPTGBL.CurrentTree.('FidAnlzfunc');
if isfield(SCRPTGBL,('FidAnlzfunc_Data'))
    FIDANLZipt.FidAnlzfunc_Data = SCRPTGBL.FidAnlzfunc_Data;
end

%------------------------------------------
% Position and BackGround Function Info
%------------------------------------------
func = str2func(ANLZ.fevolfunc);           
[SCRPTipt,FEVOL,err] = func(SCRPTipt,FEVOLipt);
if err.flag
    return
end
func = str2func(ANLZ.psbgfunc);           
[SCRPTipt,FIDANLZ,err] = func(SCRPTipt,FIDANLZipt);
if err.flag
    return
end

%---------------------------------------------
% Determine Eddy Currents
%---------------------------------------------
func = str2func([ANLZ.method,'_Func']);
INPUT.FEVOL = FEVOL;
INPUT.FIDANLZ = FIDANLZ;
[ANLZ,err] = func(ANLZ,INPUT);
if err.flag
    return
end

%--------------------------------------------
% Output to TextBox
%--------------------------------------------
global FIGOBJS
FIGOBJS.(SCRPTGBL.RWSUI.tab).Info.String = ANLZ.ExpDisp;

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
        SCRPTGBL.RWSUI.SaveVariables = {ANLZ};
        SCRPTGBL.RWSUI.KeepEdit = 'yes';
        return
    end
end
ANLZ.name = name;
ANLZ.type = 'Analysis';   

%---------------------------------------------
% Return
%---------------------------------------------
SCRPTipt(indnum).entrystr = name;
SCRPTGBL.RWSUI.SaveVariables = {ANLZ};
SCRPTGBL.RWSUI.SaveVariableNames = {'ANLZ'};
SCRPTGBL.RWSUI.SaveGlobal = 'yes';
SCRPTGBL.RWSUI.SaveGlobalNames = name;
SCRPTGBL.RWSUI.SaveScriptOption = 'yes';
SCRPTGBL.RWSUI.SaveScriptPath = 'outloc';
SCRPTGBL.RWSUI.SaveScriptName = name;

Status('done','');
Status2('done','',2);
Status2('done','',3);
