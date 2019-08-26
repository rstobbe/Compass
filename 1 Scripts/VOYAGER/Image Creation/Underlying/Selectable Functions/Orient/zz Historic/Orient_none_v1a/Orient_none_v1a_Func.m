%=====================================================
%
%=====================================================

function [ORNT,err] = Orient_none_v1a_Func(ORNT,INPUT)

Status2('busy','Orient',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Do Nothing
%---------------------------------------------
ReconPars = INPUT.ReconPars;
ORNT.Im = INPUT.Im;

ReconPars.ornt = ORNT.method;
ReconPars.ImfovLR = ReconPars.Imfovro;
ReconPars.ImfovTB = ReconPars.Imfovpe1;               
ReconPars.ImvoxLR = ReconPars.Imvoxro;
ReconPars.ImvoxTB = ReconPars.Imvoxpe1;
ReconPars.ImszLR = ReconPars.Imfovro/ReconPars.Imvoxro;
ReconPars.ImszTB = ReconPars.Imfovpe1/ReconPars.Imvoxpe1;
if isfield(ReconPars,'Imfovpe2')
    ReconPars.ImfovIO = ReconPars.Imfovpe2;
    ReconPars.ImvoxIO = ReconPars.Imvoxpe2; 
    ReconPars.ImszIO = ReconPars.Imfovpe2/ReconPars.Imvoxpe2; 
    ReconPars = rmfield(ReconPars,{'Imfovro','Imfovpe1','Imfovpe2','Imvoxro','Imvoxpe1','Imvoxpe2'});
else
    ReconPars.ImfovIO = ReconPars.Imfovslc;
    ReconPars.ImvoxIO = ReconPars.Imvoxslc;
    ReconPars.ImszIO = ReconPars.Imfovslc/ReconPars.Imvoxslc; 
    ReconPars = rmfield(ReconPars,{'Imfovro','Imfovpe1','Imfovslc','Imvoxro','Imvoxpe1','Imvoxslc'});
end
ORNT.ReconPars = ReconPars;

Status2('done','',2);
Status2('done','',3);






