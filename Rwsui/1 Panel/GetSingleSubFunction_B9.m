%=========================================================
%
%=========================================================

function [CellArray] = GetSingleSubFunction_B9(CellArray,tab,panelnum)

global SCRPTPATHS

if not(exist(CellArray{1,1}.entrystr,'file'))
%     path = uigetdir(CellArray{1,1}.searchpath,['Find: ''',CellArray{1,1}.entrystr,''' Folder']);
%     if path == 0
%         error('finish');
%     end
%     CellArray{1,1}.path = path;
    error();        % Selected File Probably not on Path
end

try
    func = str2func([CellArray{1,1}.entrystr,'_Default2']);
    CellArray{1,2} = func(SCRPTPATHS.(tab)(panelnum));
catch
    func = str2func(CellArray{1,1}.entrystr);
    Temp = func();
    CellArray{1,2} = Temp.CompassInterface(SCRPTPATHS.(tab)(panelnum));
end
    
[CellArray] = GetSubFunctions_B9(CellArray(1),tab,panelnum);


%if not(isempty(CellArray{1,2}{1,1}))
%    for n = 1:length(CellArray{1,2}(:,1))
%        CellArray{1,2}{n,1}.altval = 0;
%        CellArray{1,2}{n,2} = cell(1);
%        CellArray{1,2}{n,2}{1,1} = [];
%    end
%end

