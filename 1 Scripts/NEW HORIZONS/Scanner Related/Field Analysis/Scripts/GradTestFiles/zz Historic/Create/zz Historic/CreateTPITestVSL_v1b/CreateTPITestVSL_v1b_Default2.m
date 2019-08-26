%====================================================
%
%====================================================

function [default] = CreateTPITestVSL_v1b_Default2(SCRPTPATHS)

pioneerloc = 'D:\1 Scripts\PIONEER\Set 1.4\';
newhorizonsloc = 'D:\1 Scripts\NEW HORIZONS\Set 1.3\';
if strcmp(filesep,'\')
    wrgradpath = [pioneerloc,'System Write\Underlying\Selectable Functions\WrtGrad Functions\'];
    wrparmpath = [newhorizonsloc,'Scanner Related\Field Analysis\Underlying\Selectable Functions\Write System Files\'];
elseif strcmp(filesep,'/')
end
wrgrad = 'WrtGrad_NFilesV_v1c';
wrparm = 'WriteParamEccV_v1d';
addpath([wrgradpath,wrgrad]);
addpath([wrparmpath,wrparm]);

m = 1;
default{m,1}.entrytype = 'StatInput';
default{m,1}.labelstr = 'GradSet_Name';
default{m,1}.entrystr = '';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'PreGDur (ms)';
default{m,1}.entrystr = '0.1';

m = m+1;
default{m,1}.entrytype = 'RunExtFunc';
default{m,1}.labelstr = 'ProjImpX_File';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Select';
default{m,1}.runfunc1 = 'LoadMatFileCur_v4';
default{m,1}.(default{m,1}.runfunc1).curloc = SCRPTPATHS.outloc;
default{m,1}.runfunc2 = 'LoadMatFileDef_v4';
default{m,1}.(default{m,1}.runfunc2).defloc = SCRPTPATHS.outloc;
default{m,1}.searchpath = SCRPTPATHS.rootloc;
default{m,1}.path = SCRPTPATHS.rootloc;

m = m+1;
default{m,1}.entrytype = 'RunExtFunc';
default{m,1}.labelstr = 'ProjImpY_File';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Select';
default{m,1}.runfunc1 = 'LoadMatFileCur_v4';
default{m,1}.(default{m,1}.runfunc1).curloc = SCRPTPATHS.outloc;
default{m,1}.runfunc2 = 'LoadMatFileDef_v4';
default{m,1}.(default{m,1}.runfunc2).defloc = SCRPTPATHS.outloc;
default{m,1}.searchpath = SCRPTPATHS.rootloc;
default{m,1}.path = SCRPTPATHS.rootloc;

m = m+1;
default{m,1}.entrytype = 'RunExtFunc';
default{m,1}.labelstr = 'ProjImpZ_File';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Select';
default{m,1}.runfunc1 = 'LoadMatFileCur_v4';
default{m,1}.(default{m,1}.runfunc1).curloc = SCRPTPATHS.outloc;
default{m,1}.runfunc2 = 'LoadMatFileDef_v4';
default{m,1}.(default{m,1}.runfunc2).defloc = SCRPTPATHS.outloc;
default{m,1}.searchpath = SCRPTPATHS.rootloc;
default{m,1}.path = SCRPTPATHS.rootloc;

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'UseTrajNum';
default{m,1}.entrystr = '1';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'UseTrajDir';
default{m,1}.entrystr = 'X';

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'WrtGradfunc';
default{m,1}.entrystr = wrgrad;
default{m,1}.searchpath = wrgradpath;
default{m,1}.path = [wrgradpath,wrgrad];

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'WrtParamfunc';
default{m,1}.entrystr = wrparm;
default{m,1}.searchpath = wrparmpath;
default{m,1}.path = [wrparmpath,wrparm];

m = m+1;
default{m,1}.entrytype = 'RunScrptFunc';
default{m,1}.scrpttype = 'CreateGrad';
default{m,1}.labelstr = 'CreateGrad';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Run';
