%=====================================================
% 
%=====================================================

function [ORNT,err] = Orient_fsemsuf_v1a_Func(ORNT,INPUT)

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
    ReconPars.ImfovIO = ReconPars.Imfovslc;
    ReconPars.ImvoxIO = ReconPars.Imvoxslc;
    ReconPars.ImszIO = ReconPars.Imfovslc/ReconPars.Imvoxslc; 
    ReconPars = rmfield(ReconPars,{'Imfovro','Imfovpe1','Imfovslc','Imvoxro','Imvoxpe1','Imvoxslc'});
elseif strcmp(orient,'oblique')
    ORNT.Im = INPUT.Im;
    ReconPars.ornt = ORNT.method;
    ReconPars.ImfovLR = ReconPars.Imfovro;
    ReconPars.ImfovTB = ReconPars.Imfovpe1;               
    ReconPars.ImvoxLR = ReconPars.Imvoxro;
    ReconPars.ImvoxTB = ReconPars.Imvoxpe1;
    ReconPars.ImszLR = ReconPars.Imfovro/ReconPars.Imvoxro;
    ReconPars.ImszTB = ReconPars.Imfovpe1/ReconPars.Imvoxpe1;
    ReconPars.ImfovIO = ReconPars.Imfovslc;
    ReconPars.ImvoxIO = ReconPars.Imvoxslc;
    ReconPars.ImszIO = ReconPars.Imfovslc/ReconPars.Imvoxslc; 
    ReconPars = rmfield(ReconPars,{'Imfovro','Imfovpe1','Imfovslc','Imvoxro','Imvoxpe1','Imvoxslc'});
end
ORNT.ReconPars = ReconPars;

Status2('done','',2);
Status2('done','',3);






