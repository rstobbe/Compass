%=========================================================
% 
%=========================================================

function [default] = ShimB0_v2d_Default2(SCRPTPATHS)

if strcmp(filesep,'\')
    maskpath = [SCRPTPATHS.voyagerloc,'Image Processing\Underlying\Selectable Functions\Image Masking\'];
    mappath = [SCRPTPATHS.voyagerloc,'Image Processing\Underlying\Selectable Functions\B0 Field Mapping\'];
    fitpath = [SCRPTPATHS.voyagerloc,'Image Processing\Underlying\Selectable Functions\B0 Shimming\Fitting\'];
    plotpath = [SCRPTPATHS.voyagerloc,'Image Processing\Underlying\Selectable Functions\B0 Shimming\Plotting\'];
elseif strcmp(filesep,'/')
end
maskfunc = 'IntenseFreqMap_v1a';
addpath([maskpath,maskfunc]);
mapfunc = 'B0MapSingleRcvr_v1a';
addpath([mappath,mapfunc]);
plotfunc = 'ShimPlot_v1b';
addpath([plotpath,plotfunc]);
fitfunc = 'Fit3DegShimCoils4z_v1a';
addpath([fitpath,fitfunc]);

m = 1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'Shim_Name';
default{m,1}.entrystr = '';

m = m+1;
default{m,1}.entrytype = 'RunExtFunc';
default{m,1}.labelstr = 'Image_File';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Select';
default{m,1}.runfunc1 = 'LoadImageCur_v4';
default{m,1}.(default{m,1}.runfunc1).curloc = SCRPTPATHS.outloc;
default{m,1}.runfunc2 = 'LoadImageDef_v4';
default{m,1}.(default{m,1}.runfunc2).defloc = SCRPTPATHS.outloc;
default{m,1}.searchpath = SCRPTPATHS.scrptshareloc;
default{m,1}.path = SCRPTPATHS.scrptshareloc;

m = m+1;
default{m,1}.entrytype = 'RunExtFunc';
default{m,1}.labelstr = 'Cal_File';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Load';
default{m,1}.runfunc1 = 'LoadMatFileCur_v4';
default{m,1}.(default{m,1}.runfunc1).curloc = SCRPTPATHS.outloc;
default{m,1}.runfunc2 = 'LoadMatFileDef_v4';
default{m,1}.(default{m,1}.runfunc2).defloc = SCRPTPATHS.outloc;
default{m,1}.searchpath = SCRPTPATHS.scrptshareloc;
default{m,1}.path = SCRPTPATHS.scrptshareloc;

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'B0Mapfunc';
default{m,1}.entrystr = mapfunc;
default{m,1}.searchpath = mappath;
default{m,1}.path = [mappath,mapfunc];

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'Maskfunc';
default{m,1}.entrystr = maskfunc;
default{m,1}.searchpath = maskpath;
default{m,1}.path = [maskpath,maskfunc];

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'Shimfunc';
default{m,1}.entrystr = fitfunc;
default{m,1}.searchpath = fitpath;
default{m,1}.path = [fitpath,fitfunc];

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'Plotfunc';
default{m,1}.entrystr = plotfunc;
default{m,1}.searchpath = plotpath;
default{m,1}.path = [plotpath,plotfunc];

m = m+1;
default{m,1}.entrytype = 'Choose';
default{m,1}.labelstr = 'Orientation';
default{m,1}.entrystr = 'Axial';
default{m,1}.options = {'Sagittal','Coronal','Axial'};

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'Inset (L,R,T,B,I,O)';
default{m,1}.entrystr = '0,0,0,0,0,0';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'DispOrigFull (Hz)';
default{m,1}.entrystr = 'Full';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'DispOrigMask (Hz)';
default{m,1}.entrystr = 'Full';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'DispFitMask (Hz)';
default{m,1}.entrystr = 'Full';

m = m+1;
default{m,1}.entrytype = 'RunScrptFunc';
default{m,1}.scrpttype = 'Shim';
default{m,1}.labelstr = 'Shim';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Run';