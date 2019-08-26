%=========================================================
% 
%=========================================================

function [default] = TrajSamp_LRstandard_v3f_Default2(SCRPTPATHS)

RelFiltBW = 1.0;
RelSamp2Filt = 1.5;
StartFrac = 0.5;

m = 1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'RelFiltBW';
default{m,1}.entrystr = RelFiltBW;

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'RelSamp2Filt';
default{m,1}.entrystr = RelSamp2Filt;

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'StartFrac';
default{m,1}.entrystr = StartFrac;

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'SampBase (ns)';
default{m,1}.entrystr = '25';