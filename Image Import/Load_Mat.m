%===================================================
% Load_Mat
%===================================================

function [IMG,ImInfo,ImType,err] = Load_Mat(imfile)

Data = load(imfile);
if isfield(Data,'saveData')
    [IMG,ImInfo,err] = Load_Mat_RWS(Data);
    ImType = 'MatRWS';
elseif isfield(Data,'DWIB0') && isfield(Data,'FA') 
    [IMG,ImInfo,err] = Load_Mat_ExploreDTI(Data);
    ImType = 'MatExploreDTI';
elseif isfield(Data,'img') && isfield(Data,'par')
    [IMG,ImInfo,err] = Load_Mat_Varian(Data); 
    ImType = 'MatOther';
elseif isfield(Data,'FTK') 
    [IMG,ImInfo,err] = Load_Mat_Old(Data); 
    ImType = 'MatOld';
else
    [IMG,ImInfo,err] = Load_Mat_Generic(Data); 
    ImType = 'MatOther';
end


