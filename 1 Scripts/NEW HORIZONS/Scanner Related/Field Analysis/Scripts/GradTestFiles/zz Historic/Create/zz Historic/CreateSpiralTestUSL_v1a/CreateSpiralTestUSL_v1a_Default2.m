%====================================================
%
%====================================================

function [default] = CreateSpiralTestUSL_v1a_Default2(SCRPTPATHS)

rstobbeloc = 'Z:\rstobbe\vnmrsys\acqlib\Field_Analysis\';

if strcmp(filesep,'\')
    wrgradpath = [SCRPTPATHS.pioneerloc,'System Write\Underlying\Selectable Functions\WrtGrad Functions\'];
    wrparmpath = [SCRPTPATHS.newhorizonsloc,'Scanner Related\Field Analysis\Underlying\Selectable Functions\Write System Files\'];
elseif strcmp(filesep,'/')
end
wrgrad = 'WrtGrad_NFilesV_v1c';
wrparm = 'WriteParamEccV_v1d';
addpath([wrgradpath,wrgrad]);
addpath([wrparmpath,wrparm]);

m = 1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'GradTest_Name';
default{m,1}.entrystr = '';

m = m+1;
default{m,1}.entrytype = 'RunExtFunc';
default{m,1}.labelstr = 'Imp_File';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Load';
default{m,1}.runfunc1 = 'LoadTrajImpCur_v4';
default{m,1}.(default{m,1}.runfunc1).curloc = SCRPTPATHS.outloc;
default{m,1}.(default{m,1}.runfunc1).loadpanel = 'No';
default{m,1}.runfunc2 = 'LoadTrajImpDef_v4';
default{m,1}.(default{m,1}.runfunc2).defloc = SCRPTPATHS.outloc;
default{m,1}.(default{m,1}.runfunc2).loadpanel = 'No';
default{m,1}.searchpath = SCRPTPATHS.scrptshareloc;
default{m,1}.path = SCRPTPATHS.scrptshareloc;

m = m+1;
default{m,1}.entrytype = 'RunExtFunc';
default{m,1}.labelstr = 'Grad_Folder';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Select';
default{m,1}.runfunc1 = 'SelectDirCur_v4';
default{m,1}.(default{m,1}.runfunc1).curloc = rstobbeloc;
default{m,1}.runfunc2 = 'SelectDirDef_v4';
default{m,1}.(default{m,1}.runfunc2).defloc = rstobbeloc;

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
