%=========================================================
% 
%=========================================================

function [default] = CNRopt_SpoiledSS_v1a_Default2(SCRPTPATHS)

m = 1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'Sim_Name';
default{m,1}.entrystr = '';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'T1_A (ms)';
default{m,1}.entrystr = '2000';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'T1_B (ms)';
default{m,1}.entrystr = '1200';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'TR (ms)';
default{m,1}.entrystr = '50:1:60';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'flip (deg)';
default{m,1}.entrystr = '15:5:30';

m = m+1;
default{m,1}.entrytype = 'RunScrptFunc';
default{m,1}.scrpttype = 'Run';
default{m,1}.labelstr = 'Run';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Run';
