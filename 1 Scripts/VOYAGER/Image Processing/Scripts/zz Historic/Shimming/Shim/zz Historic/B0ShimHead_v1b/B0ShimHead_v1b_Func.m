%===========================================
% 
%===========================================

function [SHIM,err] = B0ShimHead_v1b_Func(SHIM,INPUT)

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

%---------------------------------------------
% Test Compare Image With Calibration
%---------------------------------------------
CalReconPars = CAL.ReconPars(1);
%if CalReconPars.orp ~= ReconPars.orp || not(strcmp(CalReconPars.ornt,ReconPars.ornt))
%    error();       % sould always be oriented in proper manner (i.e. so that plotting function produces appropriate orientation)
%end
if CalReconPars.ImvoxLR ~= ReconPars.ImvoxLR || ...
   CalReconPars.ImvoxTB ~= ReconPars.ImvoxTB || ...
   CalReconPars.ImvoxIO ~= ReconPars.ImvoxIO
        error();    % not finished
end
if CalReconPars.ImszLR ~= ReconPars.ImszLR || ...
   CalReconPars.ImszTB ~= ReconPars.ImszTB || ...
   CalReconPars.ImszIO ~= ReconPars.ImszIO
        sz = size(Im);
        ImNew = zeros(CalReconPars.ImszLR,CalReconPars.ImszTB,CalReconPars.ImszIO,sz(4),sz(5));       
        bLR = abs((CalReconPars.ImszLR - ReconPars.ImszLR)/2)+1;
        tLR = CalReconPars.ImszLR - abs((CalReconPars.ImszLR - ReconPars.ImszLR)/2);
        if rem(bLR,1)
            error();  % not finished
        end
        bTB = abs((CalReconPars.ImszTB - ReconPars.ImszTB)/2)+1;
        tTB = CalReconPars.ImszTB - abs((CalReconPars.ImszTB - ReconPars.ImszTB)/2);
        if rem(bTB,1)
            error();  % not finished
        end
        bIO = abs((CalReconPars.ImszIO - ReconPars.ImszIO)/2)+1;
        tIO = CalReconPars.ImszIO - abs((CalReconPars.ImszIO - ReconPars.ImszIO)/2);
        if rem(bIO,1)
            error();  % not finished
        end        
        ImNew(bLR:tLR,bTB:tTB,bIO:tIO,:,:) = Im;
        Im = ImNew;
end

%---------------------------------------------
% Separate
%---------------------------------------------
Im1 = squeeze(Im(:,:,:,1,:));
Im2 = squeeze(Im(:,:,:,2,:));
Im3 = squeeze(Im(:,:,:,3,:));
TEdif1 = ExpPars.te2 - ExpPars.te1;
TEdif2 = ExpPars.te3 - ExpPars.te1;
TEorig = ExpPars.te1;

%---------------------------------------------
% Get Magnitude Image For Plotting
%---------------------------------------------
if ExpPars.nrcvrs > 1
    sz = size(Im1);
    if sz(4) < ExpPars.nrcvrs+1
        err.flag = 1;
        err.msg = 'Reconstruct with MultiSuperAdd';
        return
    end
    AbsIm = Im1(:,:,:,ExpPars.nrcvrs+1);
else
    AbsIm = abs(Im1);
end
if strcmp(ReconPars.Filter,'None')
    [x,y,z] = size(AbsIm);
    beta = 2;
    Filt = Kaiser_v1b(x,y,z,beta,'unsym');                  
    AbsIm = abs(fftshift(fftn(ifftshift(Filt.*fftshift(ifftn(ifftshift(AbsIm)))))));   
end

%---------------------------------------------
% Magnitude Image Mask
%---------------------------------------------
MagMask = ones(size(AbsIm));
MagMask(AbsIm < 0.05*max(AbsIm(:))) = NaN;
AbsIm = AbsIm.*MagMask;

%---------------------------------------------
% Create B0 Map1
%---------------------------------------------
func = str2func([SHIM.mapfunc,'_Func']);  
INPUT.Im1 = Im1;
INPUT.Im2 = Im2;
INPUT.TEdif = TEdif1;
[MAP,err] = func(MAP,INPUT);
if err.flag
    return
end
clear INPUT;
fMap1 = MAP.fMap;

%---------------------------------------------
% Create B0 Map2
%---------------------------------------------
func = str2func([SHIM.mapfunc,'_Func']);  
INPUT.Im1 = Im1;
INPUT.Im2 = Im3;
INPUT.TEdif = TEdif2;
[MAP,err] = func(MAP,INPUT);
if err.flag
    return
end
clear INPUT;
fMap2 = MAP.fMap;

%---------------------------------------------
% Ensure Same Mask
%---------------------------------------------
fMapArr = cat(4,fMap1,fMap2);
Mask = mean(fMapArr,4);
Mask(not(isnan(Mask))) = 1;
fMap1 = fMap1.*Mask;
fMap2 = fMap2.*Mask;

%---------------------------------------------
% Mask (use fMap1)
%---------------------------------------------
func = str2func([SHIM.maskfunc,'_Func']);  
INPUT.AbsIm = AbsIm;
INPUT.fMap = fMap1;
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
Mask1 = MASK.Mask;
clear INPUT;

%---------------------------------------------
% Mask (use fMap2)
%---------------------------------------------
func = str2func([SHIM.maskfunc,'_Func']);  
INPUT.AbsIm = AbsIm;
INPUT.fMap = fMap2;
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
Mask2 = MASK.Mask;
clear INPUT;

%---------------------------------------------
% Combine Masks 
%---------------------------------------------
Mask = Mask1.*Mask2;

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
INPUT.Im = fMap2.*Mask;
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
INPUT.fMap = 0;
INPUT.fMap1 = fMap1;
INPUT.fMap2 = fMap2;
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
SHIM.fMap1 = fMap1;
SHIM.fMap2 = fMap2;
SHIM.fMap = fMap2;
SHIM.Prof = Prof;
SHIM.Mask = Mask;
SHIM.MagMask = MagMask;
SHIM.AbsIm = AbsIm;
SHIM.SCRPTipt = SCRPTipt;

Status2('done','',2);
Status2('done','',3);

