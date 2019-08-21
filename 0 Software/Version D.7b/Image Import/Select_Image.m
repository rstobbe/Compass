%===================================================
% Select Image
%===================================================

function [imfile,impath,err] = Select_Image(DefPath,DefFileType)

err.flag = 0;
err.msg = 0;

%---------------------------------------------------------
% Select Image File
%---------------------------------------------------------
Status2('busy','Select Image File',1);
if strcmp(DefFileType,'Dicom')
    [imfile,impath] = uigetfile({'*.IMA';'*.dcm';'*.hdr';'*.nii';'*.mat';'*.fdf'},'Select Image Header File',DefPath);
elseif strcmp(DefFileType,'Dicom2')
    [imfile,impath] = uigetfile({'*.dcm';'*.IMA';'*.hdr';'*.nii';'*.mat';'*.fdf'},'Select Image Header File',DefPath);
elseif strcmp(DefFileType,'Dicom3')
    [imfile,impath] = uigetfile({'*.*';'*.dcm';'*.IMA';'*.hdr';'*.nii';'*.mat';'*.fdf'},'Select Image Header File',DefPath);
elseif strcmp(DefFileType,'Analyze')
    [imfile,impath] = uigetfile({'*.hdr';'*.nii';'*.IMA';'*.dcm';'*.mat';'*.fdf'},'Select Image Header File',DefPath);
elseif strcmp(DefFileType,'NIFTI')
    [imfile,impath] = uigetfile({'*.nii';'*.hdr';'*.IMA';'*.dcm';'*.mat';'*.fdf'},'Select Image Header File',DefPath);
elseif strcmp(DefFileType,'Mat') || strcmp(DefFileType,'MatRWS') || strcmp(DefFileType,'MatExploreDTI') || strcmp(DefFileType,'MatOther') 
    [imfile,impath] = uigetfile({'*.mat';'*.nii';'*.hdr';'*.IMA';'*.dcm';'*.fdf'},'Select Image Header File',DefPath);
elseif strcmp(DefFileType,'FDF')
    [imfile,impath] = uigetfile({'*.fdf';'*.mat';'*.nii';'*.hdr';'*.IMA';'*.dcm'},'Select Image Header File',DefPath);
else
    [imfile,impath] = uigetfile({'*.mat';'*.nii';'*.hdr';'*.IMA';'*.dcm';'*.fdf'},'Select Image Header File',DefPath);
end    
if impath == 0
    err.flag = 4;
    err.msg = 'Image Not Selected';
    ErrDisp(err);
    return
end

Status2('done','',1);


