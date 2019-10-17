%=========================================================
% 
%=========================================================

function [default] = MontageFigureRoi_v1b_Default2(SCRPTPATHS)

if strcmp(filesep,'\')
    scalepath = [SCRPTPATHS.voyagerloc,'Image Plotting\Underlying\zz Underlying\Image Contrast\'];
    roiloadpath = [SCRPTPATHS.scrptshareloc,'0 General\File Related\Selectable Functions\'];
    roiplotpath = [SCRPTPATHS.voyagerloc,'Image Plotting\Underlying\zz Underlying\Roi Plot\'];
elseif strcmp(filesep,'/')
end
scalefunc = 'ImageContrastRelMag_v1c';
roiplotfunc = 'PlotRoiStandard_v1a';
roiloadfunc = 'MultiGenericFileSelect_v1a';

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
default{m,1}.entrystr = 'Yes';
default{m,1}.options = {'Yes','No'};

m = m+1;
default{m,1}.entrytype = 'Choose';
default{m,1}.labelstr = 'Scale';
default{m,1}.entrystr = 'auto';
default{m,1}.options = {'auto','1','2','3','4','5','6'};

m = m+1;
default{m,1}.entrytype = 'Choose';
default{m,1}.labelstr = 'FigureVisible';
default{m,1}.entrystr = 'Yes';
default{m,1}.options = {'Yes','No'};

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'RoiLoadfunc';
default{m,1}.entrystr = roiloadfunc;
default{m,1}.searchpath = roiloadpath;
default{m,1}.path = [roiloadpath,roiloadfunc];

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'RoiPlotfunc';
default{m,1}.entrystr = roiplotfunc;
default{m,1}.searchpath = roiplotpath;
default{m,1}.path = [roiplotpath,roiplotfunc];