%=====================================================
% (v1a) 
%        
%=====================================================

function [SCRPTipt,SCRPTGBL,err] = Study_MS_v1a(SCRPTipt,SCRPTGBL)

Status('busy','Build MS Study');
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
SBLD.method = SCRPTGBL.CurrentTree.Func;
SBLD.selectfunc = SCRPTGBL.CurrentTree.('ExcelSelectfunc').Func;

%---------------------------------------------
% Get Working Structures from Sub Functions
%---------------------------------------------
SLCTipt = SCRPTGBL.CurrentTree.('ExcelSelectfunc');
if isfield(SCRPTGBL,('ExcelSelectfunc_Data'))
    SLCTipt.ExcelSelectfunc_Data = SCRPTGBL.ExcelSelectfunc_Data;
end

%------------------------------------------
% Get Function Info
%------------------------------------------
func = str2func(SBLD.selectfunc);           
[SCRPTipt,SCRPTGBL,SLCT,err] = func(SCRPTipt,SCRPTGBL,SLCTipt);
if err.flag
    return
end
Files = SLCT.Files;

%---------------------------------------------
% Build Study
%---------------------------------------------
func = str2func([SBLD.method,'_Func']);
INPUT.Files = Files;
[SBLD,err] = func(SBLD,INPUT);
if err.flag
    return
end
clear INPUT;

%--------------------------------------------
% Output to TextBox
%--------------------------------------------
global FIGOBJS
FIGOBJS.(SCRPTGBL.RWSUI.tab).Info.String = SBLD.ExpDisp;

%--------------------------------------------
% Name
%--------------------------------------------
name = 'STUDY_';

%--------------------------------------------
% Return
%--------------------------------------------
name = inputdlg('Name Study:','Name',1,{name});
if isempty(name)
    SCRPTGBL.RWSUI.SaveGlobal = 'no';
    return
end
SBLD.name = name{1};
SBLD.structname = 'SBLD';

SCRPTipt(indnum).entrystr = name;
SCRPTGBL.RWSUI.SaveVariables = {SBLD};
SCRPTGBL.RWSUI.SaveVariableNames = {'SBLD'};
SCRPTGBL.RWSUI.SaveGlobal = 'yes';
SCRPTGBL.RWSUI.SaveGlobalNames = name;
SCRPTGBL.RWSUI.SaveScriptOption = 'yes';
SCRPTGBL.RWSUI.SaveScriptPath = 'outloc';
SCRPTGBL.RWSUI.SaveScriptName = name;

Status('done','');
Status2('done','',2);
Status2('done','',3);
