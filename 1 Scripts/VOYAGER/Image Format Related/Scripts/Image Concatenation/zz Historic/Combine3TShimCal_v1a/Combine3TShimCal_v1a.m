%===========================================
% (v1a)
%    
%===========================================

function [SCRPTipt,SCRPTGBL,err] = Combine3TShimCal_v1a(SCRPTipt,SCRPTGBL)

Status('busy','Combine Images');
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
% Return Panel Input
%---------------------------------------------
IMG.method = SCRPTGBL.CurrentTree.Func;

%---------------------------------------------
% Load Image
%---------------------------------------------
IMG1 = SCRPTGBL.Image_File1_Data.IMG;
IMG2 = SCRPTGBL.Image_File2_Data.IMG;
ShimFile = SCRPTGBL.Shim_File_Data;

%---------------------------------------------
% B0 Map
%---------------------------------------------
func = str2func([IMG.method,'_Func']);
INPUT.IMG1 = IMG1;
INPUT.IMG2 = IMG2;
INPUT.ShimFile = ShimFile;
[IMG,err] = func(IMG,INPUT);
if err.flag
    return
end

%--------------------------------------------
% Output to TextBox
%--------------------------------------------
IMG.ExpDisp = PanelStruct2Text(IMG.PanelOutput);
set(findobj('tag','TestBox'),'string',IMG.ExpDisp);

%--------------------------------------------
% Return
%--------------------------------------------
name = inputdlg('Name Image:');
if isempty(name)
    SCRPTGBL.RWSUI.SaveGlobal = 'no';
    return
end
SCRPTipt(indnum).entrystr = cell2mat(name);

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

