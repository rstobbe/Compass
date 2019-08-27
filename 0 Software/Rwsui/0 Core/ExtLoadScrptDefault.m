%====================================================
%
%====================================================

function [err] = ExtLoadScrptDefault(tab,panelnum,scrptnum,file,path)

global DEFFILEGBL

err.flag = 0;
err.msg = '';

%--------------------------------------------
% Check if Already Loaded
%--------------------------------------------
if isfield(DEFFILEGBL.(tab)(panelnum,scrptnum),'file')
    if strcmp(DEFFILEGBL.(tab)(panelnum,scrptnum).file,[path,file])
        return
    end
end

%--------------------------------------------
% Load Script Defaults
%--------------------------------------------
[runfunc,ScrptCellArray,err] = LoadScrptDefault(panelnum,tab,scrptnum,file,path);
if err.flag
    return
end

%--------------------------------------------
% Record Default Name
%--------------------------------------------
DEFFILEGBL.(tab)(panelnum,scrptnum).file = [path,file];
DEFFILEGBL.(tab)(panelnum,scrptnum).runfunc = runfunc;
