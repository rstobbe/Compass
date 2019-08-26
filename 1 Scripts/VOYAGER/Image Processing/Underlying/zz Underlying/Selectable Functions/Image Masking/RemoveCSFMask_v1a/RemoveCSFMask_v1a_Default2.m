%=========================================================
% 
%=========================================================

function [default] = RemoveCSFMask_v1a_Default2(SCRPTPATHS)

m = 1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'Threshold';
default{m,1}.entrystr = '0.05';

m = m+1;
default{m,1}.entrytype = 'Choose';
default{m,1}.labelstr = 'Direction';
default{m,1}.entrystr = 'Positive';
default{m,1}.options = {'Positive','Negative'};

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'MaskExpand (mat)';
default{m,1}.entrystr = '1';


