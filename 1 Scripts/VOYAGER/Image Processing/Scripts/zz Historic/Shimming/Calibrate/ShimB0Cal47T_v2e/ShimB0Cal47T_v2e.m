%===========================================
% (v2e)
%      - add 'ReconPars' to CAL output
%===========================================

function [SCRPTipt,SCRPTGBL,err] = ShimB0Cal47T_v2e(SCRPTipt,SCRPTGBL)

Status('busy','Measure Shim Coil Effects');
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
CAL.shimfunc = SCRPTGBL.CurrentTree.('ShimCalfunc').Func;

%---------------------------------------------
% Load Image
%---------------------------------------------
Im{1} = SCRPTGBL.Image_base_Data.IMG.Im;
ReconPars(1) = SCRPTGBL.Image_base_Data.IMG.ReconPars;
ExpPars(1) = SCRPTGBL.Image_base_Data.IMG.ExpPars;
Shim(1) = SCRPTGBL.Image_base_Data.IMG.FID.Shim;
Im{2} = SCRPTGBL.Image_z1c_Data.IMG.Im;
ReconPars(2) = SCRPTGBL.Image_z1c_Data.IMG.ReconPars;
ExpPars(2) = SCRPTGBL.Image_z1c_Data.IMG.ExpPars;
Shim(2) = SCRPTGBL.Image_z1c_Data.IMG.FID.Shim;
Im{3} = SCRPTGBL.Image_z2c_Data.IMG.Im;
ReconPars(3) = SCRPTGBL.Image_z2c_Data.IMG.ReconPars;
ExpPars(3) = SCRPTGBL.Image_z2c_Data.IMG.ExpPars;
Shim(3) = SCRPTGBL.Image_z2c_Data.IMG.FID.Shim;
Im{4} = SCRPTGBL.Image_z3c_Data.IMG.Im;
ReconPars(4) = SCRPTGBL.Image_z3c_Data.IMG.ReconPars;
ExpPars(4) = SCRPTGBL.Image_z3c_Data.IMG.ExpPars;
Shim(4) = SCRPTGBL.Image_z3c_Data.IMG.FID.Shim;
Im{5} = SCRPTGBL.Image_z4c_Data.IMG.Im;
ReconPars(5) = SCRPTGBL.Image_z4c_Data.IMG.ReconPars;
ExpPars(5) = SCRPTGBL.Image_z4c_Data.IMG.ExpPars;
Shim(5) = SCRPTGBL.Image_z4c_Data.IMG.FID.Shim;
Im{6} = SCRPTGBL.Image_x1_Data.IMG.Im;
ReconPars(6) = SCRPTGBL.Image_x1_Data.IMG.ReconPars;
ExpPars(6) = SCRPTGBL.Image_x1_Data.IMG.ExpPars;
Shim(6) = SCRPTGBL.Image_x1_Data.IMG.FID.Shim;
Im{7} = SCRPTGBL.Image_y1_Data.IMG.Im;
ReconPars(7) = SCRPTGBL.Image_y1_Data.IMG.ReconPars;
ExpPars(7) = SCRPTGBL.Image_y1_Data.IMG.ExpPars;
Shim(7) = SCRPTGBL.Image_y1_Data.IMG.FID.Shim;
Im{8} = SCRPTGBL.Image_xz_Data.IMG.Im;
ReconPars(8) = SCRPTGBL.Image_xz_Data.IMG.ReconPars;
ExpPars(8) = SCRPTGBL.Image_xz_Data.IMG.ExpPars;
Shim(8) = SCRPTGBL.Image_xz_Data.IMG.FID.Shim;
Im{9} = SCRPTGBL.Image_yz_Data.IMG.Im;
ReconPars(9) = SCRPTGBL.Image_yz_Data.IMG.ReconPars;
ExpPars(9) = SCRPTGBL.Image_yz_Data.IMG.ExpPars;
Shim(9) = SCRPTGBL.Image_yz_Data.IMG.FID.Shim;
Im{10} = SCRPTGBL.Image_xy_Data.IMG.Im;
ReconPars(10) = SCRPTGBL.Image_xy_Data.IMG.ReconPars;
ExpPars(10) = SCRPTGBL.Image_xy_Data.IMG.ExpPars;
Shim(10) = SCRPTGBL.Image_xy_Data.IMG.FID.Shim;
Im{11} = SCRPTGBL.Image_x2y2_Data.IMG.Im;
ReconPars(11) = SCRPTGBL.Image_x2y2_Data.IMG.ReconPars;
ExpPars(11) = SCRPTGBL.Image_x2y2_Data.IMG.ExpPars;
Shim(11) = SCRPTGBL.Image_x2y2_Data.IMG.FID.Shim;
Im{12} = SCRPTGBL.Image_x3_Data.IMG.Im;
ReconPars(12) = SCRPTGBL.Image_x3_Data.IMG.ReconPars;
ExpPars(12) = SCRPTGBL.Image_x3_Data.IMG.ExpPars;
Shim(12) = SCRPTGBL.Image_x3_Data.IMG.FID.Shim;
Im{13} = SCRPTGBL.Image_y3_Data.IMG.Im;
ReconPars(13) = SCRPTGBL.Image_y3_Data.IMG.ReconPars;
ExpPars(13) = SCRPTGBL.Image_y3_Data.IMG.ExpPars;
Shim(13) = SCRPTGBL.Image_y3_Data.IMG.FID.Shim;
Im{14} = SCRPTGBL.Image_xz2_Data.IMG.Im;
ReconPars(14) = SCRPTGBL.Image_xz2_Data.IMG.ReconPars;
ExpPars(14) = SCRPTGBL.Image_xz2_Data.IMG.ExpPars;
Shim(14) = SCRPTGBL.Image_xz2_Data.IMG.FID.Shim;
Im{15} = SCRPTGBL.Image_yz2_Data.IMG.Im;
ReconPars(15) = SCRPTGBL.Image_yz2_Data.IMG.ReconPars;
ExpPars(15) = SCRPTGBL.Image_yz2_Data.IMG.ExpPars;
Shim(15) = SCRPTGBL.Image_yz2_Data.IMG.FID.Shim;
Im{16} = SCRPTGBL.Image_zxy_Data.IMG.Im;
ReconPars(16) = SCRPTGBL.Image_zxy_Data.IMG.ReconPars;
ExpPars(16) = SCRPTGBL.Image_zxy_Data.IMG.ExpPars;
Shim(16) = SCRPTGBL.Image_zxy_Data.IMG.FID.Shim;
Im{17} = SCRPTGBL.Image_zx2y2_Data.IMG.Im;
ReconPars(17) = SCRPTGBL.Image_zx2y2_Data.IMG.ReconPars;
ExpPars(17) = SCRPTGBL.Image_zx2y2_Data.IMG.ExpPars;
Shim(17) = SCRPTGBL.Image_zx2y2_Data.IMG.FID.Shim;

%---------------------------------------------
% Get Working Structures from Sub Functions
%---------------------------------------------
SHIMMEASipt = SCRPTGBL.CurrentTree.('ShimCalfunc');
if isfield(SCRPTGBL,('ShimCalfunc_Data'))
    SHIMMEASipt.ShimCalfunc_Data = SCRPTGBL.ShimCalfunc_Data;
end

%------------------------------------------
% Get Shim Function Info
%------------------------------------------
func = str2func(CAL.shimfunc);           
[SCRPTipt,SHIMMEAS,err] = func(SCRPTipt,SHIMMEASipt);
if err.flag
    return
end

%---------------------------------------------
% 
%---------------------------------------------
func = str2func([CAL.method,'_Func']);
INPUT.Im = Im;
INPUT.ReconPars = ReconPars;
INPUT.ExpPars = ExpPars;
INPUT.SHIMMEAS = SHIMMEAS;
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

