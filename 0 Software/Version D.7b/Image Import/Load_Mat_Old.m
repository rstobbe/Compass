%===================================================
% Load_Old
%===================================================

function [IMG,ImInfo,err] = Load_Mat_Old(Data)

err.flag = 0;
err.msg = '';
ImInfo = '';

IMG.Im = Data.FTK;
IMPROP = Data.IMPROP;

ImvoxTB = IMPROP.presx;
ImvoxLR = IMPROP.presy;
ImvoxIO = IMPROP.presz;

ImInfo.pixdim = [ImvoxTB,ImvoxLR,ImvoxIO];
ImInfo.vox = ImvoxTB*ImvoxLR*ImvoxIO;
ImInfo.info = '';
ImInfo.acqorient = 'Axial';  
ImInfo.baseorient = 'Axial';  

IMG.Im = permute(IMG.Im,[2 1 3]);





