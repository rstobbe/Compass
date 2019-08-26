%=========================================================
% 
%=========================================================

function [default] = TrajSamp_LRideal_v1b_Default2(SCRPTPATHS)

StartFrac = 0;
OverSamp = 1.0;

m = 1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'StartFrac';
default{m,1}.entrystr = StartFrac;

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'OverSamp';
default{m,1}.entrystr = OverSamp;