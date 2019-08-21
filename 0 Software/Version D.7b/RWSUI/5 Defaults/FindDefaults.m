%====================================================
%  
%====================================================

function [err,Path] = FindDefaults(RWSUI,name)

global SCRPTPATHS
global USER

err.flag = 0;
err.msg = '';
Path = '';

tab = RWSUI.tab;
panelnum = RWSUI.panelnum;

%---------------------------------------------
% Find Defaults
%---------------------------------------------
found = 0;
searchloc = [SCRPTPATHS.(tab)(panelnum).defrootloc,'Default\'];
Subfolders = regexp(genpath(searchloc),'[^;]*','match');
for n = 1:length(Subfolders)
    folder = Subfolders{n};
    if exist([folder,'\',name],'file')
        Path = [folder,'\'];
        found = 1;
        break
    end
end

%---------------------------------------------
% Find Defaults
%---------------------------------------------
if found == 0
    searchloc = [SCRPTPATHS.(tab)(panelnum).defrootloc,'\',USER,'\'];
    Subfolders = regexp(genpath(searchloc),'[^;]*','match');
    for n = 1:length(Subfolders)
        folder = Subfolders{n};
        if exist([folder,'\',name],'file')
            Path = [folder,'\'];
            found = 1;
            break
        end
    end
end

if found == 0
    err.msg = ['''',name,''' Default Not Found'];
    err.flag = 1;
    return
end
  