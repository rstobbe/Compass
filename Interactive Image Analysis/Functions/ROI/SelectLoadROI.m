%============================================
%
%============================================
function SelectLoadROI(tab,axnum,roinum)

global IMAGEANLZ
global SCRPTPATHS

if not(isempty(IMAGEANLZ.(tab)(axnum).movefunction))
    error;          % shouldn't get here
end

roisloc = SCRPTPATHS.(tab)(1).roisloc;
[file,path] = uigetfile('*.mat','Select ROI',roisloc);
if path == 0
    return;
end
SCRPTPATHS.(tab)(1).roisloc = path(1:end-1);

LoadROI(tab,axnum,roinum,path,file);