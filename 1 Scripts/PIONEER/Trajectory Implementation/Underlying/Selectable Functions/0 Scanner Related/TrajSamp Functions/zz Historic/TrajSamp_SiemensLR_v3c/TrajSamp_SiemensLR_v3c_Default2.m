%=========================================================
% 
%=========================================================

function [default] = TrajSamp_SiemensLR_v3c_Default2(SCRPTPATHS)

m = 1;
default{m,1}.entrytype = 'Choose';
default{m,1}.labelstr = 'RelOverSamp';
default{m,1}.entrystr = '1.25';
default{m,1}.options = {'2','1.6','1.25'};

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'Discard (pts)';
default{m,1}.entrystr = '0';

