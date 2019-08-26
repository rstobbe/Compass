%====================================================
%
%====================================================

function [default] = B1correction_v1b_Default2(SCRPTPATHS)

if strcmp(filesep,'\')
    loadpath = [SCRPTPATHS.voyagerloc,'Image Format Related\Underlying\Selectable Functions\Load\Mat\'];
    algnpath = [SCRPTPATHS.voyagerloc,'Image Processing\Underlying\Selectable Functions\Image Registration\ReSize\'];
    corrpath = [SCRPTPATHS.voyagerloc,'Image Processing\Underlying\Selectable Functions\Image Correction\B1 Correction\'];
    disppath = [SCRPTPATHS.voyagerloc,'Image Processing\Underlying\Selectable Functions\Image Display\'];  
elseif strcmp(filesep,'/')
end
loadfunc = 'Im2LoadMat_v1a';
algnfunc = 'SameSizeTest_v1a';
corrfunc = 'B1corrDW_v1c';
dispfunc = 'NoImageDisplay_v1a';

m = 1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'Image_Name';
default{m,1}.entrystr = '';

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'ImLoadfunc';
default{m,1}.entrystr = loadfunc;
default{m,1}.searchpath = loadpath;
default{m,1}.path = [loadpath,loadfunc];

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'ReSizefunc';
default{m,1}.entrystr = algnfunc;
default{m,1}.searchpath = algnpath;
default{m,1}.path = [algnpath,algnfunc];

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'B1Corrfunc';
default{m,1}.entrystr = corrfunc;
default{m,1}.searchpath = corrpath;
default{m,1}.path = [corrpath,corrfunc];

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'Dispfunc';
default{m,1}.entrystr = dispfunc;
default{m,1}.searchpath = disppath;
default{m,1}.path = [disppath,dispfunc];

m = m+1;
default{m,1}.entrytype = 'RunScrptFunc';
default{m,1}.scrpttype = 'B1corr';
default{m,1}.labelstr = 'B1corr';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Run';

