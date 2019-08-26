%=========================================================
% 
%=========================================================

function [EXPORT,err] = ExportGenericDicom_v1b_Func(EXPORT,INPUT)

Status2('busy','Export Images in Dicom Format',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Input
%---------------------------------------------
IMG = INPUT.IMG;
Im = IMG.Im;
folder = INPUT.folder;
imagename = INPUT.imagename;
clear INPUT

%-------------------------------------------
% Just Write Absolute
%-------------------------------------------
%Im = flip(Im,3);
%Im = flip(Im,2);
Im = abs(Im);
Im = Im./max(Im(:));

%-------------------------------------------
% Just Write Volume Images
%-------------------------------------------
sz = size(Im);
if length(sz) > 3
    err.flag = 1;
    err.msg = 'Cannot Writed Arrayed Images';
end

%-------------------------------------------
% Create Folder
%-------------------------------------------
if strcmp(folder(end),'\')
    fname = [folder,imagename,'\'];
else
    fname = [folder,'\',imagename,'\'];
end
if ~exist(fname,'dir')
    mkdir(fname);
end

%-------------------------------------------
% Write Dicom Images
%-------------------------------------------
Meta.SeriesInstanceUID = dicomuid;
Meta.StudyInstanceUID = dicomuid;
Meta.SOPInstanceUID = dicomuid;
Meta.MediaStorageSOPInstanceUID = dicomuid;

for n = 1:sz(3)
    Meta.InstanceNumber = n;
    num = num2str(n,'%3.3d');
    dicomwrite(squeeze(Im(:,:,n)),[fname,'image',num,'.dcm'],Meta,'CompressionMode','none');
end

Status2('done','',2);
Status2('done','',3);






