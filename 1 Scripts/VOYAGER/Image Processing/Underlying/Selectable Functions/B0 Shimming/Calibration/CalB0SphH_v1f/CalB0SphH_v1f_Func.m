%===========================================
% 
%===========================================

function [CALB0SHIM,err] = CalB0SphH_v1f_Func(CALB0SHIM,INPUT)

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
INPUT.Im1 = squeeze(Im{1}(:,:,:,1,:));
INPUT.Im2 = squeeze(Im{1}(:,:,:,2,:));
INPUT.TEdif = TEdif;
[MAP,err] = func(MAP,INPUT);
if err.flag
    return
end
clear INPUT;
Base_fMap = -MAP.fMap;                  % account negative rotation
%Base_B0Map = -MAP.fMap/42.577;         % fix      

%---------------------------------------------
% Max Frequency Supported
%---------------------------------------------
maxfreq = round(1000/(TEdif*2));
if CALB0SHIM.maxoff > maxfreq
    err.flag = 1;
    err.msg = 'MaxOffRes selection not supported by TE';
    return
end

%---------------------------------------------
% Create Base Offres Mask
%---------------------------------------------
Mask = ones(size(Base_fMap));
Mask(abs(Base_fMap) > CALB0SHIM.maxoff) = NaN; 

%---------------------------------------------
% Display
%---------------------------------------------
showbase = 1;
if showbase == 1
    func = str2func([CALB0SHIM.dispfunc,'_Func']);  
    INPUT.Im = cat(4,ImBase,Base_fMap);
    INPUT.Name = 'Base Image Frequency Map';
    [DISP,err] = func(DISP,INPUT);
    if err.flag
        return
    end
    clear INPUT;
end
cont = questdlg('Continue');
if not(strcmp(cont,'Yes'));
    return
end

%---------------------------------------------
% Apply
%---------------------------------------------
fBMap = Base_fMap.*Mask;

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
    INPUT.Im = cat(4,ImBase,fMap);
    INPUT.Name = ['Shim Difference Image ',num2str(n)];
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
    displayresidual = 1;
    if displayresidual == 1
        func = str2func([CALB0SHIM.dispfunc,'_Func']);  
        INPUT.Im = cat(4,ImBase,fMap-Prof);
        DPROPS.scale = [-5,5]; 
        DPROPS.figno = 5000;
        INPUT.DPROPS = DPROPS;
        INPUT.Name = ['Regression Residual ',num2str(n)];
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

    cont = questdlg('Continue');
    if not(strcmp(cont,'Yes'));
        return
    end
end

%---------------------------------------------
% Return
%---------------------------------------------
CALB0SHIM.V = V;
CALB0SHIM.FIT = FIT;
CALB0SHIM.CalData = CalData;

Status2('done','',2);
Status2('done','',3);

