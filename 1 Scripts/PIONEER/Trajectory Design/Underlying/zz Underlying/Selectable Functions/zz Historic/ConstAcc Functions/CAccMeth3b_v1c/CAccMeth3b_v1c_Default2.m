%=========================================================
% 
%=========================================================

function [default] = CAccMeth3b_v1c_Default2(SCRPTPATHS)

m = 1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'MaxJrk';
default{m,1}.entrystr = '3.0e5';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'MaxAcc';
default{m,1}.entrystr = '6500';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'Acc0';
default{m,1}.entrystr = '2000';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'AccRamp';
default{m,1}.entrystr = '3.5e4';