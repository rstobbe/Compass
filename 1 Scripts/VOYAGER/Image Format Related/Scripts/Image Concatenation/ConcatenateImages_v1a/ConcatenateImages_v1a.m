%===========================================
% (v1a)
%    
%===========================================

function [SCRPTipt,SCRPTGBL,err] = ConcatenateImages_v1a(SCRPTipt,SCRPTGBL)

Status('busy','Concatenate Images');
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
% Return Panel Input
%---------------------------------------------
CONCAT.method = SCRPTGBL.CurrentTree.Func;
CONCAT.loadfunc = SCRPTGBL.CurrentTree.('LoadImagefunc').Func;

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
func = str2func(CONCAT.loadfunc);           
[SCRPTipt,SCRPTGBL,LOAD,err] = func(SCRPTipt,SCRPTGBL,LOADipt);
if err.flag
    return
end
IMG = LOAD.IMG;

%---------------------------------------------
% Concatenate
%---------------------------------------------
func = str2func([CONCAT.method,'_Func']);
INPUT.IMG = IMG;
[CONCAT,err] = func(CONCAT,INPUT);
if err.flag
    return
end

%--------------------------------------------
% Output to TextBox
%--------------------------------------------
CONCAT.ExpDisp = PanelStruct2Text(CONCAT.PanelOutput);
set(findobj('tag','TestBox'),'string',CONCAT.ExpDisp);

%--------------------------------------------
% Name
%--------------------------------------------
name = inputdlg('Name Image:','Name Image',1,{'CONCAT_'});
name = cell2mat(name);
if isempty(name)
    SCRPTGBL.RWSUI.KeepEdit = 'yes';
    return
end
CONCAT.name = name;
CONCAT.path = IMG{1}.path;

%--------------------------------------------
% Return
%--------------------------------------------
SCRPTipt(indnum).entrystr = name;
SCRPTGBL.RWSUI.SaveVariables = {CONCAT};
SCRPTGBL.RWSUI.SaveVariableNames = {'CONCAT'};
SCRPTGBL.RWSUI.SaveGlobal = 'yes';
SCRPTGBL.RWSUI.SaveGlobalNames = name;
SCRPTGBL.RWSUI.SaveScriptOption = 'yes';
SCRPTGBL.RWSUI.SaveScriptPath = CONCAT.path;
SCRPTGBL.RWSUI.SaveScriptName = name;

Status('done','');
Status2('done','',2);
Status2('done','',3);
