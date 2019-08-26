%=====================================================
%
%=====================================================

function [ORNT,err] = Orient_VarianPA_v1b_Func(ORNT,INPUT)

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
    [x,y,z] = size(INPUT.Im);
    Im = permute(INPUT.Im,[2,1,3]);
    Im = flip(Im,1);
    Im = flip(Im,2);    
    ORNT.Im = flip(Im,3);
    ReconPars.ornt = ORNT.method;  
    ReconPars.ImfovTB = ReconPars.Imfovx;
    ReconPars.ImfovLR = ReconPars.Imfovy;                 
    ReconPars.ImfovIO = ReconPars.Imfovz;       
    ReconPars.ImvoxTB = ReconPars.Imfovx/x;
    ReconPars.ImvoxLR = ReconPars.Imfovy/y;
    ReconPars.ImvoxIO = ReconPars.Imfovz/z;
    ReconPars.ImszTB = x;
    ReconPars.ImszLR = y;
    ReconPars.ImszIO = z; 
    ReconPars = rmfield(ReconPars,{'Imfovx','Imfovy','Imfovz'});    
    ORNT.ReconPars = ReconPars;    
elseif orp == 2
    error();
elseif orp == 3
    error();
end

Status2('done','',2);
Status2('done','',3);