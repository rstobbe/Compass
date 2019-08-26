%=========================================================
% 
%=========================================================

function [default] = IntenseFreqMap_v1a_Default2(SCRPTPATHS)

m = 1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'AbsThresh (rel)';
default{m,1}.entrystr = '0.05';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'FreqThresh (Hz)';
default{m,1}.entrystr = '200';

