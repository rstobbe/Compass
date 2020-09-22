%===================================================
% Load_RWS
%===================================================

function [IMG,ImInfo,err] = Load_Mat_Generic(Data)

err.flag = 0;
err.msg = '';
ImInfo = '';
IMG = cell(1);

found = 0;
if isfield(Data,'img') && isfield(Data,'par')
    Im = Data.img;
    par = Data.par;
    ImInfo.pixdim = [1,1,1];                    % Finish
    ImInfo.vox = 1;
    ImInfo.info = '';
    found = 1;
end
if found == 0
    err.flag = 1;
    err.msg = 'File does not contain loadable image';
    return
end

IMG.Im = Im;

