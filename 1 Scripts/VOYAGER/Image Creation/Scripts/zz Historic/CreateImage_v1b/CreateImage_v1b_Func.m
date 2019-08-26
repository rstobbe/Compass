%====================================================
%  
%====================================================

function [IMG,err] = CreateImage_v1b_Func(INPUT,IMG)

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
IC = rmfield(IC,'Im');

%----------------------------------------------------
% Panel Items
%----------------------------------------------------
IMG.PanelOutput = [FID.PanelOutput;IC.PanelOutput];

%---------------------------------------------
% Return
%---------------------------------------------
FID = rmfield(FID,'FIDmat');
IMG.Im = Im;
IMG.ImageType = 'Image';
IMG.FID = FID;
IMG.ReconPars = IC.ReconPars;
IMG.ExpPars = FID.ExpPars;

Status('done','');
Status2('done','',2);
Status2('done','',3);

