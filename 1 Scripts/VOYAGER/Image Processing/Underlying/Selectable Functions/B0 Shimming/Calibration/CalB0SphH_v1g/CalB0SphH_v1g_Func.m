%===========================================
% 
%===========================================

function [CALB0SHIM,err] = CalB0SphH_v1g_Func(CALB0SHIM,INPUT)

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
IMDISP = INPUT.IMDISP;
clear INPUT;

%---------------------------------------------
% Calibration Start
%---------------------------------------------
CalData(1).Shim = 'tof';
CalData(1).CalVal = 1;
%---    
CalData(1).SphWgts = zeros(size(ShimCalPars));                  % fix - needs to be number of spherical harmonics used
%---
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
% Apply
%---------------------------------------------
fBMap = Base_fMap.*Mask;

%---------------------------------------------
% Display Base
%---------------------------------------------
INPUT.numberslices = 16;
INPUT.Image = cat(4,fBMap,ImBase);
INPUT.MSTRCT.ImInfo = IMDISP.ImInfo;
[MCHRS,err] = DefaultMontageChars_v1a(INPUT);
if err.flag
    return
end
MCHRS.MSTRCT.fhand = figure;
INPUT = MCHRS;
INPUT.Name = 'Base Image Frequency Map';
[MOF,err] = B0mapOverlayWithHist_v1a(INPUT);
truesize(MCHRS.MSTRCT.fhand,[500 500]);
cont = questdlg('Continue');
if not(strcmp(cont,'Yes'));
    err.flag = 4;
    return
end


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
    INPUT.numberslices = 15;
    INPUT.Image = cat(4,fMap,fMap-Prof,ImBase);
    INPUT.MSTRCT.ImInfo = IMDISP.ImInfo;
    [MCHRS,err] = DefaultMontageChars_v1a(INPUT);
    if err.flag
        return
    end
    MCHRS.MSTRCT.fhand = figure;
    INPUT = MCHRS;
    INPUT.Name1 = ['Shim Difference ',num2str(n)];
    INPUT.Name2 = ['Regression Residual ',num2str(n)];
    [MOF,err] = ShimMapOverlayWithHist_v1a(INPUT);
    truesize(MCHRS.MSTRCT.fhand,[350 700]);
    if err.flag
        return
    end
    clear INPUT;
    
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

