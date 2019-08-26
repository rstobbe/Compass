%=========================================================
% 
%=========================================================

function [default] = B0Shim2TE_v1d_Default2(SCRPTPATHS)

if strcmp(filesep,'\')
    loadpath = [SCRPTPATHS.voyagerloc,'Image Format Related\Underlying\Selectable Functions\Load\Generic\'];
    algnpath = [SCRPTPATHS.voyagerloc,'Image Processing\Underlying\Selectable Functions\Image Registration\ReSize\'];
    baseimpath = [SCRPTPATHS.voyagerloc,'Image Processing\Underlying\Selectable Functions\Base Image for Mapping\'];
    maskpath = [SCRPTPATHS.voyagerloc,'Image Processing\Underlying\Selectable Functions\Image Masking\'];
    mappath = [SCRPTPATHS.voyagerloc,'Image Processing\Underlying\Selectable Functions\B0 Field Mapping\Mapping\'];
    fitpath = [SCRPTPATHS.voyagerloc,'Image Processing\Underlying\Selectable Functions\B0 Shimming\Fitting\'];
    disppath = [SCRPTPATHS.voyagerloc,'Image Processing\Underlying\Selectable Functions\Image Display\'];
elseif strcmp(filesep,'/')
end
loadfunc = 'Im1LoadGeneric_v1c';
algnfunc = 'SameSizeTest_v1a';
baseimfunc = 'AbsCombine_v1a';
maskfunc = 'IntenseFreqMap_v1a';
mapfunc = 'B0MapSingleRcvr_v1b';
dispfunc = 'SubPlotMontage_v1b';
fitfunc = 'Fit3DegShimCoils4z_v1c';

m = 1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'Shim_Name';
default{m,1}.entrystr = '';

m = m+1;
default{m,1}.entrytype = 'ScriptName';
default{m,1}.labelstr = 'Script_Name';
default{m,1}.entrystr = '';

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
default{m,1}.labelstr = 'BaseImfunc';
default{m,1}.entrystr = baseimfunc;
default{m,1}.searchpath = baseimpath;
default{m,1}.path = [baseimpath,baseimfunc];

m = m+1;
default{m,1}.entrytype = 'Choose';
default{m,1}.labelstr = 'ShimCalPol';
default{m,1}.entrystr = 'B0';
default{m,1}.options = {'B0','AbsFreq'};

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
default{m,1}.labelstr = 'Dispfunc';
default{m,1}.entrystr = dispfunc;
default{m,1}.searchpath = disppath;
default{m,1}.path = [disppath,dispfunc];

m = m+1;
default{m,1}.entrytype = 'RunScrptFunc';
default{m,1}.scrpttype = 'Shim';
default{m,1}.labelstr = 'Shim';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Run';