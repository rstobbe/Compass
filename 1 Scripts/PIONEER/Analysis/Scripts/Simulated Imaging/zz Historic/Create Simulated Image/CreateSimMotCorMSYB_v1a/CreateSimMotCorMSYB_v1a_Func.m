%=========================================================
% 
%=========================================================

function [IMG,err] = CreateSimMotCorMSYB_v1a_Func(INPUT)

Status('busy','Create Simulated Image With Motion Correction');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
IMG = INPUT.IMG;
IMP = INPUT.IMP;
KSMP = INPUT.KSMP;
arrSDC = INPUT.SDC;
arrDAT = KSMP.SampDat;
IC = INPUT.IC;
MOTCOR = INPUT.MOTCOR;
clear INPUT;

%---------------------------------------------
% Compensate Data
%---------------------------------------------
arrDAT = arrDAT.*arrSDC;
[DAT] = DatArr2Mat(arrDAT,IMP.PROJimp.nproj,IMP.PROJimp.npro);

%----------------------------------------------
% Correct for Motion
%----------------------------------------------
func = str2func([IMG.motcorfunc,'_Func']);  
INPUT.IMP = IMP;
INPUT.DAT = DAT;
INPUT.KSMP = KSMP;      % for testing...
[MOTCOR,err] = func(MOTCOR,INPUT);
if err.flag
    return
end
clear INPUT;

%----------------------------------------------
% Create Image
%----------------------------------------------
func = str2func([IMG.imagecreatefunc,'_Func']);  
IMP.Kmat = MOTCOR.Kmat;
INPUT.IMP = IMP;
INPUT.DAT = MOTCOR.DAT;
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