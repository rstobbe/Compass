%===================================================
% Load_RWS
%===================================================

function [IMG,ImInfo,err] = Load_Mat_Generic(Data)

err.flag = 0;
err.msg = '';
ImInfo = '';

found = 0;
if isfield(Data,'img')
    IMG.Im = Data.img;
    found = 1;
elseif isfield(Data,'im')
    IMG.Im = Data.im;
    found = 1;
else
    names = fieldnames(Data);
    if size(names) == 1
        IMG.Im = Data.(names{1});
    end
    found = 1;
end
IMG.Im = squeeze(IMG.Im);
ImInfo.pixdim = [1,1,1];                    % Finish
ImInfo.vox = 1;
ImInfo.info = '';
ImInfo.baseorient = 'Axial';  

if found == 0
    err.flag = 1;
    err.msg = 'Put image matrix in ''im''';
    IMG = struct();
    return
end

Panel(1,:) = {'','','Output'};
Panel(2,:) = {'Description','MatFile','Output'};
IMG.PanelOutput = cell2struct(Panel,{'label','value','type'},2);
IMG.ExpDisp = PanelStruct2Text(IMG.PanelOutput);
