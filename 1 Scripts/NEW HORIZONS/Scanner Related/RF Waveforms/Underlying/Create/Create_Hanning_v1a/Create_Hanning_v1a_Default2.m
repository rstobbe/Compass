%====================================================
%
%====================================================

function [default] = Create_Hanning_v1a_Default2(SCRPTPATHS)

m = 1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'Lobes';
default{m,1}.entrystr = '3';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'Flip (forSim)';
default{m,1}.entrystr = '10';



