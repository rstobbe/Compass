%====================================================
%  
%====================================================

function [IMG,err] = PopData_v1a_Func(INPUT,IMG)

Status('busy','Pop Images');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
clear INPUT;

%---------------------------------------------
% Create Local Folder
%---------------------------------------------
inds = strfind(IMG.varianfolder,'\');
Vfolder = IMG.varianfolder(inds(end)+1:end);
mkdir(IMG.localfolder,Vfolder);
localfolder = [IMG.localfolder,'\',Vfolder];
mkdir(localfolder,'data');

%---------------------------------------------
% Check and Pop
%---------------------------------------------
Status2('busy','Pop Images',1);
Vsubfolders = dir(IMG.varianfolder);
Lsubfolders = dir(localfolder);
i = 1;
Totalfolders = cell(0);
for n = 1:length(Vsubfolders)
    have = 0;
    Vname = Vsubfolders(n).name;
    for m = 1:length(Lsubfolders);
        if strcmp(Vname,Lsubfolders(m).name)
            have = 1;
            break
        end
    end
    if have == 0
        copyfile([IMG.varianfolder,'\',Vname],[localfolder,'\',Vname]);
    end
    Totalfolders{i} = [localfolder,'\',Vname];
    i = i+1;
end
Vsubdatafolders = dir([IMG.varianfolder,'\data']);
Lsubdatafolders = dir([localfolder,'\data']);
for n = 1:length(Vsubdatafolders)
    have = 0;
    Vname = Vsubdatafolders(n).name;
    for m = 1:length(Lsubdatafolders);
        if strcmp(Vname,Lsubdatafolders(m).name)
            have = 1;
            break
        end
    end
    if have == 0
        copyfile([IMG.varianfolder,'\data\',Vname],[localfolder,'\data\',Vname]);
    end
    Totalfolders{i} = [localfolder,'\data\',Vname];
    i = i+1;        
end

    
Status('done','');
Status2('done','',2);
Status2('done','',3);

