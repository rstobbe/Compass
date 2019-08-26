%=========================================================
% 
%=========================================================

function [default] = TF_Kaiser_v1c_Default2(SCRPTPATHS)

m = 1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'Beta';
default{m,1}.entrystr = '4';

m = m+1;
default{m,1}.entrytype = 'Choose';
default{m,1}.labelstr = 'Weighting';
default{m,1}.entrystr = 'TPI';
default{m,1}.options = {'TPI','OneAtCen','OneAtEnd'};

m = m+1;
default{m,1}.entrytype = 'Choose';
default{m,1}.labelstr = 'Output';
default{m,1}.entrystr = 'Array';
default{m,1}.options = {'Array','Function'};