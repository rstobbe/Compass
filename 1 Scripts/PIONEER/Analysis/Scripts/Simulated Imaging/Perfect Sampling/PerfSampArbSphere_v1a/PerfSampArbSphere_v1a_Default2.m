%=========================================================
% 
%=========================================================

function [default] = PerfSampArbSphere_v1a_Default2(SCRPTPATHS)

fov = 220;
diam = 5;

m = 1;
default{m,1}.entrytype = 'StatInput';
default{m,1}.labelstr = 'Imp_Name';
default{m,1}.entrystr = '';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'FoV (mm)';
default{m,1}.entrystr = fov;

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'Diam (vox)';
default{m,1}.entrystr = diam;

m = m+1;
default{m,1}.entrytype = 'RunScrptFunc';
default{m,1}.scrpttype = 'CreateSampArr';
default{m,1}.labelstr = 'CreateSampArr';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Sample';
