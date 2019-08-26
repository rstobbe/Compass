%=========================================================
% 
%=========================================================

function [default] = ShimFiguresAll_v1a_Default2(SCRPTPATHS)

m = 1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'DispFull (Hz)';
default{m,1}.entrystr = 'Full';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'HistStepFull (Hz)';
default{m,1}.entrystr = 2;

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'DispMask (Hz)';
default{m,1}.entrystr = 'Full';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'HistStepMask (Hz)';
default{m,1}.entrystr = 1;
