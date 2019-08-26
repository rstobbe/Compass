%===========================================
% 
%===========================================

function [B0MAP,err] = CreateB0Map_v1a_Func(B0MAP,INPUT)

Status2('busy','B0 Map',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%--------------------------------------------- 
Im10 = INPUT.Im1;
Im20 = INPUT.Im2;
TEdif = INPUT.TEdif;
clear INPUT;

%---------------------------------------------
% receiver check
%--------------------------------------------- 
[x,y,z,nrcvrs] = size(Im10); 
fMapArr = zeros(size(Im10));
for n = 1:nrcvrs
    Im1 = Im10(:,:,:,n);
    Im2 = Im20(:,:,:,n);
    
    %---------------------------------------------
    % Mask
    %---------------------------------------------
    mask = abs(Im1)/max(abs(Im1(:)));
    mask(mask < B0MAP.threshold) = NaN;
    mask(mask >= B0MAP.threshold) = 1;

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
    %fMap(:,:,90:128) = NaN;

    %---------------------------------------------
    % Display
    %---------------------------------------------
    sz = size(Im1);
    IMSTRCT.type = 'real'; IMSTRCT.start = 1; IMSTRCT.step = 1; IMSTRCT.stop = sz(3); 
    IMSTRCT.rows = floor(sqrt(sz(3))+1); IMSTRCT.lvl = [-B0MAP.maxdisplay B0MAP.maxdisplay]; IMSTRCT.SLab = 0; IMSTRCT.figno = 1000+n; 
    IMSTRCT.docolor = 1; IMSTRCT.ColorMap = 'ColorMap4'; IMSTRCT.figsize = [700 500];
    AxialMontage_v2a(fMap,IMSTRCT);

    %---------------------------------------------
    % Histogram
    %---------------------------------------------
    test = fMap(:);
    test = test(not(isnan(test)));
    test = test(abs(test) < B0MAP.maxdisplay);
    figure(2000); hold on;
    [nels,cens] = hist(test,1000);
    %plot(cens,nels);
    nels = smooth(nels,5,'moving');
    plot(cens,nels);
    xlabel('Off Resonance (Hz)'); ylabel('Voxels');

    fMapArr(:,:,:,n) = fMap;   
end

%---------------------------------------------
% Average
%---------------------------------------------
fMap = mean(fMapArr,4);

%---------------------------------------------
% Plot
%---------------------------------------------
IMSTRCT.type = 'real'; IMSTRCT.start = 1; IMSTRCT.step = 1; IMSTRCT.stop = sz(3); 
IMSTRCT.rows = floor(sqrt(sz(3))+1); IMSTRCT.lvl = [-B0MAP.maxdisplay B0MAP.maxdisplay]; IMSTRCT.SLab = 0; IMSTRCT.figno = 3000; 
IMSTRCT.docolor = 1; IMSTRCT.ColorMap = 'ColorMap4'; IMSTRCT.figsize = [];
AxialMontage_v2a(fMap,IMSTRCT);

%---------------------------------------------
% Histogram
%---------------------------------------------
test = fMap(:);
test = test(not(isnan(test)));
test = test(abs(test) < B0MAP.maxdisplay);
figure(2000); hold on;
[nels,cens] = hist(test,1000);
%plot(cens,nels);
nels = smooth(nels,5,'moving');
plot(cens,nels,'r');
xlabel('Off Resonance (Hz)'); ylabel('Voxels');

%---------------------------------------------
% Calcs
%---------------------------------------------
meanoff = mean(test);
stdev = std(test);
rmsval = rms(test);
maxoff = max(abs(test));

%--------------------------------------------
% Panel
%--------------------------------------------
Panel(1,:) = {'mean (Hz)',meanoff,'Output'};
Panel(2,:) = {'stdev (Hz)',stdev,'Output'};
Panel(3,:) = {'rmsval (Hz)',rmsval,'Output'};
Panel(4,:) = {'maxoff (Hz)',maxoff,'Output'};
PanelOutput = cell2struct(Panel,{'label','value','type'},2);

%---------------------------------------------
% Return
%--------------------------------------------- 
B0MAP.Im = fMap;
B0MAP.rmsval = rmsval;
B0MAP.maxoff = maxoff;
B0MAP.PanelOutput = PanelOutput;

Status2('done','',2);
Status2('done','',3);

