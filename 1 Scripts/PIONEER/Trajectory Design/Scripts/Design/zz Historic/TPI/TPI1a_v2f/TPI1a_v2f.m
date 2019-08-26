%====================================================
% (TPI1)
%       - 'p' is selector
% (a)
%       - no k-space overshoot for spiral effect
% (v2f)
%       - output gamma at edge (no functionality change)
%====================================================

function [SCRPTipt,SCRPTGBL,err] = TPI1a_v2f(SCRPTipt,SCRPTGBL)

Status('busy','Create Design');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Clear Naming
%---------------------------------------------
SCRPTipt(strcmp('Design_Name',{SCRPTipt.labelstr})).entrystr = '';

%---------------------------------------------
% Load Input
%---------------------------------------------
PROJdgn.method = SCRPTGBL.CurrentTree.Func;
PROJdgn.fov = str2double(SCRPTGBL.CurrentTree.FoV);
PROJdgn.vox = str2double(SCRPTGBL.CurrentTree.Vox);
PROJdgn.tro = str2double(SCRPTGBL.CurrentTree.Tro);
PROJdgn.nproj = str2double(SCRPTGBL.CurrentTree.Nproj);
PROJdgn.p = str2double(SCRPTGBL.CurrentTree.p);
PROJdgn.elip = str2double(SCRPTGBL.CurrentTree.Elip);
PROJdgn.gamfunc = SCRPTGBL.CurrentTree.Gamfunc.Func;

%---------------------------------------------
% Get Working Structures from Sub Functions
%---------------------------------------------
GAMFUNCipt = SCRPTGBL.CurrentTree.('Gamfunc');
if isfield(SCRPTGBL,('Gamfunc_Data'))
    GAMFUNCipt.Gamfunc_Data = SCRPTGBL.Gamfunc_Data;
end

%------------------------------------------
% Get Gamma Function Info
%------------------------------------------
func = str2func(PROJdgn.gamfunc);           
[SCRPTipt,GAMFUNC,err] = func(SCRPTipt,GAMFUNCipt);
if err.flag
    return
end

%---------------------------------------------
% Generate TPI Design parameters
%---------------------------------------------
func = str2func([PROJdgn.method,'_Func']);
INPUT.PROJdgn = PROJdgn;
INPUT.GAMFUNC = GAMFUNC;
[DES,err] = func(INPUT);
if err.flag
    return
end

%---------------------------------------------
% Panel Output
%--------------------------------------------- 
SCRPTGBL.RWSUI.LocalOutput = DES.PanelOutput;

%--------------------------------------------
% Output to TextBox
%--------------------------------------------
DES.ExpDisp = PanelStruct2Text(DES.PanelOutput);
set(findobj('tag','TestBox'),'string',DES.ExpDisp);

%--------------------------------------------
% Return
%--------------------------------------------
name = inputdlg('Name Design:','Name',1,{'DES_'});
if isempty(name)
    SCRPTGBL.RWSUI.SaveGlobal = 'no';
    return
end

%--------------------------------------------
% Output
%--------------------------------------------
inds = strcmp('Design_Name',{SCRPTipt.labelstr});
indnum = find(inds==1);
if length(indnum) > 1
    indnum = indnum(SCRPTGBL.RWSUI.scrptnum);
end
SCRPTipt(indnum).entrystr = cell2mat(name);

SCRPTGBL.RWSUI.SaveVariables = {DES};
SCRPTGBL.RWSUI.SaveVariableNames = {'DES'};
SCRPTGBL.RWSUI.SaveGlobal = 'yes';
SCRPTGBL.RWSUI.SaveGlobalNames = name;
SCRPTGBL.RWSUI.SaveScriptOption = 'yes';
SCRPTGBL.RWSUI.SaveScriptPath = 'outloc';
SCRPTGBL.RWSUI.SaveScriptName = 'ProjDes';

Status('done','');
Status2('done','',2);
Status2('done','',3);

