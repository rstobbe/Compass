%=========================================================
% 
%=========================================================

function [default] = StabilityCheck_v1a_Default2(SCRPTPATHS)

m = 1;
default{m,1}.entrytype = 'Choose';
default{m,1}.labelstr = 'Type';
default{m,1}.entrystr = 'Abs';
default{m,1}.options = {'Abs','Phase','Real','Imag'};

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'SliceNum';
default{m,1}.entrystr = '10';
