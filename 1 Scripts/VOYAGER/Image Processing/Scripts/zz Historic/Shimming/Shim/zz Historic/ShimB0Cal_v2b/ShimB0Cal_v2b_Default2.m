%=========================================================
% 
%=========================================================

function [default] = ShimB0Cal_v2b_Default2(SCRPTPATHS)

if strcmp(filesep,'\')
    fitpath = [SCRPTPATHS.voyagerloc,'Image Processing\Underlying\Selectable Functions\Shimming\B0\'];
elseif strcmp(filesep,'/')
end
fitfunc = 'CalB0SphH_v1b';
addpath([fitpath,fitfunc]);

m = 1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'Image_Name';
default{m,1}.entrystr = '';

m = m+1;
default{m,1}.entrytype = 'RunExtFunc';
default{m,1}.labelstr = 'ImageB_File';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Select';
default{m,1}.runfunc1 = 'LoadMatFileCur_v4';
default{m,1}.(default{m,1}.runfunc1).curloc = SCRPTPATHS.outloc;
default{m,1}.runfunc2 = 'LoadMatFileDef_v4';
default{m,1}.(default{m,1}.runfunc2).defloc = SCRPTPATHS.outloc;
default{m,1}.searchpath = SCRPTPATHS.scrptshareloc;
default{m,1}.path = SCRPTPATHS.scrptshareloc;

m = m+1;
default{m,1}.entrytype = 'RunExtFunc';
default{m,1}.labelstr = 'ImageV_File';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Select';
default{m,1}.runfunc1 = 'LoadMatFileCur_v4';
default{m,1}.(default{m,1}.runfunc1).curloc = SCRPTPATHS.outloc;
default{m,1}.runfunc2 = 'LoadMatFileDef_v4';
default{m,1}.(default{m,1}.runfunc2).defloc = SCRPTPATHS.outloc;
default{m,1}.searchpath = SCRPTPATHS.scrptshareloc;
default{m,1}.path = SCRPTPATHS.scrptshareloc;

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'B0Shimfunc';
default{m,1}.entrystr = fitfunc;
default{m,1}.searchpath = fitpath;
default{m,1}.path = [fitpath,fitfunc];

m = m+1;
default{m,1}.entrytype = 'RunScrptFunc';
default{m,1}.scrpttype = 'Shim';
default{m,1}.labelstr = 'Shim';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Run';