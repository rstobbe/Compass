%====================================================
%
%====================================================

function [default] = AddGradientOffset_v1a_Default2(SCRPTPATHS)

if strcmp(filesep,'\')
    wrgradpath = [SCRPTPATHS.newhorizonsloc,'Scanner Related\Field Analysis\Underlying\Selectable Functions\Write System Files\'];
    wrparmpath = [SCRPTPATHS.newhorizonsloc,'Scanner Related\Field Analysis\Underlying\Selectable Functions\Write System Files\'];
elseif strcmp(filesep,'/')
end
wrgrad = 'WriteSingleGradV_v1a';
wrparm = 'WriteParamEccV_v1d';
addpath([wrgradpath,wrgrad]);
addpath([wrparmpath,wrparm]);

m = 1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'GradTest_Name';
default{m,1}.entrystr = '';

m = m+1;
default{m,1}.entrytype = 'RunExtFunc';
default{m,1}.labelstr = 'GradTest_File';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Load';
default{m,1}.runfunc1 = 'LoadMatFileCur_v4';
default{m,1}.(default{m,1}.runfunc1).curloc = SCRPTPATHS.outloc;
default{m,1}.(default{m,1}.runfunc1).loadpanel = 'No';
default{m,1}.runfunc2 = 'LoadMatFileDef_v4';
default{m,1}.(default{m,1}.runfunc2).defloc = SCRPTPATHS.outloc;
default{m,1}.(default{m,1}.runfunc2).loadpanel = 'No';
default{m,1}.searchpath = SCRPTPATHS.scrptshareloc;
default{m,1}.path = SCRPTPATHS.scrptshareloc;

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'Goffset (mT/m)';
default{m,1}.entrystr = '-0.02';

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
default{m,1}.scrpttype = 'CreateTest';
default{m,1}.labelstr = 'CreateTest';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Run';
