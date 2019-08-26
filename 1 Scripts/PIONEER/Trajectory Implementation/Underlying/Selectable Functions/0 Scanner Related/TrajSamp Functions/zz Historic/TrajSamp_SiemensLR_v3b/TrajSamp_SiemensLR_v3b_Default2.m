%=========================================================
% 
%=========================================================

function [default] = TrajSamp_SiemensLR_v3b_Default2(SCRPTPATHS)

RelOverSamp = 1.25;
startsteps = 2;

m = 1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'RelOverSamp';
default{m,1}.entrystr = RelOverSamp;

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'Discard (pts)';
default{m,1}.entrystr = startsteps;

