%====================================================
%
%====================================================

function SelectScrptDefault_B9(panelnum,tab,scrptnum)

Status2('busy','Load Script',1);
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

SCRPTGBL.(tab){panelnum,scrptnum} = [];

%----------------------------------------------------
% Select Default
%----------------------------------------------------
[file,path] = uigetfile('*.mat','Select Script',SCRPTPATHS.(tab)(panelnum).defloc);
if path == 0
    err.flag = 4;
    err.msg = 'Script Not Selected';
    ErrDisp(err);
    return
end
defloc = path;
SCRPTPATHS.(tab)(panelnum).defloc = defloc;

%----------------------------------------------------
% Load Default
%----------------------------------------------------
[runfunc,CellArray,err] = LoadScrptDefault(panelnum,tab,scrptnum,file,path);
if err.flag
    ErrDisp(err);
    return
end

Status2('done','Script Loaded',1);
Status2('done','',2);
Status2('done','',3);
