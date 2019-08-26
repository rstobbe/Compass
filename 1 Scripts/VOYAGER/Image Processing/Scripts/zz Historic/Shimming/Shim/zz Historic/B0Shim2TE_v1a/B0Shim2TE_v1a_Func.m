%===========================================
% 
%===========================================

function [SHIM,err] = ShimB0_v2e_Func(SHIM,INPUT)

Status('busy','B0 Shimming');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Input
%---------------------------------------------
IMG = INPUT.IMG;
ReconPars = IMG.ReconPars;
Shims = IMG.FID.Shim;
ExpPars = IMG.ExpPars;
Im = IMG.Im;
CAL = INPUT.CAL;
MAP = INPUT.MAP;
MASK = INPUT.MASK;
FIT = INPUT.FIT;
DISP = INPUT.DISP;
SCRPTipt = INPUT.SCRPTipt;
SCRPTGBL = INPUT.SCRPTGBL;
clear INPUT;

%**** add to calibration output ***
CAL.shimsused = '3degz4';
CAL.ReconPars = ReconPars;
%**********************************

%---------------------------------------------
% Test Compare Image With Calibration
%---------------------------------------------
CalReconPars = CAL.ReconPars;

if CalReconPars.orp ~= ReconPars.orp || not(strcmp(CalReconPars.ornt,ReconPars.ornt))
    error();    % fix up orientation (include update to reconpars)...
end
if CalReconPars.ImfovLR ~= ReconPars.ImfovLR || ...
   CalReconPars.ImfovTB ~= ReconPars.ImfovTB || ...
   CalReconPars.ImfovIO ~= ReconPars.ImfovIO || ...
   CalReconPars.ImvoxLR ~= ReconPars.ImvoxLR || ...
   CalReconPars.ImvoxTB ~= ReconPars.ImvoxTB || ...
   CalReconPars.ImvoxIO ~= ReconPars.ImvoxIO
        error();    % fix up image dimensions (include update to reconpars)...
        %[Imzf,err] = Imzerofilltodim_v1a(Im,zfdims)
end

%---------------------------------------------
% Separate
%---------------------------------------------
Im1 = Im(:,:,:,1,:);
Im2 = Im(:,:,:,2,:);
TEdif = ExpPars.te2 - ExpPars.te1;
TEorig = ExpPars.te1;

%-------------------------------------------------
% Create Absolute Image For Plotting
%-------------------------------------------------
if strcmp(ReconPars.Filter,'None')
    [x,y,z] = size(Im1);
    beta = 2;
    Filt = Kaiser_v1b(x,y,z,beta,'unsym');                  
    AbsIm = abs(fftshift(fftn(ifftshift(Filt.*fftshift(ifftn(ifftshift(Im1)))))));   
else
   AbsIm = abs(Im1);
end

%---------------------------------------------
% Create B0 Map
%---------------------------------------------
func = str2func([SHIM.mapfunc,'_Func']);  
INPUT.Im1 = Im1;
INPUT.Im2 = Im2;
INPUT.TEdif = TEdif;
INPUT.TEorig = TEorig;
[MAP,err] = func(MAP,INPUT);
if err.flag
    return
end
clear INPUT;
fMap = MAP.fMap;

%-------------------------------------------------
% Base Mask
%-------------------------------------------------
BaseMask = ones(size(AbsIm));
BaseMask(AbsIm < 0.05*max(AbsIm(:))) = NaN;

%---------------------------------------------
% Mask
%---------------------------------------------
func = str2func([SHIM.maskfunc,'_Func']);  
INPUT.Im = AbsIm.*BaseMask;
INPUT.fMap = fMap.*BaseMask;
INPUT.ReconPars = ReconPars;
INPUT.figno = 100;
INPUT.SCRPTipt = SCRPTipt;
INPUT.SCRPTGBL = SCRPTGBL;
[MASK,err] = func(MASK,INPUT);
if err.flag
    return
end
if isfield(MASK,'SCRPTipt');
    SCRPTipt = MASK.SCRPTipt;
end
Mask = MASK.Mask;
clear INPUT;

%---------------------------------------------
% Get Previous Shims
%---------------------------------------------
for n = 1:length(CAL.CalData)
    PrevShims(n) = Shims.(CAL.CalData(n).Shim);
end

%---------------------------------------------
% Shim
%---------------------------------------------
func = str2func([SHIM.fitfunc,'_Func']);  
INPUT.Im = fMap.*Mask;
INPUT.CalData = CAL.CalData;
INPUT.PrevShims = PrevShims;
[FIT,err] = func(FIT,INPUT);
if err.flag
    return
end
clear INPUT;
Vfit = -round(FIT.V);
Prof = FIT.Prof;

%---------------------------------------------
% Display
%---------------------------------------------
func = str2func([SHIM.dispfunc,'_Func']);  
INPUT.AbsIm = AbsIm;
INPUT.BaseMask = BaseMask;
INPUT.fMap = fMap;
INPUT.Mask = Mask;
INPUT.Prof = Prof;
[DISP,err] = func(DISP,INPUT);
if err.flag
    return
end
clear INPUT;

%---------------------------------------------
% Add to Previous Shims
%---------------------------------------------
for n = 1:length(Vfit)
    V(n) = Shims.(CAL.CalData(n).Shim) + Vfit(n);
end
    
%--------------------------------------------
% Panel
%--------------------------------------------
for n = 1:length(V)
    Panel(n,:) = {['Update_',CAL.CalData(n).Shim],Vfit(n),'Output'};
end
n = n+1;
Panel(n,:) = {'','','Output'};
N = n;
for n = 1:length(V)
    Panel(n+N,:) = {['New_',CAL.CalData(n).Shim],V(n),'Output'};
end
PanelOutput = cell2struct(Panel,{'label','value','type'},2);
SHIM.PanelOutput = PanelOutput;

%---------------------------------------------
% Return
%---------------------------------------------
SHIM.CalData = CAL.CalData;
SHIM.Vfit = Vfit;
SHIM.V = V;
SHIM.fMap = fMap;
SHIM.Prof = Prof;
SHIM.Mask = Mask;
SHIM.BaseMask = BaseMask;
SHIM.AbsIm = AbsIm;
SHIM.SCRPTipt = SCRPTipt;

Status2('done','',2);
Status2('done','',3);

