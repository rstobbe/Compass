%=========================================================
% 
%=========================================================

function [EXPORT,err] = ExportImageDicom_v1a_Func(EXPORT,INPUT)

Status2('busy','Export Images in Dicom Format',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Input
%---------------------------------------------
IMG = INPUT.IMG;
if isfield(IMG,'ExpPars')
    par = IMG.ExpPars;
end
par.studyid_ = '';
if isfield(IMG,'ImInfo')
   ImInfo = IMG.ImInfo;
   if not(isfield(ImInfo,'studyid'))
       par.studyid_ = '';
   end
end
Im = IMG.Im;
folder = INPUT.folder;
imagename = INPUT.imagename;
clear INPUT

%-------------------------------------------
% Just Write Absolute
%-------------------------------------------
Im = flipdim(Im,3);
Im = abs(Im);

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
%Define common dicom headers
%-------------------------------------------
par.StudyInstanceUID = ['1.3.6.1.4.1.9590.100.1.1.817913647490004488.',par.studyid_(3:end)];
par.StudyInstanceUID(strfind(par.StudyInstanceUID,'_')) = '';
par.SeriesNumber = 0;
par.PatientID = '';
par.StudyDescription = '';

%-------------------------------------------
% Send to dicom writing engine
%-------------------------------------------
opt.operator = '';
dicomw_v1a(Im,fname,par,opt);
disp('Done');
Status2('done','',2);
Status2('done','',3);
