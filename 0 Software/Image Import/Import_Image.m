%===================================================
% Load Image
%===================================================

function [IMG,Name,ImType,err] = Import_Image(impath,imfile)

IMG = struct();
Name = '';
ImType = '';
err.flag = 0;
err.msg = 0;

%---------------------------------------------------------
% Determine Image Type
%---------------------------------------------------------
Status2('busy','Load Image File',1);
ext = imfile;
while true
    [fileext,ext] = strtok(ext,'.');
    if isempty(ext)
        break
    end
end
if strcmp(fileext,'hdr')
    [IMG,ImInfo,err] = Load_Analyze([impath,imfile]); 
    ImType = 'Analyze';
    %[Name,~] = strtok(imfile,'.');
    Name = imfile;
elseif strcmp(fileext,'nii')
    [IMG,ImInfo,err] = Load_Nifti([impath,imfile]); 
    ImType = 'NIFTI';
    %[Name,~] = strtok(imfile,'.');
    Name = imfile;
elseif strcmp(fileext,'IMA')
    [IMG,ImInfo,err] = Load_Dicom(impath,imfile);
    inds = strfind(impath,'\');
    Name = impath(inds(end-1)+1:inds(end)-1);
    ImType = 'Dicom';
elseif strcmp(fileext,'dcm')
    [IMG,ImInfo,err] = Load_Dicom2b(impath,imfile);
    inds = strfind(impath,'\');
    Name = impath(inds(end-1)+1:inds(end)-1);
    ImType = 'Dicom2';
elseif strcmp(fileext,'mat')
    [IMG,ImInfo,ImType,err] = Load_Mat([impath,imfile]);
    %[Name,~] = strtok(imfile,'.');
    Name = imfile;
elseif strcmp(fileext,'fdf')
    [IMG,ImInfo,err] = Load_FDF(impath,imfile);
    ImType = 'FDF';
    %[Name,~] = strtok(imfile,'.');
    Name = imfile;
else
    %---
    [IMG,ImInfo,err] = Load_Dicom2b(impath,imfile);
    inds = strfind(impath,'\');
    Name = impath(inds(end-1)+1:inds(end)-1);
    ImType = 'Dicom3';    
	%---  
    %err.flag = 1;
    %err.msg = 'Image Type Not Supported';    
end
if err.flag
    ErrDisp(err);
    return
end
IMG.name = Name;
IMG.path = impath;

%---------------------------------------------------------
% Remove NaN
%---------------------------------------------------------
%IMG.Im(logical(isnan(IMG.Im))) = 0;

%---------------------------------------------------------
% Make Sure Double
%---------------------------------------------------------
IMG.Im = double(IMG.Im);

%---------------------------------------------------------
% Display Setup
%---------------------------------------------------------
if not(isfield(IMG,'IMDISP'))
    INPUT.Image = IMG.Im;
    INPUT.MSTRCT.type = 'abs';
    INPUT.MSTRCT.dispwid = [0 max(abs(IMG.Im(:)))];
    INPUT.MSTRCT.ImInfo = ImInfo;
    IMDISP = ImagingPlotSetup(INPUT);
    IMG.IMDISP = IMDISP;
end

Status2('done','',1);


