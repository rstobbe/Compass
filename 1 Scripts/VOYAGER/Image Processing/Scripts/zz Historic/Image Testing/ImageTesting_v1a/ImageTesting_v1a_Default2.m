%=========================================================
% 
%=========================================================

function [default] = ImageTesting_v1a_Default2(SCRPTPATHS)

if strcmp(filesep,'\')
    loadpath = [SCRPTPATHS.voyagerloc,'Image Format Related\Underlying\Selectable Functions\Load\Mat\'];
    baseimpath = [SCRPTPATHS.voyagerloc,'Image Processing\Underlying\Selectable Functions\Base Image for Mapping\'];
    maskpath = [SCRPTPATHS.voyagerloc,'Image Processing\Underlying\Selectable Functions\Image Masking\'];
    testpath = [SCRPTPATHS.voyagerloc,'Image Processing\Underlying\Selectable Functions\Image Testing\'];
    disppath = [SCRPTPATHS.voyagerloc,'Image Processing\Underlying\Selectable Functions\Image Display\'];    
elseif strcmp(filesep,'/')
end
loadfunc = 'FImageLoad1_v1a';
baseimfunc = 'AbsCombine_v1a';
maskfunc = 'IntenseMask_v1a';
testfunc = 'StabilityCheck_v1a';
dispfunc = 'SubPlotMontage_v1a';

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
default{m,1}.labelstr = 'BaseImfunc';
default{m,1}.entrystr = baseimfunc;
default{m,1}.searchpath = baseimpath;
default{m,1}.path = [baseimpath,baseimfunc];

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'Maskfunc';
default{m,1}.entrystr = maskfunc;
default{m,1}.searchpath = maskpath;
default{m,1}.path = [maskpath,maskfunc];

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'Testfunc';
default{m,1}.entrystr = testfunc;
default{m,1}.searchpath = testpath;
default{m,1}.path = [testpath,testfunc];

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'Dispfunc';
default{m,1}.entrystr = dispfunc;
default{m,1}.searchpath = disppath;
default{m,1}.path = [disppath,dispfunc];

m = m+1;
default{m,1}.entrytype = 'RunScrptFunc';
default{m,1}.scrpttype = 'Test';
default{m,1}.labelstr = 'Test';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Run';