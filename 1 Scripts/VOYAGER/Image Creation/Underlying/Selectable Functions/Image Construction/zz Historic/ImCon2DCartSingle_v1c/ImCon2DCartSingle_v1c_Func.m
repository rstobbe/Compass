%====================================================
%  
%====================================================

function [IC,err] = ImCon2DCartSingle_v1c_Func(IC,INPUT)

Status2('busy','Create 2D-Cartesian Image',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
FID = INPUT.FID;
ReconPars = FID.ReconPars;
PREPRC = IC.PREPRC;
RCOMB = IC.RCOMB;
FILT = IC.FILT;
ZF = IC.ZF;
ORNT = IC.ORNT;
clear INPUT;

%----------------------------------------------
% FID Info
%----------------------------------------------
ExpPars = FID.ExpPars;
FIDmat = FID.FIDmat;

%----------------------------------------------
% Pre Process
%----------------------------------------------
func = str2func([IC.preprocfunc,'_Func']);  
INPUT.FIDmat = FIDmat;
[PREPRC,err] = func(PREPRC,INPUT);
if err.flag
    return
end
FIDmat = PREPRC.FIDmat;
clear INPUT;
clear PREPRC;

%---------------------------------------------
% Create Images
%---------------------------------------------
Status2('busy','Fourier Transform',2);
Im = zeros(size(FIDmat));
[x,y,nslices,nrcvrs] = size(FIDmat);
for m = 1:nslices
    for n = 1:ExpPars.nrcvrs
        Im(:,:,m,n) = fftshift(ifftn(ifftshift(FIDmat(:,:,m,n))));
    end
end
    
%------------------------------------------
% Combine Receivers
%------------------------------------------
if ExpPars.nrcvrs > 1
    func = str2func([IC.rcvcombfunc,'_Func']);  
    INPUT.vis = IC.visuals;
    INPUT.Im = Im;
    INPUT.ReconPars = ReconPars;
    [RCOMB,err] = func(RCOMB,INPUT);
    if err.flag
        return
    end
    Im = RCOMB.Im;
    clear INPUT;
    clear RCOMB;
end

%----------------------------------------------
% Filter
%----------------------------------------------
func = str2func([IC.filterfunc,'_Func']);  
INPUT.Im = Im;
INPUT.ReconPars = ReconPars;
[FILT,err] = func(FILT,INPUT);
if err.flag
    return
end
Im = FILT.Im;
ReconPars = FILT.ReconPars;
clear INPUT;
clear FILT;

%---------------------------------------------
% Zero Fill
%---------------------------------------------
func = str2func([IC.zerofillfunc,'_Func']);  
INPUT.Im = Im;
INPUT.ReconPars = ReconPars;
[ZF,err] = func(ZF,INPUT);
if err.flag
    return
end
Im = ZF.Im;
ReconPars = ZF.ReconPars;
clear INPUT;
clear ZF;

%----------------------------------------------
% Return FoV
%----------------------------------------------
if strcmp(IC.returnfov,'Yes')
    sz = size(Im);
    bot = (sz(1) - sz(1)/ExpPars.rosamp)/2 + 1;
    top = bot + sz(1)/ExpPars.rosamp - 1;
    Im = Im(bot:top,:,:,:);
end
ReconPars.Imfovro = ReconPars.Imfovro/ExpPars.rosamp;

%----------------------------------------------
% Orient
%----------------------------------------------
func = str2func([IC.orientfunc,'_Func']);  
INPUT.Im = Im;
INPUT.ReconPars = ReconPars;
[ORNT,err] = func(ORNT,INPUT);
if err.flag
    return
end
Im = ORNT.Im;
ReconPars = ORNT.ReconPars;
clear INPUT;
clear ORNT;

%--------------------------------------------
% Panel
%--------------------------------------------
sz = size(Im);
Panel(1,:) = {'ImFoV_LR',ReconPars.ImfovLR,'Output'};
Panel(2,:) = {'ImFoV_TB',ReconPars.ImfovTB,'Output'};
Panel(3,:) = {'ImFoV_IO',ReconPars.ImfovIO,'Output'};
Panel(4,:) = {'ImSz_LR',ReconPars.ImszLR,'Output'};
Panel(5,:) = {'ImSz_TB',ReconPars.ImszTB,'Output'};
Panel(6,:) = {'ImSz_IO',ReconPars.ImszIO,'Output'};
Panel(7,:) = {'ImMaxVal',max(abs(Im(:))),'Output'};
IC.PanelOutput = cell2struct(Panel,{'label','value','type'},2);

%---------------------------------------------
% Return
%---------------------------------------------
IC.Im = Im;
IC.ImSz_X = ReconPars.ImszLR;
IC.ImSz_Y = ReconPars.ImszTB;
IC.ImSz_Z = ReconPars.ImszIO;
IC.maxval = max(abs(Im(:)));
IC.ExpPars = ExpPars;
IC.ReconPars = ReconPars;

Status2('done','',2);
Status2('done','',3);

