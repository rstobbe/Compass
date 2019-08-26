%===========================================
% 
%===========================================

function [SCRPTipt,SCRPTGBL,err] = StabilityCheck_v1b(SCRPTipt,SCRPTGBL)

Status('busy','Check Image Stability');
Status2('done','',2);
Status2('done','',3);

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
DispScriptParam_B9(SCRPTipt,setfunc,SCRPTGBL.RWSUI.panel);

%---------------------------------------------
% Load Input
%---------------------------------------------
TST.method = SCRPTGBL.CurrentTree.Func;
TST.type = SCRPTGBL.CurrentTree.('Type');
TST.loadfunc = SCRPTGBL.CurrentTree.('Loadfunc').Func;

%---------------------------------------------
% Get Working Structures from Sub Functions
%---------------------------------------------
LOADipt = SCRPTGBL.CurrentTree.('Loadfunc');
if isfield(SCRPTGBL,('Loadfunc_Data'))
    LOADipt.Loadfunc_Data = SCRPTGBL.Loadfunc_Data;
end

%------------------------------------------
% Get Function Info
%------------------------------------------
func = str2func(TST.loadfunc);           
[SCRPTipt,LOAD,err] = func(SCRPTipt,LOADipt);
if err.flag
    return
end

%---------------------------------------------
% Test Stability
%---------------------------------------------
func = str2func([TST.method,'_Func']);
INPUT.LOAD = LOAD;
[TST,err] = func(TST,INPUT);
if err.flag
    return
end

%--------------------------------------------
% Return
%--------------------------------------------
name = inputdlg('Name Image:');
if isempty(name)
    SCRPTGBL.RWSUI.SaveGlobal = 'no';
    return
end
SCRPTipt(indnum).entrystr = cell2mat(name);

SCRPTGBL.RWSUI.SaveVariables = {COMP};
SCRPTGBL.RWSUI.SaveVariableNames = 'COMP';
SCRPTGBL.RWSUI.SaveGlobal = 'yes';
SCRPTGBL.RWSUI.SaveGlobalNames = name;
SCRPTGBL.RWSUI.SaveScriptOption = 'yes';
SCRPTGBL.RWSUI.SaveScriptPath = 'outloc';
SCRPTGBL.RWSUI.SaveScriptName = name;

Status('done','');
Status2('done','',2);
Status2('done','',3);
