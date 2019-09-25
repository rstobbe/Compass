%=========================================================
% 
%=========================================================

function [EXPORT,err] = ExportImageNII_v1c_Func(EXPORT,INPUT)

Status2('busy','Export NII Images',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Input
%---------------------------------------------
IMG = INPUT.IMG;
Im = abs(IMG.Im);
%Im = Im./max(Im(:));
Im = permute(Im,[2 1 3]);
Im = flip(Im,2);                               
%Im = flip(Im,1);                                % think this is right - make correction somewhere else
folder = INPUT.folder;
filename = IMG.name;
clear INPUT

%---------------------------------------------
% Test
%---------------------------------------------
test = sum(imag(Im(:)));
if test ~= 0
    error
end
test = min(Im(:));
if test < 0
    error
end

%---------------------------------------------
% Name
%---------------------------------------------
filename = strtok(filename,'.');
[filename,folder] = uiputfile('*.nii','Name Export Image File',[folder,'\',filename,'.nii']);
if filename == 0
    err.flag = 4;
    err.msg = '';
    return
end
filename = filename(1:end-4);        

%---------------------------------------------
% Export
%---------------------------------------------
if isfield(IMG,'ReconPars')
    voxeldims = [IMG.ReconPars.ImvoxLR IMG.ReconPars.ImvoxTB IMG.ReconPars.ImvoxIO];
else
    voxeldims = IMG.IMDISP.ImInfo.pixdim;
end
voxeldims = voxeldims([2 1 3]);
origin = size(Im).*voxeldims/2;
%origin(3) = origin(3)*1.3;                          % bad when used with SPM
if strcmp(EXPORT.datatype,'int16')
    Im = 32767*Im/max(Im(:));
    datatype = 4;
end
if strcmp(EXPORT.datatype,'single')
    datatype = 16;
end
description = [];
nii = MakeNiftiHeaderYB_v1a(Im,voxeldims,origin,datatype,description); 
%--
hist = nii.hdr.hist
%--

save_nii(nii,[folder,filename,'.nii']);

EXPORT.name = filename;
EXPORT.file = [filename,'.nii'];
EXPORT.path = folder;

Status2('done','',2);
Status2('done','',3);
