%======================================================
% 
%======================================================

function [SBLD,err] = Study_MS_v1a_Func(SBLD,INPUT)

Status('busy','Build MS Study');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
Files = INPUT.Files;
clear INPUT

%--------------------------------------
% Build Study
%--------------------------------------    
STUDY = MSStudyClass;

file1 = [Files{1}.path,Files{1}.file];
[STUDY,err] = BuildVolunteerList(file1,STUDY);
if err.flag
    return
end
[STUDY,err] = AddRoiData(file1,STUDY);
if err.flag
    return
end

%--------------------------------------
% Return
%--------------------------------------
SBLD.ExpDisp = '';
SBLD.STUDY = STUDY;

Status2('done','',1);
Status2('done','',2);
Status2('done','',3);
