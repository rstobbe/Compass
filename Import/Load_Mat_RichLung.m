%===================================================
% Load_RWS
%===================================================

function [IMG,ImInfo,err] = Load_Mat_RichLung(Data)

err.flag = 0;
err.msg = '';
ImInfo = '';

IMG.Im = Data.lung.CroppedImg;
IMG.Data = Data.lung;

IMG.Im = squeeze(IMG.Im);
ImInfo.pixdim = [1,1,1];                   
ImInfo.vox = 1;
ImInfo.info = '';
ImInfo.baseorient = 'Axial';  

Panel(1,:) = {'','','Output'};
Panel(2,:) = {'Description','MatFile','Output'};
IMG.PanelOutput = cell2struct(Panel,{'label','value','type'},2);
IMG.ExpDisp = PanelStruct2Text(IMG.PanelOutput);
