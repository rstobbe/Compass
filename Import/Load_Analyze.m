%===================================================
% Load_Analyze
%===================================================

function [IMG,ImInfo,err] = Load_Analyze(imfile)

err.flag = 0;
err.msg = '';
ImInfo = '';

Im = analyze75read(imfile);
test = analyze75info(imfile);
%-
pixdim = test.PixelDimensions;
ImInfo.pixdim = [pixdim(2) pixdim(1) pixdim(3)];
%-
ImInfo.vox = ImInfo.pixdim(1)*ImInfo.pixdim(2)*ImInfo.pixdim(3);
ImInfo.info = '';

%---------------------------------
Im = flip(Im,1);                        % Analyze orientation - don't change (problem elsewehere)
%---------------------------------

ReconPars.ImvoxTB = round(ImInfo.pixdim(1)*100)/100;
ReconPars.ImvoxLR = round(ImInfo.pixdim(2)*100)/100;  
ReconPars.ImvoxIO = round(ImInfo.pixdim(3)*100)/100;  

sz = size(Im);
ReconPars.ImfovTB = ReconPars.ImvoxTB*sz(1);
ReconPars.ImfovLR = ReconPars.ImvoxLR*sz(2);
ReconPars.ImfovIO = ReconPars.ImvoxIO*sz(3);

IMG.Im = double(Im);
IMG.ReconPars = ReconPars;

ImInfo.acqorient = 'Axial';  
ImInfo.baseorient = 'Axial';  

Panel(1,:) = {'','','Output'};
Panel(2,:) = {'File',imfile,'Output'};
IMG.PanelOutput = cell2struct(Panel,{'label','value','type'},2);
IMG.ExpDisp = PanelStruct2Text(IMG.PanelOutput);