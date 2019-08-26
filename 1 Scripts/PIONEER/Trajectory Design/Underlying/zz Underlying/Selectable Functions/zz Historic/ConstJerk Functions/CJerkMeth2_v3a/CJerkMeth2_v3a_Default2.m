%=========================================================
% 
%=========================================================

function [default] = CJerkMeth2_v3a_Default2(SCRPTPATHS)

m = 1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'ExpTc1 (ms)';
default{m,1}.entrystr = '0.0003';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'ExpRelVal1';
default{m,1}.entrystr = '5';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'ExpTc2 (ms)';
default{m,1}.entrystr = '0.003';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'ExpRelVal2';
default{m,1}.entrystr = '10';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'ExpTc3 (ms)';
default{m,1}.entrystr = '0.1';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'ExpRelVal3';
default{m,1}.entrystr = '2';
