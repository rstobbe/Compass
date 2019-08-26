%=========================================================
% 
%=========================================================

function [default] = MontageOverlayFigure_v1a_Default2(SCRPTPATHS)

if strcmp(filesep,'\')
    scalepath = [SCRPTPATHS.voyagerloc,'Image Plotting\Underlying\zz Underlying\Image Contrast\'];
    plotpath = [SCRPTPATHS.voyagerloc,'Image Plotting\Underlying\zz Underlying\Overlay Plot\'];
elseif strcmp(filesep,'/')
end
scale1func = 'ImageContrastRelMag_v1a';
scale2func = 'ImageContrastGeneral_v1a';
plotfunc = 'PlotMontageOverlayStandard_v1b';

m = 1;
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
