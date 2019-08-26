%=========================================================
% 
%=========================================================

function [default] = DefLocalECC_v1a_Default2(SCRPTPATHS)

m = 1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'LECC_Name';
default{m,1}.entrystr = '';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'gcoil';
default{m,1}.entrystr = 'Mar2013_noVSL';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'graddel (us)';
default{m,1}.entrystr = '21';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'Tc (ms)';
default{m,1}.entrystr = '0.06';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'Mag (%)';
default{m,1}.entrystr = '10';

m = m+1;
default{m,1}.entrytype = 'RunScrptFunc';
default{m,1}.scrpttype = 'Save';
default{m,1}.labelstr = 'Save';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Save';

