%====================================================
%
%====================================================

function [ANON,err] = AnonDicomHeader_v1b_Func(INPUT,ANON)

Status('busy','Anonomize');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
clear INPUT;

%---------------------------------------------
% Create New Folder
%---------------------------------------------
newfolder = [ANON.dir,'_A'];
if not(exist(newfolder,'dir')) 
    mkdir(newfolder);
end

%---------------------------------------------
% Find contents of folder
%---------------------------------------------
files = ls(ANON.dir);

for m = 3:length(files(:,1))
    file = squeeze(files(m,:));
    oldpath = ([ANON.dir,'\',squeeze(files(m,:))]);
    info = dicominfo(oldpath);
    image = dicomread(oldpath);
    %-----------------------------------------
    info.PatientName.FamilyName = ANON.val;
    info.PatientName.GivenName = '';
    info.PatientName.MiddleName = '';
    info.PatientAddress = '';
    info.PatientTelephoneNumber = '';
    %-----------------------------------------
    newpath = ([newfolder,'\',squeeze(files(m,:))]);
    dicomwrite(image,newpath,info);
    Status2('busy',['file: ',num2str(m)],2);
end


Status2('done','',2);
Status2('done','',3);

