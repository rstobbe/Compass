%====================================================
%
%====================================================

function [default] = CreateGradTestFile_v1a_Default2(SCRPTPATHS)

if strcmp(filesep,'\')
    syswrtpath = [SCRPTPATHS.pioneerloc,'System Write\Underlying\Selectable Functions\'];
    testsamppath = [SCRPTPATHS.newhorizonsloc,'Scanner Related\Field Analysis\Underlying\Selectable Functions\Gradient Test Sampling\'];
    testdespath = [SCRPTPATHS.newhorizonsloc,'Scanner Related\Field Analysis\Underlying\Selectable Functions\Gradient Test Design\'];
elseif strcmp(filesep,'/')
end
syswrt = 'SysWrt_Siemens_v1a';
testsamp = 'GradTestSamp_v1a';
testdes = 'BPGradCompositeTest_v1c';

m = 1;
default{m,1}.entrytype = 'OutputName';
default{m,1}.labelstr = 'GradSet_Name';
default{m,1}.entrystr = '';

m = m+1;
default{m,1}.entrytype = 'ScriptName';
default{m,1}.labelstr = 'Script_Name';
default{m,1}.entrystr = '';

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'TestDesfunc';
default{m,1}.entrystr = testdes;
default{m,1}.searchpath = testdespath;
default{m,1}.path = [testdespath,testdes];

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
default{m,1}.scrpttype = 'CreateGrad';
default{m,1}.labelstr = 'CreateGrad';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Run';
