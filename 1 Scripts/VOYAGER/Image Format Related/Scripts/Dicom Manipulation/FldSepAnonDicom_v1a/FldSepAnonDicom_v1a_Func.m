%====================================================
%
%====================================================

function [FSEP,err] = FldSepAnonDicom_v1a_Func(INPUT,FSEP)

Status('busy','Info');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
ANON = INPUT.ANON;
clear INPUT;

%---------------------------------------------
% Determine series number location in file name
%---------------------------------------------
files = dir(FSEP.path);
n = 3;
if files(n).isdir
    err.flag = 1;
    err.msg = 'Delete underlying directories from folder';
    return
end
name = files(n).name;
ind = strfind(name,'.MR.');
test = name(ind+4);
if strcmp(test,'1')
    ind1 = ind+4;
else
    ind = strfind(name,'.');
    test = name(ind(3)+1);
    if strcmp(test,'1')
        ind1 = ind(3)+1;
    end
end

%---------------------------------------------
% Create Directories / Move
%---------------------------------------------
info = dicominfo([FSEP.path,'\',files(n).name]);
if not(isfield(info,'ProtocolName'))
    field = 'SeriesNumber';
else
    field = 'ProtocolName';
end
currentdir = [FSEP.path,'\Series_',num2str(1),'_',info.(field)];
mkdir(currentdir);
M = 1;
for n = 3:length(files)
    name = files(n).name;
    test = strfind(name,'.MR.');
    if isempty(test)
        continue
    end
    name = files(n).name(ind1:end);
    ind = strfind(name,'.');
    m = str2double(name(1:ind(1)-1));
    p = name(ind(1)+1:ind(2)-1);
    if m ~= M
        info = dicominfo([FSEP.path,'\',files(n).name]);
        currentdir = [FSEP.path,'\Series_',num2str(m),'_',info.(field)];
        mkdir(currentdir);
        M = m;
    end
    func = str2func([FSEP.anonfunc,'_Func']);  
    INPUT.oldfile = [FSEP.path,'\',files(n).name];
    INPUT.newfile = [currentdir,'\Dicom',p,'.IMA'];
    [ANON,err] = func(INPUT,ANON);
    if err.flag
        return
    end
    clear INPUT;
    Status2('busy',['file: ',num2str(n)],2);
end

Status2('done','',2);
Status2('done','',3);
