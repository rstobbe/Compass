%=========================================================
% 
%=========================================================

function [default] = TrajSamp_Ideal_v1a_Default2(SCRPTPATHS)

StartFrac = 0.5;
OverSamp = 1.2;

m = 1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'StartFrac';
default{m,1}.entrystr = StartFrac;

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'OverSamp';
default{m,1}.entrystr = OverSamp;