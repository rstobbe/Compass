%====================================================
%
%====================================================

function [default] = CreateBPGradCompositeTest_v1c_Default2(SCRPTPATHS)

if strcmp(filesep,'\')
    syswrtpath = [SCRPTPATHS.pioneerloc,'System Write\Underlying\Selectable Functions\'];
    testsamppath = [SCRPTPATHS.newhorizonsloc,'Scanner Related\Field Analysis\Underlying\Selectable Functions\Gradient Test Sampling'];
elseif strcmp(filesep,'/')
end
syswrt = 'SysWrt_Siemens_v1a';
testsamp = 'GradTestSamp_v1a';

m = 1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'GradSet_Name';
default{m,1}.entrystr = '';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'NumBGtests';
default{m,1}.entrystr = '1';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'NumPLtests';
default{m,1}.entrystr = '1';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'PLGrad (mT/m)';
default{m,1}.entrystr = '4';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'TotGradDur (ms)';
default{m,1}.entrystr = '8';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'PreGDur (ms)';
default{m,1}.entrystr = '0.1';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'GatMaxDur (ms)';
default{m,1}.entrystr = '0.5';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'InterGDur (ms)';
default{m,1}.entrystr = '0.3';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'GStepDur (us)';
default{m,1}.entrystr = '2.5';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'Gsl (mT/m/ms)';
default{m,1}.entrystr = '120';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'Gstart (mT/m)';
default{m,1}.entrystr = '0.5';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'Gstep (mT/m)';
default{m,1}.entrystr = '0.5';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'Gstop (mT/m)';
default{m,1}.entrystr = '30';

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
