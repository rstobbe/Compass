%===========================================
% (v2e)
%      - Start ShimB0Cal47T_v2e
%===========================================

function [SCRPTipt,SCRPTGBL,err] = XYZB0Cal47T_v2e(SCRPTipt,SCRPTGBL)

Status('busy','Measure X,Y,Z,B0 Interdependencies');
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
CAL.shimfunc = SCRPTGBL.CurrentTree.('Calfunc').Func;
CAL.baseimfunc = SCRPTGBL.CurrentTree.('BaseImfunc').Func;

%---------------------------------------------
% Load Image
%---------------------------------------------
Im{1} = SCRPTGBL.Image_base_Data.IMG.Im;
ReconPars(1) = SCRPTGBL.Image_base_Data.IMG.ReconPars;
ExpPars(1) = SCRPTGBL.Image_base_Data.IMG.ExpPars;
Shim(1) = SCRPTGBL.Image_base_Data.IMG.FID.Shim;
Im{2} = SCRPTGBL.Image_z_Data.IMG.Im;
ReconPars(2) = SCRPTGBL.Image_z_Data.IMG.ReconPars;
ExpPars(2) = SCRPTGBL.Image_z_Data.IMG.ExpPars;
Shim(2) = SCRPTGBL.Image_z_Data.IMG.FID.Shim;
Im{3} = SCRPTGBL.Image_x_Data.IMG.Im;
ReconPars(3) = SCRPTGBL.Image_x_Data.IMG.ReconPars;
ExpPars(3) = SCRPTGBL.Image_x_Data.IMG.ExpPars;
Shim(3) = SCRPTGBL.Image_x_Data.IMG.FID.Shim;
Im{4} = SCRPTGBL.Image_y_Data.IMG.Im;
ReconPars(4) = SCRPTGBL.Image_y_Data.IMG.ReconPars;
ExpPars(4) = SCRPTGBL.Image_y_Data.IMG.ExpPars;
Shim(4) = SCRPTGBL.Image_y_Data.IMG.FID.Shim;

%---------------------------------------------
% Get Working Structures from Sub Functions
%---------------------------------------------
SHIMMEASipt = SCRPTGBL.CurrentTree.('Calfunc');
if isfield(SCRPTGBL,('Calfunc_Data'))
    SHIMMEASipt.Calfunc_Data = SCRPTGBL.Calfunc_Data;
end
BASEipt = SCRPTGBL.CurrentTree.('BaseImfunc');
if isfield(SCRPTGBL,('BaseImfunc_Data'))
    BASEipt.BaseImfunc_Data = SCRPTGBL.BaseImfunc_Data;
end

%------------------------------------------
% Get Function Info
%------------------------------------------
func = str2func(CAL.shimfunc);           
[SCRPTipt,SHIMMEAS,err] = func(SCRPTipt,SHIMMEASipt);
if err.flag
    return
end
func = str2func(CAL.baseimfunc);           
[SCRPTipt,BASE,err] = func(SCRPTipt,BASEipt);
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
INPUT.BASE = BASE;
[CAL,err] = func(CAL,INPUT);
if err.flag
    return
end

%--------------------------------------------
% Output to TextBox
%--------------------------------------------
CAL.ExpDisp = PanelStruct2Text(CAL.PanelOutput);
set(findobj('tag','TestBox'),'string',CAL.ExpDisp);

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

