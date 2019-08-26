%====================================================
%  
%====================================================

function [EXPORT,err] = VarianFID2Mat_v1a_Func(EXPORT,INPUT)

Status('busy','Export FID');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
clear INPUT;

%---------------------------------------------
% Load FID
%---------------------------------------------
[fid] = ImportExpArrayFIDmatV_v1a([EXPORT.path,'\fid']);

%---------------------------------------------
% Save
%---------------------------------------------
[file,path] = uiputfile('*.mat','NameFile',EXPORT.path);
save([path,file],'fid');
