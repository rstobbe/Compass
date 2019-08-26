%=========================================================
% 
%=========================================================

function [default] = CVarr_SphereROI_v1a_Default2(SCRPTPATHS)

if strcmp(filesep,'\')
    cvcalcpath = [SCRPTPATHS.pioneerloc,'Analysis\Underlying\zz Underlying\Selectable Functions\Trajectory Analysis\CV Calculate Functions\'];
elseif strcmp(filesep,'/')
end
cvcalcfunc = 'CVcalculate_v1b';

m = 1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'Diam (x:x:x mm)';
default{m,1}.entrystr = '3:1:10';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'ZeroFill';
default{m,1}.entrystr = '300';

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'CVcalcfunc';
default{m,1}.entrystr = cvcalcfunc;
default{m,1}.searchpath = cvcalcpath;
default{m,1}.path = [cvcalcpath,cvcalcfunc];

