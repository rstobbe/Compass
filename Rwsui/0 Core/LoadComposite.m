%====================================================
%
%====================================================

function [runfunc,CellArray,err] = LoadComposite(tab,scrptnum,file,path)

Status('busy','Load Composite');

err.flag = 0;
err.msg = '';
runfunc = [];
CompCellArray = [];

%----------------------------------------------------
% Load
%----------------------------------------------------
if not(exist([path,file],'file'))
    err.flag = 1;
    err.msg = ['''',file(1:end-4),''' script does not exist'];
    CellArray = [];
    return
end
load([path,file]);
if not(exist('CompCellArray','var'));
    err.flag = 1;
    err.msg = 'Not an RWS Composite File';
    return
end
CompCellArray = CompCellArray;

%----------------------------------------------------
% Load2Panels
%----------------------------------------------------
for n = 1:4
    if not(isempty(CompCellArray{n,1,2}{1}))
        [runfunc{n},CellArray{n},err] = LoadScrptDefault2Panels(n,tab,scrptnum,CompCellArray(n,:,:));
        if err.flag
            ErrDisp(err);
            return
        end
    end
end

Status('done','Composite Loaded');


