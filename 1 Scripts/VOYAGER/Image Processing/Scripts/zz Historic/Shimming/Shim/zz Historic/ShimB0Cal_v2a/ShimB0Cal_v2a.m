%===========================================
% (v2a)
%       
%===========================================

function [SCRPTipt,SCRPTGBL,err] = ShimB0Cal_v2a(SCRPTipt,SCRPTGBL)

Status('busy','Shim Image Intensity');
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
IMG.shimfunc = SCRPTGBL.CurrentTree.('B0Shimfunc').Func;

%---------------------------------------------
% Load Image
%---------------------------------------------
ImB = SCRPTGBL.ImageB_File_Data.IMG.Im;
ImV = SCRPTGBL.ImageV_File_Data.IMG.Im;
ReconParsB = SCRPTGBL.ImageB_File_Data.IMG.ReconPars;
ReconParsV = SCRPTGBL.ImageV_File_Data.IMG.ReconPars;

%---------------------------------------------
% Get Working Structures from Sub Functions
%---------------------------------------------
B0SHIMipt = SCRPTGBL.CurrentTree.('B0Shimfunc');
if isfield(SCRPTGBL,('B0Shimfunc_Data'))
    B0SHIMipt.B0Shimfunc_Data = SCRPTGBL.B0Shimfunc_Data;
end

%------------------------------------------
% Get Shim Function Info
%------------------------------------------
func = str2func(IMG.shimfunc);           
[SCRPTipt,B0SHIM,err] = func(SCRPTipt,B0SHIMipt);
if err.flag
    return
end

%---------------------------------------------
% 
%---------------------------------------------
func = str2func([IMG.method,'_Func']);
INPUT.ImB = ImB;
INPUT.ImV = ImV;
INPUT.ReconParsB = ReconParsB;
INPUT.ReconParsV = ReconParsV;
INPUT.B0SHIM = B0SHIM;
[IMG,err] = func(IMG,INPUT);
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

SCRPTGBL.RWSUI.SaveVariables = {IMG};
SCRPTGBL.RWSUI.SaveVariableNames = 'IMG';
SCRPTGBL.RWSUI.SaveGlobal = 'yes';
SCRPTGBL.RWSUI.SaveGlobalNames = name;
SCRPTGBL.RWSUI.SaveScriptOption = 'yes';
SCRPTGBL.RWSUI.SaveScriptPath = 'outloc';
SCRPTGBL.RWSUI.SaveScriptName = name;

Status('done','');
Status2('done','',2);
Status2('done','',3);

