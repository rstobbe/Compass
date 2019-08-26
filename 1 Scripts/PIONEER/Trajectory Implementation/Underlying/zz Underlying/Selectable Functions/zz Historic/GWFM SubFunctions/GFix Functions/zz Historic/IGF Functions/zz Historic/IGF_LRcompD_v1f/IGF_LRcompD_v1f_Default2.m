%====================================================
%
%====================================================

function [default] = IGF_LRcomp1_v1a_Default2(SCRPTPATHS)

m = 1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'GAccMx (mT/m/ms2)';
default{m,1}.entrystr = '20';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'GVelMx (mT/m/ms)';
default{m,1}.entrystr = '160';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'GCompStpMx (mT/m)';
default{m,1}.entrystr = '0.1';
