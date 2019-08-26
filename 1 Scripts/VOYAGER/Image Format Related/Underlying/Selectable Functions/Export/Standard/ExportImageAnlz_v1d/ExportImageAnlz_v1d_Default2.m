%=========================================================
% 
%=========================================================

function [default] = ExportImageAnlz_v1c_Default2(SCRPTPATHS)

m = 1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'SubSet (a:b)';
default{m,1}.entrystr = '1:1000';

m = m+1;
default{m,1}.entrytype = 'Choose';
default{m,1}.labelstr = 'Type';
default{m,1}.entrystr = 'Abs';
default{m,1}.options = {'Abs','Real','Imaginary'};