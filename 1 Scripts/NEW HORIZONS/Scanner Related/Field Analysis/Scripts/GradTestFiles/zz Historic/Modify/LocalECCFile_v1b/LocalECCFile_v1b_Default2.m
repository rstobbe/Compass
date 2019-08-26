%====================================================
%
%====================================================

function [default] = LocalECCFile_v1b_Default2(SCRPTPATHS)

if strcmp(filesep,'\')
    wrgradpath = [SCRPTPATHS.pioneerloc,'System Write\Underlying\Selectable Functions\WrtGrad Functions\'];
    wrparmpath = [SCRPTPATHS.newhorizonsloc,'Scanner Related\Field Analysis\Underlying\Selectable Functions\Write System Files\'];
    atrpath = [SCRPTPATHS.newhorizonsloc,'Scanner Related\Field Analysis\Underlying\Selectable Functions\Add Transient Response\'];
elseif strcmp(filesep,'/')
end
wrgrad = 'WrtGrad_NFilesV_v1c';
wrparm = 'WriteParamEccV_v1d';
atrfunc = 'AddExpTransResp_v1a';
addpath([wrgradpath,wrgrad]);
addpath([wrparmpath,wrparm]);
addpath([atrpath,atrfunc]);

m = 1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'GradSet_Name';
default{m,1}.entrystr = '';

m = m+1;
default{m,1}.entrytype = 'RunExtFunc';
default{m,1}.labelstr = 'GradDes_File';
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
default{m,1}.labelstr = 'ECC_File';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Select';
default{m,1}.runfunc1 = 'LoadMatFileCur_v4';
default{m,1}.(default{m,1}.runfunc1).curloc = SCRPTPATHS.outloc;
default{m,1}.runfunc2 = 'LoadMatFileDef_v4';
default{m,1}.(default{m,1}.runfunc2).defloc = SCRPTPATHS.outloc;
default{m,1}.searchpath = SCRPTPATHS.rootloc;
default{m,1}.path = SCRPTPATHS.rootloc;

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'ATRfunc';
default{m,1}.entrystr = atrfunc;
default{m,1}.searchpath = atrpath;
default{m,1}.path = [atrpath,atrfunc];

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
