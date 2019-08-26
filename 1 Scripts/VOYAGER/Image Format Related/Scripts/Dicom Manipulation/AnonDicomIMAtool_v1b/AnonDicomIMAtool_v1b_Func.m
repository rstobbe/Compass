%====================================================
%
%====================================================

function [ANON,err] = AnonDicomIMAtool_v1b_Func(INPUT,ANON)

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
% Find contents of folder
%---------------------------------------------
folderlist = ls(ANON.dir);

for n = 3:length(folderlist(:,1))
    tsubfolder = [ANON.dir,'\',squeeze(folderlist(n,:))];
    ind = find(not(tsubfolder==32),1,'last');
    oldsubfolder{n-2} = tsubfolder(1:ind);
    newsubfolder{n-2} = [tsubfolder(1:ind),'_A'];
    if not(exist(newsubfolder{n-2},'dir')) 
        mkdir(newsubfolder{n-2});
    end
    filelists{n-2} = ls(oldsubfolder{n-2});
end

for n = 1:length(filelists)
    files = filelists{n};
    for m = 3:length(files(:,1))
        file = squeeze(files(m,:));
        test = strfind(file,ANON.replacestring);
        if test == 1
            oldpath = ([oldsubfolder{n},'\',squeeze(files(m,:))]);
            if ~isdicom(oldpath)
                continue
            end
            info = dicominfo(oldpath);
            image = dicomread(oldpath);
            %-----------------------------------------
            info.PatientName.FamilyName = ANON.val;
            info.PatientName.GivenName = '';
            info.PatientName.MiddleName = '';
            info.PatientAddress = '';
            info.PatientTelephoneNumber = '';
            info.PatientID = '';
            %-----------------------------------------
            filenew = [ANON.val,file(length(ANON.replacestring)+1:length(file))];
            newpath = ([newsubfolder{n},'\',filenew]);
            dicomwrite(image,newpath,info);
        end
        Status2('busy',['file: ',num2str(m)],3);
    end
    Status2('busy',['folder: ',num2str(n)],2);
end

Status2('done','',2);
Status2('done','',3);

