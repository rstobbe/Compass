%===========================================
% (v2c)
%       Large Input Array
%===========================================

function [SCRPTipt,SCRPTGBL,err] = ShimB0Cal_v2c(SCRPTipt,SCRPTGBL)

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
CAL.method = SCRPTGBL.CurrentTree.Func;
CAL.shimfunc = SCRPTGBL.CurrentTree.('B0Shimfunc').Func;

%---------------------------------------------
% Load Image
%---------------------------------------------
Im{1} = SCRPTGBL.Image_base_Data.IMG.Im;
ReconPars(1) = SCRPTGBL.Image_base_Data.IMG.ReconPars;
Shim(1) = SCRPTGBL.Image_base_Data.IMG.FID.Shim;
Im{2} = SCRPTGBL.Image_z1c_Data.IMG.Im;
ReconPars(2) = SCRPTGBL.Image_z1c_Data.IMG.ReconPars;
Shim(2) = SCRPTGBL.Image_z1c_Data.IMG.FID.Shim;
Im{3} = SCRPTGBL.Image_z2c_Data.IMG.Im;
ReconPars(3) = SCRPTGBL.Image_z2c_Data.IMG.ReconPars;
Shim(3) = SCRPTGBL.Image_z2c_Data.IMG.FID.Shim;
Im{4} = SCRPTGBL.Image_z3c_Data.IMG.Im;
ReconPars(4) = SCRPTGBL.Image_z3c_Data.IMG.ReconPars;
Shim(4) = SCRPTGBL.Image_z3c_Data.IMG.FID.Shim;
Im{5} = SCRPTGBL.Image_z4c_Data.IMG.Im;
ReconPars(5) = SCRPTGBL.Image_z4c_Data.IMG.ReconPars;
Shim(5) = SCRPTGBL.Image_z4c_Data.IMG.FID.Shim;
Im{6} = SCRPTGBL.Image_x1_Data.IMG.Im;
ReconPars(6) = SCRPTGBL.Image_x1_Data.IMG.ReconPars;
Shim(6) = SCRPTGBL.Image_x1_Data.IMG.FID.Shim;
Im{7} = SCRPTGBL.Image_y1_Data.IMG.Im;
ReconPars(7) = SCRPTGBL.Image_y1_Data.IMG.ReconPars;
Shim(7) = SCRPTGBL.Image_y1_Data.IMG.FID.Shim;
Im{8} = SCRPTGBL.Image_xz_Data.IMG.Im;
ReconPars(8) = SCRPTGBL.Image_xz_Data.IMG.ReconPars;
Shim(8) = SCRPTGBL.Image_xz_Data.IMG.FID.Shim;
Im{9} = SCRPTGBL.Image_yz_Data.IMG.Im;
ReconPars(9) = SCRPTGBL.Image_yz_Data.IMG.ReconPars;
Shim(9) = SCRPTGBL.Image_yz_Data.IMG.FID.Shim;
Im{10} = SCRPTGBL.Image_xy_Data.IMG.Im;
ReconPars(10) = SCRPTGBL.Image_xy_Data.IMG.ReconPars;
Shim(10) = SCRPTGBL.Image_xy_Data.IMG.FID.Shim;
Im{11} = SCRPTGBL.Image_x2y2_Data.IMG.Im;
ReconPars(11) = SCRPTGBL.Image_x2y2_Data.IMG.ReconPars;
Shim(11) = SCRPTGBL.Image_x2y2_Data.IMG.FID.Shim;
Im{12} = SCRPTGBL.Image_x3_Data.IMG.Im;
ReconPars(12) = SCRPTGBL.Image_x3_Data.IMG.ReconPars;
Shim(12) = SCRPTGBL.Image_x3_Data.IMG.FID.Shim;
Im{13} = SCRPTGBL.Image_y3_Data.IMG.Im;
ReconPars(13) = SCRPTGBL.Image_y3_Data.IMG.ReconPars;
Shim(13) = SCRPTGBL.Image_y3_Data.IMG.FID.Shim;
Im{14} = SCRPTGBL.Image_xz2_Data.IMG.Im;
ReconPars(14) = SCRPTGBL.Image_xz2_Data.IMG.ReconPars;
Shim(14) = SCRPTGBL.Image_xz2_Data.IMG.FID.Shim;
Im{15} = SCRPTGBL.Image_yz2_Data.IMG.Im;
ReconPars(15) = SCRPTGBL.Image_yz2_Data.IMG.ReconPars;
Shim(15) = SCRPTGBL.Image_yz2_Data.IMG.FID.Shim;
Im{16} = SCRPTGBL.Image_zxy_Data.IMG.Im;
ReconPars(16) = SCRPTGBL.Image_zxy_Data.IMG.ReconPars;
Shim(16) = SCRPTGBL.Image_zxy_Data.IMG.FID.Shim;
Im{17} = SCRPTGBL.Image_zx2y2_Data.IMG.Im;
ReconPars(17) = SCRPTGBL.Image_zx2y2_Data.IMG.ReconPars;
Shim(17) = SCRPTGBL.Image_zx2y2_Data.IMG.FID.Shim;

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
func = str2func(CAL.shimfunc);           
[SCRPTipt,B0SHIM,err] = func(SCRPTipt,B0SHIMipt);
if err.flag
    return
end

%---------------------------------------------
% 
%---------------------------------------------
func = str2func([CAL.method,'_Func']);
INPUT.Im = Im;
INPUT.ReconPars = ReconPars;
INPUT.B0SHIM = B0SHIM;
INPUT.Shim = Shim;
[CAL,err] = func(CAL,INPUT);
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

SCRPTGBL.RWSUI.SaveVariables = {CAL};
SCRPTGBL.RWSUI.SaveVariableNames = {'CAL'};
SCRPTGBL.RWSUI.SaveGlobal = 'yes';
SCRPTGBL.RWSUI.SaveGlobalNames = name;
SCRPTGBL.RWSUI.SaveScriptOption = 'yes';
SCRPTGBL.RWSUI.SaveScriptPath = 'outloc';
SCRPTGBL.RWSUI.SaveScriptName = name;

Status('done','');
Status2('done','',2);
Status2('done','',3);

