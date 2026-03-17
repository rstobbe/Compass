%===================================================
% Load_RWS
%===================================================

function [IMG,ImInfo,err] = Load_Mat_RWS(Data)

err.flag = 0;
err.msg = '';
ImInfo = '';

found = 0;
saveData = Data.saveData;
names = fieldnames(saveData);
for n = 1:length(names)
    if isfield(saveData.(names{n}),'Im')
        field = names{n};
        found = 1;
        break
    end
end
if found == 0
    IMG = struct();
    err.flag = 1;
    err.msg = 'File does not contain loadable image';
    return
end

IMG = saveData.(field);
found = 0;
if isfield(IMG,'IMDISP')
    if isfield(IMG.IMDISP,'ImInfo')
        found = 1;
    end
end
if found == 0
    if isfield(IMG,'ReconPars')
        ImvoxTB = IMG.ReconPars.ImvoxTB;
        ImvoxLR = IMG.ReconPars.ImvoxLR;
        ImvoxIO = IMG.ReconPars.ImvoxIO;
    else
        ImvoxTB = 1;
        ImvoxLR = 1;
        ImvoxIO = 1;
    end
    ImInfo.pixdim = [ImvoxTB,ImvoxLR,ImvoxIO];
    ImInfo.vox = ImvoxTB*ImvoxLR*ImvoxIO;
    if isfield(IMG,'ExpDisp')
        ImInfo.info = IMG.ExpDisp;
    else
        ImInfo.info = '';
    end
    ImInfo.acqorient = 'Axial';  
    ImInfo.baseorient = 'Axial';  
end

if isfield(Data,'saveSCRPTcellarray')
    IMG.saveSCRPTcellarray = Data.saveSCRPTcellarray;
end





