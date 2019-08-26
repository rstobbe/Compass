%====================================================
%  
%====================================================

function [IMG,err] = Create2DCart1_v1a_Func(INPUT,IMG)

Status('busy','Create 2D-Cartesian Image');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
FID = INPUT.FID;
DCCOR = INPUT.DCCOR;
PREP = INPUT.PREP;
FILT = INPUT.FILT;
RCOMB = INPUT.RCOMB;
PSTP = INPUT.PSTP;
clear INPUT;

%----------------------------------------------
% Import FID
%----------------------------------------------
func = str2func([IMG.importfidfunc,'_Func']);  
INPUT = struct();
[FID,err] = func(FID,INPUT);
if err.flag
    return
end
ExpPars = FID.ExpPars;
FIDmat = FID.FIDmat;
clear INPUT;
clear FID;

%----------------------------------------------
% DCcor FID
%----------------------------------------------
func = str2func([IMG.dccorfunc,'_Func']);  
INPUT.FIDmat = FIDmat;
INPUT.nrcvrs = ExpPars.nrcvrs;
[DCCOR,err] = func(DCCOR,INPUT);
if err.flag
    return
end
FIDmat = DCCOR.FIDmat;
clear INPUT;
clear DCCOR;

%----------------------------------------------
% Pre Process FID
%----------------------------------------------
func = str2func([IMG.prepfunc,'_Func']);  
INPUT.FIDmat = FIDmat;
INPUT.nrcvrs = ExpPars.nrcvrs;
[PREP,err] = func(PREP,INPUT);
if err.flag
    return
end
FIDmat = PREP.FIDmat;
clear INPUT;
clear PREP;

%----------------------------------------------
% Create Images
%----------------------------------------------
Status2('busy','FT',2);
[~,~,nz,nrcvrs] = size(FIDmat);
Im = zeros(size(FIDmat));
for n = 1:nrcvrs
    for z = 1:nz
        Im(:,:,z,n) = fftshift(ifft2(ifftshift(FIDmat(:,:,z,n))));
    end
end

%------------------------------------------
% Combine Receivers
%------------------------------------------
func = str2func([IMG.rcvcombfunc,'_Func']);  
INPUT.vis = 'Yes';
INPUT.Im = Im;
INPUT.nrcvrs = ExpPars.nrcvrs;
[RCOMB,err] = func(RCOMB,INPUT);
if err.flag
    return
end
Im = RCOMB.Im;
clear INPUT;
clear RCOMB;

%----------------------------------------------
% Filter Image
%----------------------------------------------
func = str2func([IMG.filtfunc,'_Func']);  
INPUT.Im = Im;
INPUT.nrcvrs = ExpPars.nrcvrs;
[FILT,err] = func(FILT,INPUT);
if err.flag
    return
end
Im = FILT.Im;
clear INPUT;
clear FILT;

%----------------------------------------------
% Post Process Image
%----------------------------------------------
func = str2func([IMG.pstpfunc,'_Func']);  
INPUT.Im = Im;
INPUT.nrcvrs = ExpPars.nrcvrs;
[PSTP,err] = func(PSTP,INPUT);
if err.flag
    return
end
Im = PSTP.Im;
clear INPUT;
clear PSTP;

%-------------------------------------------
% Orient
%-------------------------------------------
%Im = flipdim(Im,3);

%---------------------------------------------
% Return
%---------------------------------------------
IMG.Im = Im;
IMG.ExpPars = ExpPars;

%----------------------------------------------------
% Panel Items
%----------------------------------------------------
%Panel(1,:) = {'','','Output'};
%PanelOutput = cell2struct(Panel,{'label','value','type'},2);
%IMG.PanelOutput = PanelOutput;

Status('done','');
Status2('done','',2);
Status2('done','',3);



