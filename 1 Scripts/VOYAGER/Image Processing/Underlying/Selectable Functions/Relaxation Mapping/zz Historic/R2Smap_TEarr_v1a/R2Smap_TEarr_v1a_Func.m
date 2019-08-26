%====================================================
%  
%====================================================

function [MAP,err] = R2Smap_TEarr_v1a_Func(MAP,INPUT)

Status2('busy','Generate R2Smap (TE array)',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
IMG = INPUT.IM0;
Im = abs(IMG.Im);
ExpPars = IMG.ExpPars;
visuals = INPUT.visuals;
CALC = MAP.CALC;
clear INPUT;

%---------------------------------------------
% Get TE
%---------------------------------------------
TEarr = ExpPars.te;

%---------------------------------------------
% Background Mask
%---------------------------------------------
[nx,ny,nz,nexp] = size(Im);
Im1 = squeeze(Im(:,:,:,1));
mask1 = ones(size(Im1));
aveval = mean(mean(mean(Im1(nx/2-nx/4:nx/2+nx/4,ny/2-ny/4:ny/2+ny/4,nz/2-nz/4:nz/2+nz/4))));
mask1(Im1 < aveval*MAP.MV) = 0;

%---------------------------------------------
% CSF Mask && Skull
%---------------------------------------------
%mask2 = ones(size(Im1));
%ImN = squeeze(Im(:,:,:,nexp));
%T2Smax = 100;
%relmax = exp(-(TEarr(nexp)-TEarr(1))/T2Smax);
%mask2(ImN > Im1*relmax) = 0;
mask2 = ones(size(mask1));

%---------------------------------------------
% Mask Visualize
%---------------------------------------------
mask = mask1.*mask2;
if strcmp(visuals,'Yes')   

    sz = size(Im1);
    figno = 1000;
    %---------------------------------------------
    % Display ColorBar
    %---------------------------------------------
    IMSTRCT.type = 'real'; IMSTRCT.start = 1; IMSTRCT.step = 1; IMSTRCT.stop = nz; 
    IMSTRCT.rows = floor(sqrt(sz(3))+2); IMSTRCT.lvl = [0 1]; IMSTRCT.SLab = 0; IMSTRCT.figno = figno; 
    IMSTRCT.docolor = 1; IMSTRCT.ColorMap = 'ColorMap4'; IMSTRCT.figsize = [500 700];
    [h3,ImSz] = ImageMontage_v1a(mask,IMSTRCT);    
    set(h3,'alphadata',zeros(ImSz));
    
    %---------------------------------------------
    % Display Abs Image
    %---------------------------------------------
    IMSTRCT.type = 'abs'; IMSTRCT.start = 1; IMSTRCT.step = 1; IMSTRCT.stop = sz(3); 
    IMSTRCT.rows = floor(sqrt(sz(3))+2); IMSTRCT.lvl = [0 max(abs(Im1(:)))]; IMSTRCT.SLab = 0; IMSTRCT.figno = figno; 
    IMSTRCT.docolor = 0; IMSTRCT.ColorMap = 'ColorMap4'; IMSTRCT.figsize = [500 700];
    [h1,ImSz] = ImageMontageRGB_v1a(Im1,IMSTRCT);

    %---------------------------------------------
    % Display fMap Image
    %---------------------------------------------
    IMSTRCT.type = 'real'; IMSTRCT.start = 1; IMSTRCT.step = 1; IMSTRCT.stop = sz(3); 
    IMSTRCT.rows = floor(sqrt(sz(3))+2); IMSTRCT.lvl = [0 2]; IMSTRCT.SLab = 0; IMSTRCT.figno = figno; 
    IMSTRCT.docolor = 1; IMSTRCT.ColorMap = 'ColorMap4'; IMSTRCT.figsize = [500 700];
    [h2,ImSz] = ImageMontageRGB_v1a(mask,IMSTRCT);

    %---------------------------------------------
    % Mask and Scale
    %---------------------------------------------
    intensity = 'Scaled';
    if strcmp(intensity,'Scaled')
        IMSTRCT.type = 'real'; IMSTRCT.start = 1; IMSTRCT.step = 1; IMSTRCT.stop = sz(3);  
        [iMask,~] = ImageMontageSetup_v1a(Im1/max(abs(Im1(:))),IMSTRCT);
    else
        iMask = ones(ImSz);
    end 
    IMSTRCT.type = 'real'; IMSTRCT.start = 1; IMSTRCT.step = 1; IMSTRCT.stop = sz(3);  
    [NaNMask,~] = ImageMontageSetup_v1a(mask,IMSTRCT);
    iMask(isnan(NaNMask)) = 0;
    set(h2,'alphadata',iMask); 
end

%---------------------------------------------
% Runc R2Start map
%---------------------------------------------
func = str2func([MAP.calcfunc,'_Func']);  
INPUT.Im = Im;
INPUT.mask = mask;
INPUT.TEarr = TEarr;
[CALC,err] = func(CALC,INPUT);
if err.flag
    return
end
clear INPUT;

%---------------------------------------------
% Return
%---------------------------------------------
MAP.Im = CALC.Im;

Status2('done','',2);
Status2('done','',3);

