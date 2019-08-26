%=========================================================
% (v1e)
%       - Use Fig/Axis Handles.
%=========================================================

function [MSTRCT,err] = MaskMontageOverlay_v1e(INPUT)

err.flag = 0;
err.msg = '';

%----------------------------------------------
% Get input
%----------------------------------------------
MSTRCT = INPUT.MSTRCT;
Im1 = squeeze(INPUT.Image(:,:,:,2));
Im2 = squeeze(INPUT.Image(:,:,:,1));
clear INPUT

%---------------------------------------------
% Test
%---------------------------------------------
ncolumns = MSTRCT.ncolumns;
test = (MSTRCT.start:MSTRCT.step:MSTRCT.stop);
if length(test) < MSTRCT.ncolumns;
    ncolumns = length(test);
end
      
%---------------------------------------------
% Determine Slice Label
%---------------------------------------------
if strcmp(MSTRCT.slclbl,'Yes')
    slclbl = 1;
else
    slclbl = 0;
end

%---------------------------------------------
% General
%---------------------------------------------
IMSTRCT.start = MSTRCT.start; IMSTRCT.step = MSTRCT.step; IMSTRCT.stop = MSTRCT.stop; 
IMSTRCT.rows = ncolumns; IMSTRCT.SLab = slclbl; IMSTRCT.fhand = MSTRCT.fhand; IMSTRCT.ahand = MSTRCT.ahand; 
IMSTRCT.ColorMap = 'ColorMap5'; IMSTRCT.figsize = MSTRCT.imsize;

%---------------------------------------------
% Display Base Image
%---------------------------------------------
IMSTRCT.type = MSTRCT.type1; IMSTRCT.lvl = [MSTRCT.dispwid1(1) MSTRCT.dispwid1(2)]; IMSTRCT.docolor = 0;
[h1,ImSz] = ImageMontageRGB_v1b(Im1,IMSTRCT);

%---------------------------------------------
% Display Mask Image
%---------------------------------------------
IMSTRCT.type = 'real'; IMSTRCT.lvl = [0 2]; IMSTRCT.docolor = 1;
[h2,ImSz] = ImageMontageRGB_v1b(Im2,IMSTRCT);

%---------------------------------------------
% Mask and Scale
%---------------------------------------------
if strcmp(MSTRCT.intensity,'Scaled')
    IMSTRCT.type = MSTRCT.type2;
    [iMask,~] = ImageMontageSetup_v1b(Im1/max(abs(Im1(:))),IMSTRCT);
    Mask = iMask;
elseif strcmp(MSTRCT.intensity,'Flat100')
    Mask = ones(ImSz);
elseif strcmp(MSTRCT.intensity,'Flat75')
    Mask = 0.75*ones(ImSz);    
elseif strcmp(MSTRCT.intensity,'Flat50')
    Mask = 0.5*ones(ImSz);
elseif strcmp(MSTRCT.intensity,'Flat25')
    Mask = 0.25*ones(ImSz);
elseif strcmp(MSTRCT.intensity,'Flat10')
    Mask = 0.20*ones(ImSz);
else
    error()
end 
IMSTRCT.type = 'real'; 
[fMask,~] = ImageMontageSetup_v1b(Im2,IMSTRCT);
Mask(isnan(fMask)) = 0;
set(h2,'alphadata',Mask);              

%---------------------------------------------
% Stretch if Needed
%--------------------------------------------- 
if not(isempty(MSTRCT.ImInfo))
    DataAspectRatio = MSTRCT.ImInfo.pixdim(1:2);
    DataAspectRatio = DataAspectRatio/max(DataAspectRatio);
    MSTRCT.ahand.DataAspectRatio = [DataAspectRatio 1];
end

MSTRCT.ihand(1) = h1;
MSTRCT.ihand(2) = h2;


