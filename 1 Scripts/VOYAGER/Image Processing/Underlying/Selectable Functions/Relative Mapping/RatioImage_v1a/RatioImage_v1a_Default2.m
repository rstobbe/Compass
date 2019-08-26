%====================================================
%
%====================================================

function [default] = RatioImage_v1a_Default2(SCRPTPATHS)

m = 1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'Mask (relval)';
default{m,1}.entrystr = '0.1';

m = m+1;
default{m,1}.entrytype = 'Choose';
default{m,1}.labelstr = 'Dir';
default{m,1}.entrystr = '1/2';
default{m,1}.options = {'1/2','2/1'};

m = m+1;
default{m,1}.entrytype = 'Choose';
default{m,1}.labelstr = 'Type';
default{m,1}.entrystr = 'abs';
default{m,1}.options = {'abs','complex'};