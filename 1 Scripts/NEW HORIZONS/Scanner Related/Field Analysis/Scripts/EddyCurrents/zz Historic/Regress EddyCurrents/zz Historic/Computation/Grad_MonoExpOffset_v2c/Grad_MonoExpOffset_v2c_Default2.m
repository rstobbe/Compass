%=========================================================
% 
%=========================================================

function [default] = Grad_MonoExpOffset_v2c_Default2(SCRPTPATHS)

m = 1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'data_start (ms)';
default{m,1}.entrystr = '0';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'data_stop (ms)';
default{m,1}.entrystr = '100';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'time_after_grad (ms)';
default{m,1}.entrystr = '0';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'Offset (uT/m)';
default{m,1}.entrystr = '0';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'estimate (ms)';
default{m,1}.entrystr = '0';

m = m+1;
default{m,1}.entrytype = 'RunScrptFunc';
default{m,1}.labelstr = 'Grad_MonoExp';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Reg';