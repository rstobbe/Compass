%=========================================================
% 
%=========================================================

function [default] = FirSysModelSiemens_BP30301501_v1c_Default2(SCRPTPATHS)

m = 1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'FilterLength';
default{m,1}.entrystr = '300';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'DelayGradient (us)';
default{m,1}.entrystr = '30';
