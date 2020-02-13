%====================================================
%
%====================================================

function [default] = IncreaseFoV_v1a_Default2(SCRPTPATHS)

m = 1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'NewFoV (TB,LR,IO)';
default{m,1}.entrystr = '280,280,280';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'MatOffset (TB,LR,IO)';
default{m,1}.entrystr = '0,0,0';

