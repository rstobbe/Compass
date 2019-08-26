%====================================================
%  
%====================================================

function [RSZ,err] = SameSizeTest_v1a_Func(RSZ,INPUT)

Status2('busy','Test Images for Same Size',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
ReconPars0 = INPUT.ReconPars0;
ReconPars1 = INPUT.ReconPars1;
Im = INPUT.Im;
clear INPUT;

%---------------------------------------------
% Test
%---------------------------------------------
if ReconPars0.ImfovTB ~= ReconPars1.ImfovTB || ...
   ReconPars0.ImfovIO ~= ReconPars1.ImfovIO || ...
   ReconPars0.ImfovLR ~= ReconPars1.ImfovLR 
      err.flag = 1;
      err.msg = 'Image FoVs Do Not Match';
      return
end

if ReconPars0.ImvoxTB ~= ReconPars1.ImvoxTB || ...
   ReconPars0.ImvoxIO ~= ReconPars1.ImvoxIO || ...
   ReconPars0.ImvoxLR ~= ReconPars1.ImvoxLR 
      err.flag = 1;
      err.msg = 'Image Voxels Do Not Match';
      return
end

%---------------------------------------------
% Return
%---------------------------------------------
RSZ.Im = Im;

Status2('done','',2);
Status2('done','',3);

