%====================================================
%
%====================================================

function [default] = CreateFromTrajUSL_v1a_Default2(SCRPTPATHS)

if strcmp(filesep,'\')
    syswrtpath = [SCRPTPATHS.pioneerloc,'System Write\Underlying\Selectable Functions\'];
    testsamppath = [SCRPTPATHS.newhorizonsloc,'Scanner Related\Field Analysis\Underlying\Selectable Functions\Gradient Test Sampling'];
elseif strcmp(filesep,'/')
end
syswrt = 'SysWrt_Siemens_v1a';
testsamp = 'GradTestSamp_v1a';

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
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'UseTrajNum';
default{m,1}.entrystr = '1';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'UseTrajDir';
default{m,1}.entrystr = 'X';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'PreGDur (ms)';
default{m,1}.entrystr = '0.5';

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'TestSampfunc';
default{m,1}.entrystr = testsamp;
default{m,1}.searchpath = testsamppath;
default{m,1}.path = [testsamppath,testsamp];

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'SysWrtfunc';
default{m,1}.entrystr = syswrt;
default{m,1}.searchpath = syswrtpath;
default{m,1}.path = [syswrtpath,syswrt];

m = m+1;
default{m,1}.entrytype = 'RunScrptFunc';
default{m,1}.scrpttype = 'CreateTest';
default{m,1}.labelstr = 'CreateTest';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Run';
