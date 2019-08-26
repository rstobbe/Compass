%===========================================
% 
%===========================================

function [B0SHIM,err] = CalB0SphH_v1c_Func(B0SHIM,INPUT)

Status2('busy','Shim Coil Calibration',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%--------------------------------------------- 
ImB10 = INPUT.ImB1;
ImB20 = INPUT.ImB2;
ImV10 = INPUT.ImV1;
ImV20 = INPUT.ImV2;
TEdif = INPUT.TEdif;
FIT = B0SHIM.FIT;
clear INPUT;

%---------------------------------------------
% Create Offset Map (seperate into own callable func)
%   - see liturature for multiple receivers and fix up
%--------------------------------------------- 
[x,y,z,nrcvrs] = size(ImB10); 
fMapArr = zeros(size(ImB10));
for n = 1:nrcvrs
    ImB1 = ImB10(:,:,:,n);
    ImB2 = ImB20(:,:,:,n);
    ImV1 = ImV10(:,:,:,n);
    ImV2 = ImV20(:,:,:,n); 
    
    %---------------------------------------------
    % Mask
    %---------------------------------------------
    mask = abs(ImB1)/max(abs(ImB1(:)));
    mask(mask < B0SHIM.threshold) = NaN;
    mask(mask >= B0SHIM.threshold) = 1;

    %---------------------------------------------
    % Create Offset Map
    %---------------------------------------------
    phImB1 = angle(ImB1);
    phImB2 = angle(ImB2);
    phImV1 = angle(ImV1);
    phImV2 = angle(ImV2);    
    dphBIm = phImB2 - phImB1;
    dphBIm(dphBIm > pi) = dphBIm(dphBIm > pi) - 2*pi;
    dphBIm(dphBIm < -pi) = dphBIm(dphBIm < -pi) + 2*pi;
    fBMap = 1000*(dphBIm/(2*pi))/TEdif;
    fBMap = fBMap.*mask;
    fBMapArr(:,:,:,n) = fBMap; 
    dphVIm = phImV2 - phImV1;
    dphVIm(dphVIm > pi) = dphVIm(dphVIm > pi) - 2*pi;
    dphVIm(dphVIm < -pi) = dphVIm(dphVIm < -pi) + 2*pi;
    fVMap = 1000*(dphVIm/(2*pi))/TEdif;
    fVMap = fVMap.*mask;
    fVMapArr(:,:,:,n) = fVMap;   
end

%---------------------------------------------
% Average
%---------------------------------------------
fBMap = mean(fBMapArr,4);
fVMap = mean(fVMapArr,4);

%---------------------------------------------
% Base Offres Mask
%---------------------------------------------
mask(abs(fBMap) > B0SHIM.maxoff) = NaN; 
fBMap = fBMap.*mask;
fVMap = fVMap.*mask;

%---------------------------------------------
% Subtract
%---------------------------------------------
fMap = fVMap - fBMap;
maxVoffres = max(abs(fVMap(:)));
maxBoffres = max(abs(fBMap(:)));
maxDoffres = max(abs(fMap(:)));
maxoffres = max([maxVoffres maxBoffres maxDoffres]);

%---------------------------------------------
% Display
%---------------------------------------------
showbase = 0;
if showbase == 1
    %mval = max(abs(fBMap(:)));
    sz = size(fBMap);
    if strcmp(B0SHIM.visuals,'Yes')
        IMSTRCT.type = 'real'; IMSTRCT.start = 1; IMSTRCT.step = 1; IMSTRCT.stop = sz(3); 
        IMSTRCT.rows = floor(sqrt(sz(3))+1); IMSTRCT.lvl = [-mval mval]; IMSTRCT.SLab = 0; IMSTRCT.figno = 10; 
        IMSTRCT.docolor = 1; IMSTRCT.ColorMap = 'ColorMap4'; IMSTRCT.figsize = [700 500];
        AxialMontage_v2a(fBMap,IMSTRCT);
    end
end

%---------------------------------------------
% Display
%---------------------------------------------
if strcmp(B0SHIM.visuals,'Yes')
    mval = max(abs(fMap(:)));
    sz = size(fMap);
    IMSTRCT.type = 'real'; IMSTRCT.start = 1; IMSTRCT.step = 1; IMSTRCT.stop = sz(3); 
    IMSTRCT.rows = floor(sqrt(sz(3))+1); IMSTRCT.lvl = [-mval mval]; IMSTRCT.SLab = 0; IMSTRCT.figno = 1000; 
    IMSTRCT.docolor = 1; IMSTRCT.ColorMap = 'ColorMap4'; IMSTRCT.figsize = [700 500];
    AxialMontage_v2a(fMap,IMSTRCT);
end

%---------------------------------------------
% Histogram
%---------------------------------------------
test = fMap(:);
test = test(not(isnan(test)));
figure(2000); hold on;
[nels,cens] = hist(test,1000);
%plot(cens,nels);
nels = smooth(nels,5,'moving');
plot(cens,nels);
xlabel('Off Resonance (Hz)'); ylabel('Voxels');

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
V = FIT.V
Prof = FIT.Prof;
FIT = rmfield(FIT,'Prof');
Prof = Prof.*mask;

%---------------------------------------------
% Display
%---------------------------------------------
if strcmp(B0SHIM.visuals,'Yes')
    mval = max(abs(fMap(:)));
    IMSTRCT.type = 'real'; IMSTRCT.start = 1; IMSTRCT.step = 1; IMSTRCT.stop = sz(3); 
    IMSTRCT.rows = floor(sqrt(sz(3))+1); IMSTRCT.lvl = [-mval mval]; IMSTRCT.SLab = 0; IMSTRCT.figno = 1001; 
    IMSTRCT.docolor = 1; IMSTRCT.ColorMap = 'ColorMap4'; IMSTRCT.figsize = [700 500];
    AxialMontage_v2a(Prof,IMSTRCT);
end

%---------------------------------------------
% Test Possible Correction
%---------------------------------------------
fMapC = fMap - Prof;

%---------------------------------------------
% Display
%---------------------------------------------
if strcmp(B0SHIM.visuals,'Yes')
    mval = 10;
    IMSTRCT.type = 'real'; IMSTRCT.start = 1; IMSTRCT.step = 1; IMSTRCT.stop = sz(3); 
    IMSTRCT.rows = floor(sqrt(sz(3))+1); IMSTRCT.lvl = [-10 10]; IMSTRCT.SLab = 0; IMSTRCT.figno = 1002; 
    IMSTRCT.docolor = 1; IMSTRCT.ColorMap = 'ColorMap4'; IMSTRCT.figsize = [700 500];
    AxialMontage_v2a(fMapC,IMSTRCT);
end

%---------------------------------------------
% Histogram
%---------------------------------------------
test = fMapC(:);
test = test(not(isnan(test)));
figure(2000); hold on;
[nels,cens] = hist(test,1000);
%plot(cens,nels);
nels = smooth(nels,5,'moving');
plot(cens,nels,'r');
xlabel('Off Resonance (Hz)'); ylabel('Voxels');

%---------------------------------------------
% Return
%---------------------------------------------
B0SHIM.V = V;
B0SHIM.FIT = FIT;
B0SHIM.maxoffres = maxoffres;

Status2('done','',2);
Status2('done','',3);

