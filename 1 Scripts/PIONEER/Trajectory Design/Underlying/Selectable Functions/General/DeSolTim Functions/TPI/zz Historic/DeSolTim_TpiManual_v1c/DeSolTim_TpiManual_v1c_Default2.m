%=========================================================
% 
%=========================================================

function [default] = DeSolTim_TpiManual_v1c_Default2(SCRPTPATHS)

m = 1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'Nin';
default{m,1}.entrystr = '200';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'Nout';
default{m,1}.entrystr = '300';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'TransPrm';
default{m,1}.entrystr = '15';
