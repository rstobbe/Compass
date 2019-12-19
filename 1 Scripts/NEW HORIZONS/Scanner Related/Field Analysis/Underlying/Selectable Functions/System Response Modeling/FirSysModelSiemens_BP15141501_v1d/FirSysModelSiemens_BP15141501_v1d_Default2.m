%=========================================================
% 
%=========================================================

function [default] = FirSysModelSiemens_BP15141501_v1d_Default2(SCRPTPATHS)

m = 1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'FilterLength';
default{m,1}.entrystr = '300';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'DelayGradient (us)';
default{m,1}.entrystr = '30';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'MinGradInReg';
default{m,1}.entrystr = '1';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'MaxGradInReg';
default{m,1}.entrystr = '10';

