%====================================================
%
%====================================================

function [err] = SelectComposite(panelnum,tab,scrptnum)

Status('busy','Load Composite');
Status2('done','',2);
Status2('done','',3);

global SCRPTPATHS
global SCRPTGBL

if isempty(SCRPTPATHS.(tab)(panelnum).defloc)
    SCRPTPATHS.(tab)(panelnum).defloc = SCRPTPATHS.(tab)(panelnum).defrootloc;
end
if SCRPTPATHS.(tab)(panelnum).defloc == 0
    SCRPTPATHS.(tab)(panelnum).defloc = '';
end

for n = 1:4
    SCRPTGBL.(tab){panelnum,n} = [];
end

%----------------------------------------------------
% Select Output Data
%----------------------------------------------------
[file,path] = uigetfile('*.mat','Select Composite',SCRPTPATHS.(tab)(panelnum).defloc);
if path == 0
    err.flag = 4;
    err.msg = 'Composite not selected';
    ErrDisp(err);
    return
end
defloc = path;
SCRPTPATHS.(tab)(panelnum).defloc = defloc;

%----------------------------------------------------
% Load Default
%----------------------------------------------------
[runfunc,CellArray,err] = LoadComposite(tab,scrptnum,file,path);
if err.flag
    ErrDisp(err);
    return
end

Status2('done','Composite Loaded',1);
Status2('done','',2);
Status2('done','',3);