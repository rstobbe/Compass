%=====================================================
%
%=====================================================

function [ORNT,err] = Orient_Standard_v1a_Func(ORNT,INPUT)

Status2('busy','Orient',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
IMPORNT = INPUT.IMP.GWFM.ORNT;
Im = INPUT.Im;
ReconPars = INPUT.ReconPars;
clear INPUT;

%---------------------------------------------
% Orient
%---------------------------------------------
if strcmp(IMPORNT.ScannerOrient,'Axial')
    if strcmp(IMPORNT.ReconOrient,'Axial')
        ORNT.Im = permute(Im,[2 1 3 4 5]);
        sz = size(Im);
        ReconPars.ImfovTB = ReconPars.Imfovx;
        ReconPars.ImfovLR = ReconPars.Imfovy;                 
        ReconPars.ImfovIO = ReconPars.Imfovz;  
        ReconPars.ImvoxLR = ReconPars.Imfovy/sz(1);
        ReconPars.ImvoxTB = ReconPars.Imfovx/sz(2);
        ReconPars.ImvoxIO = ReconPars.Imfovz/sz(3);
        ReconPars.ImszLR = sz(1);
        ReconPars.ImszTB = sz(2);
        ReconPars.ImszIO = sz(3);
        ORNT.ReconPars = ReconPars;
    end
end

Status2('done','',2);
Status2('done','',3);






