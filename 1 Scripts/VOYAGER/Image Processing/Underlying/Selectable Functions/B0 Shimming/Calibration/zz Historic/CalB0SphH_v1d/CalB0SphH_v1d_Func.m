%===========================================
% 
%===========================================

function [B0SHIM,err] = CalB0SphH_v1d_Func(B0SHIM,INPUT)

Status2('busy','Shim Coil Calibration',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%--------------------------------------------- 
AbsIm = INPUT.AbsIm;
ImBase = INPUT.ImBase;
Im = INPUT.Im;
TEdif = INPUT.TEdif;
ReconPars = INPUT.ReconPars;
FIT = B0SHIM.FIT;
MAP = B0SHIM.MAP;
DISP = B0SHIM.DISP;
clear INPUT;

%---------------------------------------------
% Calibration Start
%---------------------------------------------
CalData(1).Shim = 'tof';
CalData(1).CalVal = 1;
CalData(1).SphWgts = [1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];

%---------------------------------------------
% Create Base B0 Map
%--------------------------------------------- 
func = str2func([B0SHIM.mapfunc,'_Func']);  
INPUT.Im1 = squeeze(ImBase(:,:,:,1,:));
INPUT.Im2 = squeeze(ImBase(:,:,:,2,:));
INPUT.ReconPars = ReconPars;
INPUT.TEdif = TEdif;
[MAP,err] = func(MAP,INPUT);
if err.flag
    return
end
clear INPUT;
fBMap = MAP.fMap;

%---------------------------------------------
% Create Base Offres Mask
%---------------------------------------------
Mask = ones(size(fBMap));
Mask(abs(fBMap) > B0SHIM.maxoff) = NaN; 

%---------------------------------------------
% Display
%---------------------------------------------
showbase = 0;
if showbase == 1
    func = str2func([B0SHIM.dispfunc,'_Func']);  
    INPUT.AbsIm = AbsIm;
    INPUT.fMap = fBMap;
    INPUT.Mask = Mask;
    INPUT.Prof = [];
    [DISP,err] = func(DISP,INPUT);
    if err.flag
        return
    end
    clear INPUT;
end

%---------------------------------------------
% Apply
%---------------------------------------------
fBMap = fBMap.*Mask;

%======================================================
% Regress Difference Images
%======================================================
for n = 2:length(Im)

    %---------------------------------------------
    % B0Map
    %---------------------------------------------
    func = str2func([B0SHIM.mapfunc,'_Func']);     
    ImV = Im{n};
    INPUT.Im1 = squeeze(ImV(:,:,:,1,:));
    INPUT.Im2 = squeeze(ImV(:,:,:,2,:));
    INPUT.ReconPars = ReconPars;
    INPUT.TEdif = TEdif;
    [MAP,err] = func(MAP,INPUT);
    if err.flag
        return
    end
    clear INPUT;
    fVMap = MAP.fMap;

    %---------------------------------------------
    % Subtract
    %---------------------------------------------
    fMap = fVMap - fBMap;
    maxVoffres = max(abs(fVMap(:)));
    maxBoffres = max(abs(fBMap(:)));
    maxDoffres = max(abs(fMap(:)));
    B0SHIM.maxoffres(n) = max([maxVoffres maxBoffres maxDoffres]);

    %---------------------------------------------
    % Fit Spherical Harmonics
    %---------------------------------------------
    INPUT.Im = fMap;
    func = str2func([B0SHIM.fitfunc,'_Func']);
    [FIT,err] = func(FIT,INPUT);
    if err.flag
        return
    end
    clear INPUT    

    %---------------------------------------------
    % Prof
    %--------------------------------------------- 
    V = FIT.V;
    Prof = FIT.Prof;
    FIT = rmfield(FIT,'Prof');
    Prof = Prof.*Mask;

    %---------------------------------------------
    % Display
    %---------------------------------------------
    func = str2func([B0SHIM.dispfunc,'_Func']);  
    INPUT.AbsIm = AbsIm;
    INPUT.fMap = fMap;
    INPUT.Mask = [];
    INPUT.Prof = Prof;
    [DISP,err] = func(DISP,INPUT);
    if err.flag
        return
    end
    clear INPUT;

    %---------------------------------------------
    % Record
    %---------------------------------------------
    CalData(n).Shim = ReconPars(n).shimcalname;
    CalData(n).CalVal = ReconPars(n).shimcalval;
    CalData(n).SphWgts = V;
    CalData(n).resnorm = FIT.resnorm;

    figure(100+n); hold on;
    plot(CalData(n).SphWgts,'k*') 
    title(CalData(n).Shim);
end

%---------------------------------------------
% Return
%---------------------------------------------
B0SHIM.V = V;
B0SHIM.FIT = FIT;
B0SHIM.CalData = CalData;

Status2('done','',2);
Status2('done','',3);

