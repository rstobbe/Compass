%=========================================================
% 
%=========================================================

function [default] = MontageFigure_v1b_Default2(SCRPTPATHS)

if strcmp(filesep,'\')
    scalepath = [SCRPTPATHS.voyagerloc,'Image Plotting\Underlying\zz Underlying\Image Contrast\'];
elseif strcmp(filesep,'/')
end
scalefunc = 'ImageContrastRelMag_v1c';

m = 1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'ImScalefunc';
default{m,1}.entrystr = scalefunc;
default{m,1}.searchpath = scalepath;
default{m,1}.path = [scalepath,scalefunc];

m = m+1;
default{m,1}.entrytype = 'Choose';
default{m,1}.labelstr = 'Colour';
default{m,1}.entrystr = 'No';
default{m,1}.options = {'Yes','No'};

m = m+1;
default{m,1}.entrytype = 'Choose';
default{m,1}.labelstr = 'SliceLabel';
default{m,1}.entrystr = 'No';
default{m,1}.options = {'Yes','No'};

m = m+1;
default{m,1}.entrytype = 'Choose';
default{m,1}.labelstr = 'Scale';
default{m,1}.entrystr = 'auto';
default{m,1}.options = {'auto','1','2','3','4','5','6'};