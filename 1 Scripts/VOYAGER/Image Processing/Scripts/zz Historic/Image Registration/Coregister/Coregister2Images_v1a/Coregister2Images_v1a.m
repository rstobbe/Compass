%=========================================================
% (v1a) 
%   
%=========================================================

function [SCRPTipt,SCRPTGBL,err] = Coregister2Images_v1a(SCRPTipt,SCRPTGBL)

Status('busy','Coregister Images');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Clear Naming
%---------------------------------------------
inds = strcmp('Image_Name',{SCRPTipt.labelstr});
indnum = find(inds==1);
if length(indnum) > 1
    indnum = indnum(SCRPTGBL.RWSUI.scrptnum);
end
SCRPTipt(indnum).entrystr = '';
setfunc = 1;
DispScriptParam(SCRPTipt,setfunc,SCRPTGBL.RWSUI.tab,SCRPTGBL.RWSUI.panelnum);

%---------------------------------------------
% Get Panel Input
%---------------------------------------------
COREG.method = SCRPTGBL.CurrentTree.Func;
COREG.loadfunc = SCRPTGBL.CurrentTree.('ImLoadfunc').Func;
COREG.coregfunc = SCRPTGBL.CurrentTree.('Coregfunc').Func;

%---------------------------------------------
% Get Working Structures from Sub Functions
%---------------------------------------------
LOADipt = SCRPTGBL.CurrentTree.('ImLoadfunc');
if isfield(SCRPTGBL,('ImLoadfunc_Data'))
    LOADipt.ImLoadfunc_Data = SCRPTGBL.ImLoadfunc_Data;
end
REGFNCipt = SCRPTGBL.CurrentTree.('Coregfunc');
if isfield(SCRPTGBL,('Coregfunc_Data'))
    REGFNCipt.Coregfunc_Data = SCRPTGBL.Coregfunc_Data;
end

%------------------------------------------
% Get Function Info
%------------------------------------------
func = str2func(COREG.loadfunc);           
[SCRPTipt,SCRPTGBL,LOAD,err] = func(SCRPTipt,SCRPTGBL,LOADipt);
if err.flag
    return
end
IMG = LOAD.IMG;
clear LOAD;
func = str2func(COREG.coregfunc);           
[SCRPTipt,REGFNC,err] = func(SCRPTipt,REGFNCipt);
if err.flag
    return
end

%---------------------------------------------
% Run
%---------------------------------------------
func = str2func([COREG.method,'_Func']);
INPUT.IMG = IMG;
INPUT.REGFNC = REGFNC;
[COREG,err] = func(COREG,INPUT);
if err.flag
    return
end

%--------------------------------------------
% Return
%--------------------------------------------
name = inputdlg('Name Registration:');
if isempty(name)
    SCRPTGBL.RWSUI.KeepEdit = 'yes';
    return
end

%---------------------------------------------
% Naming
%---------------------------------------------
SCRPTipt(indnum).entrystr = cell2mat(name);

SCRPTGBL.RWSUI.SaveVariables = {COREG};
SCRPTGBL.RWSUI.SaveVariableNames = {'COREG'};
SCRPTGBL.RWSUI.SaveGlobal = 'yes';
SCRPTGBL.RWSUI.SaveGlobalNames = name;
SCRPTGBL.RWSUI.SaveScriptOption = 'yes';
SCRPTGBL.RWSUI.SaveScriptPath = 'outloc';
SCRPTGBL.RWSUI.SaveScriptName = cell2mat(name);

Status('done','');
Status2('done','',2);
Status2('done','',3);

