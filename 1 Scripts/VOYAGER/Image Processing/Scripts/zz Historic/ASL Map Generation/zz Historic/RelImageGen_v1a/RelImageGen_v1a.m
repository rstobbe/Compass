%=========================================================
% (v1a)
%
%=========================================================

function [SCRPTipt,SCRPTGBL,err] = RelImageGen_v1a(SCRPTipt,SCRPTGBL)

Status('busy','Image Division-Based Comparison');
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

%---------------------------------------------
% Tests
%---------------------------------------------


%---------------------------------------------
% Load Input
%---------------------------------------------
COMP.script = SCRPTGBL.CurrentTree.Func;

%---------------------------------------------
% Load Images
%---------------------------------------------
Im1 = SCRPTGBL.Image1_File_Data.IMG.Im;
sz = size(Im1);
Ims = zeros([sz(1:3),2]);
Ims(:,:,:,1) = Im1(:,:,:,1);
Ims(:,:,:,2) = SCRPTGBL.Image2_File_Data.IMG.Im(:,:,:,1);

%---------------------------------------------
% Correct DWI Image
%---------------------------------------------
func = str2func([COMP.script,'_Func']);
INPUT.COMP = COMP;
INPUT.Ims = Ims;
[COMP,err] = func(INPUT,COMP);
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

