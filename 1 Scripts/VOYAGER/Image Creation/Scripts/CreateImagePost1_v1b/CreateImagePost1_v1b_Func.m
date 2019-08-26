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

%----------------------------------------------
% Create Image Structure
%----------------------------------------------
IMG.Im = IC.Im;
IMG.ReconPars = IC.ReconPars;
IMG.ExpPars = FID.ExpPars;

%----------------------------------------------
% Post Process
%----------------------------------------------
func = str2func([IMG.postprocfunc,'_Func']);  
INPUT.IMG = IMG;
[PSTPRC,err] = func(PSTPRC,INPUT);
if err.flag
    return
end
clear INPUT;
IMG = PSTPRC.IMG;

%----------------------------------------------------
% Panel Items
%----------------------------------------------------
IMG.PanelOutput = [FID.PanelOutput;IC.PanelOutput;PSTPRC.PanelOutput];

%---------------------------------------------
% Return
%---------------------------------------------
IC = rmfield(IC,'Im');
FID = rmfield(FID,'FIDmat');
PSTPRC = rmfield(PSTPRC,'IMG');
IMG.FID = FID;
IMG.IC = IC;
IMG.PSTPRC = PSTPRC;

Status('done','');
Status2('done','',2);
Status2('done','',3);

