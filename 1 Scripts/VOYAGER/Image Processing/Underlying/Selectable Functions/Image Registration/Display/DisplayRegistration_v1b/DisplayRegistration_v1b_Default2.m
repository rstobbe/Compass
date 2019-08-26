%=========================================================
% 
%=========================================================

function [default] = DisplayRegistration_v1b_Default2(SCRPTPATHS)

if strcmp(filesep,'\')
    contrastpath = [SCRPTPATHS.voyagerloc,'Image Plotting\Underlying\zz Underlying\Image Contrast\'];
    montcharspath = [SCRPTPATHS.voyagerloc,'Image Plotting\Underlying\zz Underlying\Montage Chars\'];
    figcharspath = [SCRPTPATHS.voyagerloc,'Image Plotting\Underlying\zz Underlying\Figure Chars\'];
    plotpath = [SCRPTPATHS.voyagerloc,'Image Plotting\Underlying\zz Underlying\Overlay Plot\'];
elseif strcmp(filesep,'/')
end
contrast1func = 'ImageContrastRelMag_v1a';
addpath([contrastpath,contrast1func]);
contrast2func = 'ImageContrastRelMag_v1a';
addpath([contrastpath,contrast2func]);
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
default{m,1}.labelstr = 'Im1Contrastfunc';
default{m,1}.entrystr = contrast1func;
default{m,1}.searchpath = contrastpath;
default{m,1}.path = [contrastpath,contrast1func];

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'Im2Contrastfunc';
default{m,1}.entrystr = contrast2func;
default{m,1}.searchpath = contrastpath;
default{m,1}.path = [contrastpath,contrast2func];

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'Plotfunc';
default{m,1}.entrystr = plotfunc;
default{m,1}.searchpath = plotpath;
default{m,1}.path = [plotpath,plotfunc];