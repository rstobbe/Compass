%===========================================
% (v1a)
%    
%===========================================

function [SCRPTipt,SCRPTGBL,err] = ShimImageIntenseLoad_v1a(SCRPTipt,SCRPTGBL)

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
IMG.shimfunc = SCRPTGBL.CurrentTree.('IntenseShimfunc').Func;

%---------------------------------------------
% Load Image
%---------------------------------------------
Im = SCRPTGBL.Image_File_Data.IMG.Im;
ReconPars = SCRPTGBL.Image_File_Data.IMG.ReconPars;

%---------------------------------------------
% Get Working Structures from Sub Functions
%---------------------------------------------
ISHIMipt = SCRPTGBL.CurrentTree.('IntenseShimfunc');
if isfield(SCRPTGBL,('IntenseShimfunc_Data'))
    ISHIMipt.IntenseShimfunc_Data = SCRPTGBL.IntenseShimfunc_Data;
end

%------------------------------------------
% Get Shim Function Info
%------------------------------------------
func = str2func(IMG.shimfunc);           
[SCRPTipt,ISHIM,err] = func(SCRPTipt,ISHIMipt);
if err.flag
    return
end

%---------------------------------------------
% 
%---------------------------------------------
func = str2func([IMG.method,'_Func']);
INPUT.Im = Im;
INPUT.ReconPars = ReconPars;
INPUT.ISHIM = ISHIM;
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

