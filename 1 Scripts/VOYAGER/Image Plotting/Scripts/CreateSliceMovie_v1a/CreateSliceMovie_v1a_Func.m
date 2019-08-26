%=========================================================
% 
%=========================================================

function [PLOT,err] = CreateSliceMovie_v1a_Func(PLOT,INPUT)

Status('busy','Slice Movie');
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
slices = PLOT.slices;
insets = PLOT.insets ;   
colour = PLOT.colour;
nrows = 1;
imsize = PLOT.imsize;
figno = PLOT.figno;
slclbl = PLOT.slclbl;

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

%---------------------------------------------
% Orientation
%---------------------------------------------
if strcmp(orient,'Axial')
    Image = Image;
elseif strcmp(orient,'Sagittal')
    Image = permute(Image,[1 3 2]);
elseif strcmp(orient,'Coronal')    
    Image = permute(Image,[3 2 1]);
end

%---------------------------------------------
% Rotate
%---------------------------------------------
if strcmp(rotation,'-90')
    Image = permute(Image,[2 1 3]);
elseif strcmp(rotation,'90')
    Image = permute(Image,[2 1 3]);
    Image = flipdim(Image,1);
elseif strcmp(rotation,'180')
    Image = flipdim(Image,1);
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
% Plot Image Setup
%--------------------------------------------- 
IMSTRCT.type = type; IMSTRCT.step = 1;
IMSTRCT.rows = nrows; IMSTRCT.lvl = [minval maxval]; IMSTRCT.SLab = slclbl; IMSTRCT.figno = fighand; 
IMSTRCT.docolor = clr; IMSTRCT.ColorMap = 'ColorMap4'; 
IMSTRCT.figsize = figsize;

%---------------------------------------------
% Plot Image Movie
%--------------------------------------------- 
m = 1;
for n = start:step:stop
    IMSTRCT.start = n; IMSTRCT.stop = n; 
    AxialMontage_v2a(Image,IMSTRCT);
    
    F = getframe(fighand);
    [Xt,~] = frame2im(F);
    X(:,:,:,m) = rgb2ind(Xt,[gray(128);jet(128)]);
    m = m+1;
    clf(fighand);  
end

%---------------------------------------------
% Save
%--------------------------------------------- 
[file,path] = uiputfile('*.gif','Name Movie',PLOT.impath);
if file == 0
    return
end
size(X)
imwrite(X,[gray(128);jet(128)],[path,file],'gif','LoopCount',inf,'DelayTime',0);    


Status('done','');
Status2('done','',2);
Status2('done','',3);
