%====================================================
%
%====================================================

function [default] = PosBgrndSiemens_v3e_Default2(SCRPTPATHS)

m = 1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'PLstart (ms)';
default{m,1}.entrystr = '0.4';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'PLstop (ms)';
default{m,1}.entrystr = '1.2';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'BGstart (ms)';
default{m,1}.entrystr = '0.1';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'BGstop (ms)';
default{m,1}.entrystr = 'end';

