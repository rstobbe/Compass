%=========================================================
% 
%=========================================================

function [default] = MontageFigureRoi_v1a_Default2(SCRPTPATHS)

if strcmp(filesep,'\')
    scalepath = [SCRPTPATHS.voyagerloc,'Image Plotting\Underlying\zz Underlying\Image Contrast\'];
    plotpath = [SCRPTPATHS.voyagerloc,'Image Plotting\Underlying\zz Underlying\Montage Plot\'];
    roiloadpath = [SCRPTPATHS.scrptshareloc,'0 General\File Related\Selectable Functions\'];
    roiplotpath = [SCRPTPATHS.voyagerloc,'Image Plotting\Underlying\zz Underlying\Roi Plot\'];
elseif strcmp(filesep,'/')
end
scalefunc = 'ImageContrastRelMag_v1b';
plotfunc = 'PlotMontageStandard_v1d';
roiplotfunc = 'PlotRoiStandard_v1a';
roiloadfunc = 'MultiGenericFileSelect_v1a';

m = 1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'ImScalefunc';
default{m,1}.entrystr = scalefunc;
default{m,1}.searchpath = scalepath;
default{m,1}.path = [scalepath,scalefunc];

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'Plotfunc';
default{m,1}.entrystr = plotfunc;
default{m,1}.searchpath = plotpath;
default{m,1}.path = [plotpath,plotfunc];

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
