%=========================================================
% 
%=========================================================

function [default] = TF_Uniform_v1a_Default2(~)

m = 1;
default{m,1}.entrytype = 'Choose';
default{m,1}.labelstr = 'Weighting';
default{m,1}.entrystr = 'TPI';
default{m,1}.options = {'TPI','OneAtEnd'};

m = m+1;
default{m,1}.entrytype = 'Choose';
default{m,1}.labelstr = 'Output';
default{m,1}.entrystr = 'Array';
default{m,1}.options = {'Array','Function'};
