%=====================================================
%
%=====================================================

function [ORNT,err] = Orient_Sim_v1a_Func(ORNT,INPUT)

Status2('busy','Orient',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Orient
%---------------------------------------------
ReconPars = INPUT.ReconPars;
ORNT.Im = INPUT.Im;
 
sz = size(ORNT.Im);

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

Status2('done','',2);
Status2('done','',3);



