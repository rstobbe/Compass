%=========================================================
% 
%=========================================================

function [default] = FixedBox_v1a_Default2(SCRPTPATHS)

m = 1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'FoV (mm)';
default{m,1}.entrystr = '30';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'x (mm)';
default{m,1}.entrystr = '15';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'y (mm)';
default{m,1}.entrystr = '15';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'z (mm)';
default{m,1}.entrystr = '2';

