%====================================================
%
%====================================================

function [default] = RcvComb_SuperAdd_v1c_Default2(SCRPTPATHS)

m = 1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'RxProfFromExp';
default{m,1}.entrystr = '1';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'RxProfRes (mm)';
default{m,1}.entrystr = '10';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'RxProfFilt (beta)';
default{m,1}.entrystr = '12';