%====================================================
%
%====================================================

function [default] = CreateMultiBPGradsUSL_v1b_Default2(SCRPTPATHS)

if strcmp(filesep,'\')
    wrgradpath = [SCRPTPATHS.pioneerloc,'System Write\Underlying\Selectable Functions\WrtGrad Functions\'];
    wrparmpath = [SCRPTPATHS.newhorizonsloc,'Scanner Related\Field Analysis\Underlying\Selectable Functions\Write System Files\'];
elseif strcmp(filesep,'/')
end
wrgrad = 'WrtGrad_NFilesV_v1c';
wrparm = 'WriteParamEccV_v1d';

m = 1;
default{m,1}.entrytype = 'StatInput';
default{m,1}.labelstr = 'GradSet_Name';
default{m,1}.entrystr = '';

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
