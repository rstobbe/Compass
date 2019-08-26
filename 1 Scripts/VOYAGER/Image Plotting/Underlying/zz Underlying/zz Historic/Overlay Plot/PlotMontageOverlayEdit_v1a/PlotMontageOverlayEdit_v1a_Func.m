%=========================================================
% 
%=========================================================

function [PLOT,err] = PlotMontageOverlayEdit_v1a_Func(PLOT,INPUT)

Status2('busy','Plot Montage Overlay',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%----------------------------------------------
% Get input
%----------------------------------------------
Image = INPUT.Image;
intensity = PLOT.intensity;
ncolumns = PLOT.ncolumns;
imsize = PLOT.imsize;
figno = PLOT.figno;
slclbl = PLOT.slclbl;
MSTRCT = INPUT.MSTRCT;
clear INPUT
Im1 = squeeze(Image(:,:,:,1));
Im2 = squeeze(Image(:,:,:,2));

%---------------------------------------------
% Figsize
%---------------------------------------------
if isempty(imsize)
    figsize = [];
else
    inds = strfind(imsize,',');
    hsz = str2double(imsize(1:inds(1)-1));
    vsz = str2double(imsize(inds(1)+1:length(imsize)));
    figsize = [hsz vsz];
end

%---------------------------------------------
% Determine Slice Label
%---------------------------------------------
if strcmp(slclbl,'Yes')
    slclbl = 1;
else
    slclbl = 0;
end

%---------------------------------------------
% Test
%---------------------------------------------
test = (MSTRCT.start:MSTRCT.step:MSTRCT.stop);
if length(test) < ncolumns;
    ncolumns = length(test);
end

%---------------------------------------------
% Determine Figure
%---------------------------------------------
if strcmp(figno,'Continue')
    fighand = figure;
else
    fighand = str2double(figno);
end 

%---------------------------------------------
% Display ColorBar
%---------------------------------------------
IMSTRCT.type = 'real'; IMSTRCT.start = MSTRCT.start; IMSTRCT.step = MSTRCT.step; IMSTRCT.stop = MSTRCT.stop; 
IMSTRCT.rows = ncolumns; IMSTRCT.lvl = [MSTRCT.dispwid2(1) MSTRCT.dispwid2(2)]; IMSTRCT.SLab = slclbl; IMSTRCT.figno = fighand; 
IMSTRCT.docolor = 1; IMSTRCT.ColorMap = 'ColorMap5'; IMSTRCT.figsize = figsize;
[h3,ImSz] = ImageMontage_v1a(Im2,IMSTRCT);    
set(h3,'alphadata',zeros(ImSz));

%---------------------------------------------
% Display Abs Image
%---------------------------------------------
IMSTRCT.type = 'real'; IMSTRCT.start = MSTRCT.start; IMSTRCT.step = MSTRCT.step; IMSTRCT.stop = MSTRCT.stop; 
IMSTRCT.rows = ncolumns; IMSTRCT.lvl = [MSTRCT.dispwid1(1) MSTRCT.dispwid1(2)]; IMSTRCT.SLab = slclbl; IMSTRCT.figno = fighand; 
IMSTRCT.docolor = 0; IMSTRCT.ColorMap = 'ColorMap5'; IMSTRCT.figsize = figsize;
[h1,ImSz] = ImageMontageRGB_v1a(Im1,IMSTRCT);

%---------------------------------------------
% Display Map Image
%---------------------------------------------
IMSTRCT.type = 'real'; IMSTRCT.start = MSTRCT.start; IMSTRCT.step = MSTRCT.step; IMSTRCT.stop = MSTRCT.stop; 
IMSTRCT.rows = ncolumns; IMSTRCT.lvl = [MSTRCT.dispwid2(1) MSTRCT.dispwid2(2)]; IMSTRCT.SLab = slclbl; IMSTRCT.figno = fighand; 
IMSTRCT.docolor = 1; IMSTRCT.ColorMap = 'ColorMap5'; IMSTRCT.figsize = figsize;
[h2,ImSz] = ImageMontageRGB_v1a(Im2,IMSTRCT);

%---------------------------------------------
% Mask and Scale
%---------------------------------------------
if strcmp(intensity,'Scaled')
    IMSTRCT.type = 'real'; IMSTRCT.start = MSTRCT.start; IMSTRCT.step = MSTRCT.step; IMSTRCT.stop = MSTRCT.stop;  
    [iMask,~] = ImageMontageSetup_v1a(Im1/max(abs(Im1(:))),IMSTRCT);
    Mask = iMask;
elseif strcmp(intensity,'Flat100')
    Mask = ones(ImSz);
elseif strcmp(intensity,'Flat50')
    Mask = 0.5*ones(ImSz);
elseif strcmp(intensity,'Flat25')
    Mask = 0.25*ones(ImSz);
end 
IMSTRCT.type = 'real'; IMSTRCT.start = MSTRCT.start; IMSTRCT.step = MSTRCT.step; IMSTRCT.stop = MSTRCT.stop;   
[fMask,~] = ImageMontageSetup_v1a(Im2,IMSTRCT);
Mask(isnan(fMask)) = 0;
set(h2,'alphadata',Mask);               

%---------------------------------------------
% Return
%---------------------------------------------
Status2('done','',2);
Status2('done','',3);