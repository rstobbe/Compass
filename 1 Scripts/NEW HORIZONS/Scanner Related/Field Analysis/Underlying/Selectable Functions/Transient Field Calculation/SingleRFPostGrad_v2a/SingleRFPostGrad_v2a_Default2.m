%====================================================
%
%====================================================

function [default] = SingleRFPostGrad_v1c_Default2(SCRPTPATHS)

m = 1;
default{m,1}.entrytype = 'Choose';
default{m,1}.labelstr = 'Timing Start';
default{m,1}.entrystr = 'Middle of Fall';
default{m,1}.options = {'Middle of Fall','End of Gradient'};
