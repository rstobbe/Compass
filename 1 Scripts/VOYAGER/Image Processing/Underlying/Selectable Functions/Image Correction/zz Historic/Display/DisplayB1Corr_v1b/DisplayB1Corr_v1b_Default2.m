%=========================================================
% 
%=========================================================

function [default] = DisplayB1Corr_v1b_Default2(SCRPTPATHS)

if strcmp(filesep,'\')
    scalepath = [SCRPTPATHS.voyagerloc,'Image Plotting\Underlying\zz Underlying\Image Contrast\'];
    montcharspath = [SCRPTPATHS.voyagerloc,'Image Plotting\Underlying\zz Underlying\Montage Chars\'];
    figcharspath = [SCRPTPATHS.voyagerloc,'Image Plotting\Underlying\zz Underlying\Figure Chars\'];
    plotpath = [SCRPTPATHS.voyagerloc,'Image Plotting\Underlying\zz Underlying\Montage Plot\'];
elseif strcmp(filesep,'/')
end
scalefunc = 'ImageContrastRelMag_v1a';
addpath([scalepath,scalefunc]);
montcharsfunc = 'MontageCharsStandard_v1a';
addpath([montcharspath,montcharsfunc]);
figcharsfunc = 'FigureCharsStandard_v1a';
addpath([figcharspath,figcharsfunc]);
plotfunc = 'PlotMontage_v1a';
addpath([plotpath,plotfunc]);

m = 1;
default{m,1}.entrytype = 'Choose';
default{m,1}.labelstr = 'Type';
default{m,1}.entrystr = 'New';
default{m,1}.options = {'New','RelChange','Old'};

m = m+1;
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
default{m,1}.labelstr = 'MapScalefunc';
default{m,1}.entrystr = scalefunc;
default{m,1}.searchpath = scalepath;
default{m,1}.path = [scalepath,scalefunc];

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'Plotfunc';
default{m,1}.entrystr = plotfunc;
default{m,1}.searchpath = plotpath;
default{m,1}.path = [plotpath,plotfunc];