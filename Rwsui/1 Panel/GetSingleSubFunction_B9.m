%=========================================================
%
%=========================================================

function [CellArray] = GetSingleSubFunction_B9(CellArray,tab,panelnum)

global SCRPTPATHS

if not(exist(CellArray{1,1}.entrystr,'file'))
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

