%====================================================
%  
%====================================================

function [IC,err] = ImCon2DCartSingle_v1b_Func(IC,INPUT)

Status2('busy','Create 2D-Cartesian Image',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
FID = INPUT.FID;
PREPRC = IC.PREPRC;
RCOMB = IC.RCOMB;
FILT = IC.FILT;
ZF = IC.ZF;
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
func = str2func([IC.rcvcombfunc,'_Func']);  
INPUT.vis = 'No';
INPUT.Im = Im;
INPUT.ReconPars = FID.ReconPars;
[RCOMB,err] = func(RCOMB,INPUT);
if err.flag
    return
end
Im = RCOMB.Im;
clear INPUT;
clear RCOMB;

%----------------------------------------------
% Filter
%----------------------------------------------
func = str2func([IC.filterfunc,'_Func']);  
INPUT.Im = Im;
[FILT,err] = func(FILT,INPUT);
if err.flag
    return
end
Im = FILT.Im;
clear INPUT;
clear FILT;

%---------------------------------------------
% Zero Fill
%---------------------------------------------
func = str2func([IC.zerofillfunc,'_Func']);  
INPUT.Im = Im;
[ZF,err] = func(ZF,INPUT);
if err.flag
    return
end
Im = ZF.Im;
clear INPUT;
clear ZF;

%--------------------------------------------
% Panel
%--------------------------------------------
sz = size(Im);
Panel(1,:) = {'ImSz_X',sz(1),'Output'};
Panel(2,:) = {'ImSz_Y',sz(2),'Output'};
Panel(3,:) = {'ImSz_Z',sz(3),'Output'};
Panel(4,:) = {'ImMaxVal',max(abs(Im(:))),'Output'};
IC.PanelOutput = cell2struct(Panel,{'label','value','type'},2);

%---------------------------------------------
% Return
%---------------------------------------------
IC.Im = Im;
IC.ImSz_X = sz(1);
IC.ImSz_Y = sz(2);
IC.ImSz_Z = sz(3);
IC.maxval = max(abs(Im(:)));
IC.ExpPars = ExpPars;
IC.ReconPars = FID.ReconPars;

Status2('done','',2);
Status2('done','',3);



