%=========================================================
% 
%=========================================================

function [default] = DefLocalComp_v1a_Default2(SCRPTPATHS)

m = 1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'Comp_Name';
default{m,1}.entrystr = '';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'gcoil';
default{m,1}.entrystr = 'Mar2013_noVSL';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'xgraddel (us)';
default{m,1}.entrystr = '35';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'ygraddel (us)';
default{m,1}.entrystr = '35';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'zgraddel (us)';
default{m,1}.entrystr = '35';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'xTc (ms)';
default{m,1}.entrystr = '';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'xMag (%)';
default{m,1}.entrystr = '';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'yTc (ms)';
default{m,1}.entrystr = '';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'yMag (%)';
default{m,1}.entrystr = '';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'zTc (ms)';
default{m,1}.entrystr = '';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'zMag (%)';
default{m,1}.entrystr = '';

m = m+1;
default{m,1}.entrytype = 'RunScrptFunc';
default{m,1}.scrpttype = 'Save';
default{m,1}.labelstr = 'Save';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Save';

