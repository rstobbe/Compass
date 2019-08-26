%=========================================================
% 
%=========================================================

function [default] = SigDec_ArbBiex_v1a_Default2(SCRPTPATHS)

m = 1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'T2f (ms)';
default{m,1}.entrystr = '2.0';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'pT2f (%)';
default{m,1}.entrystr = '22';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'T2s (ms)';
default{m,1}.entrystr = '15.8';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'pT2s (%)';
default{m,1}.entrystr = '78';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'TE';
default{m,1}.entrystr = '0.106';
