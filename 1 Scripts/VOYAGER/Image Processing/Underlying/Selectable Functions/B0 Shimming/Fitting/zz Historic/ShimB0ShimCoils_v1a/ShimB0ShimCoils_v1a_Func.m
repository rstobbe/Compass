%===========================================
% 
%===========================================

function [B0SHIM,err] = ShimB0ShimCoils_v1a_Func(B0SHIM,INPUT)

Status2('busy','B0 Shim',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%--------------------------------------------- 
Im10 = INPUT.Im1;
Im20 = INPUT.Im2;
TEdif = INPUT.TEdif;
FIT = B0SHIM.FIT;
mval = B0SHIM.dispwid;
clear INPUT;

[x,y,z,nrcvrs] = size(Im10); 
fMapArr = zeros(size(Im10));
for n = 1:nrcvrs
    Im1 = Im10(:,:,:,n);
    Im2 = Im20(:,:,:,n);
    
    %---------------------------------------------
    % Mask
    %---------------------------------------------
    mask = abs(Im1)/max(abs(Im1(:)));
    mask(mask < B0SHIM.threshold) = NaN;
    mask(mask >= B0SHIM.threshold) = 1;

    %---------------------------------------------
    % Create Offset Map
    %---------------------------------------------
    phIm1 = angle(Im1);
    phIm2 = angle(Im2);
    dphIm = phIm2 - phIm1;
    dphIm(dphIm > pi) = dphIm(dphIm > pi) - 2*pi;
    dphIm(dphIm < -pi) = dphIm(dphIm < -pi) + 2*pi;
    fMap = 1000*(dphIm/(2*pi))/TEdif;
    fMap = fMap.*mask;
    
    fMapArr(:,:,:,n) = fMap;   
end

%---------------------------------------------
% Average
%---------------------------------------------
fMap = mean(fMapArr,4);
mask = ones(size(fMap));
mask(isnan(fMap)) = NaN;

%---------------------------------------------
% Display
%---------------------------------------------
sz = size(fMap);
%maxval = max(abs(fMap(:)));
maxval = mval;
if strcmp(B0SHIM.visuals,'Yes')
    fMapS = permute(fMap,[1 3 2]);
    IMSTRCT.type = 'real'; IMSTRCT.start = 1; IMSTRCT.step = 1; IMSTRCT.stop = sz(3); 
    IMSTRCT.rows = floor(sqrt(sz(3))+2); IMSTRCT.lvl = [-maxval maxval]; IMSTRCT.SLab = 1; IMSTRCT.figno = 1000; 
    IMSTRCT.docolor = 1; IMSTRCT.ColorMap = 'ColorMap4'; IMSTRCT.figsize = [500 400];
    %ImageMontage_v2b(fMap,IMSTRCT);
    AxialMontage_v2a(fMapS,IMSTRCT);
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
INPUT.CalData = B0SHIM.CalData;
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
Prof = Prof.*mask;

%---------------------------------------------
% Display
%---------------------------------------------
%if strcmp(B0SHIM.visuals,'Yes')
%    IMSTRCT.type = 'real'; IMSTRCT.start = 1; IMSTRCT.step = 1; IMSTRCT.stop = sz(3); 
%    IMSTRCT.rows = floor(sqrt(sz(3))+1); IMSTRCT.lvl = [-mval mval]; IMSTRCT.SLab = 0; IMSTRCT.figno = 1001; 
%    IMSTRCT.docolor = 1; IMSTRCT.ColorMap = 'ColorMap4'; IMSTRCT.figsize = [700 500];
%    ImageMontage_v2b(Prof,IMSTRCT);
%end

%---------------------------------------------
% Test Possible Correction
%---------------------------------------------
fMapC = fMap - Prof;

%---------------------------------------------
% Display
%---------------------------------------------
if strcmp(B0SHIM.visuals,'Yes')
    fMapCS = permute(fMapC,[1 3 2]);
    IMSTRCT.type = 'real'; IMSTRCT.start = 1; IMSTRCT.step = 1; IMSTRCT.stop = sz(3); 
    IMSTRCT.rows = floor(sqrt(sz(3))+2); IMSTRCT.lvl = [-mval mval]; IMSTRCT.SLab = 1; IMSTRCT.figno = 1001; 
    IMSTRCT.docolor = 1; IMSTRCT.ColorMap = 'ColorMap4'; IMSTRCT.figsize = [500 400];
    AxialMontage_v2a(fMapCS,IMSTRCT);
    %ImageMontage_v2b(fMapC,IMSTRCT);
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
B0SHIM.V = -V;
B0SHIM.fMapC = fMapC;
B0SHIM.fMap0 = fMap;

Status2('done','',2);
Status2('done','',3);

