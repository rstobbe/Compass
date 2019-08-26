%=====================================================
%
%=====================================================

function [ORNT,err] = Orient_VarianPA_v1a_Func(ORNT,INPUT)

Status2('busy','Orient',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
ReconPars = INPUT.ReconPars;
if not(isfield(ReconPars,'orp'))
    ReconPars.orp = 1;
end
orp = ReconPars.orp;


%---------------------------------------------
% Flip
%---------------------------------------------
if orp == 1
    sz = size(INPUT.Im);
    Im = 10000*permute(INPUT.Im,[2,1,3,4]); 
    ORNT.Im = flip(Im,1);
    ReconPars.ornt = ORNT.method;  
    ReconPars.ImfovTB = ReconPars.Imfovx;
    ReconPars.ImfovLR = ReconPars.Imfovy;                 
    ReconPars.ImfovIO = ReconPars.Imfovz;       
    ReconPars.ImvoxTB = ReconPars.Imfovx/sz(1);
    ReconPars.ImvoxLR = ReconPars.Imfovy/sz(2);
    ReconPars.ImvoxIO = ReconPars.Imfovz/sz(3);
    ReconPars.ImszTB = sz(1);
    ReconPars.ImszLR = sz(2);
    ReconPars.ImszIO = sz(3); 
    ReconPars = rmfield(ReconPars,{'Imfovx','Imfovy','Imfovz'});    
    ORNT.ReconPars = ReconPars;    
elseif orp == 2
    error();
elseif orp == 3
    error();
end

Status2('done','',2);
Status2('done','',3);