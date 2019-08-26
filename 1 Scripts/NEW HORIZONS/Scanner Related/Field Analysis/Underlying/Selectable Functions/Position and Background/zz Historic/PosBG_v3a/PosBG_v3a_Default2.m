%====================================================
%
%====================================================

function [default] = PosBG_v3a_Default2(SCRPTPATHS)

m = 1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'PLstart (ms)';
default{m,1}.entrystr = '0.1';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'PLstop (ms)';
default{m,1}.entrystr = '1.0';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'BGstart (ms)';
default{m,1}.entrystr = '4';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'BGstop (ms)';
default{m,1}.entrystr = '30';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'SmoothWinBG';
default{m,1}.entrystr = '15';



