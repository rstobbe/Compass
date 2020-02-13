%====================================================
%  
%====================================================

function [RSZ,err] = FoVAdjust_v1a_Func(RSZ,INPUT)

Status2('busy','Adjust FoV',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
IMG = INPUT.IMG{1};
MatDims = IMG.IMDISP.ImInfo.dims;
PixDims = IMG.IMDISP.ImInfo.pixdim;
clear INPUT;

%---------------------------------------------
% Test
%---------------------------------------------
if ReconPars0.ImvoxTB ~= ReconPars1.ImvoxTB || ...
   ReconPars0.ImvoxIO ~= ReconPars1.ImvoxIO || ...
   ReconPars0.ImvoxLR ~= ReconPars1.ImvoxLR 
      err.flag = 1;
      err.msg = 'Image Resolutions Must Match for ''FoVAdjust''';
      return
end

%---------------------------------------------
% Test
%---------------------------------------------
if ReconPars0.ImfovTB ~= ReconPars1.ImfovTB || ...
   ReconPars0.ImfovIO ~= ReconPars1.ImfovIO || ...
   ReconPars0.ImfovLR ~= ReconPars1.ImfovLR 
        sz = size(Im);
        if length(sz) == 4
            ImNew = zeros(ReconPars1.ImszLR,ReconPars1.ImszTB,ReconPars1.ImszIO,sz(4));
        elseif length(sz) == 5
            ImNew = zeros(ReconPars1.ImszLR,ReconPars1.ImszTB,ReconPars1.ImszIO,sz(4),sz(5));
        end
        bLR = abs((ReconPars1.ImszLR - ReconPars0.ImszLR)/2)+1;
        tLR = ReconPars1.ImszLR - abs((ReconPars1.ImszLR - ReconPars0.ImszLR)/2);
        if rem(bLR,1)
            error();  % not finished
        end
        bTB = abs((ReconPars1.ImszTB - ReconPars0.ImszTB)/2)+1;
        tTB = ReconPars1.ImszTB - abs((ReconPars1.ImszTB - ReconPars0.ImszTB)/2);
        if rem(bTB,1)
            error();  % not finished
        end
        bIO = abs((ReconPars1.ImszIO - ReconPars0.ImszIO)/2)+1;
        tIO = ReconPars1.ImszIO - abs((ReconPars1.ImszIO - ReconPars0.ImszIO)/2);
        if rem(bIO,1)
            error();  % not finished
        end        
        ImNew(bLR:tLR,bTB:tTB,bIO:tIO,:,:) = Im;
        Im = ImNew;
end

RSZ.Im = Im;

Status2('done','',2);
Status2('done','',3);

