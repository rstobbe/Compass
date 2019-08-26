%=========================================================
% 
%=========================================================

function [default] = CJerkMeth2_v4a_Default2(SCRPTPATHS)

m = 1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'ExpTc1 (ms)';
default{m,1}.entrystr = '0.00004';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'ExpRelVal1';
default{m,1}.entrystr = '50';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'ExpTc2 (ms)';
default{m,1}.entrystr = '0.0004';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'ExpRelVal2';
default{m,1}.entrystr = '30';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'ExpTc3 (ms)';
default{m,1}.entrystr = '0.004';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'ExpRelVal3';
default{m,1}.entrystr = '10';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'ExpTc4 (ms)';
default{m,1}.entrystr = '0.1';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'ExpRelVal4';
default{m,1}.entrystr = '2';