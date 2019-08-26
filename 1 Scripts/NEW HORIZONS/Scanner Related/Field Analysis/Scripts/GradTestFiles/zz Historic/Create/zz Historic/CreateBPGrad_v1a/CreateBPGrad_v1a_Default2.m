%====================================================
%
%====================================================

function [default] = CreateBPGrad_v1a_Default2(SCRPTPATHS)

if strcmp(filesep,'\')
    wrgradpath = [SCRPTPATHS.scrptshareloc,'1 MRI Systems\Selectable Functions\Write1GradFileV_v1a'];
    wrparmpath = [SCRPTPATHS.scrptshareloc,'1 MRI Systems\Selectable Functions\WriteParamEccV_v1a'];
elseif strcmp(filesep,'/')
end
wrgrad = 'Write1GradFileV_v1a';
wrparm = 'WriteParamEccV_v1a';

m = 1;
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
default{m,1}.labelstr = 'Gmax (mT/m)';
default{m,1}.entrystr = '30';

m = m+1;
default{m,1}.entrytype = 'Choose';
default{m,1}.labelstr = 'Write Grads';
default{m,1}.entrystr = 'No';
default{m,1}.options = {'Yes','No'};

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'WrtGradFnc';
default{m,1}.entrystr = wrgrad;
default{m,1}.searchpath = wrgradpath;

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'WrtParamFnc';
default{m,1}.entrystr = wrparm;
default{m,1}.searchpath = wrparmpath;
