%===========================================
% 
%===========================================

function [B0MAP,err] = B0Mapping_v1a_Func(B0MAP,INPUT)

Status('busy','Map B0');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Test
%---------------------------------------------
IMG = INPUT.IMG;
ReconPars = IMG.ReconPars;
MAP = INPUT.MAP;
DISP = INPUT.DISP;
clear INPUT;

%---------------------------------------------
% Separate
%---------------------------------------------
Im = IMG.Im;
ExpPars = IMG.ExpPars;
Im1 = squeeze(Im(:,:,:,1,:));
Im2 = squeeze(Im(:,:,:,2,:));
TEdif = ExpPars.te2 - ExpPars.te1;
TEorig = ExpPars.te1;

%---------------------------------------------
% B0 Map
%---------------------------------------------
func = str2func([B0MAP.mapfunc,'_Func']);  
INPUT.Im1 = Im1;
INPUT.Im2 = Im2;
INPUT.TEdif = TEdif;
INPUT.TEorig = TEorig;
INPUT.ReconPars = ReconPars;
[MAP,err] = func(MAP,INPUT);
if err.flag
    return
end
clear INPUT;
fMap = MAP.fMap;

%-------------------------------------------------
% Get Magnitude Image For Plotting
%-------------------------------------------------
if ExpPars.nrcvrs > 1
    sz = size(Im1);
    if sz(4) < ExpPars.nrcvrs+1
        err.flag = 1;
        err.msg = 'Reconstruct with MultiSuperAdd';
        return
    end
    tIm = Im1(:,:,:,ExpPars.nrcvrs+1);
else
    tIm = Im1;
end
if strcmp(ReconPars.Filter,'None')
    [x,y,z] = size(tIm);
    beta = 2;
    Filt = Kaiser_v1b(x,y,z,beta,'unsym');                  
    tIm = fftshift(fftn(ifftshift(Filt.*fftshift(ifftn(ifftshift(tIm))))));   
end
AbsIm = abs(tIm);

%-------------------------------------------------
% Base Mask
%-------------------------------------------------
BaseMask = ones(size(AbsIm));
BaseMask(AbsIm < 0.05*max(AbsIm(:))) = NaN;

%---------------------------------------------
% Display
%---------------------------------------------
func = str2func([B0MAP.dispfunc,'_Func']);  
INPUT.AbsIm = AbsIm;
INPUT.BaseMask = BaseMask;
INPUT.fMap = fMap;
[DISP,err] = func(DISP,INPUT);
if err.flag
    return
end
clear INPUT;

%---------------------------------------------
% Return
%---------------------------------------------
B0MAP.Im = -MAP.fMap;
B0MAP.ReconPars = ReconPars;
B0MAP.ExpPars = ExpPars;
B0MAP.PanelOutput = IMG.PanelOutput;

Status2('done','',1);
Status2('done','',2);
Status2('done','',3);

