%=========================================================
% 
%=========================================================

function [EXPORT,err] = ExportImageNII_v1a_Func(EXPORT,INPUT)

Status2('busy','Export NII Images',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Input
%---------------------------------------------
IMG = INPUT.IMG;
Im = IMG.Im;
ReconPars = IMG.ReconPars
%PRM = INPUT.PRM;
filename = IMG.name;
%par = PRM.par;
%voxsize = PRM.voxsize;
par = [];
voxsize = [];
clear INPUT

%---------------------------------------------
% Common Variables
%---------------------------------------------
opt.multivol_flg = EXPORT.multivol;

%---------------------------------------------
% Other Options
%---------------------------------------------
opt.numchunks = 1;
opt.nii_z_invert = 0;

%---------------------------------------------
% Run Corey's Code
%---------------------------------------------
save_nii_w_hdr(Im,par,filename,voxsize,opt);


Status2('done','',2);
Status2('done','',3);
