%=====================================================
%
%=====================================================

function [ORNT,err] = Orient_gemsme3dR2s_v1a_Func(ORNT,INPUT)

Status2('busy','Orient',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
ReconPars = INPUT.ReconPars;
orient = ReconPars.orient;

%---------------------------------------------
% Flip
%---------------------------------------------
if strcmp(orient,'trans')
    ORNT.Im = INPUT.Im;
    ReconPars.ornt = ORNT.method;  
    ReconPars.ImfovTB = ReconPars.Imfovro;
    ReconPars.ImfovLR = ReconPars.Imfovpe1;               
    ReconPars.ImvoxTB = ReconPars.Imvoxro;
    ReconPars.ImvoxLR = ReconPars.Imvoxpe1;
    ReconPars.ImszTB = ReconPars.Imfovro/ReconPars.Imvoxro;
    ReconPars.ImszLR = ReconPars.Imfovpe1/ReconPars.Imvoxpe1;
    ReconPars.ImfovIO = ReconPars.Imfovpe2;
    ReconPars.ImvoxIO = ReconPars.Imvoxpe2;
    ReconPars.ImszIO = ReconPars.Imfovpe2/ReconPars.Imvoxpe2; 
    ReconPars = rmfield(ReconPars,{'Imfovro','Imfovpe1','Imfovpe2','Imvoxro','Imvoxpe1','Imvoxpe2'});
end
ORNT.ReconPars = ReconPars;

Status2('done','',2);
Status2('done','',3);






