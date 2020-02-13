%====================================================
%
%====================================================

function [default] = B1MapInovaHippo4_v1a_Default2(SCRPTPATHS)

if strcmp(filesep,'\')
    filtpath = [SCRPTPATHS.voyagerloc,'Image Processing\Underlying\Selectable Functions\Filter Image\No Filter\'];
elseif strcmp(filesep,'/')
end
filtfunc = 'Filter_none_v1a';

m = 1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'Mask (relval)';
default{m,1}.entrystr = '0.05';

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'LowPassfunc';
default{m,1}.entrystr = filtfunc;
default{m,1}.searchpath = filtpath;
default{m,1}.path = [filtpath,filtfunc];