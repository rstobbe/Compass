%===================================================
% Select Image
%===================================================

function [imfile,impath,err] = Select_Image(DefPath,DefFileType)

err.flag = 0;
err.msg = 0;

%---------------------------------------------------------
% Select Image File
%---------------------------------------------------------
Status2('busy','Select Images',1);
% if strcmp(DefFileType,'Dicom')
%     [imfile,impath] = uigetfile({'*.IMA';'*.dcm';'*.hdr';'*.nii';'*.mat';'*.fdf'},'Select Image Header File',DefPath);
% elseif strcmp(DefFileType,'Dicom2')
%     [imfile,impath] = uigetfile({'*.dcm';'*.IMA';'*.hdr';'*.nii';'*.mat';'*.fdf'},'Select Image Header File',DefPath);
% elseif strcmp(DefFileType,'Dicom3')
%     [imfile,impath] = uigetfile({'*.*';'*.dcm';'*.IMA';'*.hdr';'*.nii';'*.mat';'*.fdf'},'Select Image Header File',DefPath);
% elseif strcmp(DefFileType,'Analyze')
%     [imfile,impath] = uigetfile({'*.hdr';'*.nii';'*.IMA';'*.dcm';'*.mat';'*.fdf'},'Select Image Header File',DefPath);
% elseif strcmp(DefFileType,'NIFTI')
%     [imfile,impath] = uigetfile({'*.nii';'*.hdr';'*.IMA';'*.dcm';'*.mat';'*.fdf'},'Select Image Header File',DefPath);
% elseif strcmp(DefFileType,'Mat') || strcmp(DefFileType,'MatRWS') || strcmp(DefFileType,'MatExploreDTI') || strcmp(DefFileType,'MatOther') 
%     [imfile,impath] = uigetfile({'*.mat';'*.nii';'*.hdr';'*.IMA';'*.dcm';'*.fdf'},'Select Image Header File',DefPath);
% elseif strcmp(DefFileType,'FDF')
%     [imfile,impath] = uigetfile({'*.fdf';'*.mat';'*.nii';'*.hdr';'*.IMA';'*.dcm'},'Select Image Header File',DefPath);
% else
%     [imfile,impath] = uigetfile({'*.mat';'*.nii';'*.hdr';'*.IMA';'*.dcm';'*.fdf'},'Select Image Header File',DefPath);
% end   
[imfile,impath] = uigetfile(['*.nii',';*.hdr',';*.dcm',';*.mat'],'Select Images',DefPath,'MultiSelect','on');
if impath == 0
    err.flag = 4;
    err.msg = 'Image Not Selected';
    ErrDisp(err);
    return
end

global COMPASSINFO
Text = fileread(COMPASSINFO.USERGBL.userinfofile);
ind1 = strfind(Text,'User.experimentsloc');
ind2 = strfind(Text,'User.trajdevloc');
Text = [Text(1:ind1+22),impath,Text(ind2-4:end)];
fid = fopen([COMPASSINFO.USERGBL.userinfofile],'w+');
fwrite(fid,Text);
fclose('all');
Status2('done','',1);


