%=========================================================
% 
%=========================================================

function [default] = DisplayB0Map_v1b_Default2(SCRPTPATHS)

if strcmp(filesep,'\')
    scalepath = [SCRPTPATHS.voyagerloc,'Image Plotting\Underlying\zz Underlying\Image Contrast\'];
    montcharspath = [SCRPTPATHS.voyagerloc,'Image Plotting\Underlying\zz Underlying\Montage Chars\'];
    figcharspath = [SCRPTPATHS.voyagerloc,'Image Plotting\Underlying\zz Underlying\Figure Chars\'];
    plotpath = [SCRPTPATHS.voyagerloc,'Image Plotting\Underlying\zz Underlying\Overlay Plot\'];
elseif strcmp(filesep,'/')
end
scale1func = 'ImageContrastRelMag_v1a';
addpath([scalepath,scale1func]);
scale2func = 'ImageContrastB0Map_v1a';
addpath([scalepath,scale2func]);
montcharsfunc = 'MontageCharsStandard_v1a';
addpath([montcharspath,montcharsfunc]);
figcharsfunc = 'FigureCharsStandard_v1a';
addpath([figcharspath,figcharsfunc]);
plotfunc = 'PlotMontageOverlayStandard_v1a';
addpath([plotpath,plotfunc]);

m = 1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'ImCharsfunc';
default{m,1}.entrystr = montcharsfunc;
default{m,1}.searchpath = montcharspath;
default{m,1}.path = [montcharspath,montcharsfunc];

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'FigCharsfunc';
default{m,1}.entrystr = figcharsfunc;
default{m,1}.searchpath = figcharspath;
default{m,1}.path = [figcharspath,figcharsfunc];

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'ImScalefunc';
default{m,1}.entrystr = scale1func;
default{m,1}.searchpath = scalepath;
default{m,1}.path = [scalepath,scale1func];

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'MapScalefunc';
default{m,1}.entrystr = scale2func;
default{m,1}.searchpath = scalepath;
default{m,1}.path = [scalepath,scale2func];

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'Plotfunc';
default{m,1}.entrystr = plotfunc;
default{m,1}.searchpath = plotpath;
default{m,1}.path = [plotpath,plotfunc];