%=========================================================
% 
%=========================================================

function [default] = TPI_wfmTSRAlinear_v1a_Default2(SCRPTPATHS)

m = 1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'SRASR (mT/m/ms)';
default{m,1}.entrystr = '120';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'Ginit (mT/m)';
default{m,1}.entrystr = '30';
