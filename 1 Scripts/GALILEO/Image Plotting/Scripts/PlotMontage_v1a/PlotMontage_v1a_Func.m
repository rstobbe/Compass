%=========================================================
% 
%=========================================================

function [PLOT,err] = PlotMontage_v1a_Func(PLOT,INPUT)

global IMT
global CURFIG
global IMLVL

Status('busy','Plot Montage');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
clear INPUT;

%---------------------------------------------
% Get Variables
%---------------------------------------------
slices = PLOT.slices;
insets = PLOT.insets ;   
nrows = PLOT.nRows ;
imsize = PLOT.imsize;
figno = PLOT.figno;
slclbl = PLOT.slclbl;

%---------------------------------------------
% Get Image
%---------------------------------------------
Image = IMT{CURFIG};
[x,y,z] = size(Image);

%---------------------------------------------
% Determine Slices
%---------------------------------------------
if strcmp(slices,'All') || isempty(slices)
    start = 1;
    step = 1;
    stop = z;
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
T = str2double(insets(1:inds(1)-1));
B = str2double(insets(inds(1)+1:inds(2)-1));
L = str2double(insets(inds(2)+1:inds(3)-1)); 
R = str2double(insets(inds(3)+1:length(insets))); 

%---------------------------------------------
% Inset
%---------------------------------------------
[x,y,z] = size(Image);
Image = Image(T+1:x-B,L+1:y-R,:);

%---------------------------------------------
% Test
%---------------------------------------------
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
minval = IMLVL(CURFIG).min+1;
maxval = IMLVL(CURFIG).max;

%---------------------------------------------
% Determine colour
%---------------------------------------------
clr = 0;
cmap = IMLVL(CURFIG).color;
if not(strcmp(cmap,'gray'))
    clr = 1;
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
type = 'real';
IMSTRCT.type = type; IMSTRCT.start = start; IMSTRCT.step = step; IMSTRCT.stop = stop; 
IMSTRCT.rows = nrows; IMSTRCT.lvl = [minval maxval]; IMSTRCT.SLab = slclbl; IMSTRCT.figno = fighand; 
IMSTRCT.docolor = clr; IMSTRCT.ColorMap = 'ColorMap4'; 
IMSTRCT.figsize = figsize;
AxialMontage_v2a(Image,IMSTRCT);
colormap(cmap);

Status('done','');
Status2('done','',2);
Status2('done','',3);
