%===========================================
% 
%===========================================

function [SHIM,err] = B0Shim2TE_v1b_Func(SHIM,INPUT)

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
%ShimName = IMG.FID.shimname;
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
        if length(sz) == 4
            ImNew = zeros(CalReconPars.ImszLR,CalReconPars.ImszTB,CalReconPars.ImszIO,sz(4));
        elseif length(sz) == 5
            ImNew = zeros(CalReconPars.ImszLR,CalReconPars.ImszTB,CalReconPars.ImszIO,sz(4),sz(5));
        end
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
TEdif = ExpPars.te2 - ExpPars.te1;

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

%---------------------------------------------
% Plotting Image Mask
%---------------------------------------------
MagMask = ones(size(AbsIm));
MagMask(AbsIm < 0.05*max(AbsIm(:))) = NaN;
AbsIm = AbsIm.*MagMask;

%---------------------------------------------
% Create B0 Map
%---------------------------------------------
func = str2func([SHIM.mapfunc,'_Func']);  
INPUT.Im1 = Im1;
INPUT.Im2 = Im2;
INPUT.ReconPars = ReconPars;
INPUT.TEdif = TEdif;
[MAP,err] = func(MAP,INPUT);
if err.flag
    return
end
clear INPUT;
fMap = MAP.fMap;

%---------------------------------------------
% Mask
%---------------------------------------------
func = str2func([SHIM.maskfunc,'_Func']);  
INPUT.AbsIm = AbsIm;
INPUT.fMap = fMap;
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
    ShimsUsed{n} = CAL.CalData(n).Shim;
end

%---------------------------------------------
% Shim
%---------------------------------------------
func = str2func([SHIM.fitfunc,'_Func']);  
if isempty(Mask)
    INPUT.Im = fMap;
else
    INPUT.Im = fMap.*Mask;
end
INPUT.CalData = CAL.CalData;
INPUT.PrevShims = PrevShims;
INPUT.ShimsUsed = ShimsUsed;
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
% Write System Structure
%---------------------------------------------
NewShims = Shims;
for n = 1:length(CAL.CalData)
    NewShims.(CAL.CalData(n).Shim) = V(n);
end

%---------------------------------------------
% Return
%---------------------------------------------
SHIM.CalData = CAL.CalData;
SHIM.Vfit = Vfit;
SHIM.V = V;
SHIM.ShimsUsed = ShimsUsed;
SHIM.fMap = fMap;
SHIM.Prof = Prof;
SHIM.Mask = Mask;
SHIM.AbsIm = AbsIm;
SHIM.PrevShims = Shims;
SHIM.NewShims = NewShims;
SHIM.SCRPTipt = SCRPTipt;
SHIM.ShimName = ShimName;

Status2('done','',2);
Status2('done','',3);

