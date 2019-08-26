%====================================================
%
%====================================================

function [default] = TrajOrder_SubSetAverage_v1a_Default2(SCRPTPATHS)

m = 1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'SubSetSize';
default{m,1}.entrystr = 65;

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'Averages';
default{m,1}.entrystr = 10;