%=========================================================
% 
%=========================================================

function [default] = B0_MonoExpManual_v1a_Default2(SCRPTPATHS)

m = 1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'B0 val (uT)';
default{m,1}.entrystr = '1';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'tc (ms)';
default{m,1}.entrystr = '100';

m = m+1;
default{m,1}.entrytype = 'RunScrptFunc';
default{m,1}.labelstr = 'B0_MonoExp';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Reg';

