%=========================================================
% (v1a) 
%       
%=========================================================

function [SCRPTipt,SCRPTGBL,err] = T1_Contrast_v1a(SCRPTipt,SCRPTGBL)

Status('busy','T1 CNR Optimization');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Clear Naming
%---------------------------------------------
inds = strcmp('Design_Name',{SCRPTipt.labelstr});
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
DES.method = SCRPTGBL.CurrentTree.Func;
DES.testfunc = SCRPTGBL.CurrentTree.('Testfunc').Func;
DES.T1(1) = str2double(SCRPTGBL.CurrentTree.('T1_tissue1'));
DES.T1(2) = str2double(SCRPTGBL.CurrentTree.('T1_tissue2'));

%---------------------------------------------
% Get Working Structures from Sub Functions
%---------------------------------------------
TSTipt = SCRPTGBL.CurrentTree.('Testfunc');
if isfield(SCRPTGBL,('Testfunc_Data'))
    TSTipt.Testfunc_Data = SCRPTGBL.Testfunc_Data;
end
func = str2func(DES.testfunc);           
[SCRPTipt,TST,err] = func(SCRPTipt,TSTipt);
if err.flag
    return
end

%---------------------------------------------
% Ren
%---------------------------------------------
func = str2func([DES.method,'_Func']);
INPUT.TST = TST;
[DES,err] = func(DES,INPUT);
if err.flag
    return
end

%--------------------------------------------
% Output to TextBox
%--------------------------------------------
global FIGOBJS
FIGOBJS.(SCRPTGBL.RWSUI.tab).Info.String = DES.ExpDisp;

%--------------------------------------------
% Return
%--------------------------------------------
name = inputdlg('Name Study Design:');
if isempty(name)
    SCRPTGBL.RWSUI.SaveGlobal = 'no';
    return
end
SCRPTipt(indnum).entrystr = cell2mat(name);

SCRPTGBL.RWSUI.SaveVariables = {DES};
SCRPTGBL.RWSUI.SaveVariableNames = {'DES'};
SCRPTGBL.RWSUI.SaveGlobal = 'yes';
SCRPTGBL.RWSUI.SaveGlobalNames = name;
SCRPTGBL.RWSUI.SaveScriptOption = 'yes';
SCRPTGBL.RWSUI.SaveScriptPath = 'outloc';
SCRPTGBL.RWSUI.SaveScriptName = name{1};
