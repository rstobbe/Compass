%=========================================================
% 
%=========================================================

function [EXPORT,err] = ExportImageNII_v1b_Func(EXPORT,INPUT)

Status2('busy','Export NII Images',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Input
%---------------------------------------------
IMG = INPUT.IMG;
Im = abs(IMG.Im);
Im = Im./max(Im(:));
Im = permute(Im,[2 1 3]);
Im = flip(Im,2);
folder = INPUT.folder;
filename = IMG.name;
clear INPUT

%---------------------------------------------
% Export
%---------------------------------------------
if isfield(IMG,'ReconPars');
    voxeldims = [IMG.ReconPars.ImvoxLR IMG.ReconPars.ImvoxTB IMG.ReconPars.ImvoxIO];
else
    voxeldims = IMG.IMDISP.ImInfo.pixdim;
end
origin = [];
datatype = [];
description = [];
nii = make_nii(Im,voxeldims,origin,datatype,description); 
save_nii(nii,[folder,filename,'.nii']);

Status2('done','',2);
Status2('done','',3);
