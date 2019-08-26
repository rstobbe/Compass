%=========================================================
% (v1a) 
%   
%=========================================================

function [SCRPTipt,SCRPTGBL,err] = LoadLocal_v1a(SCRPTipt,SCRPTGBL)

Status('busy','Load Image');
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
% Get Input
%---------------------------------------------
LDTOP.method = SCRPTGBL.CurrentScript.Func;
LDTOP.loadfunc = SCRPTGBL.CurrentTree.('LoadImagefunc').Func;

%---------------------------------------------
% Get Working Structures from Sub Functions
%---------------------------------------------
LOADipt = SCRPTGBL.CurrentTree.('LoadImagefunc');
if isfield(SCRPTGBL,('LoadImagefunc_Data'))
    LOADipt.LoadImagefunc_Data = SCRPTGBL.LoadImagefunc_Data;
end

%------------------------------------------
% Get Load Function Info
%------------------------------------------
func = str2func(LDTOP.loadfunc);           
[SCRPTipt,LOAD,err] = func(SCRPTipt,LOADipt);
if err.flag
    return
end

%---------------------------------------------
% Load
%---------------------------------------------
func = str2func([LDTOP.method,'_Func']);
INPUT.LOAD = LOAD;
[LDTOP,err] = func(LDTOP,INPUT);
if err.flag
    return
end
IMG = LDTOP.IMG;

%--------------------------------------------
% Return
%--------------------------------------------
name = inputdlg('Name Image:','Name Image',1,{'IMG_'});
name = cell2mat(name);
if isempty(name)
    SCRPTGBL.RWSUI.KeepEdit = 'yes';
    return
end

%---------------------------------------------
% Naming
%---------------------------------------------
SCRPTipt(indnum).entrystr = name;
SCRPTGBL.RWSUI.SaveVariables = {IMG};
SCRPTGBL.RWSUI.SaveVariableNames = {'IMG'};
SCRPTGBL.RWSUI.SaveGlobal = 'yes';
SCRPTGBL.RWSUI.SaveGlobalNames = name;
SCRPTGBL.RWSUI.SaveScriptOption = 'yes';
SCRPTGBL.RWSUI.SaveScriptPath = 'outloc';
SCRPTGBL.RWSUI.SaveScriptName = name;

Status('done','');
Status2('done','',2);
Status2('done','',3);

