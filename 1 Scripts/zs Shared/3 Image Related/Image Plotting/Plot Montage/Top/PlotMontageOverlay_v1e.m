%=========================================================
% (v1e)
%       - Use Fig/Axis Handles.
%=========================================================

function [Img,err] = PlotMontageOverlay_v1e(INPUT)

err.flag = 0;
err.msg = '';

%----------------------------------------------
% Get input
%----------------------------------------------
MSTRCT = INPUT.MSTRCT;
Im2 = squeeze(INPUT.Image(:,:,:,2));
Im1 = squeeze(INPUT.Image(:,:,:,1));
clear INPUT

%---------------------------------------------
% Test
%---------------------------------------------
if not(isfield(MSTRCT,'fhand'))
    MSTRCT.fhand = figure;
end
if not(isfield(MSTRCT,'ahand'))
    MSTRCT.ahand = axes('parent',MSTRCT.fhand);
    MSTRCT.ahand.Position = [0,0,1,1];
end
if not(isfield(MSTRCT,'type1'))
    MSTRCT.type1 = 'abs';
end
if not(isfield(MSTRCT,'dispwid1'))
    MSTRCT.dispwid1 = [0 max(abs(Im1(:)))];
end
if not(isfield(MSTRCT,'type2'))
    MSTRCT.type2 = 'real';
end
if not(isfield(MSTRCT,'dispwid2'))
    MSTRCT.dispwid2 = [-max(abs(Im2(:))) max(abs(Im2(:)))];
end
if not(isfield(MSTRCT,'intensity'))
    MSTRCT.intensity = 'Flat50';
end
ncolumns = MSTRCT.ncolumns;
test = (MSTRCT.start:MSTRCT.step:MSTRCT.stop);
if length(test) < MSTRCT.ncolumns
    ncolumns = length(test);
end
if not(isfield(MSTRCT,'scale'))
    MSTRCT.scale = 'auto';
end
if not(isfield(MSTRCT,'zero2'))
    MSTRCT.zero2 = 'black';
end

%---------------------------------------------
% Zeros
%---------------------------------------------
if strcmp(MSTRCT.zero2,'black')
    Im2(Im2 == 0) = NaN;
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
IMSTRCT.rows = ncolumns; IMSTRCT.SLab = slclbl; IMSTRCT.fhand = MSTRCT.fhand; IMSTRCT.ahand = MSTRCT.ahand; IMSTRCT.lblvals = MSTRCT.lblvals; 
IMSTRCT.ColorMap = 'ColorMap5'; IMSTRCT.figsize = MSTRCT.imsize;

%---------------------------------------------
% Display ColorBar
%---------------------------------------------
IMSTRCT.type = MSTRCT.type2; IMSTRCT.lvl = [MSTRCT.dispwid2(1) MSTRCT.dispwid2(2)]; IMSTRCT.docolor = 1; 
[h3,ImSz,Img] = ImageMontage_v2b(Im2,IMSTRCT);    
set(h3.ihand,'alphadata',zeros(ImSz));
IMSTRCT.ahand = h3.ahand;
IMSTRCT.fhand = h3.fhand;

%---------------------------------------------
% Display Base Image
%---------------------------------------------
IMSTRCT.type = MSTRCT.type1; IMSTRCT.lvl = [MSTRCT.dispwid1(1) MSTRCT.dispwid1(2)]; IMSTRCT.docolor = 0;
[h1,ImSz] = ImageMontageRGB_v1b(Im1,IMSTRCT);

%---------------------------------------------
% Display Map Image
%---------------------------------------------
IMSTRCT.type = MSTRCT.type2; IMSTRCT.lvl = [MSTRCT.dispwid2(1) MSTRCT.dispwid2(2)]; IMSTRCT.docolor = 1;
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
    Mask = 0.10*ones(ImSz);
elseif strcmp(MSTRCT.intensity,'Flat5')
    Mask = 0.05*ones(ImSz);
elseif strcmp(MSTRCT.intensity,'Flat0')
    Mask = 0*ones(ImSz);
else
    error()
end 
IMSTRCT.type = MSTRCT.type2; 
[fMask,~] = ImageMontageSetup_v1b(Im2,IMSTRCT);
Mask(isnan(fMask)) = 0;
set(h2,'alphadata',Mask);              

%---------------------------------------------
% Stretch if Needed
%--------------------------------------------- 
DataAspectRatio = MSTRCT.ImInfo.pixdim(1:2);
DataAspectRatio = DataAspectRatio/max(DataAspectRatio);
DataAspectRatio = round(DataAspectRatio*200)/200;             % get rid of potential tiny differences in Siemens images 
IMSTRCT.ahand.DataAspectRatio = [DataAspectRatio 1];
figdims = DataAspectRatio.*ImSz;
if strcmp(MSTRCT.scale,'auto')
    scale1 = ceil(1000/figdims(1));
    scale2 = ceil(600/figdims(2));
    scale = min([scale1 scale2]);
else
    scale = str2double(MSTRCT.scale);
end   
figdims = figdims*scale;
figdims(1) =  figdims(1)*1.05; 
%--
if strcmp(IMSTRCT.fhand.Type,'figure')
    truesize(IMSTRCT.fhand,figdims);
end
%--

