%=====================================================
% 
%=====================================================

function [ORNT,err] = Orient_SPGR3T_v1a_Func(ORNT,INPUT)

Status2('busy','Orient',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
ReconPars = INPUT.ReconPars;
orp = ReconPars.orp;

%---------------------------------------------
% Flip
%---------------------------------------------
if orp == 1
    Im = flipdim(INPUT.Im,1);
    ORNT.Im = flipdim(Im,2);
    ReconPars.ornt = ORNT.method;  
    ReconPars.ImfovTB = ReconPars.Imfovro;
    ReconPars.ImfovLR = ReconPars.Imfovpe1;                 
    ReconPars.ImfovIO = ReconPars.Imfovpe2;       
    ReconPars.ImvoxTB = ReconPars.Imvoxro;
    ReconPars.ImvoxLR = ReconPars.Imvoxpe1;
    ReconPars.ImvoxIO = ReconPars.Imvoxpe2; 
    ReconPars.ImszTB = ReconPars.Imfovro/ReconPars.Imvoxro;
    ReconPars.ImszLR = ReconPars.Imfovpe1/ReconPars.Imvoxpe1;
    ReconPars.ImszIO = ReconPars.Imfovpe2/ReconPars.Imvoxpe2; 
    ReconPars = rmfield(ReconPars,{'Imfovro','Imfovpe1','Imfovpe2','Imvoxro','Imvoxpe1','Imvoxpe2'});    
    ORNT.ReconPars = ReconPars;    
elseif orp == 2
    error();
elseif orp == 3
    error();
end

Status2('done','',2);
Status2('done','',3);






