%============================================
% 
%============================================
function SetRoiSearchPath(path)

global SCRPTPATHS

SCRPTPATHS.('IM')(1).roisloc = path;
SCRPTPATHS.('IM2')(1).roisloc = path;
SCRPTPATHS.('IM3')(1).roisloc = path;
SCRPTPATHS.('IM4')(1).roisloc = path;
