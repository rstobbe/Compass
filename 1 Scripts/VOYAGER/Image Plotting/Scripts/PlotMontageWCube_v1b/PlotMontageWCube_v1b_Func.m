%=========================================================
% 
%=========================================================

function [PLOT,err] = PlotMontageWCube_v1b_Func(PLOT,INPUT)

Status('busy','Plot Montage');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
IMG = INPUT.IMG;
IMSCL = INPUT.IMSCL;
clear INPUT;
Image = IMG.Im;

%---------------------------------------------
% Get Variables
%---------------------------------------------
type = PLOT.type;
orient = PLOT.orient;
rotation = PLOT.rotation;
imnum = PLOT.imnum;
slices = PLOT.slices;
insets = PLOT.insets ;   
colour = PLOT.colour;
nrows = PLOT.nRows ;
imsize = PLOT.imsize;
figno = PLOT.figno;
slclbl = PLOT.slclbl;

%---------------------------------------------
% Select Image
%---------------------------------------------
Image = squeeze(Image(:,:,:,imnum));

%---------------------------------------------
% Cube
%---------------------------------------------
dims = [5,5,5];
disp = [0,0,0];
sz = size(Image);
bot = ceil(sz/2)-floor(dims/2)+disp;
top = ceil(sz/2)+floor(dims/2)+disp;
Cube = NaN*ones(sz);
Cube(bot(1):top(1),bot(2):top(2),bot(3):top(3)) = 1;

%---------------------------------------------
% Determine Slices
%---------------------------------------------
if strcmp(slices,'All')
    start = 1;
    step = 1;
    stop = IMG.ImSz;
else
    inds = strfind(slices,':');
    if isempty(inds)
        start = str2double(slices);
        stop = str2double(slices);
        step = 1;
    else
        start = str2double(slices(1:inds(1)-1));
        step = str2double(slices(inds(1)+1:inds(2)-1));
        stop = str2double(slices(inds(2)+1:length(slices))); 
    end
end 

%---------------------------------------------
% Determine Insets
%---------------------------------------------
inds = strfind(insets,',');
A = str2double(insets(1:inds(1)-1));
P = str2double(insets(inds(1)+1:inds(2)-1));
L = str2double(insets(inds(2)+1:inds(3)-1)); 
R = str2double(insets(inds(3)+1:inds(4)-1));
T = str2double(insets(inds(4)+1:inds(5)-1)); 
B = str2double(insets(inds(5)+1:length(insets))); 

%---------------------------------------------
% Inset
%---------------------------------------------
[x,y,z] = size(Image);
Image = Image(A+1:x-P,L+1:y-R,T+1:z-B);
Cube = Cube(A+1:x-P,L+1:y-R,T+1:z-B);

%---------------------------------------------
% Orientation
%---------------------------------------------
if strcmp(orient,'Axial')
    Image = Image;
    Cube = Cube;
elseif strcmp(orient,'Coronal')
    Image = permute(Image,[3 2 1]);
    Cube = permute(Cube,[3 2 1]);
elseif strcmp(orient,'Sagittal')    
    Image = permute(Image,[3 1 2]);
    Cube = permute(Cube,[3 1 2]);
end

%---------------------------------------------
% Rotate
%---------------------------------------------
if strcmp(rotation,'90')
    Image = permute(Image,[2 1 3]);
    Cube = permute(Cube,[2 1 3]);
elseif strcmp(rotation,'-90')
    Image = permute(Image,[2 1 3]);
    Cube = flipdim(Cube,2);
end
    
%---------------------------------------------
% Test
%---------------------------------------------
[x,y,z] = size(Image);
if stop > z
    stop = z;
end
test = (start:step:stop);
if length(test) < nrows;
    nrows = length(test);
end

%---------------------------------------------
% Determine Scaling
%---------------------------------------------
func = str2func([PLOT.scalefunc,'_Func']);  
INPUT.Image = Image;
INPUT.type = type;
[IMSCL,err] = func(IMSCL,INPUT);
if err.flag
    return
end
clear INPUT;
Image = IMSCL.Image;
minval = IMSCL.minval;
maxval = IMSCL.maxval;

%---------------------------------------------
% Determine Scaling
%---------------------------------------------
if strcmp(type,'Abs')
    type = 'abs';
elseif strcmp(type,'Real')
    type = 'real';
elseif strcmp(type,'Imag')
    type = 'imag';    
elseif strcmp(type,'Phase')
    type = 'phase';  
end

%---------------------------------------------
% Determine colour
%---------------------------------------------
if strcmp(colour,'Yes')
    clr = 1;
else
    clr = 0;
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
% Determine Figure Size
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
% Determine Figure
%---------------------------------------------
if strcmp(figno,'Continue')
    fighand = figure;
else
    fighand = str2double(figno);
end 

%---------------------------------------------
% Plot Image
%--------------------------------------------- 
IMSTRCT.type = type; IMSTRCT.start = start; IMSTRCT.step = step; IMSTRCT.stop = stop; 
IMSTRCT.rows = nrows; IMSTRCT.lvl = [minval maxval]; IMSTRCT.SLab = 0; IMSTRCT.figno = fighand; 
IMSTRCT.docolor = 0; IMSTRCT.ColorMap = 'ColorMap4'; 
IMSTRCT.figsize = figsize;
[h1,ImSz] = ImageMontageRGB_v1a(Image,IMSTRCT);

%---------------------------------------------
% Display Mask Image
%---------------------------------------------
IMSTRCT.SLab = slclbl;
IMSTRCT.type = 'real'; IMSTRCT.lvl = [0 2]; IMSTRCT.docolor = 1; 
[h2,ImSz] = ImageMontageRGB_v1a(Cube,IMSTRCT);

%---------------------------------------------
% Mask and Scale
%---------------------------------------------
IMSTRCT.type = 'real'; IMSTRCT.lvl = [0 1];
[Mask,~] = ImageMontageSetup_v1a(Cube/3,IMSTRCT);
Mask(isnan(Mask)) = 0;
set(h2,'alphadata',Mask);       

%---------------------------------------------
% Ajust Mask Location
%---------------------------------------------
global MASK
MASK.h1 = h1;
MASK.h2 = h2;
MASK.dims = dims;
MASK.disp = disp;
MASK.sz = sz;
MASK.A = A;
MASK.P = P;
MASK.L = L;
MASK.R = R;
MASK.T = T;
MASK.B = B;
MASK.orient = orient;
MASK.rotation = rotation;
MASK.IMSTRCT = IMSTRCT;
MASK.ImSz = ImSz;
set(1,'Renderer','OpenGL');
set(1,'WindowKeyPressFcn',@FigKeyPress);

waitfor(1);

Status('done','');
Status2('done','',2);
Status2('done','',3);
