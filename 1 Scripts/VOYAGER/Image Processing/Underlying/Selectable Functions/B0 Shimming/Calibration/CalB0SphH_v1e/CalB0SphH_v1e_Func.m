%===========================================
% 
%===========================================

function [CALB0SHIM,err] = CalB0SphH_v1e_Func(CALB0SHIM,INPUT)

Status2('busy','Shim Coil Calibration',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%--------------------------------------------- 
ImBase = INPUT.ImBase;
Im = INPUT.Im;
TEdif = INPUT.TEdif;
ShimCalPars = INPUT.ShimCalPars;
FIT = CALB0SHIM.FIT;
MAP = CALB0SHIM.MAP;
DISP = CALB0SHIM.DISP;
clear INPUT;

%---------------------------------------------
% Calibration Start
%---------------------------------------------
CalData(1).Shim = 'tof';
CalData(1).CalVal = 1;
CalData(1).SphWgts = zeros(size(ShimCalPars));
CalData(1).SphWgts(1) = 1;

%---------------------------------------------
% Create Base B0 Map
%--------------------------------------------- 
func = str2func([CALB0SHIM.mapfunc,'_Func']);  
INPUT.Im1 = squeeze(ImBase(:,:,:,1,:));
INPUT.Im2 = squeeze(ImBase(:,:,:,2,:));
INPUT.TEdif = TEdif;
[MAP,err] = func(MAP,INPUT);
if err.flag
    return
end
clear INPUT;
fBMap = -MAP.fMap;

%---------------------------------------------
% Create Base Offres Mask
%---------------------------------------------
Mask = ones(size(fBMap));
Mask(abs(fBMap) > CALB0SHIM.maxoff) = NaN; 

%---------------------------------------------
% Max Frequency Supported
%---------------------------------------------
maxfreq = round(1000/(TEdif*2));

%---------------------------------------------
% Display
%---------------------------------------------
showbase = 1;
if showbase == 1
    func = str2func([CALB0SHIM.dispfunc,'_Func']);  
    INPUT.Im = ImBase;
    INPUT.fMap = fBMap;
    INPUT.wid = maxfreq;
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
    func = str2func([CALB0SHIM.mapfunc,'_Func']);     
    ImV = Im{n};
    INPUT.Im1 = squeeze(ImV(:,:,:,1,:));
    INPUT.Im2 = squeeze(ImV(:,:,:,2,:));
    INPUT.TEdif = TEdif;
    [MAP,err] = func(MAP,INPUT);
    if err.flag
        return
    end
    clear INPUT;
    fVMap = -MAP.fMap;

    %---------------------------------------------
    % Subtract
    %---------------------------------------------
    fMap = fVMap - fBMap;
    maxVoffres = max(abs(fVMap(:)));
    maxBoffres = max(abs(fBMap(:)));
    maxDoffres = max(abs(fMap(:)));
    CALB0SHIM.maxoffres(n) = max([maxVoffres maxBoffres maxDoffres]);

    %---------------------------------------------
    % Display
    %---------------------------------------------
    func = str2func([CALB0SHIM.dispfunc,'_Func']);  
    INPUT.Im = ImBase;
    INPUT.fMap = fMap;
    INPUT.wid = maxfreq;
    [DISP,err] = func(DISP,INPUT);
    if err.flag
        return
    end
    clear INPUT;
    
    %---------------------------------------------
    % Fit Spherical Harmonics
    %---------------------------------------------
    INPUT.Im = fMap;
    func = str2func([CALB0SHIM.fitfunc,'_Func']);
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
    displayprof = 0;
    if displayprof == 1
        func = str2func([CALB0SHIM.dispfunc,'_Func']);  
        INPUT.Im = ImBase;
        INPUT.fMap = Prof;
        INPUT.wid = maxfreq;
        [DISP,err] = func(DISP,INPUT);
        if err.flag
            return
        end
        clear INPUT;
    end
    
    %---------------------------------------------
    % Record
    %---------------------------------------------
    CalData(n).Shim = ShimCalPars(n).shimcalname;
    CalData(n).CalVal = ShimCalPars(n).shimcalval;
    CalData(n).SphWgts = V;
    CalData(n).resnorm = FIT.resnorm;

    figure(100+n); hold on;
    plot(CalData(n).SphWgts,'k*') 
    title(CalData(n).Shim);
end

%---------------------------------------------
% Return
%---------------------------------------------
CALB0SHIM.V = V;
CALB0SHIM.FIT = FIT;
CALB0SHIM.CalData = CalData;

Status2('done','',2);
Status2('done','',3);

