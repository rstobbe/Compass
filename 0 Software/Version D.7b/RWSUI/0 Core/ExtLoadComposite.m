%====================================================
%
%====================================================

function [err] = ExtLoadComposite(tab,file,path)

global DEFFILEGBL

err.flag = 0;
err.msg = '';

%--------------------------------------------
% Check if Already Loaded
%--------------------------------------------
reload = 0;
for n = 1:4
    if isfield(DEFFILEGBL.(tab)(n,1),'file')
        if not(strcmp(DEFFILEGBL.(tab)(n,1).file,[path,file]))
            reload = 1;
        end
    end
end
if reload == 0
    return
end

%--------------------------------------------
% Load Script Defaults
%--------------------------------------------
[runfunc,ScrptCellArray,err] = LoadComposite(tab,1,file,path);
if err.flag
    return
end

%--------------------------------------------
% Record Default Name
%--------------------------------------------
for n = 1:length(runfunc)
    DEFFILEGBL.(tab)(n,1).file = [path,file];
    DEFFILEGBL.(tab)(n,1).runfunc = runfunc{n};
end
