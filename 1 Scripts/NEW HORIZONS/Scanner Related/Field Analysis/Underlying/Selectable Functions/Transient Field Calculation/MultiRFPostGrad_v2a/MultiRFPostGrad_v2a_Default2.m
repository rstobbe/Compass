%====================================================
%
%====================================================

function [default] = MultiRFPostGrad_v2a_Default2(SCRPTPATHS)

m = 1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'Gstart (ms)';
default{m,1}.entrystr = '1';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'Gstop (ms)';
default{m,1}.entrystr = '30';

m = m+1;
default{m,1}.entrytype = 'Choose';
default{m,1}.labelstr = 'Timing Start';
default{m,1}.entrystr = 'Middle of Fall';
default{m,1}.options = {'Middle of Fall','End of Gradient'};


