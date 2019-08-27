%===================================================
% Load_Analyze
%===================================================

function [IMG,ImInfo,err] = Load_Analyze(imfile)

err.flag = 0;
err.msg = '';
ImInfo = '';

Im = analyze75read(imfile);
test = analyze75info(imfile);
ImInfo.pixdim = test.PixelDimensions;
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
IMG.ExpDisp = [];

ImInfo.acqorient = 'Axial';  
ImInfo.baseorient = 'Axial';  