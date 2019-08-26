%====================================================
%  
%====================================================

function [IMG,err] = CreateImage_v1c_Func(INPUT,IMG)

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
[SCALE,err] = func(SCALE,INPUT);
if err.flag
    return
end
clear INPUT;
Im = SCALE.Im;

%----------------------------------------------
% Panel Items
%----------------------------------------------
IMG.PanelOutput = [FID.PanelOutput;IC.PanelOutput];
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

