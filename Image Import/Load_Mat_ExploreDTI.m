%===================================================
% Load_ExploreDTI
%===================================================

function [IMG,ImInfo,err] = Load_Mat_ExploreDTI(Data)

err.flag = 0;
err.msg = '';
ImInfo = '';

[s,v] = listdlg('PromptString','Load Image Type:','SelectionMode','single','ListString',{'DWIB0','FA'});

switch s
    case 1
        Im = Data.DWIB0;
        ImInfo.info = 'DWIB0 - from Explore DTI';
    case 2
        Im = Data.FA;
        ImInfo.info = 'FA - from Explore DTI';
end

ImInfo.pixdim = Data.VDims;
ImInfo.vox = Data.VDims(1)*Data.VDims(2)*Data.VDims(3);

ReconPars.ImvoxTB =  Data.VDims(1);
ReconPars.ImvoxLR =  Data.VDims(2);  
ReconPars.ImvoxIO =  Data.VDims(3);  

Im = flip(Im,3);

IMG.Im = Im;
IMG.ReconPars = ReconPars;
