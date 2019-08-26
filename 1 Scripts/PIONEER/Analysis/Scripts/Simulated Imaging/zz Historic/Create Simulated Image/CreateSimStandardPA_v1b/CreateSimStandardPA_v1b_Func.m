%=========================================================
% 
%=========================================================

function [IMG,err] = CreateSimStandardPA_v1b_Func(INPUT)

Status('busy','Create Simulated Image');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
IMG = INPUT.IMG;
IMP = INPUT.IMP;
arrSDC = INPUT.SDC;
arrDAT = INPUT.DAT;
IC = INPUT.IC;
clear INPUT;

%---------------------------------------------
% Compensate Data
%---------------------------------------------
arrDAT = arrDAT.*arrSDC;
[DAT] = DatArr2Mat(arrDAT,IMP.PROJimp.nproj,IMP.PROJimp.npro);

%----------------------------------------------
% Create Image
%----------------------------------------------
func = str2func([IMG.imagecreatefunc,'_Func']);  
INPUT.IMP = IMP;
INPUT.DAT = DAT;
[IC,err] = func(IC,INPUT);
if err.flag
    return
end
clear INPUT;

%--------------------------------------
% Get Image in right orientation (for some reason flipped)
%--------------------------------------
Im = IC.Im;
IC = rmfield(IC,'Im');
Im = flipdim(Im,1);
Im = flipdim(Im,2);
Im = flipdim(Im,3);

%---------------------------------------------
% Return
%---------------------------------------------
IMG.Im = Im;
IMG.ImSz = IC.ImSz;
IMG.zf = IC.zf;
IMG.returnfov = IC.returnfov;
IMG.IC = IC;

Status('done','');
Status2('done','',2);
Status2('done','',3);