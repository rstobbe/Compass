%=========================================================
% 
%=========================================================

function [PLOT,err] = PlotMontageStandard_v1b_Func(PLOT,INPUT)

Status2('busy','Plot Montage',3);

err.flag = 0;
err.msg = '';

%----------------------------------------------
% Get input
%----------------------------------------------
Image = INPUT.Image;
Name = INPUT.Name;
MSTRCT = INPUT.MSTRCT;
clear INPUT

ncolumns = MSTRCT.ncolumns;
imsize = MSTRCT.imsize;
figno = MSTRCT.figno;
slclbl = MSTRCT.slclbl;
start = MSTRCT.start;
step = MSTRCT.step;
stop = MSTRCT.stop;
type = MSTRCT.type;
minval = MSTRCT.dispwid(1);
maxval = MSTRCT.dispwid(2);
colour = PLOT.colour;

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
test = (start:step:stop);
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
% Determine colour
%---------------------------------------------
if strcmp(colour,'Yes')
    clr = 1;
else
    clr = 0;
end

%---------------------------------------------
% Plot Image
%--------------------------------------------- 
IMSTRCT.type = type; IMSTRCT.start = start; IMSTRCT.step = step; IMSTRCT.stop = stop; 
IMSTRCT.rows = ncolumns; IMSTRCT.lvl = [minval maxval]; IMSTRCT.SLab = slclbl; IMSTRCT.figno = fighand; 
IMSTRCT.docolor = clr; IMSTRCT.ColorMap = 'ColorMap4'; 
IMSTRCT.figsize = figsize;
AxialMontage_v2a(Image,IMSTRCT);
title(Name);

Status2('done','',3);
