%=========================================================
% 
%=========================================================

function [default] = ExportImageNII_v1c_Default2(SCRPTPATHS)

m = 1;
default{m,1}.entrytype = 'Choose';
default{m,1}.labelstr = 'MultipleVols';
default{m,1}.entrystr = '0';
default{m,1}.options = {'1','0'};

m = m+1;
default{m,1}.entrytype = 'Choose';
default{m,1}.labelstr = 'DataType';
default{m,1}.entrystr = 'int16';
default{m,1}.options = {'int16','double','single'};



