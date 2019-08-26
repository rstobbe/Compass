%====================================================
%  
%====================================================

function [IMG,err] = CreateImage_v2a_Func(INPUT,IMG)

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
PSTPRC = INPUT.PSTPRC;
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
% Post Process
%----------------------------------------------
func = str2func([IMG.postprocfunc,'_Func']);  
INPUT.Im = Im;
INPUT.ReconPars = IC.ReconPars;
[PSTPRC,err] = func(PSTPRC,INPUT);
if err.flag
    return
end
clear INPUT;
Im = PSTPRC.Im;
PSTPRC = rmfield(PSTPRC,'Im');

%----------------------------------------------------
% Panel Items
%----------------------------------------------------
IMG.PanelOutput = [FID.PanelOutput;IC.PanelOutput;PSTPRC.PanelOutput];

%---------------------------------------------
% Remove Large Mats from SubStructs
%---------------------------------------------
IC = rmfield(IC,'Im');
FID = rmfield(FID,'FIDmat');

%---------------------------------------------
% Return
%---------------------------------------------
IMG.Im = Im;
IMG.ImSz_X = IC.ImSz_X;
IMG.ImSz_Y = IC.ImSz_Y; 
IMG.ImSz_Z = IC.ImSz_Z; 
IMG.maxval = max(abs(Im(:)));
IMG.ReconPars = IC.ReconPars;
IMG.ExpPars = IC.ExpPars;
IMG.IC = IC;
IMG.FID = FID;
IMG.PSTPRC = PSTPRC;

Status('done','');
Status2('done','',2);
Status2('done','',3);

