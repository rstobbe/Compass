%====================================================
%
%====================================================

function [err] = NewScriptSearchPaths_B9(panelnum,tab)

Status('busy','Load New Search Paths');

global SCRPTPATHS

path = uigetdir(SCRPTPATHS.(tab)(panelnum).rootloc,'Select New Script Search Path');
if path == 0
    err.flag = 4;
    err.msg = '';
    return
end

SCRPTPATHS.(tab)(panelnum).loc = [path,filesep];
SCRPTPATHS.(tab)(panelnum).rootloc = [path,filesep];
SCRPTPATHS.(tab)(panelnum).defloc = [path,filesep];
SCRPTPATHS.(tab)(panelnum).defrootloc = [path,filesep];

Status('done','Default File Loaded');
