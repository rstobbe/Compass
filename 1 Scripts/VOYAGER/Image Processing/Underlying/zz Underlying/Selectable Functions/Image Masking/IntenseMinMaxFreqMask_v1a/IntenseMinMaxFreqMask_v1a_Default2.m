%=========================================================
% 
%=========================================================

function [default] = MinMaxFreqMask_v1a_Default2(SCRPTPATHS)

m = 1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'AbsThresh (rel)';
default{m,1}.entrystr = '0.3';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'MinFreq (Hz)';
default{m,1}.entrystr = '-40';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'MaxFreq (Hz)';
default{m,1}.entrystr = '55';
