%=========================================================
% 
%=========================================================

function [default] = CAccMeth3b_v1b_Default2(SCRPTPATHS)

m = 1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'MaxJrk';
default{m,1}.entrystr = '3e5';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'MaxAcc';
default{m,1}.entrystr = '6800';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'Acc0';
default{m,1}.entrystr = '3500';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'AccRamp';
default{m,1}.entrystr = '3e4';