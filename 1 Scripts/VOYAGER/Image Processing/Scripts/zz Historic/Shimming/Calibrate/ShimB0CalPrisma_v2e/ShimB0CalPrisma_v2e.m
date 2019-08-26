%===========================================
% (v2e)
%      - 
%===========================================

function [SCRPTipt,SCRPTGBL,err] = ShimB0CalPrisma_v2e(SCRPTipt,SCRPTGBL)

Status('busy','Measure Shim Coil Effects');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Clear Naming
%---------------------------------------------
inds = strcmp('Cal_Name',{SCRPTipt.labelstr});
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
CAL.method = SCRPTGBL.CurrentTree.Func;
CAL.shimfunc = SCRPTGBL.CurrentTree.('ShimCalfunc').Func;

%---------------------------------------------
% Load Image
%---------------------------------------------
IMDISP = SCRPTGBL.Image_base_Data.IMG.IMDISP;
Im{1} = SCRPTGBL.Image_base_Data.IMG.Im;
ReconPars(1) = SCRPTGBL.Image_base_Data.IMG.ReconPars;
ExpPars(1) = SCRPTGBL.Image_base_Data.IMG.ExpPars;
Shim(1) = SCRPTGBL.Image_base_Data.IMG.FID.Shim;
Im{2} = SCRPTGBL.Image_x_Data.IMG.Im;
ReconPars(2) = SCRPTGBL.Image_x_Data.IMG.ReconPars;
ExpPars(2) = SCRPTGBL.Image_x_Data.IMG.ExpPars;
Shim(2) = SCRPTGBL.Image_x_Data.IMG.FID.Shim;
Im{3} = SCRPTGBL.Image_y_Data.IMG.Im;
ReconPars(3) = SCRPTGBL.Image_y_Data.IMG.ReconPars;
ExpPars(3) = SCRPTGBL.Image_y_Data.IMG.ExpPars;
Shim(3) = SCRPTGBL.Image_y_Data.IMG.FID.Shim;
Im{4} = SCRPTGBL.Image_z_Data.IMG.Im;
ReconPars(4) = SCRPTGBL.Image_z_Data.IMG.ReconPars;
ExpPars(4) = SCRPTGBL.Image_z_Data.IMG.ExpPars;
Shim(4) = SCRPTGBL.Image_z_Data.IMG.FID.Shim;
Im{5} = SCRPTGBL.Image_z2_Data.IMG.Im;
ReconPars(5) = SCRPTGBL.Image_z2_Data.IMG.ReconPars;
ExpPars(5) = SCRPTGBL.Image_z2_Data.IMG.ExpPars;
Shim(5) = SCRPTGBL.Image_z2_Data.IMG.FID.Shim;
Im{6} = SCRPTGBL.Image_zx_Data.IMG.Im;
ReconPars(6) = SCRPTGBL.Image_zx_Data.IMG.ReconPars;
ExpPars(6) = SCRPTGBL.Image_zx_Data.IMG.ExpPars;
Shim(6) = SCRPTGBL.Image_zx_Data.IMG.FID.Shim;
Im{7} = SCRPTGBL.Image_zy_Data.IMG.Im;
ReconPars(7) = SCRPTGBL.Image_zy_Data.IMG.ReconPars;
ExpPars(7) = SCRPTGBL.Image_zy_Data.IMG.ExpPars;
Shim(7) = SCRPTGBL.Image_zy_Data.IMG.FID.Shim;
Im{8} = SCRPTGBL.Image_x2y2_Data.IMG.Im;
ReconPars(8) = SCRPTGBL.Image_x2y2_Data.IMG.ReconPars;
ExpPars(8) = SCRPTGBL.Image_x2y2_Data.IMG.ExpPars;
Shim(8) = SCRPTGBL.Image_x2y2_Data.IMG.FID.Shim;
Im{9} = SCRPTGBL.Image_xy_Data.IMG.Im;
ReconPars(9) = SCRPTGBL.Image_xy_Data.IMG.ReconPars;
ExpPars(9) = SCRPTGBL.Image_xy_Data.IMG.ExpPars;
Shim(9) = SCRPTGBL.Image_xy_Data.IMG.FID.Shim;

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
[SCRPTipt,SCRPTGBL,SHIMMEAS,err] = func(SCRPTipt,SCRPTGBL,SHIMMEASipt);
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
INPUT.IMDISP = IMDISP;
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

