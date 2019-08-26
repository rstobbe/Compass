%=========================================================
% 
%=========================================================

function [default] = MontageOverlayFigure_v1b_Default2(SCRPTPATHS)

if strcmp(filesep,'\')
    scalepath = [SCRPTPATHS.voyagerloc,'Image Plotting\Underlying\zz Underlying\Image Contrast\'];
elseif strcmp(filesep,'/')
end
scale1func = 'ImageContrastRelMag_v1c';
scale2func = 'ImageContrastGeneral_v1a';

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
default{m,1}.entrytype = 'Choose';
default{m,1}.labelstr = 'SliceLabel';
default{m,1}.entrystr = 'No';
default{m,1}.options = {'Yes','No'};