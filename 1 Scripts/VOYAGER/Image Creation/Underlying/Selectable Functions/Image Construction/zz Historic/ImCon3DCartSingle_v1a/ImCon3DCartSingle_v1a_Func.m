%====================================================
%  
%====================================================

function [IC,err] = ImCon3DCartSingle_v1a_Func(IC,INPUT)

Status('busy','Create 3D-Cartesian Image');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
FID = INPUT.FID;
KDCCOR = IC.KDCCOR;
PREPRC = IC.PREPRC;
RCOMB = IC.RCOMB;
FILT = IC.FILT;
ZF = IC.ZF;
PSTPRC = IC.PSTPRC;
clear INPUT;

%----------------------------------------------
% FID Info
%----------------------------------------------
ExpPars = FID.ExpPars;
FIDmat = FID.FIDmat;

%----------------------------------------------
% DCcor FID
%----------------------------------------------
func = str2func([IC.kdccorfunc,'_Func']);  
INPUT.FIDmat = FIDmat;
[KDCCOR,err] = func(KDCCOR,INPUT);
if err.flag
    return
end
FIDmat = KDCCOR.FIDmat;
clear INPUT;
clear KDCCOR;

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
for n = 1:ExpPars.nrcvrs
    Im(:,:,:,n) = fftshift(ifftn(ifftshift(FIDmat(:,:,:,n))));
end

%------------------------------------------
% Combine Receivers
%------------------------------------------
func = str2func([IC.rcvcombfunc,'_Func']);  
INPUT.vis = 'No';
INPUT.Im = Im;
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

%----------------------------------------------
% Post Process
%----------------------------------------------
func = str2func([IC.postprocfunc,'_Func']);  
INPUT.Im = Im;
[PSTPRC,err] = func(PSTPRC,INPUT);
if err.flag
    return
end
Im = PSTPRC.Im;
clear INPUT;
clear PSTPRC;

%---------------------------------------------
% Return
%---------------------------------------------
IC.Im = Im;
IC.ImSz = length(Im(:,1,1));
IC.ExpPars = ExpPars;

%----------------------------------------------------
% Panel Items
%----------------------------------------------------
%Panel(1,:) = {'','','Output'};
%PanelOutput = cell2struct(Panel,{'label','value','type'},2);
%IC.PanelOutput = PanelOutput;

Status('done','');
Status2('done','',2);
Status2('done','',3);



