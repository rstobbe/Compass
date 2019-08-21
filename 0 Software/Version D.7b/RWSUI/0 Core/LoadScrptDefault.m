%====================================================
%
%====================================================

function [runfunc,CellArray,err] = LoadScrptDefault(panelnum,tab,scrptnum,file,path)

Status('busy','Load Script');

global DEFFILEGBL

err.flag = 0;
err.msg = '';
runfunc = '';
CellArray = [];

%----------------------------------------------------
% Load
%----------------------------------------------------
if not(exist([path,file],'file'))
    err.flag = 1;
    err.msg = ['Script ''',file(1:end-4),''' file does not exist'];
    CellArray = [];
    return
end
load([path,file]);
if not(exist('ScrptCellArray','var'))
    err.flag = 1;
    err.msg = 'Not an RWS Script File';
    return
end
CellArray = ScrptCellArray;

%----------------------------------------------------
% Load2Panels
%----------------------------------------------------
[runfunc,CellArray,err] = LoadScrptDefault2Panels(panelnum,tab,scrptnum,CellArray);
if err.flag
    ErrDisp(err);
    return
end

%----------------------------------------------------
% Save Default Name
%----------------------------------------------------
DEFFILEGBL.(tab)(panelnum,scrptnum).file = [path,file];

Status('done','Script Loaded');


