%====================================================
%  
%====================================================

function [IMG,err] = CreateImage_v1e_Func(INPUT,IMG)

Status('busy','Create Image');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
FID = INPUT.FID;
IC = INPUT.IC;
SCALE = INPUT.SCALE;
clear INPUT;

%----------------------------------------------
% Create Image
%----------------------------------------------
func = str2func([IMG.imconstfunc,'_Func']);  
INPUT.func = 'ImpLoad';
INPUT.FID = FID;
[IC,err] = func(IC,INPUT);
if err.flag
    return
end
TORD = IC.IMP.TORD;
clear INPUT;

%----------------------------------------------
% Import FID
%----------------------------------------------
func = str2func([IMG.importfidfunc,'_Func']);  
INPUT.IC = IC;
[FID,err] = func(FID,INPUT);
if err.flag
    return
end
clear INPUT;

%----------------------------------------------
% Create Image
%----------------------------------------------
func = str2func([IMG.imconstfunc,'_Func']);  
INPUT.func = 'Create';
INPUT.FID = FID;
[IC,err] = func(IC,INPUT);
if err.flag
    return
end
clear INPUT;
Im = IC.Im;

%----------------------------------------------
% Scale Image
%----------------------------------------------
func = str2func([IMG.imscalefunc,'_Func']);  
INPUT.Im = Im;
INPUT.zf = str2double(IC.zf);
INPUT.FID = FID;
INPUT.TORD = TORD;
[SCALE,err] = func(SCALE,INPUT);
if err.flag
    return
end
clear INPUT;
Im = SCALE.Im;

%----------------------------------------------
% Panel Items
%----------------------------------------------
Panel(1,:) = {'','','Output'};
Panel(2,:) = {'',IMG.method,'Output'};
PanelOutput = cell2struct(Panel,{'label','value','type'},2);
IMG.PanelOutput = [PanelOutput;FID.PanelOutput;IC.PanelOutput];
IMG.ExpDisp = PanelStruct2Text(IMG.PanelOutput);

%----------------------------------------------
% Set Up Compass Display
%----------------------------------------------
MSTRCT.type = 'abs';
MSTRCT.dispwid = [0 max(abs(Im(:)))];
MSTRCT.ImInfo.pixdim = [IC.ReconPars.ImvoxTB,IC.ReconPars.ImvoxLR,IC.ReconPars.ImvoxIO];
MSTRCT.ImInfo.vox = IC.ReconPars.ImvoxTB*IC.ReconPars.ImvoxLR*IC.ReconPars.ImvoxIO;
MSTRCT.ImInfo.info = IMG.ExpDisp;
MSTRCT.ImInfo.baseorient = 'Axial';             % all images should be oriented axially
INPUT.Image = Im;
INPUT.MSTRCT = MSTRCT;
IMDISP = ImagingPlotSetup(INPUT);
IMG.IMDISP = IMDISP;

%---------------------------------------------
% Return
%---------------------------------------------
FID = rmfield(FID,'FIDmat');
IMG.Im = Im;
IMG.FID = FID;
IMG.ReconPars = IC.ReconPars;
IMG.ExpPars = FID.ExpPars;

Status('done','');
Status2('done','',2);
Status2('done','',3);

